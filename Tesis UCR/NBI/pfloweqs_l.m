function [c,ceq]=pfloweqs_l(x,S)

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
% PQ buses with generators (Type 1)
Pg4=x(11);
% PQ buses with generators (Type 1)
Pg5=x(12);


c = [];


 ceq = [Pg1-Pl(1)-real((V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(3.4497*i + 6.0654) + V2*cos(d2)*(- 3.4497*i - 6.0654) + V1*sin(d1)*(3.4497 - 6.0654*i) + V2*sin(d2)*(6.0654*i - 3.4497)));
Qg1-Ql(1)-imag((V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(3.4497*i + 6.0654) + V2*cos(d2)*(- 3.4497*i - 6.0654) + V1*sin(d1)*(3.4497 - 6.0654*i) + V2*sin(d2)*(6.0654*i - 3.4497)));
-Pl(2)-real(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(3.4497*i + 6.0654) + V2*cos(d2)*(- 5.7954*i - 10.573) + V3*cos(d3)*(2.3458*i + 4.5075) + V1*sin(d1)*(3.4497 - 6.0654*i) + V2*sin(d2)*(10.573*i - 5.7954) + V3*sin(d3)*(2.3458 - 4.5075*i)));
-Ql(2)-imag(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(3.4497*i + 6.0654) + V2*cos(d2)*(- 5.7954*i - 10.573) + V3*cos(d3)*(2.3458*i + 4.5075) + V1*sin(d1)*(3.4497 - 6.0654*i) + V2*sin(d2)*(10.573*i - 5.7954) + V3*sin(d3)*(2.3458 - 4.5075*i)));
-Pl(3)-real(-1.0*(V3*cos(d3) + V3*sin(d3)*(1.0*i + 0.0))*(V2*cos(d2)*(2.3458*i + 4.5075) + V3*cos(d3)*(- 6.1272*i - 11.88) + V4*cos(d4)*(1.7142*i + 3.4473) + V5*cos(d5)*(2.0673*i + 3.9257) + V2*sin(d2)*(2.3458 - 4.5075*i) + V3*sin(d3)*(11.88*i - 6.1272) + V4*sin(d4)*(1.7142 - 3.4473*i) + V5*sin(d5)*(2.0673 - 3.9257*i)));
-Ql(3)-imag(-1.0*(V3*cos(d3) + V3*sin(d3)*(1.0*i + 0.0))*(V2*cos(d2)*(2.3458*i + 4.5075) + V3*cos(d3)*(- 6.1272*i - 11.88) + V4*cos(d4)*(1.7142*i + 3.4473) + V5*cos(d5)*(2.0673*i + 3.9257) + V2*sin(d2)*(2.3458 - 4.5075*i) + V3*sin(d3)*(11.88*i - 6.1272) + V4*sin(d4)*(1.7142 - 3.4473*i) + V5*sin(d5)*(2.0673 - 3.9257*i)));
Pg4-Pl(4)-real(-1.0*(V4*cos(d4) + V4*sin(d4)*(1.0*i + 0.0))*(V3*cos(d3)*(1.7142*i + 3.4473) + V4*cos(d4)*(- 1.7142*i - 3.4473) + V3*sin(d3)*(1.7142 - 3.4473*i) + V4*sin(d4)*(3.4473*i - 1.7142)));
Pg4*4.259982e-01-Ql(4)-imag(-1.0*(V4*cos(d4) + V4*sin(d4)*(1.0*i + 0.0))*(V3*cos(d3)*(1.7142*i + 3.4473) + V4*cos(d4)*(- 1.7142*i - 3.4473) + V3*sin(d3)*(1.7142 - 3.4473*i) + V4*sin(d4)*(3.4473*i - 1.7142)));
Pg5-Pl(5)-real(-1.0*(V5*cos(d5) + V5*sin(d5)*(1.0*i + 0.0))*(V3*cos(d3)*(2.0673*i + 3.9257) + V5*cos(d5)*(- 2.0673*i - 3.9257) + V3*sin(d3)*(2.0673 - 3.9257*i) + V5*sin(d5)*(3.9257*i - 2.0673)));
Pg5*4.259982e-01-Ql(5)-imag(-1.0*(V5*cos(d5) + V5*sin(d5)*(1.0*i + 0.0))*(V3*cos(d3)*(2.0673*i + 3.9257) + V5*cos(d5)*(- 2.0673*i - 3.9257) + V3*sin(d3)*(2.0673 - 3.9257*i) + V5*sin(d5)*(3.9257*i - 2.0673)));
];