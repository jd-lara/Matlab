function Pout=PVoutput(PVinput,tvsp,cur_irrad,temp,eff)


irrad=PVinput(1);
Pmpp=PVinput(2);
Pcut=PVinput(3);

% Factor de reducción de P(T)
ftr1=interp1(tvsp(:,1),tvsp(:,2),temp);  

% Potencia de entrada de inversor
Pin=Pmpp*irrad*cur_irrad.*ftr1;

% eficiencia del inversor, eff(Pin)
ftr2=zeros(1,length(Pin)); 
for i=1:length(Pin)
    if Pin(i)/Pmpp > Pcut
        ftr2(i)=interp1(eff(:,1),eff(:,2),Pin(i)/Pmpp);
    end
end

% Potencia de salida del inversor
Pout=Pin.*ftr2;
% 