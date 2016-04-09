classdef parameters < handle
    %PARAMETERS Parameters of mathematical models.
    %   Detailed explanation goes here
    
    properties
        z         % Policy -> Renewable portfolio standard.
        A         % Demand system -> Intercept.
        B         % Demand system -> Jacobian.
        U         % Utility function -> Matrix of quadratic coefficients.
        pUp       % Utility function -> Constant term.
        a_rh      % Segment -> Scalar corresponding to the multiplication a*rh.
        a         % Segment -> Matrix of number of customers in each segment (THETAxTAU).
        a0        % Segment -> Initial # of customer in each segment. Useful for searching algorithm. 
        ub        % Segment -> Fractional upper bound for segments.
        c         % Variable cost of generation.
        ro        % Availability factor.
        r         % Fixed cost (anualized (T) fixed operation plus capital cost).
        K         % # of supply-side technologies. 
        W         % # of states of the world.
        T         % # of periods.
        nfuel     % # of fuels types considered in the instance.
        % Auxiliar parameters
        e         % Vector of ones dimension TW.
        eRPS      % Vector for dim K with 1 if tech k receives RPS credit.    
        SY        % Transformation to compute production per scenario and period (TW x TWK).
        SD        % Transformation to compute aggregated demand per scenario and period (TW x TW*THETA) 
        SR        % Tranformation to compute renewable production per scenario and period transformation (TW * TWK).
        H         % Total capacity per scenario transformation x.
        TW        % Auxiliary variable. 
        TWK       % Auxiliary variable.
        O         % Total number of time windows (summation over all tariffs)
    end
    
    methods
        function obj = parameters(z, c, ro, r, K, W, T, eRPS, THETA, a0, ub, nf)
            obj.z     = z;
            obj.c     = c;
            obj.ro    = ro;
            obj.r     = r;
            obj.K     = K;
            obj.W     = W;
            obj.T     = T;
            obj.nfuel = nf;
            obj.a0    = a0;
            obj.ub    = ub;
            obj.TW    = T*W; obj.TWK = obj.TW*K;
            obj.e     = ones(obj.TW,1); 
            ek        = ones(1,obj.K);
            ed        = ones(1,THETA);
            obj.eRPS  = eRPS;
            obj.SY    = sparse(kron(ek,eye(obj.TW)));
            obj.SD    = sparse(kron(ed,eye(obj.TW)));
            obj.SR    = sparse(kron(eRPS',eye(obj.TW)));
            obj.H     = sparse(kron(eye(obj.K),obj.e).*repmat(ro,[1 K]));
        end
        function set_O(obj, lse)
            % Computes the number of time-windows across all tariffs
            obj.O = 0;
            for t = 1:lse.TAU
                obj.O = obj.O + lse.segments(1,t).tariff.O;
            end            
        end
        function update_demand_parameters(obj, a, lse)
            % Receives vector 'a' THETA*TAU
            obj.a = vec2mat(a,lse.TAU);
            % Unscale 'a'
            obj.a = obj.a*sum(lse.XI);
            obj.update_a_rh(lse);
            obj.update_demand_system(lse);
            obj.update_utility_function(lse);
        end
        function update_a_rh(obj, lse)
            obj.a_rh = sum(vec(obj.a.*lse.get_Mrh));
        end    
        function update_demand_system(obj, lse)
            % Computes the aggregated demand system for the current value a
            Baux = zeros(lse.THETA*obj.TW,obj.O);
            Aaux = zeros(lse.THETA*obj.TW, 1);
            a_tt = 0;
            r_ini = 1; r_fin = 0;
            for tt = 1:lse.THETA
                c_ini = 1; c_fin = 0;
                r_fin = r_fin + obj.TW;
                for t = 1:lse.TAU
                    c_fin = c_fin + lse.segments(tt,t).tariff.O;
                    Baux(r_ini:r_fin,c_ini:c_fin) = obj.a(tt,t)*lse.segments(tt,t).B;
                    a_tt = a_tt + obj.a(tt,t);
                    c_ini = c_fin + 1;                     
                end
                Aaux(r_ini:r_fin) = a_tt*lse.segments(tt,1).customer.A;
                a_tt = 0;
                r_ini = r_fin + 1; 
            end
            Baux = sparse(Baux); Aaux = sparse(Aaux);            
            obj.A = sparse(obj.SD*Aaux);
            obj.B = sparse(obj.SD*Baux);
        end 
        function update_utility_function(obj, lse)
            obj.U = zeros(obj.O);
            U_tt = zeros(obj.O);
            obj.pUp = 0;
            for tt = 1:lse.THETA
                a_tt = 0;
                ini = 1; fin = 0;
                for t = 1:lse.TAU
                    fin = fin + lse.segments(tt,t).tariff.O;
                    U_tt(ini:fin,ini:fin) = lse.segments(tt,t).U*obj.a(tt,t);
                    a_tt = a_tt + obj.a(tt,t);
                    ini = fin + 1;
                end
                obj.U = obj.U + U_tt;
                obj.pUp = obj.pUp + a_tt*lse.segments(tt,t).customer.pUp;
            end 
            obj.U = sparse(obj.U);
        end 
        function [a0, Aeq, beq, lb, ub] = gen_master_param(obj,lse)
            a0 = vec(obj.a0');
            Aeq = kron(lse.ALPHA,ones(1,lse.TAU));
            beq = lse.XI/sum(lse.XI);
            lb = zeros(lse.THETA*lse.TAU,1);
            ub = obj.ub;
        end    
    end
    
end

