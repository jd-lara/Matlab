clc; clear all; close all;
d=100; Sigma=eye(24); quant_past=ones(19,24); quant_future=ones(19,24);
load data4.mat; load data5.mat; fileID1 = fopen('scenarios_JDLA.txt','w'); fileID2 = fopen('scenarios_max_JDLA.txt','w');

fprintf(fileID1,'  , \t  , \tT1, \tT2, \tT3, \tT4, \tT5, \tT6, \tT7, \tT8, \tT9, \tT10, \tT11, \tT12, \tT13, \tT14, \tT15, \tT16, \tT17, \tT18, \tT19,  \tT20,  \tT21,  \tT22,  \tT23,  \tT24  \n');
fprintf(fileID2,'  , \tT1, \tT2, \tT3, \tT4, \tT5, \tT6, \tT7, \tT8, \tT9, \tT10, \tT11, \tT12, \tT13, \tT14, \tT15, \tT16, \tT17, \tT18, \tT19,  \tT20,  \tT21,  \tT22,  \tT23,  \tT24  \n');
err=(0.00001:0.000001:(0.000001*28))';

% data_ok_realized=Data2(:,1);
% data_ok_forecast=Data2(:,2);
% 
% data_reg_realized=Data2(:,3);
% data_reg_forecast=Data2(:,4);
% 
% data_bad_realized=Data2(:,5);
% data_bad_forecast=Data2(:,6);
% 
% quant1=quant_gen(data_ok_forecast);
% quant2=quant_gen(data_reg_forecast);
% quant3=quant_gen(data_bad_forecast);

% fanchart(quant_past)
% hold on
% plot(data_ok_realized,'-k')
% plot(data_ok_realized,'ko')
% 
% fanchart(quant2)
% hold on
% plot(data_reg_realized,'-k')
% plot(data_reg_realized,'ko')
% 
% fanchart(quant3)
% hold on
% plot(data_bad_realized,'-k')
% plot(data_bad_realized,'ko')


for kt=1:24
    
    data_realized=data4(kt:kt+24,1)./4;
    data_forecasted=data4(kt:kt+24,2)./4;
    data_forecast_past=data5(kt,:)./4;
    data_forecast_future=data5(24+kt,:)./4;
    
    quant_past=quant_gen(data_forecast_past');
    quant_future=quant_gen(data_forecast_future');

    
Y=ones(1,24);
for n=1:1:24
  xi=quant_past(:,n)+err;  Fi=(0.05:0.05:0.95)';
  [CDF]=CDFcalc(xi,Fi);
  Y(n)=CDF(data_realized(n));
  clear CDF

end

X = norminv(Y,0,1);

Sigma=Sigma*(0.95)+(1-0.95)*(X'*X);
sigma=sqrt(diag(Sigma))';
Sigma=Sigma./(sigma'*sigma);

x1=mvnrnd(zeros(24,1),Sigma,d);

y1=zeros(d,24);
for n=1:1:d
  y1(n,:)=normcdf(x1(n,:),0,1);
end 


q_s=zeros(d,24);
for n=1:1:24
  xi=quant_future(:,n)+err;  Fi=(0.05:0.05:0.95)';
  [CDF, CDF_inv]=CDFcalc(xi,Fi); %generate the inverse CDF to obtain the powers  
  q_s(:,n)=CDF_inv(y1(:,n));
  clear CDF_inv

end

figure
for n=1:d
plot(q_s(n,:),'-k')
  hold on
end
plot(data_forecasted,'-r','LineWidth',1.5 )
%plot(data_realized,'-g','LineWidth',1.5 )
axis([1,24,0,1])
hold off

max_q_s=max(q_s);

%write output to excel 

for n=1:d
   t=sprintf('K%d',kt); s=sprintf('S%d',n);
   fprintf(fileID1,'%s, \t%s, \t%s \n',t,s,num2str(q_s(n,:),'%0.3f,\t'));
end
  fprintf(fileID2,'%s, \t%s \n',t,num2str(max_q_s,'%0.3f,\t'));      
  fprintf(fileID1,'\n\n');

end