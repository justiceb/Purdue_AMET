clc; clear;
%close all;

%declare global variables
global rasaero
global rocksim
global sy_0

%load external data
rasaero = load_RASAero_aeroplot1('RASAero_aeroplot1.csv');
rocksim = load_rocksim('rocksim.csv');

%formulate 2d lookup table (input Mach and aoa)
m = length(unique(rasaero.Mach));
n = length(unique(rasaero.alpha_deg));

rasaero.Mach = reshape(rasaero.Mach,m,n)';
rasaero.alpha_deg = reshape(rasaero.alpha_deg,m,n)';
rasaero.CD = reshape(rasaero.CD,m,n)';
rasaero.CN = reshape(rasaero.CN,m,n)';
rasaero.CP = reshape(rasaero.CP,m,n)';

%find time of liftoff
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

%sim initial conditions
sx_0 = 0;
sy_0 = 70000 * 0.3048;   %m
vx_0 = 0;
vy_0 = 0.0000001;        %make really small value to init angle of attack
theta_0 = 90;            %degrees
theta_dot_0 = 0;         %degrees/sec
t_end = 50;               %(s) sim end time

%run ode45 solver
timerange = [t_liftoff t_end];
init = [sx_0, vx_0, sy_0, vy_0, theta_0, theta_dot_0];
[t, outputs] = ode45(@rockoon_calc, timerange, init);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sy = outputs(:,3);
vy = outputs(:,4);
theta = outputs(:,5);
theta_dot = outputs(:,6);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sx)
    inputs = [sx(n), vx(n), sy(n), vy(n), theta(n), theta_dot(n)];
    [outputs2, data] = rockoon_calc(t(n), inputs);
    alpha(n) = data.alpha;
    N(n) = data.N;
    D(n) = data.D;
    Fg(n) = data.Fg;
    T(n) = data.T;
    Torque(n) = data.Torque;
    M(n) = data.M;
    a(n) = data.a;
    vy_sum(n) = data.vy_sum;
    vx_sum(n) = data.vx_sum;
    ay(n) = data.ay;
    ax(n) = data.ax;
end



%run plots
figure(1)
plot(t,T,t,D,t,N,t,Fg)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('force (N)')
grid on
legend('T','D','N','Fg')

figure(2)
plot(t,Torque,t,alpha)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('Torque (N-M), AOA (degrees)')
grid on
legend('Torque','AOA')

figure(3)
subplot(2,2,1)
plot(t,sy)
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











