function [Area,xcent,ycent,Ixx,Iyy,Ixy]=ellipsecheck(n)
% [Area,xcent,ycent,Ixx,Iyy,Ixy]=ellipsecheck(n) checks
% checks how accurately a spline represents an ellipse
if nargin==0, n=81; end
a=2; b=1; th=linspace(0,2*pi,n);
xd=a+a*cos(th); yd=b+b*sin(th);
[Area,Ax,Ay,Ixx,Iyy,Pxy]=splpol(1,xd,yd,1);
disp(' ')
disp('Ellipse ((x-a)/a)^2+((y-b)/b)^2 = 1')
disp('     for a = 2 and b = 1'), disp(' ')
xcent=Ax/Area; ycent=Ay/Area;
format long
disp(['Area/(pi*a*b)       = ',num2str(Area/(pi*a*b))])
disp(['xcent/a             = ',num2str(xcent/a)])
disp(['ycent/b             = ',num2str(ycent/b)])
disp(['Ixx/(1.25*pi*a*b^3) = ',num2str(Ixx/(1.25*pi*a*b^3))])
disp(['Iyy/(1.25*pi*a^2*b) = ',num2str(Iyy/(1.25*pi*a^3*b))])
disp(['Pxy/(pi*a^2*b^2)    = ',num2str(Pxy/(pi*a^2*b^2))])
format short

function [Area,Ax,Ay,Ixx,Iyy,Pxy]=splpol(type,xd,yd,doplot)
% [Area,Ax,Ay,Ixx,Iyy,Pxy]=splpol(type,xd,yd,doplot)
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
  title('ELLIPSE APPROXIMATED BY A SPLINE CURVE'), shg
end
Area=xymom(type,xd,yd,0,0); Ax=xymom(type,xd,yd,1,0);
Ay=xymom(type,xd,yd,0,1);   Ixx=xymom(type,xd,yd,0,2);
Iyy=xymom(type,xd,yd,2,0);  Pxy=xymom(type,xd,yd,1,1); 