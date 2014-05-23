function data = rocket_ODE_wrapper(init_ODE, rasaero, rocksim, wind, rocket, balloon)
%Created by Brent Justice
%5/15/2014
%
%This simulation runs a 3DOF analysis on a rocket launch using ODE45. 
%The non-dimensional aerodynamic coefficients are taken from RASAero
%The moment of inertia over time and motor thrust is taken from Rocksim
%
%Inputs
%init_ODE = [sx_0, vx_0, sz_0, vz_0, theta_0, theta_dot_0]
%   where sx = horizontal distance [m]
%   where sz = vertical distance (altitude) [m]
%   where theta = polar angle from horizon [deg]
%rasaero = RASAero parsed output (use load_rasaero function)
%rocksim = rocksim parsed outpup (use load_rocksim function)
%wind = parsed wind data --> forcing function on rocket
%rocket = struct with necessary rocket inputs
%   rocket.D = rocket diameter [m]
%balloon = struct with necessary balloon inputs --> ignore if not rockoon
%   balloon.height = distance rocket will be travelling through H2

%% check function inputs
if ~isfield(balloon,'height')
    balloon.height = 0;
end

%% formulate 2d RASAero lookup table
%This allows for determination of non-dimensional aerodynamic properties as
%a function of Mach number and AOA
m = length(unique(rasaero.Mach));
n = length(unique(rasaero.alpha_deg));

rasaero.Mach = reshape(rasaero.Mach,m,n)';
rasaero.alpha_deg = reshape(rasaero.alpha_deg,m,n)';
rasaero.CD = reshape(rasaero.CD,m,n)';
rasaero.CN = reshape(rasaero.CN,m,n)';
rasaero.CP = reshape(rasaero.CP,m,n)';

%% find time of liftoff
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

    %find Fnet
    Fnet = T - m_total * 9.81;                                       %(N) net thrust in vertical direction
end

%% run ode45 solver
timerange = [t_liftoff, inf];
options = odeset('Events',@detect_rocket_apogee);
[t, outputs] = ode45(@rocket_ODE, timerange, init_ODE, options, init_ODE(3), rocksim, rasaero, wind, balloon.height, rocket.D);

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
    [~, data_ODE] = rocket_ODE(t(n), inputs, init_ODE(3), rocksim, rasaero, wind, balloon.height, rocket.D);
    data(n) = data_ODE;
end
data = transpose_arrayOfStructs(data);
data.sx = sx;
data.vx = vx;
data.sz = sz;
data.vz = vz;
data.theta = theta;
data.theta_dot = theta_dot;
data.t = t;
end










