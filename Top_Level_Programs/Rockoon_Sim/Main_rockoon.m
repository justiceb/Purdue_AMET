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
addpath(genpath(strcat(Parent,'Programs\Balloon_Shape')));
addpath(genpath(strcat(Parent,'Programs\Ascent_ZP_Balloon')));
addpath(genpath(strcat(Parent,'Programs\Rocket_3DOF')));
addpath(genpath(strcat(Parent,'Programs\Descent_Parachute')));

%% Inputs
input.m_payload = 0;                 %(kg)
input.m_balloon = 0;                 %(kg)
input.V_H2_surplus = 40 * 0.0283168; %(m^3) surplus volume of H2 added to balloon
input.lat0 =  40.416275;
input.long0 = -86.944016;
input.alt0 = 180;                    %(m)
input.Drocket = 54 * 0.001;          %(m) rocket body diameter
input.Afin = 0.0129032;              %(m^2) Aref for fin
input.alt_chute = 5000 * 0.3048;     %(m) parachute deployment altitude
input.Dparachute = 36 * 0.0254;      %(m) parachute diameter

%% Configs
config.wind = load_Wyoming_Sounding('12Z_05_May_2014.csv');
config.rasaero = load_RASAero_aeroplot1('RASAero_aeroplot1.csv');
config.rocksim = load_rocksim('rocksim.csv');

%% Balloon Shape
run create_balloon

%determine variables to keep
balloon.V = V;                        %(m^3) balloon volume when deployed
balloon.m_balloon = S*wd;             %(kg) predicted balloon mass
balloon.m_payload = Wpayload/g;       %(kg) payload mass
balloon.z = z;                        %(m) balloon height as a function of S
balloon.s = s;                        %(s) balloon gore length

%clear all variables but balloon struct
clearvars -except input config balloon

%% Ascent Calculator
run rockoon_ascent

%clear all variables but balloon and ascent structs
clearvars -except input config balloon ascent

%% Rockoon Launch
run rockoon_launch

%clear all variables but balloon and ascent structs
clearvars -except input config balloon ascent rockoon

%% Descent
run rockoon_descent

descent.t1 = t1;
descent.sx1 = sx1;
descent.sy1 = sy1;
descent.sz1 = sz1;
descent.long1 = long1;
descent.lat1 = lat1;

descent.t2 = t2;
descent.sx2 = sx2;
descent.sy2 = sy2;
descent.sz2 = sz2;
descent.long2 = long2;
descent.lat2 = lat2;

%clear all variables but balloon and ascent structs
clearvars -except input config balloon ascent rockoon descent

%% Formulate trajectory
t = ascent.t;
t = [t; t(end) + rockoon.t];
t = [t; t(end) + descent.t1];
t = [t; t(end) + descent.t2];
sx = ascent.sx;
sx = [sx; sx(end) + rockoon.sxx];
sx = [sx; sx(end) + descent.sx1];
sx = [sx; sx(end) + descent.sx2];
sy = ascent.sy;
sy = [sy; sy(end) + rockoon.syy];
sy = [sy; sy(end) + descent.sy1];
sy = [sy; sy(end) + descent.sy2];
sz = [ascent.sz; rockoon.sz; descent.sz1; descent.sz2];
long = [ascent.long'; rockoon.long'; descent.long1'; descent.long2'];
lat = [ascent.lat'; rockoon.lat'; descent.lat1'; descent.lat2'];

trajectory = [sz, long, lat];

%% Plots

figure(10)
xlabels{1} = 'Ground Course (degrees)';
xlabels{2} = 'Windspeed (mph)';
ylabels{1} = 'Altitude (feet)';
ylabels{2} = 'Altitude (feet)';
[ax,L1,L2] = plotxx([ascent.gc, rockoon.gc], [ascent.sz; rockoon.sz]*3.28084, ...
                    [ascent.gs, rockoon.gs]*2.23694, [ascent.sz; rockoon.sz]*3.28084, ...
                    xlabels,ylabels);
hold all
L3 = plot(get(gca,'xlim'), rockoon.sz(1)*ones(1,2)*3.28084 ); %plot horizontal line
L4 = plot(get(gca,'xlim'), rockoon.sz(end)*ones(1,2)*3.28084 ); %plot horizontal line
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






