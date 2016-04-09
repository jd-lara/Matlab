function v = Ramsey_bellman(coeff,cons,k_i)
%  Bellman for the Ramsey model
%  Calculate next period capital nodes and evaluate r.h.s. Bellman eqn

global fspace delta kappa L g eta beta

% Calculate the capital stock in the next period
k_i_next = ((1-delta)*k_i + k_i.^kappa.*L.^(1-kappa) - cons).*exp(-g);

% Calculate the value function in the next period, i.e V(k_(t+1))
value_next = funeval(coeff,fspace,k_i_next);

% Instantaneous utility from consumption level c in this period
inst_utility = cons.^(1-eta)./(1-eta);

% Negative of total utility from current and future consumption
v = -inst_utility - beta*value_next;

end

