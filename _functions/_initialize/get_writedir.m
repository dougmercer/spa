function [ writedir, status ] = get_writedir( )
uiwait(msgbox({'Please select the current or future directory in which you''d like SPA to store its output data.','This directory should *not* require administrator/super user write privileges.'}, 'Select Write Directory'));
writedir = uigetdir();
if writedir == 0
    status = 2;
    return
end
try
    test = 1;
    save([writedir,filesep,'test.mat'], 'test');
    delete([writedir,filesep,'test.mat']);
    status = 0;
catch
    status = 1;
end
end

