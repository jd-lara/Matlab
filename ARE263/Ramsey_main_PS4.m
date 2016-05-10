%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ARE 263 Larry Karp & Christian Traeger
% 
%  Ramsey Growth Model in discrete time, dynamic programming
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup

% Tidy your workspace
clear global    % Clears all global variables
clear all       % Clears all variable from memory
close all       % Closes all open figures
clc            % Clears all text from your command window

% Change the working directory to wherever you saved the PS3 package
% Sample paths:
% cd  C:\Matlab\ARE263\PS3 % Windows
% cd /User/ARE263/PS3 % MAC

% Declare relevant parameters to be global 
% Global parameters can be accessed by all scripts that declare them upfrong as global.
% This is an alternative to passing parameters explicitly to functions.
% Note that if another script changes a global parameter it will be permanently changed for all scripts
% (which is not the case with parameters passed along as function arguments - unless they are returned again)
global fspace delta kappa L g eta beta options gamma e w sigma
% space structure, capital decay, growth rate, IES, pure time preference

% Set the economic parameters

eta = 3/2;      % Consumption smoothing parameter (IES)
                % If eta=1 calls the Bellman_log, otherwise regular Bellman using CIES
rho = 0.015;    % Annual (or periodic) rate of pure time preference
kappa = 0.3;    % Capital share
delta = 0.1;    % Capital depreciation rate
% Rate of technological progress: Has to be zero unless using log-utility
g = 0.02;
L = 7;          % Global labor force in billions of people


K_0 = 80;       % Initial capital stock
A_0 = 1;        % Initial level of technology
k_0 = K_0/A_0;  % Initial level of effective capital

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4)%%%%%%%%%%%%%%%%%%%%%%
%This portion of the code is used to include the stochastic process. 
uncertainty_flag=1;
gamma = 2/3;    % Disentangelment constant. 
mu=1; 
sigma = 0.2;
nshocks = 3; 
[e,w] =qnwnorm(nshocks, mu, sigma^2); 
%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4)%%%%%%%%%%%%%%%%%%%%%%

% Normalization of discount factor to transform system to autonomous function iteration
beta = exp(-rho+(1-eta)*g);

% Set the numeric parameters

num_nodes = 9; % Number of evaluation nodes & basis functions

T = 100;        % Time horizon for time path simulations
consum_min=0;   % Set lower bound on consumption (no borrowing)

% Choose interpolation basis functions: 'cheb' Chebychev polynomials;
% 'spli' cubic splines; 'lin' linear splines
interp = 'cheb';

% Pick the bounds of the function approximation space
k_min = 1;      % Lower bound - pick larger than 0 - value function is badly behaved at 0
k_max = 100;    % Upper bound


%parameters controlling function iteration loop:
tol = 1e-5;    % convergence tolerance
damp = 0;      % weight on coefficients of previous step (>0 for damping)
maxit = 10000; % maximum number of iterations in function approximation loop

% set options for utility maximization step:
% the most important ones are to 'display', 'off' which suppresses output on the screen and 
% 'Algorithm', 'interior-point', which specifies the maximization algorithm.
% the other options set the maximal number of function evaluations and iterations, to put a limit on the maximal run-time
options = optimset('display','off', 'MaxFunEvals', 1000, 'MaxIter', 1000, 'Algorithm','interior-point');
%options = optimset('display','off', 'MaxFunEvals', 1000, 'MaxIter', 1000, 'Algorithm','active-set'); %,'TolX',1e-12);

%Calculating steady state capital for fixed investment rate

disp(['Initial capital is ' num2str(K_0) ' and initial normalized capital is ' num2str(K_0/A_0) ]); 

fixed_investment_rate=0.25;
ss_residual = @(k) ((1-delta).*k + fixed_investment_rate*k.^kappa.*L.^(1-kappa)).*exp(-g) - k;
k_ss = fzero(ss_residual,K_0);
%19.9263
disp(['Steady state at fixed investment rate of ' num2str(fixed_investment_rate) ' is effective capital stock of ' num2str(k_ss) ]); 

% Plot effective capital surplus at a 25% fixed investment rate over present effective capital stock
% x = 0:0.1:100;
% y = ss_residual(x);
% h = figure('name', ['Fixed investment rate and capital surplus']);
%       set(gca,'fontsize',16)
%         plot(x,y,k_ss,ss_residual(k_ss),'rx','MarkerSize',20);
%         title('Fixed investment rate and capital surplus', 'FontSize', 20);
%         xlabel('Effective Capital', 'FontSize', 16);
%         ylabel('Effective Capital Growth (abs)', 'FontSize', 16);
%      %saveas(h,['ss_capital'], 'jpg');
%      saveas(h,['ss_capital'], 'epsc');
% close(h)

