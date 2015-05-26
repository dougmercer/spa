function [ bool ] = myismember( a, b )
bool = false(1, length(a));
for i = 1:length(a)
    bool(i) = any(strcmp(a{i}, b));
end
