%% Inputs
long0 = rockoon.long(end);
lat0 = rockoon.lat(end);
alt0 = rockoon.sz(end);
alt_end = 0;
wind = ascent.wind;
CD = 1;
Aref = 5;
m = 3;
vx0 = 0;
vy0 = 0;

%% Parachute descent
[ long, lat, sz ] = descent_trajectory( long0, lat0, alt0, alt_end, wind, CD, Aref, m, vx0, vy0 );









