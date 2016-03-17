function r = FunctionalEquationByCollocation_residual(c,nod,fspace,alpha)
% Calculates residual of functional equation
% Arguments: basis fct coefficients, evaluation nodes, approximation space

% generate function values with current basis coefficients c.
y = funeval(c,fspace,nod);

% Calculates residual for present approximation
r = exp(y)-nod.^alpha;

%disp(num2str(r))

end

