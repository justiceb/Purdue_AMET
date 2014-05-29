function data = ascent_ODE_wrapper( init_ODE, balloon, wind, m_payload )
%Created by Brent Justice
%5/15/2014
%
%Inputs
%init_ODE = [sx_0, vx_0, sy_0, vy_0,sz_0, vz_0, m_H2_0, T_H2_0]
%   where sx,sy = horizontal distance [m]
%   where sz = vertical distance (altitude) [m]
%   where m_H2 = mass of hydrogen gas [kg]
%wind = parsed wind data --> forcing function on rocket
%balloon = struct with necessary balloon inputs

%% run ode45 solver
timerange = [0 inf];
options = odeset('Events',@detect_apogee,'RelTol',1E-4);
[t, outputs] = ode45(@ascent_ODE, timerange, init_ODE, options, balloon, wind, m_payload);

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
    inputs = [sx(n), vx(n), sy(n), vy(n), sz(n), vz(n), m_H2(n), T_H2(n)];
    [~, data_ODE] = ascent_ODE(t(n), inputs, balloon, wind, m_payload);
    data(n) = data_ODE;
end
data = transpose_arrayOfStructs(data);
data.sx = sx;
data.vx = vx;
data.sy = sy;
data.vy = vy;
data.sz = sz;
data.vz = vz;
data.m_H2 = m_H2;
data.T_H2 = T_H2;
data.t = t;

end

