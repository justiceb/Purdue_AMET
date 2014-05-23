clc; clear; close all;

%% Dependencies
Parent = pwd;
NAME = 'null';
while ~strcmp(NAME,'Matlab')
    [Parent,NAME,EXT] = fileparts(Parent);
end
Parent = strcat(Parent,'\',NAME,'\');

addpath(genpath(strcat(Parent,'Common_Functions')));
addpath(genpath(strcat(Parent,'Config_Files')));

%% Configs
wind = load_Wyoming_Sounding('no_wind.csv');
rasaero = load_RASAero_aeroplot1('RASAero_aeroplot1.csv');
rocksim = load_rocksim('rocksim.csv');
Rsim = load_rasaero_sim('rasaero_sim.CSV');

%% Prepare variabels and run ODE sim
sx_0 = 0;
vx_0 = 0;
sz_0 = 0;
vz_0 = 0.0001;        %make really small value to init angle of attack
theta_0 = 90;           %degrees
theta_dot_0 = 0;         %degrees/sec
init_ODE = [sx_0, vx_0, sz_0, vz_0, theta_0, theta_dot_0];
rocket_input.D = 54 * 0.001;          %(m) rocket body diameter
balloon = [];

rocket = rocket_ODE_wrapper(init_ODE, rasaero, rocksim, wind, rocket_input, balloon);

%% Plots
t = rocket.t;

figure(1)
subplot(3,2,1)
plot(t,rocket.sz,Rsim.t,Rsim.sz)
xlabel('time (s)')
ylabel('altitude (m)')
grid on
legend('MATLAB','RASAero')

subplot(3,2,2)
plot(t,rocket.M,Rsim.t,Rsim.Mach)
xlabel('time (s)')
ylabel('Mach Number')
grid on
legend('MATLAB','RASAero')

subplot(3,2,3)
plot(t,rocket.T,t,rocket.D,t,rocket.N,t,rocket.Fg)
title('when launched from 70k ft')
xlabel('time (s)')
ylabel('force (N)')
grid on
legend('T','D','N','Fg')

subplot(3,2,4)
plot(t,rocket.Tx,'r:',t,rocket.Tz,'r',t,rocket.Dx,'b:',t,rocket.Dz,'b',t,rocket.Nx,'k:',t,rocket.Nz,'k')
xlabel('time (s)')
ylabel('Force (n)')
grid on
legend('Tx','Tz','Dx','Dz','Nx','Nz')

subplot(3,2,5)
plot(t,rocket.alpha)
xlabel('time (s)')
ylabel('AOA (deg)')
grid on

subplot(3,2,6)
plot(t, rocket.theta)
xlabel('time (s)')
ylabel('theta (deg)')
grid on

figure(2)
plot(t,rocket.vx_inf*2.23694,t,rocket.vx_wind*2.23694,t,rocket.vx*2.23694)
xlabel('time (s)')
ylabel('X-Velocity (mph)')
grid on
legend('vx-inf','vx-wind','vx')



