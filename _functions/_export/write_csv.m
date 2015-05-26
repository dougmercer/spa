function [ ] = write_csv( )
students=quickget('students');
projects=quickget('projects');
s_assignment=quickget('s_assignment');
art_p = quickget('art_p');
art_pm = quickget('art_pm');

csv_str=cell(length(students)+1,9);
csv_str(1,:)={'Last','First','email','Sponser','Project Title','Instructor','Course','Choice','Note'};
ns = length(students);
for i=1:length(students)
    if s_assignment(3,i)==-1
        val_str='Not Matched';
    elseif s_assignment(3,i) == 0
        val_str='Random';
    elseif s_assignment(3,i) < 1
        val_str='Recommendation';
    else
        s = s_assignment(1, i);
        val_str = num2str(find(s_assignment(2,i)==students(s).preferences));
    end
    if s_assignment(2, i) ~= Inf
        p = s_assignment(2,i);
        sec = projects(p).section{1};
        csv_str(i+1,:)={students(i).last, students(i).first, students(i).access, projects(p).sponsor, projects(p).title, char, sec, val_str, char};
    else
        na = 'N/A';
        csv_str(i+1,:)={students(i).last, students(i).first, students(i).access, na, na, na, na, val_str, char};
    end
end
for i = 1:2
    %make some blank rows?
    csv_str(ns + i,:) = {char, char, char, char, char, char, char, char, char};
end
[~, blah] = size(art_p);
for i = 1:blah
    p = art_p(1,i);
    str = sprintf('%s is short %d students of its overall lower bound.', projects(p).title, art_p(2,i));
    csv_str(ns +2+ i,:) = {str, char, char, char, char, char, char, char, char};
end
for i = 1:2
    %more blank rows... cause reasons
    csv_str(ns +2+blah+ i,:) = {char, char, char, char, char, char, char, char, char};
end
majors = fieldnames(quickget('majors'));
[~, blah2] = size(art_pm);
for i = 1:blah2
    p = art_pm(1, i);
    m = majors{art_pm(2, i)};
    str = sprintf('%s is short %d students of its %s lower bound.', projects(p).title, art_pm(3,i), m);
    csv_str(ns +2+blah+2+ i, :) = {str, char, char, char, char, char, char, char, char};
end
filestr = determine_savefile( 'results', '.csv' );
cell2csv(filestr, csv_str, ',');
% pref = quickget('pref');
% try
%     cell2csv([pref.writedir,filesep,filestr], csv_str, ',');
% catch
%     msgbox('Unable to save to file. Please verify that the directory you selected does not have write restrictions');
% end
end