% Jose Daniel Lara, ARE 263
% This code solves the discrete time dynamic programming Ramsey growth model
% \sum_{0}^{\inf} \exp(-\rho t) u(C_t)
% s.t. 
% y_t = k_t^{\kappa} L^{1-\kappa}
% K_{t+1} = [(1-\delta)k_t + y_t - c_t]exp(-g)
% Requires the files PS3_Bellman.m and PS3_iter.m

%% Solution of the DP section of the code
% clean up 
clear; clc; close all;

%definition of the parameters
%Dynamic programming loop parameters
iter_s = 0;
max_iter = 500;
epsilon = 1e-4;
diff = inf;
% Value of K in ss obtained from problem 1
k_ss=17.97;

%Strucuture to store results

log.V_hist=[];
log.diff_hist=[];
log.w_hist=[];
log.kp_hist=[];
log.c_hist=[];

%Call for functions 
maxim = @PS3_iter;
bellman = @PS3_Bellman;

%model parameters, stored into an array for a cleaner way of sharing them
%with the functions. 

param = struct(...
'opt', optimoptions('fmincon','Display','none','Algorithm','sqp'),... %Parameters for the optimization routine 
'slv', optimoptions('fsolve','Display','iter'),... %Parameters for the fsolve rutine
'eta' , 2,... 
'rho' , 0.015,...
'kappa' , 0.3,...
'delta' , 0.1,...
'g' , 0.02,...
'L' , 7,...
'k0' , 80);

% i) solution of the equation for k_t in S.S. k_ss is the function
% substituing for a fixed investment rate of 25%, for details on the
% calculation refer to the accompaning report.
k_inf = @(k) ((1-param.delta)*k+0.25*(k^(param.kappa)*param.L^(1-param.kappa)))*exp(-param.g)-k; 

k_inf_approx = fsolve(k_inf,21,param.slv); % steady state value of k

fprintf('The approximate solution to the capital stock in steady state is %f\n',...
                k_inf_approx)


% ii) Definintion of the the supporting interval for the value function
a = k_ss;      % Left bound of approximation interval Capital level in the steady state
b = 100;         % Right bound of approximation interval, initial amount of capital. 

% iii) implementation of the Ramsey growth model
basis_fun = 'cheb';                 % Specification the basis function (here 'cheb', 'spli', or 'lin)
n = 10;                             % Number of basis functions for the cheb approx as per iii)
fspace = fundefn(basis_fun,n,a,b);  % CompEcon routine defining the approximation space
nod = funnode(fspace);              % Obtain the collocation nodes

%Definitions of the initial conditions and first evaluation of V.  
w = zeros(n,1); w(1,:) = 1; % Initial values for w (chebyschev coefficients) 
k_old = linspace(a,b,n);    % Initial values for capital, using the final value in S.S. 
V_old=1*ones(n,1);          % Initial values for V
x0=[15*ones(n,1),V_old];

%main loop defintion as per the break condition. For this case, the epsilon
% and the maximum iterations are defined above
while (max(diff) > epsilon &  iter_s <= max_iter); 
    
    %Step 1, increase the iteration count and display
    iter_s = iter_s+1;
    S = ['Iteration count: ' num2str(iter_s) '  Current Gap:' num2str(diff)];
    disp(S)
    
   	%Step 2, given the current coefficients w, solve the RHS of Bellman's
   	%equation. Refer to the function PS3_iter for details. The resulting
   	%Value function evaluations and capital values are stored directly into
   	%the log structure for record keeping.
    [log.V_hist(:,iter_s),...
     log.kp_hist(:,iter_s),... 
     log.c_hist(:,iter_s)] = maxim(x0,fspace,w,nod,param);
    
    %Step 3, calculate the convergence criteria. In this case a simple
    %convergence criteria was selected using the absolute value of the
    %current value of V and the previous one stored in variable V_old. The
    %diffence is also stored for record keeping the log structure. 
    log.diff_hist(:,iter_s)=(abs(log.V_hist(:,iter_s)-V_old));
    diff = max(log.diff_hist(:,iter_s));
    
    %I have included a protection to avoid the system exploding before the
    %iteration count is done. 
  
    if diff > 1e5 
        error('Error. The difference is diverging, problem definition incorrect')
    end
    
    %Step 4, if the convergence criteria is not met, update the value of
    %V_old and k_old to the latests one and proceed to update the coefficients
    %and provide a new initial condition for the optimization. 
    V_old=log.V_hist(:,iter_s);
    k_old=log.kp_hist(:,iter_s);
    x0=[log.c_hist(:,iter_s),V_old];
    
    %update of the coefficients using the funfitxy function of the CompEcon
    % toolbox. The results are stored directly into the structure for
    % record keeping. 
    log.w_hist(:,iter_s)=funfitxy(fspace,nod,V_old);
    
    if any(isnan(log.w_hist(:,iter_s)))
        error('NaNs encountered in the weights')
    end
    
    w=log.w_hist(:,iter_s);
