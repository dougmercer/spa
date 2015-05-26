function [ num ] = time2num( time )
%Note: 12:00:00 AM -> 0 (not 1)
hms_str=regexp(time,'([0-9]+):([0-9]{2}):([0-9]{2})','tokens','once');
hms=zeros(1,3);
for i=1:3
    %hms(i)=str2double(hms_str{i});
    hms(i)=str2doubleq(hms_str{i});
end
if hms(1)==12
    hms(1)=0;
end
if strfind(time, 'PM')
	hms(1)=hms(1)+12;
end
num=hms(1)/24+hms(2)/(24*60)+hms(3)/(24*60*60);
end

