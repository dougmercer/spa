function varargout = launcher(varargin)
% LAUNCHER MATLAB code for launcher.fig
%      LAUNCHER, by itself, creates a new LAUNCHER or raises the existing
%      singleton*.
%
%      H = LAUNCHER returns the handle to a new LAUNCHER or the handle to
%      the existing singleton*.
%
%      LAUNCHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAUNCHER.M with the given input arguments.
%
%      LAUNCHER('Property','Value',...) creates a new LAUNCHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before launcher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to launcher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help launcher

% Last Modified by GUIDE v2.5 16-Dec-2014 19:24:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @launcher_OpeningFcn, ...
                   'gui_OutputFcn',  @launcher_OutputFcn, ...
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


% --- Executes just before launcher is made visible.
function launcher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to launcher (see VARARGIN)

% Choose default command line output for launcher
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Initialize preferences
initpref();

%Display image in launcher axes
impath=quickget('pref','cosm','impath');
if isa(impath,'struct')
    impath=char;
end
if exist(impath,'file')~=0
    image_start=imread(impath);
else
    image_start=imread('psu_logo.jpg');
end
imshow(image_start,'Parent',handles.launcher_img);

%set launcher handle to root appdata
setappdata(0,'launcherhandle',handles.launcher_fig);

%set handles to root
setappdata(0,'launcherhandles',handles);

%center figure in middle of screen
center_fig(handles.launcher_fig);

set(handles.project_status,'ForegroundColor','Black');

% UIWAIT makes launcher wait for user response (see UIRESUME)
% uiwait(handles.launcher_fig);


% --- Outputs from this function are returned to the command line.
function varargout = launcher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function edit_solve_Callback(hObject, eventdata, handles)
% hObject    handle to edit_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run pref_menu.m


% --------------------------------------------------------------------
function export_csv_Callback(hObject, eventdata, handles)
% hObject    handle to export_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(getappdata(0),'s_assignment')
    write_csv();
    msgbox('Exported solution to .csv.');
else
    msgbox('Solve problem before attempting to export results.');
end


% --- Executes on button press in solve_button.
function solve_button_Callback(hObject, eventdata, handles)
% hObject    handle to solve_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ps=get(handles.project_status,'BackgroundColor');
if ~(ps(1) == 0 && ps(2) == 1 && ps(3) == 0)
    msgbox('Load data before solving the problem.', 'Error','error');
    return
else
    [ status, p ] = check_bound_feas;
    if status ~= 0
        display_solver_error(status, p);
        return
    end
end

%Display msgbox
m=msgbox('Solving. Please wait...'); %m is the handle of the message box
child=get(m,'Children'); %the message box has two children: the actual message and the OK button. There are two handles in child
set(child(2),'Visible','off'); %hides OK button
pause(0.01) %pausing lets the gui hide the "ok" button 

r = prepare_r; %construct student-> project value matrix

%convert to binary program
[ c, A, b, lb, ub, th ] = values2bintprog(r);
%solve
[ x, f, status, ~ ] = pass2glpk(c, A, b, lb, ub);
if status == 210
    msgbox('Uh oh... there is literally no feasible solution to this problem, and that shouldn''t happen. Contact Doug Mercer at dgm161@psu.edu, and send your data.mat file that is exported upon closing the application.','Error','error');
    return
end
    %translate solution
[ s_assignment, art_pm, art_p ] = translate_solution( x, th, r );
%store solution in appdata
quickset('s_assignment', s_assignment);
quickset('art_pm', art_pm);
quickset('art_p', art_p);
close(m); %close old msgbox
if f < 0 % obj. func. value < 0 iff (s->sink or art_s->pm or art_s->p)
    str = 'No feasible solution exists. Nearest optimal feasible solution found with infeasibility report. Export solution to .csv, identify causes of feasibility, edit your student and project data, and solve again to address these infeasibilities.';
    warndlg(str, 'Warning');
else
    str = 'Optimal solution found.';
    msgbox(str, 'Success', 'custom', makeicon);
end

% --------------------------------------------------------------------
function download_Callback(hObject, eventdata, handles)
% hObject    handle to download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% str=sprintf('MATLAB is about to direct your browser to the Learning Factory website. Although the website will warn you that the security certificate is not secure, please click "Proceed Anyways".\n\nUse the following log-in credentials:\n\tUsername: Projects\n\tPassword: Export\n\nThe .xml file will automatically be downloaded to your browser''s default "Downloads" directory.');
% uiwait(msgbox(str));
% web('https://www.lf.psu.edu/ProjectExport','-browser');
str=sprintf('Future home of function to download Shan''s data.');
msgbox(str);

% --------------------------------------------------------------------
function edit_students_Callback(hObject, eventdata, handles)
% hObject    handle to edit_students (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run student_menu.m


% --------------------------------------------------------------------
function edit_projects_Callback(hObject, eventdata, handles)
% hObject    handle to edit_projects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run project_menu.m

% --------------------------------------------------------------------
function edit_majors_Callback(hObject, eventdata, handles)
% hObject    handle to edit_majors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run major_menu.m


% --------------------------------------------------------------------
function edit_sections_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run section_menu.m


function select_launcher_img_Callback(hObject, eventdata, handles)
% hObject    handle to select_image_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f, p, i] = uigetfile('*.jpg;*.png;*.bmp','Select an image file');
if i ~= 0
    impath = [p, f];
    quickset('pref', impath, 'cosm', 'impath');
    imshow(impath, 'Parent', handles.launcher_img);
end

