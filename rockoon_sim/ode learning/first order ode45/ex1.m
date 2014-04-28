clc; clear; close all;

time_period = [0 30];
v0 = 0;
[t,v] = ode45(@solve_vdot, time_period, v0);
vdot = solve_vdot(0,v);

plot(t,v,t,vdot)
legend('v','vdot')