%Create the function space & initial guess

% generate function approximation space and collocation nodes
fspace = fundefn(interp,num_nodes,k_min,k_max);
k_nodes = funnode(fspace);

consum = ones(num_nodes,1)+5;  % action = 1 (arbitrary consumption guess)
value = zeros(num_nodes,1);  % initialize storage for value function at nodes (updated in every iteration)
coeff = zeros(num_nodes,1);  % coeffs = 0 (flat value function guess)

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3a)%%%%%%%%%%%%%%%%%%%
if exist('coeff_init.mat','file') == 2 
    disp('Previuos solution available')
    load coeff_init.mat;
    if  logical_converged == 1
        coeff = [coeff0(1:min(numel(coeff0),num_nodes));zeros(max(0,num_nodes-numel(coeff0)),1)];    
    elseif  logical_converged ~= 1 && exist('coeff_init_old.mat','file') == 2
        disp('Previuos solution is not good, it will be ignored. Using coefficients from last successful run')
        load coeff_init_old.mat;
        disp(['Loading ' num2str(min(numel(coeff0),num_nodes)) ' coefficients'])
        coeff = [coeff0(1:min(numel(coeff0),num_nodes));zeros(max(0,num_nodes-numel(coeff0)),1)];
     end
else
    disp('Previuos solution not available')
    coeff(1) = 1;  % coeffs = 0 (flat value function guess)
end
%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3a)%%%%%%%%%%%%%%%%%%%


% Solving for the optimal value function with Chebychev polynomials

% Passing: maximal number of function iterations, break criterion
% tolerance, potential damping coefficient, nodes, and initializations

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3b and PS4-3c)%%%%%%%%
[consum,value,coeff,B,logical_converged,it] = Ramsey_iterate_PS4(uncertainty_flag,maxit,tol,damp,k_nodes,value,consum,coeff);
%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3b and PS4-3c)%%%%%%%%
    
%Saves initial guess from the last succesful run
if logical_converged == 1
coeff0=coeff; 
save('coeff_init.mat','coeff0','logical_converged');
end

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3a)%%%%%%%%%%%%%%%%%%%

% Display an error message if the function iteration did not converge

if logical_converged ~= 1
    error('Did not converge. Breaking script.')
end

if uncertainty_flag == 1
    consum_u=consum;
    value_u=value;
    coeff_u=coeff;
    B_u=B;
    k_nodes_u=k_nodes;
    res_consum_u=consum;
    res_value_u=value;
    res_coeff_u=coeff;
    res_B_u=B;
    res_k_nodes_u=k_nodes;
    save('results_u.mat','res_consum_u', 'res_value_u', 'res_k_nodes_u','res_coeff_u', 'res_B_u','uncertainty_flag', 'num_nodes')
end 

% Evaluating on a denser grid

    k_dense = (k_min:((k_max-k_min)/100):k_max)'; % redefine the approximation nodes to finer grid
    value_dense = funeval(coeff_u,fspace,k_dense);    

% For efficient memory allocation better to first allocate vector of full lenght instead of adding on to an existing vector in a loop
 consum_dense = zeros(length(k_dense),1);
 value_dense_rhs = zeros(length(k_dense),1);
for i=1:length(k_dense)
            val_handle = @(consum) Ramsey_bellman_u_PS4(coeff_u,consum,k_dense(i));
            production = k_dense(i).^kappa.*L.^(1-kappa); % upper consumption constraint
            [consum_dense(i),value_dense_rhs_neg(i)] = fmincon(val_handle,1,[],[],[],[],consum_min,production,[],options);        
end

% Generate time paths

k_path = k_0;

    % Make an initial guess for the control. Pick the control 
    % corresponding to the stock value closest to the intial stock. 
    consum_start = consum_dense(find(k_nodes_u < k_0, 1, 'last'));