end

%% Simulation section of the code 
%simulation step of the process, obtain the optimal control rule as a
%function of the capital 

%v and vi) Plot the optimal consumption rate vs the effective capital
%first approach, use the resulting value function and solve the
%optimization problems

t_max = 50;
sim_count=1;
k = param.k0;
x0=[a,k];
delta_k = inf;
log.k_opt=[];
log.c_opt=[];

while (delta_k > 0.001 & sim_count <= t_max); 
    
    log.k_opt(sim_count)=x0(2);
    log.c_opt(sim_count)=x0(1);
    
    delta_k = log.k_opt(sim_count) - k_ss;
    sim_count = sim_count + 1;
    
    [~,...
     kp,... 
     c_t] = maxim(x0,fspace,w,log.k_opt(sim_count-1),param);
 
     x0=[c_t,kp];
     
     S = ['Simulation step opt: ' num2str(sim_count) '  Current Capital stock:' num2str(kp)];
        disp(S)
     
end

%second approach, create an implicit function 

fspace_sym = fundefn(basis_fun,n,a,b);  % CompEcon routine defining the approximation space
w_sym = funfitxy(fspace_sym,log.kp_hist(:,iter_s),log.c_hist(:,iter_s));
k_sym = param.k0;
log.k_fit=ones(1,t_max);
log.c_fit=ones(1,t_max);
log.k_fit(1)=param.k0;

for t_sym = 2:t_max+1 

log.c_fit(t_sym) = funeval(w_sym,fspace_sym,k_sym);
log.k_fit(t_sym) = ((1-param.delta)*k_sym + k_sym^(param.kappa)*param.L^(1-param.kappa) - log.c_fit(t_sym))*exp(-param.g);
k_sym = log.k_fit(t_sym);

S = ['Simulation step fit: ' num2str(t_sym) '  Current Capital stock:' num2str(k_sym)];
        disp(S)

end

