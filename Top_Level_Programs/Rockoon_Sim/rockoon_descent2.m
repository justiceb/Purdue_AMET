function descent = rockoon_descent2( input_filename )
%% Inputs (Mission Criteria)
load(input_filename) %load the following input parameters
% long0
% lat0
% alt0
% wind
% m_payload
% vx0
% vy0 
% alt_chute 
% Afin 
% Drocket 
% Dparachute

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
[ long1, lat1, sz1, data1 ] = descent_trajectory( long0, lat0, alt0, alt_chute, wind, CD, Aref, mass, vx0, vy0 );
sx1 = data1.sx;
sy1 = data1.sy;
t1 = data1.t;

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
[ long2, lat2, sz2, data2 ] = descent_trajectory( long0, lat0, alt0, alt_end, wind, CD, Aref, mass, vx0, vy0 );
sx2 = data2.sx;
sy2 = data2.sy;
t2 = data2.t;


%% Formulate output
descent.t1 = t1;
descent.sx1 = sx1;
descent.sy1 = sy1;
descent.sz1 = sz1;
descent.long1 = long1;
descent.lat1 = lat1;

descent.t2 = t2;
descent.sx2 = sx2;
descent.sy2 = sy2;
descent.sz2 = sz2;
descent.long2 = long2;
descent.lat2 = lat2;


end

