%This function loops through the nodes of the polynomial approximation
%function in order to solve the RHS equation of the Bellman equation. Here,
% TV corresponds to the resulting value function and k is the optimal
% captial consumption. This function calls the PS3_Bellman function which
% contains the expression for the RHS of the Bellman equation. 

function [TV, kp, c]=PS3_iter(x0,fspace,w,k,param)

%Create the matrices to store the values of the variables of interest. 
TV=zeros(numel(k),1); %The solution of the RHS
x=zeros(numel(k),2);  %Optimal effective capital
c=zeros(numel(k),1);  %Optimal consumption.

%Initial condition for the solver, it has to be a feasible point. To accelerate
% convergence I have selected to used the previuos value of kp and c

                        
%Iteration loop in the each one of the nodes.                         
for i = 1:numel(k) 
    
    % Update the RHS of the Bellman equation for the level of capital under analysis. 
    bellman = @(x)PS3_Bellman(x,fspace,w,k(i),param);
    
    [x(i,:), TV(i), flag] = fmincon(bellman,x0(1,:),[],[],[],[],[0,0],[],[],param.opt);
    %Matlab won't solve for c within the optimization because is redundant
    %so it has to be calculated outside. Otherwise, the equation has to be
    %rewritten as a constraint in another function file. This seems to be
    %the easiest way.
    c(i)= - (x(i,2)./(exp(-param.g))) + k(i).^(param.kappa)*param.L^(1-param.kappa) + ((1 - param.delta).*k(i));
    x0=x(i,:);
    
    if flag < 0 
        error('Error. The maximization flag is %i', flag)
    end
    
end
    kp=x(:,2);
    if c < 0 
        error('Error. Returned a negative value of c')
    end
    
    TV=-1*TV;
end