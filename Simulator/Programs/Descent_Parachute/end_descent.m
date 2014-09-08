function [value,isterminal,direction] = end_descent(t, inputs, wind, CD, Aref, m, alt_end)

%define inputs and outputs
%inputs = [sx, vx, sy, vy, sz, vz]
%outputs = [vx, ax, vy, az, vz, az]
sz = inputs(5);

value = sz - alt_end;  % stop simulation when sz = alt_end
isterminal = 1;        % yes, stop the integration when condition met
direction = -1;        % negative direction
end

