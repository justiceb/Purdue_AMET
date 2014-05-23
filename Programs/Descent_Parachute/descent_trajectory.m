function [ long, lat, sz, data ] = descent_trajectory( long0, lat0, alt0, alt_end, wind, CD, Aref, m, vx0, vy0 )

%% run ode45 solver
sx0 = 0;
sy0 = 0;
sz0 = alt0;
vz0 = -0.000001;
timerange = [0 50000];
init = [sx0, vx0, sy0, vy0, sz0, vz0];
options = odeset('Events',@end_descent);
[t, outputs] = ode45(@Descent_Calc, timerange, init, options, wind, CD, Aref, m, alt_end);

%extract outputs
sx = outputs(:,1);
vx = outputs(:,2);
sy = outputs(:,3);
vy = outputs(:,4);
sz = outputs(:,5);
vz = outputs(:,6);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(sz)
    inputs = [sx(n), vx(n), sy(n), vy(n), sz(n), vz(n)];
    [~, data] = Descent_Calc(t(n), inputs, wind, CD, Aref, m, alt_end);
    ax(n) = data.ax;
    ay(n) = data.ay;
    az(n) = data.az;
end

%% Convert x,y distances to GPS coordinates
[ long, lat ] = dxdy_to_coordinates( sx, sy, long0, lat0 );

%% Package extra data we might want in the future
data.vx = vx;
data.vy = vy;
data.sx = sx;
data.sy = sy;
data.t = t;

end










