close all; clear;
load wind_data_v2.mat
load ktr_scenarios_original;
original_profile = [Original(:,1)',Original(1:14,1)'];
WIND = WIND/(max(WIND));
Xt_in = linspace(0,23.75,96);
Xt_out = linspace(0,24-(1/12),288);
wind_hr = [];

t=1;

%Spline filling to go from 15 minutes to 5 minute time-steps. 

for k = 1:96:length(WIND)    
    spline_temp = spline(Xt_in,WIND(k:k+95),Xt_out);
    spline_temp =spline_temp.*(spline_temp>0);
    spline_temp = spline_temp/(max(spline_temp));
    wind_hr= [wind_hr,spline_temp]; 
    
end

%Discretization of the data. 

state = 0*(wind_hr >= 0 & wind_hr < 0.1) + ...
1*(wind_hr >= 0.1 & wind_hr < 0.2) + ...
2*(wind_hr >= 0.2 & wind_hr < 0.3) + ...
3*(wind_hr >= 0.3 & wind_hr < 0.4) + ...
4*(wind_hr >= 0.4 & wind_hr < 0.5) + ...
5*(wind_hr >= 0.5 & wind_hr < 0.6) + ...
6*(wind_hr >= 0.6 & wind_hr < 0.7) + ...
7*(wind_hr >= 0.7 & wind_hr < 0.8) + ...
8*(wind_hr >= 0.8 & wind_hr < 0.9) + ...
9*(wind_hr >= 0.9 & wind_hr < 1);

next_state = state(2:end);
state = state(1:length(state)-1);

transition_matrix = zeros(10,10);

%Construction of the transition Matrix 

for i = 1:10
    for j = 1:10
        
        temp_i1 = (state == i-1);
        temp_j1 = (next_state == j-1);
        temp1 = temp_i1.*temp_j1; 

        transition_matrix(i,j) = sum(temp1); 
        
    end
    
    transition_matrix(i,:) = transition_matrix(i,:)/sum(transition_matrix(i,:));
    
end

lik_num = 0;
 cases_log = [];
 
while lik_num < 20
    
    TM = transition_matrix;
    G = 0:9;
    T = 87580000;
    CDF = cumsum(TM,2); % cumulative distribution function.
    i = 1; % index of the initial state.
    ug = ones(1,T);
    ind = zeros(1,T);
    ind(1) = i;
    theta = []; 

    for t = 1:T; % simulation for T periods.
        ug(t) = rand(1); % create pseudo-random numbers from the uniform dist.
        j = find(CDF(i,:)>=ug(t),1,'First');
        ind(t) = j;
        i = j;
    end

    theta = G(ind); % pseudo-random numbers from the Markov chain for simulation. %

    for n = 1:length(theta)-1
    theta(n) = (theta(n) + theta(n+1))/20 + 0.05*rand(1) - 0.1*rand(1);
    end
    theta =theta.*(theta>0);

    %slices have the size of the 288 point forecast + 15 steps

    theta_comp = zeros(T/302,302);
    likelihood = zeros(T/302,302);
    likelihood_average = zeros(1,T/302);

    %Theta slicing
    kk = 1;
    for k = 1:302:length(theta)    
        theta_temp = theta(k:k+301);
        theta_comp(kk,:)= theta_temp; 
        kk = kk +1;
    end

    %likelihood calculation
    parfor k = 1:1:length(theta_comp(:,1))    

        likelihood_temp = abs(theta_comp(k,:) - original_profile);
        likelihood(k,:) = likelihood_temp;
        likelihood_average(k) = mean(likelihood_temp);

    end

    cases = theta_comp(likelihood_average <= 0.115,:); 
    
    cases_log = [cases_log; cases];

    lik_num = numel(cases_log(:,1));
    disp(lik_num);

end

cases = cases_log;
close all; 
time = 0:24/288:(24-1/288);
plot(time, 1.04*original_profile(1:288), 'k'); hold on
for k = 1:numel(cases(:,1))
    plot(time, cases(k,1:288))
end
plot(time, 1.04*original_profile(1:288), 'k', 'LineWidth',1.5);


forecasts = [];
p_forecasts= [];

for n = 1:length(cases(:,1)) 
    profileTemp = cases(n,:);
    for nn = 1:288 
        noise = [1, 1 + normrnd(0,0.20,1,14)];
        forecastTemp = profileTemp(nn:nn+14).*noise;
        forecastTemp = forecastTemp.*(forecastTemp>0);
        forecastTemp = forecastTemp.*(forecastTemp<1)+(1*forecastTemp>1);
        forecast_pTemp = profileTemp(nn:nn+14);
        forecasts = [forecasts; forecastTemp];
        p_forecasts = [p_forecasts; forecast_pTemp];
    end
end

forecasts = [1.0*Original(:,1:15); forecasts];
p_forecasts = [1.0*Original(:,1:15); p_forecasts];