%% Plotting section of the code 
close all; 
            

            %Plot of the value function. 
            h1 = figure('name', 'Plot of the value funtion with respect to capital');
            set(gca,'fontsize',16)
            hold on
            plot(k_ss:1:param.k0,funeval(w,fspace,[k_ss:1:param.k0]'),'k');
            title('Value function', 'FontSize', 20);
            xlabel('Effective Capital Stock k_t', 'FontSize', 16);
            ylabel('Value function V(k_t)', 'FontSize', 16);
            hold off
            saveas(h1,'Value_function', 'epsc');
            %close(h1)
            
            %Plot of the control with respect to capital. 
            h2 = figure('name', 'lot of the control with respect to capital');
            set(gca,'fontsize',16)
            hold on
            plot(log.k_opt(1:end-1),log.c_opt(2:end),'b');
            plot(log.k_fit(1:end-1),log.c_fit(2:end),'r');
            title('Control rule', 'FontSize', 20);
            xlabel('Effective Capital Stock k_t', 'FontSize', 16);
            ylabel('Consumption c_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','Location','northwest');
            hold off
            saveas(h2,'Control_rule', 'epsc');
            %close(h2)
            
            %Plot of the Policy Function. 
            h3 = figure('name', 'Policy Function');
            set(gca,'fontsize',16)
            hold on
            plot(log.k_opt(1:end-1),log.k_opt(2:end),'b');
            plot(log.k_fit(1:end-1),log.k_fit(2:end),'r');
            plot(log.k_fit(1:end-1),log.k_fit(1:end-1),'k--');
            title('Policy rule', 'FontSize', 20);
            xlabel('Effective Capital Stock k_t', 'FontSize', 16);
            ylabel('Effective Next Period Capital Stock kp_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','45 degree line','Location','northwest');
            ylim([min(log.k_fit) max(log.k_fit)])
            xlim([min(log.k_fit) max(log.k_fit)])
            hold off
            saveas(h3,'Policy_Function', 'epsc');
            %close(h3)
            
            %vii) time domain plots
            %Plot of the time domain effective consumption.
            h4 = figure('name', 'Consumption time simulation');
            set(gca,'fontsize',16)
            hold on
            stairs(log.c_opt(2:end),'b');
            stairs(log.c_fit(2:end),'r');
            title('Time Domain Simulation of Consumption', 'FontSize', 20);
            xlabel('Years', 'FontSize', 16);
            ylabel('Effective Consumption c_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','Location','northeast');
            xlim([1 t_max])
            hold off
            saveas(h4,'Consumption', 'epsc');
            %close(h4)
            
            %Plot of the time domain effective capital. 
            h5 = figure('name', 'Capital time simulation');
            set(gca,'fontsize',16)
            hold on
            stairs(0:1:numel(log.k_opt)-1,log.k_opt,'b');
            stairs(0:1:numel(log.k_fit)-1,log.k_fit,'r');
            title('Time Domain Simulation of Capital Stock', 'FontSize', 20);
            xlabel('Years', 'FontSize', 16);
            ylabel('Effective Capital k_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','Location','northeast');
            xlim([0 t_max])
            hold off
            saveas(h5,'Capital', 'epsc');
            %close(h5)
            
            %Plot of the gap for all the nodes. 
            h6 = figure('name', 'Converence');
            set(gca,'fontsize',16)
            hold on
                for i=1:n                    
                    plot(log.diff_hist(i,:))
                end  
            title('Convergence of the DP algorithm', 'FontSize', 20);
            xlabel('iterations', 'FontSize', 16);
            ylabel('Difference bewtween steps', 'FontSize', 16);
            xlim([1 iter_s])
            hold off
            saveas(h6,'Convergence', 'epsc');
            %close(h6)
            
            % viii) Comparison with the continous time. 
            % This section just loads the previuos results           
            log_2 = log; %I had to rename the results for Problem 2
            load PS3_1results.mat 
            
            %Plot of the time domain effective consumption.
            h7 = figure('name', 'Consumption time simulation comparison');
            set(gca,'fontsize',16)
            hold on
            stairs(log_2.c_opt(2:end),'b');
            stairs(log_2.c_fit(2:end),'r');
            plot(log.cheb.nodes10.t_sym,log.cheb.nodes10.c_sym, 'k--');
            title('Compare time Domain Simulation of Consumption', 'FontSize', 20);
            xlabel('Years', 'FontSize', 16);
            ylabel('Effective Consumption c_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','Cont Time','Location','northeast');
            xlim([1 t_max])
            hold off
            saveas(h7,'Consumption_comp', 'epsc');
            %close(h7)
            
            %Plot of the time domain effective capital. 
            h8 = figure('name', 'Capital time simulation comparison');
            set(gca,'fontsize',16)
            hold on
            stairs(log_2.k_opt(2:end),'b');
            stairs(log_2.k_fit(2:end),'r');
            plot(log.cheb.nodes10.t_sym,log.cheb.nodes10.k_sym, 'k--');
            title('Time Domain Simulation of Capital Stock', 'FontSize', 20);
            xlabel('Years', 'FontSize', 16);
            ylabel('Effective Capital k_t', 'FontSize', 16);
            legend('Optimization simulation','Function fit','Cont Time','Location','northeast');
            xlim([0 t_max])
            hold off
            saveas(h8,'Capital_comp', 'epsc');
            %close(h8)
            
            
            close all;

