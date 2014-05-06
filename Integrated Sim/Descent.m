%% Inputs
long0 = rockoon.long(end);
lat0 = rockoon.lat(end);
alt0 = rockoon.sz(end);
wind = config.wind;
m = balloon.m_payload;
vx0 = rockoon.vxx(end);
vy0 = rockoon.vyy(end);
alt_end = input.alt_chute;
Afin = input.Afin;
Drocket = input.Drocket;
Dparachute = input.Dparachute;

%% Drogue Descent
%constants
CDf = 1.42;
CDbt = 0.56;
nu = 1.41;

%Determine CD and Aref
CD = 1;
Arocket = pi * (Drocket/2)^2;
Aref = (CDf * Afin) + (CDbt * Arocket);

% Run ODE45 solver
[ long1, lat1, sz1, data1 ] = descent_trajectory( long0, lat0, alt0, alt_end, wind, CD, Aref, m, vx0, vy0 );

%% Parachute Descent
%determine starting criteria from ending of drogue descent
long0 = long1(end);
lat0 = lat1(end);
alt0 = sz1(end);
alt_end = 0;
vx0 = data1.vx(end);
vy0 = data1.vy(end);

%determine parachute drag criteria
CD = 1.5;
Aref = pi * (Dparachute/2)^2;

% Run ODE45 solver
[ long2, lat2, sz2 ] = descent_trajectory( long0, lat0, alt0, alt_end, wind, CD, Aref, m, vx0, vy0 );









