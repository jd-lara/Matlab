function [consum,value,c,B,logical_converged,it] = Ramsey_iterate_PS4(uncertainty_flag, maxit,tol,damp,k_nodes,value,consum,c)

% Iterates over function approximations in recursive ramsey growth problem
% logical_converged==1 if converged.

% For each function gues (outer loop), the algorithm loops over the
% nodes where it solve utility maximization problem via fmincon 
% The outer loop stops when coefficients stay within tolerance "tol" or
% when reaching max # of iterations "maxit"

global fspace kappa L options delta consum_min w e sigma



num_nodes = length(k_nodes);

%Initialization
logical_converged = 0; % if =1 on output then converged


%% Begin function iteration loop (outer loop) 
% Takes current guess of value function as given
% After running inner loop over nodes it updates the guess

for it = 1:maxit
    
    % save current values of collocation function as cold
    c_old = c;
    consum_old = consum;
    value_old = value;
    
    %% node loop 
    % Iterates over all state-nodes
    % maximizes r.h.s. of Bellman for each node 
    % (given the current approximation of the value function)
    
%    If parallizing use these lines instead - command depends on your Matlab version
%    matlabpool open
%    parfor i = 1:num_nodes

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3b and PS4-3c)%%%%%%%%
if uncertainty_flag==1

disp(['Solving the model with uncertainty considering ' num2str(numel(w)) ' and standard deviation ' num2str(sigma)])  

for i = 1:num_nodes
    index = i;
    
    % maximization step, define the r.h.s. of Bellman as the objective
    val_handle_u = @(cons) Ramsey_bellman_u_PS4(c,cons,k_nodes(index));
    
    % Constraints:
    % Production given current capital stock
    production = k_nodes(index).^kappa.*L.^(1-kappa);
    % I will use production as the max consumption constraint.
    % Alternative formulation: Allow agent to additionally eat up left-over capital from last period
    %production = k_nodes(i).^kappa.*L.^(1-kappa)+(1-delta)*k_nodes(i);
    
    % Carry out r.h.s. Bellman maximization:
    % passing over: objective, starting values for optimal consumption search, and
    % constraints: 4 empty, lower bound, upper bound, empty, options specified in main file
    [consum_new,value_new] = fmincon(val_handle_u,5,[],[],[],[],consum_min,production,[],options);
    
    % save results of maximization step at present node
    consum(index) = consum_new;
    value(index) = -value_new;  % solver minimizes rather than maximizes
    
end

else
    disp(['Solving the deterministic model'])  
    for i = 1:num_nodes
        index = i;
        
        % maximization step, define the r.h.s. of Bellman as the objective
        val_handle_u = @(cons) Ramsey_bellman_PS4(c,cons,k_nodes(index));
        
        % Constraints:
        % Production given current capital stock
        production = k_nodes(index).^kappa.*L.^(1-kappa);
        % I will use production as the max consumption constraint.
        % Alternative formulation: Allow agent to additionally eat up left-over capital from last period
        %production = k_nodes(i).^kappa.*L.^(1-kappa)+(1-delta)*k_nodes(i);
        
        % Carry out r.h.s. Bellman maximization:
        % passing over: objective, starting values for optimal consumption search, and
        % constraints: 4 empty, lower bound, upper bound, empty, options specified in main file
        [consum_new,value_new] = fmincon(val_handle_u,consum(index),[],[],[],[],consum_min,production,[],options);
        
        % save results of maximization step at present node
        consum(index) = consum_new;
        value(index) = -value_new;  % solver minimizes rather than maximizes
        
    end
    
end

%%%%%%%%%%%%%%%%% Changes by JDLA to comply with PS4-3b and PS4-3c)%%%%%%%%



%% function iteration - update step - calculate new value function approximation
    % collocation function, given the outcome of the utility maximization
    if it==1
        % B: can save time through the (optional) saving of the basis matrix B
        [c_new B] = funfitxy(fspace, k_nodes, value);
    else
        % B: now I already have basis structure B and reuse it (more efficient)
        %[c_new] = funfitxy(fspace, B, value);
        [c_new] = funfitxy(fspace, k_nodes, value);
    end
    
    % Sometimes more stable not to update coefficients all the way, particularly useful if 
    % there might be a danger of alternating around the correct value (damp=0 usual full updating)
     c = (1-damp)*c_new + damp*c; 
    % c=c_new;
    
    step1 = norm(c_new-c_old,inf);
    step2 = norm(value-value_old,inf);
    normalization = norm(value);
    
    % check covergence criterion
    if step2/normalization<tol  %converged    
    % Alternative: If coefficients only change by little:
    % if step1<tol  %converged
        disp(['Function iteration with ' num2str(num_nodes) ' nodes converged after ' num2str(it),...
            ' iterations with maximum coefficient difference of ' num2str(step1)])
        disp(['Absolute and relative value function difference in last step: ' num2str(step2) ' and ' num2str(step2/normalization)])
        logical_converged=1; % indicates convergence
        break;
        
    elseif it==maxit
        disp(['Function iteration with ',num2str(num_nodes),' nodes reached the maximum number of iterations (',num2str(maxit),...
            '), still having a maximum coefficient difference of ',num2str(step1)])
        disp(['Value function difference at nodes in last step: ' num2str(step2)])
        logical_converged=-1;
    else
        disp(['Function iteration ',num2str(it),': max coeff change of ',num2str(step1,'%.5f'),...   % '%.5f' formats to 5 digits after decimal point
            ', max value change of ',num2str(step2,'%.5f'),' and relative ' num2str(step2/normalization,'%.5f') '.']);
    end
    
    if step1>10e+6 && it>1  % Divergence break
        disp(['Breaking function iteration with ',num2str(num_nodes),' nodes because coefficients changing too much (sign of divergence): ',num2str(step1)])
        logical_converged=-2;
        break;
    end
    

    
end % end of function iteration loop (go back to next guess unless break criterion satisfied)




end % end of function

