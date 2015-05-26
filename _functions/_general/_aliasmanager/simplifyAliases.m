function [ aliases ] = simplifyAliases( aliases )
if ischar(aliases)
    aliases = str2cell(aliases);
end
%set to lower case and remove spaces
for i=1:length(aliases)
    aliases{i} = lower(aliases{i}(aliases{i} ~= ' '));
end
%remove duplicates
aliases = unique(aliases);
end

