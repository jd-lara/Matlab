classdef p_temperature
    %P_TEMPERATURE Temperature profile for a given power profile
    %   This object allows not duplicate information/
    
    properties
        O1   % Matrix of power to temperature transformation
        O2   % Vector of power to temperature transformation
    end
    
    methods
        function obj = p_temperature(O1,O2)
            obj.O1 = O1;
            obj.O2 = O2;
        end
        function O = gen_temp(obj,p)
            O = obj.O1*p + obj.O2;
        end    
    end
    
end

