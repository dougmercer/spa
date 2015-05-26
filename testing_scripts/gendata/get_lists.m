function [in_list, out_list] = get_lists(student, projects)
in_list = [];
for i = 1:length(projects)
    if projects(i).type == student.type && ~myismember(i, student.preferences) 
        in_list = [in_list, i];
    end
end
out_list = [];
for i = 1:length(projects)
    if projects(i).type ~= student.type && ~myismember(i, student.preferences) 
        out_list = [out_list, i];
    end
end

function bool = myismember(a, b)
bool = ismembc(a, sort(b));
