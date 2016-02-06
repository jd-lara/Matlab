function bldr_nnc_eu(S)
fid=fopen('r_nnc_e.m','w+');
fprintf(fid,'function [c, ceq]=r_nnc_e(x,S,Wx)\n\n');
fprintf(fid,'r_balance = nnc_pbalance(x,S);\n');
%Parameters
pf=0.92; s=tan(acos(pf));

%Calculation of the norm_anchor points. (STEP 1)

S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.012*(1+1j*s);
S=pflow(S);

anchor2=[losses_approx([1, 0.12, 0.012], S); -0.12; -0.012];

% G5 = Full
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S.Bus.Generation(4,1)=0.012*(1+1j*s);
S=pflow(S);
losses_exact(S);

anchor3=[losses_approx([1, 0.012, 0.12],S); -0.012; -0.12];

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

anchor1t=[fval; -1*x(2); -1*x(3)];

S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S=pflow(S);
anchor1=[losses_approx([1, 0.12, 0.12], S); -0.12; -0.12];

%Normalization of the objectives mapping and plotting. (STEP 2)
utopia_point=[anchor1(1,1), anchor2(2,1), anchor3(3,1)]';

% nadir_point=[max([anchor1(1,1),anchor2(1,1),anchor3(1,1)]),...
%              max([anchor1(2,1),anchor2(2,1),anchor3(2,1)]),...
%              max([anchor1(3,1),anchor2(3,1),anchor3(3,1)])]';
% 
% L=nadir_point-utopia_point;

L=[1,1,1]';
utopia_point=[0,0,0]';

% plot3([anchor1(2,1),anchor2(2,1)], [anchor1(3,1),anchor3(3,1)], [anchor1(1,1),anchor1(1,1)],'r'); hold on; grid
% plot3([anchor2(2,1),anchor2(2,1)], [anchor2(3,1),anchor3(3,1)], [anchor2(1,1),anchor1(1,1)],'r')
% plot3([anchor3(2,1),anchor2(2,1)], [anchor3(3,1),anchor3(3,1)], [anchor3(1,1),anchor1(1,1)],'r')
% plot3([anchor1(2,1)], [anchor1(3,1)], [anchor1(1,1)],'*b')
% plot3([anchor2(2,1)], [anchor2(3,1)], [anchor2(1,1)],'*b')
% plot3([anchor3(2,1)], [anchor3(3,1)], [anchor3(1,1)],'*b')
% plot3([utopia_point(2,1)],[utopia_point(3,1)],[utopia_point(1,1)],'ob')
% plot3([nadir_point(2,1)],[nadir_point(3,1)],[nadir_point(1,1)],'ob'); hold off;

norm_anchor1=(anchor1-utopia_point)./L;
norm_anchor2=(anchor2-utopia_point)./L;
norm_anchor3=(anchor3-utopia_point)./L;

norm=[norm_anchor1,norm_anchor2,norm_anchor3];

% figure
% plot3([norm_anchor1(2,1),norm_anchor2(2,1)], [norm_anchor1(3,1),norm_anchor3(3,1)], [norm_anchor1(1,1),norm_anchor1(1,1)],'r'); hold on
% plot3([norm_anchor2(2,1),norm_anchor2(2,1)], [norm_anchor2(3,1),norm_anchor3(3,1)], [norm_anchor2(1,1),norm_anchor1(1,1)],'r');
% plot3([norm_anchor3(2,1),norm_anchor2(2,1)], [norm_anchor3(3,1),norm_anchor3(3,1)], [norm_anchor3(1,1),norm_anchor1(1,1)],'r');
% plot3([norm_anchor1(2,1)], [norm_anchor1(3,1)], [norm_anchor1(1,1)],'*b');
% plot3([norm_anchor2(2,1)], [norm_anchor2(3,1)], [norm_anchor2(1,1)],'*b');
% plot3([norm_anchor3(2,1)], [norm_anchor3(3,1)], [norm_anchor3(1,1)],'*b');
% % fill3(norm(2,:),norm(3,:),norm(1,:),'r'); alpha(0.3);

%Normal plane calculator 
upv1=norm_anchor1-norm_anchor2;
upv2=norm_anchor1-norm_anchor3;

% plot3([norm_anchor1(2,1), norm_anchor2(2,1)], [norm_anchor1(3,1), norm_anchor2(3,1)],[norm_anchor1(1,1), norm_anchor2(1,1)])
% plot3([norm_anchor1(2,1), norm_anchor3(2,1)], [norm_anchor1(3,1), norm_anchor3(3,1)],[norm_anchor1(1,1), norm_anchor3(1,1)])

Nk = -1*[upv1, upv2]';

%Normalized cost functions. 
fprintf(fid,'obj1 =  losses_approx(x,S);\n');
fprintf(fid,'obj2 = -1*x(2);\n');
fprintf(fid,'obj3 = -1*x(3);\n');

fprintf(fid,'normXPJ1 = Wx(1)*%d+Wx(2)*%d+Wx(3)*%d;\n',norm(1,1),norm(1,2),norm(1,3));
fprintf(fid,'normXPJ2 = Wx(1)*%d+Wx(2)*%d+Wx(3)*%d;\n',norm(2,1),norm(2,2),norm(2,3));
fprintf(fid,'normXPJ3 = Wx(1)*%d+Wx(2)*%d+Wx(3)*%d;\n',norm(3,1),norm(3,2),norm(3,3));
%fprintf(fid,'plot3(normXPJ2,normXPJ3,normXPJ1,''*b''); hold on;');

fprintf(fid,'\n\n');
fprintf(fid,'c = [');
for n=1:2
 for nn=1:3
    fprintf(fid,'+%d*(obj%d-normXPJ%d)',Nk(n,nn),nn,nn);
 end 
  fprintf(fid,';\n');
end

fprintf(fid,']; \n\n\n');

fprintf(fid,'ceq = r_balance;');

fclose(fid);



