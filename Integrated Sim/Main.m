clc; clear; close all

%% Balloon Shape
%{
The balloon shape is determined early on in the design process with a
predicted payload weight.  All of these design inputs are placed at the top
of the create_balloon script file.  Once the balloon is created, these
inputs cannot be changed.  However, we often find that the actual measured
payload weight on the day of the launch is slightly different from the
designed payload weight.  We also often find that the balloon weight is
slightly different.  For the remainder of this integrated sim, we will use 
these measure values for increased sim accuracy.  The only value that we
extract from the balloon_shape sim is the balloon volume when fully 
deployed.  This will stay relatively accurate for small deviations from
the designed payload weight.
%}

run Balloon_Shape/create_balloon

%determine variables to keep
balloon.V = V;                        %(m^3) balloon volume when deployed
balloon.m_balloon = S*wd;             %(kg) predicted balloon mass
balloon.m_total = S*wd + Wpayload/g;  %(kg) balloon and payload mass

%clear all variables but balloon struct
clearvars -except balloon

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

%constant
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
alt0 = 180;                   %(m) launch elevation

%inputs for day of launch
V_H2_surplus = 500 * 0.0283168;         %(m^3) surplus volume of H2 added to balloon
m_balloon = 0;                          %(kg) measured balloon mass
m_payload = 0;                          %(kg) measured payload mass

    %Simulate masses (enable these for testing)
    m_balloon = balloon.m_balloon;
    m_payload = balloon.m_total - balloon.m_balloon;

%determine hydrogen mass to fill
syms m_H2 positive
for n = 1:1:2
    [rho_air,SOS,T,P,nu,ZorH]=stdatmo(alt0);   %SI  (standard atmosphere)
    rho_H2 = P/(R_H2*T);                     %Ideal gas law, assume ambient pressure
    m_system = m_balloon + m_payload;        %(kg) balloon and payload mass
    W = (m_system + m_H2) * g;               %(N) total weight  --> f(m_H2)
    Vmin = W/((rho_air - rho_H2) * g);       %(m^3) minimum hydrogen needed  --> f(m_H2)
    V_H2_SL = Vmin + V_H2_surplus;           %(m^3) volume of hydrogen filled at SL --> f(m_H2)

    if n==1
        sol = solve(m_H2 == rho_H2 * V_H2_SL);
        m_H2 = double(sol);
    end
end

fprintf('\n');
fprintf('Total Hydrogen to Fill = %f ft^3 \n',V_H2_SL * 35.3147);

%run ode45 solver
timerange = [0 10000];
init = [alt0 0];
[t, outputs] = ode45(@ascent_calc, timerange, init, [], m_H2, m_system, balloon.V);

%extract outputs
s = outputs(:,1);
v = outputs(:,2);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(s)
    inputs = [s(n), v(n)];
    [outputs, data] = ascent_calc(t(n), inputs, m_H2, m_system, balloon.V);
    L(n) = data.L;
    W(n) = data.W;
    D(n) = data.D;
    Fnet(n) = data.Fnet;
    a(n) = data.a;
    Vgas(n) = data.Vgas;
    m_H2_real(n) = data.m_H2;
end

%Make some plots
figure(4)
subplot(2,2,1)
plot(t,s*3.28084)
xlabel('time (s)')
ylabel('altitude (ft)')
grid on

subplot(2,2,2)
plot(t,L,t,W,t,D,t,Fnet)
xlabel('time (s)')
ylabel('Force (N)')
grid on
legend('Lift','Weight','Drag','Fnet')

subplot(2,2,3)
plot(t,v)
xlabel('time (s)')
ylabel('ascent rate (m/s)')
grid on

subplot(2,2,4)
plot(Vgas,s*3.28084)
xlabel('Balloon Volume (m^3)')
ylabel('Altitude (ft)')
grid on

















