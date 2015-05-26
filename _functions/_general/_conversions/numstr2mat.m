function [ mat ] = numstr2mat( str )
if isnan(str)
    mat=NaN;
else
cellstr=strtrim(strsplit(str,','));
%cellstr=strtrim(mystrsplit(str, ','));
nEntries=length(cellstr);
mat=zeros(1,nEntries);
for i=1:length(cellstr)
    mat(i)=str2double(cellstr{i});
    %mat(i)=str2doubleq(cellstr{i});
end
end

