function varargout = Microscope_Configuration_File_Generator_GUI(varargin)
% MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI MATLAB code for Microscope_Configuration_File_Generator_GUI.fig
%      MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI, by itself, creates a new MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI or raises the existing
%      singleton*.
%
%      H = MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI returns the handle to a new MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI or the handle to
%      the existing singleton*.
%
%      MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI.M with the given input arguments.
%
%      MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI('Property','Value',...) creates a new MICROSCOPE_CONFIGURATION_FILE_GENERATOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Microscope_Configuration_File_Generator_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Microscope_Configuration_File_Generator_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Microscope_Configuration_File_Generator_GUI

% Last Modified by GUIDE v2.5 29-Jun-2018 16:43:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Microscope_Configuration_File_Generator_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Microscope_Configuration_File_Generator_GUI_OutputFcn, ...
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


% --- Executes just before Microscope_Configuration_File_Generator_GUI is made visible.
function Microscope_Configuration_File_Generator_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Microscope_Configuration_File_Generator_GUI (see VARARGIN)

% Choose default command line output for Microscope_Configuration_File_Generator_GUI
handles.output = hObject;

% Declare Global Variables
global edit_flag
global save_path

% Set Edit Existing Flag
edit_flag = 0;

% Initialize Save Path Value
save_path = './Functions/Microscope Configurations';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Microscope_Configuration_File_Generator_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Microscope_Configuration_File_Generator_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pixel_lpmm_conv_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_lpmm_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_lpmm_conv as text
%        str2double(get(hObject,'String')) returns contents of pixel_lpmm_conv as a double


% --- Executes during object creation, after setting all properties.
function pixel_lpmm_conv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_lpmm_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function obj_na_Callback(hObject, eventdata, handles)
% hObject    handle to obj_na (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obj_na as text
%        str2double(get(hObject,'String')) returns contents of obj_na as a double


% --- Executes during object creation, after setting all properties.
function obj_na_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_na (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function obj_mag_Callback(hObject, eventdata, handles)
% hObject    handle to obj_mag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obj_mag as text
%        str2double(get(hObject,'String')) returns contents of obj_mag as a double


% --- Executes during object creation, after setting all properties.
function obj_mag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_mag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_number_Callback(hObject, eventdata, handles)
% hObject    handle to f_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_number as text
%        str2double(get(hObject,'String')) returns contents of f_number as a double


% --- Executes during object creation, after setting all properties.
function f_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavelength as text
%        str2double(get(hObject,'String')) returns contents of wavelength as a double


% --- Executes during object creation, after setting all properties.
function wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function refractive_index_medium_Callback(hObject, eventdata, handles)
% hObject    handle to refractive_index_medium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refractive_index_medium as text
%        str2double(get(hObject,'String')) returns contents of refractive_index_medium as a double


% --- Executes during object creation, after setting all properties.
function refractive_index_medium_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refractive_index_medium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function working_distance_Callback(hObject, eventdata, handles)
% hObject    handle to working_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of working_distance as text
%        str2double(get(hObject,'String')) returns contents of working_distance as a double


% --- Executes during object creation, after setting all properties.
function working_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to working_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Declare Globals
global edit_flag
global save_path
global existing_file_name

% Get Values
obj_na = str2double(get(handles.obj_na, 'String'));
obj_mag = str2double(get(handles.obj_mag, 'String'));
working_distance = str2double(get(handles.working_distance, 'String'));
f_number = str2double(get(handles.f_number, 'String'));
refractive_index_medium = str2double(get(...
    handles.refractive_index_medium, 'String'));
wavelength = str2double(get(handles.wavelength, 'String'));
pixel_lpmm_conv = str2double(get(handles.pixel_lpmm_conv, 'String'));

% Determine if Editing an Existing Configuration and Generate Save Name
if edit_flag == 0
    cpath = pwd;
    cd(save_path)
    
    % Check for Valid New File Name
    while 1
        fname = inputdlg('Configuration File Name', ...
            'Enter a New Configuration File Name');
        if ~isempty(fname)
            [~, fname, ~] = fileparts(fname{1});
            if exist([fname '.mat'], 'file') == 0
                break;
            else
                uiwait(msgbox('Filename Already in Use.'));
            end
        else
            uiwait(msgbox('Please Enter a Configuration Name.'));
        end
    end
    sname = [save_path '\' fname '.mat'];
    cd(cpath);
else
    sname = [save_path '\' existing_file_name];
end

% Save Configuration File
save(sname, 'obj_na', 'obj_mag', 'working_distance', 'f_number', ...
    'refractive_index_medium', 'wavelength', 'pixel_lpmm_conv');

% Close GUI
closereq;



% --- Executes on button press in edit_existing_button.
function edit_existing_button_Callback(hObject, eventdata, handles)
% hObject    handle to edit_existing_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Declare Global Variables
global edit_flag
global save_path
global existing_file_name

% Get Existing Configuration File
cpath = pwd;
edit_file_selected_flag = 1;
    cd(save_path)
    [existing_file_name, existing_file_path] = ...
        uigetfile('*.mat');
if existing_file_name == 0
    % User closed the window before selecting a file
    edit_file_selected_flag = 0;
end
cd(cpath);

if edit_file_selected_flag == 1
    % Set the Edit Existing Flag
    edit_flag = 1;
    
    % Load Congigutaion File
    load([existing_file_path '\' existing_file_name]);
    
    % Set Existing Values
    set(handles.obj_na, 'String', num2str(obj_na));
    set(handles.obj_mag, 'String', num2str(obj_mag));
    set(handles.working_distance, 'String', num2str(working_distance));
    set(handles.f_number, 'String', num2str(f_number));
    set(handles.refractive_index_medium, 'String', ...
        num2str(refractive_index_medium));
    set(handles.wavelength, 'String', num2str(wavelength));
    set(handles.pixel_lpmm_conv, 'String', num2str(pixel_lpmm_conv));
end