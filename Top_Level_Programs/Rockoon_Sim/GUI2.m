function varargout = GUI2(varargin)
% GUI2 MATLAB code for GUI2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI2

% Last Modified by GUIDE v2.5 24-Aug-2014 19:40:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
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


% --- Executes just before GUI2 is made visible.
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% Clear workspace
evalin('base','clear')
clc;

% Dependencies
Parent = pwd;
NAME = 'null';
while ~strcmp(NAME,'Matlab')
    [Parent,NAME,EXT] = fileparts(Parent);
end
Parent = strcat(Parent,'\',NAME,'\');
addpath(genpath(strcat(Parent,'Common_Functions')));
addpath(genpath(strcat(Parent,'Config_Files')));
addpath(genpath(strcat(Parent,'Programs\Balloon_Shape')));
addpath(genpath(strcat(Parent,'Programs\Ascent_ZP_Balloon')));
addpath(genpath(strcat(Parent,'Programs\Rocket_3DOF')));
addpath(genpath(strcat(Parent,'Programs\Descent_Parachute')));

% Choose default command line output for GUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function rho_PE_Callback(hObject, eventdata, handles)
% hObject    handle to rho_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%assignin('base',get(hObject,'Tag'),str2double(get(hObject,'String')));


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


% --- Executes on button press in Create_Balloon_Button.
function Create_Balloon_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Balloon_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%read input values and convert to appropriate units
rho_PE = str2double(get(handles.rho_PE,'String'));
thickness_PE = str2double(get(handles.thickness_PE,'String')) * 1E-6;
Wpayload = str2double(get(handles.Wpayload,'String')) * 4.44822162;
alt_apogee = str2double(get(handles.alt_apogee,'String')) * 0.3048;
numGores = str2double(get(handles.numGores,'String'));
savex('balloon_inputs.mat','hObject','eventdata','handles');

%run balloon creation code.  save output to guidata
handles.balloon = create_balloon('balloon_inputs');
guidata(hObject, handles);



function Wpayload_Callback(hObject, eventdata, handles)
% hObject    handle to Wpayload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Wpayload as text
%        str2double(get(hObject,'String')) returns contents of Wpayload as a double


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

% Hints: get(hObject,'String') returns contents of alt_apogee as text
%        str2double(get(hObject,'String')) returns contents of alt_apogee as a double


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

% Hints: get(hObject,'String') returns contents of numGores as text
%        str2double(get(hObject,'String')) returns contents of numGores as a double


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



function alt0_Callback(hObject, eventdata, handles)
% hObject    handle to alt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alt0 as text
%        str2double(get(hObject,'String')) returns contents of alt0 as a double


% --- Executes during object creation, after setting all properties.
function alt0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Ascent_Button.
function Ascent_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Ascent_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alt0 = str2double(get(handles.alt0,'String')) * 0.3048;
long0 = str2double(get(handles.long0,'String'));
lat0 = str2double(get(handles.lat0,'String'));
V_H2_surplusfill = str2double(get(handles.V_H2_surplusfill,'String')) * 0.0283168;
wind_filename = get(handles.wind_filename,'String');

wind = load_Wyoming_Sounding(wind_filename);
balloon = handles.balloon;
savex('ascent_inputs.mat','hObject','eventdata','handles');

%run ascent code.  save output to guidata
handles.ascent = rockoon_ascent2('ascent_inputs');
guidata(hObject, handles);



function V_H2_surplusfill_Callback(hObject, eventdata, handles)
% hObject    handle to V_H2_surplusfill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_H2_surplusfill as text
%        str2double(get(hObject,'String')) returns contents of V_H2_surplusfill as a double


% --- Executes during object creation, after setting all properties.
function V_H2_surplusfill_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_H2_surplusfill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wind_filename_Callback(hObject, eventdata, handles)
% hObject    handle to wind_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wind_filename as text
%        str2double(get(hObject,'String')) returns contents of wind_filename as a double


% --- Executes during object creation, after setting all properties.
function wind_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wind_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function long0_Callback(hObject, eventdata, handles)
% hObject    handle to long0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of long0 as text
%        str2double(get(hObject,'String')) returns contents of long0 as a double


% --- Executes during object creation, after setting all properties.
function long0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to long0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lat0_Callback(hObject, eventdata, handles)
% hObject    handle to lat0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lat0 as text
%        str2double(get(hObject,'String')) returns contents of lat0 as a double


% --- Executes during object creation, after setting all properties.
function lat0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lat0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
