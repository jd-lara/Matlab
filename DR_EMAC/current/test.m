% clear all;
T = 12;

% Parameters of devices (from Metheiu et. al. 2015)
par   = parameters(0, 0, 0, 0, 1, 1, T, 1, 3, 1, 1);
beta  = 0.5;
Oobj  = 22;
Omin  = 17;
Omax  = 50;
Pmin  = 0;
Pmax  = 7.2;
R     = 2;
C     = 2;
eta   = -1/2.5;
Oout  = 50*ones(T,1); 
label = 'AC System';

dev1 = d_tcl(par, beta, Oobj, Omin, Omax, Pmin, Pmax, R, ...
                           C, eta, Oout, label);
ope = -0.01;
d0  = ones(4,1)*0.3;
p0  = ones(4,1)*0.16;
dev2 = d_baseline(par, ope, d0, p0); 

Pmax = 1;
SOC_max = 2;
SOC_min = 0.2;
eta_out = 0.8;
eta_in = 0.8;
S_0 = 0;
dev3 = d_bss(par, Pmax, SOC_max, SOC_min, eta_out, eta_in, S_0);

devs = dev1;
c1 = customer(par, devs);
c2 = c1.replicate;

l = 1*ones(T,1); l(6) = 14;
% Customer with RTP
tar1 = t_two_part(1, T, 'RTP', par);
seg1 = segment(c1,tar1);

% Customer with Flat rate
tar2 = t_two_part(ones(T,1), 1, 'Flat-Rate', par);
seg2 = segment(c1,tar2);

% Customer with TOU, where peak period is hour 2
M = [1 0;0 1;1 0;1 0];
tar3 = t_two_part(M, 2, 'TOU', par);
seg3 = segment(c1,tar3);

% Solve segment
seg1.find_demand_and_prices_1(l);




                       

         