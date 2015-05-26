function [conflict] = check_for_conflict(student_starts, student_ends, section_starts, section_ends)
% initialize as false
conflict = 0;                                                    
% initialize index for students and sections respectively
i = 1;                                                               
j = 1;
% while we haven't checked against all section meeting times AND while we haven't found a conflict
while (j <= length(section_starts) && (~conflict))
    % while we haven't checked all of students sched for the day and while we haven't passed this section's meeting's end time
    while ((i <= length(student_starts)) && (section_starts(j) <= section_ends(j)))   
       % this covers cases a, b
        if ((student_starts(i) <= section_starts(j)) && (student_ends(i) > section_starts(j))) 
            conflict = 1;
            return
        % this covers cases c, d        
        elseif ((student_starts(i) >= section_starts(j)) && (student_starts(i) <= section_ends(j))) 
            conflict = 1;
            return
        end
        % increment
        i = i + 1;                                                
    end
    j = j + 1; 
end
end

