classdef d_tcl_comp < device
    %Composite TCL
    %   Generates a composite TCL. This object is designed to model
    %   a set of TCL's that affect the same comfort metrics
    %   such as inside temperature.
    
    
    properties
        % Physical and behavioral properties (S = shared property)
        beta % [$/(C)^2] (S) Parameter that determines how consumers trade comfort v/s savings
        Oobj % [C] (S) Thermostat temperature target
        Omin % [C] Min temperature (max of min temp of component devices)
        Omax % [C] Max temperature (min of max temp of component devices)
        R    % [C/kW] (S) Thermal resistance of the building
        C    % [kWh/C] (S) Thermal capacitance of the interior space  
        Oout % [C] (S) Vector of outside temperatures.
        cont_ex % Matrix of devices contribution to input fuel consumption       
                        
        % Auxiliar parameters
        O       % Temperature linear transformation
        devices % Set of devices
        ndev    % Number of devices
        cont_cm % array of contribution of device to comfort metric
                % Important: This array contains the heat rates of the 
                % TCL's.
        par        
                
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
        ds  % [kW] Matrix of aggregated optimal power consumption. One per fuel type.               
    end
    
    methods
        function obj = d_tcl_comp(par, devices)
            if nargin > 0
                obj.devices = devices;
                obj.ndev  = size(devices,2);
                obj.par   = par;
                obj.gen_parameters;
            end
        end
        function gen_parameters(obj)
            % For the shared paramerest, this procedure considers
            % the parameters of the first TCL in the array of 
            % devices. The researcher has
            % to be careful when creating the composite TCL
            
            % Shared parameters
            obj.beta  = obj.devices(1).beta;
            obj.Oobj  = obj.devices(1).Oobj;
            obj.R     = obj.devices(1).R;
            obj.C     = obj.devices(1).C;
            obj.Oout  = obj.devices(1).Oout;
            obj.affects_utility = 1;
            obj.affects_constraint = 1;
            obj.mathpar = p_mathpar();
                        
            % Aggregated parameters
            nfuel = obj.par.nfuel;
            obj.cont_ex = zeros(nfuel,obj.ndev);
            obj.cont_cm = ones(1,obj.ndev);
            IOmin = 0; IOmax = 10000;
            obj.label = '';
            for k = 1:obj.ndev
                dev = obj.devices(k);
                obj.cont_ex(dev.fuel,k) = 1;
                obj.cont_cm(k) = 1/dev.eta;
                if dev.Omin > IOmin
                    IOmin = dev.Omin;
                end
                if dev.Omax < IOmax
                    IOmax = dev.Omax;
                end
                obj.label = strcat(obj.label,'+',dev.label); 
            end
            obj.Omin  = IOmin;
            obj.Omax  = IOmax;
            obj.label = obj.label(2:size(obj.label,2));
            obj.gen_temp_transform();
            obj.gen_utility();
            obj.gen_constraint_set();
        end
        function obj = replicate(obj1)
            obj                    = d_tcl_comp();
            obj.devices            = d_tcl();
            obj.devices(obj1.ndev) = d_tcl();
            for k = 1:obj1.ndev
                obj.devices(k) = obj1.devices(k).replicate;
            end
            obj.ndev               = obj1.ndev;
            obj.par                = obj1.par;
            obj.beta               = obj1.beta;
            obj.Oobj               = obj1.Oobj;
            obj.Omin               = obj1.Omin;
            obj.Omax               = obj1.Omax;
            obj.R                  = obj1.R;
            obj.C                  = obj1.C;
            obj.cont_ex            = obj1.cont_ex;            
            obj.cont_cm            = obj1.cont_cm;
            obj.Oout               = obj1.Oout;
            obj.label              = obj1.label;
            obj.affects_utility    = 1;
            obj.affects_constraint = 1;
            obj.mathpar            = obj1.mathpar;
            obj.O                  = obj1.O;
        end
        function gen_temp_transform(obj)
            % This function defines the relationship between power and
            % temperature. It uses a first order thermal model.
            % The thermal model is the following
            % C*dO/dt = p(t)/eta - (O(t) - Oout(t))/R
            % The solution is of the form
            % O_(t+dt) = a1*O_t + a2*Oout_t + a3*p_t (coeffs defined bellow)
            % It assumes that Oout and p are constant during dt.
            % Besides, it assumes that in each cycle the last period 
            % is equal to the first. 
            
            dt = 1;          % Time step in hours. 
            a1 = exp(-dt/obj.C/obj.R);
            a2 = 1 - a1;
            a3 = a2*obj.R;
            
            T = obj.par.T;
            TW = obj.par.TW;
            
            % Temperature transformation O(p) = O1*p + O2
            M = eye(T)*a1^(T-1);
            for j = 1:T-1
                M = M + diag(ones(1,T-j),-j)*a1^(j-1);
                M = M + diag(ones(1,T-j), j)*a1^(T-1-j);
            end
            IW = eye(obj.par.W);
            M  = kron(IW, M/(1 - a1^T));
            S  = kron(obj.cont_cm, eye(TW));
            obj.O = p_temperature(a3*M*S, a2*M*obj.Oout);
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
            %            Omin <= O(p) <= Omax
            %            Pmin <= p    <= Pmax
            O1 = obj.O.O1; O2 = obj.O.O2; Omax = obj.Omax; Omin = obj.Omin;
            TW = obj.par.TW;
            I = eye(TW*obj.ndev);
            Pmax = zeros(obj.ndev,1); Pmin = Pmax;
            for k = 1:obj.ndev
                dev = obj.devices(k);
                Pmax(k) = dev.Pmax; Pmin(k) = dev.Pmin;
            end
            Pmax = kron(Pmax,ones(TW,1)); Pmin = kron(Pmin,ones(TW,1));
            e = obj.par.e;
            
            % Output set A*p <= b;
            obj.mathpar.set_A([O1; -O1; I; -I]);
            obj.mathpar.set_b([Omax*e - O2 ; - Omin*e + O2; Pmax  ; - Pmin]);            
        end
        function dim = get_dim(obj)      
            % Provides the dimension of the demand vector
            dim = obj.ndev*obj.par.TW;
        end
        function set_sol(obj, ds)        
            % Generates solution profile for the device
            TW = obj.par.TW; nfuel = obj.par.nfuel;
            obj.ds = zeros(TW,nfuel);
            obj.Os = obj.O.gen_temp(ds);
            fin = 0; ini = fin + 1;
            for k = 1:obj.ndev
                dev = obj.devices(k);
                fin = fin + TW;
                dev.set_sol(ds(ini:fin,1), obj.Os);
                ini = fin + 1;
                obj.ds(:,dev.fuel) = obj.ds(:,dev.fuel) + dev.ds; 
            end
        end
        % Useful for debugging
        function print_summary(obj)
            % Generates summary of plots fot the device
            e = obj.par.e;
            x = (1:obj.par.TW)';
            P_p = obj.ds;
            O_p = [obj.Os,obj.Omax*e,obj.Omin*e,obj.Oobj*e,obj.Oout];
            
            figure
            set(gcf,'numbertitle','off','name',strcat('Summary TCL-',obj.label))
            subplot(2,1,1)
            plot(x,P_p)
            if size(obj.ds,2) > 1
                legend('p','p_gas','Location',...
                       'southoutside','Orientation','horizontal')
            else
                legend('p','Location',...
                       'southoutside','Orientation','horizontal')
            end
            ylabel('kW')   
            title('power')
                        
            subplot(2,1,2)
            plot(x,O_p)
            legend('t_{in}','t_{max}','t_{min}','t_{obj}','t_{out}',...
                   'Location','southoutside','Orientation','horizontal')
            ylabel('C')   
            title('temperature')
            
            % Graphs for individual TCL's
            for k = 1:obj.ndev
                dev = obj.devices(k);
                dev.print_summary;
            end
        end
    end
    
end

