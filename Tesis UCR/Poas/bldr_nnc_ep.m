function bldr_nnc_ep(S)
fid=fopen('r_nnc_ep.m','w+');
fprintf(fid,'function [c, ceq]=r_nnc_ep(x,S,Wx)\n\n');
fprintf(fid,'r_balance = nnc_pbalancep(x,S);\n');
%Parameters
pf=0.95; s=tan(acos(pf));

%Calculation of the norm_anchor points. (STEP 1)

% G4 and G5= Full

S=pflow(S);
anchor2=[losses_approx2((S.Machine.MW/50),S); -sum(S.Machine.MW(5:6))/50];

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

anchor1=[fval; -1*x(5)-1*x(6)];

%Normalization of the objectives mapping and plotting. (STEP 2)
utopia_point=[anchor1(1,1),anchor2(2,1)]';

nadir_point=[anchor2(1,1),anchor1(2,1)]';

L=nadir_point-utopia_point;

norm_anchor1=(anchor1-utopia_point)./L;
norm_anchor2=(anchor2-utopia_point)./L;


norm=[norm_anchor1,norm_anchor2];

%plot([norm_anchor1(2,1),norm_anchor2(2,1)],[norm_anchor1(1,1),norm_anchor2(1,1)]); hold on;

%Normal plane calculator 
Nk=[norm_anchor1-norm_anchor2]';

%Normalized cost functions. 
fprintf(fid,'obj1 = (losses_approx2(x,S)-%d)/%d;\n',utopia_point(1,1),L(1));
fprintf(fid,'obj2 = (-1*x(5)-1*x(6)-1*(%d))/%d;\n',utopia_point(2,1),L(2));

fprintf(fid,'normXPJ1 = Wx(1)*%d+Wx(2)*%d;\n',norm(1,1),norm(1,2));
fprintf(fid,'normXPJ2 = Wx(1)*%d+Wx(2)*%d;\n',norm(2,1),norm(2,2));
%fprintf(fid,'plot(normXPJ1,normXPJ2,''ob''); hold on;');

fprintf(fid,'\n\n');
fprintf(fid,'c = [');
for n=1:1
 for nn=1:2
    fprintf(fid,'+%d*(obj%d-normXPJ%d)',Nk(n,nn),nn,nn);
 end 
  fprintf(fid,';\n');
end

fprintf(fid,']; \n\n\n');

fprintf(fid,'ceq = r_balance;');

fclose(fid);



