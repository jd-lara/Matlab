a=cos(120*pi/180)+sin(120*pi/180)*i;
A=[1 1 1;1 a*a a;1 a a*a];

Ybus1 = [1/(0.1i)+1/(0.01+0.1i)+1/(0.01+0.1i) -1/(0.01+0.1i) -1/(0.01+0.1i) 0
        -1/(0.01+0.1i) 1/(0.1i)+1/(0.01+0.1i)+1/(0.01+0.1i) -1/(0.01+0.1i) 0
        -1/(0.01+0.1i) -1/(0.01+0.1i) 1/(0.1i)+1/(0.01+0.1i)+1/(0.01+0.1i) -1/(0.1i)
        0 0 -1/(0.1i) 1/(0.1i)+1/(1.023-0.495i)];
    
Ybus0 = [1/(0.05i)+1/(0.03+0.3i)+1/(0.03+0.3i) -1/(0.03+0.3i) -1/(0.03+0.3i) 0
        -1/(0.03+0.3i) 1/(0.05i)+1/(0.03+0.3i)+1/(0.03+0.3i) -1/(0.03+0.3i) 0
        -1/(0.03+0.3i) -1/(0.03+0.3i) 1/(0.1i)+1/(0.03+0.3i)+1/(0.03+0.3i) 0
        0 0 0 1/(1.023-0.495i)];

%%% Define pre-fault voltages for each sequence
angles_pf=[-0.6 0 -2.74 -8.43]*pi/180;
V0_pf=zeros(4,1);
V2_pf=zeros(4,1);
V1_pf=[1.014*(cos(angles_pf(1))+sin(angles_pf(1))*i);1.01*(cos(angles_pf(2))+sin(angles_pf(2))*i);0.98*(cos(angles_pf(3))+sin(angles_pf(3))*i);
        0.94*(cos(angles_pf(4))+sin(angles_pf(4))*i)];
    
%%% Define fault admittance matrix:

Yfabc1=[9e9 0 0;0 0 0;0 0 0];     % SLG fault

%%% Calculate the fault admittance matrix in 0-1-2 frame
Yf012_1=(A^-1)*Yfabc1*A;

%%% Use LU decomposition to solve for Z3 in each sequence
[L1 U1]=lu(Ybus1);
[L0 U0]=lu(Ybus0);
aux=eye(4);
X1=(L1^-1)*aux(:,3);
X0=(L0^-1)*aux(:,3);
Z3_1=(U1^-1)*X1;
Z3_0=(U0^-1)*X0;
Z3_2=Z3_1;

%%% Define the Z3_012 matrix (Z3_3 of each sequence in the diagonal)
Z3_012=[Z3_0(3) 0 0;0 Z3_1(3) 0;0 0 Z3_2(3)];

%%% Calculate fault current in 0-1-2 frame
If012_1=((Yf012_1*Z3_012+eye(3))^-1)*Yf012_1*[V0_pf(3);V1_pf(3);V2_pf(3)];

%%% Transform to a-b-c frame
Ifabc_1=A*If012_1;

%%% Obtain fault voltages at each bus for zero sequence
V0_f1=V0_pf-If012_1(1)*Z3_0;

%%% Obtain fault voltages at each bus for positive sequence
V1_f1=V1_pf-If012_1(2)*Z3_1;

%%% Obtain fault voltages at each bus for negative sequence
V2_f1=V2_pf-If012_1(3)*Z3_2;

%%% Auxiliary matrix to convert to a-b-c frame
V_aux1=[V0_f1,V1_f1,V2_f1]';

%%% Matrix containing fault voltages at each bus (columns) for each phase
%%% (rows)
Vabc_f1=A*V_aux1;

%%% Calculating fault currents at line 1-2
If012_1_2_f1=[(V0_f1(1)-V0_f1(2))*(-Ybus0(1,2)); (V1_f1(1)-V1_f1(2))*(-Ybus1(1,2)); (V2_f1(1)-V2_f1(2))*(-Ybus1(1,2))];
Ifabc_1_2_f1=A*If012_1_2_f1;

    
    