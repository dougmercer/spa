function [ ] = delete_row(handles, tablename)
% if ~isfield(getappdata(0),'dontdeletestuff')
table_indices=getappdata(0,'table_indices');
if numel(table_indices)>2
    msgbox('Select a single cell to insert row.');
elseif numel(table_indices)==2
    x=table_indices(1);
    data=get(handles.(tablename),'Data');
    data(x,:)=[];
    set(handles.(tablename),'Data',data);
end
%end note: do the same for append row
end

