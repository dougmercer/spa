function [list] = list_feas_proj_maj(snum, r)
%input 
%students is the actual students struct array
%snum is a number in interval 1..|S|, the index for the student in question
%projects is the actual projects struct array
%majors is the actual majors struct array

%getappdata
students = quickget('students');
projects = quickget('projects');
majors = quickget('majors'); %migrated

feasProjs = find(~isnan(r(snum,:)));  %list of the student's feasible projects
nmaj = length(fieldnames(majors));
list = [];
for pnum = feasProjs
    for smaj = students(snum).majors
        if myismember(smaj, projects(pnum).majors)
             majnum = majors.(smaj{1}).number;
             list = [list, (pnum-1) * nmaj + majnum];
         end
     end
end
end