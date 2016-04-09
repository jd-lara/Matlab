classdef segment < handle
    %SEGMENT Combination of a traiff with a customer
    
            
    properties
        customer % Customer associated to the segment.
        tariff   % Tariff associated to the segment.
        d_o      % Segment demand vector (optimum).
        p_o      % Segment price vector (optimum).
        
        % Output for reporting. All maginitudes are expected values.
        GS      % Segment gross surplus.
        VC      % Segment total variable charge.
        FC      % Segment fixed charge.
        Bill    % Electrcity bill: Variable + FC.
        CS      % Segment net surplus GS - VC - FC.
        X       % Peak demand.  [MW]
        TD      % Customer total demand. 
        D       % Vector of demand (scenario and period)
        
        % Auxiliar parameters
        par
    end
    
    methods (Access = public)
        function obj = segment(customer, tariff)
            if nargin > 0
                obj.customer = customer;
                obj.tariff = tariff;
                obj.par = obj.customer.par;
            end    
        end        
        function find_demand_and_prices_1(obj,l)
            % This procedure solves bilevel model
            % using the big M method. Basically,  
            % it formulates the bilevel problem as a quadratic mixed 
            % integer programming
            
            % Load parameters
            U = obj.customer.get_U;
            u = obj.customer.get_u;
            S = obj.customer.get_S;
            A = obj.customer.get_A;
            b = obj.customer.get_b;
            M = obj.tariff.get_M;
            O = obj.tariff.get_O;
            dim = obj.customer.dim;
            dim_c = obj.customer.dim_c;
            de = obj.customer.get_d;
            
            % This model assumes that excess energy is spilled.
            cvx_solver gurobi
            cvx_begin
                variable d(dim)     % Household consumption per device
                variable p(O)       % Total customer consumption
                if dim_c > 0
                variable dta(dim_c) % Dual variable of the customer constraint
                % Auxiliar variables for big m formulation
                variable v_c(dim_c) binary
                variable v_dta(dim_c) binary
                end                
                                
                maximize( d'*U*d + u'*d - l'*(S*d + de) )
                
                    2*U*d + u - A'*dta - S'*M*p == 0;                                
                           1000*v_c - (b - A*d) >= 0;
                               1000*v_dta - dta >= 0;    
                                      (b - A*d) >= 0;
                                            dta >= 0;
                              1 - (v_c + v_dta) >= 0; 
                                              d >= 0;
            cvx_end
            
            obj.customer.set_sol(d);
            obj.tariff.set_sol(S*d,p,l,0);
       %     obj.d = S*d;               % Compute total consumer consumption.
       %     obj.p = U*d + u - A'*dta;  % Compute household variable charge.
        end
        function find_demand_and_prices_2(obj,l)
            % This procedure solves bilevel model
            % using an alternative prodecure to the big M method
            % This procedure finds a solution 
            % Setting the retail price as the price as the optimal price
            % provided that there no constraint in the feasible region 
            % of the customer problem. For the moment, this procedure
            % is heuristic.
            
            % Load parameters
            U = obj.customer.get_U;
            u = obj.customer.get_u;
            S = obj.customer.get_S;
            A = obj.customer.get_A;
            b = obj.customer.get_b;
            M = obj.tariff.get_M;
            dim = obj.customer.dim;
            de = obj.customer.get_d;
            
            % Consider d(p) = argmax{d'*U*d + u'*d - (M*p)'*(S*d + de)}
            % Then, d(p) = IU/2*(S'*M*p - u), where IU = U^(-1)
            
            % Step 1: Set p = argmax{d(p)'*U*d(p) + u'*d(p) - l'*(S*d(p) + de)}
            % Then, p_o = (M'*S*IU*S'*M)^(-1)*(M'*S*IU*S'*l)
            MS = M'*S;
            MSUS = MS/U*S';
            obj.p_o = MSUS*M\(MSUS*l);
            
            % Step 2: Find d_o = argmax{U(d) - (M*p_o)'*(S*d + de): A*d - b <= 0}
            cvx_solver gurobi
            cvx_begin
                variable d(dim)     % Household consumption per device
                
                maximize( d'*U*d + u'*d - (M*obj.p_o)'*(S*d + de) )
                
                          (b - A*d) >= 0;
                                  d >= 0;
            cvx_end
            
            obj.d_o = S*d;
            obj.customer.set_sol(d);
            obj.tariff.set_sol(obj.d_o,obj.p_o,l,0);
            
        end
        % Useful for debugging
        function print_summary(obj,l)
            % Generates summary of plots fot the segment
            n = obj.customer.ndev + 2;
            x = (1:obj.par.TW)';
            M = obj.tariff.mathpar.M;
            
            figure
            set(gcf,'numbertitle','off','name','Summary Segment')
            subplot(n,1,1)
            plotyy(x,M*obj.tariff.p,x,l);
            ylabel('$/kW')
            legend('p','l')
            title(strcat('variable charge (fixed = ',num2str(obj.tariff.F),')'))
            
            subplot(n,1,2)
            plot(x,obj.customer.ds)
            ylabel('kW')
            title('customer total demand')
            
            for i = 3:n
                dev = obj.customer.devices(i-2);
                subplot(n,1,i)
                if not(isa(dev,'d_bss'))                                    
                    plot(x,dev.ds)                    
                else
                    plot(x,[dev.p_in, dev.p_out])
                end
                ylabel('kW')
                title(strcat('customer-',dev.label))
            end
            
            for i = 1:(n-2)
                % Print devices detailed summary
                dev = obj.customer.devices(i);
                dev.print_summary;
            end    
        end    
       
%         function set_optimum(obj) % fix
%             p        = obj.tariff.p;
%             par      = obj.customer.par;
%             A        = obj.customer.A;
%             obj.GS   = .5*(p'*obj.U*p - pUp)/par.W;
%             obj.D    = A + obj.B*p;
%             obj.VC   = (obj.D'*obj.tariff.M*p)/par.W;
%             obj.FC   = obj.D'*(l + par.z*et*par.e)/par.W - obj.VC;
%             obj.Bill = obj.VC + obj.FC;
%             obj.AC   = obj.rh;
%             obj.CS   = obj.GS - obj.Bill - obj.AC;
%             obj.X    = max(obj.D);
%             obj.TD   = obj.D'*par.e/par.W;
%         end    
    end
    
end

