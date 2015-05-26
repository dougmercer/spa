function varargout = student_menu(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @student_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @student_menu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function student_menu_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isfield(getappdata(0), 'students')
    students = quickget('students');
    %convert from struct to cell array
    nstudents = length(students);
    tabledata = cell(nstudents, 10);
    for i = 1:nstudents
        tabledata{i, 1} = students(i).id;
        tabledata{i, 2} = students(i).first;
        tabledata{i, 3} = students(i).last;
        tabledata{i, 4} = students(i).access;
        [~, tabledata{i, 5}] = verify_list(students(i).majors, 'majors');
        tabledata{i, 6} = students(i).intent;
        tabledata{i, 7} = students(i).nda;
        tabledata{i, 8} = students(i).ipa;
        [~, tabledata{i, 9}] = verify_list(students(i).sections, 'sections');
        %begin preferences
        str = char;
        for j = 1:length(students(i).preferences)
            str = [str, ',', num2str(students(i).preferences(j))];
        end
        tabledata{i, 10} = str(2:length(str));%grab all but first comma
        %end preferences
        tabledata{i, 11} = num2timedate(students(i).time);%convert from numtime to displaytime
    end
    set(handles.studenttable, 'Data', tabledata);
end

%hide launcher
if isfield(getappdata(0), 'launcherhandle')
    launcherhandle = getappdata(0, 'launcherhandle');
    set(launcherhandle, 'Visible', 'off');
end

%center figure in middle of screen
center_fig(handles.student_fig);


% --- Outputs from this function are returned to the command line.
function varargout = student_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function student_menu_fig_CloseRequestFcn(hObject, eventdata, handles)
if length(getappdata(0,'table_indices'))==2
    rmappdata(0,'table_indices');
end
if isfield(getappdata(0),'missingMajors')
    rmappdata(0,'missingMajors');
end
if isfield(getappdata(0),'missingSections')
    rmappdata(0,'missingSections');
end
set(getappdata(0,'launcherhandle'),'Visible','on');
if isfield(getappdata(0),'msgboxhandle')
    figure(quickget('msgboxhandle'));
    rmappdata(0,'msgboxhandle');
end
if ~isempty(quickget('missingh'))
    close(quickget('missingh'));
end
delete(hObject);


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = 1;


% --------------------------------------------------------------------
function saveexit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveexit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.studenttable, 'Data');
[nstudents, ~] = size(data);
%convert cell array to struct array
for i=1:nstudents
    students(i).id = data{i,1};
    students(i).first = data{i,2};
    students(i).last = data{i,3};
    students(i).access = data{i,4};
    %begin majors
    majors = str2cell(data{i, 5});
    [students(i).majors, ~] = verify_list(majors, 'majors');
    %end majors
    students(i).intent = data{i, 6};
    students(i).nda = data{i, 7};
    students(i).ipa = data{i, 8};
    %begin sections
    sections = str2cell(data{i, 9});
    [students(i).sections, ~] = verify_list(sections, 'sections');
    %end sections
    %begin preferences
    temp = str2cell(data{i, 10});
    temp2 = zeros(1, length(temp));
    for j = 1:length(temp)
        temp2(1, j) = str2double(temp{1, j});
        %temp2(1, j) = str2doubleq(temp{1, j});
    end
    students(i).preferences = temp2;
    %end preferences
    datetime = strsplit(data{i, 11});
    %datetime=mystrsplit(data{i, 11}, ' ');
    students(i).time = timedate2num(datetime{2}, datetime{1});
end

%update students in app data
quickset('students', students);

%change color/text of student indicator on launcher
[sec, maj] = refreshlist(data,'students');
if ~(isempty(sec) && isempty(maj)) %if both missing tables are empty, then project list is OK
    if isempty(sec)
        h = msgbox(sprintf('There are %d major tags that are still invalid. You''ll need to correct these tags before solving the problem.', sum(cell2mat(maj(:,2)))));
    elseif isempty(maj)
        h = msgbox(sprintf('There are %d section tags that are still invalid. You''ll need to correct these tags before solving the problem.', sum(cell2mat(sec(:,2)))));
    else
        h = msgbox(sprintf('There are %d section tags and %d major tags that are still invalid. You''ll need to correct these tags before solving the problem.', sum(cell2mat(sec(:,2))),sum(cell2mat(maj(:,2)))));
    end
    quickset('msgboxhandle',h);
end
%close figure
student_fig_CloseRequestFcn(handles.student_fig, [], handles)


% --- Executes when selected cell(s) is changed in att_table.
function studenttable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to att_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
setappdata(0, 'table_indices', eventdata.Indices);


% --------------------------------------------------------------------
function launch_missing_Callback(hObject, eventdata, handles)
% hObject    handle to launch_missing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quickset('table', handles.studenttable);
run missing_menu.m;


% --- Executes when entered data in editable cell(s) in studenttable.
function studenttable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to studenttable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(quickget('missingh'))
    if eventdata.Indices(2) == 5 || eventdata.Indices(2) == 8
        mhandles = quickget('missinghandles');
        table = quickget('table');
        [secdat, majdat] = refreshlist(get(table, 'Data'), 'students');
        set(mhandles.sec_tab, 'Data', secdat);
        set(mhandles.maj_tab, 'Data', majdat);
    end
end


% --------------------------------------------------------------------
function debug_placeholder_Callback(hObject, eventdata, handles)
% hObject    handle to debug_placeholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function count_students_Callback(hObject, eventdata, handles)
% hObject    handle to count_students (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ps = get(quickget('launcherhandles', 'project_status'), 'Background');
if ~(ps(1) == 0 && ps(2) == 1 && ps(3) == 0)
    msgbox('Load/confirm project table before counting student-project potential matches.');
    return
else
    run potential_menu.m
end


% --------------------------------------------------------------------
function add_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to add_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
append_row(handles, 'studenttable', {[], char, char, char, char, false, ...
                                     false, false, char, char, []});


% --------------------------------------------------------------------
function delete_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to delete_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete_row(handles, 'studenttable');


% --------------------------------------------------------------------
function toggle_edit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggle_edit(handles, 'studenttable', false(1, 11))


% --- Executes when user attempts to close student_fig.
function student_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to student_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if length(getappdata(0, 'table_indices')) == 2
    rmappdata(0, 'table_indices');
end
if isfield(getappdata(0), 'missingMajors')
    rmappdata(0, 'missingMajors');
end
if isfield(getappdata(0), 'missingSections')
    rmappdata(0, 'missingSections');
end
set(getappdata(0, 'launcherhandle'), 'Visible', 'on');
if isfield(getappdata(0), 'msgboxhandle')
    try %FIXME?
        figure(quickget('msgboxhandle'));
        rmappdata(0, 'msgboxhandle');
    catch
        rmappdata(0, 'msgboxhandle');
    end
end
if ~isempty(quickget('missingh'))
    close(quickget('missingh'));
end
delete(hObject);
