classdef simulations < handle
    %SIMULATIONS Manages the simulations of the analysis
    %   Every time we change the parameters over which we perfom
    %   the analysis, we have to change the variables of this object and the
    %   funciton update. The idea is that, for an specific analysis, we
    %   change this function but not the other classes.
    
    properties
        N % Number of simulations
        NC % Number of columns of C
        C % Matrix where each row is a run and
        % columns are the parameters characterizing a simulation.
        % C1: [Na] Portfolio of tariff. 0 = FR + TOU and 1 = FR + TOU + RTP
        % (I do not use this column for updating)
        % C2: [#] Own-price elasticity without customer system
        % C3: [#] Own-price elasticity with customer system
        % C4: [#] Cross-price elasticity without customer system
        % C5: [#] Cross-price elasticity with customer system
        % C6: [#] RPS
        % C7: [2014$/ctmr-day] Incremental cost AMI
        % C8: [2014$/ctmr-day] Capital cost customer system
        % Parameter useful fot updating faster the data
        IE   % Input for elasticities.
        a_tt % Initial number of customer under each ex-post type.
    end
    
    methods
        function obj = simulations(C, a_tt, IE)
            obj.C    = C;
            obj.N    = size(obj.C,1);
            obj.NC   = size(obj.C,2);
            obj.a_tt = a_tt;
            obj.IE   = IE;
        end
        function update_data(obj, par, w_m, n_s)
            data = obj.C(n_s,2:obj.NC); 
            lse = w_m.lse;
            
            % Update tech costs
            for t = 1:lse.TAU
                lse.segments(2,t).rh = data(7);
                lse.segments(3,t).rh = data(7) + data(8);
            end
            
            % Potentially new elasticity parameters
            NewIE = obj.IE;
            NewIE(1,1:2) = [data(2), data(4)];
            NewIE(2,1:2) = [data(2), data(4)];
            NewIE(3,1:2) = [data(3), data(5)];
            
            % Deciding what to update
            if n_s == 1
                update1 = 1;
                obj.IE = NewIE;
                par.z = data(6);
            else
                update1 = 0; update2 = 0;
                if not(isequal(obj.IE,NewIE)) 
                    obj.IE = NewIE;
                    update1 = 1;
                end
                if not(par.z == data(6))
                    par.z = data(6);
                    update2 = 1;
                end
            end                 
                       
            % Update demand system
            if update1
                lse.set_demands_v0(obj.IE);
                t0 = lse.compute_anchor_price;
                lse.set_segments_vf(t0);
            else
                if update2
                    t0 = lse.compute_anchor_price;
                    lse.set_segments_vf(t0);
                end    
            end                        
            
        end
        function ID_SIM = get_ID_SIM(obj, n_s)
            ID_SIM = obj.C(n_s,1);
        end    
    end
    
end

