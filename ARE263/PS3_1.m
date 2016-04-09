%Jose Daniel Lara, ARE 263
% This code solves the BVP for the continuos time Ramsey model, the set 
% of ordinary differential equations of the model are as follows
% 
% \dot c = \frac{c}{\eta}[L^{1-\kappa} \kappa k^{\kappa-1} - \rho -(\delta
% +g)]
% \dot k = k^{\kappa} L^{1 - \kappa} - c - (\delta + g) k
%
%Requires the files Ramsey_ss.m and res_PS3.m
%
%The code cycles through Chebyschev and Spline basis functions, considering
%the polynomial orders stored in the vector order. All the results are
%stored in the structure log. 

% clean up 
clear; close all;
clc

%Parameters for NL set of equations solving algorithm. 
opt = optimoptions('fsolve','Display','iter','Algorithm','trust-region-reflective');

% Parameters of the growth model to be used in the BVP, could have been
% clenear to define a param structure with all of them.
eta = 2; 
rho = 0.015;
kappa = 0.3;
delta = 0.1;
g = 0.02;
L = 7;

%Initial condition for the capital
k0 = 80;

% This portion of the code solves question iii) and finds the ss values of
% the x vector is x = [c , k], x_ss is the value in steady state of the
% variables. 
x_ss = fsolve(@(x) Ramsey_ss(x,eta, rho, kappa, delta,...
            g, L), [10;10], opt);        

        
fprintf('The solution to the capital stock in steady state is %f\n',...
                x_ss(2))

%%            
%Parameters to solve the BVP problem by the collocation method

