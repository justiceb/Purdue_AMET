clc; clear; close all;

%% Dependencies
Parent = pwd;
NAME = 'null';
while ~strcmp(NAME,'Matlab')
    [Parent,NAME,EXT] = fileparts(Parent);
end
Parent = strcat(Parent,'\',NAME,'\');

addpath(genpath(strcat(Parent,'Common_Functions')));
addpath(genpath(strcat(Parent,'Config_Files')));
addpath(genpath(strcat(Parent,'Programs\APRS_Analyze')));

%% Load APRS dataset and analyze
aprs = APRS_analyze('APRS_7.csv',1);

%% Load arduino data and crunch
ardu.raw = load('IGNITOR_trunc.TXT');
ardu.time = ardu.raw(:,1)*0.001;      %s;
ardu.t0 = ardu.time - ardu.time(1);   %s t-clock
ardu.t0_hrs = ardu.t0*0.000277778;    %hours
ardu.press = ardu.raw(:,9);

%Interpolate standard atmosphere to find pressure altitude
Hchart = 0:0.01:35;                    %km
Pchart = atmo_p(Hchart);               %Pa
ardu.alt = interp1(Pchart,Hchart,ardu.press);  %km

figure(7)
plot(ardu.t0_hrs,ardu.press)

figure(8)
plot(ardu.t0_hrs,ardu.alt)
