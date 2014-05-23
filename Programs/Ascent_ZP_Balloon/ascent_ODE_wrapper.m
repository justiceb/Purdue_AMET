function data = ascent_ODE_wrapper( init_ODE, balloon, wind, lat0, long0, Free_Lift0 )
%Created by Brent Justice
%5/15/2014
%
%Inputs
%init_ODE = [sx_0, vx_0, sy_0, vy_0,sz_0, vz_0, m_H2_0]
%   where sx,sy = horizontal distance [m]
%   where sz = vertical distance (altitude) [m]
%   where m_H2 = mass of hydrogen gas [kg]
%wind = parsed wind data --> forcing function on rocket
%balloon = struct with necessary balloon inputs

%% run ode45 solver
sx0 = 0;
vx0 = 0;
sy0 = 0;
vy0 = 0;
sz0 = alt0;
vz0 = 0.001;
init = [sx0, vx0, sy0, vy0, sz0, vz0, m_H2_0];
timerange = [0 inf];
options = odeset('Events',@detect_apogee,'RelTol',1E-3);
[t, outputs] = ode45(@ascent_ODE, timerange, init_ODE, options, m_system, balloon.V, wind, dt);





end

