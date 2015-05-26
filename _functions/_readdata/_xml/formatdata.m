function [ data ] = formatdata( xmldata )

%write majors
for i = 1:length(xmldata.majors.major)
    majtag = simplify_tag(xmldata.majors.major{i});
    data.majors.(majtag).aliases{1} = majtag;
    data.majors.(majtag).number = i;
end

% START FORMAT PROJECT DATA
p = xmldata.projects.project;
majnames = fieldnames(data.majors);
nprojects = length(p);
for i = 1:nprojects
    p(i).id = i;
    p(i).section = simplifyAliases(p(i).section);
    p(i).majors = simplifyAliases(p(i).majors);
    % get rid of weird characters
    p(i).section = regexprep(p(i).section, '[^\w]', '');
    p(i).majors = regexprep(p(i).majors, '[^\w]', '');
end
% return the project output
data.projects = p;
%add majorbounds
for i = 1:nprojects
    data.projects(i).majbounds = rmfield(data.projects(i).majbounds, 'maj');
    for maj = majnames' %initialize with zeros
        data.projects(i).majbounds.(maj{1}).lb = 0;
        data.projects(i).majbounds.(maj{1}).ub = 0;
    end
    for j = 1:length(p(i).majbounds.maj)  %fill nonzero values
        majtag = simplify_tag(p(i).majbounds.maj(j).val);
        data.projects(i).majbounds.(majtag).lb = p(i).majbounds.maj(j).lb;
        data.projects(i).majbounds.(majtag).ub = p(i).majbounds.maj(j).ub;
    end
end

% START FORMAT STUDENT DATA
s = xmldata.students.student;
nstudents = length(s);
for i = 1:nstudents
    s(i).majors = simplifyAliases(s(i).majors);
    % get rid of weird characters
    s(i).majors = regexprep(s(i).majors, '[^\w]', '');
    %write time of submission as num using time and date
    s(i).time = timedate2num(s(i).time, s(i).date);
    % we use this to index the current pref num of the current student
    counter = 1; 
    %exchange each proj title in preferences w/ the corresponding proj num
    for j=1:length(s(i).preferences.preference)
        for k=1:nprojects
             if (strcmpi(s(i).preferences.preference(j), p(k).title))
                 s(i).prefnum(counter) = k;
                 counter = counter+1;
                 break;
             end 
        end 
    end
end
s = rmfield(s, 'date');
%write the output to out_students
data.students = s;
%delete the old preferences with project titles
data.students = rmfield(data.students, 'preferences');
%assign the preferences number to a new preference field to stay consistent
for i=1:length(xmldata.students.student)
   data.students(i).preferences = data.students(i).prefnum;
end
%delete the prefnum field 
data.students = rmfield(data.students, 'prefnum');

%write sections
for i=1:length(xmldata.sections.section)
    section_tag = simplify_tag(xmldata.sections.section(i).name);
    data.sections.(section_tag).id = i;
    data.sections.(section_tag).aliases{1} = section_tag;
end

%For students, we need to translate section numbers to cell array of tags 
% This returns a matrix of students by sections, 1 means feasible to attend
[conflict] = detect_conflicts(xmldata.students, xmldata.sections);
% delete the student schedule field 
data.students = rmfield(data.students, 'schedule');
% Add the section conflict detection to the student data
% START FORMAT SECTION DATA
secnames = fieldnames(data.sections)';
for i=1:nstudents
   sec_ids = find(~conflict(i, :));
   sections = secnames(sec_ids); %ignore the debugger: "find" is necessary
   data.students(i).sections = sections;
end
end