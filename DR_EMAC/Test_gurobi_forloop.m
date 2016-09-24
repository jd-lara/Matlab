clear all

model.A = sparse([1 1 0; 0 1 1]);
model.obj = [1 2 3];
model.modelsense = 'Max';
model.rhs = [1 1];
model.sense = [ '<' '<'];

% Alterantive representation of A - as sparse triplet matrix
i = [1; 1; 2; 2];
j = [1; 2; 2; 3];
x = [1; 1; 1; 1];
model.A = sparse(i, j, x, 2, 3);

params.method = 2;
params.timelimit = 100;
params.Threads = 4;
params.OutputFlag = 0;

t = cputime;
for n = 1:9000

    tk = 0.001*n;
    
model2=model;
model2.rhs = [1 1+tk];

result = gurobi(model2, params);
logs(n) = result.objval;

%disp(result.objval);
%disp(result.x)

end
se = cputime-t;

params.Threads = 1;

t = cputime;
parfor n = 1:9000

    tk = 0.001*n;
    
model2=model;
model2.rhs = [1 1+tk];

result = gurobi(model2, params);

logp(n) = result.objval;

%disp(result.objval);
%disp(result.x)

end
pe = cputime-t;