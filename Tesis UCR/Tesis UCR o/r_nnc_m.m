function [c, ceq]=r_nnc_m(x,S,Wx)

r_flow = pfloweqs_nnc(x,S);
obj1 = losseqs(x,S);
obj2 = -1*x(11);
obj3 = -1*x(12);
normXPJ1 = Wx(1)*3.082835e-01+Wx(2)*1.263666e-01+Wx(3)*1.126276e-01;
normXPJ2 = Wx(1)*-1.200000e-01+Wx(2)*-1.200000e-01+Wx(3)*-3.643000e-02;
normXPJ3 = Wx(1)*-1.200000e-01+Wx(2)*-3.707000e-02+Wx(3)*-1.200000e-01;
%plot3(normXPJ2,normXPJ3,normXPJ1,'*b'); hold on;

c = [+-1.819170e-01*(obj1-normXPJ1)+0*(obj2-normXPJ2)+8.293000e-02*(obj3-normXPJ3);
+-1.956560e-01*(obj1-normXPJ1)+8.357000e-02*(obj2-normXPJ2)+0*(obj3-normXPJ3);
]; 


ceq = r_flow;