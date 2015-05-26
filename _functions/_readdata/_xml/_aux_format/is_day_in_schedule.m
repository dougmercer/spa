function [ index ] = is_day_in_schedule( day, schedule )
% output is -1 if day isn't in the schedule
nScheduleDays = length(schedule.day);
for i=1:nScheduleDays
    exist = ismember(lower(schedule.day(i).val), lower(day));
    % now we must check to see if this day conflicts the student schedule
    index = find(exist, 1);
    if (isempty(index))
        index = -1;
    else
        % we have a match, get the index and end the loop
        index = i;
        break;
    end
end
end

