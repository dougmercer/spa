function [ ] = spa( varargin )
%MWSTOOL Summary of this function goes here
%   Detailed explanation goes here
if myisrunning('spa')
    msgbox('An instance of spa.exe is already running. If you still wish to open a new instance of spa.exe, please terminate this process and run spa.exe once again.');
    return
end
run launcher.m;
end