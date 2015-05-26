function [ str ] = determine_savepath( str )
pref = quickget('pref');
str = [pref.writedir, filesep, str];
end

