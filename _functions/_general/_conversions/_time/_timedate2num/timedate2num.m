function [ num ] = timedate2num( time, date )
days=date2days(date);
num=days+time2num(time);
end

