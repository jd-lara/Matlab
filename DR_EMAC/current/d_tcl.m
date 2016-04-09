classdef d_tcl < device
    %TCL
    %   Detailed explanation goes here
    
    properties
        % Physical and behavioral properties
        beta % [$/(C)^2] Parameter that determines how consumers trade comfort v/s savings
        Oobj % [C] Thermostat temperature target
        Omin % [C] Min temperature
        Omax % [C] Max temperature
        Pmin % [kW] Min power consumption
        Pmax % [kW] Max power consumption
        R    % [C/kW] Thermal resistance
        C    % [kWh/C] Thermal capacitance of the interior space  
        eta  % Heat rate (convetion: (+) for heating and (-) cooling)
        Oout % [C] Vector of outside temperatures.
        fuel % id of fuel type
        comp % Whether the TCL belongs to a composite TCL. 1 True, 0 False
        cont_ex % Matrix of device contribution to input fuel consumption

        % Other parameters
        O    % Temperature function
        
        % Math model parameters
        mathpar % Parameters of the mathematical model
        
        % Other parameters
        label % Device label
        affects_utility % Whether the device impacts the utility function (1 yes, 0 not)
        affects_constraint % Whether the device modifies the feasible region (1 yes, 0 not)
        % If the device does not affect utility nor the feasble region, its
        % demand is exogenous.
        
        % Solution parameters
        Os  % [C] Temperature profile associated to optimal power consumption
        ds  % [kW] Optimal power consumption
        
        % Auxiliar parameters
        par
        
    end
    
    methods
        function obj = d_tcl(par, beta, Oobj, Omin, Omax, Pmin, Pmax, R, ...
                             C, eta, Oout, label, fuel, comp)
            if nargin > 0
                obj.par   = par;
                obj.beta  = beta;
                obj.Oobj  = Oobj;
                obj.Omin  = Omin;
                obj.Omax  = Omax;
                obj.Pmin  = Pmin;
                obj.Pmax  = Pmax;
                obj.R     = R;
                obj.C     = C;
                obj.eta   = eta;
                obj.Oout  = Oout;
                obj.label = label;
                obj.fuel  = fuel;
                obj.comp  = comp;
                if not(comp)
                    obj.affects_utility = 1;
                    obj.affects_constraint = 1;
                    nfuel = obj.par.nfuel;
                    obj.cont_ex = zeros(nfuel,1);
                    obj.cont_ex(obj.fuel) = 1;
                    obj.mathpar = p_mathpar();
                    obj.gen_temp_transform();
                    obj.gen_utility();
                    obj.gen_constraint_set();                    
                end
            end
        end
        function obj = replicate(obj1)
            obj = d_tcl();
            obj.par   = obj1.par;
            obj.beta  = obj1.beta;
            obj.Oobj  = obj1.Oobj;
            obj.Omin  = obj1.Omin;
            obj.Omax  = obj1.Omax;
            obj.Pmin  = obj1.Pmin;
            obj.Pmax  = obj1.Pmax;
            obj.R     = obj1.R;
            obj.C     = obj1.C;
            obj.eta   = obj1.eta;
            obj.Oout  = obj1.Oout;
            obj.label = obj1.label;
            obj.fuel  = obj1.fuel;
            obj.comp  = obj1.comp;
            if not(obj1.comp)
                obj.affects_utility    = 1;
                obj.affects_constraint = 1;
                obj.cont_ex            = obj1.cont_ex;
                obj.mathpar            = obj1.mathpar;
                obj.O                  = obj1.O;                 
            end
        end    
        function gen_temp_transform(obj)
            % This function defines the relationship between power and
            % temperature. It uses a first order thermal model.
            % The thermal model is the following
            % C*dO/dt = p(t)/eta - (O(t) - Oout(t))/R
            % The solution is
            % O_(t+dt) = a1*O_t + a2*Oout_t + a3*p_t (coeffs defined bellow)
            % It assumes that Oout and p are constant during dt.
            % Besides, it assumes that in each cycle the last period 
            % is equal to the first. 
            
            dt = 1;          % Time step in hour. 
            a1 = exp(-dt/obj.C/obj.R);
            a2 = 1 - a1;
            a3 = a2*obj.R/obj.eta;
            
            T = obj.par.T;
            
            % Temperature transformation O(p) = O1*p + O2
            M = eye(T)*a1^(T-1);
            for j = 1:T-1
                M = M + diag(ones(1,T-j),-j)*a1^(j-1);
                M = M + diag(ones(1,T-j), j)*a1^(T-1-j);
            end
            IW = eye(obj.par.W);
            M  = kron(IW, M/(1 - a1^T));
            obj.O = p_temperature(a3*M, a2*M*obj.Oout);
        end        
        function gen_utility(obj)
            % Generates the parameters of the utility associated to the TCL
            % Element of utility function
            % - 0.5*beta*(O(p) - Tobj)'*(O(p) - Tobj)
            O1 = obj.O.O1; O2 = obj.O.O2; Oobj = obj.Oobj; b = obj.beta;
            obj.mathpar.set_U(- 0.5*b*O1'*O1);
            obj.mathpar.set_u(- b*O1'*(O2 - Oobj));
        end        
        function gen_constraint_set(obj)
            % Constraints
            %            Omin <= O(p) <= Omax
            %            Pmin <= p    <= Pmax
            O1 = obj.O.O1; O2 = obj.O.O2; Omax = obj.Omax; Omin = obj.Omin;
            Pmax = obj.Pmax; Pmin = obj.Pmin; e = obj.par.e; I = diag(e);
            
            % Output set A*p <= b;
            obj.mathpar.set_A([O1; -O1; I; -I]);
            obj.mathpar.set_b([Omax*e - O2 ; - Omin*e + O2; Pmax*e  ; - Pmin*e]);            
        end
        function dim = get_dim(obj)      
            % Provides the dimension of the variables of the TCL
            dim = obj.par.TW;
        end
        function set_sol(obj, ds, Os)        
            % Generates solution profile for the device
            obj.ds = ds;
            if nargin > 2
                obj.Os = Os;
            else    
                obj.Os = obj.O.gen_temp(ds);
            end
        end
        % Useful for debugging
        function print_summary(obj)
            % Generates summary of plots fot the device
            e = obj.par.e;
            x = (1:obj.par.TW)';
            P_p = [obj.ds,obj.Pmax*e,obj.Pmin*e];
            O_p = [obj.Os,obj.Omax*e,obj.Omin*e,obj.Oobj*e,obj.Oout];
            
            figure
            set(gcf,'numbertitle','off','name',strcat('Summary TCL-',obj.label))
            subplot(2,1,1)
            plot(x,P_p)
            legend('p','p_{max}','p_{min}',...
                   'Location','southoutside','Orientation','horizontal')
            ylabel('kW')   
            title('power')
                        
            subplot(2,1,2)
            plot(x,O_p)
            legend('t_{in}','t_{max}','t_{min}','t_{obj}','t_{out}',...
                   'Location','southoutside','Orientation','horizontal')
            ylabel('C')   
            title('temperature')
        end
    end
    
end

