a=cos(120*pi/180)+sin(120*pi/180)*i;
A=[1 1 1;1 a*a a;1 a a*a];
     
Zline = [0 0.01938+0.05917i 0 0 0.05403+0.22304i 0 0 0 0 0 0 0 0 0
         0.01938+0.05917i 0 0.04699+0.19797i 0.05811+0.17632i 0.05695+0.17388i 0 0 0 0 0 0 0 0 0
         0 0.04699+0.19797i 0 0.06701+0.17103i 0 0 0 0 0 0 0 0 0 0 
         0 0.05811+0.17632i 0.06701+0.17103i 0 0.01335+0.04211i 0 0 0 0 0 0 0 0 0
         0.05403+0.22304i 0.05695+0.17388i 0 0.01335+0.04211i 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0.09498+0.1989i 0.12291+0.25581i 0.06615+0.13027i 0
         0 0 0 0 0 0 0 0 0.11001i 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0.11001i 0 0 0.03181+0.0845i 0 0 0 0.12711+0.27038i
         0 0 0 0 0 0 0 0 0.03181+0.0845i 0 0.08205+0.19207i 0 0 0
         0 0 0 0 0 0.09498+0.1989i 0 0 0 0.08205+0.19207i 0 0 0 0
         0 0 0 0 0 0.12291+0.25581i 0 0 0 0 0 0 0.22092+0.19988i 0
         0 0 0 0 0 0.06615+0.13027i 0 0 0 0 0 0.22092+0.19988i 0 0.17093+0.34802i
         0 0 0 0 0 0 0 0 0.12711+0.27038i 0 0 0 0.17093+0.34802i 0];
     
Bline = [0 0.0528i 0 0 0.0492i 0 0 0 0 0 0 0 0 0
         0.0528i 0 0.0438i 0.0374i 0.034i 0 0 0 0 0 0 0 0 0
         0 0.0438i 0 0.0346i 0 0 0 0 0 0 0 0 0 0 
         0 0.0374i 0.0346i 0 0.0128i 0 0 0 0 0 0 0 0 0
         0.0492i 0.034i 0 0.0128i 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 0 0 0 0 0 0];

% Define bus load impedances
Zload = [0 3.7484+2.1938i 1.0406+0.2099i 2.1260+0.1779i 13+2.7369i 7.0576+4.7260i 0 0 2.7404+1.5421i 8.3433+5.3768i 24.7516+12.7294i 17.0184+4.4638i 6.8522+2.9439i 6.2758+2.1060i];

% Define generator & synchronous compensator impedances
Zg1 = [0.05366i 0.3333i 0.3333i 0 0 1.2222i 0 1.1342i];
Zg0 = [0.01951i 0.1015i 0.1015i 0 0 0.3333i 0 0.5671i];

% Define transformer impedances & admittances
Zt = [0.25202i*0.932 0.55618i*0.969 0.20912i*0.978 0.17615i];
Y1t = [(1-(1/0.932))/0.25202i (1-(1/0.969))/0.55618i (1-(1/0.978))/0.20912i 0];
Y2t = [((1/0.932)^2-(1/0.932))/0.25202i  ((1/0.969)^2-(1/0.969))/0.55618i ((1/0.978)^2-(1/0.978))/0.20912i 0];
      
