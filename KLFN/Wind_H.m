close all;
Mine2Load_Jan30_5min=ones(288,1);
Mine2Wind_Jan30_5min=ones(288,1);
Mine2AvailableWind_Jan30_5min=ones(288,1);
Mine2AvailableWind_Jan1_5min=ones(288,1);
k=1;

for n = 1:300:numel(Mine2Load_Jan1)
    Mine2Load_Jan30_5min(k) = mean(Mine2Load_Jan30(n:n+299));
    Mine2Wind_Jan30_5min(k) = mean(Mine2Wind_Jan30(n:n+299));
    Mine2AvailableWind_Jan30_5min(k) = mean(Mine2AvailableWind_Jan30(n:n+299));
    
    k=k+1;
end

plot(-1*Mine2Load_Jan30_5min); hold on;
plot(Mine2AvailableWind_Jan30_5min, 'k');


%plot(Mine2Wind_Jan30_5min, 'r'); hold off;

% 
% wind_averaged=10*ones(24,1);
% wind_perfect_info=zeros(24,24);
% wind(287)=wind(286);
% wind(288)=wind(287);
% k=1;
% 
% for n = 1:12:288
% 
%     wind_averaged(k)=mean(wind(n:n+11));
% 
%     k=k+1;
% 
% end
% 
% wind_averaged2=[wind_averaged;wind_averaged];
% 
% for n = 1:24
% 
% wind_perfect_info(n,:)=wind_averaged2(n:n+23)';
% 
% end
% 
% k=1;
% for n=1:12:288
%    
%     wind_forecast_288(n:n+11)=wind_forecast(k)*ones(12,1);
%     wind_perfect_288(n:n+11)=wind_averaged(k)*ones(12,1);
%     
%     k=k+1;
% end
% 
% wind_forecast_288 = wind_forecast_288';
% wind_perfect_288 = wind_perfect_288';
% 
% time= 0:24/288:24;
% time = time(1:288)';
% 
% for s = 1:100
%  k=1;
% for n=1:12:288
%    
%     wind_scenarios_288(s,n:n+11)=scenarios(s,k)*ones(12,1);
%     
%     k=k+1;
% end
%  
%    
% end
% 
% wind_scenarios_288=wind_scenarios_288';
% 
% for n= 1:288
%     
%     scenarios_up(n,1)=0.92*max(wind_scenarios_288(n,:));
%     scenarios_down(n,1)=0.92*min(wind_scenarios_288(n,:));
% end
% 
% plot(time,wind,'color',[0 0 0],'marker','*','DisplayName','wind','LineWidth',1); hold on;
% plot(time,wind_perfect_288,'r','LineWidth',2); hold off;
% 
% 
% figure; hold all; 
% hLine1 = plot(time,scenarios_up,'--','color','black','DisplayName','scenarios_up','LineWidth',3);hold all;
% hLine2= plot(time,scenarios_down,'--','DisplayName','scenarios_down','color','black','LineWidth',3);
% hLine3= plot(time,wind,'color',[0 0 0],'marker','*','DisplayName','wind','LineWidth',2); 
% hLine4=plot(time,wind_perfect_288,'color','black','LineWidth',3); 
%  for s = 1:5:100
%      plot(time,0.92*wind_scenarios_288(:,s),'Color',[0.5 0.5 0.5]);
%  end
% legend([hLine1,hLine2,hLine3,hLine4],'Upper bound of scenarios','Lower bound of scenarios','Realization','Wind Power Hourly Average')
% hold off;