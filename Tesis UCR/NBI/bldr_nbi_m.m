function bldr_nbi_m(S)
fid=fopen('r_nbi_m.m','w+');
fprintf(fid,'function [c, ceq]=r_nbi_m(x,S,Wx)\n\n');
fprintf(fid,'r_flow = pfloweqs_nbi(x,S);\n');
fprintf(fid,'obj1 = losseqs(x,S);\n');
fprintf(fid,'t=x(13);\n');
fprintf(fid,'obj2=-1*x(11);\n');
fprintf(fid,'obj3=-1*x(12);\n');
%Parameters
pf=0.92; s=tan(acos(pf));

%Calculation of the payoff Matrix
% G4 = Full
S.Bus.Generation(4,1)=0.12*(1+1j*s);
S.Bus.Generation(5,1)=0.03707*(1+1j*s);
S=pflow(S);
mu2=[losses_exact(S); -0.12; -0.03707];
% G5 = Full
S.Bus.Generation(5,1)=0.12*(1+1j*s);
S.Bus.Generation(4,1)=0.03643*(1+1j*s);
S=pflow(S);
losses_exact(S);
mu3=[losses_exact(S); -0.03643; -0.12];

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
lb(2*S.Bus.n+1:end)=-0.012;

ub=1*ones(2*S.Bus.n+numel(find(S.Bus.busType==1)),1);
for k=3:2:2*S.Bus.n
ub(k)=1.10;
ub(k+1)=pi/2;
end
ub(2*S.Bus.n+1:end)=0.12;

fl = @(x)(losseqs(x,S));
r = @(x)pfloweqs_l(x,S);

[x,fval] = fmincon(fl,x0,[],[],[],[],lb,ub,r,...
           (optimset('Display','on','Algorithm','interior-point',...
           'Diagnostics','off','MaxFunEvals',10000)));

mu1=[fval; -1*x(11); -1*x(12)];
% S.Bus.Generation(4,1)=0.12*(1+1j*s);
% S.Bus.Generation(5,1)=0.12*(1+1j*s);
% S=pflow(S);
% mu1t=[losses_exact(S); -0.12; -0.12];

phi=[mu1, mu2, mu3];
normal=cross(mu1-mu3,mu1-mu2);
normal=normal/norm(normal);
fill3(phi(2,:),phi(3,:),phi(1,:),'r'); alpha(0.3); hold on; 
plot3([mu1(2,1),mu2(2,1)], [mu1(3,1),mu3(3,1)], [mu1(1,1),mu1(1,1)],'r')
plot3([mu2(2,1),mu2(2,1)], [mu2(3,1),mu3(3,1)], [mu2(1,1),mu1(1,1)],'r')
plot3([mu3(2,1),mu2(2,1)], [mu3(3,1),mu3(3,1)], [mu3(1,1),mu1(1,1)],'r')

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



