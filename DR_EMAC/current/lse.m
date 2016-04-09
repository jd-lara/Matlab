classdef lse < handle
    % LSE
    % In this version of the code, I consider that the user does not 
    % input retail prices. This is the case 2 in the implementation notes.
    
    properties
        XI        % # of ex-ante consumers in the population.
        THETA     % # of ex-post types.
        TAU       % # of tariffs.
        ALPHA     % A(i,j) = 1 if ex-post type j corresponds to ex-ante type i, zero otherwise.
        segments  % Matrix of segments (rows: exp-types, cols: tars)
        par       % Parameters of the setting.
        % Outputs for reporting
        TI        % Expected total income [$/T]
        TC        % Expected total cost [$/T]
        VI        % Expected variable income [$/T]
        FI        % Fixed income [$/T]
        VC        % Expected cost associated to buying energy in the wholesale market [$/T]
        AC        % Portion of segment adoption cost paid by the LSE [$/T]
        RPS_C     % Cost of RPS compliance  [$/T]
        TR        % LSE net revenue [$/T]
        TD        % Expected total demand [MWh/T]
        X         % Peak demand.  [MW]
    end
    methods
        function obj = lse(XI, THETA, TAU, ALPHA, D, IE, inf_tau, M, par, Mrh, all)
            % Constructor for the LSE. If all = 1, then the demand system
            % of the customers is initialized. Not otherwise.
            
            obj.XI = XI;
            obj.THETA = THETA;
            obj.TAU = TAU;
            obj.ALPHA = ALPHA;
            obj.par = par;
            
            % Create array segments
            obj.set_segments_v0(D, inf_tau, M, Mrh);
            
            % Set the demand system of the customers.
            if all
                obj.set_demands_v0(IE);
                t0 = obj.compute_anchor_price;
                obj.set_segments_vf(t0);
            end    
            
        end
        function set_segments_v0(obj, D, inf_tau, M, Mrh)
            % Initilize 2D array of segments
            obj.segments = segment();
            obj.segments(obj.THETA,obj.TAU) = segment();
            
            % Observed customers per ex-post type
            N = sum(obj.XI);
            a_tt = sum(obj.par.a0,2)*N;
            
            % First row of segments
            cus = customer(D(:,1),a_tt(1),obj.par);
            c_ini = 1; c_fin = 0;
            r_ini = 1; r_fin = 0;
            for t = 1:obj.TAU
                if inf_tau(t,1) == 1 % flat rate
                    tar = tariff(inf_tau(t,1), obj.par.e, 1);
                elseif inf_tau(t,1) == 3 % RTP
                    tar = tariff(inf_tau(t,1), 1, obj.par.TW);
                else % Otheriwise TOU
                    r_fin = r_fin + obj.par.TW;
                    c_fin = c_fin + inf_tau(t,2);
                    Mtar = M(r_ini:r_fin,c_ini:c_fin);
                    tar = tariff(inf_tau(t,1), Mtar, inf_tau(t,2));
                    c_ini = c_fin + 1; 
                    r_ini = r_fin + 1;
                end
                obj.segments(1,t) = segment(cus, tar, 0, Mrh(1,t));
            end    
            
            % Remaining rows
            for tt = 2:obj.THETA
                cus = customer(D(:,tt),a_tt(tt),obj.par);
                for t = 1:obj.TAU
                    obj.segments(tt,t) = ... 
                    segment(cus, obj.segments(1,t).tariff, 0, Mrh(tt,t));
                end
            end
        end
        function set_demands_v0(obj, IE)
            % Set the first version of the customers demands. This version
            % is not normalized by the anchor price.
            for tt = 1:obj.THETA
                obj.segments(tt,1).customer.set_demand_v0(IE(tt,:));
            end    
        end    
        function t0 = compute_anchor_price(obj)
            % Compute anchor price. Assumes that customers have the
            % jacobian defined. It can be the preliminary jacobian.
            D = obj.get_obs_D;
            [l, et] = solve_cmin(obj.par,D);
            l_sum = l + et*obj.par.z*obj.par.e;
            B_tt = zeros(obj.par.TW);
            for tt = 1:obj.THETA
                cus = obj.segments(tt,1).customer;
                B_tt = B_tt + cus.a*cus.B;
            end
            t0 = (obj.par.e'*B_tt*l_sum)/(obj.par.e'*B_tt*obj.par.e);
        end    
        function set_segments_vf(obj, t0)
            % Set customer demand systems and segments (vf)
            for tt = 1:obj.THETA
                obj.segments(tt,1).customer.set_demand_vf(t0);
                for t = 1:obj.TAU
                    obj.segments(tt,t).set_segment_vf;
                end    
            end
        end    
        function Mrh = get_Mrh(obj)
            Mrh = zeros(obj.THETA,obj.TAU);
            for tt = 1:obj.THETA
                for t = 1:obj.TAU
                    Mrh(tt,t) = obj.segments(tt,t).rh;
                end    
            end    
        end
        function D = get_obs_D(obj)
            % Gets the observed demand system. 
            D = zeros(obj.par.TW,1);
            for tt = 1:obj.THETA
                cus = obj.segments(tt,1).customer;
                D = D + cus.a*cus.D;
            end
        end   
        function update(obj, sol)
            % Initialization
            obj.VI     = 0;
            obj.FI     = 0;
            obj.VC     = 0;
            obj.AC     = 0;
            obj.RPS_C  = 0;
            obj.TR     = 0;
            D          = zeros(obj.par.TW,1);
            M_a        = vec2mat(sol.a, obj.TAU);
            N          = sum(obj.XI);
            ini = 1; fin = 0;
            for t = 1:obj.TAU
                % Update tariff
                tar = obj.segments(1,t).tariff;
                fin = fin + tar.O; 
                tar.update(sol.p(ini:fin));
                ini = fin + 1;
                for tt = 1:obj.THETA
                % Update segments
                    seg = obj.segments(tt,t);
                    l = sol.l; et = sol.et;
                    pr = obj.par;
                    seg.update(M_a(tt,t), N, l, et);
                    obj.VI    = obj.VI + seg.a*seg.VC;
                    obj.FI    = obj.FI + seg.a*seg.FC;
                    obj.VC    = obj.VC + seg.a*seg.D'*l/pr.W;
                    obj.AC    = 0;
                    obj.RPS_C = obj.RPS_C + seg.a*pr.z*et*seg.D'*pr.e/pr.W;
                    D         = D + seg.a*seg.D;
                end
            end
            % Update final aggregated variables.
            obj.TI = obj.VI + obj.FI;
            obj.TC = obj.VC + obj.RPS_C + obj.AC;
            obj.TR = obj.TI - obj.TC;
            obj.TD = D'*pr.e/pr.W; 
            obj.X  = max(D);
        end
        function NES = get_NES(obj)
            % This function gets the number of effective segments. That is,
            % segments that have a possitive number of customers
            % associated. The possitiveness is defined below.
            N = sum(obj.XI);
            NES = 0;
            for tt = 1:obj.THETA
                for t = 1:obj.TAU
                    seg = obj.segments(tt,t);
                    if seg.a/N > 0.0001
                        NES = NES + 1;
                    end    
                end
            end    
        end    
        function data = gen_output_demand(obj, ID_SIM, a_W, a_T)
            % Record only segments for which there is a considerable number
            % of customer.
            data = zeros(obj.get_NES*obj.par.TW,6);
            N = sum(obj.XI);
            ini  = 1; fin = 0;
            ID_S = ID_SIM*obj.par.e;
            T    = kron(ones(obj.par.W,1), a_T);
            for tt = 1:obj.THETA
                for t = 1:obj.TAU
                    seg = obj.segments(tt,t);
                    if seg.a/N > 0.0001 
                        fin             = fin + obj.par.TW;
                        ID_EXP_TYPE     = tt*obj.par.e;
                        ID_TAR          = t*obj.par.e;
                        data(ini:fin,:) = [ID_S, ID_EXP_TYPE, ID_TAR, a_W, T, seg.D];
                        ini             = fin + 1;
                    end
                end
            end
        end    
    end
    
end

