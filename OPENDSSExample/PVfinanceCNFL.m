clear all;

kWinstalvec=[1,2,3,4]; % array de capacidad en kW de los sistemas PVs a evaluar

for w=1:length(kWinstalvec)
%% SISTEMA PV

kWinstal=kWinstalvec(w);

PVdeg=0.008; % PV panel degradation / year
irrad=0.65; % kW/m2
Pmpp=kWinstal; % kW  (maximum power point)
Pcut=0.1; % valor de potencia de entrada minima (en pu) para que el sistema PV genere
PVinput=[irrad;Pmpp;Pcut];

cur_irrad=[0 0 0 0 0 0 .1 .2 .3 .5 .8 .9 1.0 1.0 .99 .9 .7 .4 .1 0 0 0 0 0]; % en pu

temp=[25,25,25,25,25,25,25,30,35,40,45,50,60,60,55,40,35,30,25,25,25,25,25,25];

tvspx=[0;25;75;100]; tvspy=[1.2;1.0;0.8;0.6]; tvsp=[tvspx,tvspy];

effx=[.1;.2;.4;1.0]; effy=[.86;.9;.93;.97]; eff=[effx,effy];

PoutPV=PVoutput(PVinput,tvsp,cur_irrad,temp,eff); % funcion para calcular salida de sistema PV

kWhPVday=sum(PoutPV); % /day
kWhPVmes=30.4*kWhPVday; % / month
kWhPVanual=ones(12,1)*kWhPVmes; % anual


%% CONSUMO ELECTRICO
kWhLoadmes=300;
kWhLoadanual=ones(12,1)*kWhLoadmes; % se supone un consumo constante por mes durante todo el año
loadgwrt=0.01; % load grow rate / year

%% FINANCIAMIENTO

if kWinstal <2.5  
    dpkW=2900; % costo en dolares por kW instalado
elseif kWinstal>=2.5 && kWinstal < 10
    dpkW=2300; % costo en dolares por kW instalado
else
    dpkW=2000; % costo en dolares por kW instalado
end

TdC=540; % colones por dólar
PVcost=kWinstal*dpkW*TdC;

tloan=10; % periodo de prestamo en años
intloan=0.10; % tasa de interés de préstamo
perloan=1; % % porcentaje de prestamo respecto costo de proyecto


%% TARIFA

TR1=70; % colones por primeros 200 kWh
TR2=107; % colones por siguientes 100 kWh
TR3=111; % colones por kWh adicional
aumcostel=0.05; % electricity cost increase / year
 
ppkWh=15; % valor de peaje en colones / kWh
aumpeaje=0.01; % aumento anual del costo de peaje

TRPV1=TR1-ppkWh;
TRPV2=TR2-ppkWh;
TRPV3=TR3-ppkWh;

%% OTROS COSTOS

CostMed=194000; %50112.41; % costo de medidor bidireccional
CostSustInv=270000*0; %
yearSustInv=10; % año de sustitución del inversor

CostMan=25000; % costos de mantenimiento por año

%% ANALISIS

years=20;

Init_pay=(1-perloan)*PVcost;
[Prpmt, Intpmt] = amortize(intloan, tloan,PVcost*perloan);
loanpay=Prpmt+Intpmt;

TR1tot=zeros(years,2);
TR2tot=zeros(years,2);
TR3tot=zeros(years,2);

peajekWh=zeros(years,1);
peajekWh(1)=ppkWh;

TR1tot(1,:)=[TR1,TRPV1];
TR2tot(1,:)=[TR2,TRPV2];
TR3tot(1,:)=[TR3,TRPV3];

kWhloadtot=zeros(12,years);
kWhPVtot=zeros(12,years);
kWhloadtot(:,1)=kWhLoadanual;
kWhPVtot(:,1)=kWhPVanual;

for i=1:years-1
    kWhloadtot(:,i+1)=kWhloadtot(:,i)*(1+loadgwrt);
    kWhPVtot(:,i+1)=kWhPVtot(:,i)*(1-PVdeg);
    TR1tot(i+1,:)=TR1tot(i,:)*(1+aumcostel);
    TR2tot(i+1,:)=TR2tot(i,:)*(1+aumcostel);
    TR3tot(i+1,:)=TR3tot(i,:)*(1+aumcostel);
    peajekWh(i+1)=peajekWh(i)*(1+aumpeaje);
end

for i=1:years
   
    kWhanual=[kWhloadtot(:,i),kWhloadtot(:,i)-kWhPVtot(:,i)];
    
    % corrección para evitar cobro por kWh negativos (excedentes)
    for j=1:12
        if kWhanual(j,2)<0
           kWhanual(j,2)=0;
        end
    end
    
    % calculo de recibo eléctrico
     facturacion=zeros(12,2);
     peaje(:,i)=kWhanual(:,1)*peajekWh(i);
    for j=1:2
        for k=1:12
           if kWhanual(k,j)<=200
              facturacion(k,j)=kWhanual(k,j)*TR1tot(i,j); % en colones
          elseif (kWhanual(k,j)>200 && kWhanual(k,j)<=300)
              facturacion(k,j)=200*TR1tot(i,j)+(kWhanual(k,j)-200)*TR2tot(i,j); % en colones
          elseif kWhanual(k,1)>300
              facturacion(k,j)=200*TR1tot(i,j)+100*TR2tot(i)+(kWhanual(k,j)-300)*TR3tot(i,j); % en colones
           end
        end
    end 

 Savemat(:,i)=facturacion(:,1)-facturacion(:,2);

end

saves=sum(Savemat);
peajes=sum(peaje);
yearvector=0:1:years;
CostManvec=repmat(CostMan,1,years);

CashFlow=[-Init_pay,saves-peajes-CostManvec];

for i=1:tloan
    CashFlow(i+1)=CashFlow(i+1)-loanpay(i);
end

CashFlow(2)=CashFlow(2)-CostMed;

CashFlow(yearSustInv+1)=CashFlow(yearSustInv+1)-CostSustInv;

ROR=irr(CashFlow);

dr=0.1; % tasa de descuento (discount rate)
for i=1:length(CashFlow)
 DiscCashFlow2year0(i)=CashFlow(i)/(1+dr)^(i-1); %
end

DiscCashFlow2yeari=zeros(1,length(CashFlow));
DiscCashFlow2yeari(1)=DiscCashFlow2year0(1);
for i=2:length(CashFlow)
    DiscCashFlow2yeari(i)=DiscCashFlow2yeari(i-1)+DiscCashFlow2year0(i);
end

Valor_Pres=pvvar(CashFlow,dr);

x_pts=0:1:years;
y_pts=DiscCashFlow2yeari;

f = @(x)interp1(x_pts,y_pts,x,'linear','extrap');
if ROR<2
  paybacktime=fzero(f,years*3);
else
  paybacktime=fzero(f,years);
end

subplot(length(kWinstalvec),1,w)
bar(x_pts,y_pts,'b');
str1=sprintf('TIR de %2.1f%%. Ahorros en %2.1f años. ',ROR*100,paybacktime);
text(15,DiscCashFlow2yeari(6),str1) 
str2=sprintf('PV de %d kW, CNFL (inc. tar. %2.1f%%). Consumo %d kWh (inc. %2.1f%%), producción %2.1f kWh (deg. %2.1f%%) al año 0. Peaje %d col/kWh (inc. %2.1f%%). Financiamiento del %d%% ',kWinstal,aumcostel*100,kWhLoadmes,loadgwrt*100,kWhPVmes,PVdeg*100,ppkWh,aumpeaje*100,perloan*100);
title(str2)
ylabel('Colones')

end

