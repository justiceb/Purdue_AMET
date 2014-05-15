function data = load_rasaero_sim(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [TIMESEC,MACH,CD1,THRUSTLB,WEIGHTLB,DRAGLB,ACCELRFTSEC2,ACCELVFTSEC2,ACCELHFTSEC2,VELRFTSEC,VELVFTSEC,VELHFTSEC,ALTITUDEFT,DISTANCEFT]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [TIMESEC,MACH,CD1,THRUSTLB,WEIGHTLB,DRAGLB,ACCELRFTSEC2,ACCELVFTSEC2,ACCELHFTSEC2,VELRFTSEC,VELVFTSEC,VELHFTSEC,ALTITUDEFT,DISTANCEFT]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [Timesec,Mach,CD1,Thrustlb,Weightlb,Draglb,AccelRftsec2,AccelVftsec2,AccelHftsec2,VelRftsec,VelVftsec,VelHftsec,Altitudeft,Distanceft]
%   = importfile('rasaero_sim.CSV',2, 6116);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/05/15 18:57:26

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
data.t = dataArray{:, 1};
data.Mach = dataArray{:, 2};
data.CD1 = dataArray{:, 3};
data.Thrustlb = dataArray{:, 4};
data.Weightlb = dataArray{:, 5};
data.Draglb = dataArray{:, 6};
data.AccelRftsec2 = dataArray{:, 7};
data.AccelVftsec2 = dataArray{:, 8};
data.AccelHftsec2 = dataArray{:, 9};
data.VelRftsec = dataArray{:, 10};
data.VelVftsec = dataArray{:, 11};
data.VelHftsec = dataArray{:, 12};
data.Altitudeft = dataArray{:, 13};
data.Distanceft = dataArray{:, 14};

data.Thrust = data.Thrustlb * 4.44822162; %N
data.Weight = data.Weightlb * 4.44822162; %N
data.Drag = data.Draglb * 4.44822162; %N
data.az = data.AccelVftsec2 * 0.3048; %m/s^2
data.ax = data.AccelHftsec2 * 0.3048; %m/s^2
data.vz = data.VelVftsec * 0.3048; %m/s^2
data.vx = data.VelHftsec * 0.3048; %m/s^2
data.sz = data.Altitudeft * 0.3048; %m
data.sx = data.Distanceft * 0.3048; %m