basis_fun = {'cheb','spli'};% Specify the basis function 
                            % (here 'cheb', 'spli', or 'lin)

T = 50;                      %Limit of the time domain, assuming that the 
                             %interval is [0,T]

order = [6, 10, 20];      %order of the polynominals

log = struct;               %This structure will store the results from the
                            %different cases tested. 
                           
for basis = [1, 2]
    log.(char(basis_fun(basis)))=struct; %Create the structure for each 
                                         %type of basis function
                                         
    for n = order
       log.(char(basis_fun(basis))).(['nodes' num2str(n)])=struct; %Create the structure for each 
                                                                   %number of basis functions
        
        c = zeros(n,2); c(1,:) = 1; c(2:n,:) = 0.05; %initial values for the 
                                                    %coefficients, they
                                                    %can't all be zero
                                                    %because of the spline
                                                    %approx
        
        %Definidion of the nodes and the function space.
        tnodes = chebnode(n-1,0,T);         %n-1 nodes are defined since the
                                            %last node is at the boundary T
        
        fspace = fundefn(char(basis_fun(basis)), n, 0, T);
        
        %Book method to find c, for practial purposes this can be ignored.
        % c_1 = broyden('res_PS3', c(:), tnodes, T, n, x_ss, fspace, eta, rho, kappa, delta,...
        %             g, L, k0);
        %
        % c_1 = [c_1(1:n),c_1(n+1:end)];
        
        %Update of the chebyschev weights using matlab solver. c_2 is the solution
        %to the system of equations for the coefficients. It was not very
        %smart to use c both for the coefficientes and the consumption
        %variable. Probably this can be improved. 
        
        resid = @res_PS3;
        
        [c_2 , ~, flag] = fsolve(@(c) resid(c, tnodes, T, n, x_ss, fspace, eta, rho, kappa, delta,...
            g, L, k0), c, opt);
        
        if imag(c_2) > eps 
            error('Error. polynomial coefficients contain imaginary terms') 
        end
        
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('coeffs')=c_2;
        
        %Simulation of the system solution.
        
        t_sym = nodeunif(1001,0,T); %This variable defines the grid for simulation,
                                    %in this case is a 1001 points in [0,T]
        
        x = funeval(c_2,fspace,t_sym); %This function evaluates the approximation at the
                                       % t_sym grid. 
                                       
        residuals = resid(c_2, t_sym, T, n, x_ss, fspace, eta, rho, kappa, delta,...
            g, L, k0);
        
        residuals_c = residuals(1:numel(t_sym));                %Residuals for \dot c in the simulation grid        
        residuals_k = residuals(numel(t_sym)+1:2*numel(t_sym)); %Residuals for \dot k in the simulation grid 
        
        rnod = resid(c_2, [0;tnodes;T], T, n, x_ss, fspace, eta, rho, kappa, delta,...
            g, L, k0);
        
        rnod_c = rnod(1:numel([0;tnodes;T]));                       %Residuals for \dot c in the nodes
        rnod_k = rnod(numel([0;tnodes;T])+1:2*numel([0;tnodes;T])); %Residuals for \dot k in the nodes
        
        %This section of the code just stores all the results into the
        %results structure for each case
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('opt_flag')=flag;
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('tnodes')=[0;tnodes;T];
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym')=t_sym;
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('c_sym')=x(:,1);
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('k_sym')=x(:,2);
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('residuals_c')=residuals_c;
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('residuals_k')=residuals_k;
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('rnod_c')=rnod_c;
        log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('rnod_k')=rnod_k;
        
    end
end


%%

%This section of the code is just for printing the results and to create
%the different plots of interest for the problem in question. I aboused a
%little bit here using some of the code in the examples for plotting. 

close all;

for basis = [1, 2]
    for n = order
        
        if log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('opt_flag') > 0
            fprintf('Plot of the case of %s approximations and %s nodes\n',...
                char(basis_fun(basis)), num2str(n))
            %Plots of the residuals for capital stock
            h = figure('name', ['Residuals of k for ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions']);
            set(gca,'fontsize',16)
            hold on
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('residuals_k'),'b--');
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('tnodes'),...
                log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('rnod_k'),'X');
            title(['Residuals for ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions'], 'FontSize', 20);
            xlabel('Time in years', 'FontSize', 16);
            ylabel('Residual error for k_t', 'FontSize', 16);
            hold off
            saveas(h,['k_residuals_' num2str(n) '_' char(basis_fun(basis))], 'epsc');
            close(h)
            
            %Plots of the residuals for consumption
            h2 = figure('name', ['Residuals of c for ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions']);
            set(gca,'fontsize',16)
            hold on
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('residuals_c'),'b--');
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('tnodes'),...
                log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('rnod_c'),'X');
            title(['Residuals for ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions'], 'FontSize', 20);
            xlabel('Time in years', 'FontSize', 16);
            ylabel('Residual error for c_t', 'FontSize', 16);
            hold off
            saveas(h2,['c_residuals_' num2str(n) '_' char(basis_fun(basis))], 'epsc');
            close(h2)
            
            %Plots of the timepath of capital stock
            h3 = figure('name', ['Time path of decision variables ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions']);
            set(gca,'fontsize',16)
            hold on
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('k_sym'),'b--');
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('c_sym'),'r--');
            title(['Time path ' num2str(n) ' ' char(basis_fun(basis)) ' basis functions'], 'FontSize', 20);
            legend('Capital stock k_t','Consumption c_t');
            xlabel('Time in years', 'FontSize', 16);
            ylabel('Capital Stock and Consumption', 'FontSize', 16);
            hold off
            saveas(h3,['timepath' num2str(n) '_' char(basis_fun(basis))], 'epsc');
            close(h3)
            
            %Plots of the timepath of capital stock
            figure(99)
            set(gca,'fontsize',16)
            hold on
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('k_sym'));
            title('Time path comparison', 'FontSize', 20);
            % I didn't have time to include automated legend for this plot
            xlabel('Time in years', 'FontSize', 16);
            ylabel('Capital Stock', 'FontSize', 16);
            hold off
            
            %Plots of the timepath of consumption
            figure(98)
            set(gca,'fontsize',16)
            hold on
            plot(log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('t_sym'),...
                 log.(char(basis_fun(basis))).(['nodes' num2str(n)]).('c_sym'));
            title('Time path comparison', 'FontSize', 20);
            % I didn't have time to include automated legend for this plot
            xlabel('Time in years', 'FontSize', 16);
            ylabel('Consumption', 'FontSize', 16);
            hold off
           
  
        else
            fprintf('The problem could not be solved for the case of %s approximations and %s nodes\n',...
                char(basis_fun(basis)), num2str(n))
            
        end
    end
end
h_99 = figure(99);
saveas(h_99,'Time_paths_capital', 'epsc');
h_98 = figure(98);
saveas(h_98,'Time_paths_consumption', 'epsc');