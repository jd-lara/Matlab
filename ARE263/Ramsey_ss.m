% This functions is only used once to calculate the steady state consumption 
%and capital stock 
function R = Ramsey_ss(x, eta, rho, kappa, delta,...
            g, L)

 R = [(x(1)./eta).*((L^(1-kappa)*kappa)*x(2).^(kappa-1)-rho-(delta+ eta* g));... 
       x(2).^(kappa)*L^(1-kappa)-x(1)-(delta+g)*x(2)];
   
% R = [x(1).^kappa*L^(1-kappa)-x(2)-(delta+g)*x(1),...
%         (x(2)/eta).*(kappa*x(1).^(kappa-1)*L^(1-kappa)-(delta+rho+eta*g))];
   