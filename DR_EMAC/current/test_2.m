% In this code, we test whether solving the problem with the big method
% or using the technique of using the price that optimizes the relaxed
% problem deliver different results.
clear all; close all;
% Instance parameters
T=24;
W=5;
par   = parameters(0, 0, 0, 0, 1, W, T, 1, 3, 1, 1, 1);

Oout  = [25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25,...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25]]';%,...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
%          (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25]]'; 
     
l = [1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1,...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1]]';%,...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
%      (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1]]';     

% Devices definition
% TCL's AC System
beta  = 0.01;
Oobj  = 22;
Omin  = 0;
Omax  = 28;
Pmin  = 0;
Pmax  = 7.2;
R     = 2;
C     = 2;
eta   = -1/2.5;
%Oout  = 20 + (rand(T,1) - rand(T,1))*40'; 
label = 'AC System';
dev1 = d_tcl(par, beta, Oobj, Omin, Omax, Pmin, Pmax, R, ...
                           C, eta, Oout, label, 1, 1);        
                       
% TCL's Heat Pump
beta2  = 0.01;
Oobj2  = 22;
Omin2  = 15;
Omax2  = 30;
Pmin2  = 0;
Pmax2  = 7.2;
R2     = 2;
C2     = 2;
eta2   = 1/3.5; 
label2 = 'Heat Pump';
dev2 = d_tcl(par, beta2, Oobj2, Omin2, Omax2, Pmin2, Pmax2, R2, ...
                           C2, eta2, Oout, label2, 1, 1);                       
                       
% Composite device
devs = [dev1, dev2];
dev3 = d_tcl_comp(par,devs);

% Customer defintion
c2 = customer(par, dev3);

%RTP case
tar2 = t_two_part(eye(T*W), 'RTP', par);

% Segment definition
seg2 = segment(c2,tar2);

% Solve segment with technique
%seg2.find_demand_and_prices_2(l);
%seg2.print_summary(l)


% Rates definition
M1 = [ones(T/3,1);zeros(2*T/3,1)];
M2 = [zeros(T/3,1);ones(T/3,1);zeros(T/3,1)];
M3 = [zeros(2*T/3,1);ones(T/3,1)];
M_int = [M1, M2, M3];
M = kron(ones(W,1),M_int);
tar1 = t_two_part(M, 'TOU', par);

% Customer defintion
c1 = customer(par, dev3);

% Segment definition
seg1 = segment(c1,tar1);

% Solve segment with technique
seg1.find_demand_and_prices_1(l);
seg1.print_summary(l)
seg1.find_demand_and_prices_2(l);
seg1.print_summary(l)
