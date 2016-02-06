function ceq_nnc=pfloweqs_nnc(x,S)

Vs=S.Bus.Voltages(S.Bus.SlackList);
V=S.Bus.Voltages(S.Bus.PVList);
Pg=real(S.Bus.Generation);
Qg=imag(S.Bus.Generation);
Pl=real(S.Bus.Load);
Ql=imag(S.Bus.Load);

% Slack bus (Type 3)
Pg1=x(1);
Qg1=x(2);
V1=Vs;
d1=0;
V2=x(3);
d2=x(4);
V3=x(5);
d3=x(6);
V4=x(7);
d4=x(8);
V5=x(9);
d5=x(10);
V6=x(11);
d6=x(12);
V7=x(13);
d7=x(14);
V8=x(15);
d8=x(16);
V9=x(17);
d9=x(18);
V10=x(19);
d10=x(20);
V11=x(21);
d11=x(22);
V12=x(23);
d12=x(24);
V13=x(25);
d13=x(26);
V14=x(27);
d14=x(28);
V15=x(29);
d15=x(30);
V16=x(31);
d16=x(32);
V17=x(33);
d17=x(34);
V18=x(35);
d18=x(36);
V19=x(37);
d19=x(38);
V20=x(39);
d20=x(40);
V21=x(41);
d21=x(42);
V22=x(43);
d22=x(44);
V23=x(45);
d23=x(46);
V24=x(47);
d24=x(48);
V25=x(49);
d25=x(50);
V26=x(51);
d26=x(52);
V27=x(53);
d27=x(54);
V28=x(55);
d28=x(56);
V29=x(57);
d29=x(58);
V30=x(59);
d30=x(60);
V31=x(61);
d31=x(62);
V32=x(63);
d32=x(64);
V33=x(65);
d33=x(66);
V34=x(67);
d34=x(68);
V35=x(69);
d35=x(70);
V36=x(71);
d36=x(72);
V37=x(73);
d37=x(74);
V38=x(75);
d38=x(76);
V39=x(77);
d39=x(78);
% PQ buses with generators (Type 1)
Pg11=x(79);
% PQ buses with generators (Type 1)
Pg15=x(80);
% PQ buses with generators (Type 1)
Pg22=x(81);
% PQ buses with generators (Type 1)
Pg37=x(82);
% PQ buses with generators (Type 1)
Pg38=x(83);


