classdef firm < handle
    %FIRMS 
    %   In this model we assume that a firm spetializes in a given
    %   technology, possibly owning all the plants of the same type 
    %   participating in the market.
    
    properties
        c    % ($/MWh) Variable cost of generation
        r    % ($/MWh-T) Fixed cost
        ro   % (in [0,1]) Technology availability factor.
        RPS  % 1 if the firm receives an RPS credit, 0 otherwise.
        y    % (MWh) Firm hourly production.
        % Ouputs for reporting
        NPV  % [$/T] Expected net present value.
        EI   % [$/T] Expected income from energy production.
        EC   % [$/T] Expected cost from energy production.
        RPSI % [$/T] Expected income from RPS policy.
        FC   % [$/T] Anualized fixed cost.
        ICAP % [MW] Installed capacity.
        PROD % [MWh/T] Expected total production.
    end
    methods
        function obj = firm(c, r, ro, RPS)
            if nargin == 0
                obj.c = NaN;
                obj.r = NaN;
                obj.ro = NaN;
                obj.RPS = NaN;
            else    
                obj.c = c;
                obj.r = r;
                obj.ro = ro;
                obj.RPS = RPS;
            end
        end
        function update(obj, y, x, l, et, par)
            obj.EI   = y'*l/par.W;
            obj.EC   = y'*obj.c/par.W;
            obj.PROD = y'*par.e/par.W;
            obj.RPSI = obj.PROD*et*obj.RPS;
            obj.FC   = obj.r*x;
            obj.NPV  = obj.EI + obj.RPSI - obj.EC - obj.FC;
            obj.ICAP = x;
            obj.y = y;
        end    
    end
    
end

