function g=taksug2(y,X,a,b)

% Identificación de las consecuencias de T&S
% Se identifica T&S completo
% y, X tienen los datos
% a, b determinan las funciones de pertenencia a los clusters
% yn, Xn son los datos normalizados
% the problem with inverse of the matrix is solved using / instead of
% inv(x). However, this method may not work properly is you use too many
% rules.

[N,n]=size(X); 
NR=size(a,1);  
A=[];

for k=1:N  

   W=ones(1,NR);
   for r=1:NR
    for i=1:n
      W(r)=W(r)*exp(-0.5*(a(r,i)*(X(k,i)-b(r,i)))^2);
    end
   end

  Wn=W/sum(W);

  Aux2=[];
  for r=1:NR
    Aux=[];
    Aux(1,1)=Wn(r);
    for i=1:n
    Aux(1,i+1)=Wn(r)*X(k,i);
    end
    Aux2=[Aux2,Aux];
  end
   A(k,:)=Aux2;
end
  
size(A);
size(y);
p=A\y;

cont=1;
for r=1:NR
    g(r,:)=p(cont:cont+n,1)';
    cont=cont+n+1;
end