ceq_nnc = [Pg1-Pl(1)-real(-1.0*(V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(- 197.16*i - 104.82) + V2*cos(d2)*(4.3249*i + 6.9682) + V3*cos(d3)*(52.588*i + 26.694) + V4*cos(d4)*(105.17*i + 53.372) + V5*cos(d5)*(17.537*i + 8.8922) + V6*cos(d6)*(17.535*i + 8.8891) + V1*sin(d1)*(104.82*i - 197.16) + V2*sin(d2)*(4.3249 - 6.9682*i) + V3*sin(d3)*(52.588 - 26.694*i) + V4*sin(d4)*(105.17 - 53.372*i) + V5*sin(d5)*(17.537 - 8.8922*i) + V6*sin(d6)*(17.535 - 8.8891*i)));
Qg1-Ql(1)-imag(-1.0*(V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(- 197.16*i - 104.82) + V2*cos(d2)*(4.3249*i + 6.9682) + V3*cos(d3)*(52.588*i + 26.694) + V4*cos(d4)*(105.17*i + 53.372) + V5*cos(d5)*(17.537*i + 8.8922) + V6*cos(d6)*(17.535*i + 8.8891) + V1*sin(d1)*(104.82*i - 197.16) + V2*sin(d2)*(4.3249 - 6.9682*i) + V3*sin(d3)*(52.588 - 26.694*i) + V4*sin(d4)*(105.17 - 53.372*i) + V5*sin(d5)*(17.537 - 8.8922*i) + V6*sin(d6)*(17.535 - 8.8891*i)));
-Pl(2)-real(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(4.3249*i + 6.9682) + V2*cos(d2)*(- 4.3247*i - 6.9682) + V1*sin(d1)*(4.3249 - 6.9682*i) + V2*sin(d2)*(6.9682*i - 4.3247)));
-Ql(2)-imag(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(4.3249*i + 6.9682) + V2*cos(d2)*(- 4.3247*i - 6.9682) + V1*sin(d1)*(4.3249 - 6.9682*i) + V2*sin(d2)*(6.9682*i - 4.3247)));
-Pl(3)-real(-1.0*(V3*cos(d3) + V3*sin(d3)*(1.0*i + 0.0))*(V1*cos(d1)*(52.588*i + 26.694) + V3*cos(d3)*(- 52.588*i - 26.694) + V1*sin(d1)*(52.588 - 26.694*i) + V3*sin(d3)*(26.694*i - 52.588)));
-Ql(3)-imag(-1.0*(V3*cos(d3) + V3*sin(d3)*(1.0*i + 0.0))*(V1*cos(d1)*(52.588*i + 26.694) + V3*cos(d3)*(- 52.588*i - 26.694) + V1*sin(d1)*(52.588 - 26.694*i) + V3*sin(d3)*(26.694*i - 52.588)));
-Pl(4)-real(-1.0*(V4*cos(d4) + V4*sin(d4)*(1.0*i + 0.0))*(V1*cos(d1)*(105.17*i + 53.372) + V4*cos(d4)*(- 209.97*i - 107.01) + V7*cos(d7)*(104.8*i + 53.642) + V1*sin(d1)*(105.17 - 53.372*i) + V4*sin(d4)*(107.01*i - 209.97) + V7*sin(d7)*(104.8 - 53.642*i)));
-Ql(4)-imag(-1.0*(V4*cos(d4) + V4*sin(d4)*(1.0*i + 0.0))*(V1*cos(d1)*(105.17*i + 53.372) + V4*cos(d4)*(- 209.97*i - 107.01) + V7*cos(d7)*(104.8*i + 53.642) + V1*sin(d1)*(105.17 - 53.372*i) + V4*sin(d4)*(107.01*i - 209.97) + V7*sin(d7)*(104.8 - 53.642*i)));
-Pl(5)-real(-1.0*(V5*cos(d5) + V5*sin(d5)*(1.0*i + 0.0))*(V1*cos(d1)*(17.537*i + 8.8922) + V5*cos(d5)*(- 17.537*i - 8.8922) + V1*sin(d1)*(17.537 - 8.8922*i) + V5*sin(d5)*(8.8922*i - 17.537)));
-Ql(5)-imag(-1.0*(V5*cos(d5) + V5*sin(d5)*(1.0*i + 0.0))*(V1*cos(d1)*(17.537*i + 8.8922) + V5*cos(d5)*(- 17.537*i - 8.8922) + V1*sin(d1)*(17.537 - 8.8922*i) + V5*sin(d5)*(8.8922*i - 17.537)));
-Pl(6)-real(-1.0*(V6*cos(d6) + V6*sin(d6)*(1.0*i + 0.0))*(V1*cos(d1)*(17.535*i + 8.8891) + V6*cos(d6)*(- 17.535*i - 8.8891) + V1*sin(d1)*(17.535 - 8.8891*i) + V6*sin(d6)*(8.8891*i - 17.535)));
-Ql(6)-imag(-1.0*(V6*cos(d6) + V6*sin(d6)*(1.0*i + 0.0))*(V1*cos(d1)*(17.535*i + 8.8891) + V6*cos(d6)*(- 17.535*i - 8.8891) + V1*sin(d1)*(17.535 - 8.8891*i) + V6*sin(d6)*(8.8891*i - 17.535)));
-Pl(7)-real(-1.0*(V7*cos(d7) + V7*sin(d7)*(1.0*i + 0.0))*(V4*cos(d4)*(104.8*i + 53.642) + V7*cos(d7)*(- 255.85*i - 78.314) + V8*cos(d8)*(51.048*i + 24.672) + V10*cos(d10)*(100.0*i + 0.0) + V4*sin(d4)*(104.8 - 53.642*i) + V7*sin(d7)*(78.314*i - 255.85) + V8*sin(d8)*(51.048 - 24.672*i) + 100.0*V10*sin(d10)));
-Ql(7)-imag(-1.0*(V7*cos(d7) + V7*sin(d7)*(1.0*i + 0.0))*(V4*cos(d4)*(104.8*i + 53.642) + V7*cos(d7)*(- 255.85*i - 78.314) + V8*cos(d8)*(51.048*i + 24.672) + V10*cos(d10)*(100.0*i + 0.0) + V4*sin(d4)*(104.8 - 53.642*i) + V7*sin(d7)*(78.314*i - 255.85) + V8*sin(d8)*(51.048 - 24.672*i) + 100.0*V10*sin(d10)));
-Pl(8)-real(-1.0*(V8*cos(d8) + V8*sin(d8)*(1.0*i + 0.0))*(V7*cos(d7)*(51.048*i + 24.672) + V8*cos(d8)*(- 102.1*i - 49.347) + V9*cos(d9)*(51.05*i + 24.675) + V7*sin(d7)*(51.048 - 24.672*i) + V8*sin(d8)*(49.347*i - 102.1) + V9*sin(d9)*(51.05 - 24.675*i)));
-Ql(8)-imag(-1.0*(V8*cos(d8) + V8*sin(d8)*(1.0*i + 0.0))*(V7*cos(d7)*(51.048*i + 24.672) + V8*cos(d8)*(- 102.1*i - 49.347) + V9*cos(d9)*(51.05*i + 24.675) + V7*sin(d7)*(51.048 - 24.672*i) + V8*sin(d8)*(49.347*i - 102.1) + V9*sin(d9)*(51.05 - 24.675*i)));
-Pl(9)-real(-1.0*(V9*cos(d9) + V9*sin(d9)*(1.0*i + 0.0))*(V8*cos(d8)*(51.05*i + 24.675) + V9*cos(d9)*(- 51.05*i - 24.675) + V8*sin(d8)*(51.05 - 24.675*i) + V9*sin(d9)*(24.675*i - 51.05)));
-Ql(9)-imag(-1.0*(V9*cos(d9) + V9*sin(d9)*(1.0*i + 0.0))*(V8*cos(d8)*(51.05*i + 24.675) + V9*cos(d9)*(- 51.05*i - 24.675) + V8*sin(d8)*(51.05 - 24.675*i) + V9*sin(d9)*(24.675*i - 51.05)));
-Pl(10)-real(-1.0*(V10*cos(d10) + V10*sin(d10)*(1.0*i + 0.0))*(V7*cos(d7)*(100.0*i + 0.0) + V10*cos(d10)*(- 215.85*i - 92.213) + V11*cos(d11)*(52.393*i + 47.63) + V12*cos(d12)*(51.208*i + 24.875) + V14*cos(d14)*(12.25*i + 19.708) + 100.0*V7*sin(d7) + V10*sin(d10)*(92.213*i - 215.85) + V11*sin(d11)*(52.393 - 47.63*i) + V12*sin(d12)*(51.208 - 24.875*i) + V14*sin(d14)*(12.25 - 19.708*i)));
-Ql(10)-imag(-1.0*(V10*cos(d10) + V10*sin(d10)*(1.0*i + 0.0))*(V7*cos(d7)*(100.0*i + 0.0) + V10*cos(d10)*(- 215.85*i - 92.213) + V11*cos(d11)*(52.393*i + 47.63) + V12*cos(d12)*(51.208*i + 24.875) + V14*cos(d14)*(12.25*i + 19.708) + 100.0*V7*sin(d7) + V10*sin(d10)*(92.213*i - 215.85) + V11*sin(d11)*(52.393 - 47.63*i) + V12*sin(d12)*(51.208 - 24.875*i) + V14*sin(d14)*(12.25 - 19.708*i)));
Pg11-Pl(11)-real(-1.0*(V11*cos(d11) + V11*sin(d11)*(1.0*i + 0.0))*(V10*cos(d10)*(52.393*i + 47.63) + V11*cos(d11)*(- 52.393*i - 47.63) + V10*sin(d10)*(52.393 - 47.63*i) + V11*sin(d11)*(47.63*i - 52.393)));
Pg11*4.259982e-01-Ql(11)-imag(-1.0*(V11*cos(d11) + V11*sin(d11)*(1.0*i + 0.0))*(V10*cos(d10)*(52.393*i + 47.63) + V11*cos(d11)*(- 52.393*i - 47.63) + V10*sin(d10)*(52.393 - 47.63*i) + V11*sin(d11)*(47.63*i - 52.393)));
-Pl(12)-real(-1.0*(V12*cos(d12) + V12*sin(d12)*(1.0*i + 0.0))*(V10*cos(d10)*(51.208*i + 24.875) + V12*cos(d12)*(- 102.26*i - 49.547) + V13*cos(d13)*(51.048*i + 24.672) + V10*sin(d10)*(51.208 - 24.875*i) + V12*sin(d12)*(49.547*i - 102.26) + V13*sin(d13)*(51.048 - 24.672*i)));
-Ql(12)-imag(-1.0*(V12*cos(d12) + V12*sin(d12)*(1.0*i + 0.0))*(V10*cos(d10)*(51.208*i + 24.875) + V12*cos(d12)*(- 102.26*i - 49.547) + V13*cos(d13)*(51.048*i + 24.672) + V10*sin(d10)*(51.208 - 24.875*i) + V12*sin(d12)*(49.547*i - 102.26) + V13*sin(d13)*(51.048 - 24.672*i)));
-Pl(13)-real(-1.0*(V13*cos(d13) + V13*sin(d13)*(1.0*i + 0.0))*(V12*cos(d12)*(51.048*i + 24.672) + V13*cos(d13)*(- 68.067*i - 32.898) + V23*cos(d23)*(17.02*i + 8.2257) + V12*sin(d12)*(51.048 - 24.672*i) + V13*sin(d13)*(32.898*i - 68.067) + V23*sin(d23)*(17.02 - 8.2257*i)));
-Ql(13)-imag(-1.0*(V13*cos(d13) + V13*sin(d13)*(1.0*i + 0.0))*(V12*cos(d12)*(51.048*i + 24.672) + V13*cos(d13)*(- 68.067*i - 32.898) + V23*cos(d23)*(17.02*i + 8.2257) + V12*sin(d12)*(51.048 - 24.672*i) + V13*sin(d13)*(32.898*i - 68.067) + V23*sin(d23)*(17.02 - 8.2257*i)));
-Pl(14)-real(-1.0*(V14*cos(d14) + V14*sin(d14)*(1.0*i + 0.0))*(V10*cos(d10)*(12.25*i + 19.708) + V14*cos(d14)*(- 78.04*i - 102.33) + V15*cos(d15)*(32.256*i + 51.976) + V16*cos(d16)*(33.534*i + 30.645) + V10*sin(d10)*(12.25 - 19.708*i) + V14*sin(d14)*(102.33*i - 78.04) + V15*sin(d15)*(32.256 - 51.976*i) + V16*sin(d16)*(33.534 - 30.645*i)));
-Ql(14)-imag(-1.0*(V14*cos(d14) + V14*sin(d14)*(1.0*i + 0.0))*(V10*cos(d10)*(12.25*i + 19.708) + V14*cos(d14)*(- 78.04*i - 102.33) + V15*cos(d15)*(32.256*i + 51.976) + V16*cos(d16)*(33.534*i + 30.645) + V10*sin(d10)*(12.25 - 19.708*i) + V14*sin(d14)*(102.33*i - 78.04) + V15*sin(d15)*(32.256 - 51.976*i) + V16*sin(d16)*(33.534 - 30.645*i)));
Pg15-Pl(15)-real(-1.0*(V15*cos(d15) + V15*sin(d15)*(1.0*i + 0.0))*(V14*cos(d14)*(32.256*i + 51.976) + V15*cos(d15)*(- 32.256*i - 51.976) + V14*sin(d14)*(32.256 - 51.976*i) + V15*sin(d15)*(51.976*i - 32.256)));
Pg15*4.259982e-01-Ql(15)-imag(-1.0*(V15*cos(d15) + V15*sin(d15)*(1.0*i + 0.0))*(V14*cos(d14)*(32.256*i + 51.976) + V15*cos(d15)*(- 32.256*i - 51.976) + V14*sin(d14)*(32.256 - 51.976*i) + V15*sin(d15)*(51.976*i - 32.256)));
-Pl(16)-real(-1.0*(V16*cos(d16) + V16*sin(d16)*(1.0*i + 0.0))*(V14*cos(d14)*(33.534*i + 30.645) + V16*cos(d16)*(- 44.723*i - 40.854) + V17*cos(d17)*(11.189*i + 10.209) + V14*sin(d14)*(33.534 - 30.645*i) + V16*sin(d16)*(40.854*i - 44.723) + V17*sin(d17)*(11.189 - 10.209*i)));
-Ql(16)-imag(-1.0*(V16*cos(d16) + V16*sin(d16)*(1.0*i + 0.0))*(V14*cos(d14)*(33.534*i + 30.645) + V16*cos(d16)*(- 44.723*i - 40.854) + V17*cos(d17)*(11.189*i + 10.209) + V14*sin(d14)*(33.534 - 30.645*i) + V16*sin(d16)*(40.854*i - 44.723) + V17*sin(d17)*(11.189 - 10.209*i)));
-Pl(17)-real(-1.0*(V17*cos(d17) + V17*sin(d17)*(1.0*i + 0.0))*(V16*cos(d16)*(11.189*i + 10.209) + V17*cos(d17)*(- 40.25*i - 31.431) + V18*cos(d18)*(16.762*i + 15.323) + V23*cos(d23)*(12.3*i + 5.8987) + V16*sin(d16)*(11.189 - 10.209*i) + V17*sin(d17)*(31.431*i - 40.25) + V18*sin(d18)*(16.762 - 15.323*i) + V23*sin(d23)*(12.3 - 5.8987*i)));
-Ql(17)-imag(-1.0*(V17*cos(d17) + V17*sin(d17)*(1.0*i + 0.0))*(V16*cos(d16)*(11.189*i + 10.209) + V17*cos(d17)*(- 40.25*i - 31.431) + V18*cos(d18)*(16.762*i + 15.323) + V23*cos(d23)*(12.3*i + 5.8987) + V16*sin(d16)*(11.189 - 10.209*i) + V17*sin(d17)*(31.431*i - 40.25) + V18*sin(d18)*(16.762 - 15.323*i) + V23*sin(d23)*(12.3 - 5.8987*i)));
-Pl(18)-real(-1.0*(V18*cos(d18) + V18*sin(d18)*(1.0*i + 0.0))*(V17*cos(d17)*(16.762*i + 15.323) + V18*cos(d18)*(- 50.295*i - 45.968) + V19*cos(d19)*(33.534*i + 30.645) + V17*sin(d17)*(16.762 - 15.323*i) + V18*sin(d18)*(45.968*i - 50.295) + V19*sin(d19)*(33.534 - 30.645*i)));
-Ql(18)-imag(-1.0*(V18*cos(d18) + V18*sin(d18)*(1.0*i + 0.0))*(V17*cos(d17)*(16.762*i + 15.323) + V18*cos(d18)*(- 50.295*i - 45.968) + V19*cos(d19)*(33.534*i + 30.645) + V17*sin(d17)*(16.762 - 15.323*i) + V18*sin(d18)*(45.968*i - 50.295) + V19*sin(d19)*(33.534 - 30.645*i)));
-Pl(19)-real(-1.0*(V19*cos(d19) + V19*sin(d19)*(1.0*i + 0.0))*(V18*cos(d18)*(33.534*i + 30.645) + V19*cos(d19)*(- 118.63*i - 71.776) + V20*cos(d20)*(51.05*i + 24.675) + V21*cos(d21)*(34.044*i + 16.457) + V18*sin(d18)*(33.534 - 30.645*i) + V19*sin(d19)*(71.776*i - 118.63) + V20*sin(d20)*(51.05 - 24.675*i) + V21*sin(d21)*(34.044 - 16.457*i)));
-Ql(19)-imag(-1.0*(V19*cos(d19) + V19*sin(d19)*(1.0*i + 0.0))*(V18*cos(d18)*(33.534*i + 30.645) + V19*cos(d19)*(- 118.63*i - 71.776) + V20*cos(d20)*(51.05*i + 24.675) + V21*cos(d21)*(34.044*i + 16.457) + V18*sin(d18)*(33.534 - 30.645*i) + V19*sin(d19)*(71.776*i - 118.63) + V20*sin(d20)*(51.05 - 24.675*i) + V21*sin(d21)*(34.044 - 16.457*i)));
-Pl(20)-real(-1.0*(V20*cos(d20) + V20*sin(d20)*(1.0*i + 0.0))*(V19*cos(d19)*(51.05*i + 24.675) + V20*cos(d20)*(- 102.12*i - 49.372) + V22*cos(d22)*(51.068*i + 24.697) + V19*sin(d19)*(51.05 - 24.675*i) + V20*sin(d20)*(49.372*i - 102.12) + V22*sin(d22)*(51.068 - 24.697*i)));
-Ql(20)-imag(-1.0*(V20*cos(d20) + V20*sin(d20)*(1.0*i + 0.0))*(V19*cos(d19)*(51.05*i + 24.675) + V20*cos(d20)*(- 102.12*i - 49.372) + V22*cos(d22)*(51.068*i + 24.697) + V19*sin(d19)*(51.05 - 24.675*i) + V20*sin(d20)*(49.372*i - 102.12) + V22*sin(d22)*(51.068 - 24.697*i)));
-Pl(21)-real(-1.0*(V21*cos(d21) + V21*sin(d21)*(1.0*i + 0.0))*(V19*cos(d19)*(34.044*i + 16.457) + V21*cos(d21)*(- 34.044*i - 16.457) + V19*sin(d19)*(34.044 - 16.457*i) + V21*sin(d21)*(16.457*i - 34.044)));
-Ql(21)-imag(-1.0*(V21*cos(d21) + V21*sin(d21)*(1.0*i + 0.0))*(V19*cos(d19)*(34.044*i + 16.457) + V21*cos(d21)*(- 34.044*i - 16.457) + V19*sin(d19)*(34.044 - 16.457*i) + V21*sin(d21)*(16.457*i - 34.044)));
Pg22-Pl(22)-real(-1.0*(V22*cos(d22) + V22*sin(d22)*(1.0*i + 0.0))*(V20*cos(d20)*(51.068*i + 24.697) + V22*cos(d22)*(- 51.068*i - 24.697) + V20*sin(d20)*(51.068 - 24.697*i) + V22*sin(d22)*(24.697*i - 51.068)));
Pg22*4.259982e-01-Ql(22)-imag(-1.0*(V22*cos(d22) + V22*sin(d22)*(1.0*i + 0.0))*(V20*cos(d20)*(51.068*i + 24.697) + V22*cos(d22)*(- 51.068*i - 24.697) + V20*sin(d20)*(51.068 - 24.697*i) + V22*sin(d22)*(24.697*i - 51.068)));
-Pl(23)-real(-1.0*(V23*cos(d23) + V23*sin(d23)*(1.0*i + 0.0))*(V13*cos(d13)*(17.02*i + 8.2257) + V17*cos(d17)*(12.3*i + 5.8987) + V23*cos(d23)*(- 64.821*i - 31.291) + V24*cos(d24)*(13.305*i + 6.4383) + V27*cos(d27)*(22.197*i + 10.728) + V13*sin(d13)*(17.02 - 8.2257*i) + V17*sin(d17)*(12.3 - 5.8987*i) + V23*sin(d23)*(31.291*i - 64.821) + V24*sin(d24)*(13.305 - 6.4383*i) + V27*sin(d27)*(22.197 - 10.728*i)));
-Ql(23)-imag(-1.0*(V23*cos(d23) + V23*sin(d23)*(1.0*i + 0.0))*(V13*cos(d13)*(17.02*i + 8.2257) + V17*cos(d17)*(12.3*i + 5.8987) + V23*cos(d23)*(- 64.821*i - 31.291) + V24*cos(d24)*(13.305*i + 6.4383) + V27*cos(d27)*(22.197*i + 10.728) + V13*sin(d13)*(17.02 - 8.2257*i) + V17*sin(d17)*(12.3 - 5.8987*i) + V23*sin(d23)*(31.291*i - 64.821) + V24*sin(d24)*(13.305 - 6.4383*i) + V27*sin(d27)*(22.197 - 10.728*i)));
-Pl(24)-real(-1.0*(V24*cos(d24) + V24*sin(d24)*(1.0*i + 0.0))*(V23*cos(d23)*(13.305*i + 6.4383) + V24*cos(d24)*(- 52.578*i - 25.422) + V25*cos(d25)*(39.273*i + 18.984) + V23*sin(d23)*(13.305 - 6.4383*i) + V24*sin(d24)*(25.422*i - 52.578) + V25*sin(d25)*(39.273 - 18.984*i)));
-Ql(24)-imag(-1.0*(V24*cos(d24) + V24*sin(d24)*(1.0*i + 0.0))*(V23*cos(d23)*(13.305*i + 6.4383) + V24*cos(d24)*(- 52.578*i - 25.422) + V25*cos(d25)*(39.273*i + 18.984) + V23*sin(d23)*(13.305 - 6.4383*i) + V24*sin(d24)*(25.422*i - 52.578) + V25*sin(d25)*(39.273 - 18.984*i)));
-Pl(25)-real(-1.0*(V25*cos(d25) + V25*sin(d25)*(1.0*i + 0.0))*(V24*cos(d24)*(39.273*i + 18.984) + V25*cos(d25)*(- 90.323*i - 43.659) + V26*cos(d26)*(51.05*i + 24.675) + V24*sin(d24)*(39.273 - 18.984*i) + V25*sin(d25)*(43.659*i - 90.323) + V26*sin(d26)*(51.05 - 24.675*i)));
-Ql(25)-imag(-1.0*(V25*cos(d25) + V25*sin(d25)*(1.0*i + 0.0))*(V24*cos(d24)*(39.273*i + 18.984) + V25*cos(d25)*(- 90.323*i - 43.659) + V26*cos(d26)*(51.05*i + 24.675) + V24*sin(d24)*(39.273 - 18.984*i) + V25*sin(d25)*(43.659*i - 90.323) + V26*sin(d26)*(51.05 - 24.675*i)));
-Pl(26)-real(-1.0*(V26*cos(d26) + V26*sin(d26)*(1.0*i + 0.0))*(V25*cos(d25)*(51.05*i + 24.675) + V26*cos(d26)*(- 51.05*i - 24.675) + V25*sin(d25)*(51.05 - 24.675*i) + V26*sin(d26)*(24.675*i - 51.05)));
-Ql(26)-imag(-1.0*(V26*cos(d26) + V26*sin(d26)*(1.0*i + 0.0))*(V25*cos(d25)*(51.05*i + 24.675) + V26*cos(d26)*(- 51.05*i - 24.675) + V25*sin(d25)*(51.05 - 24.675*i) + V26*sin(d26)*(24.675*i - 51.05)));
-Pl(27)-real(-1.0*(V27*cos(d27) + V27*sin(d27)*(1.0*i + 0.0))*(V23*cos(d23)*(22.197*i + 10.728) + V27*cos(d27)*(- 90.298*i - 43.668) + V28*cos(d28)*(68.101*i + 32.94) + V23*sin(d23)*(22.197 - 10.728*i) + V27*sin(d27)*(43.668*i - 90.298) + V28*sin(d28)*(68.101 - 32.94*i)));
-Ql(27)-imag(-1.0*(V27*cos(d27) + V27*sin(d27)*(1.0*i + 0.0))*(V23*cos(d23)*(22.197*i + 10.728) + V27*cos(d27)*(- 90.298*i - 43.668) + V28*cos(d28)*(68.101*i + 32.94) + V23*sin(d23)*(22.197 - 10.728*i) + V27*sin(d27)*(43.668*i - 90.298) + V28*sin(d28)*(68.101 - 32.94*i)));
-Pl(28)-real(-1.0*(V28*cos(d28) + V28*sin(d28)*(1.0*i + 0.0))*(V27*cos(d27)*(68.101*i + 32.94) + V28*cos(d28)*(- 79.446*i - 38.423) + V29*cos(d29)*(11.345*i + 5.4824) + V27*sin(d27)*(68.101 - 32.94*i) + V28*sin(d28)*(38.423*i - 79.446) + V29*sin(d29)*(11.345 - 5.4824*i)));
-Ql(28)-imag(-1.0*(V28*cos(d28) + V28*sin(d28)*(1.0*i + 0.0))*(V27*cos(d27)*(68.101*i + 32.94) + V28*cos(d28)*(- 79.446*i - 38.423) + V29*cos(d29)*(11.345*i + 5.4824) + V27*sin(d27)*(68.101 - 32.94*i) + V28*sin(d28)*(38.423*i - 79.446) + V29*sin(d29)*(11.345 - 5.4824*i)));
-Pl(29)-real(-1.0*(V29*cos(d29) + V29*sin(d29)*(1.0*i + 0.0))*(V28*cos(d28)*(11.345*i + 5.4824) + V29*cos(d29)*(- 22.689*i - 10.965) + V30*cos(d30)*(11.344*i + 5.4826) + V28*sin(d28)*(11.345 - 5.4824*i) + V29*sin(d29)*(10.965*i - 22.689) + V30*sin(d30)*(11.344 - 5.4826*i)));
-Ql(29)-imag(-1.0*(V29*cos(d29) + V29*sin(d29)*(1.0*i + 0.0))*(V28*cos(d28)*(11.345*i + 5.4824) + V29*cos(d29)*(- 22.689*i - 10.965) + V30*cos(d30)*(11.344*i + 5.4826) + V28*sin(d28)*(11.345 - 5.4824*i) + V29*sin(d29)*(10.965*i - 22.689) + V30*sin(d30)*(11.344 - 5.4826*i)));
-Pl(30)-real(-1.0*(V30*cos(d30) + V30*sin(d30)*(1.0*i + 0.0))*(V29*cos(d29)*(11.344*i + 5.4826) + V30*cos(d30)*(- 30.393*i - 15.03) + V31*cos(d31)*(19.05*i + 9.5478) + V29*sin(d29)*(11.344 - 5.4826*i) + V30*sin(d30)*(15.03*i - 30.393) + V31*sin(d31)*(19.05 - 9.5478*i)));
-Ql(30)-imag(-1.0*(V30*cos(d30) + V30*sin(d30)*(1.0*i + 0.0))*(V29*cos(d29)*(11.344*i + 5.4826) + V30*cos(d30)*(- 30.393*i - 15.03) + V31*cos(d31)*(19.05*i + 9.5478) + V29*sin(d29)*(11.344 - 5.4826*i) + V30*sin(d30)*(15.03*i - 30.393) + V31*sin(d31)*(19.05 - 9.5478*i)));
-Pl(31)-real(-1.0*(V31*cos(d31) + V31*sin(d31)*(1.0*i + 0.0))*(V30*cos(d30)*(19.05*i + 9.5478) + V31*cos(d31)*(- 35.269*i - 20.026) + V32*cos(d32)*(16.22*i + 10.478) + V30*sin(d30)*(19.05 - 9.5478*i) + V31*sin(d31)*(20.026*i - 35.269) + V32*sin(d32)*(16.22 - 10.478*i)));
-Ql(31)-imag(-1.0*(V31*cos(d31) + V31*sin(d31)*(1.0*i + 0.0))*(V30*cos(d30)*(19.05*i + 9.5478) + V31*cos(d31)*(- 35.269*i - 20.026) + V32*cos(d32)*(16.22*i + 10.478) + V30*sin(d30)*(19.05 - 9.5478*i) + V31*sin(d31)*(20.026*i - 35.269) + V32*sin(d32)*(16.22 - 10.478*i)));
-Pl(32)-real(-1.0*(V32*cos(d32) + V32*sin(d32)*(1.0*i + 0.0))*(V31*cos(d31)*(16.22*i + 10.478) + V32*cos(d32)*(- 34.594*i - 19.686) + V34*cos(d34)*(18.374*i + 9.2081) + V31*sin(d31)*(16.22 - 10.478*i) + V32*sin(d32)*(19.686*i - 34.594) + V34*sin(d34)*(18.374 - 9.2081*i)));
-Ql(32)-imag(-1.0*(V32*cos(d32) + V32*sin(d32)*(1.0*i + 0.0))*(V31*cos(d31)*(16.22*i + 10.478) + V32*cos(d32)*(- 34.594*i - 19.686) + V34*cos(d34)*(18.374*i + 9.2081) + V31*sin(d31)*(16.22 - 10.478*i) + V32*sin(d32)*(19.686*i - 34.594) + V34*sin(d34)*(18.374 - 9.2081*i)));
-Pl(33)-real((V33*cos(d33) + V33*sin(d33)*(1.0*i + 0.0))*(V33*cos(d33)*(8.5729*i + 4.2963) + V34*cos(d34)*(- 8.5732*i - 4.2963) + V33*sin(d33)*(8.5729 - 4.2963*i) + V34*sin(d34)*(4.2963*i - 8.5732)));
-Ql(33)-imag((V33*cos(d33) + V33*sin(d33)*(1.0*i + 0.0))*(V33*cos(d33)*(8.5729*i + 4.2963) + V34*cos(d34)*(- 8.5732*i - 4.2963) + V33*sin(d33)*(8.5729 - 4.2963*i) + V34*sin(d34)*(4.2963*i - 8.5732)));
-Pl(34)-real(-1.0*(V34*cos(d34) + V34*sin(d34)*(1.0*i + 0.0))*(V32*cos(d32)*(18.374*i + 9.2081) + V33*cos(d33)*(8.5732*i + 4.2963) + V34*cos(d34)*(- 35.325*i - 21.163) + V35*cos(d35)*(8.379*i + 7.659) + V32*sin(d32)*(18.374 - 9.2081*i) + V33*sin(d33)*(8.5732 - 4.2963*i) + V34*sin(d34)*(21.163*i - 35.325) + V35*sin(d35)*(8.379 - 7.659*i)));
-Ql(34)-imag(-1.0*(V34*cos(d34) + V34*sin(d34)*(1.0*i + 0.0))*(V32*cos(d32)*(18.374*i + 9.2081) + V33*cos(d33)*(8.5732*i + 4.2963) + V34*cos(d34)*(- 35.325*i - 21.163) + V35*cos(d35)*(8.379*i + 7.659) + V32*sin(d32)*(18.374 - 9.2081*i) + V33*sin(d33)*(8.5732 - 4.2963*i) + V34*sin(d34)*(21.163*i - 35.325) + V35*sin(d35)*(8.379 - 7.659*i)));
-Pl(35)-real(-1.0*(V35*cos(d35) + V35*sin(d35)*(1.0*i + 0.0))*(V34*cos(d34)*(8.379*i + 7.659) + V35*cos(d35)*(- 39.135*i - 38.415) + V36*cos(d36)*(30.756*i + 30.756) + V34*sin(d34)*(8.379 - 7.659*i) + V35*sin(d35)*(38.415*i - 39.135) + V36*sin(d36)*(30.756 - 30.756*i)));
-Ql(35)-imag(-1.0*(V35*cos(d35) + V35*sin(d35)*(1.0*i + 0.0))*(V34*cos(d34)*(8.379*i + 7.659) + V35*cos(d35)*(- 39.135*i - 38.415) + V36*cos(d36)*(30.756*i + 30.756) + V34*sin(d34)*(8.379 - 7.659*i) + V35*sin(d35)*(38.415*i - 39.135) + V36*sin(d36)*(30.756 - 30.756*i)));
-Pl(36)-real(-1.0*(V36*cos(d36) + V36*sin(d36)*(1.0*i + 0.0))*(V35*cos(d35)*(30.756*i + 30.756) + V36*cos(d36)*(- 78.792*i - 84.314) + V37*cos(d37)*(18.62*i + 17.019) + V38*cos(d38)*(18.668*i + 19.215) + V39*cos(d39)*(10.748*i + 17.324) + V35*sin(d35)*(30.756 - 30.756*i) + V36*sin(d36)*(84.314*i - 78.792) + V37*sin(d37)*(18.62 - 17.019*i) + V38*sin(d38)*(18.668 - 19.215*i) + V39*sin(d39)*(10.748 - 17.324*i)));
-Ql(36)-imag(-1.0*(V36*cos(d36) + V36*sin(d36)*(1.0*i + 0.0))*(V35*cos(d35)*(30.756*i + 30.756) + V36*cos(d36)*(- 78.792*i - 84.314) + V37*cos(d37)*(18.62*i + 17.019) + V38*cos(d38)*(18.668*i + 19.215) + V39*cos(d39)*(10.748*i + 17.324) + V35*sin(d35)*(30.756 - 30.756*i) + V36*sin(d36)*(84.314*i - 78.792) + V37*sin(d37)*(18.62 - 17.019*i) + V38*sin(d38)*(18.668 - 19.215*i) + V39*sin(d39)*(10.748 - 17.324*i)));
Pg37-Pl(37)-real(-1.0*(V37*cos(d37) + V37*sin(d37)*(1.0*i + 0.0))*(V36*cos(d36)*(18.62*i + 17.019) + V37*cos(d37)*(- 18.62*i - 17.019) + V36*sin(d36)*(18.62 - 17.019*i) + V37*sin(d37)*(17.019*i - 18.62)));
Pg37*4.259982e-01-Ql(37)-imag(-1.0*(V37*cos(d37) + V37*sin(d37)*(1.0*i + 0.0))*(V36*cos(d36)*(18.62*i + 17.019) + V37*cos(d37)*(- 18.62*i - 17.019) + V36*sin(d36)*(18.62 - 17.019*i) + V37*sin(d37)*(17.019*i - 18.62)));
Pg38-Pl(38)-real(-1.0*(V38*cos(d38) + V38*sin(d38)*(1.0*i + 0.0))*(V36*cos(d36)*(18.668*i + 19.215) + V38*cos(d38)*(- 18.668*i - 19.215) + V36*sin(d36)*(18.668 - 19.215*i) + V38*sin(d38)*(19.215*i - 18.668)));
Pg38*4.259982e-01-Ql(38)-imag(-1.0*(V38*cos(d38) + V38*sin(d38)*(1.0*i + 0.0))*(V36*cos(d36)*(18.668*i + 19.215) + V38*cos(d38)*(- 18.668*i - 19.215) + V36*sin(d36)*(18.668 - 19.215*i) + V38*sin(d38)*(19.215*i - 18.668)));
-Pl(39)-real(-1.0*(V39*cos(d39) + V39*sin(d39)*(1.0*i + 0.0))*(V36*cos(d36)*(10.748*i + 17.324) + V39*cos(d39)*(- 10.748*i - 17.324) + V36*sin(d36)*(10.748 - 17.324*i) + V39*sin(d39)*(17.324*i - 10.748)));
-Ql(39)-imag(-1.0*(V39*cos(d39) + V39*sin(d39)*(1.0*i + 0.0))*(V36*cos(d36)*(10.748*i + 17.324) + V39*cos(d39)*(- 10.748*i - 17.324) + V36*sin(d36)*(10.748 - 17.324*i) + V39*sin(d39)*(17.324*i - 10.748)));
];