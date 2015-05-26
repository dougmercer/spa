function varargout = potential_menu(varargin)
% potential_menu MATLAB code for potential_menu.fig
%      potential_menu, by itself, creates a new potential_menu or raises the existing
%      singleton*.
%
%      H = potential_menu returns the handle to a new potential_menu or the handle to
%      the existing singleton*.
%
%      potential_menu('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in potential_menu.M with the given input arguments.
%
%      potential_menu('Property','Value',...) creates a new potential_menu or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before potential_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to potential_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help potential_menu

% Last Modified by GUIDE v2.5 21-Jan-2014 19:01:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @potential_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @potential_menu_OutputFcn, ...
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


% --- Executes just before potential_menu is made visible.
function potential_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to potential_menu (see VARARGIN)

% Choose default command line output for potential_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes potential_menu wait for user response (see UIRESUME)
% uiwait(handles.potential_fig);
refresh_list_Callback(handles.refresh_list, [], handles)
quickset('potential_h',handles.potential_fig);
quickset('potential_handles',handles);


% --- Outputs from this function are returned to the command line.
function varargout = potential_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close potential_fig.
function potential_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to potential_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isfield(getappdata(0),'potential_h')
    rmappdata(0,'potential_h');
end
if isfield(getappdata(0),'potential_handles')
    rmappdata(0,'potential_handles');
end
delete(hObject);


% --------------------------------------------------------------------
function refresh_list_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%magic number. need to move to a preference menu somewhere
at_risk_feas_count = 3; 

ps=get(quickget('launcherhandles','project_status'),'BackgroundColor');
if ~(ps(1) == 0 && ps(2) == 1 && ps(3) == 0)
    msgbox('Load and confirm project table before counting potential student-project matches.');
    return
end
students = quickget('students');
matches = zeros(length(students),2);
k = 0;
%cut off exclude students who are well covered by project set
for i = 1:length(students)
    num_feas = sum(isfeasmatch(i));
    if num_feas <= at_risk_feas_count
        k = k+1;
        matches(k, 1) = students(i).id;
        matches(k, 2) = sum(isfeasmatch(i));
    end
end
matches = matches(1:k, :);
set(handles.potential_table, 'Data', matches)


% --------------------------------------------------------------------
function open_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to open_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%I guess I never wrote this?
