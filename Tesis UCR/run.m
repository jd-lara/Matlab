%Just hit play. 
clear all ; close all;
clc
S=readcf('5bus_33v2.cf'); %This Function ONLY reads the information stored on the *cf file 
S=bldybus(S); 
bldpfloweqs(S)
%bldlosseqs(S)
% S.Bus.Load(2,1)=1.0*S.Bus.Load(2,1);
% S.Bus.Load(4,1)=1.0*S.Bus.Load(4,1);
% S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
% S.Bus.Load(5,1)=1.0*S.Bus.Load(5,1);
% S.Bus.Generation(4,1)=0.5*S.Bus.Generation(4,1);
% S.Bus.Generation(5,1)=1.8*S.Bus.Generation(5,1);
L_exact=[]; P=[];
S=pflow(S);

pf=0.92;
s=sin(acos(pf));
n=0; m=0;
    for P2=0:0.01:1
        m=m+1;
        S.Bus.Generation(2,1)=0.06*P2*(1+1j*s);
        P(m)=real(S.Bus.Generation(2,1))*50;
        S=pflow(S);
        S.Bus.Voltages
        L_exact(m)=losses_exact(S); %losses in MW  
        Corriente(m)=sqrt(L_exact(m)/(S.BaseMVA*0.2326))*836.73;
        %L_approx(n,m)=losses_approx(real([S.Bus.Generation(1,1),S.Bus.Generation(4,1),S.Bus.Generation(5,1)]),S);        
    end
    
plot(P,L_exact)    
figure;
plot(P,Corriente)

%Just hit play. 
clear all ; close all;
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
S=bldybus(S); 
bldpfloweqs(S)
%bldlosseqs(S)
% S.Bus.Load(2,1)=0.9*S.Bus.Load(4,1);
% S.Bus.Load(4,1)=0.7*S.Bus.Load(4,1);
% S.Bus.Load(3,1)=1.0*S.Bus.Load(3,1);
% S.Bus.Load(5,1)=1.1*S.Bus.Load(5,1);
% S.Bus.Generation(4,1)=0.5*S.Bus.Generation(4,1);
% S.Bus.Generation(5,1)=1.8*S.Bus.Generation(5,1);
L_exact=[]; L_approx=[];
S=pflow(S);
pf=0.92;
s=tan(acos(pf));
n=0; m=0;
for P1=0:0.05:1
    n=n+1;
    S.Bus.Generation(4,1)=0.12*P1*(1+1j*s);
    P1k(n)=S.Bus.Generation(4,1)*50;
    m=0;
    for P2=0:0.05:1
        m=m+1;
        S.Bus.Generation(5,1)=0.12*P2*(1+1j*s);
        P2k(m)=S.Bus.Generation(5,1)*50;
         S=pflow(S);
         S.Bus.Voltages
         L_exact(n,m)=losses_exact(S); %losses in MW    
         L_approx(n,m)=losses_approx(real([S.Bus.Generation(1,1),S.Bus.Generation(4,1),S.Bus.Generation(5,1)]),S);        
    end
end
[p1, p2]=meshgrid(real(P1k),real(P2k));
colormap([gray(64);jet(64)])
mesh(p1,p2,L_exact)
hold on; 
mesh(p1,p2,L_approx)
figure
err=(L_exact-L_approx);
mesh(p1,p2,err)