function [c,ceq]=rest(z,b)

x=z(1);
y=z(2);
t=z(3);

c= [-1-x; 
    -1-y;
     x^2+y^2-1];
 
 ceq= [   -b  - t - x;
       -(1-b) - t - y];