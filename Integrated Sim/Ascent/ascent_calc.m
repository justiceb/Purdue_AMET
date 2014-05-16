function [outputs, data] = ascent_calc(t, inputs, m_system, Vdeployed, wind, dt)

%define inputs and outputs
%inputs = [sx, vx, sy, vy, xz, vz, m_H2]
%outputs = [vx, ax, vy, ay, vz, az, mdot_H2]
%m_h2 = mass of filled hydrogen (kg)
%m_system = balloon and payload mass (kg)
%Vdeployed = volume of balloon when deployed (m^3)
sx = inputs(1);     %(m)
vx = inputs(2);     %(m/s)
sy = inputs(3);     %(m)
vy = inputs(4);     %(m/s)
sz = inputs(5);     %(m)
vz = inputs(6);     %(m/s)
m_H2 = inputs(7);  %(kg)

%constants
volume_flux = -0.000011;      %[m^3/m^2-s]
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
CD =  0.47; 

%% get gas properties
[rho_air,SOS,T,P,nu,ZorH]=stdatmo(sz);     %SI  (standard atmosphere)
mu = nu * rho_air;                       %dynamic viscosity of air
rho_H2 = P/(R_H2*T);                    %Ideal gas law, assume ambient pressure

%% Determine Vgas and calc mdot_H2
Vgas = m_H2 / rho_H2;        %(m^3) gas volume
R = (Vgas*(3/4)/pi)^(1/3);   %(m)
SA = 4*pi*R^2;               %(m^2)
m_flux = volume_flux * rho_H2;    %(kg/m^2-s)
mdot_H2 = m_flux * SA;            %(kg/s)

%% check to see if we are fully deployed yet
if Vgas >= Vdeployed
    Vgas = Vdeployed;
    m_H2_constrained = Vgas * rho_H2;
    mdot_H2 = (m_H2_constrained - m_H2)/dt;
    m_H2 = m_H2_constrained;
end

%% Calculate reference area --> asume spherical balloon
r = (Vgas*(3/4)/pi)^(1/3);    %theoretical balloon radius
Aref = pi * (r)^2;              %reference area

%% calculate net vertical acceleration
L = (rho_air - rho_H2) * g * Vgas;         %(N)
W = m_system * g;                           %(N)
Dz = (1/2) * rho_air * vz^2 * CD * Aref;     %(N)
Fnet_z = L - W -Dz;                           %(N)
az = Fnet_z/m_system;                          %(m/s/s)

%% Process wind data
gc = interp1( wind.HGHT, wind.DRCT, sz, 'linear', 'extrap');    %interpolate for ground course
gs = interp1( wind.HGHT, wind.SPEED, sz, 'linear', 'extrap' );    %interpolate for ground course

vx_wind = gs * cosd(gc);  %(m/s) x-axis velocity during this time slice
vy_wind = gs * sind(gc);  %(m/s) y-axis velocity during this time slice

vx_inf = vx_wind - vx;   %(m/s) freestream airspeed
vy_inf = vy_wind - vy;   %(m/s) freestream airspeed

%% Horizontal Forces
Dx = (1/2) * rho_air * vx_inf^2 * CD * Aref * sign(vx_inf);
Dy = (1/2) * rho_air * vy_inf^2 * CD * Aref * sign(vy_inf);

ax = Dx/(m_system + m_H2);
ay = Dy/(m_system + m_H2);

%% format outputs
outputs = [vx, ax, vy, ay, vz, az, mdot_H2]';
data.L = L;
data.W = W;
data.Dz = Dz;
data.Fnet_z = Fnet_z;
data.az = az;
data.Vgas = Vgas;
data.m_H2 = m_H2;
data.mdot_H2 = mdot_H2;
data.gc = gc;
data.gs = gs;
end



