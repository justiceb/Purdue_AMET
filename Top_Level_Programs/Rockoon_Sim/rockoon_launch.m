%% Prepare variabels and run ODE sim
sx_0 = 0;
vx_0 = norm([ascent.vx(end), ascent.vy(end)]);
sz_0 = ascent.sz(end);
vz_0 =  0.0001;        %make really small value to init angle of attack
theta_0 = 90;           %degrees
theta_dot_0 = 0;         %degrees/sec
init_ODE = [sx_0, vx_0, sz_0, vz_0, theta_0, theta_dot_0];
rasaero = config.rasaero;
rocksim = config.rocksim;
wind = config.wind;
rocket.D = input.Drocket;
balloon_input.height = balloon.z(end);

rockoon = rocket_ODE_wrapper(init_ODE, rasaero, rocksim, wind, rocket, balloon_input);

%% Formulate 3d trajectory
gs0 = interp1( wind.HGHT, wind.SPEED, sz_0, 'linear', 'extrap' );    %interpolate for ground course
gc0 = interp1( wind.HGHT, wind.DRCT, sz_0, 'linear', 'extrap' );    %interpolate for ground course

long0 = ascent.long(end);
lat0 = ascent.lat(end);
rockoon.sxx = rockoon.sx*cosd(gc0);
rockoon.syy = rockoon.sx*sind(gc0);
rockoon.vxx = rockoon.vx*cosd(gc0);
rockoon.vyy = rockoon.vx*sind(gc0);
[ rockoon.long, rockoon.lat ] = dxdy_to_coordinates( rockoon.sxx, rockoon.syy, long0, lat0 );

%% run plots
t = rockoon.t;

figure(7)
subplot(3,2,1)
plot(t,rockoon.sz)
xlabel('time (s)')
ylabel('altitude (m)')
grid on

subplot(3,2,2)
plot(t,rockoon.M)
xlabel('time (s)')
ylabel('Mach Number')
grid on

subplot(3,2,3)
plot(t,rockoon.T,t,rockoon.D,t,rockoon.N,t,rockoon.Fg)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('force (N)')
grid on
legend('T','D','N','Fg')

subplot(3,2,4)
plot(t,rockoon.Tx,'r:',t,rockoon.Tz,'r',t,rockoon.Dx,'b:',t,rockoon.Dz,'b',t,rockoon.Nx,'k:',t,rockoon.Nz,'k')
xlabel('time (s)')
ylabel('Force (n)')
grid on
legend('Tx','Tz','Dx','Dz','Nx','Nz')

subplot(3,2,5)
plot(t,rockoon.alpha)
xlabel('time (s)')
ylabel('AOA (deg)')
grid on

subplot(3,2,6)
plot(t, rockoon.theta)
xlabel('time (s)')
ylabel('theta (deg)')
grid on

figure(8)
plot(t,rockoon.vx_inf*2.23694,t,rockoon.vx_wind*2.23694,t,rockoon.vx*2.23694)
xlabel('time (s)')
ylabel('X-Velocity (mph)')
grid on
legend('vx-inf','vx-wind','vx')

figure(9)
color_line(rockoon.sxx*0.000621371,rockoon.syy*0.000621371,rockoon.sz*3.28084);
axis equal
xlabel('x-distance (miles)')
ylabel('y-distance (miles)')
title('Rocket Trajectory')
cb = colorbar('peer',gca);
set(get(cb,'ylabel'),'String', 'Altitude (feet)');
grid on


