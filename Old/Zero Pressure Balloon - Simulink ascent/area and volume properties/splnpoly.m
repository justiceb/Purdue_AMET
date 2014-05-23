function [Area,Ax,Ay,Ixx,Iyy,Pxy]=splnpoly(type,xd,yd,doplot)
% [Area,Ax,Ay,Ixx,Iyy,Pxy]=splnpoly(type,xd,yd,doplot)
% Inertial properties contributions of a cubic spline or 
% polyline boundary part are computed. If the first and 
% last data points match,then a closed boundary is defined.
if nargin==0 % example ellipse geometry
  th=linspace(0,2*pi,41); xd=1+cos(th); yd=1+.5*sin(th); 
  type=1; doplot=1;
end 
if exist('doplot','var')
  if type ==1
    nd=length(xd); zd=xd(:)+i*yd(:); 
    z=spline(1:nd,xd(:)+i*yd(:),linspace(1,nd,81));
    plot(real(z),imag(z),'k',xd,yd,'.r')
  else
    plot(xd,yd,'k')
  end
  axis equal, xlabel('x axis'), ylabel('y axis')
  title('PLOT OF THE BOUNDARY DATA'), shg, pause
end
Area=xymom(type,xd,yd,0,0); Ax=xymom(type,xd,yd,1,0);
Ay=xymom(type,xd,yd,0,1);   Ixx=xymom(type,xd,yd,0,2);
Iyy=xymom(type,xd,yd,2,0);  Pxy=xymom(type,xd,yd,1,1); 