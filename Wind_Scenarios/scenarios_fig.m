load scenarios.mat

%extend scenarios and ruc 
kt=numel(Realization);

scenarios_extended=zeros(100,kt);
k=1;

for n=1:100
    for m=1:24
    scenarios_extended(n,k:k+11)=Scenarios(n,m)*ones(1,12);
    k=k+12;
    end
k=1;    
end

Ruc=RUC';
RUC_extended=zeros(4,kt);

for n=1:4
    for m=1:24
    RUC_extended(n,k:k+11)=RUC(n,m)*ones(1,12);
    k=k+12;
    end
k=1;    
end

Realization=[Realization;Realization(1:2)];


plot(scenarios_extended','k'); hold on
plot(Realization)'; hold on;
plot(RUC_extended(2:end,:)', 'r')
plot(RUC_extended(1,:)', 'g')

scenarios_extended=scenarios_extended';
RUC_extended=RUC_extended';
