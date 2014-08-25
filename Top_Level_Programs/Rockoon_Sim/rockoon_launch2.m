function launch = rockoon_launch2( input_filename )
%% Inputs (Mission Criteria)
load(input_filename) %load the following input parameters
% balloon              --> struct of all balloon creation variables
% wind                 --> struct of wind config data
% rasaero              --> struct of all rasaero data
% rocksim              --> struct of all rocksim data
% vx_0                 --> (m/s) initial horizontal velocity

%% Pre-ODE calculations
% formulate 2d RASAero lookup table
% This allows for determination of non-dimensional aerodynamic properties as
% a function of Mach number and AOA
m = length(unique(rasaero.Mach));
n = length(unique(rasaero.alpha_deg));

rasaero.Mach = reshape(rasaero.Mach,m,n)';
rasaero.alpha_deg = reshape(rasaero.alpha_deg,m,n)';
rasaero.CD = reshape(rasaero.CD,m,n)';
rasaero.CN = reshape(rasaero.CN,m,n)';
rasaero.CP = reshape(rasaero.CP,m,n)';

% find time of liftoff
%t = 0 --> motor ignition
%t = t_liftoff --> Fg == Thrust
t_liftoff = 0;
Fnet = -1;
while (Fnet < 0)
    %increment timestep
    t_liftoff = t_liftoff + 0.001;
    
    %find rocket mass and thrust
    m_total = interp1(rocksim.Time1, rocksim.MassOunces, t_liftoff); %(ounces) total rocket mass
    m_total = m_total * 0.0283495;                                   %(kg) total rocket mass
    T = interp1(rocksim.Time1, rocksim.ThrustN, t_liftoff);          %(N) engine thrust
    Tz = T*sind(theta_0);                                            %(N) engine thrust in vertical direction

    %find Fnet
    Fnet = Tz - m_total * 9.81;                                      %(N) net thrust in vertical direction
end

%% ODE solver
% init ODE variables
sx_0 = 0;
vz_0 =  0.0001;        %make really small value to init angle of attack
theta_dot_0 = 0;         %degrees/sec
init_ODE = [sx_0, vx_0, sz_0, vz_0, theta_0, theta_dot_0];

% dependant variables input
input.balloon = balloon;
input.wind = wind;
input.rasaero = rasaero;
input.rocksim = rocksim;
input.sz_0 = sz_0;
input.Drocket = Drocket;

% run ode45 solver
timerange = [t_liftoff, inf];
options = odeset('Events',@detect_rocket_apogee);
[t, outputs] = ode45(@rocket_ODE, timerange, init_ODE, options, input);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sz = outputs(:,3);
vz = outputs(:,4);
theta = outputs(:,5);
theta_dot = outputs(:,6);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sx)
    ODE_inputs = [sx(n), vx(n), sz(n), vz(n), theta(n), theta_dot(n)];
    [~, data_ODE] = rocket_ODE(t(n), ODE_inputs, input);
    launch(n) = data_ODE;
end
launch = transpose_arrayOfStructs(launch);
launch.sx = sx;
launch.vx = vx;
launch.sz = sz;
launch.vz = vz;
launch.theta = theta;
launch.theta_dot = theta_dot;
launch.t = t;

%% Formulate 3d trajectory
gs0 = interp1( wind.HGHT, wind.SPEED, sz_0, 'linear', 'extrap' );    %interpolate for ground course
gc0 = interp1( wind.HGHT, wind.DRCT, sz_0, 'linear', 'extrap' );    %interpolate for ground course

launch.sxx = launch.sx*cosd(gc0);
launch.syy = launch.sx*sind(gc0);
launch.vxx = launch.vx*cosd(gc0);
launch.vyy = launch.vx*sind(gc0);
[ launch.long, launch.lat ] = dxdy_to_coordinates( launch.sxx, launch.syy, long0, lat0 );

%% run plots
t = launch.t;

figure(7)
subplot(3,2,1)
plot(t,launch.sz)
xlabel('time (s)')
ylabel('altitude (m)')
grid on

subplot(3,2,2)
plot(t,launch.M)
xlabel('time (s)')
ylabel('Mach Number')
grid on

subplot(3,2,3)
plot(t,launch.T,t,launch.D,t,launch.N,t,launch.Fg)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('force (N)')
grid on
legend('T','D','N','Fg')

subplot(3,2,4)
plot(t,launch.Tx,'r:',t,launch.Tz,'r',t,launch.Dx,'b:',t,launch.Dz,'b',t,launch.Nx,'k:',t,launch.Nz,'k')
xlabel('time (s)')
ylabel('Force (n)')
grid on
legend('Tx','Tz','Dx','Dz','Nx','Nz')

subplot(3,2,5)
plot(t,launch.alpha)
xlabel('time (s)')
ylabel('AOA (deg)')
grid on

subplot(3,2,6)
plot(t, launch.theta)
xlabel('time (s)')
ylabel('theta (deg)')
grid on

figure(8)
plot(t,launch.vx_inf*2.23694,t,launch.vx_wind*2.23694,t,launch.vx*2.23694)
xlabel('time (s)')
ylabel('X-Velocity (mph)')
grid on
legend('vx-inf','vx-wind','vx')

figure(9)
color_line(launch.sxx*0.000621371,launch.syy*0.000621371,launch.sz*3.28084);
axis equal
xlabel('x-distance (miles)')
ylabel('y-distance (miles)')
title('Rocket Trajectory')
cb = colorbar('peer',gca);
set(get(cb,'ylabel'),'String', 'Altitude (feet)');
grid on





end

