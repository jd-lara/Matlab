function [c, ceq]=r_nnc_mp(x,S,Wx)

r_flow = pfloweqs_nnc(x,S);
obj1 = (losseqs(x(1:78),S)-1.966178e-02)/7.354005e-02;
obj2 = (-1*x(82)-1*x(83)-1*(-1.050000e-01))/7.099491e-02;
normXPJ1 = Wx(1)*0+Wx(2)*1;
normXPJ2 = Wx(1)*1+Wx(2)*0;


c = [+-1*(obj1-normXPJ1)+1*(obj2-normXPJ2);
]; 


ceq = r_flow;