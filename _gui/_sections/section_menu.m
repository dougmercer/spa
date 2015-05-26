function varargout = section_menu(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @section_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @section_menu_OutputFcn, ...
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


function section_menu_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isfield(getappdata(0), 'sections')
    s = quickget('sections');
    %convert from struct to cell array
    secnames = fieldnames(s);
    nsections = length(secnames);
    tabledata = cell(nsections, 2);
    for i = 1:nsections
        tabledata{i, 1} = secnames{i};
        str = char;
        for j = 1:length(s.(secnames{i}).aliases)
            str = [s.(secnames{i}).aliases{j}, ',', str]; %for comma delimited list
        end
        tabledata{i, 2} = str(1:length(str) - 1);%grab all but last comma and store in cell
    end
set(handles.sectable, 'Data', tabledata);
end

%hide launcher
if isfield(getappdata(0), 'launcherhandle')
    launcherhandle = getappdata(0, 'launcherhandle');
    set(launcherhandle, 'Visible', 'off');
end

%center figure in middle of screen
center_fig(handles.sec_fig);



% --- Outputs from this function are returned to the command line.
function varargout = section_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function sec_fig_CloseRequestFcn(hObject, eventdata, handles)
if length(getappdata(0, 'table_indices')) == 2
    rmappdata(0, 'table_indices');
end
set(getappdata(0, 'launcherhandle'), 'Visible', 'on');
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
data = get(handles.sectable,'Data');
[nsections, ~] = size(data);
for i = 1:nsections
    if ~isvarname(data{i, 1})    %check if the tag would be a valid fieldname
        str = sprintf('The tag for %d would not produce a valid variable name in MATLAB. Enter a tag that would return "true" for isvarname(tag).',i);
        msgbox(str);
        return
    end
end

%convert cell array to struct array
for i = 1:nsections
    sections.(data{i, 1}).aliases = simplifyAliases(strsplit(data{i, 2}, ','));
end

%update pref in app data
quickset('sections', sections);

%close figure
sec_fig_CloseRequestFcn(handles.sec_fig, [], handles)


% --- Executes when selected cell(s) is changed in att_table.
function sectable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to att_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
setappdata(0, 'table_indices', eventdata.Indices);


% --------------------------------------------------------------------
function add_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to add_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
append_row(handles, 'sectable', {char, char});


% --------------------------------------------------------------------
function delete_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to delete_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete_row(handles, 'sectable');


% --------------------------------------------------------------------
function toggle_edit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggle_edit(handles, 'sectable', false(1, 2))
