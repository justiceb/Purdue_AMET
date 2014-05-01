%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hrishi Shah
% Generalized Newton Raphson Method
% Example Input File
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% close all
% clc
%% Important Values - All Inputs are column vectors
variables=['th1';'th2';'th3']; % variable values
 % functions to be evaluated - should have same number of characters
 % write beneath each other and add spaces if necessary
functions=['2*bx+l1*cos(th1)+l2*cos(th1+th2+th3)-ex';
           'by+l1*sin(th1)+l2*sin(th1+th2+th3)-ey  '];
%% Optional Values
paramnames =['bx';'by';'l1';'l2';'ex';'ey']; % parameter names
paramvalues=[   1;   1;   2;   3;   3;   4]; % parameter values
tol  = 1e-4;                                 % tolerance value for convergence
nmax = 30;                                   % maximum number of iterations 
initial_values=[0.1;0.1;0.1];                % initial values

var1=newton_raphson(functions, variables, paramnames, paramvalues);%, initial_values, tol, nmax);
disp(var1);