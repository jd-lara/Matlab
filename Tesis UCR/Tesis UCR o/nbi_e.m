clear all
clear losseqs.m r_nbi_e.m
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.92; s=tan(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
bldr_nbi_e(S);
S=pflow(S);

%initial conditions 
x0=0.08*ones(4,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=0.012*ones(2,1);
ub(2:3,1)=0.12*ones(2,1);
lb=[lb;-99];
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
fl = @(x)(-1*x(4));
tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nbi  = @(x)r_nbi_e(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nbi,...
           (optimset('Display','off','Algorithm','sqp',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';       
%p_surface(k,:)=[losseqs(x(1:10),S), -1*x(11), -1*x(12)];
plot3(-1*x(2),-1*x(3),losses_approx(x(1:3), S),'.-b'); 
hold on 
sal(k)=flag;
end
toc




