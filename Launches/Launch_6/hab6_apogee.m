%kd9aiq
clc;
clear;
close all;

%% Load ARPS Data
aprs = load_aprs('APRS_6.csv');                    %load aprs data
%Modify APRS data to SI units
aprs.t0 = aprs.unix_time - aprs.unix_time(1);    %t clock in seconds
aprs.speed = aprs.speed*0.277778;                %convert speed to m/s
aprs.course = -aprs.course+90;                   %convert to degrees where 0=east, 90=north
[alt_apogee,i_apogee] = max(aprs.altitude);      %find apogee coordinate

%% User inputs
CD_vec = 0.1:0.1:2;             %iterate these CD values
m = 15 * 0.453592;              %kg  --> payload mass
%A = 11.5 * 8 * 0.00064516;      %m^2  cross section of parachute (or payload if no parachute)
A = pi * (6/2)^2 * 0.092903;      %m^2  cross section of parachute (or payload if no parachute)
i_lost = 28;                    %index where we ignore future GC data

%% Iterate values of CD
for q = 1:1:length(CD_vec)
    CD = CD_vec(q);        

    %sim inputs
    v0 = 0;                          %m/s --> initial velocity
    alt0 = alt_apogee;               %m  --> inital altitude
    t_stop = 3000;                   %s  --> simulation run time

    %run sim
    Simulink.sdi.clear
    clearvars simout
    sim('descent_model');

    %get sim data
    sim_a = simout.data(:,1);
    sim_v = simout.data(:,2);
    sim_s = simout.data(:,3);
    
        %{
        %get velocity at last data point on descent.  call this point "1"
        alt_1 = aprs.altitude(end);      %last altitude point on descent
        v0_1 = interp1(sim_s,sim_v,alt_1)  %interpolate sim data to get velocity at point 1
        
        %sim inputs startijg sim at point 1
        v0 = v0_1;   %set vo to vo_1
        alt0 = alt_1;  %set alt to alt_1
        
        %run sim
        Simulink.sdi.clear
        clearvars simout
        sim('descent_model');

        %get sim data
        sim_a = simout.data(:,1);
        sim_v = simout.data(:,2);
        sim_s = simout.data(:,3);
        %}

    %Plot sim data
    figure(1)
    subplot(2,2,1)
    plot(simout.time,sim_a)
    hold all
    xlabel('time (s)')
    ylabel('vertical acceleration (m/s/s)')
    grid on

    subplot(2,2,2)
    plot(simout.time,sim_v)
    hold all
    xlabel('time (s)')
    ylabel('vertical velocity (m/s)')
    grid on

    subplot(2,2,3)
    plot(simout.time,sim_s)
    hold all
    plot(aprs.t0(end) - aprs.t0(end-1),aprs.altitude(end),'o')
    xlabel('time (s)')
    ylabel('altitude (m)')
    grid on
    axis([-inf inf 0 inf]) 
    
    n = 1;   %loop counter
    sx = 0;  %set x origin to apogee
    sy = 0;  %set y position to apogee
    %calculate horizontal drift during descent
    while sim_s(n) > 0                               %while we haven't landed
        
        if  sim_s(n) > aprs.altitude(i_lost)      
            gc = aprs.course(i_lost);                                                                   %use last reputable ground speed
        else
            gc = interp1([0; aprs.altitude(1:i_apogee)] , [0; aprs.course(1:i_apogee)] , sim_s(n) );    %interpolate for ground course
        end
    
        gs = interp1([0; aprs.altitude(1:i_apogee)] , [0; aprs.speed(1:i_apogee)] , sim_s(n) );         %interpolate for ground speed
        dt = simout.time(n+1) - simout.time(n);                                                         %[s] time slice
    
        vx = gs * cosd(gc);  %x-axis velocity during this time slice
        vy = gs * sind(gc);  %y-axis velocity during this time slice
    
        dx = vx * dt;        %change in x position during this time slice
        dy = vy * dt;        %change in y position during this time slice
    
        sx(n+1) = sx(n) + dx;  %new x poxistion
        sy(n+1) = sy(n) + dy;  %new y position
    
        n = n+1;
    end

    figure(4)
    plot(sx*0.000621371,sy*0.000621371)
    hold all
    xlabel('latitude distance (miles)')
    ylabel('longituide distance (miles)')
    grid on
    axis equal

    dx_2_long = 1/60/1412;  %convert dx (meters) to dx (degrees long)
    dy_2_lat = 1/60/1853;   %convert dy (meters) to dy (degrees lat)

    out.long = sx * dx_2_long + aprs.lng(i_apogee);  %3d path from apogee to landing for THIS CD
    out.lat = sy * dy_2_lat + aprs.lat(i_apogee);    %3d path from apogee to landing for THIS CD
    out.alt = sim_s(1:n);                            %3d path from apogee to landing for THIS CD

    long_landing(q) = out.long(end);                 %landing coordinates as function of CD
    lat_landing(q) = out.lat(end);                   %landing coordinates as function of CD

    %Output 3D path for the specified CD
    if CD == 1
        descent_path = [[aprs.altitude(1:i_apogee); out.alt] ...
                       [aprs.lng(1:i_apogee); out.long']     ...
                       [aprs.lat(1:i_apogee); out.lat']]
    end

end

%display landing coordinates as a function of CD
landing_path = [[aprs.lat(i_apogee) lat_landing]; [aprs.lng(i_apogee) long_landing]]'

