function varargout = missing_menu(varargin)
% MISSING_MENU MATLAB code for missing_menu.fig
%      MISSING_MENU, by itself, creates a new MISSING_MENU or raises the existing
%      singleton*.
%
%      H = MISSING_MENU returns the handle to a new MISSING_MENU or the handle to
%      the existing singleton*.
%
%      MISSING_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MISSING_MENU.M with the given input arguments.
%
%      MISSING_MENU('Property','Value',...) creates a new MISSING_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before missing_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to missing_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help missing_menu

% Last Modified by GUIDE v2.5 11-Jan-2014 13:35:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @missing_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @missing_menu_OutputFcn, ...
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


% --- Executes just before missing_menu is made visible.
function missing_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to missing_menu (see VARARGIN)

% Choose default command line output for missing_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes missing_menu wait for user response (see UIRESUME)
% uiwait(handles.missing_fig);
refresh_list_Callback(handles.refresh_list, [], handles)
quickset('missingh',handles.missing_fig);
quickset('missinghandles',handles);



% --- Outputs from this function are returned to the command line.
function varargout = missing_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close missing_fig.
function missing_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to missing_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isfield(getappdata(0),'missingh')
    rmappdata(0,'missingh');
end
if isfield(getappdata(0),'missinghandles')
    rmappdata(0,'missinghandles');
end
delete(hObject);


% --------------------------------------------------------------------
function refresh_list_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table=quickget('table');
if strcmp(get(table,'Tag'),'projecttable')
    type='projects';
else
    type='students';
end
[secdat, majdat]=refreshlist(get(table,'Data'),type);
set(handles.sec_tab,'Data',secdat);
set(handles.maj_tab,'Data',majdat);


% --------------------------------------------------------------------
function edit_placeholder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_placeholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edit_sec_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run section_menu.m;

% --------------------------------------------------------------------
function edit_maj_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run major_menu.m;

% --------------------------------------------------------------------
function show_majors_Callback(hObject, eventdata, handles)
% hObject    handle to show_majors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh_list_Callback(handles.refresh_list, [], handles)
cellstr=quickget('missingMajors_inds');
if isempty(cellstr)
    msgbox('No invalid major indicies.');
else
    msgbox(cellstr{1});
end

% --------------------------------------------------------------------
function show_sections_Callback(hObject, eventdata, handles)
% hObject    handle to show_sections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh_list_Callback(handles.refresh_list, [], handles)
cellstr=quickget('missingSections_inds');
if isempty(cellstr)
    msgbox('No invalid section indicies.');
else
    msgbox(cellstr{1});
end

% --------------------------------------------------------------------
function show_placeholder_Callback(hObject, eventdata, handles)
% hObject    handle to show_placeholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
