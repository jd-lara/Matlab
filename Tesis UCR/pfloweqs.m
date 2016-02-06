function f=pfloweqs(x,S)

Vs=S.Bus.Voltages(S.Bus.SlackList);
V=S.Bus.Voltages(S.Bus.PVList);
Pg=real(S.Bus.Generation);
Qg=imag(S.Bus.Generation);
Pl=real(S.Bus.Load);
Ql=imag(S.Bus.Load);

% Slack bus
Pg1=x(1);
Qg1=x(2);
V1=Vs;
d1=0;
V2=x(3);
d2=x(4);


f(1)=Pg1-Pl(1)-real((V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(1.7405*i + 3.4118) + V2*cos(d2)*(- 1.7405*i - 3.4118) + V1*sin(d1)*(1.7405 - 3.4118*i) + V2*sin(d2)*(3.4118*i - 1.7405)));
f(2)=Qg1-Ql(1)-imag((V1*cos(d1) + V1*sin(d1)*(1.0*i + 0.0))*(V1*cos(d1)*(1.7405*i + 3.4118) + V2*cos(d2)*(- 1.7405*i - 3.4118) + V1*sin(d1)*(1.7405 - 3.4118*i) + V2*sin(d2)*(3.4118*i - 1.7405)));
f(3)=Pg(2)-Pl(2)-real(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(1.7405*i + 3.4118) + V2*cos(d2)*(- 1.7405*i - 3.4118) + V1*sin(d1)*(1.7405 - 3.4118*i) + V2*sin(d2)*(3.4118*i - 1.7405)));
f(4)=Qg(2)-Ql(2)-imag(-1.0*(V2*cos(d2) + V2*sin(d2)*(1.0*i + 0.0))*(V1*cos(d1)*(1.7405*i + 3.4118) + V2*cos(d2)*(- 1.7405*i - 3.4118) + V1*sin(d1)*(1.7405 - 3.4118*i) + V2*sin(d2)*(3.4118*i - 1.7405)));
