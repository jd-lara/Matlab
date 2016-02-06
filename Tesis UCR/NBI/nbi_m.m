clear all
clear losseqs.m pfloweqs_nbi.m r_nbi.m
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.92; s=tan(acos(pf));
% S.Bus.Load(2,1)=0.9*S.Bus.Load(4,1);
% S.Bus.Load(4,1)=0.7*S.Bus.Load(4,1);
% S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
% S.Bus.Load(5,1)=1.1*S.Bus.Load(5,1);
S=bldybus(S); 
bldpfloweqs(S)
bldnbipfloweqs_m(S);
% ws_m, hold on 
bldr_nbi_m(S);
S=pflow(S);

%Initial conditions for the optimization problem
x0=0.001*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);

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

x0=[x0;1];

% Lower and upper boundaries declaration for fmincon

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi/2;
end
lb(2*S.Bus.n+1:end)=0.012;
lb=[lb;-99];

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi/2;
end
ub(2*S.Bus.n+1:end)=0.12;
ub=[ub;99];

% Weights for the restrictions 
w1=0:0.05:1;
w2=0:0.05:1;
w3=0:0.05:1;
Wx=allcomb(w1,w2,w3);
n=1; W=[];
for k = 1:numel(Wx(:,1));
if sum(Wx(k,:)) == 1
    W(n,:)=Wx(k,:); 
    n=n+1;
end
end
clear Wx;
p_surface=zeros(numel(W(:,1)),3);
%equations for the optimization problem 
fl = @(x)(-1*x(13));

tic
for k = 1:numel(W(:,1))

    k
    Wx=W(k,:);
    r_nbi  = @(x)r_nbi_m(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nbi,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';       
%p_surface(k,:)=[losseqs(x(1:10),S), -1*x(11), -1*x(12)];
if flag == -2
plot3(-1*x(11),-1*x(12),losseqs(x(1:10),S),'*', 'Color', [0.5 0 0.5]); hold on
else
plot3(-1*x(11),-1*x(12),losseqs(x(1:10),S) ,'*r');   
end

%plot3(-1*x(11),-1*x(12),losseqs(x(1:10),S),'*r');  
sal(k)=flag;
end
toc

grid




