function [ ] = display_solver_error( status, p )
        projects = quickget('projects');
        e{1} = sprintf('%s: overall lower bound greater than overall upper bound.', projects(p).title);
        e{2} = sprintf('%s: there exists a major lowerbound that exceeds its upper bound.', projects(p).title);
        e{3} = sprintf('%s: there exists a nonzero major lower bound for a major not in the major list.', projects(p).title);
        e{4} = sprintf('%s: there exists an empty or NaN major bound.', projects(p).title);
        e{5} = sprintf('%s: there exists an empty or NaN overall bound.', projects(p).title);
        e{6} = sprintf('%s: sum of major lower bounds exceeds overall upper bound.', projects(p).title);
        %e{7} = sprintf('%s: sum of major upper bounds is less than the overall lower bound.', projects(p).title);
        msgbox(e{status}, 'Error','error');
end

