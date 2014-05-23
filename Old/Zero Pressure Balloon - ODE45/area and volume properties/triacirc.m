function [pdat,sdat]=triacirc
% This function defines a semicircle on the
% right joined with a triangle on the left.
% The combined centroid is at (3,0).

sdat=3+exp(i*linspace(-pi/2,pi/2,21)); 
pdat=[3,3-sqrt(2),3]+i*[1,0,-1]; 
