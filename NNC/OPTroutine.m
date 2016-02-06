%% OPTroutine.m 
% Implements the optimization routine for NNC algorithm.
%
% Xsqp [OUT]    : The decision vector calculated
% FUN  [OUT]    : Objective vector Value
% Flag [OUT]    : See fmincon help
% Options [OUT] : See fmincon help
% X     [IN]    : Decision Variable (initial guess)
% Dat   [IN]    : Parameters defined in NNCparam.m
% 
%%
%% Beta version 
% Copyright 2006 - 2012 - CPOH  
% Predictive Control and Heuristic Optimization Research Group
%      http://cpoh.upv.es
% ai2 Institute
%      http://www.ai2.upv.es
% Universitat Politècnica de València - Spain.
%      http://www.upv.es
%%
%% Author
% Gilberto Reynoso Meza
% gilreyme@upv.es
% http://cpoh.upv.es/en/gilberto-reynoso-meza.html
% http://www.mathworks.es/matlabcentral/fileexchange/authors/289050
%%
%% For new releases and bug fixing of this Tool Set please visit:
% http://cpoh.upv.es/en/research/software.html
% Matlab Central File Exchange
%%
%% Main call
function [Xsqp FUN FLAG Options] = OPTroutine(X,Dat)

lb=Dat.FieldD(:,1);  % lower bounds for X
ub=Dat.FieldD(:,2);  % upper bounds for X
Aeq=[];              % Equality constraints of the form (Aeq)*(X)=Beq
Beq=[];
A=[];                % Inequality constraints of the form (A)*(X)<=
B=[];

options=optimset('Algorithm','active-set','Display','off');

%See fmincon help for more information
[Xsqp FUN FLAG Options]=fmincon(@(X)SQP(X,Dat),X,A,B,Aeq,Beq,lb,ub,@(X)SQPnolcon(X,Dat),options);

for nvar=1:size(X,2)
    if isnan(Xsqp(1,nvar))
        Xsqp=X; %Just in case we get NAN solution.
        break;
    end
end

%% Here comes the weighted function call
function Jw=SQP(X,Dat)

mop=Dat.mop;
J=mop(X,Dat);
Jw=J*Dat.Mu';

%% Here comes the non-linear constraints.
function [C Ceq]=SQPnolcon(X,Dat)


J=Dat.mop(X,Dat);

if Dat.LookingAnchors==1 % When looking for anchors points, the non-linear 
                         % contraints required by NNC are not included.
    if Dat.NOBJ==2
        C=[];
        Ceq=[];
    elseif Dat.NOBJ==3
        C=[];
        Ceq=[];
    end
else                    % We are looking for Pareto points with the utopia
                        % plane constraint.
    if Dat.NOBJ==2
        normJ=(J-Dat.Utopia)./(Dat.MatrixL);
        C=Dat.Nk*(normJ-Dat.normXpj)';%This one is required in NNC.
        Ceq=[];
    elseif Dat.NOBJ==3
        normJ=(J-Dat.Utopia)./(Dat.MatrixL);
        Dat.Nk;
        Dat.normXpj;
        C=Dat.Nk*(normJ-Dat.normXpj)';%This one is required in NNC
        Ceq=[];
    end
end
%% Release and bug report:
%
% November 2012: Initial release