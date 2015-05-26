function [ itIsRunning ] = myisrunning( str )
myTask = [str,'.exe'];
commandLine = sprintf('tasklist /FI "IMAGENAME eq %s"', myTask);
[~, result]= system(commandLine);
itIsRunning = length(strfind(lower(result), lower(myTask)))>1; %QUICKFIX: Since a deployed MWS application detects itself, we are looking for 2 or more entries in this list.
end