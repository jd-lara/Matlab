function record(INST, ID_SIM, sol, par, w_m)
%RECORD Summary of this function goes here
%   Detailed explanation goes here
    
    % Open connection
    conn = database.ODBCConnection(INST,'admin','admin');
    
    % Auxiliar variables
    a_W  = kron((1:par.W)', ones(par.T,1));
    a_T  = (1:par.T)';
    
    % Record detailed reports (variables)
    % Production
    data = w_m.gen_output_production(ID_SIM, a_W, a_T);
    insert(conn,'OPT_1_3_PRODUCTION',{'ID_SIM','ID_GEN','ID_SCEN','ID_PER','VALUE'},data);
    
    % Energy price
    ID_S = ID_SIM*par.e;
    T    = kron(ones(par.W,1), a_T);    
    data = [ID_S, a_W, T, sol.l];
    insert(conn,'OPT_1_2_ENERGY_PRICE',{'ID_SIM','ID_SCEN','ID_PER','VALUE'},data);
    
    % RPS price
    data = [ID_SIM, sol.et];
    insert(conn,'OPT_1_1_RPS_PRICE',{'ID_SIM','VALUE'},data);
    
    % Volumetric charges
    ini   = 1; fin = 0;
    data  = zeros(par.O,4);
    for t = 1:w_m.lse.TAU
        tar             = w_m.lse.segments(1,t).tariff;
        fin             = fin + tar.O;
        ID_S            = ID_SIM*ones(tar.O,1);
        ID_TAR          = t*ones(tar.O,1);
        ID_TWIN         = (ini:fin)'; 
        data(ini:fin,:) = [ID_S, ID_TAR, ID_TWIN, sol.p(ini:fin)];
        ini             = fin + 1;
    end
    insert(conn,'OPT_1_0_VCHARGE',{'ID_SIM','ID_TAR','ID_TWIN','VALUE'},data);
    
    % Demand
    data = w_m.lse.gen_output_demand(ID_SIM, a_W, a_T);
    insert(conn,'OPT_0_3_DEMAND',{'ID_SIM','ID_EXP_TYPE','ID_TAR',...
                                  'ID_SCEN','ID_PER','VALUE'},data);
    
    % Record summary reports
    % Firm
    data  = zeros(par.K,9);
    for k = 1:par.K
        firm      = w_m.firms(k);
        data(k,:) = [ID_SIM, k, firm.NPV, firm.EI, firm.EC, firm.RPSI, ...
                     firm.FC, firm.ICAP, firm.PROD];
    end
    insert(conn,'OPT_0_4_FIRM',{'ID_SIM','ID_GEN','NPV','EI','EC',...
                                'RPS','FC','ICAP','PROD'},data);
    
    % Customer
    data = zeros(w_m.lse.THETA*w_m.lse.TAU,13);
    ttt  = 0;
    for tt = 1:w_m.lse.THETA
        for t = 1:w_m.lse.TAU
            seg         = w_m.lse.segments(tt,t);
            ttt         = ttt + 1;
            data(ttt,:) = [ID_SIM, tt, t, seg.a_f, seg.a, seg.GS, seg.VC, ...
                           seg.FC, seg.Bill, seg.AC, seg.CS, seg.TD, seg.X];
        end
    end
    insert(conn,'OPT_0_2_CUSTOMER',{'ID_SIM','ID_EXP_TYPE','ID_TAR','A',...
                                    'NC','GS','VC','FC','Bill','AC',...
                                    'CS','TD','X'},data);
                                
    % LSE
    lse = w_m.lse;
    data = [ID_SIM, lse.TD, lse.X, lse.TR, lse.TI, lse.TC, lse.VI,...
             lse.FI, lse.VC, lse.AC, lse.RPS_C];
    insert(conn,'OPT_0_1_LSE',{'ID_SIM','TD','X','TR','TI','TC','VI',...
                               'FI','VC','AC','RPS_C'},data);
                           
    % Solution status
    o = sol.output;
    data = {ID_SIM, sol.fval, sol.exitflag, o.iterations, o.funcCount,...
            o.constrviolation, o.stepsize, o.firstorderopt, o.message,...
            sol.sol_time};
    insert(conn,'OPT_0_0_SOL_STATUS',{'ID_SIM','objective','exitflag',...
                'iterations','funcCount','constrviolation','stepsize',...
                'firstorderopt','message','sol_time'},data);
    
end

