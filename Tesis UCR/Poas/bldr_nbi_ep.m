function bldr_nbi_ep(S)
fid=fopen('r_nbi_ep.m','w+');
fprintf(fid,'function [c, ceq]=r_nbi_ep(x,S,Wx)\n\n');
fprintf(fid,'r_balance = nbi_pbalancep(x,S);\n');
fprintf(fid,'obj1 = losses_approx2(x,S);\n');
fprintf(fid,'t=x(7);\n');
fprintf(fid,'obj2=-1*x(5)-1*x(6);\n');
%Parameters
pf=0.95; s=tan(acos(pf));

%Calculation of the payoff Matrix
% G4 = Full
S=pflow(S);
mu2=[losses_approx2((S.Machine.MW/50),S); -sum(S.Machine.MW(5:6))/50];

%Loss minimization
%initial conditions set

x0=S.Machine.MW/51;

lb=-1*ones(6,1); ub=1*ones(6,1);
lb(2:4,1)=S.Machine.MW(2:4,1)/50;
ub(2:4,1)=S.Machine.MW(2:4,1)/50;
lb(5:6,1)=0.01*ones(2,1);
ub(5,1)=S.Machine.MW(5,1)/50;
ub(6,1)=S.Machine.MW(6,1)/50;

fl=@(x)losses_approx2(x,S);
r=@(x)pbalancep(x,S);

[x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,...
    (optimset('Display','on','Algorithm','sqp','Diagnostics','off','MaxFunEvals',10000)));

mu1=[fval; -1*x(5)-1*x(6)];
plot([mu1(2,1),mu2(2,1)],[mu1(1,1),mu2(1,1)]); hold on; 
phi=[mu1, mu2];
utopia_plane=[(mu2(1,1)-mu1(1,1)),(mu2(2,1)-mu1(2,1))];
normal=[1*(mu2(2,1)-mu1(2,1)),-1*(mu2(1,1)-mu1(1,1))]
normal=1*normal/norm(normal)

fprintf(fid,'\n\n');
fprintf(fid,'c = [];\n\n\n ceq = [r_balance;\n');
for n=1:numel(phi(1,:))
 for nn=1:numel(phi(1,:))
    fprintf(fid,'+%d*Wx(%d)',phi(n,nn),nn);
 end
    fprintf(fid,'+t*%d',normal(n));
    fprintf(fid,'-obj%d',n);
 fprintf(fid,';\n');
end


fprintf(fid,'];');
fclose(fid);


