function v = Ramsey_bellman_u_PS4(coeff,cons,k_i, w, e)
%  Bellman for the Ramsey model
%  Calculate next period capital nodes and evaluate r.h.s. Bellman eqn

global fspace delta kappa L g eta beta

value_next_int=999*ones(1,numel(w));

for i = numel(w)

% Calculate the capital stock in the next period including shock

k_i_next = ((1-delta)*k_i + k_i.^kappa.*L.^(1-kappa) - cons).*exp(-g)*e(i);

% Calculate the expecte value function in the next period, i.e EV(k_(t+1)

value_next_int(i) = funeval(coeff,fspace,k_i_next);

end

value_next = dot(w,value_next_int);

% Instantaneous utility from consumption level c in this period
inst_utility = cons.^(1-eta)./(1-eta);

% Negative of total utility from current and future consumption
v = -inst_utility - beta*value_next;

end

