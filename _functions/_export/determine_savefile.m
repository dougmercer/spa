function [ filestr ] = determine_savefile( leading_str, ftype )
if ~strcmp(ftype(1),'.')
    ftype=['.',ftype];
end
extra = char;
blah = true;
k = 1;
while blah
    if ~(exist([cd,filesep,leading_str,extra,ftype],'file')==2) %if already printed results for today's date
        blah = false;
    else
        extra = num2str(k);
        k = k+1;
    end
end
filestr =[cd,filesep,leading_str,extra,ftype];
end


