clear all
clear losseqs.m r_nbi_e.m
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.92; s=tan(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);
bldr_nnc_e2(S);
%ws_e; hold on

%Initial conditions for the optimization problem
%initial conditions 
x0=0.08*ones(4,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=0.012*ones(2,1);
ub(2:3,1)=0.12*ones(2,1);

% Weights for the restrictions 
% Weights for the restrictions 
w1=0:0.1:1;
w2=0:0.1:1;
Wx=allcomb(w1,w2);
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
fl = @(x)((losses_approx(x,S)-6.641584e-02)/2.751662e-01);

tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nnc  = @(x)r_nnc_e2(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nnc,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';
% plot(-1*x(2)-1*x(3),...
%       losses_approx(x,S),'xr');
plot((-1*x(2)-1*x(3)-1*(-2.400000e-01))/1.094455e-01,...
      (losses_approx(x,S)-6.641584e-02)/2.751662e-01,'*r');

hold on 
k

%sal(k)=flag;
end
toc

xlabel('Maximizacion de la generacion total')
ylabel('Minimizacion de las perdidas')


