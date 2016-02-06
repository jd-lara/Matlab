function [c,ceq]=rest2(z,b)

x=z(1);
y=z(2);

c= [-1-x; 
    -1-y;
     x^2+y^2-1;
     -x-b+y+(1-b)
     ];

 ceq=[];