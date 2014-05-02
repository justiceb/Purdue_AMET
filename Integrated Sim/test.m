s = (0:1:100000) * 0.3048;

[rho_air,SOS,T,P,nu,ZorH]=stdatmo(s);     %SI  (standard atmosphere)

figure(1)
plot(nu)