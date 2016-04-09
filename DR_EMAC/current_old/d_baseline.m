classdef d_baseline < device
    %BASELINE Baseline consumption
    %   All devices added up to form the baseline consumption of a
    %   customer.
    %   This version assumes that for baseline devices there is only
    %   own price elastcity, and that the consumer preferences are 
    %   quadratic.
    %   The problem is the following
    %   max U(x) - px, where U(x) is a quadratic function
    
    properties
        % Physical and behavioral properties
        ope % Own price elasticty
        d0  % [kWh] Demand baseline (vector TW)
        p0  % [$/kWh] Price vector faced by the customer when d0 happens
        
        % Math model parameters
        mathpar % Parameters of the mathematical model
        
        % Other parameters
        label % Device label
        affects_utility % Whether the device impacts the utility function (1 yes, 0 not)
        affects_constraint % Whether the device modifies the feasible region (1 yes, 0 not)
        % If the device does not affect utility nor the feasble region, its
        % demand is exogenous.
        
        % Solution parameters
        ds  % [kW] Optimal power consumption
        
        % Auxiliar parameters
        par
    end
    
    methods
        function obj = d_baseline(par, ope, d0, p0)
            if nargin > 0
                obj.ope = ope;
                obj.d0  = d0;
                obj.p0  = p0;
                obj.par = par;
                obj.label = 'baseline';
                obj.affects_utility = 1;
                obj.affects_constraint = 0;
                obj.mathpar = p_mathpar();
                obj.gen_utility();
                obj.mathpar.set_S(eye(par.TW));
            end
        end
        function obj1 = replicate(obj)
            obj1 = d_baseline();
            obj1.ope = obj.ope;
            obj1.d0  = obj.d0;
            obj1.p0  = obj.p0;
            obj1.par = obj.par;
            obj1.label = 'baseline';
            obj1.affects_utility = 1;
            obj1.affects_constraint = 0;
            obj1.mathpar = obj.mathpar;           
        end
        function gen_utility(obj)
            U = sparse(diag(0.5*(obj.p0 ./ obj.d0)/obj.ope));
            obj.mathpar.set_U(U);
            u = obj.p0 - U*obj.d0;
            obj.mathpar.set_u(u);
        end
        function gen_constraint_set(obj)
            % Do nothing in the case of this object.
        end 
        function dim = get_dim(obj)      
            % Provides the dimension of the demand vector
            dim = size(obj.mathpar.S,2);
        end
        function set_sol(obj, ds)        
            % Generates solution profile for the device
            obj.ds = ds;
        end
        % Useful for debugging
        function print_summary(obj)
            % Generates summary of plots fot the device
            x = (1:obj.par.TW)';
            P_p = [obj.ds, obj.d0];
                        
            figure
            set(gcf,'numbertitle','off','name',strcat('Summary baseline'))
            plot(x,P_p)
            ylabel('kW')
            legend('p','p_0',...
                   'Location','southoutside','Orientation','horizontal')
            title('power')            
        end
    end
    
end

