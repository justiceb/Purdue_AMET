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

% Last Modified by GUIDE v2.5 25-Aug-2014 23:13:44

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
rho_PE = str2double(get(handles.rho_PE,'String'));
thickness_PE = str2double(get(handles.thickness_PE,'String')) * 1E-6;
Wpayload = str2double(get(handles.Wpayload,'String')) * 4.44822162;
alt_apogee = str2double(get(handles.alt_apogee,'String')) * 0.3048;
numGores = str2double(get(handles.numGores,'String'));
savex('balloon_inputs.mat','hObject','eventdata','handles');

%run balloon creation code.  save output to guidata
handles.balloon = create_balloon('balloon_inputs');
guidata(hObject, handles);


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
handles.wind = wind;
handles.ascent = rockoon_ascent2('ascent_inputs');
guidata(hObject, handles);


% --- Executes on button press in Launch_Button.
function Launch_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Launch_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

theta_0 = str2double(get(handles.theta_0,'String'));
Drocket = str2double(get(handles.Drocket,'String')) * 0.001;
rasaero_filename = get(handles.rasaero_filename,'String');
rocksim_filename = get(handles.rocksim_filename,'String');

vx_0 = norm([handles.ascent.vx(end), handles.ascent.vy(end)]);
sz_0 = handles.ascent.sz(end);
long0 = handles.ascent.long(end);
lat0 = handles.ascent.lat(end);

balloon = handles.balloon;
wind = handles.wind;
rasaero = load_RASAero_aeroplot1(rasaero_filename);
rocksim = load_rocksim(rocksim_filename);
savex('launch_inputs.mat','hObject','eventdata','handles');

%run ascent code.  save output to guidata
handles.launch = rockoon_launch2('launch_inputs');
guidata(hObject, handles);


% --- Executes on button press in Descent_Button.
function Descent_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Descent_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alt_chute = str2double(get(handles.alt_chute,'String')) * 0.3048;
Dparachute = str2double(get(handles.Dparachute,'String')) * 0.0254;
Drocket = str2double(get(handles.Drocket,'String')) * 0.001;
Afin = str2double(get(handles.Afin,'String')) * 0.00064516;

wind = handles.wind;
mass = handles.balloon.m_payload;
long0 = handles.launch.long(end);
lat0 = handles.launch.lat(end);
alt0 = handles.launch.sz(end);
vx0 = handles.launch.vxx(end);
vy0 = handles.launch.vyy(end);
savex('descent_inputs.mat','hObject','eventdata','handles');

%run ascent code.  save output to guidata
handles.descent = rockoon_descent2('descent_inputs');
guidata(hObject, handles);

%% Formulate trajectory
ascent = handles.ascent;
launch = handles.launch;
descent = handles.descent;
t = ascent.t;
t = [t; t(end) + launch.t];
t = [t; t(end) + descent.t1];
t = [t; t(end) + descent.t2];
sx = ascent.sx;
sx = [sx; sx(end) + launch.sxx];
sx = [sx; sx(end) + descent.sx1];
sx = [sx; sx(end) + descent.sx2];
sy = ascent.sy;
sy = [sy; sy(end) + launch.syy];
sy = [sy; sy(end) + descent.sy1];
sy = [sy; sy(end) + descent.sy2];
sz = [ascent.sz; launch.sz; descent.sz1; descent.sz2];
long = [ascent.long'; launch.long'; descent.long1'; descent.long2'];
lat = [ascent.lat'; launch.lat'; descent.lat1'; descent.lat2'];

%trajectory = [sz, long, lat];

%% Plots

figure(10)
xlabels{1} = 'Ground Course (degrees)';
xlabels{2} = 'Windspeed (mph)';
ylabels{1} = 'Altitude (feet)';
ylabels{2} = 'Altitude (feet)';
[ax,L1,L2] = plotxx([ascent.gc, launch.gc], [ascent.sz; launch.sz]*3.28084, ...
                    [ascent.gs, launch.gs]*2.23694, [ascent.sz; launch.sz]*3.28084, ...
                    xlabels,ylabels);
