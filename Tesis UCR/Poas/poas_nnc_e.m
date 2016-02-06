clear all
clear losseqs.m r_nbi_e.m
S=readcf('Poasg.cf'); %This Function ONLY reads the information stored on the *cf file 
pf=0.95; s=tan(acos(pf));
S=bldybus(S); 
bldpfloweqs(S)
S.Bus.Load=S.Bus.Load*0.8;
S=pflow(S);
%bldr_nnc_ep(S);


x0=S.Machine.MW/51;

lb=-1*ones(6,1); ub=1*ones(6,1);
lb(2:4,1)=S.Machine.MW(2:4,1)/50;
ub(2:4,1)=S.Machine.MW(2:4,1)/50;
lb(5:6,1)=0.01*ones(2,1);
ub(5,1)=S.Machine.MW(5,1)/50;
ub(6,1)=S.Machine.MW(6,1)/50;

% Weights for the restrictions 
w1=0:0.01:1;
w2=0:0.01:1;
Wx=allcomb(w1,w2);
n=1; W=[];
for k = 1:numel(Wx(:,1));
if sum(Wx(k,:)) == 1
    W(n,:)=Wx(k,:); 
    n=n+1;
end
end

clear Wx;
p_surface=zeros(numel(W(:,1)),3);
%equations for the optimization problem 
fl = @(x)((losses_approx2(x,S)-2.021415e-02)/8.306104e-02);

tic
for k = 1:numel(W(:,1))

    Wx=W(k,:);
    r_nnc  = @(x)r_nnc_ep(x,S,Wx);

[x,fval,flag] = fmincon(fl,x0,[],[],[],[],lb,ub,r_nnc,...
           (optimset('Display','off','Algorithm','sqp',...
           'Diagnostics','off','MaxFunEvals',1000)));

res(k,:)=x';
plot(-1*x(5)-1*x(6),losses_approx2(x(1:6), S),'og'); hold on;
% plot((-1*x(5)-1*x(6)-1*(-1.050000e-01))/7.203326e-02,...
%       (losses_approx2(x,S)-2.021415e-02)/8.306104e-02,'*k');

hold on 


sal(k)=flag;
end
toc

 grid
 xlabel('Maximizacion de la generacion total')
 ylabel('Minimizacion de las perdidas')



