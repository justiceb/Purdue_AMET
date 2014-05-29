%% Ascent Calculator
%{
Calculate ascent rate of the balloon.  Assume that we have measured the
GLOW.  Compute the minimum required hydrogen for bouyancy, and then add
user defined surplus hydrogen.  Starting from sea level, the balloon will
have constant lift until it is fully deployed.  We assume that once fully
deployed, the balloon has the same volume as it's designed apogee volume.
The balloon will continue to climb and vent hydrogen while maintaining
constant volume.  Eventually, the balloon will establish neutral bouyancy
at apogee.
%}

%% Determine initial H2 mass
V_H2_fill = 10;  %(m)^3
[rho_H2_fill]=stdatmo_H2(0);
m_H2_0 = rho_H2_fill * V_H2_fill;

%% Run Ascent program
%variable inputs
sx_0 = 0;
vx_0 = 0;
sy_0 = 0;
vy_0 = 0;
sz_0 = input.alt0;
vz_0 = 0.001;
T_H2_0 = 15+273.15;
init_ODE = [sx_0, vx_0, sy_0, vy_0,sz_0, vz_0, m_H2_0, T_H2_0];

%run ODE
ascent = ascent_ODE_wrapper( init_ODE, balloon, config.wind, balloon.m_payload );

%% Convert x,y distances to GPS coordinates
[ ascent.long, ascent.lat ] = dxdy_to_coordinates( ascent.sx, ascent.sy, input.long0, input.lat0 );
ascent.trajectory = [ascent.sz ascent.long' ascent.lat'];

%% Plots
figure(3)
subplot(3,2,1)
plot(ascent.t,ascent.sz*3.28084)
xlabel('time (s)')
ylabel('altitude (ft)')
grid on

subplot(3,2,2)
plot(ascent.t,ascent.vz)
xlabel('time (s)')
ylabel('Ascent Rate (m/s)')
grid on

subplot(3,2,3)
plot(ascent.t,ascent.m_H2)
hold all
xlabel('time (s)')
ylabel('Hydrogen mass (kg)')
grid on

subplot(3,2,4)
plot(ascent.t,ascent.mdot_H2,ascent.t,ascent.mdot_H2_base,ascent.t,ascent.mdot_H2_hole)
xlabel('time (s)')
ylabel('hydrogen mass flow rate (kg/s)')
grid on
legend('sum','base','hole',0)

subplot(3,2,5)
plot(ascent.t,ascent.volume_H2)
xlabel('time (s)')
ylabel('Volume (m^3)')
grid on
hold all
plot(ascent.t,ones(1,length(ascent.t))*balloon.V)
legend('Constrained Hydrogen Volume','Balloon Volume',0)

subplot(3,2,6)
plot(ascent.t,ascent.T_H2-273.15,ascent.t,ascent.T_air-273.15,ascent.t,ascent.Tfilm-273.15)
xlabel('time (s)')
ylabel('Temperature (C)')
grid on
legend('H2 temp','air temp','film temp')

figure(4)
subplot(2,2,1)
plot(ascent.t,ascent.Tdot_H2)
xlabel('time (s)')
ylabel('Tdot (K/s)')
grid on

subplot(2,2,2)
plot(ascent.t,ascent.HCinternal)
xlabel('time (s)')
ylabel('HCinternal (Watts/m^2-K)')
grid on

subplot(2,2,3)
plot(ascent.t,ascent.Qconvint)
xlabel('time (s)')
ylabel('Qconvint (Watts)')
grid on

subplot(2,2,4)
plot(ascent.t,ascent.Aeffective)
xlabel('time (s)')
ylabel('Aeffective (m^2)')
grid on








%{
%% Make some plots
f3 = figure(3);
subplot(3,2,1)
plot(t,sz*3.28084)
xlabel('time (s)')
ylabel('altitude (ft)')
grid on
hold all
%plot(aprs.t0,aprs.altitude*3.28084)
%legend('simulated','actual')

subplot(3,2,2)
plot(t,L,t,W,t,Dz,t,Fnet_z)
xlabel('time (s)')
ylabel('Force (N)')
grid on
legend('Lift','Weight','Drag','Fnet')

subplot(3,2,3)
plot(t,vz)
xlabel('time (s)')
ylabel('ascent rate (m/s)')
grid on
hold all
%plot(aprs.t0,gps_vv)
%legend('simulated','actual')

subplot(3,2,4)
plot(t,Vgas)
ylabel('Gas Volume (m^3)')
xlabel('time (s)')
grid on

subplot(3,2,5)
plot(t,m_H2)
xlabel('time (s)')
ylabel('Hydrogen Mass (kg)')
grid on

subplot(3,2,6)
plot(t,mdot_H2)
xlabel('time (s)')
ylabel('rate of hydrogem mass loss (kg/s)')
grid on

figure(4)
color_line(sx*0.000621371,sy*0.000621371,sz*3.28084);
axis equal
xlabel('x-distance (miles)')
ylabel('y-distance (miles)')
title('Ascent Trajectory')
cb = colorbar('peer',gca);
set(get(cb,'ylabel'),'String', 'Altitude (feet)');
grid on
%}















