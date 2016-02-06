%Just hit play. 
clear all ; close all;
clc; load Curva_demanda.mat;
S=readcf('Poasg.cf'); %This Function ONLY reads the information stored on the *cf file 
S=bldybus(S); 
pf=0.95;
s=tan(acos(pf));
% L_exact=[]; P=[];
% S.Bus.Load=S.Bus.Load*0.8;
% S.Bus.Generation(37,1)=0.0165+1j*s*0.0165;
% S.Bus.Generation(38,1)=0.0165+1j*s*0.0165;
% S=pflow(S);
% S.Machine.MW(5:6)=0.0165*50;
% x=S.Machine.MW/50
% S.Bus.Generation
% %S.Bus.Voltages
% [losses,L_k]=losses_exact(S)
% losses_approx2(x,S)

%Exact Losses minimization 

%initial conditions set

x0=0.09*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
x0=[x0;1];

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

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi/2;
end

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.1;
ub(k+1)=pi/2;
end

lb(79:81,1)=S.Machine.MW(2:4,1)/50;
ub(79:81,1)=S.Machine.MW(2:4,1)/50;
lb(82:83,1)=0.01*ones(2,1);
ub(82,1)=S.Machine.MW(5,1)/50;
ub(83,1)=S.Machine.MW(6,1)/50;

lb=[lb;-99];
ub=[ub;99];

L=S.Bus.Load;

dispatch_mp=zeros(5,96);
losses_km=zeros(1,96); kp=1.2;
demanda_total=zeros(1,96);

tic
for t=1:96
t    
S.Bus.Load=curva_demanda(t,1)*kp*L;
demanda_total(t)=sum(real(S.Bus.Load));

clear r_nbi;
clear r_nbi_mp

S=bldybus(S); 
bldpfloweqs(S)
bldnbipfloweqs_m(S);
bldlosseqs(S);
bldr_nbi_mp(S);

Wx=[5 5];
    
fl = @(x)(-1*x(84));
r_nbi  = @(x)r_nbi_mp(x,S,Wx);

[x_m,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nbi,...
           (optimset('Display','on','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',1000)));

fprintf('opt lista');
res(k,:)=x_m'; 
S.Bus.Generation(37,1)=x_m(82)+1j*s*x_m(82);
S.Bus.Generation(38,1)=x_m(83)+1j*s*x_m(83);
S=pflow(S);
dispatch_mp(:,t)=x_m(79:end)*50;
losses_km(t)= losses_exact(S);

end
toc
%approx losses minimization



lb=-1*ones(6,1); ub=1*ones(6,1);
ub(2:end)=S.Machine.MW(2:6)./(50);
lb(2:end)=0.0*S.Machine.MW(2:6)./(50);

x0=0.0*ones(6,1);

clear t
dispatch_ep=zeros(5,96);
losses_ke=zeros(1,96); kp=1.2;

tic
for t=1:96
t
S.Bus.Load=curva_demanda(t,1)*kp*L;

r=@(x)pbalancep(x,S);
fl=@(x)losses_approx2(x,S);


 
[x_e,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','on','Algorithm','sqp','Diagnostics','off','MaxFunEvals',10000)));
 
dispatch_ep(:,t)=x_e(2:end)*50;
losses_ke(t)=fval;
% losses_ke2(t)=losses_approx2(x_e,S)
end
toc

plot(0:24/96:23.9,dispatch_mp(5,:),'r'); hold on 
plot(0:24/96:23.9,dispatch_mp(4,:),'-.r');
plot(0:24/96:23.9,dispatch_ep(5,:),'k');
plot(0:24/96:23.9,dispatch_ep(4,:),'-.k'); hold off 


dispatch_mp=dispatch_mp';
dispatch_ep=dispatch_ep';
figure
area(0:24/96:23.9,dispatch_ep); 
figure
area(0:24/96:23.9,dispatch_mp)

