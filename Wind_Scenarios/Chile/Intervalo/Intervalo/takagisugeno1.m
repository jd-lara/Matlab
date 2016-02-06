function [model, result]=takagisugeno1(iden_y,iden_x,Nmax,opcion)

% iden_y is one vector with the output y(k+1)
% iden_x is the matrix with the regresors [x1(k) x2(k) ... xn(k)]
% Nmax is the number of rules we want
% opcion(1)=1 LMS with all the data (problems may arise with the inverse of this matrix)
% opcion(1)=2 LMS for each rule (data weighted by activation degree of each rule)
% opcion(2)=1 Linear normalization
% opcion(2)=2 Gaussian normalization

% STEP 1: Normalization
dataEntr.X = [iden_y,iden_x]; % All the data

% We can use lineal 'range', or based on the a Gaussian normalization 'var'

if(opcion(2)==1)
dataEntr=clust_normalize(dataEntr,'range'); %data.min and data.max to denormalize
else
dataEntr=clust_normalize(dataEntr,'var'); %data.mean and data.std to denormalize
end
%dataEntr.Xold is the old data
%dataEntr.X is the normalized data

%STEP 2: Clustering
[fil col]=size(iden_x); %fil is number of data points, col the number of regressors
param.m=Nmax; %Number of clusters
param.e=1e-6; %Tolerance
%dataEntrOut.X=dataEntr.X(:,2:end); %everything except the output y(k+1)
dataEntrOut.X=dataEntr.X; %Data to do the clustering
param.c=Nmax; %Number of clusters
param.ro=ones(1,param.c); %
result=GKclust(dataEntrOut,param); %GK clustering

Vc=result.cluster.v(:,2:end);

B=[];
for j=1:Nmax
[A Valp]=eig(result.cluster.M(2:end,2:end,j));
B=[1./sqrt(diag(Valp)) B];
end

a=B';
b=Vc;

% Denormalization
if(opcion(2)==1)
for j=1:col
xmax=dataEntr.max(1,j+1);
xmin=dataEntr.min(1,j+1);
dx=xmax-xmin;
a(:,j)=a(:,j)*(1/dx);
b(:,j)=xmin+dx*b(:,j);
end
else
for j=1:col
xmean=dataEntr.mean(1,j+1);
dx=dataEntr.std(1,j+1);
a(:,j)=a(:,j)*(1/dx);
b(:,j)=xmean+dx*b(:,j);
end
end

model.a=a;
model.b=b;

%g=taksug2(dataEntr.X(:,1),dataEntr.X(:,2:end),B,Vc(1:cl,:,cl-1))
%g=taksug2(iden_y,iden_x,a,b);

if(opcion(1)==1)
%g=Taksug(iden_y,iden_x,a,b,dataEntr.X(:,1),dataEntr.X(:,2:end));
g=taksug2(iden_y,iden_x,a,b);
end

if(opcion(1)==2)
%g=taksug3(iden_y,iden_x,a,b,dataEntr.X(:,1),dataEntr.X(:,2:end));
g=taksug3(iden_y,iden_x,a,b);
end

model.g=g;


