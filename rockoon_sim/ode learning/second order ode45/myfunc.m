function outputs = myfunc( t, inputs )
%inputs = [y, ydot]
%outputs = [ydot, ydotdot]

g = 9.81;
m = 80;
y = inputs(1,:);
ydot = inputs(2,:);
outputs = [ydot ; -g + 4/15 * ydot.^2/m]; 

end

