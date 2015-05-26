function [ data ] = importxml( )
%open gui window to allow user to select .xml file for import
[fn,p]=uigetfile('*.xml','Select the Projects .xml file');
str=fileread([p,fn]);%read file into string
str=strrep(str,'&',' and '); %replace all instances of ampersand with " and "
str=regexprep(str,'[^(\x20-\x7F)]*','');%remove all nonvalid utf-8 characters
fid=fopen([p,fn],'w'); %open the file with write priviledges 
fwrite(fid,str);       %write our modified str to the file
fclose(fid);           %close the file
data=xml_read([p,fn]);  %open the file using xml_read, store result
end

