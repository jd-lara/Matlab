function v =Val(a,model21,result)
%Intervalos de 1 a 96 pasos con el Metodo A
%a corresponde al vector de los alpha sintonizados desde 10% a 90%
%v.IU=[U9;U8;...;U1]
%v.IL=[L9;L8;...;L1]
%v.M=[U9;...;U1;y_Vl;L1;...;L9]
%v.CL=[CL1 CL2...CL9]

load Demandas

%-----------------------Conjuntos--------------------------------
Datos=Demanda2(:,7);
InVl=7489;
FnVl=14112;

%Conjunto Validacion
y_Vl=Datos(97+InVl+1:FnVl,1);
for i=1:96
   X_Vl(:,i)=Datos(97-i+(InVl+1):FnVl-i,1);
end

for i=1:9
    i
IUVl=[];
ILVl=[];    
    for n=1:length(X_Vl)
    X_aux=X_Vl(n,:);
        for j=1:96
            X_aux=[ysim(X_aux,model21.a,model21.b,model21.g) X_aux(1:95)];
            interval_d=Intervalo(model21,result,a(i),X_aux);
        end
    II(n)=interval_d.interv;
    IUVl(1,n)=interval_d.up;
    ILVl(1,n)=interval_d.lw;
    end   
    v.CL(i)=CI(y_Vl(96:end),IUVl(1:end-95),ILVl(1:end-95))
    v.IU(10-i,:)=IUVl(1,:);
    v.IL(10-i,:)=ILVl(1,:);
end
v.M=[v.IU;y_Vl';v.IL];
fanchart(v.M(:,1:96))
