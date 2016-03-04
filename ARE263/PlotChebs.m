%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ARE 263 Dynamic Methods
%  Christian Traeger
% 
%  "Problem 0": Plotting Chebychev polynomials
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup

clear all
close all
clc

% change path to wherever you want like your graphs to be saved
savepath = '/Users/jdlara/Dropbox/Matlab/ARE263';

N=12; % First N-1 Chebychev polynomial will be plotted (they start with 0)
M=9;
x=-1:0.001:1; % grid over which we plot the polynomials
fspace=fundefn('cheb',N,-1,1);  % creates the "function space data structure" 
                               % (mostly approximating basis) on interval [-1,1]
fspace2 = fundefn('spli',M,-1,1);                               

%% create plot

h = figure('name', 'Chebs');                    % starts a figure (internal name)
title('Chebychev Polynomials', 'FontSize', 20)  % title printed on top of Figure
hold all; 


for i=[1,4,7,12]                 % loop over basis functions

disp(['Currently plotting polynomial ' num2str(i-1)])
    
c=zeros(1,N);             % sets all basis coefficients to zero
c(1,i)=1;                 % sets ith basis coefficient to unity
y=funeval(c',fspace,x');  % evaluates the sum over the basis functions (only ith different from zero)
plot(x,y)                 % plots the result

end

hold off

h2 = figure('name', 'spli');                    % starts a figure (internal name)
title('Spline', 'FontSize', 20)  % title printed on top of Figure
hold all;

for i=1:M                 % loop over basis functions

disp(['Currently plotting polynomial ' num2str(i-1)])
    
c2=zeros(1,M);             % sets all basis coefficients to zero
c2(1,i)=1;                 % sets ith basis coefficient to unity
y2=funeval(c2',fspace2,x');  % evaluates the sum over the basis functions (only ith different from zero)
plot(x,y2)                 % plots the result

end

hold off

%% save the plot:
%disp(['Now saving files in directory ' savepath])
%saveas(h,[savepath 'Chebpols.jpg'])    % Chebpols.jpg is name of plot
%saveas(h,[savepath 'Chebpols.epsc2'])  % epsc2 is color eps format (more reliable than merely eps)
%close(h)
