clear all
S=readcf('base2.cf');
S.Bus.Load(2,1)=0.9*S.Bus.Load(4,1);
S.Bus.Load(4,1)=0.7*S.Bus.Load(4,1);
S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
S.Bus.Load(5,1)=1.1*S.Bus.Load(5,1);
pf=0.92;
s=sin(acos(pf));
%initial conditions 
x0=0.03*ones(3,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=zeros(2,1);
ub(2:3,1)=0.08*ones(2,1);

% Weights 
w1=0:0.01:1;
w2=0:0.01:1;
w3=0:0.01:1;
Wx=allcomb(w1,w2,w3);
n=1; W=[];
for k = 1:numel(Wx(:,1));
if sum(Wx(k,:)) == 1
    W(n,:)=Wx(k,:); 
    n=n+1;
end

end


fl=@(x)losses_approx(x,S);
r=@(x)pbalance(x,S);

[x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','iter','Algorithm','interior-point','Diagnostics','on','MaxFunEvals',10000)))

S.Bus.Generation(4,1)=x(2)+j*s*x(2);
S.Bus.Generation(5,1)=x(3)+j*s*x(3);

S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);

S.Bus.Voltages
losses_exact(S)