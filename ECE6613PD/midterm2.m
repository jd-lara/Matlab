clear all; clc
a=cos(120*pi/180)+sin(120*pi/180)*i; A=[1 1 1;1 a*a a;1 a a*a];


Ybus1 = [-20*i  10*i      0          0         0;...
          10*i -20*i      10*i       0         0; ...
           0    10*i      1-20.4*i   10*i      0; ...
           0     0        10*i      -20*i     10*i;...
           0     0        0          10*i    -20*i];
       
Ybus0 = [-20*i   0        0          0        0;...
          0    -13.33*i   3.33*i     0        0;...
          0      3.33*i  -6.66*i     3.33*i   0;...
          0      0        3.33*i   -13.33*i   0;...
          0      0        0          0        0.001*i];

%%% Define pre-fault voltages for each sequence
V0_pf=0;
V2_pf=0;
V1_pf=1;
%%% Define fault admittance matrix: 
Yfabc1=[9e9 0 0;0 0 0;0 0 0]; % SLG fault
%%% Calculate the fault admittance matrix in 0-1-2 frame
Yf012_1=(A^-1)*Yfabc1*A;
%%% Use LU decomposition to solve for Z3 in each sequence
[L1 U1]=lu(Ybus1);
[L0 U0]=lu(Ybus0); 
aux=eye(5); 
X1=(L1^-1)*aux(:,3); 
X0=(L0^-1)*aux(:,3); 
Z3_1=(U1^-1)*X1; 
Z3_0=(U0^-1)*X0; 
Z3_2=Z3_1;
%%% Define the Z3_012 matrix (Z3_3 of each sequence in the diagonal)
Z3_012=[Z3_0(3) 0 0;0 Z3_1(3) 0;0 0 Z3_2(3)];
%%% Calculate fault current in 0-1-2 frame
fprintf('Sequence Currents, 012\n')
If012_1=((Yf012_1*Z3_012+eye(3))^-1)*Yf012_1*[V0_pf;V1_pf;V2_pf]
%%% Transform to a-b-c frame
fprintf('Phase Current, in cartesian coordinates\n')
Ifabc_1=A*If012_1
fprintf('Phase Current, magnitudes\n')
Ifabc_abs=abs(Ifabc_1)