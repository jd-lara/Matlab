clear; 

N = 1000;  % Number of time steps per simulation step 
T = 1;    % Time Limit
S0 = 1;  % Initial value
dt = T/N; % Detla t  
Sn = 10000; % Number of trials per time step

kappa = 1;

theta = 5;

sigma = 0.5; 

S=ones(Sn,N);
S_av = ones(N,1);
S_var = ones(N,1);
T_vect = [0:dt:T-dt];

for s = 1:Sn
    
    S(s,1) = S0;
    
    for n = 2:N
        
    S(s,n) = S(s,n-1) +  kappa*(theta - S(s,n-1))*dt + sigma * sqrt(dt) * normrnd(0,1);   
        
    end
       
    
end

for n = 1:N
        
    S_av(n) = mean(S(:,n));   
    
    S_var(n) = var(S(:,n));    
      
end

S_av_exact = S0*exp(-1*kappa.*T_vect)+theta*(1-exp(-1*kappa.*T_vect));

S_var_exact = (sigma^2/2*kappa)*(1 - exp(-2.*kappa.*T_vect));

close all

figure(1)
plot(S');
title('Montecarlo Simulation');
xlabel('Time');
ylabel('State S_t');

figure(2)
plot(T_vect,S_av)
title('Average');
xlabel('Time');
ylabel('State S_t');
hold on 
plot(T_vect,S_av_exact)
legend('Simulation','Exact')
hold off

figure(3)
plot(T_vect,S_var)
title('Variance');
xlabel('Time');
ylabel('State S_t');
hold on
plot(T_vect,S_var_exact)
legend('Simulation','Exact')
hold off