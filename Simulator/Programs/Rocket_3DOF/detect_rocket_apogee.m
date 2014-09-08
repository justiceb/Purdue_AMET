function [value,isterminal,direction] = detect_rocket_apogee(t, inputs, sz_0, rocksim, rasaero, wind, balloon_height, Drocket)
% Locate the time when height passes through zero in a decreasing direction
% and stop integration. 

%define inputs and outputs
%inputs = [sx, vx, sz, vz, theta, theta_dot]
%outputs = [vx, ax, vz, az, theta_dot, theta_dot_dot]
vz = inputs(4);    %(m/s)
value = vz;        % stop simulation when ascent rate reaches 0
isterminal = 1;   % yes, stop the integration when condition met
direction = -1;   % negative direction
end