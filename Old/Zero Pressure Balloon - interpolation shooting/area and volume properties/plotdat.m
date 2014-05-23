function plotdat(pdat,sdat,titl)
% plotdat(pdat,sdat,titl) plots a geometry
% composed of splines and polygon lines
if nargin<3, titl='BOUNDARY DATA PLOT'; end
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
xlabel('x axis'), ylabel('y axis')
title(titl)
xmin=min(x); xmax=max(x);
ymin=min(y); ymax=max(y);
dx=0.1*(xmax-xmin); dy=0.1*(ymax-ymin);
range=[xmin-dx,xmax+dx,ymin-dy,ymax+dy];
axis(range), axis equal, hold off
shg