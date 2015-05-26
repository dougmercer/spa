function [ ] = add2path( dirstr )
addpath(genpath(dirstr));
if exist([cd, filesep,'CompileMe'],'dir')==7
    rmpathsub([cd, filesep, 'CompileMe']);
end
end