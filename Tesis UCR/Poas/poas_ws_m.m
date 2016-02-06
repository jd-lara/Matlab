clear all ; %close all
%clear losseqs.m pfloweqs_l.m
clc
S=readcf('Poasg.cf'); %This Function ONLY reads the information stored on the *cf file 
S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);
S.Bus.Load=S.Bus.Load*0.8;
pf=0.95;
s=tan(acos(pf));
%initial conditions set 

x0=0.01*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);

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

x0(79:81,1)=S.Machine.MW(2:4,1)/50;
x0(79:81,1)=S.Machine.MW(2:4,1)/50;
x0(82:83,1)=0.01*ones(2,1);
x0(82,1)=S.Machine.MW(5,1)/50;
x0(83,1)=S.Machine.MW(6,1)/50;

clear losseqs 
clear pfloweqs_l    
bldpfloweqs_l(S)
bldlosseqs(S)

losseqs(x0,S)
losses_exact(S)

% Lower and upper boundaries declaration

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi;
end

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi;
end

lb(79:81,1)=S.Machine.MW(2:4,1)/50;
ub(79:81,1)=S.Machine.MW(2:4,1)/50;
lb(82:83,1)=0.01*ones(2,1);
ub(82,1)=S.Machine.MW(5,1)/50;
ub(83,1)=S.Machine.MW(6,1)/50;

n=1;
tic
for k = 0:0.01:1;
    
fl = @(x)(losseqs(x,S)*(k)-(1-k)*(x(82)+x(83)));
r = @(x)pfloweqs_l(x,S);

x = fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off',...
   'Algorithm','interior-point','Diagnostics','off','MaxFunEvals',10000)));

%Write results into the structure. 

% S.Bus.Generation(37,1)=x(82)+1j*s*x(82);
% S.Bus.Generation(38,1)=x(83)+1j*s*x(83);
% S=pflow(S);

% U1_2(n)=x(82);
% U2_2(n)=x(83);
p_surface2(n,:)=[-(x(82)+x(83)), losseqs(x,S)];
%volt(n,:)=(S.Bus.Voltages+0)';
n=n+1;
end
 toc
 plot(p_surface2(:,1),p_surface2(:,2),'*k'); grid; hold on
 grid
 xlabel('Maximizacion de la generacion total')
 ylabel('Minimizacion de las perdidas')
%  poas_nbi_m
%  poas_nnc_m