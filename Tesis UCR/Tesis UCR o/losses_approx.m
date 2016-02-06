function L_approx = losses_approx(x,S)

Pg_slack=x(1);
Pg1=x(2);
Pg2=x(3);
pdiff=zeros(5,1);
qdiff=zeros(5,1);
pf=0.92;
s=sin(acos(pf));

%n=S.Bus.n;
pdiff(2)=real(S.Bus.Load(2,1));
pdiff(3)=real(S.Bus.Load(3,1));
pdiff(4)=real(S.Bus.Load(4,1))-Pg1;
pdiff(5)=real(S.Bus.Load(5,1))-Pg2;

qdiff(2)=imag(S.Bus.Load(2,1));
qdiff(3)=imag(S.Bus.Load(3,1));
qdiff(4)=imag(S.Bus.Load(4,1))-s*Pg1;
qdiff(5)=imag(S.Bus.Load(5,1))-s*Pg2;

%Bus 4
P_b4=(pdiff(4,1)^2+qdiff(4,1)^2)*real(S.Branch.Z(3,1));
Q_b4=(pdiff(4,1)^2+qdiff(4,1)^2)*imag(S.Branch.Z(3,1));
%Bus 5
P_b5=(pdiff(5,1)^2+qdiff(5,1)^2)*real(S.Branch.Z(4,1));
Q_b5=(pdiff(5,1)^2+qdiff(5,1)^2)*imag(S.Branch.Z(4,1));
%Bus 3
P_b3=((pdiff(4,1)+pdiff(5,1)+pdiff(3,1)+P_b4+P_b5)^2+(qdiff(4,1)+qdiff(5,1)+qdiff(3,1)+Q_b4+Q_b5)^2)*real(S.Branch.Z(2,1));
Q_b2=((pdiff(4,1)+pdiff(5,1)+pdiff(3,1)+P_b4+P_b5)^2+(qdiff(4,1)+qdiff(5,1)+qdiff(3,1)+Q_b4+Q_b5)^2)*imag(S.Branch.Z(2,1));
%Bus 2
P_b2=((pdiff(4,1)+pdiff(5,1)+pdiff(3,1)+pdiff(2,1)+P_b4+P_b5+P_b3)^2+(qdiff(4,1)+qdiff(5,1)+qdiff(3,1)+qdiff(2,1)+Q_b4+Q_b5+Q_b2)^2)*real(S.Branch.Z(1,1));

L_approx=(P_b2+P_b4+P_b5+P_b3)*50; %Approximate Losses in MW. 

end
