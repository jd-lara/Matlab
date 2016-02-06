function [flagV flagQ] = flags(S)

%Search for flags on the Voltages 
 
V=S.Bus.Voltages(S.Bus.PQList) >= S.Bus.ULimit(S.Bus.PQList);
V=V+(S.Bus.Voltages(S.Bus.PQList) <= S.Bus.LLimit(S.Bus.PQList));

if isempty(nonzeros(V))
    fprintf('No Voltage Flags\n')
    flagV=[];
else
    flagV= S.Bus.PQList(find(V));
    fprintf('Voltage Violation at bus %i\n',S.Bus.PQList(find(V))) %#ok<*FNDSB>
end

%Search for flags on the Reactive Power 
[~,t]=ismember(S.Bus.PVList,S.Machine.BusRef);

if isempty(S.Bus.PVList)
    fprintf('No PV Buses in the system\n')
    flagQ=[];
else
    
for k=t
    if (S.Machine.MinQOutput(k) == -1) || (S.Machine.MaxQOutput(k) == -1)
        Q(k)=0;
    elseif (S.Machine.MVAR(k)<=S.Machine.MaxQOutput(k)) && (S.Machine.MVAR(k)>=S.Machine.MinQOutput(k))
        Q(k)=0;
    else
        Q(k)=1;
    end
end    

if isempty(nonzeros(Q)) 
    fprintf('No Reactive Limit Flags\n')
    flagQ=[];
else
    flagQ= find(Q);
    fprintf('Reactive Limit Reached at Machine %i\n',S.Machine.BusRef(flagQ))
    flagQ=S.Machine.BusRef(flagQ);
end
end