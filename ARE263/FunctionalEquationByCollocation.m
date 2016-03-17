%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ARE 263 Dynamic Methods
%  Larry Karp & Christian Traeger
%  
%  Function approximation
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup

% Consider setting your working directory to where you store your lecture's Matlab file
% cd ...

% Set parameter alpha in functional equation:
alpha=2;
% Note that increasing alpha to 3 or 4 implies a crazy residual. Still
% functional approximation is all nice and smooth and so is true solution.
% The spiky residual must be due to numeric precision of residual due to
% the the functional equation creating huge numbers in intermediate step.

% Analytic solution is alpha*log

% Specifiy the approximation space

n = 20;     % Number of basis functions
a = 0;    % Left bound of approximation interval
b = 10;      % Right bound of approximation interval

% Specify the basis function (here 'cheb', 'spli', or 'lin)
basis_fun = 'cheb';

% CompEcon routine defining the approximation space
fspace = fundefn(basis_fun,n,a,b);

% Obtain the collocation nodes
nod = funnode(fspace);

%% Computing the basis coefficients using fsolve

% Create a vector of basis coefficients. Serves as initial guess.
c = zeros(n,1);

% Create a function handle for the residual (separate file)
resid = @FunctionalEquationByCollocation_residual;

% Call the fsolve routine to solve for coefficients.
%  Note that our resid function is parameterized.
%  We need to send our resid function to fsolve as a function of only c. Do 
%  this by creating an anynomous function within fsolve itself.
%  See the fsolve help file more more details.
c_star = fsolve(@(c) resid(c,nod,fspace,alpha), c);

c_star

% This outcommented section is irrelevant for our example, but might help
% you at some point if you into the issue of generating complex numbers:
% Take only real component of the coefficients. The Chebychev polynomial
% approximation returns negative values of q in the early iterations of the
% fsolve algorithm. This implies that for those iterations the vector c
% will take complex values. Although the final, converged vector is
% real valued, MATLAB stores the elements as complex numbers. If this is the
% case it is necessary to only take the real part of the vector.
% NOTE: Verify for yourself that the imaginary part of c is zero. If it is
% not then you will need to do some troubleshooting. 
%if isreal(c_star) == 0
%    c_star = real(c_star);
%end

%% Plot residuals

% Creates an x-axis grid for plotting.
xgrid = [a:.001:b]';    % Note the transpose for correct dimensions.

% Calculates the residuals given optimal basis coefficients at all points
% on the pgrid.
residuals = resid(c_star,xgrid,fspace,alpha);
rnod = resid(c_star,nod,fspace,alpha);

% Make and save a pretty picture of the residuals
h = figure('name', ['Residuals for ' num2str(n) ' ' basis_fun ' basis functions']);
      set(gca,'fontsize',16)
        hold on 
        plot(xgrid,residuals,'b--');
         plot(nod,rnod,'X');
        title(['Residuals for ' num2str(n) ' ' basis_fun ' basis functions'], 'FontSize', 20);
        xlabel('x', 'FontSize', 16);
        ylabel('Residual error', 'FontSize', 16);
        hold off
     saveas(h,['residuals_' num2str(n) '_' basis_fun], 'jpg');
     saveas(h,['residuals_' num2str(n) '_' basis_fun], 'epsc');
close(h)

%% Plot function

% Calculates the quantities supplied at each price
ygrid = funeval(c_star,fspace,xgrid);
ynod = funeval(c_star,fspace,nod);

% Make and save a pretty picture of the supply and demand for 1 firm
h = figure('name', ['The (approximate) function solving the equation:']);
      set(gca,'fontsize',16)
        hold on % -- use for merging multiple plots        
        plot(xgrid,ygrid,'r');
        plot(nod,ynod,'X');
        %sprintf allows the newline escape command '\n' to be used in the title
        title(sprintf(['The (approximate) function solving the equation:']), 'FontSize', 20);
        xlabel('x', 'FontSize', 16);
        ylabel('Y', 'FontSize', 16);
        %legend('','');
        %axis([0 3 0 3]) %Set axis limits for a clearer image
        hold off
     saveas(h,['FunctionalSolution_with_' num2str(n) '_' basis_fun], 'jpg');
     saveas(h,['FunctionalSolution_with' num2str(n) '_' basis_fun], 'epsc');
close(h)

