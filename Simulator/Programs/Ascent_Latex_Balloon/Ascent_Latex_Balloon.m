clc
clear
close all

% Dependencies
Parent = pwd;
NAME = 'null';
while ~strcmp(NAME,'Matlab')
    [Parent,NAME,EXT] = fileparts(Parent);
end
Parent = strcat(Parent,'\',NAME,'\');
addpath(genpath(strcat(Parent,'Common_Functions')));

%constants
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

%inputs
Dburst = 40 * 0.3048;                %(m) balloon burst diameter
Vburst = (4/3) * pi * (Dburst/2)^3;  %(m^3) burs volume
m = 1;                               %(kg) balloon and payload mass
V0 = 300 * 0.0283168;                %(m^3) initial volume of cubic hydrogen

%determine hydrogen mass
[rho_air,a,T,P,nu,ZorH]=stdatmo(0);   %SI  (standard atmosphere)
rho_H2 = P/(R_H2*T);                  %Ideal gas law, assume ambient pressure
mH2 = rho_H2 * V0                     %(kg) mass of hydrogen in balloon

%iterate
alt = (0:1000:130000)*0.3048;   %(m)

%get gas properties
[rho_air,a,T,P,nu,ZorH]=stdatmo(alt);   %SI  (standard atmosphere)
rho_H2 = P./(R_H2.*T);                    %Ideal gas law, assume ambient pressure
V = mH2./rho_H2;                         %balloon volume  

%calculate lift
L = (rho_air - rho_H2) * g .* V;         %(N)
W = m * g;                              %(N)
Fnet = L - W;                           %(N)

figure(1)
subplot(2,1,1)
plot(L,alt*3.28084)
xlabel('Lift (N)')
ylabel('Altitude (ft)')
grid on

subplot(2,1,2)
plot(V*35.3147,alt*3.28084)
hold on
plot([1 1]*Vburst*35.3147,[0 130000])
xlabel('Balloon Volume (ft^3)')
ylabel('Altitude (ft)')
legend('Theoretical Balloon Volume','Burst Diameter')
grid on


