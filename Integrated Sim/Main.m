run clc; clear; close all
addpath Common_Functions
addpath Config_Files\Wyoming_Sounding
addpath Balloon_Shape
addpath Ascent

%% Balloon Shape
run create_balloon

%determine variables to keep
balloon.V = V;                        %(m^3) balloon volume when deployed
balloon.m_balloon = S*wd;             %(kg) predicted balloon mass
balloon.m_total = S*wd + Wpayload/g;  %(kg) balloon and payload mass

%clear all variables but balloon struct
clearvars -except balloon

%% Ascent Calculator
run Ascent

%determine variables to keep
ascent.s = s;
ascent.v = v;
ascent.t = t;
ascent.Vgas = Vgas;

%clear all variables but balloon and ascent structs
%clearvars -except balloon ascent