% --------------------------------------------------------------------
function importxml_Callback(hObject, eventdata, handles)
% hObject    handle to importxml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m = msgbox('Loading data. Please wait...'); %m is the handle of the message box
child = get(m, 'Children');%the message box has two children: the actual message and the OK button. There are two handles in child one for each
cc = get(child(1), 'Children'); % cc is another handle
set(child(2),  'Visible', 'off'); %makes "ok" button invisible
pause(0.01); %pausing lets the gui hide the "ok" button
try
    data = importxml();
    data = formatdata(data);
    quickset('students', data.students);
    quickset('projects', data.projects); %migrated
    quickset('sections', data.sections);
    quickset('majors', data.majors);

    set(cc, 'String', 'Data successfully loaded.');
    set(child(2), 'Visible', 'on');

    set(handles.project_status, 'String', 'Data Imported');
    set(handles.project_status, 'BackgroundColor', 'Green');
    set(handles.project_status, 'ForegroundColor', 'Black');
catch
    close(m)
    msgbox('Failed to import .xml.');
end

% --------------------------------------------------------------------
function importmat_Callback(hObject, eventdata, handles)
% hObject    handle to importmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f, p, i] = uigetfile('*.mat', 'Select your data.mat file');
if i ~= 0
    load([p, f]);
    try 
        if isstruct(students)
            quickset('students', students);
        end
        if isstruct(projects)
            quickset('projects', projects);
        end
        if isstruct(majors)
            quickset('majors', majors);
        end
        if isstruct(sections)
            quickset('sections', sections);
        end  
        msgbox('Data successfully loaded.');
        set(handles.project_status, 'String', 'Data Imported', 'BackgroundColor', 'Green', 'ForegroundColor', 'Black');
    catch
        msgbox('Table load failed. Please ensure you selected the correct .mat file and try again.');
    end
end

% --- Executes when user attempts to close launcher_fig.
function launcher_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to launcher_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(getappdata(0), 'pref')
    pref = quickget('pref');
    rmappdata(0, 'pref');
    save('preferences.mat', 'pref'); %save preferences to pref.mat
%     try
%         save([pref.writedir, filesep, 'preferences.mat'], 'pref'); %save preferences to pref.mat
%     catch
%         msgbox('Unable to save to file. Please verify that the directory you selected does not have write restrictions');
%     end
end

if isfield(getappdata(0),'students')
    students = quickget('students');
    rmappdata(0, 'students');
else
    students = 0;
end
if isfield(getappdata(0), 'projects')
    projects = quickget('projects');
    rmappdata(0, 'projects');
else
    projects = 0;
end
if isfield(getappdata(0), 'majors')
    majors = quickget('majors');
    rmappdata(0, 'majors');
else
    majors = 0;
end
if isfield(getappdata(0), 'sections')
    sections = quickget('sections');
    rmappdata(0, 'sections');
else
    sections = 0;
end

%save current data in workspace to data.mat
save('data.mat', 'students', 'projects', 'majors', 'sections');
% try
%     save([pref.writedir,filesep,'data.mat'], 'students', 'projects', 'majors', 'sections');
% catch
%     msgbox('Unable to save to file. Please verify that the directory you selected does not have write restrictions');
% end


%begin cleaning up a bunch of junk in appdata
if isfield(getappdata(0),'launcherhandle')
    rmappdata(0,'launcherhandle');
end
if isfield(getappdata(0),'launcherhandles')
    rmappdata(0,'launcherhandles');
end
if isfield(getappdata(0),'projecttable')
    rmappdata(0,'projecttable');
end
if isfield(getappdata(0),'table')
    rmappdata(0,'table');
end
if isfield(getappdata(0),'missingMajors')
    rmappdata(0,'missingMajors');
end
if isfield(getappdata(0),'missingSections')
    rmappdata(0,'missingSections');
end
if isfield(getappdata(0),'missingMajors_inds')
    rmappdata(0,'missingMajors_inds');
end
if isfield(getappdata(0),'missingSections_inds')
    rmappdata(0,'missingSections_inds');
end
if isfield(getappdata(0),'s_assignment')
    rmappdata(0,'s_assignment');
end
if isfield(getappdata(0),'art_pm')
    rmappdata(0,'art_pm');
end
if isfield(getappdata(0),'art_p')
    rmappdata(0,'art_p');
end
delete(hObject);



function edit_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to edit_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%
% --------------------------------------------------------------------

function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%
a=1;

% --------------------------------------------------------------------
function edit_main_Callback(hObject, eventdata, handles)
% hObject    handle to edit_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%
% --------------------------------------------------------------------
function import_main_Callback(hObject, eventdata, handles)
% hObject    handle to import_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%
% --------------------------------------------------------------------
function other_Callback(hObject, eventdata, handles)
% hObject    handle to other (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%
% --------------------------------------------------------------------
function edit_disp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%THIS MENU IS JUST A PLACEHOLDER%


% --------------------------------------------------------------------
% function write_dir_Callback(hObject, eventdata, handles)
% % hObject    handle to write_dir (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% stopper = false;
% while ~stopper
%     [writedir, status] = get_writedir( );
%     if status == 0
%         quickset('pref', writedir, 'writedir');
%         stopper = true;
%         msgbox('Write directory selection successful.');
%     elseif status == 1
%         button = questdlg('Invalid directory selection: Unable to save to file. Please ensure the directory you selected does not require elevated permissions to write. Would you like to break or try again?','Invalid directory selection','Yes','No','Yes');
%         if strcmp(button, 'No')
%             stopper = true;
%         end
%     else%ask user if they want to try again or break
%         button = questdlg('Invalid directory selection: Unable to save to file. Please ensure the directory you selected does not require elevated permissions to write. Would you like to break or try again?','Invalid directory selection','Yes','No','Yes');
%         if strcmp(button, 'No')
%             stopper = true;
%         end
%     end
% end
