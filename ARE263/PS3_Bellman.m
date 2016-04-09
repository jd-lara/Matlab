%This function contains the expression for the RHS of the Bellman equation.
% The vector x = (c,kp). Where c is the consumption in s and kp is the
% capital in s-1. 

function V = PS3_Bellman(x,fspace,w,k,param)

%Calculate the discount factor from the parameters
beta = exp(-param.rho+(1-param.eta)*param.g);

%Definition of the control variable as a function of the state variable,
%fmincon doesn't really care and only solves for the state variable. In
%this regard, we obtain the solution of the "optimal policy"
y=k.^(param.kappa)*param.L^(1-param.kappa);
x(1) = - (x(2)./(exp(-param.g))) + y + ((1 - param.delta)*k);

%Utility function section of the value function
V1 = (x(1)).^(1-param.eta)./(1-param.eta);

%Evaluation of the state in the approximation of the value function s-1
V2 = funeval(w,fspace,x(2));

%RHS evaluation of the Bellam equation, mutltiplied by -1 because this is a
%maximization problem. 
V = -1*(V1 + beta*V2);

end
