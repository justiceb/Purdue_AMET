function ascent = rockoon_ascent2( input_filename )
%% Inputs (Mission Criteria)
load(input_filename) %load the following input parameters
%balloon              --> struct of all balloon creation variables
%wind                 --> struct of wind config data
%V_H2_surplusfill     --> m^3 excess hydrogen volume to be filled at launch
%alt0                 --> m launch altitude

%constants  (mission criteria and materials)
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

%% Pre-ODE Calculations
%hydrogen to be filled
[~,~,T0,P0]=stdatmo(alt0);                        %SI  (standard atmosphere)
rho_H2_0 = P0/(R_H2*T0);                          %Ideal gas law, assume ambient pressure
V_H2_minfill = balloon.m_H2 / rho_H2_0;           %m^3 minimum Hydrogen Volume at launch for bouyancy
V_H2_filltotal = V_H2_minfill + V_H2_surplusfill; %m^3 total Hydrogen Volume at launch for bouyancy
m_H2_0 = rho_H2_0 * V_H2_filltotal;               %kg mass of hydrogen to be initially filled

%% ODE solver
% init ODE variables
sx_0 = 0;
vx_0 = 0;
sy_0 = 0;
vy_0 = 0;
sz_0 = alt0;
vz_0 = 0.001;
T_H2_0 = T0;
init_ODE = [sx_0, vx_0, sy_0, vy_0,sz_0, vz_0, m_H2_0, T_H2_0];

% dependant variables input
input.balloon = balloon;
input.wind = wind;

% run ode45 solver
timerange = [0 inf];
options = odeset('Events',@detect_apogee,'RelTol',1E-4);
[t, outputs] = ode45(@ascent_ODE, timerange, init_ODE, options, input);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sy = outputs(:,3);
vy = outputs(:,4);
sz = outputs(:,5);
vz = outputs(:,6);
m_H2 = outputs(:,7);
T_H2 = outputs(:,8);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sx)
    ODE_inputs = [sx(n), vx(n), sy(n), vy(n), sz(n), vz(n), m_H2(n), T_H2(n)];
    [~, data_ODE] = ascent_ODE(t(n), ODE_inputs, input);
    ascent(n) = data_ODE;
end
ascent = transpose_arrayOfStructs(ascent);
ascent.sx = sx;
ascent.vx = vx;
ascent.sy = sy;
ascent.vy = vy;
ascent.sz = sz;
ascent.vz = vz;
ascent.m_H2 = m_H2;
ascent.T_H2 = T_H2;
ascent.t = t;

%% Convert x,y distances to GPS coordinates
[ ascent.long, ascent.lat ] = dxdy_to_coordinates( ascent.sx, ascent.sy, long0, lat0 );
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

















end

