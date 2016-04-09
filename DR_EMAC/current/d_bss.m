classdef d_bss < device
    %BSS Batery Storage System
    %   Detailed explanation goes here
    
    properties
        % Physical and behavioral properties
        eta_in  % [%] Total input efficiency considering rectifier
        eta_out % [%] Total output efficiency considering inverter
        SOC_max % [kWh] Max state of charge of the BSS
        SOC_min % [kWh] Minimum state of charge of the BSS
        Pmax    % [kW] Max power consumption
        S_0     % [kWh] Initial state of charge of the BSS 
        cont_ex % Matrix of device contribution to input fuel consumption
                
        % Math model parameters
        mathpar % Parameters of the mathematical model
        
        % Other parameters
        label % Device label
        affects_utility % Whether the device impacts the utility function (1 yes, 0 not)
        affects_constraint % Whether the device modifies the feasible region (1 yes, 0 not)
        % If the device does not affect utility nor the feasble region, its
        % demand is exogenous.
        
        % Solution parameters
        Ss     % [kWh] Vector of optimal states of charges
        p_in   % [kW] Optimal power input
        p_out  % [kW] Optimal power output
        
        % Auxiliar parameters
        par
        
    end
    
    methods
        function obj = d_bss(par, Pmax, SOC_max, SOC_min, eta_out, eta_in, S_0)
            if nargin > 0
                obj.par   = par;
                obj.Pmax  = Pmax;
                obj.SOC_max  = SOC_max;
                obj.SOC_min  = SOC_min;
                obj.eta_out   = eta_out;
                obj.eta_in   = eta_in;
                obj.S_0 = S_0;
                obj.label = 'bss';
                obj.affects_utility = 0;
                obj.affects_constraint = 1;
                obj.mathpar = p_mathpar();
                obj.gen_constraint_set();
                nfuel = obj.par.nfuel;
                obj.cont_ex = zeros(nfuel,2);
                obj.cont_ex(1,1) =  1;
                obj.cont_ex(1,2) = -1;
            end
        end        
        function obj = replicate(obj1)
            obj = d_bss();
            obj.par                = obj1.par;
            obj.Pmax               = obj1.Pmax;
            obj.SOC_max            = obj1.SOC_max;
            obj.SOC_min            = obj1.SOC_min;
            obj.eta_out            = obj1.eta_out;
            obj.eta_in             = obj1.eta_in;
            obj.S_0                = obj1.S_0;
            obj.label              = 'bss';
            obj.affects_utility    = 0;
            obj.affects_constraint = 1;
            obj.mathpar            = obj1.mathpar;
            obj.cont_ex            = obj1.cont_ex;
        end
        function gen_utility(obj)
        end    
        function gen_constraint_set(obj)
            
            % Constraints
            % S(p_{t}): S_{t+1}=S_{t}-[P^out_{t+1}*(1/eta_out)-P^in_{t+1}*(eta_in)]
            %        => S_{N} = S_0 - sum_{j=1}^{N}[[P^out_{N}*(1/eta_out)-P^in_{N}*(eta_in)
            %        The model can be simplified as follows: 
            %            Smin <= S(p) <= Smax
            %            0 <= P_out    <= Pmax
            %            0 <= P_in    <= Pmax
            
            Ps_max = obj.Pmax; e_out=obj.eta_out; e_in=obj.eta_in;
            T=obj.par.T; w=obj.par.W; S_max=obj.SOC_max; S_min=obj.SOC_min;
            S0=obj.S_0; TW = obj.par.TW; e = obj.par.e;
            
            % Output set A*p <= b;
            % Intermediate steps
            B1  = tril(ones(T));
            B  = [kron(eye(w),B1*e_in),kron(eye(w),B1*-1/e_out)];
                   
            %Final calculation
            A =   [  B;                     % RHS constraint of the SOC
                     -B;                    % LHS constraint of the SOC
                     eye(TW) , zeros(TW);   % Pmax constraint for Pin
                     -eye(TW) , zeros(TW);  % Lower bound for Pin
                     zeros(TW), eye(TW)  ;  % Pmax constraint for Pout
                     zeros(TW),-eye(TW) ];  % Lower bound for Pout
           obj.mathpar.set_A(A);
           b = [   (S_max-S0)*e;      % RHS constraint of the SOC
                     -1*(S_min-S0)*e; % LHS constraint of the SOC
                        (Ps_max)*e;   % Pmax constraint for Pin
                        zeros(TW,1);  % Lower Bound for Pin
                        (Ps_max)*e;   % Pmax constraint for Pout
                        zeros(TW,1)]; % Lower Bound for Pout
           obj.mathpar.set_b(b);          
        end    
        function dim = get_dim(obj)      
            % Provides the dimension of the demand vector
            dim = 2*obj.par.TW;
        end
        function set_sol(obj, ds)        
            % Generates solution profile for the device
            obj.p_in  = ds(1:obj.par.TW);
            obj.p_out = ds(obj.par.TW + 1:2*obj.par.TW);
            B         = obj.mathpar.A(1:obj.par.TW,:);
            obj.Ss    = obj.S_0*obj.par.e + B*ds;
        end
        function print_summary(obj)
            % Generates summary of plots fot the device
            e = obj.par.e;
            x = (1:obj.par.TW)';
            P_p = [obj.p_in,obj.p_out,obj.Pmax*e];
            S_p = [obj.Ss,obj.SOC_max*e,obj.SOC_min*e];
            
            figure
            set(gcf,'numbertitle','off','name',strcat('Summary TCL-',obj.label))
            subplot(2,1,1)
            plot(x,P_p)
            legend('p_{in}','p_{out}','p_{max}',...
                   'Location','southoutside','Orientation','horizontal')
            ylabel('kW')   
            title('power')
                        
            subplot(2,1,2)
            plot(x,S_p)
            legend('S','S_{max}','S_{min}',...
                   'Location','southoutside','Orientation','horizontal')
            ylabel('kWh')   
            title('state of charge')
        end
    end
    
end

