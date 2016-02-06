clear all
clear losseqs.m pfloweqs_l.m
clc; 
load Curva_demanda.mat
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
dispatch=zeros(2,96);
losses_km=[]; kp=1.2;
S=bldybus(S); 
bldpfloweqs(S)
bldpfloweqs_l(S)
bldlosseqs(S)
S=pflow(S);
pf=0.92;
s=sin(acos(pf));
%initial conditions set

x0=0.09*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);

%Function for reading the initial conditions of the Power Flow from the structure 

%Initial Conditions for Slack Bus

for k= S.Bus.SlackList
    x0(k)= real(S.Bus.Generation(S.Bus.SlackList));
    x0(k+1)=imag(S.Bus.Generation(S.Bus.SlackList));
end
 
%Initial conditions for PQ Buses 

for k = S.Bus.PQList
    
    x0(2*k -1) = S.Bus.Voltages(k);
    x0(2*k) = S.Bus.Angles(k)/(180/pi);
end

%Initial conditions for PV Buses 

for k = S.Bus.PVList
    
    x0(2*k -1) = imag(S.Bus.Load(k))-imag(S.Bus.Generation(k));
    x0(2*k)=S.Bus.Angles(k)/(180/pi);
end  


% losseqs(x0,S)
% losses_exact(S)

% Lower and upper boundaries declaration

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi/2;
end
lb(2*S.Bus.n+1:end)=0;

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.1;
ub(k+1)=pi/2;
end
ub(2*S.Bus.n+1:end)=0.11;

fl = @(x)(losseqs(x,S));
r = @(x)pfloweqs_l(x,S);

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
%plot(n,sum(real(S.Bus.Load(1:5,1))));

fl = @(x)(losseqs(x,S));
r = @(x)pfloweqs_l(x,S);

[x,fval] = fmincon(fl,x0,[],[],[],[],lb,ub,r,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',10000)));

dispatch_m(:,n)=x(11:12)*50;
       
losses_km(n)=fval;
%plot(n,x(11:12)*50,n,fval); hold on

%Write results into the structure. 

% S.Bus.Generation(4,1)=x(11)+1j*s*x(11);
% S.Bus.Generation(5,1)=x(12)+1j*s*x(12);
% 
% S=bldybus(S); 
% bldpfloweqs(S)
% S=pflow(S);
% 
% S.Bus.Voltages
horas(n)=1+(n-1)*1/4;
end 
toc

[AX,H1,H2]=plotyy(horas,demanda_total,horas,losses_km);
set(AX, 'XLim', [1 24]);
set(AX(1), 'YLim', [0 12]);
set(AX(2), 'YLim', [0 0.2]); hold on; 
total_loss_m=sum(losses_km)*0.25