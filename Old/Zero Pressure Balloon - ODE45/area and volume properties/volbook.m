function [pdat,sdat]=volbook
% [pdat,sdat]=volbook example from
% Adv. Math. & Mech. Appl. Using MATLAB
% page 164
pdat={[4+i,4,3],[5,5+i]};  
sdat={[4+exp(i*linspace(pi,2*pi,51))],...
      [4.5+i+0.5*exp(i*linspace(0,pi,51))]};  