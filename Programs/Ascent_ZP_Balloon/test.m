g = 9.81;           %m/s/s
T_H2 = 10+273;      %K hydrogen temp
T_air = 15+273;     %K air temp
R_H2 = 4124;        %(J/kg-K) specific gas constant hydrogen
R_air = 287.058;    %(J/kg-K) specific gas constant air
CP_H2 = 14.32*1000; %(J/kg-K) specific heat in constant pressure hydrogen
vz = 3;             %(m/s) ascent rate

Tdot = - (g*(T_H2/T_air)*(R_H2/R_air)*vz) * (1/CP_H2)