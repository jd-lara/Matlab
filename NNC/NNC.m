%% NNC
% Run the NNC optimization algorithm. It needs the parameters defined in
% NNCparam.m to work.
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
%% Main Call
% 
% Main body
%
function OUT=NNC(Dat)
%% Reading parameters form Dat
Nobj   = Dat.NOBJ;             % Number of objectives.
Nvar   = Dat.NVAR;             % Number of decision variables.
mopOPT = Dat.mopOPT;           % Optimization routine to implement.
mop    = Dat.mop;              % Cost Function
Bound  = Dat.FieldD;           % Optimization bounds.

%% Initialization
FES    = 0;                    % Function Evaluation.
PSet   = zeros(Dat.Card,Nvar); % Pareto Front initialization.
PFront = zeros(Dat.Card,Nobj); % Pareto Front initialization.
Card   = 0;                    % Quantity of solutions.

%% Step1 ANCHOR POINTS
if size(Dat.AnchorF)==0 % Anchors are not provided in NNCparam.m
    Dat.LookingAnchors=1; % To avoid including the non linear constraints
                          % defined by the NNC algorithm.
    AnchorX=zeros(Nobj,Nvar);
    AnchorF=zeros(Nobj,Nobj);
    
    for nobj=1:Nobj
        disp(['Ancla: ' num2str(nobj)]);
        Mu=zeros(1,Nobj);
        Mu(1,nobj)=1;
        Dat.Mu=Mu;
        if size(Dat.InitialGuess)==0 % No initial guess is provided
            X=(Bound(:,1)+(Bound(:,2)-Bound(:,1)).*rand(Nvar,1))';
        else %An initial guess is provided
            X=Dat.InitialGuess;
        end
        [Xsqp,~,FVAL]=mopOPT(X,Dat);
        FES=FES+FVAL;
        AnchorX(nobj,:)=Xsqp;
        AnchorF(nobj,:)=mop(Xsqp,Dat);
        Card=Card+1;
    end
else %Anchors are provided in NNCparam.m
    AnchorX=Dat.AnchorX;
    AnchorF=Dat.AnchorF;
end
Dat.LookingAnchors=0;
if Nobj==2
    plot(AnchorF(:,1),AnchorF(:,2),'ob'); grid on; hold on;
elseif Nobj==3
    plot3(AnchorF(:,1),AnchorF(:,2),AnchorF(:,3),'ob'); grid on; hold on;
end


%% Step 2 NORMALIZATION
Dat.Utopia=min(AnchorF)
Dat.Nadir=max(AnchorF)
Dat.MatrixL=(Dat.Nadir-Dat.Utopia)

%% Step 3 UTOPIA LINE VECTOR
if Nobj==2
    normAnchors(1,:)=(AnchorF(1,:)-Dat.Utopia)./Dat.MatrixL;
    normAnchors(2,:)=(AnchorF(2,:)-Dat.Utopia)./Dat.MatrixL;
    Nk=normAnchors(2,:)-normAnchors(1,:);
elseif Nobj==3
    normAnchors(1,:)=(AnchorF(1,:)-Dat.Utopia)./Dat.MatrixL;
    normAnchors(2,:)=(AnchorF(2,:)-Dat.Utopia)./Dat.MatrixL;
    normAnchors(3,:)=(AnchorF(3,:)-Dat.Utopia)./Dat.MatrixL;
    Nk=[normAnchors(3,:)-normAnchors(1,:);
        normAnchors(3,:)-normAnchors(2,:)];
end
Dat.Nk=Nk;


%% Step 4 NORMALIZED INCREMENTS
delta1=1/(Dat.Card-1);

%% Step 5 GENERATE UTOPIA LINE POINTS
alpha1=0:delta1:1;
if Nobj==2
    alpha1=alpha1';
    normXpj=zeros(size(alpha1,1),2);
    for pj=1:size(alpha1,1)
        normXpj(pj,:)=alpha1(pj,1)*normAnchors(1,:)+(1-alpha1(pj,1))*normAnchors(2,:);
    end
elseif Nobj==3 %Perhaps this step could be more elegant...
    k=0;
    Pesos=zeros(Dat.Card^3,Nobj);
    for i=1:size(alpha1,2)
        for ii=1:size(alpha1,2)
            for iii=1:size(alpha1,2)
                k=k+1;
                Pesos(k,:)=[alpha1(i) alpha1(ii) alpha1(iii)];
                if sum(Pesos(k,:))>0
                    Pesos(k,:)=Pesos(k,:)/sum(Pesos(k,:));
                else
                    Pesos(k,:)=[0 0 1];
                end
            end
        end
    end
    Pesos=Pesos(1:k,:);
    normXpj=zeros(size(Pesos,1),3);
    for pj=1:size(Pesos,1)
        normXpj(pj,:)=Pesos(pj,1)*normAnchors(1,:)+Pesos(pj,2)*normAnchors(2,:)+Pesos(pj,3)*normAnchors(3,:);
    end
end

%% Step 6 PARETO POINTS CALCULATION

