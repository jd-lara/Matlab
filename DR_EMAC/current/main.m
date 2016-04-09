%----------- MAIN CODE ---------------%

clear all;

INST = 'Test_California_3TAR';
[K, W, T, XI, THETA, TAU, c, r, Mrh, D, IE, ...
 ALPHA, inf_tau, M, ekR, z, ro, SIMs, a0, ub] = prepare_instance(INST);

% Initilize model's parameters
par = parameters(z, c, ro, r, K, W, T, ekR, THETA, a0, ub);
                 
% Initialize LSE
lse = lse(XI, THETA, TAU, ALPHA, D, IE, inf_tau, M, par, Mrh, 0);

% Set total number of time windows.
par.set_O(lse);

% Initilize wholesale market
w_m = wholesale_market(lse, par);

% Initilize solution object
sol = solution();

% Main iteration
for n_s = 1:SIMs.N
  
  display(['Simulation N',num2str(n_s)]);display('-------------');
    
  tic;
  % Update data
  SIMs.update_data(par, w_m, n_s);
  
  % Find equilibrium
  search_equilibrium(sol, par, w_m.lse);
  
  % Update objects
  w_m.update(sol);
    
  % Record output
  record(INST, SIMs.get_ID_SIM(n_s), sol, par, w_m);
  
end


