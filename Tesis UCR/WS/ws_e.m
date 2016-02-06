clear all
S=readcf('base2.cf');
S.Bus.Load(2,1)=1.0*S.Bus.Load(2,1);
S.Bus.Load(4,1)=1.0*S.Bus.Load(4,1);
S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
S.Bus.Load(5,1)=1.0*S.Bus.Load(5,1);
S=bldybus(S); 
pf=0.92;
s=tan(acos(pf));
%initial conditions 
x0=0.0*ones(3,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=0.012*ones(2,1);
ub(2:3,1)=0.12*ones(2,1);

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
% exact=zeros(numel(W(:,1)),1);
% tic
% for k = 1:numel(W(:,1));
% 
% fl=@(x)(losses_approx(x,S)*W(k,1)-x(2)*W(k,2)-x(3)*W(k,3));
% r=@(x)pbalance(x,S);
% 
% [x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off','Algorithm','sqp',...
%          'Diagnostics','off','MaxFunEvals',10000)));
% 
% S.Bus.Generation(4,1)=x(2)+1j*s*x(2);
% S.Bus.Generation(5,1)=x(3)+1j*s*x(3);
% 
% S=pflow(S);
% 
% p_surface(k,:)=[-1*x(2), -1*x(3), losses_approx(x,S)];
% volt(k,:)=(S.Bus.Voltages+0)';
% exact(k,:)=losses_exact(S);
% 
% end
% toc
% plot3(p_surface(:,1),p_surface(:,2),p_surface(:,3),'*r');
% xlim = [-0.012 0.12];
% ylim = [-0.012 0.12];

n=1;
tic
for k = 0:0.01:1;

fl=@(x)(losses_approx(x,S)*(1-k)-k*(x(2)+x(3)));
r=@(x)pbalance(x,S);

[x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,(optimset('Display','off','Algorithm','sqp',...
         'Diagnostics','off','MaxFunEvals',10000)));

S.Bus.Generation(4,1)=x(2)+1j*s*x(2);
S.Bus.Generation(5,1)=x(3)+1j*s*x(3);

S=pflow(S);

p_surface2(n,:)=[-(x(2)+x(3)),losses_approx(x,S)];
volt(n,:)=(S.Bus.Voltages+0)';
exact(n,:)=losses_exact(S);
n=n+1;
end
toc
plot(p_surface2(:,1),p_surface2(:,2),'.k');
