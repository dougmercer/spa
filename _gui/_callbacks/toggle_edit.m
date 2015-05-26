% handles      structure with handles and user data (see GUIDATA)
% tablename    table stored in hanldes
% fixed_column column in the table to be edited 
function [  ] = toggle_edit( handles, tablename, fixed_columns )
if ~all(get(handles.(tablename),'ColumnEditable'))
    set(handles.(tablename),'ColumnEditable',true(1,length(fixed_columns))&~fixed_columns);
else
    set(handles.(tablename),'ColumnEditable',false(1,length(fixed_columns))&~fixed_columns);
end
end

