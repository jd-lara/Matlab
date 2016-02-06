%clear all
S=readcf('base2.cf'); load Curva_demanda.mat
S.Bus.Load(2,1)=1.0*S.Bus.Load(2,1);
S.Bus.Load(4,1)=1.0*S.Bus.Load(4,1);
S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
S.Bus.Load(5,1)=1.0*S.Bus.Load(5,1);
pf=0.92;
s=sin(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
%initial conditions 
x0=0.03*ones(3,1);

dispatch=zeros(2,96);
losses_km=zeros(1,96); kp=1.2;
demanda_total=zeros(1,96);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=zeros(2,1);
ub(2:3,1)=0.1*ones(2,1);

L2=S.Bus.Load(2,1);
L4=S.Bus.Load(4,1);
L3=S.Bus.Load(3,1);
L5=S.Bus.Load(5,1);

tic
for n=1:96
S.Bus.Load(2,1)=curva_demanda(n,1)*kp*L2;
S.Bus.Load(4,1)=curva_demanda(n,1)*kp*L4;
S.Bus.Load(3,1)=curva_demanda(n,1)*kp*L3;
S.Bus.Load(5,1)=curva_demanda(n,1)*kp*L5;
demanda_total(n)=sum(real(S.Bus.Load))*50;

fl=@(x)losses_approx(x,S);
r=@(x)pbalance(x,S);

[x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off','Algorithm','sqp','Diagnostics','off','MaxFunEvals',10000)));

dispatch_e(:,n)=x(2:3)*50;       
losses_km(n)=fval;


S.Bus.Generation(4,1)=x(2)+1i*s*x(2);
S.Bus.Generation(5,1)=x(3)+1i*s*x(3);
S=pflow(S);

volt_lim(n)=max(S.Bus.Voltages);
losses_kme(n)=losses_exact(S);
horas(n)=1+(n-1)*1/4;

end
toc

[AX,H1,H2]=plotyy(1+horas,losses_km,horas,demanda_total);
set(AX, 'XLim', [1 24]);
set(AX(1), 'YLim', [0 0.2]); 
set(AX(2), 'YLim', [0 12]);
  hold on; 
  plot(1+horas,losses_kme,'k')
axes(AX(1)); ylabel('Perdidas [MW]');
axes(AX(2)); ylabel('Demanda [MW]');
%  for n= 1:96
%     if volt_lim(n) > 1.05 && volt_lim(n) <0.95
%     plot(horas(n),demanda_total(n),'r')
%     end
%  end
%  total_loss_e=sum(losses_kme)*0.25;

figure
plot(1+horas,dispatch_e,'.')
hold on 
plot(1+horas,dispatch_m)
xaxis=[1 24];