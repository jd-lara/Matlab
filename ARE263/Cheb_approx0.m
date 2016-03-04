clear all;
clc

N=6;
fun = @(x) 1./(1+25*x.^2);
fspace=fundefn('cheb',N,-1,1);
x=-1:0.001:1;
y=fun(x);

cx=funnode(fspace);

[c,B]=funfitxy(fspace,x',y');
y2=funeval(c,fspace,x')
r=y'-y2;
plot(x,r);

figure
plot(x,y); hold on; 
plot(x,y2,'r');



