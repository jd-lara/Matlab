% Test with dual control model (price signal)  
% with begin temperature = end temperature.
clear all;
close all;
clc;

N = 24;
c = [1, 2, 3, 4, 5, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 2, 4, 1, 13, 3, 2, 1, 1]';
r = 20;
ga = 2.5;
et = 0.17;
tmin = 5.5; tmax = 5.8;
pmin = 0; pmax = 2;
M = 999;
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

% Bilevel model
% -------------
cvx_begin
    variable y(N)         % MWh Energy production in scenario W, period T by generator.
    variable l(N)         % Variable charge
    variable p(N)         % Household power consumption.
    variable dep(N)       % dual of pmax constraint.
    variable dem(N)       % dual of pmin constraint.
    variable mup(N)       % dual of tmax constraint.
    variable mum(N)       % dual of tmin constraint.
    variable dp(N) binary % Integer of pmax constraint.
    variable dm(N) binary % Integer of pmin constraint.
    variable up(N) binary % Integer of tmax constraint.
    variable um(N) binary % Integer of tmin constraint.
%   variable x            % MWh Capacity built per time slot (in MWh because one time slot is one hour). 
    
    minimize( c'*y )
                                      y >= 0; 
                                      y == p;
                                      l >= 0.0001;
                                      l <= 1;
    l - ga*A'*(mup - mum) + (dep - dem) == 0;
    % Complementarity condition 0 <= p - pmin _|_ dem >= 0
                               p - pmin >= 0;
                M*(1 - dm) - (p - pmin) >= 0;
                                    dem >= 0;
                             M*dm - dem >= 0;
    % Complementarity condition 0 <= pmax - p _|_ dep >= 0                         
                               pmax - p >= 0;
                M*(1 - dp) - (pmax - p) >= 0;
                                    dep >= 0;
                             M*dp - dep >= 0;
    % Complementarity condition 0 <= tmax - T(p) _|_ mup >= 0                         
                 tmax - A*(et*h - ga*p) >= 0;
  M*(1 - up) - (tmax - A*(et*h - ga*p)) >= 0;
                                    mup >= 0;
                             M*up - mup >= 0;
    % Complementarity condition 0 <= T(p) - tmin _|_ mum >= 0                         
                 A*(et*h - ga*p) - tmin >= 0;
  M*(1 - um) - (A*(et*h - ga*p) - tmin) >= 0;
                                    mum >= 0;
                             M*um - mum >= 0;
cvx_end


cvx_begin
    variable p1(N)         % Household power consumption.
%   variable x            % MWh Capacity built per time slot (in MWh because one time slot is one hour). 
    
    minimize( l'*p1 )
        A*(et*h - ga*p1) - tmin >= 0;
        tmax - A*(et*h - ga*p1) >= 0;
         p1 - pmin >= 0;
          pmax - p1 >= 0;  
cvx_end

T =  A*(et*h - ga*p);
T1 =  A*(et*h - ga*p1);

plot(T); hold on; plot(T1,'r')
plot(p); hold on; plot(p1,'r')
figure
plot(l);