clear all;
close all;

% Parameters of devices (from Metheiu et. al. 2015)
% Parameters(z, c, ro, r, K, W, T, eRPS, THETA, a0, ub)
T=24;
W=12;
par   = parameters(0, 0, 0, 0, 1, W, T, 1, 3, 1, 1);
beta  = 0.01;
Oobj  = 22;
Omin  = 17;
Omax  = 26;
Pmin  = 0;
Pmax  = 7.2;
R     = 2;
C     = 2;
eta   = -1/2.5;

% Oout  = [25 25 26,...
%          (1+(rand()-rand())*0.15)*[25 25 26]];
         

Oout  = [25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25,...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25],...
         (1+(rand()-rand())*0.15)*[25 25 25 29 30 28 25 24 23 20 25 25 25 29 30 28 25 24 23 20 18 25 25 25]]'; 

label = 'AC System';

dev1 = d_tcl(par, beta, Oobj, Omin, Omax, Pmin, Pmax, R, ...
                           C, eta, Oout, label);
                       

par   = parameters(0, 0, 0, 0, 1, W, T, 1, 3, 1, 1);
beta  = 0.1;
Oobj  = 2;
Omin  = 1;
Omax  = 6;
Pmin  = 0;
Pmax  = 7.2;
R     = 20;
C     = 4;
label = 'Fridge';

% Parameters(z, c, ro, r, K, W, T, eRPS, THETA, a0, ub)
dev1_2 = d_tcl(par, beta*5, Oobj, Omin, Omax, Pmin, Pmax, R, ...
                           C, eta, Oout, label);                       
                       
ope = -0.01;
d0  = ones(T*W,1)*0.3;
p0  = ones(T*W,1)*0.16;
dev2 = d_baseline(par, ope, d0, p0); 

Pmax = 1;
SOC_max = 1;
SOC_min = 0.2;
eta_out = sqrt(0.92)*0.95;
eta_in = sqrt(0.92)*0.95;
S_0 = 0.2;
dev3 = d_bss(par, Pmax, SOC_max, SOC_min, eta_out, eta_in, S_0);


devs = [dev2];
devs1 = [dev1 dev1_2 dev2 dev3];
c1 = customer(par, devs);
cA = customer(par, devs1);

% l = [1, 3, 3,...
%      (1+(rand()-rand())*0.5)*[1, 3, 3]]';%,...

l = [1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1,...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1],...
     (1+(rand()-rand())*0.5)*[1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 1, 3, 6, 15, 17, 18, 17, 15, 16, 12, 6, 3, 1]]';
     
% Customer with RTP
%t_two_part(M, O, label, par, p, F)
tar1 = t_two_part(1, T*W, 'RTP', par);
seg1 = segment(cA,tar1);

% Customer with Flat rate
tar2 = t_two_part(ones(T*W,1), 1, 'Flat-Rate', par);
seg2 = segment(c1,tar2);

% Customer with TOU, where peak period is hour 2
%M = [1 0;0 1;1 0;1 0];
%tar3 = t_two_part(M, 2, 'TOU', par);
%seg3 = segment(c1,tar3);

tic

% Solve segment
%seg1.find_demand_and_prices_1(l);
seg2.find_demand_and_prices_1(l);

toc 

%dev3.print_summary
seg1.print_summary



                       

         