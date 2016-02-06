clear all; clc 

f = @(z)(-1*z(3));
x0=[0.5,0.5,0.5];
res=[]; n=1;

for b=0:0.01:1

r = @(z)rest1(z,b);

[z,fval]=fmincon(f,x0,[],[],[],[],[],[],r,(optimset('Display','iter','Algorithm','sqp','Diagnostics','on')));

res(n,:)=z;

n=n+1;

end

plot(res(:,1),res(:,2),'.b')