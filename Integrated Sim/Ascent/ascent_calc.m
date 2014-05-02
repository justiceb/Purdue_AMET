function [outputs, data] = ascent_calc(t, inputs, m_system, Vdeployed)

%define inputs and outputs
%inputs = [s, v, m_H2]
%outputs = [v, a, mdot_H2]
%m_h2 = mass of filled hydrogen (kg)
%m_system = balloon and payload mass (kg)
%Vdeployed = volume of balloon when deployed (m^3)
s = inputs(1);     %(m)
v = inputs(2);     %(m/s)
m_H2 = inputs(3);  %(kg)

%constant
volume_flux = -0.000012;         %[m^3/m^2-s]
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

%get gas properties
[rho_air,SOS,T,P,nu,ZorH]=stdatmo(s);     %SI  (standard atmosphere)
mu = nu * rho_air;                       %dynamic viscosity of air
rho_H2 = P/(R_H2*T);                    %Ideal gas law, assume ambient pressure

%Determine Vgas and calc mdot_H2
Vgas = m_H2 / rho_H2;        %(m^3) gas volume
R = (Vgas*(3/4)/pi)^(1/3);   %(m)
SA = 4*pi*R^2;               %(m^2)
m_flux = volume_flux * rho_H2;    %(kg/m^2-s)
mdot_H2 = m_flux * SA;            %(kg/s)

%check to see if we are fully deployed yet
if Vgas >= Vdeployed
    Vgas = Vdeployed;
    m_H2 = Vgas * rho_H2;
end

%Calculate reference area --> asume spherical balloon
r = (Vgas*(3/4)/pi)^(1/3);    %theoretical balloon radius
Aref = pi * (r)^2;              %reference area

%Get CD (approximate CD as a sphere)
RE = rho_air * abs(v) * 2*r / mu;
CD =  0.47;        %4.808 * 10^-2 * log(RE)^2 - 1.406 * log(RE) + 10.490;

%calculate net acceleration
    m_total = m_system + m_H2;             %(kg) 
L = (rho_air - rho_H2) * g * Vgas;         %(N)
W = m_total * g;                           %(N)
D = (1/2) * rho_air * v^2 * CD * Aref;     %(N)
Fnet = L - W -D;                           %(N)
a = Fnet/m_total;                          %(m/s/s)

outputs = [v, a, mdot_H2]';
data.L = L;
data.W = W;
data.D = D;
data.Fnet = Fnet;
data.a = a;
data.Vgas = Vgas;
data.m_H2 = m_H2;
data.CD = CD;
data.RE = RE;
data.mdot_H2 = mdot_H2;
end