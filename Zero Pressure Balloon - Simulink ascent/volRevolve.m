function vol = volRevolve(R,Z)
%VOLREVOLVE calculates the volume of a polygon revolved around the Z-axis.
%
% CALLING SEQUENCE / USAGE:
%
%   vol = volRevolve(R,Z)
%
% INPUTS:
%
%   R       One-dimensional vector (n-by-1 or 1-by-n) of R points
%   Z       One-dimensional vector (n-by-1 or 1-by-n) of Z points
%
% OUTPUTS:
%
%   vol     Volume of solid formed by revolving polygon formed by [R,Z]
%           lists of points around the Z-axis. Units are the square of the
%           units of the inputs.
%
% DESCRIPTION and NOTES:
%
%  - R and Z vectors must be in order, counter-clockwise around the area
%    being defined. If not, this will give the volume of the
%    counter-clockwise parts, minus the volume of the clockwise parts.
%
%  - It does not matter if the curve is open or closed - if it is open
%    (last point doesn't overlap first point), this function will
%    automatically close it.
%
%  - Based on Advanced Mathematics and Mechanics Applications with MATLAB,
%    3rd ed., by H.B. Wilson, L.H. Turcotte, and D. Halpern,
%    Chapman & Hall / CRC Press, 2002, e-ISBN 978-1-4200-3544-5.
%    See Chapter 5, Section 5.4, doi: 10.1201/9781420035445.ch5
%
% Function originally created 2012-05-03 by Geoffrey M. Olynyk.
%   (email: geoff at olynyk.name or golynyk at psfc.mit.edu)
% For details and notes, see notebook of G.M. Olynyk, dated 2012-05-03.

% UPDATE HISTORY:
%
%  2012-05-03: Function originally created. -G.M. Olynyk

% Check to make sure they're the same length, throw an error if not:
if ~(numel(R) == numel(Z)),
    err = MException('volRevolve:UnequalLengths', ...
        'Input coordinate vectors (R,Z) do not have same length') ;
    throw(err) ;
end

% Now that we know they're the same length, figure out what that length is:
n = numel(R) ;

% You have to have at least three points to define a polygon.
% Check that this is true and throw an error if it's not:
if n < 3,
    err = MException('volRevolve:NotEnoughPoints', ...
        'Input coordinate vectors must have at least three points') ;
    throw(err) ;
end

% Cast inputs to doubles:
R = double(R) ;
Z = double(Z) ;

% Check if last point overlaps first point; if it doesn't, add another
% point that does overlap the first point. (Note that we have to compare
% using a tolerance because these are floating-point values):
tol = 1.e-5 ; % (10 µm when using metres as input)

if (abs(R(end) - R(1)) < tol) && (abs(Z(end) - Z(1)) < tol),
    isClosed = true ;
else
    isClosed = false ;
end

% If it's not a closed curve, add a point to make it closed:
if ~isClosed,
    R(n+1) = R(1) ;
    Z(n+1) = Z(1) ;
end

clear n ;
clear isClosed ;

% Now, from the Wilson, Turcotte, and Halpern book, we note that if we have
% a closed curve defined by R(s), Z(s), 0 <= s <= 1, then the volume of the
% solid formed by revolving that curve around the Z axis is:
%
%   V = (2pi/3) * int( R(s) * [R(s)Z'(s) - Z(s)R'(s)] ds, s = 0..1)
%
% where R'(s) = dR/ds;  Z'(s) = dZ/ds. Since the boundary of our polygon is
% piecewise linear, these R'(s) and Z'(s) are constant on each line
% segment, and can be pre-calculated quickly. Note that the s values are
% equally spaced on each point. So, for example, if there are four line
% segments, the s values at points 1, 2, 3, 4, 5 are 0.00, 0.25, 0.50,
% 0.75, 1.00 respectively. (Note point 5 is on top of point 1.)

Rp = R(1:end-1) ;
Zp = Z(1:end-1) ;

dR = (R(2:end) - Rp) ;
dZ = (Z(2:end) - Zp) ;

% We can do an analytic integral for each of nSeg line segments. It has
% four parts, we calculate each of these as v1, v2, v3, v4, and then add
% them together to get the total integral. (Everything is worked out in
% notebook of G.M. Olynyk dated 2012-05-03.)

v1 = dR .* dZ .* Rp ;
v2 = 2 * dZ .* Rp.^2 ;
v3 = (-1) * dR.^2 .* Zp ;
v4 = (-2) * dR .* Rp .* Zp ;

V = (pi/3) * (v1 + v2 + v3 + v4) ;
vol = sum(V) ;



% Verification for circular toroid of major radius R0, minor radius a
% Volume is 2 * pi^2 * R0 * a^2. Run this code:

% clear all
% R0 = 5 ;
% a = 1 ;
% npoints = 100 ;
% theta = 2*pi*[0:1:npoints-1]'/double(npoints-1) ;
% R = R0 + a*cos(theta) ;
% Z =      a*sin(theta) ;
% vol_analytic = 2 * pi^2 * R0 * a^2 ;
%  >> 98.6960
% vol = volRevolve(R,Z) ;
%  >> 98.6298 (6.7e-04 relative error)

% Do it again with npoints = 1000, get:
%  >> 98.6954 (6.6e-06 relative error)

% As expected, it's always slightly small because the polygon inscribes the
% circle.



% Verification for washer (rectangular toroid), with the radius of the
% 'hole' in the washer being a, and the outer radius of the washer being b.
% (Thus the width of the metal cross section is b-a.) The height of the
% washer is h. Then the volume is pi * (b^2 - a^2) * h. Run this code:
%
% clear all
% a = 1 ;
% b = 2 ;
% h = 10 ;
% R = [a; b; b; a; a] ;
% Z = [0; 0; h; h; 0] ;
% vol_analytic = pi * (b^2 - a^2) * h ;
%  >> 94.2478
% vol = volRevolve(R,Z) ;
%  >> 94.2478

end % function