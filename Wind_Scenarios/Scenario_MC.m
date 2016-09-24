clear all; 
load ktr_scenarios_original; 
load scenarios.mat

scenarios_fig

clear Scenarios
for k = 1:10
    for n = 1:length(Original(:,1))
        noise = 1 - n/10 + normrnd(0, 0.15, 1, 400); 
        Scenarios(n,:) = Original(n,:).*noise(n:length(Original(1,:))+n-1);
        Scenarios(n,:) = Scenarios(n,:)/max(Scenarios(n,:));
        plot(Scenarios(:,1))
    end
end