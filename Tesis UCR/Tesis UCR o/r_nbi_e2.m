function [c, ceq]=r_nbi_e2(x,S,Wx)

r_balance = nbi_pbalance(x,S);
obj1 = losses_approx(x,S);
t=x(4);
obj2=-1*x(2)-1*x(3);


c = [];


 ceq = [r_balance;
+6.889311e-02*Wx(1)+3.322083e-01*Wx(2)+t*-1.082766e-01-obj1;
+-1.317234e-01*Wx(1)+-2.400000e-01*Wx(2)+t*-2.633152e-01-obj2;
];