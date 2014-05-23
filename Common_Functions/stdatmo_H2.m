function [rho_H2,SOS_H2,T_H2,P_H2]=stdatmo_H2(altitude)
%provides hydrogen properties at given altitude
%assumes the temperature and pressure of the air and H2 are the same
%all units are SI

%%
%constants
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
CP_H2 = 14.32;                %kj/kg-K
CV_H2 = 10.16;                %kj/kg-K
gamma_H2 = CP_H2 / CV_H2;     %ratio of specific heats

%standard atmosphere of the ambient air
[~,~,T_air,P_air]=stdatmo(altitude);     %SI  (standard atmosphere)
T_H2 = T_air;
P_H2 = P_air;
rho_H2 = P_H2 / (R_H2 * T_H2);
SOS_H2 = sqrt(gamma_H2 * R_H2 * T_H2);

end

