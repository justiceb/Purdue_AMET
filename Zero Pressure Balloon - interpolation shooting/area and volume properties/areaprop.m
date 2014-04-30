function [Area,xcent,ycent,Axx,Ayy,Axy]=areaprop(pdat,sdat,titl,doplot)
% [Area,xcent,ycent,Axx,Ayy,Axy]=areaprop(pdat,sdat,titl,doplot)
% This program computes the area, centroidal coordinates, and
% inertial moments of general regions bounded by a series of
% polylines and spline curves. Several separate parts may be
% involved. For each part the outer boudary must be traversed
% counter-clockwise with any interior holes being traversed
% clockwise. For each closed boundary part, the first and last
% points must match. Cell arrays are employed to describe the
% boundary parts with variables pdat and sdat containing poly-
% line and spline data, respectively. Function areabook gives
% representative data case.If areaprop is run with no data input,
% then areabook is executed. When both pdat and sdat are given
% in an external procedure, then enter the procedure handle for
% pdat and use {} for the sdat variable.
% pdat        - a cell array to define polylines boundary parts.
%               A part is defined by by a matrix with with x
%               values in the first row and y values in the 
%               second row. For instance, a square of unit side
%               length centered at (2.5,2.5) could be given as
%               [1 2 2 1 1; 2 2 3 3 2] or in complex form as
%               [1.5+2.5i+sqrt(2)*exp(i*pi*(1/4:2/4:9/4))].
% sdat        - This variable defines spline interpolated parts
%               of the boundary. It has the same structure as
%               pdat.
% titl        - a title to identify the printout and boundary
%               plot. Use [] if no title is desired.
% doplot      - doplot = -1 for no print of results or plots. 
%               doplot =  0 to print results without a plot.
%               doplot =  1 prints both output and a plot
% Area        - the combined area of all parts
% xcent,ycent - centroidal coordinates
% Axx,Ayy,Axy - integrals of x^2dxdy, y^2dxdy, and xydxdy, 
%               respectively

%               HBW, 9/16/09
if ~exist('doplot','var'), doplot=0; end
if nargin<3, titl='Boundary Plot'; end
if nargin==0
  pdat=@areabook; sdat={}; doplot=1;
  titl='Example from Adv. Math. & Mech. Appl. page 158';
end 
if isa(pdat,'function_handle'), [pdat,sdat]=feval(pdat); end    
if ~isempty(pdat), pdat=chkdat(pdat); end
if ~isempty(sdat), sdat=chkdat(sdat); end
if doplot==1, plotdat(pdat,sdat,titl), end; %pause, end
Area=0; Ax=0; Ay=0; Axx=0; Ayy=0; Axy=0;
np=length(pdat); ns=length(sdat);
if ~isempty(pdat) % process polyline data
  for k=1:np
    u=pdat{k}; xd=u(1,:); yd=u(2,:);  
    [ak,axk,ayk,axxk,ayyk,axyk]=splnpoly(2,xd,yd);
    Area=Area+ak; Ax=Ax+axk; Ay=Ay+ayk;
    Axx=Axx+axxk; Ayy=Ayy+ayyk; Axy=Axy+axyk;
  end
end
if ~isempty(sdat) % process spline data
  for k=1:ns
    u=sdat{k}; xd=u(1,:); yd=u(2,:);  
    [ak,axk,ayk,axxk,ayyk,axyk]=splnpoly(1,xd,yd);
    Area=Area+ak; Ax=Ax+axk; Ay=Ay+ayk;
    Axx=Axx+axxk; Ayy=Ayy+ayyk; Axy=Axy+axyk;
  end
end
xcent=Ax/Area; ycent=Ay/Area;
if doplot>-1
   disp(' '), disp(titl) 
   outputa(Area,xcent,ycent,Axx,Ayy,Axy)
end

