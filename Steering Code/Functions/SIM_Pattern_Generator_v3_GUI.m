function varargout = SIM_Pattern_Generator_v3_GUI(varargin)
% SIM_PATTERN_GENERATOR_V3_GUI MATLAB code for SIM_Pattern_Generator_v3_GUI.fig
%      SIM_PATTERN_GENERATOR_V3_GUI, by itself, creates a new SIM_PATTERN_GENERATOR_V3_GUI or raises the existing
%      singleton*.
%
%      H = SIM_PATTERN_GENERATOR_V3_GUI returns the handle to a new SIM_PATTERN_GENERATOR_V3_GUI or the handle to
%      the existing singleton*.
%
%      SIM_PATTERN_GENERATOR_V3_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIM_PATTERN_GENERATOR_V3_GUI.M with the given input arguments.
%
%      SIM_PATTERN_GENERATOR_V3_GUI('Property','Value',...) creates a new SIM_PATTERN_GENERATOR_V3_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SIM_Pattern_Generator_v3_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SIM_Pattern_Generator_v3_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SIM_Pattern_Generator_v3_GUI

% Last Modified by GUIDE v2.5 08-Aug-2018 13:08:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SIM_Pattern_Generator_v3_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SIM_Pattern_Generator_v3_GUI_OutputFcn, ...
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


% --- Executes just before SIM_Pattern_Generator_v3_GUI is made visible.
function SIM_Pattern_Generator_v3_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SIM_Pattern_Generator_v3_GUI (see VARARGIN)

% Choose default command line output for SIM_Pattern_Generator_v3_GUI
handles.output = hObject;

% Load in Previous State
load('.\Functions\GUI Last States\Pattern_Generator_Last_State.mat');
set(handles.pattern_pixel_width, 'String', num2str(pixels_wide));
set(handles.display_width, 'String', num2str(pattern_width));
set(handles.display_height, 'String', num2str(pattern_height));
set(handles.aperture, 'String', num2str(aperture_percent));
set(handles.rotation, 'String', num2str(rotation));

switch file_num
    case 3
        set(handles.rb_3_sub, 'Value',1);
    case 4
        set(handles.rb_4_sub, 'Value',1);
    case 5
        set(handles.rb_5_sub, 'Value',1);
end

switch pattern
    case 'Perfect Bar'
        set(handles.rb_perfect_bar, 'Value', 1)
    case 'Imperfect Bar'
        set(handles.rb_imperfect_bar, 'Value', 1)
    case 'Imperfect Sine Wave'
        set(handles.rb_imperfect_sine, 'Value', 1)
end

switch file_type
    case '.bmp'
        set(handles.rb_bmp, 'Value', 1)
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SIM_Pattern_Generator_v3_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SIM_Pattern_Generator_v3_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in generate_patterns.
function generate_patterns_Callback(hObject, eventdata, handles)
% hObject    handle to generate_patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get Text Inputs
pixels_wide = str2double(get(handles.pattern_pixel_width, 'String'));
pattern_width = str2double(get(handles.display_width, 'String'));
pattern_height = str2double(get(handles.display_height, 'String'));
aperture_percent = str2double(get(handles.aperture, 'String'));
rotation = str2double(get(handles.rotation, 'String'));

% Get Reconstruction Type
if get(handles.rb_3_sub, 'Value') == 1
    reconstruction_type = '3 Sub Image';
    file_num = 3;
elseif get(handles.rb_4_sub, 'Value') == 1
    reconstruction_type = '4 Sub Image';
    file_num = 4;
elseif get(handles.rb_5_sub, 'Value') == 1
    reconstruction_type = '5 Sub Image';
    file_num = 5;
end

% Get Pattern Type
if get(handles.rb_perfect_bar, 'Value') == 1
    pattern = 'Perfect Bar';
elseif get(handles.rb_imperfect_bar, 'Value') == 1
    pattern = 'Imperfect Bar';
elseif get(handles.rb_imperfect_sine, 'Value') == 1
    pattern = 'Imperfect Sine Wave';
end

% Get File Type
%   NOTE: This is here as an expandle point for future versions. 
if get(handles.rb_bmp, 'Value') == 1
    file_type = '.bmp';
end
save('.\Functions\GUI Last States\Pattern_Generator_Last_State.mat', ...
    'file_num', 'pattern', 'pixels_wide', 'pattern_width', ...
    'pattern_height', 'aperture_percent', 'file_type', 'rotation');

% Generate Save Path and Check if the Patterns Were Already Generated. 
hpath = pwd;
cd('.\Patterns');
save_path = [pwd '\' num2str(pattern_width) 'x' num2str(pattern_height)];
if exist(save_path, 'dir') == 0
    mkdir(save_path);
end
cd(save_path);
save_path = [save_path '\' reconstruction_type ' ' pattern ' ' ...
    num2str(pixels_wide) ' Pixels ' num2str(aperture_percent) ...
    ' Aperture ' num2str(rotation) 'deg Rotation' ];
pattern_exist_flag = 0;  % Pre-Existing Pattern Flag
if exist(save_path, 'dir') == 0
    mkdir(save_path);
else
    % Folder Exists. Need to Check for Content.
    cd(save_path);
    if numel(dir) == (2 + file_num)
        % The two compensates for system folders
        pattern_exist_flag = 1;     % Patterns were previously generated. 
    end
end
cd(hpath);

% Generate Patterns
if pattern_exist_flag == 0
    SIM_Pattern_Generator_v3_func(save_path, pixels_wide, pattern_width,...
        pattern_height, reconstruction_type, pattern, file_type, ...
        aperture_percent, rotation);
else
    uiwait(msgbox('Patterns Already Exist in the Patterns Folder.'));
end

% Close GUI
closereq;



function pattern_pixel_width_Callback(hObject, eventdata, handles)
% hObject    handle to pattern_pixel_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pattern_pixel_width as text
%        str2double(get(hObject,'String')) returns contents of pattern_pixel_width as a double


% --- Executes during object creation, after setting all properties.
function pattern_pixel_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pattern_pixel_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_width_Callback(hObject, eventdata, handles)
% hObject    handle to display_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_width as text
%        str2double(get(hObject,'String')) returns contents of display_width as a double


% --- Executes during object creation, after setting all properties.
function display_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_height_Callback(hObject, eventdata, handles)
% hObject    handle to display_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_height as text
%        str2double(get(hObject,'String')) returns contents of display_height as a double


% --- Executes during object creation, after setting all properties.
function display_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aperture_Callback(hObject, eventdata, handles)
% hObject    handle to aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aperture as text
%        str2double(get(hObject,'String')) returns contents of aperture as a double


% --- Executes during object creation, after setting all properties.
function aperture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotation_Callback(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation as text
%        str2double(get(hObject,'String')) returns contents of rotation as a double


% --- Executes during object creation, after setting all properties.
function rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
