function [c, ceq]=r_nbi_e(x,S,Wx)

r_balance = nbi_pbalance(x,S);
obj1 = losses_approx(x,S);
t=x(4);
obj2=-1*x(2);
obj3=-1*x(3);


c = [];


 ceq = [r_balance;
+3.322083e-01*Wx(1)+1.504097e-01*Wx(2)+1.359324e-01*Wx(3)+t*3.743349e-01-obj1;
+-1.200000e-01*Wx(1)+-1.200000e-01*Wx(2)+-1.200000e-02*Wx(3)+t*6.803049e-01-obj2;
+-1.200000e-01*Wx(1)+-1.200000e-02*Wx(2)+-1.200000e-01*Wx(3)+t*6.301259e-01-obj3;
];