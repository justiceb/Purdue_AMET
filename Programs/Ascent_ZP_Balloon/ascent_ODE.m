function [outputs, data] = ascent_ODE(t, inputs, balloon, wind, m_payload)

%define inputs and outputs
%ODE inputs = [sx, vx, sy, vy, xz, vz, m_H2, T_H2]
%ODE outputs = [vx, ax, vy, ay, vz, az, mdot_H2, Tdot_H2]
sx = inputs(1);     %(m)
vx = inputs(2);     %(m/s)
sy = inputs(3);     %(m)
vy = inputs(4);     %(m/s)
sz = inputs(5);     %(m)
vz = inputs(6);     %(m/s)
m_H2 = inputs(7);  %(kg)
T_H2 = inputs(8);  %(kg)

%% Constants
g = 9.807;                    %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
CP_air = 1.01*1000;           %j/kg-K
CV_air = 0.718*1000;          %j/kg-K
CP_H2 = 14.32*1000;           %j/kg-K
CV_H2 = 10.16*1000;           %j/kg-K
gamma_H2 = CP_H2 / CV_H2;     %ratio of specific heats

%% Gas properties 
%Ambient Gas Properties --> f(altitude)
[rho_air,~,T_air,P_air,nu_air]=stdatmo(sz);      %SI  (standard atmosphere)
mu_air = nu_air * rho_air;                       %SI dynamic viscosity for air
mu_H2 = 386.9E-5*(T_H2/273.15)^1.5 * (T_H2+650.4)/((T_H2+19.6)*(T_H2+1176));  %kg/m-s where T is in K
k_air = 0.0241*(T_air/273.15)^(0.9);             %SI conductivity of air
k_H2 = 1.2*0.144*(T_H2/273.15)^(0.7);            %SI conductivity of H2
Pr_air = CP_air*mu_air/k_air;                    %SI prandtl number for air
Pr_H2 = CP_H2*mu_H2/k_H2;                    %SI prandtl number for air

%Unconstrained gas properties
rho_H2_avg = P_air/(R_H2*T_H2);
volume_H2 = m_H2/rho_H2_avg;

%Constrained gas properties --> if gas volume exceeds balloon volume
rho_H2_avg_constrained = m_H2/balloon.V;
P_H2_avg_constrained = rho_H2_avg_constrained * R_H2 * T_H2;
dP_constrained = P_H2_avg_constrained - P_air;
b_constrained = g*(rho_air-rho_H2_avg_constrained);
dp_base = dP_constrained - b_constrained*(balloon.z(end)/2);
    if dp_base < 0
        dp_base = 0;
        volume = volume_H2;
    else
        rho_H2_avg = rho_H2_avg_constrained;
        volume = balloon.V;
    end

%% Balloon Shape
diameter = 2.23*((0.75/pi)*(m_H2/rho_H2_avg))^(1/3);  %(m) balloon diameter
Atop = (pi/4)*diameter^2;                             %(m^2) balloon top reference area
Asurf = 2.582*diameter^2;
Lgoreb = 1.37*diameter;
Asurf1 = 4.94*balloon.V^(2/3) * (1-cos(pi*Lgoreb/balloon.s(end)));
Aeffective = 0.65*Asurf + 0.35*Asurf1;

%% Mass flow rate
Cdischarge_base = 0.6;
Abase = 0.003;                                                       %(m^2) area at the base of the balloon
mdot_H2_base = -Abase*Cdischarge_base*sqrt(2*dp_base*rho_H2_avg);    %(km/s) discharge rate of hydrogen gas

Cdischarge_hole = 0.6;
Ahole = 0.000045;
x_hole = 0.75;
dp_hole = dp_base + g*(rho_air-rho_H2_avg)*x_hole*diameter;
mdot_H2_hole = -Ahole*Cdischarge_hole*sqrt(2*dp_hole*rho_H2_avg);

mdot_H2 = mdot_H2_base + mdot_H2_hole;

%% calculate net vertical acceleration
CD = 0.8;
Aref = Atop;
L = (rho_air - rho_H2_avg) * g * volume;           %(N)
W = (balloon.m_balloon + m_payload) * g;           %(N)
Dz = (1/2) * rho_air * vz^2 * CD * Aref;           %(N)
Fnet_z = L-W-Dz;                                   %(N)
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

%% Temperature differential equation
Tfilm = mean([T_air, T_H2]);
HCinternal = 0.13*k_H2*((rho_H2_avg^2*g*abs(Tfilm-T_H2)*Pr_H2)/(T_H2*mu_air^2))^(1/3);
Qconvint = HCinternal * Aeffective * (Tfilm - T_H2);
Qburner = 0;
Tdot_H2 = ((Qconvint + Qburner)/m_H2 - g*(T_H2/T_air)*(R_H2/R_air)*vz) * (1/CP_H2);

%% format outputs
outputs = [vx, ax, vy, ay, vz, az, mdot_H2, Tdot_H2]';
data.L = L;
data.W = W;
data.Dz = Dz;
data.Fnet_z = Fnet_z;
data.az = az;
data.volume_H2 = volume_H2;
data.volume = volume;
data.mdot_H2 = mdot_H2;
data.Tdot_H2 = Tdot_H2;
data.gc = gc;
data.gs = gs;
data.dp_base = dp_base;
data.T_air = T_air;
data.Tfilm = Tfilm;
data.HCinternal = HCinternal;
data.Qconvint = Qconvint;
data.Aeffective = Aeffective;
data.mdot_H2_base = mdot_H2_base;
data.mdot_H2_hole = mdot_H2_hole;
end







%% Old code, keep for legacy

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

%{
F = @(x) [x(1) - (g*(rho_air-x(3))*0.834*((0.75/pi)*(m_H2/x(3)))^(1/3));...
          x(2) - (P_air + x(1));...
          x(3) - (x(2)/(R_H2*T_H2_avg));];
x = fsolve(F,[1,P_air,rho_H2_amb],optimoptions('fsolve','Display','off'));
dP = x(1);
P_H2_avg = x(2);
rho_H2_avg = x(3);
%}

