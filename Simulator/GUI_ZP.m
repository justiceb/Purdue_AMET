function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 07-Sep-2014 21:08:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Clear workspace
evalin('base','clear')
clc;

% Dependencies
addpath(genpath(pwd));

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Create_Balloon_Button.
function Create_Balloon_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Balloon_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%read input values and convert to appropriate units
rho_PE = str2double(get(handles.rho_PE,'String'));                      %kg/m^3
thickness_PE = str2double(get(handles.thickness_PE,'String')) * 1E-6;   %m
Wpayload = str2double(get(handles.Wpayload,'String')) * 4.44822162;     %N
alt_apogee = str2double(get(handles.alt_apogee,'String')) * 0.3048;     %m
numGores = str2double(get(handles.numGores,'String'));                  %
savex('balloon_inputs.mat','hObject','eventdata','handles');            %save inputs to file

%run balloon creation code.  save output to guidata
handles.balloon = create_balloon('balloon_inputs');
guidata(hObject, handles);


function rho_PE_Callback(hObject, eventdata, handles)
% hObject    handle to rho_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function rho_PE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function thickness_PE_Callback(hObject, eventdata, handles)
% hObject    handle to thickness_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function thickness_PE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thickness_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Wpayload_Callback(hObject, eventdata, handles)
% hObject    handle to Wpayload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Wpayload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wpayload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function alt_apogee_Callback(hObject, eventdata, handles)
% hObject    handle to alt_apogee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function alt_apogee_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alt_apogee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numGores_Callback(hObject, eventdata, handles)
% hObject    handle to numGores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function numGores_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numGores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in save_gui_inputs.
function save_gui_inputs_Callback(hObject, eventdata, handles)
% hObject    handle to save_gui_inputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('GUI_inputs/*.mat', 'Pick or create a GUI iunputs file');
    if isequal(filename,0) || isequal(pathname,0)
       % user pressed cancel.  Do nothing
    else
        inputs = struct;
        m = 1;
        NAMES = fieldnames(handles);
        for n = 1:1:length(NAMES)
            if isprop(handles.(NAMES{n}),'style')
                if strcmp('edit' , get(handles.(NAMES{n}),'style') )
                    inputs(m).tag = get(handles.(NAMES{n}),'tag');
                    inputs(m).string = get(handles.(NAMES{n}),'string');
                    m = m+1;
                end
            end
        end
        save(fullfile(pathname,filename),'inputs');
    end

% --- Executes on button press in load_GUI_inputs.
function load_GUI_inputs_Callback(~, eventdata, handles)
% hObject    handle to load_GUI_inputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('GUI_inputs/*.mat', 'Pick or create a GUI iunputs file');
    if isequal(filename,0) || isequal(pathname,0)
       % user pressed cancel.  Do nothing
    else
        temp = load(fullfile(pathname,filename));
        inputs = temp.inputs;
        for n = 1:1:length(inputs)
            set(handles.(inputs(n).tag),'string',inputs(n).string)
        end
    end



function gui_inputs_filepath_Callback(hObject, eventdata, handles)
% hObject    handle to gui_inputs_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gui_inputs_filepath as text
%        str2double(get(hObject,'String')) returns contents of gui_inputs_filepath as a double


% --- Executes during object creation, after setting all properties.
function gui_inputs_filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_inputs_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
