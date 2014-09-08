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
addpath(genpath(strcat(Parent,'Programs\Balloon_Shape')));
addpath(genpath(strcat(Parent,'Programs\Ascent_ZP_Balloon')));

%% Load APRS dataset and analyze
aprs = APRS_analyze('APRS_8.csv',1);
