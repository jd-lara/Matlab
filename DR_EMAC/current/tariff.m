classdef (Abstract) tariff < handle & matlab.mixin.Heterogeneous
    % Abstract class tariff
    
    properties (Abstract)
        label % Name of the tariff
        endogenous % Whether the rate is determined endogenously or exogenously.
        
        % Math model parameters: Define how prices are constrained.
        mathpar
        
        % Auxiliar parameters
        par         
    end
    
    methods (Abstract)
        obj = replicate(obj)    % generates a replica of the object
                                % attributes point to the original tariff
                                % This helps saving memory
        set_sol(obj, sol)
    end
    methods (Static, Sealed, Access = protected)  
        function default_object = getDefaultScalarElement
            default_object = t_two_part;
        end
    end

end