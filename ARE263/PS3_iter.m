%This function loops through the nodes of the polynomial approximation
%function in order to solve the RHS equation of the Bellman equation. Here,
% TV corresponds to the resulting value function and k is the optimal
% captial consumption. This function calls the PS3_Bellman function which
% contains the expression for the RHS of the Bellman equation. 

function [TV, k,c]=PS3_iter(k_old,fspace,w,nod,param)

%Create the matrices to store the values of the variables of interest. 
TV=zeros(numel(nod),1); %The solution of the RHS
x=zeros(numel(nod),2);  %Optimal effective capital

k0=k_old(1);            %Initial condition for the solver, 
                        % it has to be a feasible point. To accelerate
                        % convergence I have selected to used the previuos
                        % value of k

                        
%Iteration loop in the each one of the nodes.                         
for i = 1:numel(nod) 
    
    % Update the RHS of the Bellman equation for the node under analysis. 
    bellman = @(kp)PS3_Bellman(kp,fspace,w,nod(i),param);
    
    
    [x(i,:), TV(i), flag] = fmincon(bellman,[25,k0],[],[],[],[],[0,0],[],[],param.opt);
    k0=x(i,2);
    
    if flag < 0 
        error('Error. The maximization flag is %i', flag)
    end
    
end
    k=x(:,2);
    c=x(:,1);
    TV=-1*TV;
end