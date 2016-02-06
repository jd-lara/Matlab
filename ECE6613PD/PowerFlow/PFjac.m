function [F,J] = PFjac(z)
%
% 3-bus example Power Flow equations and Jacobian
%

global lambda J

d2=z(1);
d3=z(2);
P1=z(3);
Q1=z(4);
Q2=z(5);
Q =z(6);

F(1,1) =  P1 +10*sin(d2) + 10*sin(d3);
F(2,1) =  Q1 - 19.8 + 10*cos(d2)+ 10*cos(d3);
F(3,1) =  0.5*P1 - 10*sin(d2) - 10*sin(d2-d3);
F(4,1) =  Q2 + 10*cos(d2) - 19.8 + 10*cos(d2-d3);
F(5,1) =  -0.9*lambda - 10*sin(d3) - 10*sin(d3-d2);
F(6,1) =  Q -0.436*lambda + 10*cos(d3) + 10*cos(d3-d2) - 19.8;

%
% Jacobian obtained with the help of MATLAB:
% syms d2 d3 P1 Q1 Q2 Q real
% z=[d2 d3 P1 Q1 Q2 Q];
% J=jacobian(PFeqs(z),z)
%
J = [
   10*cos(d2),10*cos(d3), 1, 0, 0, 0;
   -10*sin(d2),   -10*sin(d3), 0, 1, 0, 0;
 -10*cos(d2)-10*cos(d2-d3), 10*cos(d2-d3),   1/2, 0, 0, 0;
 -10*sin(d2)-10*sin(d2-d3), 10*sin(d2-d3), 0, 0, 1, 0;
 10*cos(d2-d3), -10*cos(d3)-10*cos(d2-d3), 0, 0, 0, 0;
-10*sin(d2-d3), -10*sin(d3)+10*sin(d2-d3), 0, 0, 0, 1
];