for t = 1:T
    val_handle = @(consum) Ramsey_bellman_u_PS4(coeff_u,consum,k_path(t));   
    production = k_path(t).^kappa.*L.^(1-kappa);
    [consum_new,v_new] = fmincon(val_handle,consum_start,[],[],[],[],consum_min,production,[],options);
    
    %store this period's value
    consum_path(t) = consum_new;
    
    % use this period's value as guess for next period
    consum_start = consum_new;
    
    % get next period's stock
    k_path(t+1) = ((1-delta).*k_path(t) + k_path(t).^kappa.*L.^(1-kappa) - consum_path(t)).*exp(-g);

    if mod(t,50)==0
        disp(['Computed ' num2str(t) ' years']);
    end
    
end


% Transforming consumption and capital back to real units
A_path=A_0*exp(g*(1:T));
Consum_path=consum_path.*A_path;
%K_path=k_path.*[A_path A_0*exp(g*(T+1))];
K_path=k_path(1:T).*A_path;

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3a)%%%%%%%%%%%%%%%%%%%

%% PLOT THE RESULTS

% Case of stochastic
if exist('results_u.mat','file') == 2 && uncertainty_flag == 1

%load results_u.mat;    

disp(['Plotting value function and control rule supported by the ',num2str(length(k_nodes_u)),' nodes of the function iteration'])

