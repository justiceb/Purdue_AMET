%% Inputs
alt0 = ascent.s(end);             %(m)
balloon_height = balloon.z(end);  %(m) height of the balloon at deployment
Drocket = 54 * 0.001;             %(m) rocket body diameter

%load external data
rasaero = load_RASAero_aeroplot1('RASAero_aeroplot1.csv');
rocksim = load_rocksim('rocksim.csv');
wind = ascent.wind;

%% formulate 2d lookup table (input Mach and aoa)
m = length(unique(rasaero.Mach));
n = length(unique(rasaero.alpha_deg));

rasaero.Mach = reshape(rasaero.Mach,m,n)';
rasaero.alpha_deg = reshape(rasaero.alpha_deg,m,n)';
rasaero.CD = reshape(rasaero.CD,m,n)';
rasaero.CN = reshape(rasaero.CN,m,n)';
rasaero.CP = reshape(rasaero.CP,m,n)';

%% find time of liftoff
t_liftoff = 0;
Fnet = -1;
while (Fnet < 0)
    
    %find rocket mass and thrust
    m_total = interp1(rocksim.Time1, rocksim.MassOunces, t_liftoff); %(ounces) total rocket mass
    m_total = m_total * 0.0283495;                                   %(kg) total rocket mass
    T = interp1(rocksim.Time1, rocksim.ThrustN, t_liftoff);                  %(N) engine thrust

    %find Fnet
    Fnet = T - m_total * 9.81;                                       %(N) net thrust in vertical direction
    
    %increment timestep
    t_liftoff = t_liftoff + 0.01;
end

%% sim initial conditions
gs0 = interp1( wind.HGHT, wind.SKNT, alt0, 'linear', 'extrap' );    %interpolate for ground course
gc0 = interp1( wind.HGHT, wind.DRCT, alt0, 'linear', 'extrap' );    %interpolate for ground course

sx_0 = 0;
sz_0 = alt0;
vx_0 = gs0;
vz_0 = 0.0000001;        %make really small value to init angle of attack
theta_0 = 90;            %degrees
theta_dot_0 = 0;         %degrees/sec
t_end = 10000;               %(s) sim end time

%% run ode45 solver
timerange = [t_liftoff t_end];
init = [sx_0, vx_0, sz_0, vz_0, theta_0, theta_dot_0];
options = odeset('Events',@detect_rocket_apogee);
[t, outputs] = ode45(@rockoon_calc, timerange, init, options, sz_0, rocksim, rasaero, wind, balloon_height, Drocket);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sz = outputs(:,3);
vz = outputs(:,4);
theta = outputs(:,5);
theta_dot = outputs(:,6);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sx)
    inputs = [sx(n), vx(n), sz(n), vz(n), theta(n), theta_dot(n)];
    [outputs2, data] = rockoon_calc(t(n), inputs, sz_0, rocksim, rasaero, wind, balloon_height, Drocket);
    alpha(n) = data.alpha;
    N(n) = data.N;
    D(n) = data.D;
    Fg(n) = data.Fg;
    T(n) = data.T;
    Torque(n) = data.Torque;
    M(n) = data.M;
    a(n) = data.a;
    vz_sum(n) = data.vz_sum;
    vx_sum(n) = data.vx_sum;
    az(n) = data.az;
    ax(n) = data.ax;
    Tx(n) = data.Tx;
    Tz(n) = data.Tz;
    Dx(n) = data.Dx;
    Dz(n) = data.Dz;
    Nx(n) = data.Nx;
    Nz(n) = data.Nz;
end

%% Formulate 3d trajectory
r = sx;
long0 = ascent.long(end);
lat0 = ascent.lat(end);
sxx = r*cosd(gc0+180);
syy = r*sind(gc0+180);
[ long, lat ] = dxdy_to_coordinates( sxx, syy, long0, lat0 );

%% run plots
figure(5)
plot(t,T,t,D,t,N,t,Fg)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('force (N)')
grid on
legend('T','D','N','Fg')

figure(6)
plot(t,Torque,t,alpha)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('Torque (N-M), AOA (degrees)')
grid on
legend('Torque','AOA')

figure(7)
subplot(2,2,1)
plot(t,sz)
xlabel('time (s)')
ylabel('altitude (m)')
grid on

subplot(2,2,2)
plot(t,M)
xlabel('time (s)')
ylabel('Mach Number')
grid on

subplot(2,2,3)
plot(t,alpha)
xlabel('time (s)')
ylabel('AOA (deg)')
grid on

subplot(2,2,4)
plot(t, theta)
xlabel('time (s)')
ylabel('theta (deg)')
grid on

figure(8)
plot(t,Tx,'r:',t,Tz,'r',t,Dx,'b:',t,Dz,'b',t,Nx,'k:',t,Nz,'k')
xlabel('time (s)')
ylabel('Force (n)')
grid on
legend('Tx','Tz','Dx','Dz','Nx','Nz')










