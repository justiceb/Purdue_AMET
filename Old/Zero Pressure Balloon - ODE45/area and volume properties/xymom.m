function v=xymom(type,xd,yd,n,m)
% v=xymom(type,xd,yd,n,m) integrates x^n*y^m*dx*dy 
% for an area bounded by either a cubic spline or a 
% polygon defined by data points xd,yd traversing
% the boundary in the a counter-clockwise sense.
% xd,yd - data points on the boundary
% n,m   - exponents for x^n*y^m
% type  - 1 for a spline or 2 for a polyline
% v     - value of the integral
zd=xd(:)+i*yd(:); nd=length(zd); td=1:nd; 
if type==1 | nargin< 5 % use a spline curve 
  v=quadgk(@(t)intgrn(td,zd,n,m,t),td(1),td(end));   
else                   % use a polyline
  f=@(z)real(z).^n.*imag(z).^m.*conj(z);
  v=quadgk(f,zd(1),zd(end),'waypoints',zd(2:end-1)); 
  v=imag(v);
end
v=v/(n+m+2); 

function v=intgrn(td,zd,n,m,t)
% v=intgrn(td,zd,n,m,t)
z=spline(td,zd,t); zp=splder(td,zd,t);
v=real(z).^n.*imag(z).^m.*imag(conj(z).*zp); 

function v=splder(td,zd,t)
% v=splder(td,zd,t) spline diferentiation
%    HBW, 9/6/09
[b,c]=unmkpp(spline(td,zd));
c=[3*c(:,1),2*c(:,2),c(:,3)];
v=ppval(mkpp(b,c),t);