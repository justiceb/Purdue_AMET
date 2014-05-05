function [value,isterminal,direction] = detect_apogee(t, inputs, m_system, Vdeployed, wind, dt)
% Locate the time when height passes through zero in a decreasing direction
% and stop integration.  
v = inputs(2);    %(m/s)
value = v;        % stop simulation when ascent rate reaches 0
isterminal = 1;   % yes, stop the integration when condition met
direction = -1;   % negative direction
end