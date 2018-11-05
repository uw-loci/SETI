function varargout = Axial_Sectioning_Framework_v11_GUI(varargin)
% AXIAL_SECTIONING_FRAMEWORK_V11_GUI MATLAB code for Axial_Sectioning_Framework_v11_GUI.fig
%      AXIAL_SECTIONING_FRAMEWORK_V11_GUI, by itself, creates a new AXIAL_SECTIONING_FRAMEWORK_V11_GUI or raises the existing
%      singleton*.
%
%      H = AXIAL_SECTIONING_FRAMEWORK_V11_GUI returns the handle to a new AXIAL_SECTIONING_FRAMEWORK_V11_GUI or the handle to
%      the existing singleton*.
%
%      AXIAL_SECTIONING_FRAMEWORK_V11_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AXIAL_SECTIONING_FRAMEWORK_V11_GUI.M with the given input arguments.
%
%      AXIAL_SECTIONING_FRAMEWORK_V11_GUI('Property','Value',...) creates a new AXIAL_SECTIONING_FRAMEWORK_V11_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Axial_Sectioning_Framework_v11_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Axial_Sectioning_Framework_v11_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Axial_Sectioning_Framework_v11_GUI

% Last Modified by GUIDE v2.5 05-Nov-2018 12:36:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Axial_Sectioning_Framework_v11_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Axial_Sectioning_Framework_v11_GUI_OutputFcn, ...
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


% --- Executes just before Axial_Sectioning_Framework_v11_GUI is made visible.
function Axial_Sectioning_Framework_v11_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Axial_Sectioning_Framework_v11_GUI (see VARARGIN)

% Choose default command line output for Axial_Sectioning_Framework_v11_GUI
handles.output = hObject;

% Initialize Globals
global fpath
fpath = 0;

% Populate the List Box with Possible Microscope Configurations
hpath = pwd;
cd('./Functions/Microscope Configurations');
config_list = dir;
config_list = struct2cell(config_list);
config_list = config_list(1,3:end); 
for i = 1:numel(config_list)
    [~, config_list{i}, ~] = fileparts(config_list{i});
end
config_list{i+1} = 'Add New/Edit Configuration';
set(handles.microscope_config_file, 'String', config_list);
cd(hpath);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Axial_Sectioning_Framework_v11_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Axial_Sectioning_Framework_v11_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in process_data_button.
function process_data_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_data_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check Globals
global fpath
global flat_field_path
if fpath == 0
    error('No Folder Selected for Processing.')
end

% Get Values
steering_code_raw_data_flag = get(handles.steering_code_raw, 'Value');
max_int = str2double(get(handles.max_int, 'String'));
sim_points = str2double(get(handles.sim_points, 'String'));
save_intermediaries_flag = get(handles.save_intermediaries_flag, 'Value');
flat_field_flag = get(handles.flat_field_flag, 'Value');
if numel(flat_field_path) == 2 && flat_field_flag == 1
    error('No Flat Field Reference Selected')
end
microscope_configuration_file_num = ...
    get(handles.microscope_config_file, 'Value');
microscope_configuration_file = ...
    get(handles.microscope_config_file, 'String');
microscope_configuration_file = ...
    [microscope_configuration_file{microscope_configuration_file_num}, ...
    '.mat'];
if get(handles.img_save_type_tif, 'Value') == 1
    img_save_type = '.tif';
end
rec_mode_list = get(handles.rec_mode_select, 'String');
rec_mode_num = get(handles.rec_mode_select, 'Value');
if rec_mode_num > 3
    error('Unsupported Reconstrution Mode');
end
rec_mode = rec_mode_list{rec_mode_num};
% Run Axial Sectioning Framework
Axial_Sectioning_Framework_v11(steering_code_raw_data_flag, ...
    microscope_configuration_file, img_save_type, rec_mode, fpath, ...
    max_int, sim_points, save_intermediaries_flag, flat_field_flag, ...
    flat_field_path);

