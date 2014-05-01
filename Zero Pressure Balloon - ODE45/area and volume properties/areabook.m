function [pdat,sdat]=areabook
% [pdat,sdat]=areabook creates data for
% a region consisting of a half annulus
% above a square having a square hole. For
% reference see page 158 of : "Advanced 
% Mathematics and Mechanics Applications
% Using MATLAB", 3rd Ed., Chapman Hall/CRC,
% 2003, by H. B. Wilson, L.H.Turcotte, and
% D. Halpern
pdat={}; sdat={};

% polygon data
pdat(1)={[1,5,5,1,1; 1,1,5,5,1]};
pdat(2)={[2,2,4,4,2; 2,4,4,2,2]};
pdat(3)={[1,2; 6,6]}; pdat(4)={[4,5; 6,6]};

% spline data
u=linspace(0,pi,7); v=linspace(pi,0,7);
sdat(1)={[3+2*cos(u); 6+2*sin(u)]}; 
sdat(2)={[3+cos(v);6+sin(v)]}; 

