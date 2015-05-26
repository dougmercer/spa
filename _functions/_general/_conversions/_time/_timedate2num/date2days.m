function [ days ] = date2days( date )
date=strsplit(date, '/');
%date = mystrsplit(date, '/');
numdate = zeros(1, 3);
for i = 1:3
    numdate(i) = str2double(date{i});
    %numdate(i) = str2doubleq(date{i});
end
days = datenum(numdate(3), numdate(1), numdate(2));
end

