function [K, W, T, XI, THETA, TAU, c, r, Mrh, D, IE, IALPHA, ...
          inf_tau, M, eRPS, z, ro, SIMs, a0, ub] = prepare_instance( INST )
%LOADINSTANCE Summary of this function goes here
%   Detailed explanation goes here
    % Open connection
    conn = database(INST,'admin','admin');
    
    % Delete OPT tables
    exec(conn,'DELETE FROM OPT_0_0_SOL_STATUS');
    exec(conn,'DELETE FROM OPT_0_1_LSE');
    exec(conn,'DELETE FROM OPT_0_2_CUSTOMER');
    exec(conn,'DELETE FROM OPT_0_3_DEMAND');
    exec(conn,'DELETE FROM OPT_0_4_FIRM');
    exec(conn,'DELETE FROM OPT_1_0_VCHARGE');
    exec(conn,'DELETE FROM OPT_1_1_RPS_PRICE');
    exec(conn,'DELETE FROM OPT_1_2_ENERGY_PRICE');
    exec(conn,'DELETE FROM OPT_1_3_PRODUCTION');
        
    % Load sets sizes
    curs = exec(conn,'select K from IPT_K'); curs = fetch(curs);
    K = cell2mat(curs.Data);
    curs = exec(conn,'select W from IPT_W'); curs = fetch(curs);
    W = cell2mat(curs.Data);
    curs = exec(conn,'select T from IPT_T'); curs = fetch(curs);
    T = cell2mat(curs.Data);
    curs = exec(conn,'select XI from IPT_XI'); curs = fetch(curs);
    XI = cell2mat(curs.Data);
    curs = exec(conn,'select THETA from IPT_THETA'); curs = fetch(curs);
    THETA = cell2mat(curs.Data);
    curs = exec(conn,'select TAU from IPT_TAU'); curs = fetch(curs);
    TAU = cell2mat(curs.Data);
            
    % Load techs parameters
    curs = exec(conn,'select c from IPT_c'); curs = fetch(curs);
    c = cell2mat(curs.Data);
    curs = exec(conn,'select r from IPT_r'); curs = fetch(curs);    
    r = cell2mat(curs.Data); 
    curs = exec(conn,'select * from IPT_Mrh'); curs = fetch(curs);    
    Mrh = cell2mat(curs.Data); Mrh = Mrh(:,2:size(Mrh,2));
    curs = exec(conn,'select ro from IPT_ro'); curs = fetch(curs);    
    ro = cell2mat(curs.Data);
    curs = exec(conn,'select eRPS from IPT_eRPS'); curs = fetch(curs);
    eRPS = cell2mat(curs.Data);
        
    % Load ex-post types parameters
    curs = exec(conn,'select * from IPT_D_01'); curs = fetch(curs);
    D = cell2mat(curs.Data); D = D(:,3:size(D,2));
    curs = exec(conn,'select * from IPT_IE'); curs = fetch(curs);
    IE = cell2mat(curs.Data);
        
    % Load tariffs parameters
    curs = exec(conn,'select * from IPT_inf_tau_05'); curs = fetch(curs);
    inf_tau = cell2mat(curs.Data); inf_tau(isnan(inf_tau)) = 0;
    curs = exec(conn,'select * from IPT_M'); curs = fetch(curs);
    M = cell2mat(curs.Data); M(isnan(M)) = 0;
    if ischar(M)
        M = 0;
    else
        M = sparse(M(:,4:size(M,2)));
    end    
        
    % Other demand parameters
    curs = exec(conn,'select * from IPT_a0_10'); curs = fetch(curs);
    a0 = cell2mat(curs.Data); a0 = a0(:,2:size(a0,2));
    curs = exec(conn,'select * from IPT_ub'); curs = fetch(curs);
    ub = cell2mat(curs.Data);
    curs = exec(conn,'select * from IPT_IALPHA'); curs = fetch(curs);
    IALPHA = cell2mat(curs.Data); IALPHA(isnan(IALPHA)) = 0;
    IALPHA = IALPHA(:,2:size(IALPHA,2));
        
    % Load policy parameters
    curs = exec(conn,'select z from IPT_z'); curs = fetch(curs);
    z = cell2mat(curs.Data);
    
    % Load simulations parameters
    curs = exec(conn,'select * from IPT_SIMs'); curs = fetch(curs);
    SIMs = simulations(cell2mat(curs.Data), sum(a0,2)*sum(XI), IE);
    
    % Close connection and cursor
    close(curs); 
    close(conn);
end

