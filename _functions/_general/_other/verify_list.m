function [ cellstr, str ] = verify_list( cellstr, type )
    for j = 1:length(cellstr)
        cellstr{j} = findTag(cellstr{j}, type); %correct aliases, if possible
    end
    str = strjoin(cellstr, ',');
    %str = mystrjoin(cellstr, ',');
end