function outputa(Area,xcent,ycent,Axx,Ayy,Axy)
disp(['Area  = Integral(    dxdy)      = ',num2str(Area)]) 
disp(['xcent = Integral(  x*dxdy)/Area = ',num2str(xcent)])
disp(['ycent = Integral(  y*dxdy)/Area = ',num2str(ycent)])
disp(['Axx   = Integral(x*x*dxdy)      = ',num2str(Axx)])
disp(['Ayy   = Integral(y*y*dxdy)      = ',num2str(Ayy)])
disp(['Axy   = Integral(x*y*dxdy)      = ',num2str(Axy)])

function [Area,Ax,Ay,Axx,Ayy,Axy]=splnpoly(type,xd,yd,doplot)
% [Area,Ax,Ay,Axx,Ayy,Axy]=splnpoly(type,xd,yd,doplot)
% Inertial properties contributions of a cubic spline or 
% polyline boundary part are computed. If the first and 
% last data points match,then a closed boundary is defined.
if nargin==0        % example ellipse geometry
  th=linspace(0,2*pi,41); xd=1+cos(th); yd=1+.5*sin(th); 
  type=1; doplot=1;
end 
if exist('doplot','var')
  if type ==1       % spline part
    nd=length(xd); zd=xd(:)+i*yd(:); 
    z=spline(1:nd,xd(:)+i*yd(:),linspace(1,nd,81));
    plot(real(z),imag(z),'k',xd,yd,'.r')
  else
    plot(xd,yd,'k') % polyline part
  end
  axis equal, xlabel('x axis'), ylabel('y axis')
  title('PLOT OF THE BOUNDARY DATA'), shg, pause
end
Area=xymom(type,xd,yd,0,0); Ax=xymom(type,xd,yd,1,0);
Ay=xymom(type,xd,yd,0,1);   Axx=xymom(type,xd,yd,2,0);
Ayy=xymom(type,xd,yd,0,2);  Axy=xymom(type,xd,yd,1,1); 

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
% v=splder(td,zd,t) cubic spline diferentiation
%    HBW, 9/6/09
n=length(td);
if n>3
  [b,c]=unmkpp(spline(td,zd));
  c=[3*c(:,1),2*c(:,2),c(:,3)];
  v=ppval(mkpp(b,c),t);
elseif n==3
  c=[[1;1;1],td(:),td(:).^2]\zd(:);
  v=c(2)+2*c(3)*t;    
elseif n==2   
  v=(zd(2)-zd(1))/(td(2)-td(1))*ones(size(t));   
else
 v=nan;  
 error('More than 1 data point is required.')
end

function plotdat(pdat,sdat,titl)
% plotdat(pdat,sdat,titl) plots a geometry bounded
% by spline curves and polygon lines
if nargin<3, titl='Boundary Plot'; end
% disp(titl), pause
ns=length(sdat); np=length(pdat); x=[]; y=[];
hold off
close
if ~isempty(sdat)
  for j=1:ns
    u=sdat{j};
    n=size(u,2); tp=linspace(1,n,80);
    zp=spline(1:n,u(1,:)+i*u(2,:),tp);
    xp=real(zp); yp=imag(zp);
    x=[x,xp]; y=[y,yp];
    plot(xp,yp,'k'); hold on  
  end
end
if ~isempty(pdat)
  for j=1:np
    u=pdat{j}; x=[x,u(1,:)]; y=[y,u(2,:)];
    plot(u(1,:),u(2,:),'k'); 
    hold on 
  end
end
xlabel('x axis'), ylabel('y axis'), title(titl)
xmin=min(x); xmax=max(x);
ymin=min(y); ymax=max(y);
dx=0.1*(xmax-xmin); dy=0.1*(ymax-ymin);
range=[xmin-dx,xmax+dx,ymin-dy,ymax+dy];
axis(range), axis equal, hold off
shg

function u=chkdat(v)
u=v; f=@(z)[real(z(:))';imag(z(:))'];
if iscell(v)
  n=length(v); 
  for k=1:n
    if ~isreal(u{k}), u(k)={f(u{k})}; end
  end
else
  if all(imag(u)==0)
    u={[u(1,:);u(2,:)]};
  else
    u={f(v)};
  end
end