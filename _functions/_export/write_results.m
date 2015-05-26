function [ ] = write_results( )
students=quickget('students');
projects=quickget('projects');
projectIDs=quickget('projectIDs');
choices=quickget('choices');

leading_str=sprintf('results_%s',date());
ftype='.txt';
if exist([cd,'\',leading_str,ftype],'file')==2 %if already printed results for today's date
	delete([cd,'\',leading_str,ftype]);%try to delete
end
fid=fopen([cd,'\',leading_str,ftype],'a');
        
for i=1:length(projects)
    matchedStudents=find(projectIDs==i);
	str=sprintf('Project %d | %s',i,projects(i).sponsor);
	fprintf(fid,'%s\r\n%s\r\n%s\r\n',repmat('-',1,6),str,repmat('-',1,6));
    for j=matchedStudents
        if choices(j)==-1
            fprintf(fid,'%s %s %s\r\n',students(j).firstname, students(j).lastname, 'Random');
        elseif choices(j)==0
            fprintf(fid,'%s %s %s \r\n',students(j).firstname, students(j).lastname, 'Recommendation');
        else
            fprintf(fid,'%s %s Choice%d\r\n',students(j).firstname, students(j).lastname, choices(j));
        end
    end
    fprintf(fid,'\r\n\r\n');
end
fclose(fid);
end
