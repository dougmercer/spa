function [] = compile_launcher(dirstr)
%QUICKFIX: Since I don't really understand -a and -I options for mcc, this
%script quickly aggregates all files for compilation into a single folder
%./zCompileMe/
if exist([dirstr,filesep,'CompileMe'],'dir')==7
    rmdir([dirstr,filesep,'CompileMe'],'s');
end
mkdir([dirstr,filesep,'CompileMe']);
rmpathsub(dirstr);

dirContent=dir;
myDirs=cell(0,0);
k=1;
for i=1:length(dirContent)
    if dirContent(i).isdir
        if strcmp(dirContent(i).name(1),'_')
            myDirs{k,1}=dirContent(i).name;
            k=k+1;
        end
    end
end

while ~isempty(myDirs)
    K=k-1;
    cdok=false;
    while ~cdok
        if exist(myDirs{K,1},'dir')
            cdok=true;
        else
            cd('../')
        end
    end
    cd(myDirs{K,1});
    dirContent=dir;
    for i=1:length(dirContent)
        if dirContent(i).isdir 
            if strcmp(dirContent(i).name(1),'_') %get additional folders 
                myDirs{k,1}=dirContent(i).name;
                k=k+1;
            end
        else %copy any files in current directory
            copyfile(dirContent(i).name,[dirstr,filesep,'CompileMe']);
        end
    end
    myDirs(K,:)=[];
    k=k-1;
end
cd(dirstr);