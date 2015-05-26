function varargout = major_menu(varargin)
% MAJOR_MENU MATLAB code for major_menu.fig
%      MAJOR_MENU, by itself, creates a new MAJOR_MENU or raises the existing
%      singleton*.
%
%      H = MAJOR_MENU returns the handle to a new MAJOR_MENU or the handle to
%      the existing singleton*.
%
%      MAJOR_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAJOR_MENU.M with the given input arguments.
%
%      MAJOR_MENU('Property','Value',...) creates a new MAJOR_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before major_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to major_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help major_menu

% Last Modified by GUIDE v2.5 17-Feb-2014 13:16:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @major_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @major_menu_OutputFcn, ...
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


% --- Executes just before major_menu is made visible.
function major_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to major_menu (see VARARGIN)

% Choose default command line output for major_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isfield(getappdata(0),'majors')
    majors = quickget('majors'); %migrated
    %convert from struct to cell array
    attributes = fieldnames(majors);
    nprojects = length(attributes);
    tabledata = cell(nprojects, 2);
    for i = 1:nprojects
        tabledata{i, 1} = attributes{i};
        str = char;
        for j = 1:length(majors.(attributes{i}).aliases)
            str = [majors.(attributes{i}).aliases{j}, ',', str];
        end
        tabledata{i, 2} = str(1:length(str) - 1);%grab all but last comma and store in cell
    end
set(handles.majtable, 'Data', tabledata);
end

%hide launcher
if isfield(getappdata(0), 'launcherhandle')
    launcherhandle=getappdata(0, 'launcherhandle');
    set(launcherhandle, 'Visible', 'off');
end

%center figure in middle of screen
center_fig(handles.major_fig);


% UIWAIT makes major_menu wait for user response (see UIRESUME)
% uiwait(handles.major_fig);


% --- Outputs from this function are returned to the command line.
function varargout = major_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close major_fig.
function major_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to major_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if length(getappdata(0,'table_indices'))==2
    rmappdata(0,'table_indices');
end
set(getappdata(0,'launcherhandle'),'Visible','on');
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
data = get(handles.majtable, 'Data');
[nmajors, ~] = size(data);
for i = 1:nmajors
    if ~isvarname(data{i, 1})    %check if the tag would be a valid fieldname
        str = sprintf('The tag for %d would not produce a valid variable name in MATLAB. Enter a tag that would return "true" for isvarname(tag).',i);
        msgbox(str);
        return
    end
end

%convert cell array to struct array
for i = 1:nmajors
    majors.(data{i, 1}).number = i;
    majors.(data{i, 1}).aliases = simplifyAliases(strsplit(data{i, 2}, ','));
end

%update pref in app data
quickset('majors', majors);

%close figure
major_fig_CloseRequestFcn(handles.major_fig, [], handles)

% --------------------------------------------------------------------
function delete_menu_Callback(hObject, eventdata, handles)
% hObject    handle to delete_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table_indices=getappdata(0,'table_indices');
if numel(table_indices)>2
    msgbox('Select a single cell to insert row.');
elseif numel(table_indices) == 2
    x = table_indices(1);
    data = get(handles.majtable, 'Data');
    data(x,:) = [];
    set(handles.majtable,'Data', data);
end

% --- Executes when selected cell(s) is changed in att_table.
function majtable_CellSelectionCallback(hObject, eventdata, handles)
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
append_row(handles, 'majtable', {char,char});


% --------------------------------------------------------------------
function delete_row_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to delete_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%FIX ME: I think we need to remove the correspond entry in each project's
%majbounds. I just don't have time to do this now...
% table_indices = quickget('table_indices');
% if numel(table_indices)==2
%     projects = quickget('projects');
%     data = get(handles.majtable, 'Data');
%     majname = data{table_indices(1), table_indices(2)};
%     if isfield(projects.majbounds, majname)
%         for i = 1:length(projects)
%         projects.majbounds = rmfield(projects.majbounds, majname);
%         quickset('projects', projects);
%     end
% end
delete_row(handles, 'majtable');


% --------------------------------------------------------------------
function toggle_edit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggle_edit(handles, 'majtable', false(1, 2))
