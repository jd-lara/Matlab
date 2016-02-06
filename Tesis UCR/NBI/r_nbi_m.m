function [c, ceq]=r_nbi_m(x,S,Wx)

r_flow = pfloweqs_nbi(x,S);
obj1 = losseqs(x,S);
t=x(13);
obj2=-1*x(11);
obj3=-1*x(12);


c = [];


 ceq = [r_flow;
+1.231199e-01*Wx(1)+1.588799e-01*Wx(2)+1.984999e-01*Wx(3)+t*-3.188148e-01-obj1;
+-7.747708e-02*Wx(1)+-1.200000e-01*Wx(2)+-3.643000e-02*Wx(3)+t*-5.871808e-01-obj2;
+-5.530566e-02*Wx(1)+-3.707000e-02*Wx(2)+-1.200000e-01*Wx(3)+t*-7.440267e-01-obj3;
];