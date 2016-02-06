function [c, ceq]=r_nnc_e(x,S,Wx)

r_balance = nnc_pbalance(x,S);
obj1 =  losses_approx(x,S);
obj2 = -1*x(2);
obj3 = -1*x(3);
normXPJ1 = Wx(1)*3.322083e-01+Wx(2)*1.504097e-01+Wx(3)*1.359324e-01;
normXPJ2 = Wx(1)*-1.200000e-01+Wx(2)*-1.200000e-01+Wx(3)*-1.200000e-02;
normXPJ3 = Wx(1)*-1.200000e-01+Wx(2)*-1.200000e-02+Wx(3)*-1.200000e-01;
%plot3(normXPJ2,normXPJ3,normXPJ1,'*b'); hold on;

c = [+-1.817987e-01*(obj1-normXPJ1)+0*(obj2-normXPJ2)+1.080000e-01*(obj3-normXPJ3);
+-1.962759e-01*(obj1-normXPJ1)+1.080000e-01*(obj2-normXPJ2)+0*(obj3-normXPJ3);
]; 


ceq = r_balance;