N = 24;
c = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 1, 1, 1, 1, 1, 1, 1]';
r = 20;
ga = 2.5;
et = 0.17;
tmin = 1; tmax = 12;
pmin = 0; pmax = 1;
ti = 3;
h =[14.4129, 14.392, 14.4169, 14.459, 14.59, 15.4402, 15.4385, 15.43585, 17.43952, 17.44748, ...
    18.45631, 18.46311, 19.4671, 21.46806, 22.46628, 21.46806, 19.4671, 18.46311, 18.45631, ...
    17.44748, 15.4385, 15.4385, 15.4385, 14.4385]';

% Thermal parameter definition
A = diag(ones(N,1))*(1-et)^(N-1);
for j = 1:N-1
    A = A + diag(ones(1,N-j),-j)*(1-et)^(j-1);
    A = A + diag(ones(1,N-j), j)*(1-et)^(N-1-j);
end
A = A/(1 - (1-et)^(N-1));

cvx_solver Gurobi_2

% Primal model (begin = end)
% --------------------------
cvx_begin
    variable y(24)         % MWh Energy production in scenario W, period T by generator.
%   variable x            % MWh Capacity built per time slot (in MWh because one time slot is one hour). 
    
    minimize( c'*y )
                         y >= 0;
                  pmax - y >= 0 ;
    A*(et*h - ga*y) - tmin >= 0;
    tmax - A*(et*h - ga*y) >= 0;
cvx_end