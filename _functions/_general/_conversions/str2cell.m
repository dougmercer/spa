function [ cellout ] = str2cell( str )
if isnan(str)
    cellout=cell(0, 0);
else
    if ~isempty(str)
        %cellout=strtrim(mystrsplit(str, ','));
        cellout=strtrim(strsplit(str,',')); %FIXME
    else
        cellout={char};
    end
end
