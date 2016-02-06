clear all; clc;
load realization_27.mat 
k=1;

realization_hourly=zeros(1,648);
for n=1:4:2589
   realization_hourly(k)=min(WindForecast(n:n+4))./4;
   k=k+1;    
end

plot(realization_hourly)


scenarios=[];
m=1;



for t=1:24
for r=t:24:(t+623)
   scenarios(((t-1)*29+m),:)=(realization_hourly(r:r+23));
   m=m+1
end
    m=1;
end