for pj=1:size(normXpj,1)
    disp(['Soluci?n: ' num2str(pj)]);
    Mu=zeros(1,Nobj);
    Mu(1,end)=1;
    Dat.Mu=Mu;
    Dat.normXpj=normXpj(pj,:);
    
    if size(Dat.InitialGuess)==0
        X=(Bound(:,1)+(Bound(:,2)-Bound(:,1)).*rand(Nvar,1))';
    else
        X=Dat.InitialGuess;
    end
    
    [Xsqp, ~, FLAG Options]=mopOPT(X,Dat);
    FEVALS=Options.funcCount;
    
    FES=FES+FEVALS;
    
    if FLAG==-2
        disp('.......... Algo paso...');
    else
        F=mop(Xsqp,Dat);
        if Nobj==2
            plot(F(1,1),F(1,2),'*r'); grid on; hold on;
        elseif Nobj==3
            plot3(F(1,1),F(1,2),F(1,3),'*r'); grid on; hold on;
        end
        pause(0.1)
    end
    
    PSet(pj,:)=Xsqp;
    PFront(pj,:)=mop(Xsqp,Dat);
    
end
%% Post-processing: only if you want to filter the calculated set.

if strcmp(Dat.DominanceFiltering,'yes')
    [PFrontFilter, PSetFilter]=...
        DominanceFilter(PFront,PSet);
    if strcmp(Dat.SmartFiltering,'yes')
        [PFrontFilter, PSetFilter]=...
        SmartFilter(PFrontFilter,PSetFilter,Dat.RateFilter);
    end
else
    PFrontFilter=PFront;
    PSetFilter=PSet;
end


F=PFrontFilter;
for xpop=1:size(F,1)
    if Nobj==2
        plot(F(xpop,1),F(xpop,2),'dk','MarkerFaceColor','k');...
            grid on; hold on;
    elseif Nobj==3
        plot3(F(xpop,1),F(xpop,2),F(xpop,3),'dk','MarkerFaceColor','k');...
            grid on; hold on;
    end
end

%% Going out
OUT.AnchorsX     = AnchorX;         % Anchors in decision space.
OUT.AnchorsF     = AnchorF;         % Anchors in objective space.
OUT.PFront       = PFront;          % Calculated Pareto Front.
OUT.PSet         = PSet;            % Calculated Pareto Set.
OUT.PFrontFilter = PFrontFilter;    % Filtered Pareto Front.
OUT.PSetFilter   = PSetFilter;      % Filtered Pareto Set.
OUT.Param        = Dat;             % Parameters used.
OUT.FES          = FES;             % Function evaluation used.

if strcmp(Dat.SaveResults,'yes')
    save(['OUT_' datestr(now,30)],'OUT');
end

disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('Blue circles   : Anchor points.')
disp('Red  asterisks : Set Calculated.')
disp('Black diamonds : Filtered Set.')
if strcmp(Dat.SaveResults,'yes')
    disp(['Check out OUT_' datestr(now,30) ...
          ' variable on folder for results.'])
end
disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')

%% Smart Filter
%
% This is the smart filter proposed by Messac in:
% Mattson CA, Muller AA, Messac A. Smart Pareto Filter: Obtaining a minimal
% representation of multi-objective design space. Engineering Optimization 
% 2004; 36(6):721-740.
%
function [PFront, PSet]=SmartFilter(F,C,Rate)

AuxF=sortrows([F C]);
F=AuxF(:,1:size(F,2));
C=AuxF(:,size(F,2)+1:end);
Xpop=size(F,1);
PFront=zeros(Xpop,size(F,2));
PSet=zeros(Xpop,size(C,2));
Fnorm=PFront;
CotaSup=max(F);
CotaInf=min(F);
L=CotaSup-CotaInf;
Nobj=size(F,2);
Dm=Rate(1,1);
DM=Rate(1,2);

for xpop=1:Xpop
    Fnorm(xpop,:)=(F(xpop,:)-CotaInf)./L;
end

ToCheck=Fnorm(1,:);
PFront(1,:)=F(1,:);
k=1;
for xpop=2:Xpop
    vm=(abs(ToCheck-Fnorm(xpop,:)));
    vM=(abs(ToCheck-Fnorm(xpop,:)));
    if sum(vm<Dm)==Nobj && sum(vM<DM)==Nobj
    else
        k=k+1;
        ToCheck=Fnorm(xpop,:);
        PFront(k,:)=F(xpop,:);
        PSet(k,:)=C(xpop,:);
    end
end

PFront=[PFront(1:k,:); F(end,:)];
PSet=[PSet(1:k,:); C(end,:)];

%% Dominance Filter
%
% A filter based on dominance criteria
%
function [PFront PSet]=DominanceFilter(F,C)

Xpop=size(F,1);
Nobj=size(F,2);
Nvar=size(C,2);
PFront=zeros(Xpop,Nobj);
PSet=zeros(Xpop,Nvar);
k=0;

for xpop=1:Xpop
    Dominated=0;
    
    for compare=1:Xpop
        if F(xpop,:)==F(compare,:)
            if xpop > compare
                Dominated=1;
                break;
            end
        else
            if F(xpop,:)>=F(compare,:)
                Dominated=1;
                break;
            end
        end
    end
    
    if Dominated==0
        k=k+1;
        PFront(k,:)=F(xpop,:);
        PSet(k,:)=C(xpop,:);
    end
end
PFront=PFront(1:k,:);
PSet=PSet(1:k,:);
%
%% Release and bug report:
%
% November 2012: Initial release
%
% December 13th. 2012: A bug reported by users in Smart Filter has been
% fixed (Correspondence between Filtered Front and Filtered Set).
%
