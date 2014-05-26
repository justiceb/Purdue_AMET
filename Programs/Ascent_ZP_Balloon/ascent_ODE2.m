function [outputs, data] = ascent_ODE2(t, inputs, balloon, wind, m_payload)

%define inputs and outputs
%ODE inputs = [sx, vx, sy, vy, xz, vz, m_H2]
%ODE outputs = [vx, ax, vy, ay, vz, az, mdot_H2]
%m_h2 = mass of filled hydrogen (kg)
sx = inputs(1);     %(m)
vx = inputs(2);     %(m/s)
sy = inputs(3);     %(m)
vy = inputs(4);     %(m/s)
sz = inputs(5);     %(m)
vz = inputs(6);     %(m/s)
m_H2 = inputs(7);  %(kg)

%% Constants
g = 9.807;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

%% Gas properties 
%Ambient Gas Properties --> f(altitude)
[rho_air,~,T_air,P_air]=stdatmo(sz);                     %SI  (standard atmosphere)
[rho_H2_amb]=stdatmo_H2(sz);                     %SI  (standard atmosphere)

%Unconstrained gas properties --> H2 pressureized by balloon
T_H2_avg = T_air;                                                       %(K) H2 temperature = ambient air T

F = @(x) [x(1) - (g*(rho_air-x(3))*0.834*((0.75/pi)*(m_H2/x(3)))^(1/3));...
          x(2) - (P_air + x(1));...
          x(3) - (x(2)/(R_H2*T_H2_avg));];
x = fsolve(F,[1,P_air,rho_H2_amb],optimoptions('fsolve','Display','off'));
dP = x(1);
P_H2_avg = x(2);
rho_H2_avg = x(3);

%Constrained gas properties --> if gas volume exceeds balloon volume
volume_H2 = m_H2/rho_H2_avg;

t
sz
dP
P_H2_avg
P_air
rho_H2_avg
rho_air
balloon.V
volume_H2


if volume_H2 > balloon.V
    rho_H2_avg = m_H2/balloon.V;
    P_H2_avg = rho_H2_avg * R_H2 * T_H2_avg;
    dP = P_H2_avg - P_air;
    b = g*(rho_air-rho_H2_avg);
    dp_base = dP - 0.5*b*(balloon.z(end)/2);
    volume = balloon.V;
    
    rho_H2_avg
    P_H2_avg
    dP
    b
    dp_base
    
    
else
    dp_base = 0;
    volume = volume_H2;
end

%% Mass flow rate
Cdischarge = 0.6;
Aduct = 0.003;                                               %(m^2) area at the base of the balloon
mdot_H2 = -Aduct*Cdischarge*sqrt(2*dp_base*rho_H2_avg)    %(km/s) discharge rate of hydrogen gas

%% Balloon Shape
diameter = 2.23*((0.75/pi)*(m_H2/rho_H2_avg))^(1/3);  %(m) balloon diameter
Atop = (pi/4)*diameter^2;                             %(m^2) balloon top reference area

%% calculate net vertical acceleration
CD = 0.8;
Aref = Atop;
L = (rho_air - rho_H2_avg) * g * volume;   %(N)
W = (balloon.m_balloon + m_payload) * g;           %(N)
Dz = (1/2) * rho_air * vz^2 * CD * Aref;   %(N)
Fnet_z = L-W-Dz;                           %(N)
az = Fnet_z/(balloon.m_balloon+m_payload+m_H2);    %(m/s/s)

%% Process wind data
gc = interp1( wind.HGHT, wind.DRCT, sz, 'linear', 'extrap');    %interpolate for ground course
gs = interp1( wind.HGHT, wind.SPEED, sz, 'linear', 'extrap' );    %interpolate for ground course

vx_wind = gs * cosd(gc);  %(m/s) x-axis velocity during this time slice
vy_wind = gs * sind(gc);  %(m/s) y-axis velocity during this time slice

vx_inf = vx_wind - vx;   %(m/s) freestream airspeed
vy_inf = vy_wind - vy;   %(m/s) freestream airspeed

%% Horizontal Forces
CD = 0.8;
Aref = Atop;
Dx = (1/2) * rho_air * vx_inf^2 * CD * Aref * sign(vx_inf);
Dy = (1/2) * rho_air * vy_inf^2 * CD * Aref * sign(vy_inf);

ax = Dx/(balloon.m_balloon+m_payload+m_H2);
ay = Dy/(balloon.m_balloon+m_payload+m_H2);

%% format outputs
outputs = [vx, ax, vy, ay, vz, az, mdot_H2]';
data.L = L;
data.W = W;
data.Dz = Dz;
data.Fnet_z = Fnet_z;
data.az = az;
data.volume_H2 = volume_H2;
data.mdot_H2 = mdot_H2;
data.gc = gc;
data.gs = gs;
data.dp_base = dp_base;
end









%{
for n = 1:1:2
    dP = g*(rho_air-rho_H2_avg)*0.834*((0.75/pi)*(m_H2/rho_H2_avg))^(1/3);  %(N/m^2) average change in pressure between H2 and air
    P_H2_avg = P_air + dP;                                                  %(N/m^2) average H2 pressure
    if n==1
        %rho_H2_avg = double(solve(rho_H2_avg == P_H2_avg/(R_H2*T_H2_avg)));         %solve via ideal gas law
        F = rho_H2_avg - P_H2_avg/(R_H2*T_H2_avg);
        rho_H2_avg = fzero(matlabFunction(F),rho_H2_amb);
    end
end
%}

