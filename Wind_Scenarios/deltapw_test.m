clear all; clc; close all
load realization_27.mat 
k=1;

 realization_hourly=[];
 for n=1:4:2497
    realization_hourly(k,:)=WindForecast(n:n+95);
    k=k+1;
 end

%plot(WindForecast)

load forecast_27.mat
k=0;
forecast_15min=zeros(648,96);
for n=4:4:2593
    k=k+1;
   forecast_15min(k,:)=WindForecast2(n,:);
    
end

for n=1:648
    k=1;
    for m=1:4:93
        forecast_hourly(n,k:k+3)=mean(forecast_15min(n,m:m+3));
    k=k+4
    end
end
k=1;
for n=1:624

    for m=1:96
        if forecast_hourly(n,m) > 0
            delta_pwa(k,m)=abs(forecast_hourly(n,m)-realization_hourly(n,m))./4;
        %else
        %    delta_pwa(n,m)=abs(forecast_hourly(n,m)-realization_hourly(n,m))/4;
        end
    end
        k=k+1;
end

for n=1:624
    k=1;
    for m=1:4:93
        delta_pw_hourly(n,k)=max(delta_pwa(n,m:m+3));
    k=k+1;
    end
end

for n=1:24

    delta_av(n)=mean(delta_pw_hourly(1:624,n))*100;
    delta_med1(n)=quantile(delta_pw_hourly(1:624,n),0.75)*100;
    delta_med2(n)=quantile(delta_pw_hourly(1:624,n),0.85)*100;
    delta_med3(n)=quantile(delta_pw_hourly(1:624,n),0.90)*100;
    delta_med4(n)=quantile(delta_pw_hourly(1:624,n),0.70);
    delta_worst(n)=max(delta_pw_hourly(1:624,n));
    
end 

figure(400)
hist(delta_pw_hourly')
figure(100)
hist(delta_pw_hourly)
figure(200)
plot(1:24,delta_av,1:24,delta_med1,1:24,delta_med2,1:24,delta_med3)
%figure
%plot(1:24,delta_av,1:24,delta_med2)

figure(300)
for q=0.5:0.01:0.9
    for n=1:24
    delta_med(n)=quantile(delta_pw_hourly(1:624,n),q);
    end
    q
    mean(delta_med(n))
    %plot(1:24,delta_med); hold on
end

binranges=0:0.05:0.9;

for n=1:624
bins(n,:)=histc(delta_pw_hourly(n,:)',binranges);
end

for n=1:numel(bins(1,:))
bins_av(n)=mean(bins(:,n));
bins_test(n)=quantile(bins(:,n),0.750);
end
sum(bins_av)
figure

duration=24*ones(numel(bins_av),1);
for n=2:numel(bins_av)
    duration(n)=duration(n-1)-bins_av(n-1);
end

plot(duration,binranges*100)


