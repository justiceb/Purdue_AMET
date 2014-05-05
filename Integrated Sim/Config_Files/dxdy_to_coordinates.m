function [ long, lat ] = dxdy_to_coordinates( sx, sy, long0, lat0 )
%constants
r_earth = 6371000;            %(m) earth radius

%calc
long = long0;
lat = lat0;
for n = 1:1:length(sx)
    if n==1
    else
        dx = sx(n) - sx(n-1);        %(m) change in x position during this time slice
        dy = sy(n) - sy(n-1);        %(m) change in y position during this time slice
        
        meters_per_deg_long = (2*pi/360) * r_earth * cosd(lat(end));  %(m/deg) long
        meters_per_deg_lat = (2*pi/360) * r_earth;                   %(m/deg) lat
        
        dlong = dx / meters_per_deg_long;   %(deg)
        dlat = dy / meters_per_deg_lat;   %(deg)
        
        long(n) = long(end) + dlong;
        lat(n) = lat(end) + dlat;
    end
end

end

