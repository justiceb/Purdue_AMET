function [ sx, sy ] = coordinates_to_dxdy( long, lat )
%constants
r_earth = 6371000;            %(m) earth radius

%calc
sx = 0;
sy = 0;
for n = 1:1:length(long)
    if n==1
    else
        dlong = long(n) - long(n-1);   %(degrees) change in long position during this time slice
        dlat = lat(n) - lat(n-1);      %(degrees) change in lat position during this time slice
        
        meters_per_deg_long = (2*pi/360) * r_earth * cosd(lat(n));  %(m/deg) long
        meters_per_deg_lat = (2*pi/360) * r_earth;                   %(m/deg) lat
        
        dx = meters_per_deg_long * dlong;   %(m)
        dy = meters_per_deg_lat * dlat;     %(m)
        
        sx(n) = sx(end) + dx; %m
        sy(n) = sy(end) + dy; %m
    end
end

end

