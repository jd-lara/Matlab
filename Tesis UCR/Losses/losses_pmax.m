%clear all
clc; 
load Curva_demanda.mat
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
losses_total=[]; kp=1.2;
S=bldybus(S); 
bldpfloweqs(S)
pf=0.92;
s=sin(acos(pf));

L2=S.Bus.Load(2,1);
L4=S.Bus.Load(4,1);
L3=S.Bus.Load(3,1);
L5=S.Bus.Load(5,1);

for n=1:96
S.Bus.Load(2,1)=curva_demanda(n,1)*kp*L2;
S.Bus.Load(4,1)=curva_demanda(n,1)*kp*L4;
S.Bus.Load(3,1)=curva_demanda(n,1)*kp*L3;
S.Bus.Load(5,1)=curva_demanda(n,1)*kp*L5;
demanda_total(n)=sum(real(S.Bus.Load))*50;

S=pflow(S);
Pslack=real(S.Bus.Generation(1,1));
losses_kmep(n)=losses_exact(S);
losses_kmp(n)=losses_approx([Pslack,0.12,0.12],S);
volt_lim(n)=max(S.Bus.Voltages);

horas(n)=1+(n-1)*1/4;
end

plot(horas,losses_kmep,horas,losses_kmp);
total_loss_pmax=sum(losses_kme)*0.25
figure
plot(horas,volt_lim);


[AX,H1,H2]=plotyy(horas,losses_kmep,horas,demanda_total);
set(AX, 'XLim', [1 24]);
set(AX(1), 'YLim', [0 0.9]); 
set(AX(2), 'YLim', [0 12]);
  hold on; 
  plot(horas,losses_kmp,'--b')
  plot(horas,losses_kme,'k')
  plot(horas,losses_km,'r')
axes(AX(1)); ylabel('Perdidas [MW]');
axes(AX(2)); ylabel('Demanda [MW]');

