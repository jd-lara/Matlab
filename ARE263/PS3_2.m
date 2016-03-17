% Jose Daniel Lara, ARE 263
% This code solves the discrete time dynamic programming Ramsey growth model
% \sum_{0}^{\inf} \exp(-\rho t) u(C_t)
% s.t. 
% y_t = k_t^{\kappa} L^{1-\kappa}
% K_{t+1} = [(1-\delta)k_t + y_t - c_t]exp(-g)

% clean up 
clear; clc

%definition of the parameters
%Dynamic programming loop parameters
iter_s = 0;
max_iter = 500;
epsilon = 1e-4;
diff = inf;

%Strucuture to store results
scase = 'case1';
log.V_hist=[];
log.diff_hist=[];
log.w_hist=[];
log.k_hist=[];
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
k_ss = @(k) ((1-param.delta)*k+0.25*(k^(param.kappa)*param.L^(1-param.kappa)))*exp(-param.g)-k; 

k_inf = fsolve(k_ss,21,param.slv); % steady state value of k


% ii) Definintion of the the supporting interval for the value function
a = 15;      % Left bound of approximation interval Capital level in the steady state
b = 100;         % Right bound of approximation interval, initial amount of capital. 

% iii) implementation of the Ramsey growth model
basis_fun = 'cheb';                 % Specification the basis function (here 'cheb', 'spli', or 'lin)
n = 10;                             % Number of basis functions for the cheb approx as per iii)
fspace = fundefn(basis_fun,n,a,b);  % CompEcon routine defining the approximation space
nod = funnode(fspace);              % Obtain the collocation nodes

%Definitions of the initial conditions and first evaluation of V.  
w = zeros(n,1); w(1,:) = 1; % Initial values for w (chebyschev coefficients) 
k_old = k_inf*ones(n,1);    % Initial values for capital, using the final value in S.S. 
V_old=-1;                   % Initial value for V


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
     log.k_hist(:,iter_s),... 
     log.c_hist(:,iter_s)] = maxim(k_old,fspace,w,nod,param);
    
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
    k_old=log.k_hist(:,iter_s);
    
    %update of the coefficients using the funfitxy function of the CompEcon
    % toolbox. The results are stored directly into the structure for
    % record keeping. 
    log.w_hist(:,iter_s)=funfitxy(fspace,nod,V_old);
    w=log.w_hist(:,iter_s);
end



