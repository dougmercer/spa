function [ indices ] = kmax( ourArray, k )
%add check, length(ourArray)>=k
indices=[];
oA=ourArray;
while length(indices)<k
    value=max(oA);
    I=find(oA==value);
    if length(I)+length(indices)<=k
        indices=cat(2,indices,I);
        oA(I)=NaN;
    else
        while length(indices)<k
            indices=cat(2,indices,I(1));
            oA(I(1))=NaN;
            I(1)=[];
        end
    end
end
end

