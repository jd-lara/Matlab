function solve_wmax(par, sol)
%SOLVE_WMAX Summary of this function goes here
%   Detailed explanation goes here

   % Simplifying notatioin 
   B = par.B; A = par.A; c = par.c; r = par.r;
   S = par.SY; H = par.H; TWK = par.TWK; K = par.K; TW = par.TW;
   e = par.e; W = par.W; SR = par.SR; z = par.z;
   O = par.O; U = par.U;

   % Welfare maximization program
   % ----------------------------
   cvx_begin quiet
        variable y(TWK)       % MWh Energy production in scenario W, period T by generator.
        variable x(K)         % MWh Capacity built per time slot (in MWh because one time slot is one hour). 
        variable p(O)         % $/MWh retail variable charges;
        dual variable l       % $/MWh marginal valuation of consumption (lambda).
        dual variable et      % $/MWh marginal valuation of rps.

        maximize( (.5*p'*U*p - c'*y)/W - x'*r )
        % Constraints
        l:        S*y/W - (A + B*p)/W >= 0;  % Market clearing.
                          H*x/W - y/W >= 0;  % Max capacity.
        et: e'*(SR*y - z*(A + B*p))/W >= 0;  % Renewable portfolio standard constraint.
                                    p >= 0;
                                    y >= 0;
    cvx_end

    % Record solution
    sol.update(y, x, p, l, et, cvx_optval);
end

