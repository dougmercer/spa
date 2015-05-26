function varargout = pref_menu(varargin)
% PREF_MENU MATLAB code for pref_menu.fig
%      PREF_MENU, by itself, creates a new PREF_MENU or raises the existing
%      singleton*.
%
%      H = PREF_MENU returns the handle to a new PREF_MENU or the handle to
%      the existing singleton*.
%
%      PREF_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREF_MENU.M with the given input arguments.
%
%      PREF_MENU('Property','Value',...) creates a new PREF_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pref_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pref_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pref_menu

% Last Modified by GUIDE v2.5 17-Feb-2014 14:00:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pref_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @pref_menu_OutputFcn, ...
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


% --- Executes just before pref_menu is made visible.
function pref_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pref_menu (see VARARGIN)

% Choose default command line output for pref_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isstruct(quickget('pref','solver','mingroup'))
    set(handles.defmin_val,'String',num2str(3));
else
    set(handles.defmin_val,'String',num2str(quickget('pref','solver','mingroup')));
end
if isstruct(quickget('pref','solver','maxgroup'))
    set(handles.defmax_val,num2str(5));
else
    set(handles.defmax_val,'String',num2str(quickget('pref','solver','maxgroup')));
end
if isstruct(quickget('pref','solver','maxvotes'))
    set(handles.maxvotes_val,'String',num2str(10));
else
    set(handles.maxvotes_val,'String',num2str(quickget('pref','solver','maxvotes')));
end
if isstruct(quickget('pref','solver','minmatchproj'))
    set(handles.minmatchproj_val,'String',num2str(3));
else
    set(handles.minmatchproj_val,'String',num2str(quickget('pref','solver','minmatchproj')));
end
if isstruct(quickget('pref','solver','maxneighbors'))
    set(handles.maxneighbors_val,'String',num2str(5));
else
    set(handles.maxneighbors_val,'String',num2str(quickget('pref','solver','maxneighbors')));
end
if isstruct(quickget('pref','solver','time_discount'))
    set(handles.time_discount_val,'String',num2str(85));
else
    set(handles.time_discount_val,'String',num2str(quickget('pref','solver','time_discount')));
end

%center figure in middle of screen
center_fig(handles.prefmenu);

% UIWAIT makes pref_menu wait for user response (see UIRESUME)
% uiwait(handles.prefmenu);


% --- Outputs from this function are returned to the command line.
function varargout = pref_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function defmin_val_Callback(hObject, eventdata, handles)
% hObject    handle to defmin_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of defmin_val as text
%        str2double(get(hObject,'String')) returns contents of defmin_val as a double


% --- Executes during object creation, after setting all properties.
function defmin_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defmin_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function defmax_val_Callback(hObject, eventdata, handles)
% hObject    handle to defmax_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of defmax_val as text
%        str2double(get(hObject,'String')) returns contents of defmax_val as a double


% --- Executes during object creation, after setting all properties.
function defmax_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defmax_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minmatchproj_val_Callback(hObject, eventdata, handles)
% hObject    handle to minmatchproj_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minmatchproj_val as text
%        str2double(get(hObject,'String')) returns contents of minmatchproj_val as a double


% --- Executes during object creation, after setting all properties.
function minmatchproj_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minmatchproj_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxneighbors_val_Callback(hObject, eventdata, handles)
% hObject    handle to maxneighbors_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxneighbors_val as text
%        str2double(get(hObject,'String')) returns contents of maxneighbors_val as a double


% --- Executes during object creation, after setting all properties.
function maxneighbors_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxneighbors_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxvotes_val_Callback(hObject, eventdata, handles)
% hObject    handle to maxvotes_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxvotes_val as text
%        str2double(get(hObject,'String')) returns contents of maxvotes_val as a double


% --- Executes during object creation, after setting all properties.
function maxvotes_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxvotes_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_exit_Callback(hObject, eventdata, handles)
% hObject    handle to save_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


mingroup=str2double(get(handles.defmin_val,'String'));
maxgroup=str2double(get(handles.defmax_val,'String'));
maxvotes=str2double(get(handles.maxvotes_val,'String'));
minmatchproj=str2double(get(handles.minmatchproj_val,'String'));
maxneighbors=str2double(get(handles.maxneighbors_val,'String'));
time_discount=str2double(get(handles.time_discount_val,'String'));

if (0<=mingroup)&&(mingroup<=maxgroup)
    quickset('pref',mingroup,'solver','mingroup');
    quickset('pref',maxgroup,'solver','maxgroup');
else
    msgbox('Ensure the min group size is greater than or equal to zero and less than or equal to the max group size.');
    return
end
if (0<maxvotes)
    quickset('pref',maxvotes,'solver','maxvotes');
end
if 0<minmatchproj
    quickset('pref',minmatchproj,'solver','minmatchproj');
end
if 0<maxneighbors
    quickset('pref',maxneighbors,'solver','maxneighbors');
end
if (0<time_discount )&&(time_discount)<=100
    quickset('pref',time_discount,'solver','time_discount');
else
    msgbox('Please enter a time discounting factor between 1 and 100 (inclusive).')
end


prefmenu_CloseRequestFcn(handles.prefmenu, [], handles)

% --- Executes when user attempts to close prefmenu.
function prefmenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to prefmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


function time_discount_val_Callback(hObject, eventdata, handles)
% hObject    handle to time_discount_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_discount_val as text
%        str2double(get(hObject,'String')) returns contents of time_discount_val as a double


% --- Executes during object creation, after setting all properties.
function time_discount_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_discount_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
