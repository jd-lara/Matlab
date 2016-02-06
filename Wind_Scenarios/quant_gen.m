function [quant] = quant_gen(data)
%Quantile generator for Data 
% This code doesn't produce an actual qauntile such as quantile regression,
% but rather uses a random number generator.

n=numel(data); range=[]; quant=[];

for l=0.085:0.085:0.78

factor=l;
x1=rand(n,1); x2=rand(n,1); x3=rand(n,1);
x=(0.35*x1+0.3*x2+0.35*x3)*factor;


for k=1:n

    if data(k)+(x(k)/2) > 1
        diff=(1-data(k));
        range(k,:)=[1-diff-(x(k)),0.96];
    
    elseif data(k)-(x(k)/2) < 0  
        diff=data(k);
        range(k,:)=[0,(x(k))-diff];
        
    else 
         range(k,:)=[data(k)-(x(k)/2),data(k)+(x(k)/2)];

    end
end

quant=[quant,range];


end
quant=[quant'; data'];

for n=1:24
 quant(:,n)=sort(quant(:,n));
 end
%figure 

%plot(quant')

end

