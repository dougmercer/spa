function varargout = project_menu(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @project_menu_OutputFcn, ...
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


function project_menu_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

projects=quickget('projects');
%convert from struct to cell array
natt=length(projects);
tabledata=cell(natt,9);
for i=1:natt
    if isfield(projects, 'id')
        tabledata{i, 1} = projects(i).id;
    else
        tabledata{i, 1} = i; %DGM - REMOVETHIS later. Hack to use old art data
    end
    tabledata{i, 2} = projects(i).title;
    tabledata{i, 3} = projects(i).sponsor;
    [~, tabledata{i, 4}] = verify_list(projects(i).section, 'sections');
    [~, tabledata{i, 5}] = verify_list(projects(i).majors, 'majors');
    tabledata{i, 6} = projects(i).nda;
    tabledata{i, 7} = projects(i).ipa;
    tabledata{i, 8} = projects(i).lb;
    tabledata{i, 9} = projects(i).ub;
end
set(handles.projecttable, 'Data', tabledata); 

%hide launcher
if isfield(getappdata(0), 'launcherhandle')
    launcherhandle=getappdata(0, 'launcherhandle');
    set(launcherhandle,'Visible', 'off');
end

%center figure in middle of screen
center_fig(handles.project_fig);


% --- Outputs from this function are returned to the command line.
function varargout = project_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function project_menu_CloseRequestFcn(hObject, eventdata, handles)
majorbounds_handle = findobj('type','figure','name','majorbounds');
if ~isempty(majorbounds_handle)
    close(majorbounds_handle);
end
if length(getappdata(0,'table_indices'))==2
    rmappdata(0,'table_indices');
end
if isfield(getappdata(0),'projecttable')
    rmappdata(0,'projecttable');
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
delete(hObject);



% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveexit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveexit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_projects(handles);
%close figure
if ~isempty(quickget('missingh'))   %what is this? Does this even apply to projects menu?
    close(quickget('missingh'));
end
project_menu_CloseRequestFcn(handles.project_fig, [], handles);



% --- Executes when selected cell(s) is changed in att_table.
function projecttable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to att_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'table_indices',eventdata.Indices);


% --------------------------------------------------------------------
function launch_missing_Callback(hObject, eventdata, handles)
% hObject    handle to launch_missing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quickset('table',handles.projecttable);
run missing_menu.m


% --------------------------------------------------------------------
function edit_placeholder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_placeholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function set_lbs_Callback(hObject, eventdata, handles)
% hObject    handle to set_lbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledata = get(handles.projecttable, 'data');
[m, n] = size(tabledata);
defaultmin = quickget('pref', 'solver', 'mingroup');
for i = 1:m
    tabledata{i, n - 1} = defaultmin;
end
set(handles.projecttable, 'data', tabledata);


% --------------------------------------------------------------------
function set_ubs_Callback(hObject, eventdata, handles)
% hObject    handle to set_ubs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledata = get(handles.projecttable, 'data');
[m, n] = size(tabledata);
defaultmax = quickget('pref', 'solver', 'maxgroup');
for i = 1:m
    tabledata{i, n} = defaultmax;
end
set(handles.projecttable, 'data', tabledata);


% --- Executes when entered data in editable cell(s) in projecttable.
function projecttable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to projecttable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(quickget('missingh'))
    if eventdata.Indices(2) == 4 || eventdata.Indices(2) == 5
        mhandles = quickget('missinghandles');
        table = quickget('table');
        [secdat, majdat] = refreshlist(get(table, 'Data'), 'projects');
        set(mhandles.sec_tab, 'Data', secdat);
        set(mhandles.maj_tab, 'Data', majdat);
    end
end


% --------------------------------------------------------------------
function open_pref_Callback(hObject, eventdata, handles)
% hObject    handle to open_pref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run pref_menu.m;


% --------------------------------------------------------------------
function add_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to add_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(getappdata(0),'ProjUneditable') %ProjUneditable created and deleted in majorbounds
    append_row(handles,'projecttable',{[],char,char,char,char,true,true,[],[]});
else
    msgbox('Cannot add row while major bounds menu is open.');
end



% --------------------------------------------------------------------
function delete_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to delete_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(getappdata(0),'ProjUneditable') %ProjUneditable created and deleted in majorbounds
    delete_row(handles, 'projecttable');
else
    msgbox('Cannot delete row while major bounds menu is open.');
end


% --------------------------------------------------------------------
function toggle_edit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(getappdata(0),'ProjUneditable') %ProjUneditable created and deleted in majorbounds
    toggle_edit(handles,'projecttable',false(1,9));
else
    msgbox('Cannot enter edit mode while major bounds menu is open.');
end


% --- Executes on button press in majorboundpress.
function majorboundpress_Callback(hObject, eventdata, handles)
% hObject    handle to majorboundpress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_projects(handles);

%launch major bound menu
run majorbounds.m

function save_projects(handles)
old_projects = quickget('projects');
pids = zeros(1, length(old_projects));
for i = 1:length(old_projects)
    if isfield(old_projects,'id')
        pids(i) = old_projects(i).id;
    else
        pids(i) = i;
    end
end
data=get(handles.projecttable,'Data');
[a,~]=size(data);
%convert cell array to struct array
for i=1:a
    %begin save stuff from uitable
    pid = data{i, 1};
    projects(i).id = pid;
    projects(i).title=data{i,2};
    projects(i).sponsor=data{i,3};
    %begin sections
    sections=str2cell(data{i,4});
    [projects(i).section,data{i,4}]=verify_list(sections,'sections');
    %end sections
    %begin majors
    majors=str2cell(data{i,5});
    [projects(i).majors,data{i,5}]=verify_list(majors,'majors');
    %end majors
    projects(i).majors=majors;    
    projects(i).nda=data{i,6};
    projects(i).ipa=data{i,7};
    projects(i).lb=data{i,8};
    projects(i).ub=data{i,9};
    %end saving stuff from uitable
    %still need to grab majbounds information
    pid = find(pids == pid, 1, 'first');
    projects(i).majbounds = old_projects(pid).majbounds; %must use pid
end

%update projects in app data
quickset('projects',projects);