Ybus1 = [1/Zline(1,2)+Bline(1,2)/2+1/Zline(1,5)+Bline(1,5)/2+1/Zg1(1) -1/Zline(1,2) 0 0 -1/Zline(1,5) 0 0 0 0 0 0 0 0 0
         -1/Zline(2,1) 1/Zline(2,1)+Bline(2,1)/2+1/Zline(2,3)+Bline(2,3)/2+1/Zline(2,4)+Bline(2,4)/2+1/Zline(2,5)+Bline(2,5)/2+1/Zg1(2)+1/Zload(2) -1/Zline(2,3) -1/Zline(2,4) -1/Zline(2,5) 0 0 0 0 0 0 0 0 0
         0 -1/Zline(3,2) 1/Zline(3,2)+Bline(3,2)/2+1/Zline(3,4)+Bline(3,4)/2+1/Zg1(3)+1/Zload(3) -1/Zline(3,4) 0 0 0 0 0 0 0 0 0 0
         0 -1/Zline(4,2) -1/Zline(4,3) 1/Zline(4,2)+Bline(4,2)/2+1/Zline(4,3)+Bline(4,3)/2+1/Zline(4,5)+Bline(4,5)/2+1/Zload(4)+1/Zt(3)+Y2t(3)+1/Zt(2)+Y2t(2) -1/Zline(4,5) 0 -1/Zt(3) 0 -1/Zt(2) 0 0 0 0 0
         -1/Zline(5,1) -1/Zline(5,2) 0 -1/Zline(5,4) 1/Zline(5,1)+Bline(5,1)/2+1/Zline(5,2)+Bline(5,2)/2+1/Zline(5,4)+Bline(5,4)/2+1/Zload(5)+1/Zt(1)+Y2t(1) -1/Zt(1) 0 0 0 0 0 0 0 0
         0 0 0 0 -1/Zt(1) 1/Zt(1)+Y1t(1)+1/Zline(6,11)+1/Zline(6,12)+1/Zline(6,13)+1/Zload(6)+1/Zg1(6) 0 0 0 0 -1/Zline(6,11) -1/Zline(6,12) -1/Zline(6,13) 0
         0 0 0 -1/Zt(3) 0 0 1/Zt(3)+Y1t(3)+1/Zt(4)+1/Zline(7,9) -1/Zt(4) -1/Zline(7,9) 0 0 0 0 0
         0 0 0 0 0 0 -1/Zt(4) 1/Zt(4)+1/Zg1(8) 0 0 0 0 0 0
         0 0 0 -1/Zt(2) 0 0 -1/Zline(9,7) 0 1/Zline(9,7)+1/Zt(2)+Y1t(2)+1/Zline(9,10)+1/Zline(9,14)+1/Zload(9) -1/Zline(9,10) 0 0 0 1/Zline(9,14)
         0 0 0 0 0 0 0 0 -1/Zline(10,9) 1/Zline(10,9)+1/Zline(10,11)+1/Zload(10) -1/Zline(10,11) 0 0 0
         0 0 0 0 0 -1/Zline(11,6) 0 0 0 -1/Zline(11,10) 1/Zline(11,6)+1/Zline(11,10)+1/Zload(11) 0 0 0
         0 0 0 0 0 -1/Zline(12,6) 0 0 0 0 0 1/Zline(12,6)+1/Zline(12,13)+1/Zload(12) -1/Zline(12,13) 0
         0 0 0 0 0 -1/Zline(13,6) 0 0 0 0 0 -1/Zline(13,12) 1/Zline(13,6)+1/Zline(13,12)+1/Zline(13,14)+1/Zload(13) -1/Zline(13,14)
         0 0 0 0 0 0 0 0 -1/Zline(14,9) 0 0 0 -1/Zline(14,13) 1/Zline(14,9)+1/Zline(14,13)+1/Zload(14)];

