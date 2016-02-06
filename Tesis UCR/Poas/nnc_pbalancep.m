function ceq=nbi_pbalancep(x,S)

Pg_slack=x(1);
Pg1=x(2);
Pg2=x(3);
Pg3=x(4);
Pg4=x(5);
Pg5=x(6);
pdiff=zeros(S.Bus.n,1);
pf=0.95;

n=1:S.Bus.n;
pdiff(n)=real(S.Bus.Load(n,1));

pdiff(11)=-Pg1;
pdiff(15)=-Pg2;
pdiff(22)=-Pg3;
pdiff(37)=-Pg4;
pdiff(38)=-Pg5;

ceq=[-Pg_slack+sum(pdiff)+(losses_approx2([Pg_slack, Pg1, Pg2, Pg3, Pg4, Pg5],S)/50)];

end

