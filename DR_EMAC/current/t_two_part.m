classdef t_two_part < tariff
    %T_TWO_PART Non-linear, two-part tariff.
    %   Under this broad category of rates fall the two-part RTP, TOU, Flat Rate.
    %   It allos enetering values for each of the parameters of the rates as exogenous elements.
    
    properties 
        % Categorical paramaters
        label  % Type of tariff 1: flat-rate, 2: TOU, 3: RTP
        endogenous % Whether the rate is determined endogenously or exogenously.
                        
        % Math model parameters: Define how prices are constrained.
        mathpar
        
        % Solution parameters
        p    % Price profile  
        F    % fixed charge
        
        % Auxiliar parameters
        par    
    end
    
    methods
        
        function obj = t_two_part(M, label, par, p, F)
            if nargin > 0
                obj.mathpar = p_mathpar();
                obj.mathpar.set_M(M);
                O = size(M,2);
                obj.mathpar.set_O(O);
                obj.label = label;
                obj.par = par;
                if nargin > 4
                    obj.endogenous = 0;
                    obj.p = p;
                    obj.F = F;
                else
                    obj.endogenous = 1;
                end
            end    
        end            
        function obj1 = replicate(obj)
            % generates a replica of the object
            % attributes point to the original device.
            obj1 = t_two_part();
            obj1.mathpar = obj.mathpar;
            obj1.label = obj.label;
            obj1.par = obj.par;
            if not(obj.endogenous)
                obj1.endogenous = 0;
                obj1.p = obj.p;
                obj1.F = obj.F;
            else
                obj1.endogenous = 1;
            end
        end
        function set_sol(obj, ds, ps, ls, fc)        
            % Set solution profile for the device
            M = obj.mathpar.M;
            obj.p = ps;
            obj.F = ds'*(ls - M*ps)/obj.par.W + fc;
        end
        function M = get_M(obj)
            M = obj.mathpar.M;
        end
        function O = get_O(obj)
            O = obj.mathpar.O;
        end  
    end
    
end