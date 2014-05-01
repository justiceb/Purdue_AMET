 function readme
% Computation of geometrical properties of plane areas including
% the area, centroidal coordinates, and inertial moments requires
% evaluation of integrals of the form: 
%              AreaIntegral(x^n*y^m*dxdy)
% Using Green's theorem, the area integral can be changed into
% the line integral:
%    1/(n+m+2)*LineIntegral(x^n*y^m*(x*y'(t)-y(t)*x'(t))dt 
% where t is the variable used to parameterize boundary parts.
% For piecewise linear parts (polylines), or piecewise cubic 
% parts (splines) the integrations can be done exactly or a
% Gauss formula or order 8 is sufficient to give exact results
% when the splines are treated one segment at a time. However,
% the MATLAB function quadgk evaluates the desired integrals so 
% efficiently that developing special methods is unnecessary.
% 
% When volume properties are computed, corresponding to an area
% rotated partially or completely about the z axis, integrals
% similar to those for areas are obtained, except that an extra
% factor of x is present int the integrands. The data structure
% used by function areaprop, which handles areas, and function
% volprop, which handles volumes of revolution, are the same 
% except volprop also requires two rotation angles to specify 
% a volume.
% 
% Executing the function EXAMPLES shows several geometries
% illustrating use of the programs. Studying that function and
% the associated data input functions should explain enough to
% to allow preparation of input data. The analytical formulation
% for the methods used appears in the book "Advanced Mathematics 
% and Mechanics Applications Using MATLAB", 3rd edition, 2003,
% CRC Press, by H.B. Wilson, L.A. Turcotte, and D. Halpern.
help readme