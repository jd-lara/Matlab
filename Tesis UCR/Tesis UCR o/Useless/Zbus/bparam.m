S.Ybus(1,1)=9e9; %Selection of the Pivot Bus
Zbus=inv(S.Ybus); %calculation of Y^-1 (a better method can be later implemented)

%Function to sort appropiately the Zbus. 
Z1=zeros(numel(S.Machine.BusRef));
for i=1:1:numel(S.Machine.BusRef)
    for j=1:1:numel(S.Machine.BusRef)
    Z1(i,j)=Zbus(S.Machine.BusRef(i),S.Machine.BusRef(j));
    end
end

Z2=zeros(numel(S.Load.BusRef));
for i=1:1:numel(S.Load.BusRef)
    for j=1:1:numel(S.Load.BusRef)
    Z2(i,j)=Zbus(S.Load.BusRef(i),S.Load.BusRef(j));
    end
end
    
Z3=zeros(numel(S.Machine.BusRef),numel(S.Load.BusRef));
for i=1:1:numel(S.Machine.BusRef)
    for j=1:1:numel(S.Load.BusRef)
    Z3(i,j)=Zbus(S.Machine.BusRef(i),S.Load.BusRef(j));
    end
end

Z_o=roundn([Z1 Z3 ; Z3.' Z2],-4); %impedance matriz ordered
R_o=real(Z_o); %Resistance matrix ordered
 
clear j
sum_l=sum(S.Load.MW+(j*S.Load.MVAR));
L=(S.Load.MW-(j*S.Load.MVAR))/sum_l; %Load unification into one single current. 

C1=[eye(numel(S.Machine.BusRef)) zeros(numel(S.Machine.BusRef),1);...
zeros(numel(S.Load.BusRef),numel(S.Machine.BusRef)) L]; %First transformation Matrix to reference frame 2

C2=[eye(numel(S.Machine.BusRef)); -ones(1,numel(S.Machine.BusRef))]; %Second transformation Matrix 
C=C1*C2;

R_3=C.'*R_o*conj(C); %Second transformation to reference frame 3

alpha=S.Machine.MVAR./S.Machine.MW; %Generation Factors
volt=S.Bus.Voltages(S.Machine.BusRef).*exp(j.*S.Bus.Angles(S.Machine.BusRef));
C3_1=diag([(1+j*alpha./volt)]); %Third transformation Matrix. 

T=C3_1.'*R_3*C3_1;

B=(T+T')/2;
real(S.Bus.Generation(S.Machine.BusRef)).'*B*(real(S.Bus.Generation(S.Machine.BusRef)))*50
    


