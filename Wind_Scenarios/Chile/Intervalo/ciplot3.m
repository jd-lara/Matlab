%Fernanda Avila
%Junio 2013


% Original: Raymond Reynolds 24/11/06
function ciplot3(lower1,upper1,lower2,upper2,lower3,upper3,colour1,colour2,colour3);

%Igual que ciplot pero para graficar 3 intervalos
% Intervalos 1<2<3     
% Plots a shaded region on a graph between specified lower and upper confidence intervals (L and U).
% l and u must be vectors of the same length.
% Uses the 'fill' function, not 'area'. Therefore multiple shaded plots
% can be overlayed without a problem. Make them transparent for total visibility.
% x data can be specified, otherwise plots against index values.


if length(lower1)~=length(upper1)||length(lower2)~=length(upper2)||length(lower3)~=length(upper3) 
    error('lower and upper vectors must be same length')
end

x=1:length(lower1);

% convert to row vectors so fliplr can work
if find(size(lower1)==(max(size(lower1))))<2
lower1=lower1'; end
if find(size(upper1)==(max(size(upper1))))<2
upper1=upper1'; end

if find(size(lower2)==(max(size(lower2))))<2
lower2=lower2'; end
if find(size(upper2)==(max(size(upper2))))<2
upper2=upper2'; end

if find(size(lower3)==(max(size(lower3))))<2
lower3=lower3'; end
if find(size(upper3)==(max(size(upper3))))<2
upper3=upper3'; end

fill([x fliplr(x)],[upper fliplr(lower)],colour)

fill([x fliplr(x)],[lower2 fliplr(lower3)],colour1)
fill([x fliplr(x)],[lower1 fliplr(lower2)],colour2)
fill([x fliplr(x)],[upper1 fliplr(lower1)],colour3)
fill([x fliplr(x)],[upper2 fliplr(upper1)],colour2)
fill([x fliplr(x)],[upper3 fliplr(upper2)],colour1)


