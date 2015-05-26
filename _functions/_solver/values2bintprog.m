function [c, A, b, lb, ub, th] = values2bintprog(r)
%initialize data
students = quickget('students');
projects = quickget('projects');
majors = quickget('majors');
majlist = getmajlist;

% Here we will construct all edges in the graph such that:
% th1 contains everything connecting to project major nodes
% th2 contains everything connecting to project nodes
% th3 contains everything connecting to the sink

% we build edges for students -> projectMajor
nStudents = length(students);
nProjects = length(projects);
nMajors = length(fieldnames(majors));
th1_tail = [];
th1_head = [];
sink = nStudents + nProjects*nMajors + nProjects + 2;

for i = 1:nStudents
    %get number of feasible project majors for student(i)
    feas_proj = list_feas_proj_maj(i, r);
    nFeasProjMaj = numel(feas_proj);
	%handle tails (student nodes)
	th1_tail = [th1_tail  i*ones(1, nFeasProjMaj)];
	%handle heads (project major nodes)
	th1_head = [th1_head, nStudents + 1 + feas_proj]; 
end

%Connect artificial student to projectmajor nodes
th1_tail = [th1_tail (nStudents+1)*ones(1, nProjects*nMajors)];
th1_head = [th1_head (nStudents + 2 : nStudents + 1 + nProjects*nMajors)];
th1 = [th1_tail; th1_head];

%th2
%connect projectmajors -> projects
th2_head = [];
th2_tail = [];
proj_num = 1;
for i = 1:nProjects*nMajors
    if i  > proj_num*nMajors
        proj_num = proj_num+1;
    end
    th2_tail = [th2_tail i];
    th2_head = [th2_head (nProjects*nMajors + proj_num)];
end
%shift by nStudents + 1
th2_tail = th2_tail + nStudents + 1;
th2_head = th2_head + nStudents + 1;


% connect the artifical student to every project
th2_tail = [th2_tail (nStudents + 1)*ones(1, nProjects)];
th2_head = [th2_head ((nStudents + (nProjects*nMajors) + 2) : (sink - 1))];
th2 = [th2_tail; th2_head];

%th3
% 1) connect projects to the sink
% 2) connect every student & artifical student to the sink
th3_tail = [(sink - nProjects:sink - 1), 1:(nStudents + 1)];
th3_head = sink*ones(1, length(th3_tail));
th3 = [th3_tail; th3_head];

% concatenate all sub-matrices to form final tail-head matrix
th = [th1 th2 th3];

%some useful numbers
nth = length(th);
nth1 = length(th1_tail);
nth2 = length(th2_tail);
nth3 = length(th3_tail);

%initialize sparse matrix, A
nNodes = nStudents + nProjects + nMajors*nProjects + 2;
nEdges = length(th);
% A = spalloc(nNodes, nEdges, 2*nEdges);

%BUILD A
% for i = 1:nth
%     A(th(1,i), i) = 1;
%     A(th(2,i), i) = -1;
% end
A = th2A( th, nNodes, nEdges );

%BUILD LB and UB
lb = zeros(nth, 1);  %lb of zero takes care of students
ub = ones(nth, 1);   %ub of one takes care students (except art. student)

ind_for_art_s_to_pm = (th1(1,:) == nStudents + 1);
ub(ind_for_art_s_to_pm) = 999999999; %Feeling lazy. magic number really should set each to the pm's major lb

%bounds for edges entering project nodes
for i = 1:nth2
    projnum = th2(2, i) - nStudents - 1 - nProjects*nMajors;
    if th2(1, i) == nStudents + 1  %if edge from art. student to project
        lb(nth1 + i) = 0;
        ub(nth1 + i) = projects(projnum).ub;
    else
        majnum  = projmaj2proj(th2(1, i), nStudents, nMajors );
        majstr = majlist{majnum};
        lb(nth1 + i) = projects(projnum).majbounds.(majstr).lb;
        ub(nth1 + i) = projects(projnum).majbounds.(majstr).ub;
    end
end

%bounds for edges entering the sink
for i = 1:nth3
    if th3(1, i) > nStudents + 1 %edge not from a student node
        projnum = th3(1, i) - nProjects*nMajors - nStudents - 1;
        lb(nth1 + nth2 + i) = projects(projnum).lb;
        ub(nth1 + nth2 + i) = projects(projnum).ub;
    elseif th3(1, i) <= nStudents % edge from real student
        lb(nth1 + nth2 + i) = 0;
        ub(nth1 + nth2 + i) = 1;
    else %edge from art. student
        lb(nth1 + nth2 + i) = 0;
        ub(nth1 + nth2 + i) = sum(lb);
        %note, since we write the art. student -> sink edge last in th3
        %art student should be last edge, and so all lbs have already been
        %entered into lb.
    end
end 

% BUILD C
c=zeros(nth, 1);
% store the sum of the lower bounds
lbsum = sum(lb);
for i = 1:nth1
    if(th1_tail(i) == nStudents+1)
        %penalize artificial student-> projectmajor
        c(i) = -10*(lbsum + nStudents) - 1; 
        %additional -1 incetivizes flows intended to satisfy the project
        %lower bound to use the edge from the artificial student to the
        %artificial project directly, rather than flowing the an arbitrary
        %projectmajor edge. This allows us to better indentify the source
        %of infeasibility
    else %write student->projectmajor value
        row = th1_tail(i);
        col = th2_head(th1_head(i) - nStudents - 1);
        col = col - nStudents - 1 - (nProjects*nMajors);
        c(i) = r(row, col);
    end
end
% penalize artifical student->project
for i = nth1 + 1:nth - 1
    if(th(1, i) == nStudents + 1)
        c(i) = -10*(lbsum + nStudents);
    end 
end
%penalize student -> sink
c(end - nStudents: end - 1) = -10*(lbsum + nStudents);


%BUILD B
b = zeros(nStudents + (nProjects*nMajors) + nProjects + 2, 1);			
b(1:nStudents, 1) = ones(nStudents,1);	% set each students supply to 1	
b(nStudents + 1, 1) = lbsum; % art. student's supply could satisfy lbs		
b(sink, 1) = -(nStudents + lbsum); % set demand to negative supply
end

