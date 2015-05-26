function [conflict] = detect_conflicts(students, sections)
days = ['u', 'm', 't', 'w', 'r', 'f', 's'];
nStudents = length(students.student);
nSections = length(sections.section);
% initialize the result to false
conflict = zeros(nStudents, nSections);
for i=1 : nStudents
    for j=1 : nSections
        % initialize index for day of week for a new section
        k = 1;                                  
        % while we haven't iterated through all days and we haven't already found a conflict
        while ((k < 8) && (~conflict(i, j)))
            % grab the day
            d = days(k);
            % make sure the day we are looping through is in the stud sched
            index_student_day = is_day_in_schedule(d, students.student(i).schedule);
            index_section_day = is_day_in_schedule(d, sections.section(j).schedule);
            % if this is false then there is no conflict
            if (index_student_day ~= -1 && index_section_day ~= -1)
                % student_starts is the student's classes start times on day k
                student_starts = students.student(i).schedule.day(index_student_day).starts;
                % section_starts is the capstone sections start times on day k
                section_starts = sections.section(j).schedule.day(index_section_day).starts;      
                 % if there are elements in both, we need check for overlap
                if ((~isempty(section_starts)) && (~isempty(student_starts)))
                    student_ends = students.student(i).schedule.day(index_student_day).ends;
                    section_ends = sections.section(j).schedule.day(index_section_day).ends; 
                    % this function returns true if conflict, otherwise false
                    if (check_for_conflict(student_starts, student_ends, section_starts, section_ends))
                        % if we are here, then there is a conflict
                        conflict(i, j) = 1;        
                        % thus we can break since theres already a conflict
                        break; 
                    end 
                end
            end
            k=k+1;
        end 
    end
end
end