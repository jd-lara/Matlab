function [c, ceq]=r_nbi_mp(x,S,Wx)

r_flow = pfloweqs_nbi(x,S);
obj1 = losseqs(x,S);
t=x(84);
obj2=(-1*x(82)-1*x(83));


c = [];


 ceq = [r_flow;
+1.966152e-02*Wx(1)+9.320183e-02*Wx(2)+t*-7.189357e-01-obj1;
+-3.390025e-02*Wx(1)+-1.050000e-01*Wx(2)+t*-6.950766e-01-obj2;
];