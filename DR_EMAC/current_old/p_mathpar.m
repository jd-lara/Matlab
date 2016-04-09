classdef p_mathpar < handle
    %D_MATHPAR Demand side math model parameters
    %   The parameters for the mathematical model are saved in this class 
    %   so that they are not duplicated when not needed.
    
    properties        
        U     % Quadratic term in the utility function
        u     % Linear term in the utility function
        A     % Matrix of the constraint set
        b     % Vector of the constraint set
        S     % Matrix of contribution to total power consumption 
        d     % Aggregated exogenous demand
        % Two-part tariffs parameters
        M     % Converts from O dimensional to TW dimensional
        O     % Number of time windows for the customers
    end
    
    methods
        function obj = p_mathpar()
        end
        function set_U(obj, U)
            obj.U = sparse(U);
        end
        function set_u(obj, u)
            obj.u = sparse(u);
        end
        function set_A(obj, A)
            obj.A = sparse(A);
        end
        function set_b(obj, b)
            obj.b = sparse(b);
        end
        function set_S(obj, S)
            obj.S = sparse(S);
        end
        function set_d(obj, d)
            obj.d = sparse(d);
        end
        function set_M(obj, M)
            obj.M = sparse(M);
        end
        function set_O(obj, O)
            obj.O = sparse(O);
        end
    end
    
end

