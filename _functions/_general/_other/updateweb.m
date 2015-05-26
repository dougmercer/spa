function [ ] = updateweb( )
majors=quickget('pref','majors');
sections=quickget('pref','sections');
[fn,p,status]=uigetfile('*.html','Load the student website');
if status ~= 0
    str=fileread([p,fn]);%read file into string
    while ~strcmp(str(1),'<') %remove BOM
        str=str(2:length(str));
    end
    %Remove last semester's sections
    extents=regexp(str,'<!--CHANGE SECTIONS HERE-->(.+)<!--END SECTIONS-->','tokenExtents');
    %write this semester's sections
    attributes=fieldnames(sections);
    secprint=sprintf('%s\r\n',char);
    for s=attributes'
        secprint=[secprint,sprintf('\t\t\t\t<option value="%s">%s</option>\r\n',s{1},sections.(s{1}).displayname)];
    end 
    str=[str(1:extents{1}(1)),secprint,str(extents{1}(2)-3:length(str))];
    %Remove last semester's majors
    extents=regexp(str,'<!--CHANGE MAJORS HERE-->(.+)<!--END MAJORS-->','tokenExtents');
    %write this semester's sections
    attributes=fieldnames(majors);
    majprint=sprintf('%s\r\n',char);
    for m=attributes'
        majprint=[majprint,sprintf('\t\t\t\t<option value="%s">%s</option>\r\n',m{1},majors.(m{1}).displayname)];
    end 
    str=[str(1:extents{1}(1)),majprint,str(extents{1}(2)-3:length(str))];
    fid=fopen('newIndex.html','w');
    fwrite(fid,str);
    fclose(fid);
end
end