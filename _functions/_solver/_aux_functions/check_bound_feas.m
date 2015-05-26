function [ status, p ] = check_bound_feas( )
%status key:
% 0 success
% 1 exists lower bound greater than upper bound
% 2 exists proj maj w/ lower bound greater than upper bound
% 3 exists proj w/ major not in its major list that has nonzero major lb
% 4 exists an empty or NaN majorbound
% 5 exists an empty or NaN overall bound
% 6 exists project w/ sum of all lower majorbounds > overall upperbound
% 7 exists project w/ sum of all upper majorbounds < overall lowerbound
status = 0;
p = 0;
projects = quickget('projects');
nprojects = length(projects);
if nprojects > 0
    majors = fieldnames(projects(1).majbounds)';
end
    
for p = 1:nprojects
    if projects(p).lb > projects(p).ub
        status = 1;
        return
    end
    total_major_lb = 0;
    total_major_ub = 0;
    for m = majors
        m = m{1};
        if projects(p).majbounds.(m).lb > projects(p).majbounds.(m).ub
            status = 2;
            return
        end
        if projects(p).majbounds.(m).lb && ~ismember(m, projects(p).majors)
            status = 3;
            return
        else
            total_major_lb = total_major_lb + projects(p).majbounds.(m).lb;
        end
        if ismember(m, projects(p).majors)
            total_major_ub = total_major_ub + projects(p).majbounds.(m).ub;
        end
        invalid_mlb = isempty(projects(p).majbounds.(m).lb) || ...
                      isnan(projects(p).majbounds.(m).lb);
        invalid_mub = isempty(projects(p).majbounds.(m).ub) || ...
                      isnan(projects(p).majbounds.(m).ub);
        if invalid_mlb || invalid_mub %if either major bound is empty
            status = 4;
            return
        end
    end
    invalid_lb = isempty(projects(p).lb)||isnan(projects(p).lb);
    invalid_ub = isempty(projects(p).ub)||isnan(projects(p).ub);
    if invalid_lb || invalid_ub
        status = 5;
        return
    end
    if total_major_lb > projects(p).ub
        status = 6;
        return
    end
%     if total_major_ub < projects(p).lb
%         status = 7;
%         return
%     end
end