% Note that all line data (R0, X0, B0) for zero sequence are equal to 3X
% the line impedances for positive sequence(X1, B1) EXCEPT for line 7-9
Ybus0 = [1/(Zline(1,2)*3)+Bline(1,2)*3/2+1/(Zline(1,5)*3)+Bline(1,5)*3/2+1/Zg0(1) -1/(Zline(1,2)*3) 0 0 -1/(Zline(1,5)*3) 0 0 0 0 0 0 0 0 0
         -1/(Zline(2,1)*3) 1/(Zline(2,1)*3)+Bline(2,1)*3/2+1/(Zline(2,3)*3)+Bline(2,3)*3/2+1/(Zline(2,4)*3)+Bline(2,4)*3/2+1/(Zline(2,5)*3)+Bline(2,5)*3/2+1/Zg0(2)+1/Zload(2) -1/(Zline(2,3)*3) -1/(Zline(2,4)*3) -1/(Zline(2,5)*3) 0 0 0 0 0 0 0 0 0
         0 -1/(Zline(3,2)*3) 1/(Zline(3,2)*3)+Bline(3,2)*3/2+1/(Zline(3,4)*3)+Bline(3,4)*3/2+1/Zg0(3)+1/Zload(3) -1/(Zline(3,4)*3) 0 0 0 0 0 0 0 0 0 0
         0 -1/(Zline(4,2)*3) -1/(Zline(4,3)*3) 1/(Zline(4,2)*3)+Bline(4,2)*3/2+1/(Zline(4,3)*3)+Bline(4,3)*3/2+1/(Zline(4,5)*3)+Bline(4,5)*3/2+1/Zload(4)+1/Zt(3)+Y2t(3)+1/Zt(2)+Y2t(2) -1/(Zline(4,5)*3) 0 0 0 0 0 0 0 0 0
         -1/(Zline(5,1)*3) -1/(Zline(5,2)*3) 0 -1/(Zline(5,4)*3) 1/(Zline(5,1)*3)+Bline(5,1)*3/2+1/(Zline(5,2)*3)+Bline(5,2)*3/2+1/(Zline(5,4)*3)+Bline(5,4)*3/2+1/Zload(5)+1/Zt(1)+Y2t(1) 0 0 0 0 0 0 0 0 0
         0 0 0 0 0 1/Zt(1)+Y1t(1)+1/(Zline(6,11)*3)+1/(Zline(6,12)*3)+1/(Zline(6,13)*3)+1/Zload(6)+1/Zg0(6) 0 0 0 0 -1/(Zline(6,11)*3) -1/(Zline(6,12)*3) -1/(Zline(6,13)*3) 0
         0 0 0 0 0 0 1/Zline(7,9) 0 -1/Zline(7,9) 0 0 0 0 0
         0 0 0 0 0 0 0 1/Zg0(8) 0 0 0 0 0 0
         0 0 0 0 0 0 -1/Zline(9,7) 0 1/Zline(9,7)+1/(Zline(9,10)*3)+1/(Zline(9,14)*3)+1/Zload(9) -1/(Zline(9,10)*3) 0 0 0 1/(Zline(9,14)*3)
         0 0 0 0 0 0 0 0 -1/(Zline(10,9)*3) 1/(Zline(10,9)*3)+1/(Zline(10,11)*3)+1/Zload(10) -1/(Zline(10,11)*3) 0 0 0
         0 0 0 0 0 -1/(Zline(11,6)*3) 0 0 0 -1/(Zline(11,10)*3) 1/(Zline(11,6)*3)+1/(Zline(11,10)*3)+1/Zload(11) 0 0 0
         0 0 0 0 0 -1/(Zline(12,6)*3) 0 0 0 0 0 1/(Zline(12,6)*3)+1/(Zline(12,13)*3)+1/Zload(12) -1/(Zline(12,13)*3) 0
         0 0 0 0 0 -1/(Zline(13,6)*3) 0 0 0 0 0 -1/(Zline(13,12)*3) 1/(Zline(13,6)*3)+1/(Zline(13,12)*3)+1/(Zline(13,14)*3)+1/Zload(13) -1/(Zline(13,14)*3)
         0 0 0 0 0 0 0 0 -1/(Zline(14,9)*3) 0 0 0 -1/(Zline(14,13)*3) 1/(Zline(14,9)*3)+1/(Zline(14,13)*3)+1/Zload(14)];

% Define sequence pre-fault voltages
V0_pf = zeros(14,1);
V2_pf = zeros(14,1);
V1_pf = [1.06;1.045;1.01;1.011638;1.047807;1.01579;1.07;1.08671;1.03171;1.030899;1.046635;1.053348;1.04681;1.02];

% Define base voltage matrix
Vbase = [69 69 69 69 69 13.8 13.8 18 13.8 13.8 13.8 13.8 13.8 13.8;69 69 69 69 69 13.8 13.8 18 13.8 13.8 13.8 13.8 13.8 13.8;69 69 69 69 69 13.8 13.8 18 13.8 13.8 13.8 13.8 13.8 13.8];

% Define fault matrices
Yfabc_1 = [9e9 0 0;0 0 0;0 0 0];  % SLG fault -> admittance matrix
Zfabc_3 = zeros(3,3);             % 3PH fault -> impedance matrix

% Calculate fault matrix in sequences
Yf012_1=(A^-1)*Yfabc_1*A; 
Zf012_3=(A^-1)*Zfabc_3*A;

% Use LU decomposition to solve for Z14 in each sequence
[L1 U1]=lu(Ybus1);
[L0 U0]=lu(Ybus0);
e14=eye(14);
X1=(L1^-1)*e14(:,14);
X0=(L0^-1)*e14(:,14);
Z14_1=(U1^-1)*X1;
Z14_0=(U0^-1)*X0;
Z14_2=Z14_1;

Z14_012 =[Z14_0(14) 0 0;0 Z14_1(14) 0;0 0 Z14_2(14)];

% Calculate sequence SLG fault current
If012_1=((Yf012_1*Z14_012+eye(3))^-1)*Yf012_1*[V0_pf(14);V1_pf(14);V2_pf(14)];

% SLG fault A-B-C phase currents
Ifabc_1=A*If012_1;
Ifabc_1_mag=abs(Ifabc_1);
Ifabc_1_angle=radtodeg(angle(Ifabc_1));

