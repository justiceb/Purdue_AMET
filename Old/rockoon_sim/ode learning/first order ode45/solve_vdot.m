function v_dot = solve_vdot( t , v )

g = 9.81;
m = 80;
v_dot = -g + (4/15) * (v.^2/m);

end

