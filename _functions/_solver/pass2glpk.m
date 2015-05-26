function [ x,f,status,extra ] = pass2glpk(c,A,b,lb,ub)
[nCons, nVars] = size(A);        %get number of constraints and variables
s = -1;                          %maximization
ctype = repmat('S', 1, nCons)';  %constraints are equalities, type 's' 
vartype = repmat('I', 1, nVars); %create appropriate binary, 'b', and integer 'i', types
param.msglev = 0;                %do not print output
[x, f, status, extra] = glpk(c, A, b, lb, ub, ctype, vartype, s, param);
end