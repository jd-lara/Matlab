clear all ; %close all
%clear losseqs.m pfloweqs_l.m
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
S.Bus.Load(2,1)=1.0*S.Bus.Load(2,1);
S.Bus.Load(4,1)=1.0*S.Bus.Load(4,1);
S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
S.Bus.Load(5,1)=1.0*S.Bus.Load(5,1);
S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);
pf=0.92;
s=tan(acos(pf));
%initial conditions set 

x0=0.0*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);

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
lb(2*S.Bus.n+1:end)=0.012;

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi;
end
ub(2*S.Bus.n+1:end)=0.12;

% % Weights 
% w1=0:0.05:1;
% w2=0:0.05:1;
% w3=0:0.05:1;
% Wx=allcomb(w1,w2,w3);
% n=1; W=[];
% for k = 1:numel(Wx(:,1));
% if sum(Wx(k,:)) == 1
%     W(n,:)=Wx(k,:); 
%     n=n+1;
% end
% 
% end
% 
% p_surface=zeros(numel(W(:,1)),3);
% volt=zeros(numel(W(:,1)),5);
% tic
% for k = 1:numel(W(:,1));
%     
% fl = @(x)(losseqs(x,S)*W(k,1)-x(11)*W(k,2)-x(12)*W(k,3));
% r = @(x)pfloweqs_l(x,S);
% 
% x = fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off',...
%    'Algorithm','interior-point','Diagnostics','off','MaxFunEvals',10000)));
% 
% %Write results into the structure. 
% 
% S.Bus.Generation(4,1)=x(11)+1j*s*x(11);
% S.Bus.Generation(5,1)=x(12)+1j*s*x(12);
% S=pflow(S);
% 
% U1_1(k)=x(11);
% U2_1(k)=x(12);
% p_surface(k,:)=[losses_exact(S), -1*x(11), -1*x(12)];
% volt(k,:)=(S.Bus.Voltages+0)';
% end
% toc
% figure
% plot3(p_surface(:,2),p_surface(:,3),p_surface(:,1),'*k'); hold on
% xlim = [-0.012 0.12];
% ylim = [-0.012 0.12];
n=1;
tic
for k = 0:0.01:1;
    
fl = @(x)(losseqs(x,S)*(k)-(1-k)*(x(11)+x(12)));
r = @(x)pfloweqs_l(x,S);

x = fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off',...
   'Algorithm','interior-point','Diagnostics','off','MaxFunEvals',10000)));

%Write results into the structure. 

S.Bus.Generation(4,1)=x(11)+1j*s*x(11);
S.Bus.Generation(5,1)=x(12)+1j*s*x(12);
S=pflow(S);

U1_2(n)=x(11);
U2_2(n)=x(12);
p_surface2(n,:)=[-(x(11)+x(12)), losses_exact(S)];
volt(n,:)=(S.Bus.Voltages+0)';
n=n+1;
end
 plot(p_surface2(:,1),p_surface2(:,2),'.k'); grid; hold on
 toc
% %ws_e