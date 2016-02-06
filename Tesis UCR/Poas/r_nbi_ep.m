function [c, ceq]=r_nbi_ep(x,S,Wx)

r_balance = nbi_pbalancep(x,S);
obj1 = losses_approx2(x,S);
t=x(7);
obj2=-1*x(5)-1*x(6);


c = [];


 ceq = [r_balance;
+2.021415e-02*Wx(1)+1.032752e-01*Wx(2)+t*-6.551747e-01-obj1;
+-3.296674e-02*Wx(1)+-1.050000e-01*Wx(2)+t*-7.554774e-01-obj2;
];