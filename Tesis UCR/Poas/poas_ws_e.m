clear all
S=readcf('Poasg.cf');
S=bldybus(S); 
bldpfloweqs(S)
pf=0.95;
S=pflow(S);
S.Bus.Load=S.Bus.Load*0.8;
s=tan(acos(pf));
%initial conditions 
x0=S.Machine.MW/51;

lb=-1*ones(6,1); ub=1*ones(6,1);
lb(2:4,1)=S.Machine.MW(2:4,1)/50;
ub(2:4,1)=S.Machine.MW(2:4,1)/50;
lb(5:6,1)=0.01*ones(2,1);
ub(5,1)=S.Machine.MW(5,1)/50;
ub(6,1)=S.Machine.MW(6,1)/50;

n=1;
tic

for k = 0:0.01:1

fl=@(x)(losses_approx2(x,S)*k-(1-k)*(x(5)+x(6)));
%*k)-((1-k)*(x(5)+x(6))))
r=@(x)pbalancep(x,S);

[x_e,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off','Algorithm','sqp',...
         'Diagnostics','off','MaxFunEvals',10000)));

% fval;     
% res(n,:)=x_e'

%  S.Bus.Generation(37,1)=x_e(5)+1j*s*x_e(5);
%  S.Bus.Generation(38,1)=x_e(6)+1j*s*x_e(6);

p_surface2(n,:)=[-(x_e(5)+x_e(6)),losses_approx2(x_e,S)];
% volt(n,:)=(S.Bus.Voltages+0)';
% S=pflow(S); exact(n,:)=losses_exact(S);
n=n+1;
end
toc
plot(p_surface2(:,1),p_surface2(:,2),'*k'); hold on;

 grid
 xlabel('Maximizacion de la generacion total')
 ylabel('Minimizacion de las perdidas')
