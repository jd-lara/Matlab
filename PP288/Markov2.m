close all; clear all; clc;
%period of data used to predic
data=30;
N=1; %number of dice 
%period predicted
s=31;
P = [0.82 0.180 0 0; 0.24 0.592 0.168 0; 0 0.252 0.608 0.14; 0 0 0.28 0.72];
a=[0.4000 ;   0.3000  ;  0.2000  ;  0.1000];
u=[0.25; 0.5; 0.75; 1];
var_proc=[1.25,2.92,5.25];
P=P^1;
a'*P;

%calculate eigenvalues and eigenvectors 
[V,Lambda]=eigs(P');
%conditioning of V, first colum all ones.
V=V';
V(1,1:end)=V(1,1:end)/V(1,1);
V(2,1:end)=V(2,1:end)/V(2,1);
V(3,1:end)=V(3,1:end)/V(3,1);
Inv_V=V^-1;

%Eigenvector/Value check 
r=V*P'*V^-1;

%Check eq 2.3 
P^5;
Inv_V*Lambda^5*V;

%Check eq 2.4
Lambda^20;
C_1=(u.*a)';
C=C_1*Inv_V;
D=V*u;

chi =C'.*D;
lambda=diag(Lambda); 


%Calculation of the expected value of process variance
exp_variance=0.5; %because it is a poisson process. 
% for n=1:numel(a)
%    exp_variance=exp_variance+a(n)*var_proc(n); 
% end

%Calculation of the covariances and k factors
Covariance=zeros(s+1,1);
k=zeros(s+1,1);
for g = 0:s;
    if g==0
Covariance(g+1)=N*dot(chi(2:end),lambda(2:end).^g)+exp_variance;
    elseif g~=0
Covariance(g+1)=N*dot(chi(2:end),lambda(2:end).^g);
    end
k(g+1)=N*Covariance(g+1)/(dot(chi(2:end),lambda(2:end).^0));
end

%Calculation of the credibilities 
%Build covariance matrix 

cov_matrix=zeros(data,data);

for i=1:data
    for j=1:data
    distance=abs(i-j);
    cov_matrix(i,j)=Covariance(distance+1);    
    end
end

vector_b=flip(Covariance(2:s));
vector_b=vector_b(1:data);

Z=(cov_matrix^-1)*vector_b*100
sum(Z)
