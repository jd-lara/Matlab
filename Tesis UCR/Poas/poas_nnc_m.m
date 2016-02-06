clear all
clear losseqs.m pfloweqs_nnc.m
S=readcf('Poasg.cf'); %This Function ONLY reads the information stored on the *cf file 
S.Bus.Load=S.Bus.Load*0.8;
pf=0.95; s=tan(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
bldnncpfloweqs_m(S);
bldr_nnc_mp(S);
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

% Lower and upper boundaries declaration for fmincon

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi/2;
end

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi/2;
end

lb(79:81,1)=S.Machine.MW(2:4,1)/50;
ub(79:81,1)=S.Machine.MW(2:4,1)/50;
lb(82:83,1)=0.01*ones(2,1);
ub(82,1)=S.Machine.MW(5,1)/50;
ub(83,1)=S.Machine.MW(6,1)/50;

% Weights for the restrictions 
W=[]; n=1;
for k = 0:0.01:1;
    W(n,1)=k; 
    W(n,2)=1-k; 
   n=n+1;
end

%equations for the optimization problem 
fl = @(x)((losseqs(x,S)-1.966178e-02)/7.354005e-02);

tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nnc  = @(x)r_nnc_mp(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nnc,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';
if flag == -2
%plot((-1*x(82)-1*x(83)-1*(-1.050000e-01))/7.099438e-02, (losseqs(x(1:78),S)-1.966178e-02)/7.354005e-02 ,'*', 'Color', [0.5 0 0.5]);    
plot((-1*x(82)-1*x(83)),losseqs(x(1:78),S) ,'*', 'Color', [0.5 0 0.5]);
else
%plot((-1*x(82)-1*x(83)-1*(-1.050000e-01))/7.099438e-02, (losseqs(x(1:78),S)-1.966178e-02)/7.354005e-02 ,'*r');
plot((-1*x(82)-1*x(83)),losseqs(x(1:78),S),'og');
xp(k)=(-1*x(82)-1*x(83));
yp(k)=(losses_exact(S));
end
hold on

sal(k)=flag;

end
toc

figure
plot(xp,yp,'.-b');

 grid
 xlabel('Maximizacion de la generacion total')
 ylabel('Minimizacion de las perdidas')

