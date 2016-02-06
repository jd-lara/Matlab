function result = GKclust(data,param)
% Gustafson Kesel algorithm
% The clusters are ellipsoids. 
% The square of the eigenvalue is the lengh of the related axis, then it is
% used as the standart deviation of the MF (with center in the cluster
% center).


f0=param.c;
X=data.X;

[N,n] = size(X);
[Nf0,nf0] = size(f0);
X1 = ones(N,1);

if exist('param.m')==1, m = param.m;else m = 2;end;
if exist('param.e')==1, e = param.m;else e = 1e-4;end;
if exist('param.ro')==1, rho=param.ro;
else 
    if max(Nf0,nf0) == 1
        rho = ones(1,param.c);
    else
        rho = ones(1,size(f0,2));
    end
end
if exist('param.gamma')==1, gamma = param.gamma;else gamma = 0;end;
if exist('param.beta')==1, beta = param.beta;else beta = 1e15;end;




rand('state',0)
if max(Nf0,nf0) == 1, 		
  c = f0;
  mm = mean(X);
  aa = max(abs(X - ones(N,1)*mm));
  v = 2*(ones(c,1)*aa).*(rand(c,n)-0.5) + ones(c,1)*mm; 
  for j = 1 : c,
    xv = X - X1*v(j,:);
    d(:,j) = sum((xv.^2),2);
  end;
  d = (d+1e-10).^(-1/(m-1));
  f0 = (d ./ (sum(d,2)*ones(1,c)));
else      
  c = size(f0,2);
  fm = f0.^m; sumf = sum(fm);
  v = (fm'*X)./(sumf'*ones(1,n));
end;

f = zeros(N,c);                
iter = 0;                      
A0= eye(n)*det(cov(X)).^(1/n);  




while  max(max(f0-f)) > e
  iter = iter + 1;
  f = f0;

  fm = f.^m; sumf = sum(fm);
  v = (fm'*X)./(sumf'*ones(1,n));
  for j = 1 : c,
    xv = X - X1*v(j,:);

    A = ones(n,1)*fm(:,j)'.*xv'*xv/sumf(j);

    A =(1-gamma)*A+gamma*(A0.^(1/n));
    if cond(A)> beta;
        [ev,ed]=eig(A); edmax = max(diag(ed));
        ed(beta*ed < edmax) = edmax/beta;
        A = ev*diag(diag(ed))/(ev);
    end;

    M = (1/det(pinv(A))/rho(j))^(1/n)*pinv(A);

    d(:,j) = sum((xv*M.*xv),2);
  end
    
  distout=sqrt(d);
  
  J(iter) = sum(sum(f0.*d));           

  d = (d+1e-10).^(-1/(m-1));
  f0 = (d ./ (sum(d,2)*ones(1,c)));
   
end          

fm = f.^m; sumf = sum(fm);

P = zeros(n,n,c);            
M = P;                         
V = zeros(c,n);              
D = V;                       


for j = 1 : c,                        
    xv = X - ones(N,1)*v(j,:);

    A = ones(n,1)*fm(:,j)'.*xv'*xv/sumf(j);

    [ev,ed] = eig(A); ed = diag(ed)';
    ev = ev(:,ed == min(ed));

	P(:,:,j) = A;
    M(:,:,j) = (det(A)/rho(j)).^(1/n)*pinv(A);
    V(j,:) = ev';
    D(j,:) = ed;
end




result.data.f = f0;
result.data.d = distout;
result.cluster.v = v;
result.cluster.P = P;
result.cluster.M = M;
result.cluster.V = V;
result.cluster.D = D;
result.iter = iter;
result.cost = J;