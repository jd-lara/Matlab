function g=taksug3(y,X,a,b)

% Identificación de las consecuencias de T&S
% Se identifica T&S por cada regla
% y, X tienen los datos
% a, b determinan las funciones de pertenencia a los clusters
% yn, Xn son los datos normalizados
% Los datos cerca del centro del cluster tienes mas valor en la función
% objectivo, y por lo tanto pesan mas al momento de obtener la funcion
% lineal de la regla

[N,n]=size(X); 
NR=size(a,1);  

for r=1:NR
    
A=[];
yr=[];
cont=1;
Wrr=[];  

Wk=0.0001; % Data with a low membership degree is not considered

for k=1:N 
  W=1;
  for i=1:n
      W=W*exp(-0.5*(a(r,i)*(X(k,i)-b(r,i)))^2);
  end
  if(W>=Wk)
      A(cont,1)=W;
      yr(cont)=W*y(k);
      for i=1:n
      A(cont,i+1)=W*X(k,i);
      end
      cont=cont+1;
  end
end

p=A\(yr');
g(r,:)=p';

end

