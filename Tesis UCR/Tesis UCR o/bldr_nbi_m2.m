function bldr_nbi_m2(S)
fid=fopen('r_nbi_m2.m','w+');
fprintf(fid,'function [c, ceq]=r_nbi_m2(x,S,Wx)\n\n');
fprintf(fid,'r_flow = pfloweqs_nbi(x,S);\n');
fprintf(fid,'obj1 = losseqs(x,S);\n');
fprintf(fid,'t=x(13);\n');
fprintf(fid,'obj2=(-1*x(11)-1*x(12));\n');
%Parameters
pf=0.92; s=tan(acos(pf));

%Calculation of the payoff Matrix
% G4 = Full
S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S=pflow(S);
mu2=[losses_exact(S); -0.24];


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
lb(k+1)=-pi;
end
lb(2*S.Bus.n+1:end)=0.012;

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi;
end
ub(2*S.Bus.n+1:end)=0.12;

fl = @(x)(losseqs(x,S));
r = @(x)pfloweqs_l(x,S);

[x,fval] = fmincon(fl,x0,[],[],[],[],lb,ub,r,...
           (optimset('Display','off','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',10000)));

mu1=[fval; -1*x(11)-1*x(12)];
plot([mu1(2,1),mu2(2,1)],[mu1(1,1),mu2(1,1)]); hold on; 
phi=[mu1, mu2];
normal=[-1*(mu2(1,1)-mu1(1,1)),1*(mu2(2,1)-mu1(2,1))];
normal=1*normal/norm(normal);

fprintf(fid,'\n\n');
fprintf(fid,'c = [];\n\n\n ceq = [r_flow;\n');
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



