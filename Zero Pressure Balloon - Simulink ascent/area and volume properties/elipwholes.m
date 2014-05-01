function [pdat,sdat]=elipwholes
% [pdat,sdat]=elipwholes creates an ellipse with
% a circular hole and a square hole
r=6; a=2; b=4; d=sqrt(pi/2); h=.4*b; n=80; t=2*pi*(0:1/n:1); 
pdat={r-h*i+d*exp(-i*pi*(0:1/2:2))*exp(i*pi/4)};
sdat={r+a*cos(t)+i*b*sin(t),r+i*h+exp(-i*t)};