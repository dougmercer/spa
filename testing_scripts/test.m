function [ A, B ] = test(th )
nStudents = 2000;
nProjects = 600;
nNodes = nStudents + nProjects + 4*nProjects + 2;
nEdges = length(th);


%initialize sparse matrix, A
A = spalloc(nNodes, nEdges, 2*nEdges);
for i = 1:nEdges
    A(th(1,i), i) = 1;
    A(th(2,i), i) = -1;
end


B = th2A( th, nNodes, nEdges );


end

