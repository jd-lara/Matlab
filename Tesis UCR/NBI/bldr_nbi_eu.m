function bldr_nbi_eu(S)
fid=fopen('r_nbi_e.m','w+');
fprintf(fid,'function [c, ceq]=r_nbi_e(x,S,Wx)\n\n');
fprintf(fid,'r_balance = nbi_pbalance(x,S);\n');
fprintf(fid,'obj1 = losses_approx(x,S);\n');
fprintf(fid,'t=x(4);\n');
fprintf(fid,'obj2=-1*x(2);\n');
fprintf(fid,'obj3=-1*x(3);\n');
%Parameters
pf=0.92; s=tan(acos(pf));

%Calculation of the payoff Matrix
% G4 = Full
S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.012*(1+1j*s);
S=pflow(S);
mu2=[losses_approx([1, 0.12, 0.012], S); -0.12; -0.012];
% G5 = Full
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S.Bus.Generation(4,1)=0.012*(1+1j*s);
S=pflow(S);
losses_exact(S);
mu3=[losses_approx([1, 0.012, 0.12],S); -0.012; -0.12];

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

mu1=[fval; -1*x(2); -1*x(3)];

S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S=pflow(S);
mu1t=[losses_approx([1, 0.12, 0.12], S); -0.12; -0.12];

phi=[mu1, mu2, mu3];
normal=cross(mu1-mu3,mu1-mu2);
normal=normal/norm(normal);
fill3(phi(2,:),phi(3,:),phi(1,:),'k'); grid; alpha(0.3); hold on
plot3([mu1(2,1),mu2(2,1)], [mu1(3,1),mu3(3,1)], [mu1(1,1),mu1(1,1)],'k')
plot3([mu2(2,1),mu2(2,1)], [mu2(3,1),mu3(3,1)], [mu2(1,1),mu1(1,1)],'k')
plot3([mu3(2,1),mu2(2,1)], [mu3(3,1),mu3(3,1)], [mu3(1,1),mu1(1,1)],'k')
% normal=planenormvec(mu1',mu2',mu3');
% normal=normal/norm(normal);

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


