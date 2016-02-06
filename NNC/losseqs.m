function fl=losseqs(x,S)

Vs=S.Bus.Voltages(S.Bus.SlackList);
V=S.Bus.Voltages(S.Bus.PVList);
% Slack bus
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


fl=0+0.5*50*6.065443e+00*(V1^2+V2^2-2*V1*V2*cos(d1-d2))+0.5*50*6.065443e+00*(V2^2+V1^2-2*V2*V1*cos(d2-d1))+0.5*50*4.507500e+00*(V2^2+V3^2-2*V2*V3*cos(d2-d3))+0.5*50*4.507500e+00*(V3^2+V2^2-2*V3*V2*cos(d3-d2))+0.5*50*3.447331e+00*(V3^2+V4^2-2*V3*V4*cos(d3-d4))+0.5*50*3.925670e+00*(V3^2+V5^2-2*V3*V5*cos(d3-d5))+0.5*50*3.447331e+00*(V4^2+V3^2-2*V4*V3*cos(d4-d3))+0.5*50*3.925670e+00*(V5^2+V3^2-2*V5*V3*cos(d5-d3));