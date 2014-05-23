% Ten examples are given which show use 
% of functions areaprop and volprop

%       HBW, 9/29/09

function examples
% Example 1: A square with a circular hole
clc, close all
xy=[1 3 3 1 1; 1 1 3 3 1];
z=exp(2i*pi*(0:1/40:1));
titl='Example 1 : Square With Circular Hole';
areaprop(xy,2+2i+0.5*conj(z),titl,1); pause,clc

% Example 2: Rotate the area in Example 1 to make a solid
titl='Example 2: Area from Example 1 Rotated';
volprop(xy,2+2i+.5*conj(z),-90,90,titl,1); pause,clc

% Example 3: Place the circle outside the square
titl='Example 3: A Circle and Square Separated';
xy=[1 3 3 1 1; 1 1 3 3 1];
z=2+6i+exp(2i*pi*(0:1/40:1));
areaprop(xy,z,titl,1); pause,clc

% Example 4: Two semi-circles and a square combined
titl='Example 4: Two Semicircles and a Square';
c=exp(i*pi*(0:1/30:1)); sdat={[4-c],[4.5+i+.5*c]};
pdat={[4+i,4,3],[5,5+i]};
areaprop(pdat,sdat,titl,1); pause, clc

% Example 5: Rotate the area from Example 4
titl='Example 5: Area from Example 4 Rotated';
volprop(pdat,sdat,-90,180,titl,1); pause, clc

% Examples 6: A half annulus and a square 
% with a square hole
titl='Example 6: A Half Annulus and Square';
sc=exp(i*pi*(0:1/30:1)); sq=sqrt(2)*exp(i*pi*(1/4:1/2:9/4));
pdat={3+3i+2*sq,3+3i+sq(end:-1:1)};
sdat={[1+6i,2+6i],[4+6i,5+6i],3+6i+2*sc,3+6i+sc(end:-1:1)};
areaprop(pdat,sdat,titl,1); pause, clc

% Example 7:  Rotate the area from Example 6
titl='Example 7: Area from Example 6 Rotated';
volprop(pdat,sdat,0,180,titl,1); pause, clc

% Example 8: Elliptic Bowl with a Semi-circular Rim
titl='Example 8: Elliptic Bowl';
a=2; b=1; t=.3; s1=[a*cos(pi/2*(-1:1/30:0));...
b*sin(pi/2*(-1:1/30:0))]; s2=(a-t)/a*s1(:,end:-1:1);
s3=a-t/2+t/2*exp(i*pi*(0:1/5:1)); s={s1,s2,s3};
volprop(i*[-b+t,-b],s,0,360,titl,1); pause, clc

% Example 9: Ellipse with a Circular and a Square Hole
titl='Example 9: Ellipse with Two Holes'; 
volprop(@elipwholes,{},-90,180,titl,2); pause, clc

% Example 10: Torus and Cone
titl='Example 10: Torus and Cone';
volprop(@torcone,{},0,360,titl,1);