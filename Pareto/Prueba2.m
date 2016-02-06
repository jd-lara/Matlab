clear all; clc 

f = @(z)(z(1));
x0=[0.5,0.5,0.5];
res=[]; n=1;

for b=0:0.01:1

r = @(z)rest2(z,b);

[z,fval]=fmincon(f,x0,[],[],[],[],[],[],r,(optimset('Display','iter','Algorithm','sqp','Diagnostics','on')));

res(n,:)=z;

n=n+1;

end

plot(res(:,1)-1,res(:,2)-1,'.b')