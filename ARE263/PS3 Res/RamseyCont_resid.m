function r = RamseyCont_resid(c,tnodes,T,n,fspace,k_0,x_ss,kappa,L,delta,g,eta,rho)
%UNTITLED4 Returns the 
%   Detailed explanation goes here

x = funeval(c,fspace,tnodes);
d = funeval(c,fspace,tnodes,1); %specifying 1 for ORDER gives 1st derivative
r = d - [x(:,1).^kappa*L^(1-kappa)-x(:,2)-(delta+g)*x(:,1),...
        (x(:,2)/eta).*(kappa*x(:,1).^(kappa-1)*L^(1-kappa)-(delta+rho+eta*g))];
x0 = funeval(c,fspace,0);
xT = funeval(c,fspace,T);
r  = [r(:); x0(1)-k_0; xT(1)-x_ss(1)];



end

