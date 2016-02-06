%% NNCparam
% Generates the required parameters to run the NNC optimization algorithm.
%%
%% Overall Description
% This code implements the NNC algorithm for 2 and 3 objectives 
% as described in:
%
% A. Messac, A. Ismail-Yahaya and C.A. Mattson. The normalized normal 
% constraint method for generating the Pareto frontier structural and
% multidisciplinary optimization Volume 25, Number 2 (2003), 86-98.
% 
%%
%% Beta version 
% Copyright 2006 - 2012 - CPOH  
% Predictive Control and Heuristic Optimization Research Group
%      http://cpoh.upv.es
% ai2 Institute
%      http://www.ai2.upv.es
% Universitat Polit?cnica de Val?ncia - Spain.
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
clear all;
close all;
clc;
%% Variables regarding the optimization problem

NNCDat.NOBJ = 2;                          % Number of objectives

NNCDat.NRES = 0;                          % Number of constraints

NNCDat.NVAR   = 10;                       % Number of decision variables

NNCDat.mop = str2func('CostFunction');    % Cost function file. In this
                                          % file should be coded the
                                          % calculation of the objective
                                          % vector given a decision
                                          % variable vector.
                                          
NNCDat.CostProblem='DTLZ2';               % Cost function instance. Used
                                          % in case you have several
                                          % mop problems in the same file.

NNCDat.FieldD =[zeros(NNCDat.NVAR,1)...
                ones(NNCDat.NVAR,1)];     % Optimization bounds

%% Variables regarding the optimization algorithm

NNCDat.mopOPT = str2func('OPTroutine');   % Optimization routine used. This
                                          % call the optimization routine
                                          % executed each time by the NNC
                                          % algorithm. The fmincon routine
                                          % is used in this application.

NNCDat.InitialGuess=[];                   % Use this if you have an initial
                                          % guess to be used in the
                                          % optimization. If empty, this
                                          % implementation will use a
                                          % random guess inside the
                                          % optimization bounds.


%NNCDat.AnchorF=[1 0 1; 0 1 1; 1 1 0];    % Use this if you have a guess 
NNCDat.AnchorF=[];                        % on the anchor points. If empty,
NNCDat.AnchorX=[];                        % the NNC algorithm will 
                                          % calculate them. 
                                          % For the 3 objectives case the 
                                          % anchor calculation is a 
                                          % sensible step. Try the guess 
                                          % (commented above) to see the 
                                          % diferences on the outcome.
                                          
NNCDat.CounterGEN=0;                      % Generation counter. 
                                          % Please, do not change.

NNCDat.CounterFES=0;                      % Function Evaluation counter. 
                                          % Do not change.

NNCDat.Card=100;                          % Number of divisions in the 
                                          % utopian line/plane. 
                                          % For 3 objective problem a 
                                          % suggested value is 10 (due to
                                          % computational burden).

%% Variables regarding the Pareto Set filtering
NNCDat.DominanceFiltering='yes';          % This is a basic Dominance
                                          % filtering; Write 'yes' if you
                                          % want to filter the Pareto front
                                          % and write 'no' if you do not
                                          % want to do it.
                                          
NNCDat.SmartFiltering='yes';              % This is the smart filter
NNCDat.RateFilter=[0.1 0.1];              % proposed by Matsson et Al. in:
%
% Mattson CA, Muller AA, Messac A. Smart Pareto Filter: Obtaining a minimal
% representation of multi-objective design space. Engineering Optimization 
% 2004 36(6):721-740.
%
% Only will be executed if NNCDat.DominanceFiltering=='yes';

NNCDat.SaveResults='yes';                  % Write 'yes' if you want to 
                                           % save your results after the
                                           % optimization process;
                                           % otherwise, write 'no';
%% Put here the variables required by your code (if any).
%
%
%
%%
%
OUT=NNC(NNCDat);                         %Run the algorithm
%
%% Release and bug report:
%
% November 2012: Initial release