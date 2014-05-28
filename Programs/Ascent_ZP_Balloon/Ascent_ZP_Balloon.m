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
addpath(genpath(strcat(Parent,'Programs\Balloon_Shape')));

%% Create Balloon
run create_balloon

%determine variables to keep
balloon.V = V                        %(m^3) balloon volume when deployed
balloon.m_balloon = S*wd;             %(kg) predicted balloon mass
balloon.m_payload = Wpayload/g;       %(kg) payload mass
balloon.z = z;                        %(m) balloon height as a function of S
balloon.s = s;                        %(s) balloon gore length

%% Determine initial H2 mass
V_H2_fill = 10;  %(m)^3
[rho_H2_fill]=stdatmo_H2(0);
m_H2_0 = rho_H2_fill * V_H2_fill

%% Run program
%variable inputs
sx_0 = 0;
vx_0 = 0;
sy_0 = 0;
vy_0 = 0;
sz_0 = 0;
vz_0 = 0.001;
T_H2_0 = 293;
init_ODE = [sx_0, vx_0, sy_0, vy_0,sz_0, vz_0, m_H2_0, T_H2_0];
wind = load_Wyoming_Sounding('ILN_12Z_06_May_2014.csv');
m_payload = 3.62874;

%run
ascent = ascent_ODE_wrapper( init_ODE, balloon, wind, m_payload );



figure(7)
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
plot(ascent.t,ascent.mdot_H2)
xlabel('time (s)')
ylabel('hydrogen mass flow rate (kg/s)')
grid on

subplot(3,2,5)
plot(ascent.t,ascent.volume_H2)
xlabel('time (s)')
ylabel('Volume (m^3)')
grid on
hold all
plot(ascent.t,ones(1,length(ascent.t))*balloon.V)
legend('Constrained Hydrogen Volume','Balloon Volume')

subplot(3,2,6)
plot(ascent.t,ascent.T_H2-273.15,ascent.t,ascent.T_air-273.15,ascent.t,ascent.Tfilm-273.15)
xlabel('time (s)')
ylabel('Temperature (C)')
grid on
legend('H2 temp','air temp','film temp')









