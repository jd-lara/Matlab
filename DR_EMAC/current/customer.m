classdef customer < handle
    %CUSTOMER Represents one customer.
    % A customer is defined by a set of devices.
            
    properties        
        % Customer devices
        devices % Array of devices owned by customer
        ndev    % Number of devices
        cont_ex % Matrix of devices contribution to input fuel consumption
        
        % Math model parameters
        mathpar % mathematical parameters
        dim     % Dimension of the vector of power consumption that
                % can be optimized.
        dim_c   % Dimension of the constraints on that vector.        
        
        % Solution parameters
        ds     % [kW] Vector of optimal aggregated demand
        
        % Auxiliar parameters
        par
    end    
    methods
        function obj = customer(par, devices)
            if nargin > 1
                obj.devices = devices;
                obj.ndev = size(devices,2);
                obj.par = par;
                obj.mathpar = p_mathpar();
                obj.gen_model_param();
                if isempty(obj.mathpar.A)
                    obj.dim_c = 0;
                else
                    obj.dim_c = size(obj.mathpar.A,1);
                end
            end
        end
        function obj1 = replicate(obj)
            obj1 = customer();
            obj1.devices = d_tcl();
            obj1.devices(1:obj.ndev) = d_tcl();
            for n = 1:obj.ndev
                obj1.devices(n) = obj.devices(n).replicate;
            end                
            obj1.ndev = obj.ndev;
            obj1.par = obj.par;
            obj1.mathpar = obj.mathpar;
            obj1.dim   = obj.dim;
            obj1.dim_c = obj.dim_c;
            obj1.cont_ex = obj.cont_ex;
        end    
        function gen_model_param(obj)
            rows1 = 0;            % Rows of U, u
            rows2 = 0; cols2 = 0; % Rows of A, b and cols of A
            TW = obj.par.TW;
            
            % Computing matrix dimensions
            for k = 1:obj.ndev
                dev = obj.devices(k);
                ind = dev.affects_utility + dev.affects_constraint;
                if ind >= 1
                    if dev.affects_constraint
                        dims = size(dev.mathpar.A);
                        rows2 = rows2 + dims(1);
                        cols2 = cols2 + dims(2);
                        rows1 = rows1 + dims(2); 
                    else
                        dims = size(dev.mathpar.U);
                        rows1 = rows1 + dims(2);
                        cols2 = cols2 + dims(2);                                                
                    end
                end
            end
            
            U = zeros(rows1,rows1);
            u = zeros(rows1,1);
            A = zeros(rows2,cols2);
            b = zeros(rows2,1);
            d = zeros(obj.par.TW,1);
            nfuel = obj.par.nfuel;
            obj.cont_ex = zeros(nfuel,1);
            obj.dim = cols2;
            obj.dim_c = rows2;
            
            r_fin1 = 0;
            r_fin2 = 0; c_fin2 = 0;            
            
            % Creating customer parameters U, u, A, b, S, d
            for k = 1:obj.ndev
                dev = obj.devices(k);
                ind = dev.affects_utility + dev.affects_constraint;
                if ind >= 1
                    obj.cont_ex = [obj.cont_ex, dev.cont_ex];
                    if dev.affects_constraint
                        dims = size(dev.mathpar.A);                        
                        r_ini2 = r_fin2 + 1; r_fin2 = r_fin2 + dims(1);
                        c_ini2 = c_fin2 + 1; c_fin2 = c_fin2 + dims(2);
                        A(r_ini2:r_fin2,c_ini2:c_fin2) = dev.mathpar.A;
                        b(r_ini2:r_fin2) = dev.mathpar.b;                    
                        r_ini1 = r_fin1 + 1; r_fin1 = r_fin1 + dims(2);
                        if dev.affects_utility
                            U(r_ini1:r_fin1,r_ini1:r_fin1) = dev.mathpar.U;
                            u(r_ini1:r_fin1) = dev.mathpar.u;
                        else
                            U(r_ini1:r_fin1,r_ini1:r_fin1) = zeros(dims(2));
                            u(r_ini1:r_fin1) = zeros(dims(2),1);
                        end
                    else
                        dims = size(dev.mathpar.U);
                        r_ini1 = r_fin1 + 1; r_fin1 = r_fin1 + dims(2);
                        U(r_ini1:r_fin1,r_ini1:r_fin1) = dev.mathpar.U;
                        u(r_ini1:r_fin1) = dev.mathpar.u;
                        c_ini2 = c_fin2 + 1; c_fin2 = c_fin2 + dims(2);
                    end
                else                        
                    d = d + dev.mathpar.d;                  
                end
            end
            obj.mathpar.set_A(A);
            obj.mathpar.set_b(b);
            obj.mathpar.set_U(U);
            obj.mathpar.set_u(u);
            obj.mathpar.set_d(d);
            n = size(obj.cont_ex,2);
            obj.cont_ex = obj.cont_ex(:,2:n);
        end
        function set_sol(obj, d)
            % Generates power and other metrics profiles for the devices
            fin = 0; 
            for k = 1:obj.ndev
                ini = fin + 1;
                dev = obj.devices(k);
                ind = dev.affects_utility + dev.affects_constraint;
                if ind >= 1
                    dimdev = dev.get_dim();
                    fin = fin + dimdev;
                    obj.devices(k).set_sol(d(ini:fin));
                end
            end
            
            % Aggregated demand
            TW = obj.par.TW;
            nfuel = obj.par.nfuel;
            obj.ds = zeros(TW,nfuel);
            I = eye(obj.par.TW);
            for f = 1:nfuel
                S = kron(obj.cont_ex(f,:),I);
                if f == 1
                    obj.ds(:,f) = S*d + obj.mathpar.d;
                else
                    obj.ds(:,f) = S*d;    
                end
            end
        end
        function U = get_U(obj)
            U = obj.mathpar.U;
        end
        function u = get_u(obj)
            u = obj.mathpar.u;
        end
        function A = get_A(obj)
            A = obj.mathpar.A;
        end
        function b = get_b(obj)
            b = obj.mathpar.b;
        end
        function d = get_d(obj)
            d = obj.mathpar.d;
        end 
        function S = get_S(obj)
            I = eye(obj.par.TW);
            S = kron(obj.cont_ex,I);
            S = sparse(S);
        end
    end
    
end

