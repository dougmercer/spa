function [ str ] = num2timedate( num )
%NUM2TIMEDATE Converts num into str of form mm/dd/yyyy hh:mm:ss
%   Detailed explanation goes here
date=datestr(floor(num),'mm/dd/yyyy');
str=[date,' ',num2time(num-floor(num))];
end

