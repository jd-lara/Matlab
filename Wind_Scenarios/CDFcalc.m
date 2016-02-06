function [CDF, CDF_inv] = CDFcalc(xi, Fi)
%This script takes a quantile description of windpower forecasts and
%obtains the empirical CDF and inverse CDF required for scenario generation. 
%The function is obtained by an interpolation proceedure.
% The input aguments and the Power Values for each quantile (xi) and their
% respective probability (Fi) where F1<F2<F3<..<Fn and each 0<Fi<1. 

%input protection
if ~iscolumn(Fi)
    Fi=Fi';
end

if ~iscolumn(xi)
    Fi=Fi';
end


%Calculation of the CDF

%stairs(xi,Fi,'r')
%hold on
xj = xi(2:end);
Fj = (Fi(1:end-1)+Fi(2:end))/2;
%plot(xj,Fj,'b.', xj,Fj,'b-'); hold on;

xj = [0;xj;1];
Fj = [0.0001;Fj;(0.999)];
%plot(xj,Fj,'b-');
CDF = @(p) interp1(xj,Fj,p,'linear','extrap');
%p = 0.1:0.01:0.9;%Test Vector for the fit.
%figure
%plot(xj,Fj,'b-',p,CDF(p),'ko');

%Calculation of the inverse CDF

%figure
%stairs(Fi,[xi(2:end);xi(end)],'r');
%hold on
xj = [xi(1,1)*0.9;xi;(xi(end)*1.1)];
Fj = [0.0001;Fi;(0.999)];

%plot(Fj,xj,'b.',Fj,xj,'b-');
CDF_inv = @(y) interp1(Fj,xj,y,'linear','extrap');
%y=rand(10,1);
%figure
%plot(Fj,xj,'b-',y,CDF_inv(y),'ko');

end

