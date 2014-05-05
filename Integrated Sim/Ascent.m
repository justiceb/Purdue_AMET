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
V_H2_surplus = 40 * 0.0283168;                          %(m^3) surplus volume of H2 added to balloon
alt0 = 180;                                             %(m) launch elevation
m_balloon = balloon.m_balloon;                          %(kg) measured balloon mass
m_payload = balloon.m_total - balloon.m_balloon;        %(kg) measured payload mass
lat0 =  40.416275;
long0 = -86.944016;

%constant
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
r_earth = 6371000;            %(m) earth radius

% Load wind config file
wind = load_Wyoming_Sounding('12Z_19_April_2014.csv');

%Modify Wind data to SI units and standard polar axes
wind.SKNT = wind.SKNT*0.514444;              %convert windspeed to m/s
wind.DRCT = -wind.DRCT+270;                   %convert to degrees where 0=east, 90=north

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
%timerange = [0 50000];
dt = 0.5; %s
timerange = 0:dt:50000;
init = [alt0, 0.001, m_H2_0, 0, 0, 0, 0];
options = odeset('Events',@detect_apogee,'RelTol',1E-6);
[t, outputs] = ode45(@ascent_calc, timerange, init, options, m_system, balloon.V, wind, dt);

%extract outputs
s = outputs(:,1);
v = outputs(:,2);
m_H2 = outputs(:,3);
sx = outputs(:,4);
vx = outputs(:,5);
sy = outputs(:,6);
vy = outputs(:,7);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(s)
    inputs = [s(n), v(n), m_H2(n), sx(n), vx(n), sy(n), vy(n)];
    [outputs, data] = ascent_calc(t(n), inputs, m_system, balloon.V, wind, dt);
    L(n) = data.L;
    W(n) = data.W;
    D(n) = data.D;
    Fnet(n) = data.Fnet;
    a(n) = data.a;
    Vgas(n) = data.Vgas;
    m_H2_real(n) = data.m_H2;
    CD(n) = data.CD;
    RE(n) = data.RE;
    mdot_H2(n) = data.mdot_H2;
end

%% Convert x,y distances to GPS coordinates
long = long0;
lat = lat0;
for n = 1:1:length(sx)
    if n==1
    else
        dx = sx(n) - sx(n-1);        %(m) change in x position during this time slice
        dy = sy(n) - sy(n-1);        %(m) change in y position during this time slice
        
        meters_per_deg_long = (2*pi/360) * r_earth * cosd(lat(end));  %(m/deg) long
        meters_per_deg_lat = (2*pi/360) * r_earth;                   %(m/deg) lat
        
        dlong = dx / meters_per_deg_long;   %(deg)
        dlat = dy / meters_per_deg_lat;   %(deg)
        
        long(n) = long(end) + dlong;
        lat(n) = lat(end) + dlat;
    end
end
trajectory = [s long' lat'];

%run C:\AMET\hab10_analysis\hab10
%% Make some plots
f3 = figure(3);
subplot(3,2,1)
plot(t,s*3.28084)
xlabel('time (s)')
ylabel('altitude (ft)')
grid on
hold all
%plot(aprs.t0,aprs.altitude*3.28084)
%legend('simulated','actual')

subplot(3,2,2)
plot(t,L,t,W,t,D,t,Fnet)
xlabel('time (s)')
ylabel('Force (N)')
grid on
legend('Lift','Weight','Drag','Fnet')

subplot(3,2,3)
plot(t,v)
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
color_line(sx*0.000621371,sy*0.000621371,s*3.28084);
axis equal
xlabel('x-distance (miles)')
ylabel('y-distance (miles)')
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Altitude (feet)');
grid on





















