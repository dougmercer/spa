function []=append_row(handles, tablename, blankrow)
% hObject    handle to insert_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.(tablename), 'Data');
[a, ~] = size(data);
if a == 0
    data = blankrow;
    set(handles.(tablename), 'Data', data);
else
    table_indices = getappdata(0, 'table_indices');
    if numel(table_indices)>2
        msgbox('Select a single cell to insert row.');
    elseif numel(table_indices) == 2
        x = table_indices(1);
        data = [data(1:x - 1, :); blankrow; data(x:a, :)];
        set(handles.(tablename), 'Data', data);
    else
        data = [data; blankrow];
        set(handles.(tablename), 'Data', data);
    end
end
end
