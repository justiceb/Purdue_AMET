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

%% Run flight prediction
run hab6_55

%% Load and analyze APRS dataset
aprs = APRS_analyze('APRS_6.csv',0);

%% Calcs
%parse ardupilot data
ardu.raw = load('IGNITOR_trunc.TXT');
ardu.time = ardu.raw(:,1)*0.001;      %s;
ardu.press = ardu.raw(:,9);

%sync ardu t-clock with aprs t-clock
ardu.t0 = ardu.time - ardu.time(1) - 532.08;   %s t-clock
ardu.t0_hrs = ardu.t0*0.000277778;    %hours

%Interpolate standard atmosphere to find pressure altitude
Hchart = 0:0.01:35;                    %km
Pchart = atmo_p(Hchart);               %Pa
ardu.alt = interp1(Pchart,Hchart,ardu.press)*1000;  %m

figure(3)
plot(ardu.t0_hrs,ardu.press)
xlabel('time (hrs)')
ylabel('Pressure (Pa)')
grid on
title('Pressure Altitude --> datalogger')

figure(4)
plot(aprs.t0_hrs,aprs.altitude*3.28084,'o',ardu.t0_hrs,ardu.alt*3.28084,simout.time*0.000277778+2.124,sim_s*3.28084)
xlabel('time (hours)')
ylabel('Altitude (ft)')
grid on
legend('APRS GPS (telemetered)','Pressure Altitude (data logged)','Prediction Altitde (CD = 1)')
