function bldr_nbi_e2(S)
fid=fopen('r_nbi_e2.m','w+');
fprintf(fid,'function [c, ceq]=r_nbi_e2(x,S,Wx)\n\n');
fprintf(fid,'r_balance = nbi_pbalance(x,S);\n');
fprintf(fid,'obj1 = losses_approx(x,S);\n');
fprintf(fid,'t=x(4);\n');
fprintf(fid,'obj2=-1*x(2)-1*x(3);\n');
%Parameters
pf=0.92; s=tan(acos(pf));

%Calculation of the payoff Matrix
% G4 = Full
S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S=pflow(S);
mu2=[losses_approx([1, 0.12, 0.12], S); -0.24];

%Loss minimization
%initial conditions set

x0=0.0*ones(3,1);

lb=-1*ones(3,1); ub=1*ones(3,1);
lb(2:3,1)=0.012*ones(2,1);
ub(2:3,1)=0.12*ones(2,1);

fl=@(x)losses_approx(x,S);
r=@(x)pbalance(x,S);

[x,fval]=fmincon(fl,x0,[],[],[],[],lb,ub,r,...
    (optimset('Display','off','Algorithm','sqp','Diagnostics','off','MaxFunEvals',10000)));

mu1=[fval; -1*x(2)-1*x(3)];
%plot([mu1(2,1),mu2(2,1)],[mu1(1,1),mu2(1,1)]); hold on; 
phi=[mu1, mu2];
utopia_plane=[(mu2(1,1)-mu1(1,1)),(mu2(2,1)-mu1(2,1))];
normal=[1*(mu2(2,1)-mu1(2,1)),-1*(mu2(1,1)-mu1(1,1))];
dot(utopia_plane,normal)

%normal=1*normal/norm(normal);

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