% Close GUI
closereq; 


% --- Executes on button press in steering_code_raw.
function steering_code_raw_Callback(hObject, eventdata, handles)
% hObject    handle to steering_code_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of steering_code_raw


% --- Executes on selection change in microscope_config_file.
function microscope_config_file_Callback(hObject, eventdata, handles)
% hObject    handle to microscope_config_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
microscope_configuration_file_num = ...
    get(handles.microscope_config_file, 'Value');
microscope_configuration_file = ...
    get(handles.microscope_config_file, 'String');
if microscope_configuration_file_num == ...
        numel(microscope_configuration_file)
    hpath = pwd;
    addpath('./Functions/Microscope Configurations');
    uiwait(Microscope_Configuration_File_Generator_GUI);
    % Populate the List Box with Possible Microscope Configurations
    cd('./Functions/Microscope Configurations');
    config_list = dir;
    config_list = struct2cell(config_list);
    config_list = config_list(1,3:end);
    for i = 1:numel(config_list)
        [~, config_list{i}, ~] = fileparts(config_list{i});
    end
    config_list{i+1} = 'Add New/Edit Configuration';
    set(handles.microscope_config_file, 'String', config_list);
    % Automatically Select the New Entry
    new_config_flag = 1;
    for i = 1:numel(microscope_configuration_file)
        if ~strcmp(microscope_configuration_file{i}, config_list{i})
            set(handles.microscope_config_file, 'Value', i);
            new_config_flag = 0;
            break;
        end
    end
    if new_config_flag == 1
        set(handles.microscope_config_file, 'Value', 1);
    end
    cd(hpath);
end

% Hints: contents = cellstr(get(hObject,'String')) returns microscope_config_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from microscope_config_file


% --- Executes during object creation, after setting all properties.
function microscope_config_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microscope_config_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rec_mode_select.
function rec_mode_select_Callback(hObject, eventdata, handles)
% hObject    handle to rec_mode_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Make Sure a Valid Selection Is Made
if get(handles.rec_mode_select, 'Value') > 4
    uiwait(msgbox('Please Select a Supported Form of Reconstruction'));
end
% Hints: contents = cellstr(get(hObject,'String')) returns rec_mode_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rec_mode_select


% --- Executes during object creation, after setting all properties.
function rec_mode_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rec_mode_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in process_folder_selection.
function process_folder_selection_Callback(hObject, eventdata, handles)
% hObject    handle to process_folder_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get a Folder Path
global fpath
fpath = uigetdir('..', 'Select Folder to Process');
if fpath == 0
    uiwait(msgbox('Please Select a Folder to Process'));
else
    set(handles.text5, 'String', fpath);
end



function max_int_Callback(hObject, eventdata, handles)
% hObject    handle to max_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_int as text
%        str2double(get(hObject,'String')) returns contents of max_int as a double


% --- Executes during object creation, after setting all properties.
function max_int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_intermediaries_flag.
function save_intermediaries_flag_Callback(hObject, eventdata, handles)
% hObject    handle to save_intermediaries_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_intermediaries_flag



function sim_points_Callback(hObject, eventdata, handles)
% hObject    handle to sim_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sim_points as text
%        str2double(get(hObject,'String')) returns contents of sim_points as a double


% --- Executes during object creation, after setting all properties.
function sim_points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flat_field_flag.
function flat_field_flag_Callback(hObject, eventdata, handles)
% hObject    handle to flat_field_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get a File Path
global flat_field_path
temp_name = 0;
if get(handles.flat_field_flag, 'Value') == 1
    [temp_name, temp_path, ~] = uigetfile('*.*', '..', ...
        'Select Flat Field Reference File');
    flat_field_path = [temp_path, temp_name];
    set(handles.text8, 'String', flat_field_path);
end

if temp_name == 0
    set(handles.flat_field_flag, 'Value', 0);
end
