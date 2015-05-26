function [ r ] = prepare_r( )
%PREPARE_R Summary of this function goes here
%   Detailed explanation goes here

%getappdata
students = quickget('students');
pref = quickget('pref');

%Compute student-project values (not time adjusted) (does not include all
%feas projects)
v = raw2valueMatrix();
[nStudents, nProjects] = size(v);

%initialize actual value matrix
r = NaN(nStudents,nProjects);

%Send ratings from v to r and determine max/min submission times
minTime = inf;
maxTime = 0;
for i = 1:nStudents
    iFeas = isfeasmatch( i ); %logical array of student i's feasible projects
    r(i, iFeas) = 0; %set all feasible projects to value 0
    preferred_bool = ~isnan(v(i, :)); %logical array of student i's preferred projects
    r(i, preferred_bool) = v(i, preferred_bool); %set to preferred values
    minTime = min(minTime, students(i).time);
    maxTime = max(maxTime, students(i).time);
end

%perform collaborative filtering if use_cf preference set
if isfield(quickget('pref','solver'),'use_cf') %remove this supporting changes added
    use_cf = quickget('pref','solver','use_cf');
    if use_cf
        r = CFilter(v, r); %perform collaborative filtering
    end
end

%Apply time discounting factor to r values
discount = log(1 - (100 - pref.solver.time_discount)/100); %compute time discounting factor
for i = 1:nStudents
    ratio = (students(i).time - minTime)/(maxTime - minTime);
    r(i, :) = r(i, :) * exp(discount * ratio); 
end
end

