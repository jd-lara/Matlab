function bldr_nnc_mp(S)
fid=fopen('r_nnc_mp.m','w+');
fprintf(fid,'function [c, ceq]=r_nnc_mp(x,S,Wx)\n\n');
fprintf(fid,'r_flow = pfloweqs_nnc(x,S);\n');
%Parameters
pf=0.95; s=tan(acos(pf));

%Calculation of the norm_anchor points. (STEP 1)

%Calculation of the payoff Matrix
% G4 and G5 = Full
% Suerkata and Vara Blanca = Full
S=pflow(S);
anchor2=[losses_exact(S); -1*sum(S.Machine.MW(5:6))/S.BaseMVA];

%Loss minimization

%initial conditions set

x0=0.0*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);

%Initial Conditions for Slack Bus

for k= S.Bus.SlackList
    x0(k)= real(S.Bus.Generation(S.Bus.SlackList));
    x0(k+1)=imag(S.Bus.Generation(S.Bus.SlackList));
end
 
%Initial conditions for PQ Buses 

for k = S.Bus.PQList
    x0(2*k -1) = S.Bus.Voltages(k);
    x0(2*k) = S.Bus.Angles(k)/(180/pi);
end

%Initial conditions for PV Buses 

for k = S.Bus.PVList
    x0(2*k -1) = imag(S.Bus.Load(k))-imag(S.Bus.Generation(k));
    x0(2*k)=S.Bus.Angles(k)/(180/pi);
end

clear losseqs; clear pfloweqs_l;    
bldpfloweqs_l(S); bldlosseqs(S);

% Lower and upper boundaries declaration

lb=-1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
lb(k)=0.90;
lb(k+1)=-pi/2;
end

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi/2;
end

lb(79:81,1)=S.Machine.MW(2:4,1)/50;
ub(79:81,1)=S.Machine.MW(2:4,1)/50;
lb(82:83,1)=0.01*ones(2,1);
ub(82,1)=S.Machine.MW(5,1)/50;
ub(83,1)=S.Machine.MW(6,1)/50;

fl = @(x)(losseqs(x,S));
r = @(x)pfloweqs_l(x,S);

[x,fval] = fmincon(fl,x0,[],[],[],[],lb,ub,r,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','on','MaxFunEvals',10000)));

anchor1=[fval; -1*x(82)-1*x(83)];

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
fprintf(fid,'obj1 = (losseqs(x(1:78),S)-%d)/%d;\n',utopia_point(1,1),L(1));
fprintf(fid,'obj2 = (-1*x(82)-1*x(83)-1*(%d))/%d;\n',utopia_point(2,1),L(2));

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

fprintf(fid,'ceq = r_flow;');

fclose(fid);


