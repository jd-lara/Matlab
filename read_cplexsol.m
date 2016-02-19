function x = read_cplexsol(solfile)
% READ_CPLEXSOL
%
%   x = cplexsol2mat(solfile)
%
%   Reads a CPLEX .sol xml file and extracts the solution. Returned is
%   the solution in form of a column vector x. The cplex solution file can
%   be created with the WRITE command in cplex.
%
%
%   Thomas Trötscher
%

xDoc = xmlread(solfile);
allVariables = xDoc.getElementsByTagName('variable');
x=zeros(allVariables.getLength,1);
% Note that the variable list index is zero-based.
for k = 0:allVariables.getLength-1
    thisVariable = allVariables.item(k);
    x(k+1) = str2double(thisVariable.getAttribute('value'));
end  % End FOR