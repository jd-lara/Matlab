function [lS, etS] = solve_cmin(par, D)
%SOLVE_CMIN Solves cost minimization problem
%  This is used to calibrate the demand system only in the cases where the
%  original prices are not known.

    % Simplifying notation
    c = par.c; r = par.r; 
    TWK = par.TWK; K = par.K; 
    W = par.W; SY = par.SY; 
    H = par.H; z = par.z;
    e = par.e; SR = par.SR;

    % Model to find anchor point
    % --------------------------
    cvx_begin quiet
        variable y(TWK)       % MWh Energy Production in Scenario W, period T by generator.
        variable x(K)         % MWh Capacity built per time slot (in MWh because one time slot is one hour). 
        dual variable l       % $/MWh
        dual variable et      % $/MWh marginal valuation of rps.

        minimize(c'*y/W + x'*r)
        % Constraints
        l:   SY*y/W - D/W >= 0;       % Market clearing.
             H*x/W - y/W >= 0;        % Capaity constraint
        et:  e'*(SR*y - z*D)/W >= 0;  % Renewable portfolio standard constraint.
             y >= 0; 
    cvx_end

    % Return solution
    lS = l; etS =et;
    
    display(['solution status of anchor point prices: ',cvx_status])


end

