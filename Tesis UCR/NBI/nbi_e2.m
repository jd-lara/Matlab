clear all
clear losseqs.m r_nbi_e2.m
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.92; s=tan(acos(pf));
% S.Bus.Load(2,1)=0.9*S.Bus.Load(4,1);
% S.Bus.Load(4,1)=0.7*S.Bus.Load(4,1);
% S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
% S.Bus.Load(5,1)=1.1*S.Bus.Load(5,1);
S=bldybus(S); 
bldpfloweqs(S)
bldr_nbi_e2(S);
%ws_e; hold on 
S=pflow(S);

%initial conditions 
x0=0.08*ones(4,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=0.012*ones(2,1);
ub(2:3,1)=0.12*ones(2,1);
lb=[lb;-9];
ub=[ub;9];

% Weights for the restrictions 
w1=0:0.01:1;
w2=0:0.01:1;
Wx=allcomb(w1,w2);
n=1; W=[];
for k = 1:numel(Wx(:,1));
if sum(Wx(k,:)) == 1
    W(n,:)=Wx(k,:); 
    n=n+1;
end
end
clear Wx;
p_surface=zeros(numel(W(:,1)),2);
%equations for the optimization problem 
fl = @(x)(-1*x(4));
tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nbi  = @(x)r_nbi_e2(x,S,Wx);
    

    
[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nbi,...
           (optimset('Display','off','Algorithm','sqp',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';       
%p_surface(k,:)=[losseqs(x(1:10),S), -1*x(11), -1*x(12)];
plot(-1*x(2)-1*x(3),losses_approx(x(1:3), S),'xb','MarkerSize',8); hold on;
%plot([-1.317234e-01*Wx(1)+-2.400000e-01*Wx(2)],[+6.889311e-02*Wx(1)+3.322083e-01*Wx(2)],'ob');
sal(k)=flag;
end
toc
nnc_e2
grid
xlabel('Maximizacion de la generacion total')
ylabel('Minimizacion de las perdidas')




