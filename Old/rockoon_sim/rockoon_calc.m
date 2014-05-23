function [outputs, data] = rockoon_calc(t, inputs)

%define inputs and outputs
%inputs = [sx, vx, sy, vy, theta, theta_dot]
%outputs = [vx, ax, vy, ay, theta_dot, theta_dot_dot]
sx = inputs(1);
vx = inputs(2);
sy = inputs(3);
vy = inputs(4);
theta = inputs(5);
theta_dot = inputs(6);

%declare globals
global rasaero
global rocksim
global sy_0

%constants/mission inputs
balloon_height = 10;                 %(m) distance from rocket nosecone to balloon apex
diameter = 54 * 0.001;               %(m) rocket body diameter
A = pi*(diameter/2)^2;               %(m^2) reference area
gamma_air = 1.4;                     %specific heat of air
gamma_H2 = 1.41;                     %specific heat of H2
g = 9.81;                            %m/s/s
R_air = 287.058;                     %specific gas constant air (SI)
R_H2 = 4124;                         %specific gas constant hydrogen (SI)

%get gaseous density and speed of sound
[rho_air,a_air,temp_air,press_air,kvisc,ZorH]=stdatmo(sy);   %SI units

if (sy-sy_0 <= balloon_height)              %if we are inside of the balloon
    rho = press_air/(R_H2 * temp_air);      %set gas density to hydrogen density
    a = sqrt(gamma_H2 * R_H2 * temp_air);   %set gas speed of sound to hydrogen speed of sound
    vx_wind = 0;                            %(m/s) wind x velocity at altitude
    vy_wind = 0;                            %(m/s) wind y velocity at altitude
else                                        %if we are outside of the balloon
    rho = rho_air;                          %use air density
    a = a_air;                              %use air speed of sound
    vx_wind = 20 * 0.44704;                 %(m/s) wind x velocity at altitude
    vy_wind = 0;                            %(m/s) wind y velocity at altitude
end

%calculate freestream velocity and angle of attack
vx_sum = vx + vx_wind;             %(m/s) get freestream velocity
vy_sum = vy + vy_wind;             %(m/s) get freestream velocity
v = norm([vx_sum vy_sum]);         %[m/s] velocity magnitude
M = v/a;                           %freestream Mach
v_theta = atan2d(vy_sum,vx_sum);   %[deg] polar angle 
alpha = v_theta - theta;           %[deg] angle of attack

%interpolate RASAero for aerodynamics data
CD = interp2(rasaero.Mach,rasaero.alpha_deg,rasaero.CD,M,abs(alpha),'spline');           %
CN = interp2(rasaero.Mach,rasaero.alpha_deg,rasaero.CN,M,abs(alpha),'spline');           %
CP = interp2(rasaero.Mach,rasaero.alpha_deg,rasaero.CP,M,abs(alpha),'spline') * 0.0254;  %(m) from nosecone tip

%Calculate forces
N = 1/2 * rho * v^2 * A * CN ;                              %(N) normal force
D = 1/2 * rho * v^2 * A * CD ;                              %(N) drag force
   m_total = interp1(rocksim.Time1, rocksim.MassOunces, t); %(ounces) total rocket mass
   m_total = m_total * 0.0283495;                           %(kg) total rocket mass
Fg = m_total * g;                                           %(N) gravity force
T = interp1(rocksim.Time1, rocksim.ThrustN, t);             %(N) engine thrust

%determine ax, ay
Tx = T*cosd(theta);
Ty = T*sind(theta);
Dx = -D*cosd(v_theta);
Dy = -D*sind(v_theta);
FGx = 0;
FGy = -Fg;
Nx = sign(alpha) * N*cosd(v_theta-90);
Ny = sign(alpha) * N*sind(v_theta-90);

ax = (Tx + Dx + FGx + Nx)/m_total;
ay = (Ty + Dy + FGy + Ny)/m_total;

%determine static margin
CG = interp1(rocksim.Time1, rocksim.CGInches, t) * 0.0254;  %(m) to CG from nosecone
margin = CP - CG;                                           %(m) static margin

%determine theta_dot_dot
r = -[cosd(theta) , sind(theta) , 0];                                %points from CG to CP (useless magnitude)
r = margin * r./norm(r);                                             %(m) displacement vector from CG to CP
Torque = cross(r,[Dx Dy 0]) + cross(r,[Nx Ny 0]);                    %(N-m) torque caused by normal and drag forces
Torque = Torque(3);                                                  %(N-m) take torque scalar term
   I = interp1(rocksim.Time1, rocksim.Longitudinalmomentofinert, t); %
   I = I * 0.00001829;                                             %(kg-m^2) moment of inertia
theta_dot_dot = (Torque / I)  *57.2957795;                           %deg/s/s

%formulate function output
outputs = [vx, ax, vy, ay, theta_dot, theta_dot_dot]';
data.alpha = alpha;
data.N = N;
data.D = D;
data.Fg = Fg;
data.T = T;
data.Torque = Torque;
data.M = M;
data.a = a;
data.vy_sum = vy_sum;
data.vx_sum = vx_sum;
data.ay = ay;
data.ax = ax;
end