% Calculate sequence 3PH fault current
If012_3=((Z14_012+Zf012_3)^-1)*[V0_pf(14);V1_pf(14);V2_pf(14)];

% 3PH fault A-B-C phase currents
Ifabc_3=A*If012_3;
% Convert from rectangular to polar form
Ifabc_3_mag=abs(Ifabc_3);
Ifabc_3_angle=radtodeg(angle(Ifabc_3));

% Calculate fault voltages at each bus for zero sequence (SLG fault)
V0_f1=V0_pf-If012_1(1)*Z14_0;

% Calculate fault voltages at each bus for positive sequence (SLG fault)
V1_f1=V1_pf-If012_1(2)*Z14_1;

% Calculate fault voltages at each bus for negative sequence (SLG fault)
V2_f1=V2_pf-If012_1(3)*Z14_2;

V_aux1=[V0_f1,V1_f1,V2_f1]';
% Matrix containing fault voltages at each bus (columns) for each A-B-C
% phase (rows)
Vabc_f1=A*V_aux1;

% Convert from rectangular to polar form
Vabc_f1_mag=abs(Vabc_f1);
Vabc_f1_angle=radtodeg(angle(Vabc_f1));

% Calculate fault voltages at each bus for zero sequence (SLG fault)
V0_f3=V0_pf-If012_3(1)*Z14_0;

% Calculate fault voltages at each bus for positive sequence (SLG fault)
V1_f3=V1_pf-If012_3(2)*Z14_1;

% Calculate fault voltages at each bus for negative sequence (SLG fault)
V2_f3=V2_pf-If012_3(3)*Z14_2;

V_aux3=[V0_f3,V1_f3,V2_f3]';
% Matrix containing fault voltages at each bus (columns) for each A-B-C
% phase (rows)
Vabc_f3=A*V_aux3;

% Convert from rectangular to polar form
Vabc_f3_mag=abs(Vabc_f3);
Vabc_f3_angle=radtodeg(angle(Vabc_f3));

% Part 2C - Line 9-14 & 13-14 fault currents
% Calculate fault currents at line 9-14 for SLG fault
If012_1_9to14=[(V0_f1(9)-V0_f1(14))*(-Ybus0(9,14)); (V1_f1(9)-V1_f1(14))*(-Ybus1(9,14)); (V2_f1(9)-V2_f1(14))*(-Ybus1(9,14))];
Ifabc_1_9to14=A*If012_1_9to14;
% Convert from rectangular to polar form
Ifabc_1_9to14_mag=abs(Ifabc_1_9to14);
Ifabc_1_9to14_angle=radtodeg(angle(Ifabc_1_9to14));

% Calculate fault currents at line 13-14 for SLG fault
If012_1_13to14=[(V0_f1(13)-V0_f1(14))*(-Ybus0(13,14)); (V1_f1(13)-V1_f1(14))*(-Ybus1(13,14)); (V2_f1(13)-V2_f1(14))*(-Ybus1(13,14))];
Ifabc_1_13to14=A*If012_1_13to14;
% Convert from rectangular to polar form
Ifabc_1_13to14_mag=abs(Ifabc_1_13to14);
Ifabc_1_13to14_angle=radtodeg(angle(Ifabc_1_13to14));

% Calculate fault currents at line 9-14 for 3PH fault
If012_3_9to14=[(V0_f3(9)-V0_f3(14))*(-Ybus0(9,14)); (V1_f3(9)-V1_f3(14))*(-Ybus1(9,14)); (V2_f3(9)-V2_f3(14))*(-Ybus1(9,14))];
Ifabc_3_9to14=A*If012_3_9to14;
% Convert from rectangular to polar form
Ifabc_3_9to14_mag=abs(Ifabc_3_9to14);
Ifabc_3_9to14_angle=radtodeg(angle(Ifabc_3_9to14));

% Calculate fault currents at line 13-14 for 3PH fault
If012_3_13to14=[(V0_f3(13)-V0_f3(14))*(-Ybus0(13,14)); (V1_f3(13)-V1_f3(14))*(-Ybus1(13,14)); (V2_f3(13)-V2_f3(14))*(-Ybus1(13,14))];
Ifabc_3_13to14=A*If012_3_13to14;
% Convert from rectangular to polar form
Ifabc_3_13to14_mag=abs(Ifabc_3_13to14);
Ifabc_3_13to14_angle=radtodeg(angle(Ifabc_3_13to14));

