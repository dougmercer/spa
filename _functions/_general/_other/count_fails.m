function [ tabledata ] = count_fails( fail_list )
tabledata=cell(0,0);
u=unique(fail_list);
i=1;
for str=u'
    tabledata{i,1}=str{1};
    tabledata{i,2}=sum(strcmp(str{1},fail_list));
    i=i+1;
end
end

