function [ aprs ] = APRS_analyze( file, plots)
% Author - Brent Justice 5/21/2014
% This function analyzes an APRS dataset
% INPUTS:
%         file = string name of APRS file EX --> 'aprs_export.csv'
%                note that the APRS file MUST have the t0 column
%                with the following excel formula: =(A2-DATE(1970,1,1))*86400
%         plots == 1 if user wants function to draw plots
%

%% Include external functions
addpath sub_functions

%% load APRS dataset
aprs = load_aprs(file);                    %load aprs data

%% Determine Apogee
[~,Iapogee] = max(aprs.altitude);

%% Calculate vertical velocity
aprs.vz(1) = 0;                                                 %(m/s)
for n = 2:1:length(aprs.t0)
   dt = aprs.t0(n) - aprs.t0(n-1);
   aprs.vz(n) = (aprs.altitude(n) - aprs.altitude(n-1) )/dt;   %(m/s)
end

%% Determine Horizontal Distances
[ aprs.sx, aprs.sy ] = coordinates_to_dxdy( aprs.lng, aprs.lat );

%% Prepare trajectory for google earth inut
aprs.trajectory = [aprs.altitude, aprs.lng, aprs.lat];

%% Plots
if plots == 1
    figure(1)
    plot(aprs.t0_hrs,aprs.altitudeFT)
    xlabel('time (hours)')
    ylabel('Altitude (ft)')
    grid on

    figure(2)
    plot(aprs.t0_hrs(1:Iapogee),aprs.vz(1:Iapogee),...
        aprs.t0_hrs(Iapogee),aprs.vz(Iapogee),'o',...
        aprs.t0_hrs(Iapogee:end),aprs.vz(Iapogee:end))
    xlabel('time (hours)')
    ylabel('Vertical Velocity (m/s)')
    grid on
    legend('Ascent','Apogee','Descent')

    figure(3)
    xlabels{1} = 'Ground Course (degrees)';
    xlabels{2} = 'Groundspeed (mph)';
    ylabels{1} = 'Altitude (feet)';
    ylabels{2} = 'Altitude (feet)';
    [ax,L1,L2] = plotxx(aprs.course(1:Iapogee), aprs.altitudeFT(1:Iapogee), ...
                        aprs.speedMPH(1:Iapogee), aprs.altitudeFT(1:Iapogee), ...
                        xlabels,ylabels);
    title('Sounding Wind Data (Ascent ONLY)')
    grid on

    figure(4)
    xlabels{1} = 'Ground Course (degrees)';
    xlabels{2} = 'Groundspeed (mph)';
    ylabels{1} = 'Altitude (feet)';
    ylabels{2} = 'Altitude (feet)';
    [ax,L1,L2] = plotxx(aprs.course(Iapogee:end), aprs.altitudeFT(Iapogee:end), ...
                        aprs.speedMPH(Iapogee:end), aprs.altitudeFT(Iapogee:end), ...
                        xlabels,ylabels);
    title('Sounding Wind Data (Descent ONLY)')
    grid on

    figure(6)
    color_line(aprs.sx*0.000621371,aprs.sy*0.000621371,aprs.altitudeFT);
    axis equal
    xlabel('x-distance (miles)')
    ylabel('y-distance (miles)')
    title('Mission Trajectory')
    cb = colorbar('peer',gca);
    set(get(cb,'ylabel'),'String', 'Altitude (feet)');
    grid on
end

end

