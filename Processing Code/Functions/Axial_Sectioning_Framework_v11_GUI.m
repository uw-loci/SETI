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

% Last Modified by GUIDE v2.5 30-Nov-2018 17:33:42

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

% Set Initial Panel Visibility
rec_mode_list = get(handles.rec_mode_select, 'String');
rec_mode_num = get(handles.rec_mode_select, 'Value');
if rec_mode_num > 3
    error('Unsupported Reconstrution Mode');
end
rec_mode = rec_mode_list{rec_mode_num};
handles = panel_visibility_setter(rec_mode, handles);

% Set all the Tool Tip Strings
handles = tooltip_string_setter(handles);

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

% Get BitDepth
switch get(handles.bit_depth, 'Value')
    case 1
        bit_depth = 8;
    case 2
        bit_depth = 16;
    case 3
        bit_depth = 32;
    case 4
        bit_depth = 64;
    otherwise
        error('Invalid Output Bit Depth Selected');
end


% Get Values
steering_code_raw_data_flag = get(handles.steering_code_raw, 'Value');
sim_points = str2double(get(handles.sim_points, 'String'));
overlap_percent = str2double(get(handles.overlap_percent, 'String')) / 100;
threshold_percent = str2double(get(handles.threshold_percent, ...
    'String')) / 100;
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
    bit_depth, sim_points, save_intermediaries_flag, flat_field_flag, ...
    flat_field_path, overlap_percent, threshold_percent);

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
rec_mode_num = get(handles.rec_mode_select, 'Value');
if rec_mode_num > 3
    uiwait(msgbox('Please Select a Supported Form of Reconstruction'));
end

% Set Panel Visibility
rec_mode_list = get(handles.rec_mode_select, 'String');
rec_mode = rec_mode_list{rec_mode_num};
handles = panel_visibility_setter(rec_mode, handles);

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
% Selected Folder to Process Tooltip
set(handles.text5, 'TooltipString', fpath);



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
else
    % Selected Flat Field Correction File Tooltip
    set(handles.text8, 'TooltipString', flat_field_path);
end



function overlap_percent_Callback(hObject, eventdata, handles)
% hObject    handle to overlap_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlap_percent as text
%        str2double(get(hObject,'String')) returns contents of overlap_percent as a double


% --- Executes during object creation, after setting all properties.
function overlap_percent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlap_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_percent_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_percent as text
%        str2double(get(hObject,'String')) returns contents of threshold_percent as a double


% --- Executes during object creation, after setting all properties.
function threshold_percent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in bit_depth.
function bit_depth_Callback(hObject, eventdata, handles)
% hObject    handle to bit_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bit_depth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bit_depth


% --- Executes during object creation, after setting all properties.
function bit_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bit_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% Function to check and set Panel visibility
function handles = panel_visibility_setter(rec_mode, handles)
switch rec_mode
    case 'Individual Images'
        set(handles.image_stack_ui_panel, 'visible', 'off');
        set(handles.rejection_profile_ui_panel, 'visible', 'off');
        
    case 'Image Stack'
        set(handles.image_stack_ui_panel, 'visible', 'on');
        set(handles.rejection_profile_ui_panel, 'visible', 'off');
        
    case 'Rejection Profile'
        set(handles.image_stack_ui_panel, 'visible', 'on');
        set(handles.rejection_profile_ui_panel, 'visible', 'on');
        
end


% Function to set all the ToolTip Strings
function handles = tooltip_string_setter(handles)
% Reconstruction Mode Tooltip
rec_mode_str_1 = 'Select how the processing code will reconstruct your images.'; 
rec_mode_str_2 = 'Individual images are images with no overlapping areas and can be a random assortment.'; 
rec_mode_str_3 = 'Image Stack is a set of images that have been acquired to make a data cube.';
rec_mode_str_4 = 'Rejection Profile is an image set used for determing the intensity falloff due to the patterning.';
rec_mode_str_full = sprintf('%s\n%s\n%s\n%s', rec_mode_str_1, ...
    rec_mode_str_2, rec_mode_str_3, rec_mode_str_4);
set(handles.text4, 'TooltipString', rec_mode_str_full);
set(handles.rec_mode_select, 'TooltipString', rec_mode_str_full);
    
% Microscope Configuration File Tooltip
microscope_config_file_str_full = 'Select which hardware configuration the microscope was in for imaging.';
set(handles.text3, 'TooltipString', microscope_config_file_str_full);
set(handles.microscope_config_file, 'TooltipString', ...
    microscope_config_file_str_full);

% Steering Code Raw Data Flag Tooltip
steering_code_raw_str_full = 'Select if the data is directly output from the steering code.';
set(handles.steering_code_raw, 'TooltipString', ...
    steering_code_raw_str_full);

% Save Intermediaries Flag Tooltip
save_intermediaries_flag_str_1 = 'Select if you want to save intermediary steps from the processed images.';
save_intermediaries_flag_str_2 = 'NOTE: This will slow down your processing speeds.';
save_intermediaries_flag_str_full = sprintf('%s\n%s', ...
    save_intermediaries_flag_str_1, save_intermediaries_flag_str_2);
set(handles.save_intermediaries_flag, 'TooltipString', ...
    save_intermediaries_flag_str_full);

% Flat Field Correction Flag Tooltip
flat_field_flag_str_full = 'Select flat field correction of the data.';
set(handles.flat_field_flag, 'TooltipString', ...
    flat_field_flag_str_full);

% Selected Folder for Flat Field Correction Tooltip
selected_folder_flat_field_str_full = get(handles.text8, 'String');
set(handles.text8, 'TooltipString', ...
    selected_folder_flat_field_str_full);

% Bit Depth Tooltip
bit_depth_str_full = 'Select the Bit Depth output images should contain.';
set(handles.text6, 'TooltipString', bit_depth_str_full);
set(handles.bit_depth, 'TooltipString', bit_depth_str_full);

% Image Save Type Tif Tooltip
img_save_type_tif_str_full = 'Select for all output images to be saved as .tif';
set(handles.img_save_type_tif, 'TooltipString', ...
    img_save_type_tif_str_full);

% Tiling Overlap Percentage Tooltip
overlap_percent_str_full = 'The estimated percentage overlap between adjacent images in X and Y.';
set(handles.text9, 'TooltipString', overlap_percent_str_full);
set(handles.overlap_percent, 'TooltipString', overlap_percent_str_full);

% Tiling Threshold Percentage Tooltip
threshold_percent_str_full = 'The thresholding percentage of maximum intensity to be used for registration.';
set(handles.text10, 'TooltipString', threshold_percent_str_full);
set(handles.threshold_percent, 'TooltipString', ...
    threshold_percent_str_full);

% Rejection Profile Number of Simulated Points Tooltip
sim_points_str_full = 'The number of points used for calculating the theoretical structured illumination axial sectioning rejection profile. ';
set(handles.text7, 'TooltipString', sim_points_str_full);
set(handles.sim_points, 'TooltipString', sim_points_str_full);

% Select Folder to Process Tooltip
process_folder_selection_str_full = 'Push to select the folder containg all the data to process.';
set(handles.process_folder_selection, 'TooltipString', ...
    process_folder_selection_str_full);

% Selected Folder to Process Tooltip
selected_folder_to_process_str_full = get(handles.text5, 'String');
set(handles.text5, 'TooltipString', ...
    selected_folder_to_process_str_full);

% Process Data Tooltip
process_data_button_str_full = 'Push to start processing data.';
set(handles.process_data_button, 'TooltipString', ...
    process_data_button_str_full);
