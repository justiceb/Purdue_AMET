function [pdat,sdat]=torconedat
% [pdat,sdat]=torconedat creates data for
% a torus and a cone
a=1; b=.5; h=2; d=1.5;
sdat=1+b+b*exp(i*linspace(-pi,pi,51));
pdat=[0,d+i*h,i*h,-i*h,d-i*h,0];
