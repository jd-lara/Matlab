classdef wholesale_market < handle
    %WHOLESALE_MARKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        firms  % Set of firms participating in the market.
        lse    % load serving entities.
        par    % Parameteres of the instance
    end
    
    methods
        function obj = wholesale_market(lse, par)
            obj.lse = lse;
            obj.par = par;
            obj.gen_firms;
        end
        function gen_firms(obj)
            obj.firms = firm();
            obj.firms(obj.par.K) = firm();
            ini = 1; fin = 0;
            for k = 1:obj.par.K
                fin = fin + obj.par.TW;
                c = obj.par.c(ini:fin); r = obj.par.r(k);
                ro = obj.par.ro(ini:fin); RPS = obj.par.eRPS(k);
                obj.firms(k) = firm(c, r, ro, RPS);
                ini = fin + 1;
            end    
        end
        function update(obj, sol)
            obj.lse.update(sol);
            ini = 1; fin = 0;
            for k = 1:obj.par.K
                fin = fin + obj.par.TW;
                y = sol.y(ini:fin);
                x = sol.x(k);
                obj.firms(k).update(y, x, sol.l, sol.et, obj.par);
                ini = fin + 1;
            end    
        end
        function [ICAP, NEF] = get_ICAP_NEF(obj)
            % This function gets the total capacity deployed, ICAP, and the 
            % number of effective firms. The number of effective firms
            % are the firms for which their capacity is possitive.
            ICAP = 0;
            for k = 1:obj.par.K
                ICAP = ICAP + obj.firms(k).ICAP;
            end
            NEF = 0;
            for k = 1:obj.par.K
                if obj.firms(k).ICAP/ICAP > 0.0001
                    NEF = NEF + 1;
                end
            end           
        end    
        function data = gen_output_production(obj, ID_SIM, a_W, a_T)
            % Record only firms for which there is a considerable ICAP.
            [ICAP, NEF] = obj.get_ICAP_NEF;
            data = zeros(NEF*obj.par.TW,5);
            ini  = 1; fin = 0;
            ID_S = ID_SIM*obj.par.e;
            T    = kron(ones(obj.par.W,1), a_T);
            for k = 1:obj.par.K
                firm = obj.firms(k);
                if firm.ICAP/ICAP > 0.0001 
                    fin = fin + obj.par.TW;
                    K    = k*obj.par.e;
                    data(ini:fin,:) = [ID_S, K, a_W, T, firm.y];
                    ini             = fin + 1;
                end
               
            end
        end    
    end
    
end

