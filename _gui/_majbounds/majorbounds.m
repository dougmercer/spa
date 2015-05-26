function varargout = majorbounds(varargin)
% MAJORBOUNDS MATLAB code for majorbounds.fig
%      MAJORBOUNDS, by itself, creates a new MAJORBOUNDS or raises the existing
%      singleton*.
%
%      H = MAJORBOUNDS returns the handle to a new MAJORBOUNDS or the handle to
%      the existing singleton*.
%
%      MAJORBOUNDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAJORBOUNDS.M with the given input arguments.
%
%      MAJORBOUNDS('Property','Value',...) creates a new MAJORBOUNDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before majorbounds_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to majorbounds_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help majorbounds

% Last Modified by GUIDE v2.5 10-Dec-2014 21:16:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @majorbounds_OpeningFcn, ...
                   'gui_OutputFcn',  @majorbounds_OutputFcn, ...
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


% --- Executes just before majorbounds is made visible.
function majorbounds_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to majorbounds (see VARARGIN)

% Choose default command line output for majorbounds
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes majorbounds wait for user response (see UIRESUME)
% uiwait(handles.majorbounds_fig);

quickset('ProjUneditable', '1') %creation of variable to prevent adding/deleteing rows in project menu while majorbounds is open

%get app data
majors = quickget('majors');
projects=quickget('projects');

majnames=fieldnames(majors); %get fieldnames (major names)
cnames=cell(1,2*length(majnames)); %initialize our cell array of column names
k = 1;
for maj=majnames' %for each major in majors
    cnames{k} = sprintf('%s LB',maj{1});      %major LB
    cnames{k + 1} = sprintf('%s UB',maj{1});  %major UB
    k = k+2;
end
cnames = [{'Project ID'}, cnames];   %append project ID column to beginning
t = uitable(hObject,'ColumnName', cnames,'tag','majorsboundstable');    %create UItable
handles.majorboundstable = t;
guidata(hObject, handles);
set(t, 'Units', 'normalized');      %switch units to normalized
set(t,'Position', [.0000001, .0000001, 0.999999, .92]);
set(t, 'Units', 'pixels');           %switch units back to pixels
cwidth = cell(1, length(cnames) +1); %initialize cwidth cell array
cwidth{1} = 'auto';                  %set first column width to auto
for k = 1:length(cnames)
    cwidth{k+1} = 70;                %set each column besides first to 70px
end
set(t, 'ColumnWidth', cwidth);        %set columnwidth attribute
set(t, 'Units', 'normalized');        %set units to normalized so it resizes

nprojects=length(projects);
tabledata=cell(nprojects,1+2*length(majors));
for i=1:nprojects
    tabledata{i,1} = projects(i).title; % list project titles
    k = 0; %counter for shifting columns by major
	for maj= majnames'
        tabledata{i, 2 + 2*k}=projects(i).majbounds.(maj{1}).lb;
        tabledata{i, 3 + 2*k}=projects(i).majbounds.(maj{1}).ub;
        k = k+1;
	end
end
%hide launcher
if isfield(getappdata(0),'launcherhandle')
    launcherhandle=getappdata(0,'launcherhandle');
    set(launcherhandle,'Visible','off');
end

set(handles.majorboundstable,'Data',tabledata);         %add the uitable handle to handles
guidata(hObject, handles);            %add the uitable handle to handles

%center figure in window
center_fig(handles.majorbounds);





% --- Outputs from this function are returned to the command line.
function varargout = majorbounds_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function toggle_edit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmaj = length(fieldnames(quickget('majors')));
nmajcols = 2*nmaj;
toggle_edit(handles, 'majorboundstable', [true, false(1, nmajcols)])


% --- Executes when user attempts to close majorbounds_fig.
function majorbounds_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to majorbounds_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isfield(getappdata(0), 'ProjUneditable');
    rmappdata(0,'ProjUneditable'); %deletion of variable to prevent adding/deleteing rows in project menu while majorbounds is open
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
data = get(handles.majorboundstable, 'Data');
[nprojects, ~] = size(data);

%convert cell array to struct array
projects = quickget('projects');
majors = quickget('majors');
majnames = fieldnames(majors);
if nprojects ~= 0
    for i = 1:nprojects
        %begin save stuff from uitable
        k = 1; %counter for shifting columns by major
        for maj = majnames'
            projects(i).majbounds.(maj{1}).lb = data{i, 2*k};
            projects(i).majbounds.(maj{1}).ub = data{i, 1 + 2*k};
            k = k+1;
        end
    end
    %update majorbounds in app data
    quickset('projects', projects);
else
    msgbox('Empty table detected. Data cannot be confirmed at this time.');
end

%delete variable preventing adding/deleteing rows in project menu while majorbounds is open
if isfield(getappdata(0), 'ProjUneditable');
    rmappdata(0,'ProjUneditable'); 
end

%close figure
majorbounds_CloseRequestFcn(handles.majorbounds, [], handles);
