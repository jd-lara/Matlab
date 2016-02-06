clear all; close all
load data.mat 
data=Power(:,3)-0.05;
n=numel(data); range=[]; quant=[];


%Creation of the future quantile prediction 
for l=0.085:0.085:0.78

factor=l;
x1=rand(n,1); x2=rand(n,1); x3=rand(n,1);
x=(0.35*x1+0.3*x2+0.35*x3)*factor;


for k=1:n

    if data(k)+(x(k)/2) > 1
        diff=(1-data(k));
        range(k,:)=[1-diff-(x(k)),0.93];
    
    elseif data(k)-(x(k)/2) < 0  
        diff=data(k);
        range(k,:)=[0,(x(k))-diff];
        
    else 
         range(k,:)=[data(k)-(x(k)/2),data(k)+(x(k)/2)];

    end
end

quant=[quant,range];


end
quant=[quant'; data'];
plot(quant')

 for n=1:24
 quant(:,n)=sort(quant(:,n));
 end
figure 

%Generation of the FanChart. 
quant1=quant';
quant2=quant';
for i=2:size(quant1,2)
    quant1(:,i)=quant1(:,i)-quant2(:,i-1);
end
h=area(quant1);
set(h,'LineStyle','none'); r1=.4; g=0;
set(h(1),'FaceColor',[1 1 1]) % white
set(h(2),'FaceColor',[r1 g .99])
set(h(3),'FaceColor',[r1 g .875])
set(h(4),'FaceColor',[r1 g .75])
set(h(5),'FaceColor',[r1 g .6])
set(h(6),'FaceColor',[r1 g .55])
set(h(7),'FaceColor',[r1 g .4])
set(h(8),'FaceColor',[r1 g .35])
set(h(9),'FaceColor',[r1*0.8 g .22])
set(h(10),'FaceColor',[r1*0.75 g .1]) %
set(h(11),'FaceColor',[r1*0.75  g .1])%
set(h(12),'FaceColor',[r1*0.8 g .22])
set(h(13),'FaceColor',[r1 g .35])
set(h(14),'FaceColor',[r1 g .4])
set(h(15),'FaceColor',[r1 g .55])
set(h(16),'FaceColor',[r1 g .6])
set(h(17),'FaceColor',[r1 g .75])
set(h(18),'FaceColor',[r1 g .875])
set(h(19),'FaceColor',[r1 g .99])
hold on
plot(quant(10,:),'-k');  % median forecast in black
 
%%
figure
  xi=quant3(:,2);
  [xi, Fi]=ecdf(xi);
  stairs(xi,Fi,'r')
  hold on
  xj = xi(2:end);
  Fj = (Fi(1:end-1)+Fi(2:end))/2;
  plot(xj,Fj,'b.', xj,Fj,'b-');
  
xj = [xj(1)-Fj(1)*(xj(2)-xj(1))/((Fj(2)-Fj(1)));
      xj;
      xj(n)+(1-Fj(n))*((xj(n)-xj(n-1))/(Fj(n)-Fj(n-1)))];
Fj = [0; Fj; 1];
  plot(xj,Fj,'b-');
CDF = @(p) interp1(xi,Fi,p,'linear','extrap');
p = 0.001:0.01:0.99;
figure
plot(xj,Fj,'b-',p,CDF(p),'ko');

%Calculation of the inverse CDF  

figure 
stairs(Fi,[xi(2:end); xi(end)],'r');
hold on
plot(Fj,xj,'b.',Fj,xj,'b-');
hold off
CDF_inv = @(y) interp1(Fj,xj,y,'linear','extrap');
y=rand(10,1);
figure
plot(Fj,xj,'b-',CDF(y),y,'ko');





