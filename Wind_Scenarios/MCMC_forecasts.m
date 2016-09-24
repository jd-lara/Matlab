clear; close all; 
load MCMC_cases.mat
forecasts = [];
p_forecasts= [];

for n = 1:length(cases(:,1)) 
    profileTemp = cases(n,:);
    for nn = 1:288 
        noise = [1,1 + normrnd(0,0.10,1,14)];
        forecastTemp = profileTemp(nn:nn+14).*noise;
        forecastTemp = forecastTemp.*(forecastTemp>0);
        forecast_pTemp = profileTemp(nn:nn+14);
        forecasts = [forecasts; forecastTemp];
        p_forecasts = [p_forecasts; forecast_pTemp];
    end
end
