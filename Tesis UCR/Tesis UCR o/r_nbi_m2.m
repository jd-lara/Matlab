function [c, ceq]=r_nbi_m2(x,S,Wx)

r_flow = pfloweqs_nbi(x,S);
obj1 = losseqs(x,S);
t=x(13);
obj2=(-1*x(11)-1*x(12));


c = [];


 ceq = [r_flow;
+6.773353e-02*Wx(1)+3.082835e-01*Wx(2)+t*-9.136849e-01-obj1;
+-1.329990e-01*Wx(1)+-2.400000e-01*Wx(2)+t*-4.064234e-01-obj2;
];