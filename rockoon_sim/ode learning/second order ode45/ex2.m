clc; clear; close all;

timerange = [0 15];
init = [600 0];
[t, outputs] = ode45(@myfunc, timerange, init);

y = outputs(:,1);
ydot = outputs(:,2);
outputs = myfunc(0, [y,ydot]');
ydotdot = outputs(2,:);

plot(t,y,t,ydot,t,ydotdot)
legend('y','ydot','ydotdot')
