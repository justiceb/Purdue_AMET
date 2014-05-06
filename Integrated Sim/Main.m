run clc; clear; close all
addpath Common_Functions
addpath_recurse('Config_Files')
addpath Balloon_Shape
addpath Ascent
addpath Rockoon_Flight

%% Balloon Shape
run create_balloon

%determine variables to keep
balloon.V = V;                        %(m^3) balloon volume when deployed
balloon.m_balloon = S*wd;             %(kg) predicted balloon mass
balloon.m_total = S*wd + Wpayload/g;  %(kg) balloon and payload mass
balloon.z = z;

%clear all variables but balloon struct
clearvars -except balloon

%% Ascent Calculator
run Ascent

%determine variables to keep
ascent.s = s;
ascent.v = v;
ascent.t = t;
ascent.lat = lat;
ascent.long = long;
ascent.wind = wind;

%clear all variables but balloon and ascent structs
clearvars -except balloon ascent

%% Rockoon Launch
run rockoon_launch

rockoon.sz = sz;
rockoon.long = long;
rockoon.lat = lat;

%clear all variables but balloon and ascent structs
clearvars -except balloon ascent rockoon

%% Descent
run Descent

descent.sz = sz;
descent.long = long;
descent.lat = lat;

%clear all variables but balloon and ascent structs
%clearvars -except balloon ascent rockoon descent

%% Formulate trajectory
trajectory = [[ascent.s;rockoon.sz;descent.sz] [ascent.long'; rockoon.long'; descent.long'] [ascent.lat'; rockoon.lat'; descent.lat']];













