function []=initpref()
% [writedir, status] = get_writedir();
if exist('preferences.mat','file')
    load('preferences.mat');
% if exist([writedir, filesep,'preferences.mat'], 'file');
%     %load existing preferences
%     load([writedir, filesep,'preferences.mat']);
else
    %create new preferences from default settings
    %Cosmetic Preferences
    pref.cosm.impath = 'psu_logo.jpg';
    %Solver Preferences
    pref.solver.minmatchproj = 3;
    pref.solver.maxneighbors = 5;
    pref.solver.maxvotes = 10;
    pref.solver.mingroup = 3;
    pref.solver.maxgroup = 5;
    pref.solver.time_discount = 85;
    
    %other
%     if writedir== 0
%         pref.writedir = cd;
%     else
%         pref.writedir = writedir;
%     end
    save('preferences.mat', 'pref');
    
    %save preferences to selected directory
%     if status == 0
%         save([pref.writedir,filesep,'preferences.mat'], 'pref');
%     elseif status == 1
%         msgbox('Unable to save to file. Please verify that the directory you selected does not require elevated permissions to write. Use the "Write Directory" preference menu to select a non-write restricted directory before closing this application.');
%     else
%         msgbox('No write directory selected. Please select a valid directory using "Edit > Preferences > Write Directory" before closing this application.');
%     end
end

%Set appdata
quickset('pref', pref);
end