hold all
L3 = plot(get(gca,'xlim'), launch.sz(1)*ones(1,2)*3.28084 ); %plot horizontal line
L4 = plot(get(gca,'xlim'), launch.sz(end)*ones(1,2)*3.28084 ); %plot horizontal line
legend([L3 L4],'Rocket Launch','Rocket Apogee')
title('Sounding Wind Data')
grid on

figure(11)
color_line(sx*0.000621371,sy*0.000621371,sz*3.28084);
axis equal
xlabel('x-distance (miles)')
ylabel('y-distance (miles)')
title('Mission Trajectory')
cb = colorbar('peer',gca);
set(get(cb,'ylabel'),'String', 'Altitude (feet)');
grid on

figure(12)
plot(t*0.0166667,sz*3.28084)
xlabel('t-time (minutes)')
ylabel('Altitude (ft)')
grid on

m=1;
for n = 1:1:length(sz)
    if mod(n,4) == 0
        a(m) = sz(n);
        b(m) = long(n);
        c(m) = lat(n);
        m = m+1;
    end
end
trajectory = [a; b; c]';
assignin('base','trajectory',trajectory);


% --- Executes on button press in Run_Sim_Button.
function Run_Sim_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Sim_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1, 'pointer', 'watch')
drawnow;

callback = get(handles.Create_Balloon_Button,'Callback');
feval(callback,hObject, handles)

callback = get(handles.Ascent_Button,'Callback');
feval(callback,hObject, handles)

callback = get(handles.Launch_Button,'Callback');
feval(callback,hObject, handles)

callback = get(handles.Descent_Button,'Callback');
feval(callback,hObject, handles)

set(handles.figure1, 'pointer', 'arrow')


















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

function alt0_Callback(hObject, eventdata, handles)
% hObject    handle to alt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


function V_H2_surplusfill_Callback(hObject, eventdata, handles)
% hObject    handle to V_H2_surplusfill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after settng all properties.
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



function theta_0_Callback(hObject, eventdata, handles)
% hObject    handle to theta_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_0 as text
%        str2double(get(hObject,'String')) returns contents of theta_0 as a double


% --- Executes during object creation, after setting all properties.
function theta_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Drocket_Callback(hObject, eventdata, handles)
% hObject    handle to Drocket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Drocket as text
%        str2double(get(hObject,'String')) returns contents of Drocket as a double


% --- Executes during object creation, after setting all properties.
function Drocket_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Drocket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rasaero_filename_Callback(hObject, eventdata, handles)
% hObject    handle to rasaero_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rasaero_filename as text
%        str2double(get(hObject,'String')) returns contents of rasaero_filename as a double


% --- Executes during object creation, after setting all properties.
function rasaero_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rasaero_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rocksim_filename_Callback(hObject, eventdata, handles)
% hObject    handle to rocksim_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rocksim_filename as text
%        str2double(get(hObject,'String')) returns contents of rocksim_filename as a double


% --- Executes during object creation, after setting all properties.
function rocksim_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rocksim_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function alt_chute_Callback(hObject, eventdata, handles)
% hObject    handle to alt_chute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alt_chute as text
%        str2double(get(hObject,'String')) returns contents of alt_chute as a double


% --- Executes during object creation, after setting all properties.
function alt_chute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alt_chute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Dparachute_Callback(hObject, eventdata, handles)
% hObject    handle to Dparachute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Dparachute as text
%        str2double(get(hObject,'String')) returns contents of Dparachute as a double


% --- Executes during object creation, after setting all properties.
function Dparachute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dparachute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Afin_Callback(hObject, eventdata, handles)
% hObject    handle to Afin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Afin as text
%        str2double(get(hObject,'String')) returns contents of Afin as a double


% --- Executes during object creation, after setting all properties.
function Afin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Afin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

