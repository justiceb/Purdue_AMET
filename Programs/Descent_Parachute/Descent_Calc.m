function [outputs, data] = Descent_Calc(t, inputs, wind, CD, Aref, m, alt_end)

%define inputs and outputs
%inputs = [sx, vx, sy, vy, sz, vz]
%outputs = [vx, ax, vy, az, vz, az]
sx = inputs(1);
vx = inputs(2);
sy = inputs(3);
vy = inputs(4);
sz = inputs(5);
vz = inputs(6);

%% Constants
g = 9.81;  %m/s/s

%% Air properties
[rho_air,a_air,temp_air,press_air,kvisc,ZorH]=stdatmo(sz);   %SI units

%% Vertical Motion
Dz = (1/2) * rho_air * vz^2 * CD * Aref;
Fg = -m * g;
Fnet_z = Dz + Fg;
az = Fnet_z/m;

%% Wind Properties
gc = interp1( wind.HGHT, wind.DRCT, sz, 'linear', 'extrap');     %interpolate for ground course
gs = interp1( wind.HGHT, wind.SPEED, sz, 'linear', 'extrap' );    %interpolate for groundspeed

vx_wind = gs * cosd(gc);  %(m/s) x-axis velocity during this time slice
vy_wind = gs * sind(gc);  %(m/s) y-axis velocity during this time slice

vx_inf = vx_wind - vx;   %(m/s) freestream airspeed
vy_inf = vy_wind - vy;   %(m/s) freestream airspeed

%% Horizontal Forces
Dx = (1/2) * rho_air * vx_inf^2 * CD * Aref * sign(vx_inf);
Dy = (1/2) * rho_air * vy_inf^2 * CD * Aref * sign(vy_inf);

ax = Dx/m;
ay = Dy/m;

%% Tabulate output
outputs = [vx, ax, vy, ay, vz, az]';
data.Dz = Dz;
data.Dx = Dx;
data.Dy = Dy;
data.Fg = Fg;
data.ax = ax;
data.ay = ay;
data.az = az;
end

