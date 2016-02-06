function [S flag V_diff t] = taps(S) 

%Step 1. Find the Controlled Branches 

controlbranch=2*ismember(2,S.Branch.Type);

if controlbranch ~= 0

if S.Branch.Control(controlbranch,2) == 0
    
    controlledbus= S.Branch.To(controlbranch);
    V_diff=S.Branch.Control(controlbranch,3)-S.Bus.Voltages(controlledbus);

    if  V_diff >0 && abs(V_diff) > 0.016 
        S.Branch.TAP(controlbranch)=S.Branch.TAP(controlbranch)-0.015;
        t=S.Branch.TAP(controlbranch);
        flag =1;
    elseif  V_diff <0 && abs(V_diff) > 0.016
        S.Branch.TAP(controlbranch)=S.Branch.TAP(controlbranch)+0.015;
        t=S.Branch.TAP(controlbranch);
        flag = -1;
    else
        S.Branch.TAP(controlbranch)=S.Branch.TAP(controlbranch)+0;
        t=S.Branch.TAP(controlbranch);
        flag = 0;
    end
    
end

else
    flag = 0; 
    fprintf('No TAP controlled Transformers on the system\n')

end
