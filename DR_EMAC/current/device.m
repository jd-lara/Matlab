classdef (Abstract) device < handle & matlab.mixin.Heterogeneous
    %DEVICE Customer device
    %   This is an abstract of customer devices.
    
    properties (Abstract)
        % Physical and behavioral properties
        cont_ex % Matrix of devices contribution to input fuel consumption
                % In position ij it has:
                %  1 if the device j consumes fuel i
                %  0 if the device j neither consumes nor produces fuel i
                % -1 if the device j produces fuel i
                % Obs: We consider that a battery storage system has two
                % devices one that consumes an other that produces
                % electrcity.                
                        
        % Math model parameters
        mathpar    
        
        % Other parameters
        label % Device label
        affects_utility % Whether the device impacts the utility function (1 yes, 0 not)
        affects_constraint % Whether the device modifies the feasible region (1 yes, 0 not)
        % If the device does not affect utility nor the feasble region, its
        % demand is exogenous.
        
        % Auxiliar parameters
        par    
    end
    
    methods (Abstract)
        obj = replicate(obj)    % generates a replica of the object
                                % attributes point to the original device.
        gen_utility(obj)        % Generates the parameters of the utility 
                                % associated to the device.
        gen_constraint_set(obj) % Generates the constraint set associated
                                % to the device.
        % Useful for debugging
        print_summary(obj)      % Print relevant profiles of the device
                               
    end
    methods (Static, Sealed, Access = protected)  
        function default_object = getDefaultScalarElement
            default_object = baseline;
        end
    end
    
end

