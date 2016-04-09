classdef solution < handle
    %SOLUTION Records the solution of welfare maximization problem and
    % also the equilibrium search method.
    
    properties
        y        % (MWh) Production by tech per scernarios and periods.
        x        % (MWh) Intalled capscity by tech.
        p        % ($/MWh) Retail volumetric charges.
        l        % ($/MWh) Wholesale energy prices.
        et       % ($/MWh) RPS price paid to renewable producers.
        val      % ($) Value of objective function of subproblem.
        % Outputs of master problem
        a        % Vector with the number of customers under each segment.
        fval     % ($) Value of objective function of master problem.
        exitflag % Exitflag
        output   % Structure containing information about the optimization.     
        sol_time % Solution time elapsed.
    end
    
    methods
        function obj = solution()
            obj.y = NaN;
            obj.x = NaN;
            obj.p = NaN;
            obj.l = NaN;
            obj.et = NaN;
            obj.val = NaN;
        end
        function update(obj, y, x, p, l, et, val)
            obj.y = y;
            obj.x = x;
            obj.p = p;
            obj.l = l;
            obj.et = et;
            obj.val = val;
        end
        function update_master(obj, a, fval, exitflag, output)
            obj.a = a;
            obj.fval = fval;
            obj.exitflag = exitflag;
            obj.output = output;
            obj.sol_time = toc;
        end
        function val = gen_objective(obj, par) 
            val = obj.val - par.a_rh - .5*par.pUp/par.W;
        end
        function grad = gen_gradient(obj, par, lse)
            grad = zeros(lse.THETA,lse.TAU);
            for tt = 1:lse.THETA
                ini = 1; fin = 0;
                cus = lse.segments(tt,1).customer;
                N   = sum(lse.XI);
                for t = 1:lse.TAU
                    seg = lse.segments(tt,t);
                    fin = fin + seg.tariff.O;
                    ph = obj.p(ini:fin);
                    grad(tt,t) = .5*(ph'*seg.U*ph*(N/par.W) - cus.pUp*(N/par.W)) - ...
                                 seg.rh*N - ...
                                 (cus.A + seg.B*ph)'*(obj.l + par.z*obj.et*par.e)*(N/par.W);     
                    ini = fin + 1;
                end
            end
            grad = vec(grad');
        end
    end
    
end

