function [c,ceq] = pbalance(x,S)

Pg_slack=x(1);
Pg1=x(2);
Pg2=x(3);
pdiff=zeros(5,1);
%qdiff=zeros(5,1);

%n=S.Bus.n;
pdiff(2)=real(S.Bus.Load(2,1));
pdiff(3)=real(S.Bus.Load(3,1));
pdiff(4)=real(S.Bus.Load(4,1))-Pg1;
pdiff(5)=real(S.Bus.Load(5,1))-Pg2;

% qdiff(2)=imag(S.Bus.Load(2,1));
% qdiff(3)=imag(S.Bus.Load(3,1));
% qdiff(4)=imag(S.Bus.Load(4,1))-0.3919*Pg1;
% qdiff(5)=imag(S.Bus.Load(5,1))-0.3919*Pg2;

c=[-1*(losses_approx([Pg_slack,Pg1,Pg2],S))];
ceq=[-Pg_slack+sum(pdiff)+(losses_approx([Pg_slack,Pg1,Pg2],S)/50)];

end

