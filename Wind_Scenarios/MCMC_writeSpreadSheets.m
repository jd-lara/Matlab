load MCMC_forecasts.mat

for k=1:length(forecasts(1,:))
    
    ColumnHeader(1,k) = {strcat('Kt',num2str(k))};
             
end


step = 1;
for k=1:length(forecasts(:,1))/288
    
    for kk = 1:288
        
        RowScenario(step,1) = {strcat('Sr',num2str(k))};
        
        RowKtr(step,1) = {strcat('Ktr',num2str(kk))};
        
        step = step + 1;
    end
             
end

xlswrite('OPF_Scenarios.xls',ColumnHeader,'Wind_Profile','C1');
xlswrite('OPF_Scenarios.xls',RowScenario,'Wind_Profile','A2');
xlswrite('OPF_Scenarios.xls',RowKtr,'Wind_Profile','B2');
xlswrite('OPF_Scenarios.xls',ColumnHeader,'Wind_Profile_Perf','C1');
xlswrite('OPF_Scenarios.xls',RowScenario,'Wind_Profile_Perf','A2');
xlswrite('OPF_Scenarios.xls',RowKtr,'Wind_Profile_Perf','B2');