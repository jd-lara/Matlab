clear all
clear losseqs.m pfloweqs_nnc.m
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.92; s=tan(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);
bldnncpfloweqs_m(S);
bldr_nnc_m2(S);
%ws_m; hold on
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
lb(2*S.Bus.n+1:end)=0.012;

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi/2;
end
ub(2*S.Bus.n+1:end)=0.12;

% Weights for the restrictions 
W=[]; n=1;
for k = 0:0.1:1;
    W(n,1)=k; 
    W(n,2)=1-k; 
   n=n+1;
end

p_surface=zeros(numel(W(:,1)),3);
%equations for the optimization problem 
fl = @(x)((losseqs(x,S)-6.525262e-02)/2.430309e-01);

tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nnc  = @(x)r_nnc_m2(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nnc,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';
%p_surface(k,:)=[losseqs(x(1:10),S), -1*x(11), -1*x(12)];
if flag == -2
plot((-1*x(11)-1*x(12)-1*(-2.400000e-01))/1.070007e-01,(losseqs(x(1:10),S)-6.773353e-02)/2.405500e-01 ,'*', 'Color', [0.5 0 0.5]);    
%plot((-1*x(11)-1*x(12)),losseqs(x(1:10),S) ,'+', 'Color', [0.5 0 0.5]);
else
plot((-1*x(11)-1*x(12)-1*(-2.400000e-01))/1.081979e-01,(losseqs(x,S)-6.525262e-02)/2.430309e-01 ,'*r');
%plot((-1*x(11)-1*x(12)),losseqs(x(1:10),S),'+r');
end
hold on 
  
  k

sal(k)=flag;

end
toc

xlabel('Maximizacion de la generacion total')
ylabel('Minimizacion de las perdidas')