h = figure('name', ['Value function evaluated at k-nodes']);
      set(gca,'fontsize',16)
        plot(k_nodes_u,value_u);
        title(sprintf(['Value Function sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Normalized Value', 'FontSize', 16);
     %saveas(h,['value_function_for_' num2str(num_nodes) '_' interp '_nodes'], 'jpg');
     saveas(h,['e1u_value_function_for_' num2str(num_nodes) '_' interp '_nodes'], 'fig');
close(h)

h = figure('name', ['Control rule evaluated at k-nodes']);
      set(gca,'fontsize',16)
        plot(k_nodes_u, consum_u);
        title(sprintf(['Control Rule sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Effective Consumption', 'FontSize', 16);
     %saveas(h,['control_rule_for_' num2str(num_nodes) '_' interp '_nodes'], 'jpg');
     saveas(h,['e1u_control_rule_for_' num2str(num_nodes) '_' interp '_nodes'], 'fig');
close(h)

% Evaluating on a denser grid

    k_dense = (k_min:((k_max-k_min)/100):k_max)'; % redefine the approximation nodes to finer grid
    value_dense = funeval(coeff_u,fspace,k_dense);    

% For efficient memory allocation better to first allocate vector of full lenght instead of adding on to an existing vector in a loop
 consum_dense = zeros(length(k_dense),1);
 value_dense_rhs = zeros(length(k_dense),1);
for i=1:length(k_dense)
            val_handle = @(consum) Ramsey_bellman_u_PS4(coeff_u,consum,k_dense(i));
            production = k_dense(i).^kappa.*L.^(1-kappa); % upper consumption constraint
            [consum_dense(i),value_dense_rhs_neg(i)] = fmincon(val_handle,1,[],[],[],[],consum_min,production,[],options);        
end

disp(['Plotting, evaluting r.h.s. Bellman at ',num2str(length(k_dense)),' nodes for the state variable'])

h = figure('name', ['Value function evaluated at k-nodes ']);
      set(gca,'fontsize',16)
        plot(k_nodes,value,k_dense,value_dense,k_dense,-value_dense_rhs_neg);
        legend({'Collocated on grid','Dense evaluated','Dense r.h.s. Bellman'},'Location','se')
        title(sprintf(['Value Function sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Normalized Value', 'FontSize', 16);
     %saveas(h,['value_function_dense_'  interp '_' num2str(num_nodes)], 'jpg');
     saveas(h,['e1u_value_function_dense_'  interp '_' num2str(num_nodes)], 'fig');
close(h)

h = figure('name', ['Control rule evaluated densely']);
      set(gca,'fontsize',16)
        plot(k_dense, consum_dense);
        title(sprintf(['Control Rule sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Consumption', 'FontSize', 16);
     %saveas(h,['control_rule_dense_' interp '_' num2str(num_nodes)], 'jpg');
     saveas(h,['e1u_control_rule_dense_' interp '_' num2str(num_nodes)], 'fig');
close(h)

h = figure('name', ['Value function residual']);
      set(gca,'fontsize',16)
        plot(k_dense,-value_dense_rhs_neg'-value_dense);     
        title(sprintf(['Value function residual sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Residual', 'FontSize', 16);
     %saveas(h,['Residual_'  interp '_' num2str(num_nodes)], 'jpg');
     saveas(h,['e1u_Residual_'  interp '_' num2str(num_nodes)], 'fig');
close(h)


% Generate time paths

k_path = k_0;

    % Make an initial guess for the control. Pick the control 
    % corresponding to the stock value closest to the intial stock. 
    consum_start = consum_dense(find(k_nodes_u < k_0, 1, 'last'));

for t = 1:T
    val_handle = @(consum) Ramsey_bellman_u_PS4(coeff_u,consum,k_path(t));   
    production = k_path(t).^kappa.*L.^(1-kappa);
    [consum_new,v_new] = fmincon(val_handle,consum_start,[],[],[],[],consum_min,production,[],options);
    
    %store this period's value
    consum_path(t) = consum_new;
    
    % use this period's value as guess for next period
    consum_start = consum_new;
    
    % get next period's stock
    k_path(t+1) = ((1-delta).*k_path(t) + k_path(t).^kappa.*L.^(1-kappa) - consum_path(t)).*exp(-g);

    if mod(t,50)==0
        disp(['Computed ' num2str(t) ' years']);
    end
    
end


h = figure('name', 'Time paths effective');
      set(gca,'fontsize',16)
        plot(1:T,k_path(1:T), 1:T,consum_path)
        legend({'effective capital','effective consumption'},'Location','se')
        title(sprintf(['Time paths in effective units sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
     %saveas(h,['Time_paths_effective_'  interp '_' num2str(num_nodes)], 'jpg');
     saveas(h,['e1u_Time_paths_effective_'  interp '_' num2str(num_nodes)], 'fig');
close(h)

% Transforming consumption and capital back to real units
A_path=A_0*exp(g*(1:T));
Consum_path=consum_path.*A_path;
%K_path=k_path.*[A_path A_0*exp(g*(T+1))];
K_path=k_path(1:T).*A_path;

h = figure('name', ['Time paths original units']);
      set(gca,'fontsize',16)
        plot(1:T,K_path(1:T), 1:T,Consum_path)
        legend({'capital','consumption'},'Location','se')
        title(sprintf(['Time paths in original units sigma = ' num2str(sigma) ' eta']), 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
     %saveas(h,['Time_paths_original_'  interp '_' num2str(num_nodes)], 'jpg');
     saveas(h,['e1u_Time_paths_original_'  interp '_' num2str(num_nodes)], 'fig');
close(h)

end
%%
%%%%%%%%%%%%%%%%%% Case of analysis for the deterministic case %%%%%%%%%%%%
if exist('results_d.mat','file') == 2 && uncertainty_flag == 0
    
%load results_d.mat; 

disp(['Plotting value function and control rule supported by the ',num2str(length(k_nodes)),' nodes of the function iteration'])

h1 = figure('name', ['Value function evaluated at k-nodes ']);
      set(gca,'fontsize',16)
        plot(k_nodes,value);
        title(sprintf(['Det Value Function eta = ', num2str(eta)]), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Normalized Value', 'FontSize', 16);
     %saveas(h1,['value_function_for_' num2str(num_nodes) '_' interp '_nodes'], 'fig');
     %saveas(h1,['value_function_for_' num2str(num_nodes) '_' interp '_nodes'], 'epsc');
close(h1)

h2 = figure('name', ['Control rule evaluated at k-nodes']);
      set(gca,'fontsize',16)
        plot(k_nodes, consum);
        title(sprintf(['Det Control Rule eta = ', num2str(eta)]), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Effective Consumption', 'FontSize', 16);
     %saveas(h,['control_rule_for_' num2str(num_nodes) '_' interp '_nodes'], 'jpg');
     %saveas(h2,['control_rule_for_' num2str(num_nodes) '_' interp '_nodes'], 'epsc');
close(h2)

% Evaluating on a denser grid

    k_dense = (k_min:((k_max*2-k_min)/100):k_max*2)'; % redefine the approximation nodes to finer grid
    value_dense = funeval(coeff,fspace,k_dense);    
    
% For efficient memory allocation better to first allocate vector of full lenght instead of adding on to an existing vector in a loop
 consum_dense = zeros(length(k_dense),1);
 value_dense_rhs = zeros(length(k_dense),1);
 
for i=1:length(k_dense)
            val_handle = @(consum) Ramsey_bellman(coeff,consum,k_dense(i));
            production = k_dense(i).^kappa.*L.^(1-kappa); % upper consumption constraint
            [consum_dense(i),value_dense_rhs_neg(i)] = fmincon(val_handle,.5,[],[],[],[],consum_min,production,[],options);        
end

disp(['Plotting, evaluting r.h.s. Bellman at ',num2str(length(k_dense)),' nodes for the state variable'])

h = figure('name', ['Value function evaluated at k-nodes ']);
      set(gca,'fontsize',16)
        plot(k_nodes,value,k_dense,value_dense,k_dense,-value_dense_rhs_neg);
        legend({'Collocated on grid','Dense evaluated','Dense r.h.s. Bellman'},'Location','se')
        title(sprintf(['Det value Function eta = ', num2str(eta)]), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Normalized Value', 'FontSize', 16);
     %saveas(h,['value_function_dense_'  interp '_' num2str(num_nodes)], 'fig');
     saveas(h,['value_function_dense_'  interp '_' num2str(num_nodes)], 'epsc');
close(h)

h = figure('name', ['Control rule evaluated densely']);
      set(gca,'fontsize',16)
        plot(k_dense, consum_dense);
        title(sprintf(['Det control Rule eta = ', num2str(eta)]), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Consumption', 'FontSize', 16);
     %saveas(h,['control_rule_dense_' interp '_' num2str(num_nodes)], 'fig');
     saveas(h,['control_rule_dense_' interp '_' num2str(num_nodes)], 'epsc');
close(h)

h = figure('name', ['Value function residual']);
      set(gca,'fontsize',16)
        plot(k_dense,-value_dense_rhs_neg'-value_dense);     
        title(sprintf(['Value function residual eta = ', num2str(eta)]), 'FontSize', 20);
        xlabel('Effective Capital', 'FontSize', 16);
        ylabel('Residual', 'FontSize', 16);
     %saveas(h,['Residual_'  interp '_' num2str(num_nodes)], 'jpg');
     %saveas(h,['Residual_'  interp '_' num2str(num_nodes)], 'epsc');
close(h)


% Generate time paths

k_path = k_0;

    % Make an initial guess for the control. Pick the control 
    % corresponding to the stock value closest to the intial stock. 
    consum_start = consum_dense(find(k_nodes < k_0, 1, 'last'));

for t = 1:T
       
    val_handle = @(consum) Ramsey_bellman(coeff,consum,k_path(t));
    production = k_path(t).^kappa.*L.^(1-kappa);
    [consum_new,v_new] = fmincon(val_handle,consum_start,[],[],[],[],consum_min,production,[],options);
    
    %store this period's value
    consum_path(t) = consum_new;
    
    % use this period's value as guess for next period
    consum_start = consum_new;
    
    % get next period's stock
    k_path(t+1) = ((1-delta).*k_path(t) + k_path(t).^kappa.*L.^(1-kappa) - consum_path(t)).*exp(-g);

    if mod(t,50)==0
        disp(['Computed ' num2str(t) ' years']);
    end
    
end


h = figure('name', 'Time paths effective');
      set(gca,'fontsize',16)
        plot(1:T,k_path(1:T), 1:T,consum_path)
        legend({'effective capital','effective consumption'},'Location','se')
        title('Time paths in effective units', 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
     %saveas(h,['Time_paths_effective_'  interp '_' num2str(num_nodes)], 'fig');
     saveas(h,['Time_paths_effective_'  interp '_' num2str(num_nodes)], 'epsc');
close(h)

% Transforming consumption and capital back to real units
A_path=A_0*exp(g*(1:T));
Consum_path=consum_path.*A_path;
%K_path=k_path.*[A_path A_0*exp(g*(T+1))];
K_path=k_path(1:T).*A_path;

h = figure('name', ['Time paths original units']);
      set(gca,'fontsize',16)
        plot(1:T,K_path(1:T), 1:T,Consum_path)
        legend({'capital','consumption'},'Location','se')
        title('Time paths in original units', 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
     %saveas(h,['Time_paths_original_'  interp '_' num2str(num_nodes)], 'fig');
     saveas(h,['Time_paths_original_'  interp '_' num2str(num_nodes)], 'epsc');
close(h)

if uncertainty_flag == 0
    res_consum=consum;
    res_value=value;
    res_coeff=coeff;
    res_B=B;
    res_k_nodes=k_nodes;
    save('results_d.mat','res_consum', 'res_value', 'res_k_nodes','res_coeff', 'res_B', 'uncertainty_flag', 'num_nodes')
end 

end