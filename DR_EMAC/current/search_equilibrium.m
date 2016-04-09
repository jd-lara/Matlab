function search_equilibrium(sol, par, lse)
%SEARCH_EQUILIBRIUM Routine to find equilibrium
    
    display('starting equilibrium search...')
            
    % call optimization
    [a0, Aeq, beq, lb, ub] = par.gen_master_param(lse);
    options = optimoptions(@fmincon,'Algorithm','interior-point', ...
                           'MaxIter',15*10^4,'MaxFunEvals',10^8, ...
                           'Display','iter',...
                           'GradObj','on','TolX',10^(-8), ...
                           'TolFun',1.0e-08, ...
                           'Hessian','lbfgs');         
    [a, fval, exitflag, output] = fmincon(@(a)objfun(a, par, sol, lse),a0,...
                                        [],[],Aeq,beq,lb,ub,[],options);
    
    sol.update_master(a, -fval, exitflag, output);

        function [f, df] = objfun(a, par, sol, lse)

            % Update parameters and solve new welfare maximization problem.
            par.update_demand_parameters(a, lse);           
            solve_wmax(par, sol);

            % set objective function and gradient
            f = - sol.gen_objective(par);
            df = - sol.gen_gradient(par, lse);
        end
end

