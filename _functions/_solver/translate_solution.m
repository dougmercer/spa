function [ s_assignment, art_pm, art_p ] = translate_solution( x, th, r )
%Input:
%x is the flow solution
%th is the tail-head list
%r is the student->project value table
%Output:
%s_assignment: 3 x nStudent array
%   first row: student index
%   second row: project index
%       Sink := Inf
%   third row: value of that match
%       Sink := -1
%art_pm: 3 x number of projectmajor lb violations
%   first row: project index
%   second row: major index
%   third row: number of artificial students needed to satisfy pm lb con
%art_p: 2 x number of project lb violations
%   first row: project index
%   second row: number of artificial students needed to satisfy proj lb con

%get app data
students = quickget('students');
projects = quickget('projects');
maj = quickget('majors'); %migrated

%useful numbers
nStudents = length(students);
nProjects = length(projects);
nMajors = length(fieldnames(maj));
sink = nStudents + 1 + nMajors*nProjects + nProjects + 1;

%reduce th and x to useful components
th_ind_s = th(1,:) <= nStudents;
th_s = th(:, th_ind_s);
x_s = x(th_ind_s);
th_s = th_s(:, x_s > 0);
x_s = x_s(x_s > 0);

th_ind_as = th(1,:) == nStudents + 1;
th_as = th(:, th_ind_as);
x_as = x(th_ind_as);
th_as = th_as(:, x_as > 0);
x_as = x_as(x_as > 0);

s_assignment = zeros(3, nStudents);
art_pm = [];
art_p = [];

for i = 1:length(x_s)
    s = th_s(1, i);
    if th_s(2, i) == sink
        s_assignment(1, s) = s;
        s_assignment(2, s) = Inf;
        s_assignment(3, s) = -1;
    else
        majnum  = projmaj2proj(th_s(2, i), nStudents, nMajors);
		shift_node = th_s(2, i) - nStudents - 1;
        projnum = (shift_node - majnum)/nMajors + 1;
        s_assignment(1, s) = s;
        s_assignment(2, s) = projnum;
        s_assignment(3, s) = r(s, projnum);
    end
end
for i = 1:length(x_as)
    if th_as(2, i) <= nStudents + 1 + nProjects *nMajors
        %art student to pm node
        majnum  = projmaj2proj(th_as(2, i), nStudents, nMajors);
		shift_node = th_as(2, i) - nStudents - 1;
        projnum = (shift_node - majnum)/nMajors + 1;
        art_pm = [art_pm, [projnum;majnum;x_as(i)]];
    elseif th_as(2, i) ~= sink
        %art student to proj node
        projnum = th_as(2, i) - nStudents - 1 - nMajors*nProjects;
        art_p = [art_p, [projnum; x_as(i)]];
    end
end
end