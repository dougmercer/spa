function [ bool ] = randbool( )
%RANDBOOL Summary of this function goes here
%   Detailed explanation goes here
blah = [true, false];
bool = blah(randi(2));
end

