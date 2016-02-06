%
% 3-bus Power Flow example
%

clear all

global lambda
lambda=1+5+5+5+5+0.5; 

%
% PF Solution from flat start with numeric Jacobian:
%
disp('PF solution (numeric jacobian):');
%zo=fsolve(@PFeqs,[-0.2501   -1.2613   12.0000    7.0658    4.8031   20.1667],optimset('Display','iter'))
zo=fsolve(@PFeqs,[0 0 0 0 0 0],optimset('Display','iter'))


%
% PF Solution from flat start with symbolic Jacobian:
%
%disp('PF solution (symbolic jacobian):');
%zo=fsolve(@PFjac,[0 0 0 0 0 0],optimset('Display','iter','Jacobian','on'))



