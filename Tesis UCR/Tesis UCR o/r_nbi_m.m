function [c, ceq]=r_nbi_m(x,S,Wx)

r_flow = pfloweqs_nbi(x,S);
obj1 = losseqs(x,S);
t=x(13);
obj2=-1*x(11);
obj3=-1*x(12);


c = [];


 ceq = [r_flow;
+3.082835e-01*Wx(1)+1.263666e-01*Wx(2)+1.126276e-01*Wx(3)+t*2.975703e-01-obj1;
+-1.200000e-01*Wx(1)+-1.200000e-01*Wx(2)+-3.643000e-02*Wx(3)+t*6.966784e-01-obj2;
+-1.200000e-01*Wx(1)+-3.707000e-02*Wx(2)+-1.200000e-01*Wx(3)+t*6.527565e-01-obj3;
];