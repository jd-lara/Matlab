function resid_PS3 = res_PS3(c, tnodes, T, n, x_ss, fspace, eta, rho, kappa,...
                             delta, g, L, k0)

 %This line makes sure that the c vector has the correct shape to be used
 %in the funeval functions. 
 c = reshape(c,n,2);
 
 %Evaluate the approximation in the nodes given the coefficients c
 x = funeval(c,fspace,tnodes);
 
 %Evaluate the approximation of \dot F(X) in the 
 x_p = funeval(c,fspace,tnodes,1);
 
 %Vector representation of F(X)
 kk = [(x(:,1)./eta).*((L^(1-kappa)*kappa)*x(:,2).^(kappa-1)-rho-(delta+g)),... 
       x(:,2).^(kappa)*L^(1-kappa)-x(:,1)+(delta+g)*x(:,1)];
 
resid_PS3 = x_p - kk;

x_ini = funeval(c,fspace,0);
x_end = funeval(c,fspace,T);

resid_PS3= [resid_PS3(:); x_ini(2)-k0; x_end(2)-x_ss(2)];