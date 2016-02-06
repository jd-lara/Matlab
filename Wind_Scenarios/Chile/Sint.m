
%Intervalos de 1 a 96 pasos con el Metodo A
%Para sintonizar alphas desde 10% a 90% de intervalo
%function s=Sint()
clear all
load WIND
%-----------------------Conjuntos--------------------------------
Datos=Data;
InTr=1;
FnTr=288; %27-Febrero
%Training
y_Tr=Datos(97:FnTr,1);
for i=1:96
   X_Tr(:,i)=Datos(97-i:FnTr-i,1);
end
%---------------------Modelo Difuso------------------------------
reglas=4;
method=2; %  LMS for each rule
norm=1; %Linear normalization
[model21, result]=takagisugeno1(y_Tr,X_Tr,reglas,[method norm]);
s.model21=model21;
s.result=result;

%----------------oooooooooooooooooo------------------------------
%---------------------INTERVALO----------------------------------
%----------------oooooooooooooooooo------------------------------

%Sintonización a para prediccion 
%Nivel de confianza
a=[];
a1=0.1;
CL=[];
IU=[];
IL=[];


    t=true;
    while t==true
        for j=1:length(X_Tr)
            X_aux=X_Tr(j,:);
            for i=1:96
            X_aux=[ysim(X_aux,model21.a,model21.b,model21.g) X_aux(1:95)];
            intervaltr_d=Intervalo(model21,result,a1,X_aux);
            end
        IU(j)=intervaltr_d.up; %el del n paso
        IL(j)=intervaltr_d.lw;
        end
    %Calculo Intervalo de Confianza    
    ci=CI(y_Tr(96:end),IU(1:end-95),IL(1:end-95))
    if  ci>0.9
    a(9)=a1;  
    CL(9)=ci;
    t=false;
    elseif ci>0.8
        a(8)=a1;
        CL(8)=ci;
        a1=a1+0.1;
    elseif ci>0.7
        a(7)=a1;
        CL(7)=ci;
        a1=a1+0.1;
    elseif ci>0.6
        a(6)=a1;
        CL(6)=ci;
        a1=a1+0.1;
    elseif ci>0.5
        a(5)=a1;
        CL(5)=ci;
        a1=a1+0.1;
    elseif ci>0.4
        a(4)=a1;
        CL(4)=ci;
        a1=a1+0.1;
    elseif ci>0.3
        a(3)=a1;
        CL(3)=ci;
        a1=a1+0.1;
    elseif ci>0.2
        a(2)=a1;
        CL(2)=ci;
        a1=a1+0.1;
    elseif ci>0.1
        a(1)=a1;
        CL(1)=ci;
        a1=a1+0.1;
    else
    a1=a1+0.1;
    end   
    end
    s.a=a;
