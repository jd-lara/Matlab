clear all; clc;
%period of data used to predict

for nnn=1:3 %nnn is the speed setting for the shifting 
for nn = 1:13; %% number of periods being predicted
    data=nn; 
N=1;
%period predicted
s=data+1;
P = [0.8 0.2 0; 0.1 0.75 0.15; 0 0.3 0.7];
P=P^nnn;
a=[0.25;0.5;0.25];
u=[2.5; 3.5; 4.5];
var_proc=[1.25,2.92,5.25];

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
exp_variance=0;
for n=1:numel(a)
   exp_variance=exp_variance+a(n)*var_proc(n); 
end

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

if nn==10
Z_10(:,nnn)=Z;
end

sum_z(nn)=sum(Z);

end

sum_cred(nnn,:)=sum_z;

end
sum_cred=sum_cred'
plot(sum_cred,'DisplayName','sum_cred');
figure
plot(Z_10,'DisplayName','Z_10');
