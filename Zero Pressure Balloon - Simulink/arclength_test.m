clc
h=0.00001;
x=0:h:2;
y=sqrt(1-(x-1).^2);
d1y =diff(y)/h;
f=sqrt(1+(d1y).^2);
trapz(x(:,1:length(f)),f)