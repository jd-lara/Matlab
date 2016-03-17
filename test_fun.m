function [test, z] = test_fun(x,m)

test = x(1).^2 - m*3*x(2); 

z = x(1) + x(2);


end 