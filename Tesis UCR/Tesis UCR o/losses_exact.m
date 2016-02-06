function [L_exact, L_k]= losses_exact(S) %Function to calculate the system losses in MW. 

L=zeros(S.Branch.nn,1);

for k = 1:1:S.Branch.nn
     L(k)=real(S.Branch.Z(k)^-1)*(S.Bus.Voltages(S.Branch.From(k))^2+S.Bus.Voltages(S.Branch.To(k))^2-...
        (2*S.Bus.Voltages(S.Branch.From(k))*S.Bus.Voltages(S.Branch.To(k))*...
        cos((S.Bus.Angles(S.Branch.From(k))*pi/180-S.Bus.Angles(S.Branch.To(k))*pi/180))));
end

L_k=L;
L_exact=sum(L)*S.BaseMVA;
