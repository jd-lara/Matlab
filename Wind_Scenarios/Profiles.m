%% This file contains load, wind and solar profiles, interpolated using spline functions from real data

% Steps for optimization, in minutes
dt = [5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 15 15 15 30 30 30 30 30 30 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60]';
n = length(dt);
Xt=zeros(n,1);
dT=[dt;60];
Tstep=5;
dT2=ones(24,1)*60;

Wind_Prof_aux = xlsread('Wind_Forecast.xlsx', 'Wind Profile','B2:CS97');
Xt_in = linspace(0,15*95,96);
Xt_out= 0:Tstep:(15*95);

for q = 1:n
    Xt(q+1) = Xt(q)+dt(q);
end

WProf_aux = spline(Xt_in,Wind_Prof_aux,Xt_out);
WProf = spline(Xt_in,WProf_aux',Xt_out)';

WProf = spline(Xt_out,WProf,Xt);
WProf = WProf.*(WProf>0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:length(Xt_out)
    
    head_v(k,1) = {strcat('K',num2str(k))};
             
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%