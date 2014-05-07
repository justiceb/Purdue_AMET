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

%% Inputs
V_H2_surplus = input.V_H2_surplus;                      %(m^3) surplus volume of H2 added to balloon
m_balloon = balloon.m_balloon;                          %(kg) measured balloon mass
m_payload = balloon.m_payload;                          %(kg) measured payload mass
lat0 =  input.lat0;
long0 = input.long0;
alt0 = input.alt0;                                      %(m) launch elevation
wind = config.wind;

%constant
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

%% determine hydrogen mass to fill at launch
[rho_air,SOS,T,P,nu,ZorH]=stdatmo(alt0);   %SI  (standard atmosphere)
rho_H2 = P/(R_H2*T);                     %Ideal gas law, assume ambient pressure
m_system = m_balloon + m_payload;        %(kg) balloon and payload mass
W = m_system * g;                        %(N) total weight
Vmin = W/((rho_air - rho_H2) * g);       %(m^3) minimum hydrogen needed 
V_H2_0 = Vmin + V_H2_surplus;           %(m^3) volume of hydrogen filled at SL 
m_H2_0 = rho_H2 * V_H2_0;                 %(kg) mas of hydrogen filled at launch

fprintf('\n');
fprintf('Total Hydrogen to Fill = %f ft^3 \n',V_H2_0 * 35.3147);

%% run ode45 solver
sx0 = 0;
vx0 = 0;
sy0 = 0;
vy0 = 0;
sz0 = alt0;
vz0 = 0.001;
init = [sx0, vx0, sy0, vy0, sz0, vz0, m_H2_0];
dt = 1; %s
timerange = 0:dt:50000;
options = odeset('Events',@detect_apogee,'RelTol',1E-3);
[t, outputs] = ode45(@ascent_calc, timerange, init, options, m_system, balloon.V, wind, dt);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sy = outputs(:,3);
vy = outputs(:,4);
sz = outputs(:,5);
vz = outputs(:,6);
m_H2 = outputs(:,7);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sz)
    inputs = [sx(n), vx(n), sy(n), vy(n), sz(n), vz(n), m_H2(n)];
    [outputs, data] = ascent_calc(t(n), inputs, m_system, balloon.V, wind, dt);
    L(n) = data.L;
    W(n) = data.W;
    Dz(n) = data.Dz;
    Fnet_z(n) = data.Fnet_z;
    az(n) = data.az;
    Vgas(n) = data.Vgas;
    mdot_H2(n) = data.mdot_H2;
    gc(n) = data.gc;
    gs(n) = data.gs;
end

%% Convert x,y distances to GPS coordinates
[ long, lat ] = dxdy_to_coordinates( sx, sy, long0, lat0 );
trajectory = [sz long' lat'];

%run C:\AMET\hab10_analysis\hab10
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
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Altitude (feet)');
grid on
















