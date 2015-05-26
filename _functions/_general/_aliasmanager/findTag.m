function [tag, flag]=findTag(attribute, type)
%migrated
tags=quickget(type);    
for tag=fieldnames(tags)'
    if ~all(~strcmpi(attribute,tags.(tag{1}).aliases))
        tag=tag{1};
        flag=false; %did not fail to find match
        return
    end
end
if isa(attribute,'cell');
    tag=attribute{1};
elseif isa(attribute,'char');
    tag=attribute;
else
    tag=char;
end
flag=true; %failed to find match
end

