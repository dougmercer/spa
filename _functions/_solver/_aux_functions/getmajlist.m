function [ majlist ] = getmajlist( )
majors = quickget('majors');
majnames = fieldnames(majors)';
majlist = cell(1,length(majnames));
for maj = majnames
    majlist{majors.(maj{1}).number} = maj{1};    
end
end

