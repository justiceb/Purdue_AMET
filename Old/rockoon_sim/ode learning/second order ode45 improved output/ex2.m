clc; clear; close all;

%run ode45 solver
timerange = [0 15];
init = [600 0];
[t, outputs] = ode45(@myfunc, timerange, init);

%extract outputs
y = outputs(:,1);
ydot = outputs(:,2);

%run myfunc once last time to solve for dependant variables
for n = 1:1:length(y)
    [outputs, data] = myfunc(t(n), [y(n) ydot(n)]);
    ydotdot(n) = outputs(2); 
    a(n) = data.a;
    b(n) = data.b;
end

%plot results
plot(t,y,t,ydot,t,ydotdot)
legend('y','ydot','ydotdot')
