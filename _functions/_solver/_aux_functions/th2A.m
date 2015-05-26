function [ A ] = th2A( th, m, n )
%Convert th 2xnEdges array into sparse node arc incidence matrix
A = sparse(th(1, :), 1:n, 1, m, n, 2*n);
B = sparse(th(2, :), 1:n, -1, m, n, 2*n);
A = A + B;
end

