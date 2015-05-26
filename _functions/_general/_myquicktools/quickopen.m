function [  ] = quickopen( files )
for file=files
    edit(file{:})
end
end

