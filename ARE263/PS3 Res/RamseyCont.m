%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ARE 263 Larry Karp & Christian Traeger
% 
%  Ramsey Growth Model in Continuous Time, Collocation
%
%  The structure of this code is similar to that of 
%  Miranda and Fackler (2002), section 6.9.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup

% Tidy up workspace
clear global    % Clears all global variables
clear all       % Clears all variable from memory
close all       % Closes all open figures
%clc            % Clears all text from your command window

% Change the working directory to wherever you saved the PS6 package
% Sample paths:
% cd  C:\Matlab\ARE263\PS3 % Windows
% cd /User/ARE263/PS3 % MAC

%% Setup

% Define the parameters

eta = 2;        % Consumption smoothing parameter (IES)
                % If eta=1 calls the Bellman_log, otherwise regular Bellman using CIES
rho = 0.015;    % Annual (or periodic) rate of pure time preference
kappa = 0.3;    % Capital share
delta = 0.1;    % Capital depreciation rate
g = 0.02;       % Rate of technological progress
L = 7;          % Global labor force in billions of people

K_0 = 80;       % Initial capital stock
A_0 = 1;        % Initial level of technology
k_0 = K_0/A_0;  % Initial level of effective capital

% Normalization of discount factor to transform system to autonomous function iteration
beta=exp(-rho+(1-eta)*g);

% numerical parameters
T = 60;         % Terminal time
num_nodes = 15; % Number of approximation nodes

interp = 'cheb'; % Interpolation basis
% Do not use 'lin' because we need to take derivatives of the interpolated
% function. 

% Use different inital guesses for the two basis function methods
if interp == 'cheb'
    tnodes = chebnode(num_nodes-1,0,T);
    c = zeros(num_nodes,2); c(1,:) = 1;
    % Pick initial guess for the coefficients
else
    tnodes = [0:T/(num_nodes-2):T]';
    % Must have nodes at 0 and T. Otherwise very badly behaved
    c = ones(num_nodes,2);
    % Pick initial guess for the coefficients
end

fspace = fundefn(interp,num_nodes,0,T);

% set options for utility maximization step:
% the most important ones are to 'display', 'off' which suppresses output on the screen and 
% 'Algorithm', 'interior-point', which specifies the maximization algorithm.
% the other options set the maximal number of function evaluations and iterations, to put a limit on the maximal run-time
options = optimset('display','off', 'MaxFunEvals', 1000, 'MaxIter', 1000);

%% Solve for the steady state capital stock

% Solving a vector equation. Initial guess needs to be a 2x1 vector.
x_ss = fsolve(@(x) [x(1).^kappa*L^(1-kappa)-x(2)-(delta+g)*x(1),...
        (x(2)/eta).*(kappa*x(1).^(kappa-1)*L^(1-kappa)-(delta+rho+eta*g))], [10 10],options);

disp(['The steady state effective capital stock is ' num2str(x_ss(1)) ' with effective consumption ' num2str(x_ss(2))])

%% Solve the collocation equation using Cheb nodes

resid = @(c) RamseyCont_resid(c,tnodes,T,num_nodes,fspace,k_0,x_ss,kappa,L,delta,g,eta,rho);

c = fsolve(resid,c,options);

disp(['Solved for coefficients at collocation nodes with 2 and Inf norm ' num2str(norm(resid(c))) ' and ' num2str(norm(resid(c),Inf))])

if norm(imag(c),inf) < 10e-6
    c = real(c);
end

nplot = 501;
t = nodeunif(nplot,0,T);
x = funeval(c,fspace,t);
res=RamseyCont_resid(c,t,T,num_nodes,fspace,k_0,x_ss,kappa,L,delta,g,eta,rho);
%or analogously obtain residual directly as two column vectors 
% d = funeval(c,fspace,t,1);
% r = d - [x(:,1).^kappa*L^(1-kappa)-x(:,2)-(delta+g)*x(:,1),...
%        (x(:,2)/eta).*(kappa*x(:,1).^(kappa-1)*L^(1-kappa)-(delta+rho+eta*g))];
%res has in addition the model match to exogenous boundary contitions    
%A_t = exp(g*t)*A_0;
%mu = A_t.^(1-eta).*x(:,2).^(-eta);
mu = x(:,2).^(-eta);

% Plot residuals   
h = figure('name', ['Residuals']);
        set(gca,'fontsize',16)
        hold on
        %plot(t,r,t,res(1:nplot),t,res(nplot+1:2*nplot));
        plot(t,res(1:nplot),t,res(nplot+1:2*nplot));
        plot(0,res(2*nplot+1),'Xr',T,res(2*nplot+2),'Xb')
        hold off
        legend({'capital','consumption','init cap match','ss cap match'},'Location','se');
        title('Error in approximation', 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
        ylabel('Error size', 'FontSize', 16);
     saveas(h,['Residuals_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'jpg');
     saveas(h,['Residuals_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'epsc');
close(h)

% Plot time paths of effective capital and consumption
h = figure('name', ['Time paths effective units']);
      set(gca,'fontsize',16)
        plot(t,x);
        legend({'capital','consumption'},'Location','se');
        title('Time paths of effective capital and consumption', 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);  
     saveas(h,['Time_paths_effective_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'jpg');
     saveas(h,['Time_paths_effective_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'epsc');
close(h)

% Plot time path of shadow value of stock (different magnitude, so needs its own graph)
h = figure('name', ['Time path of current shadow value']);
      set(gca,'fontsize',16)
        plot(t,mu);
        title('Time path of current shadow value of effective capital', 'FontSize', 20);
        xlabel('Time in years', 'FontSize', 16);
        ylabel('Shadow value', 'FontSize', 16);
     saveas(h,['Time_paths_shadow_effective_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'jpg');
     saveas(h,['Time_paths_shadow_effective_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'epsc');
close(h)

% Plot the observed control rule
h = figure('name', ['Control Rule']);
      set(gca,'fontsize',16)
        plot(x(:,1),x(:,2));
        title('Normalized Control Rule', 'FontSize', 20);
        xlabel('Stock', 'FontSize', 16);
        ylabel('Optimal Effective Consumption', 'FontSize', 16);
     saveas(h,['control_rule_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'jpg');
     saveas(h,['control_rule_'  interp '_' num2str(num_nodes) 'horizon_' num2str(T)], 'epsc');
close(h)
