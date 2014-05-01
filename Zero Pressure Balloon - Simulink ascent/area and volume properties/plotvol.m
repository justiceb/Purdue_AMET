function plotvol(pdat,sdat,t1,t2,titl,nrot,nspl)
% plotvol(pdat,sdat,t1,t2,titl,nrot,nspl)
% plots a volume of revolution, with the cross-
% section composed of splines and polygon lines
if nargin<7, nspl=21; end, if nargin<6, nrot=30; end
if nargin<5, titl='VOLUME OF REVOLUTION'; end
if nargin<4, t1=-90; t2=270; end
if nargin==0, [pdat,sdat]=feval(@volbook); end
pdat=chkdat(pdat); sdat=chkdat(sdat);
t1=pi/180*t1; t2=pi/180*t2;
nrot=max(nrot,ceil(20*abs(t2-t1)/(2*pi)));
thr=linspace(t1,t2,nrot+1); cr=cos(thr); sr=sin(thr);
ns=length(sdat); np=length(pdat); x=[]; y=[];
hold off
close
big=1e300; xmin=big; ymin=big; zmin=big;
xmax=-big; ymax=-big; zmax=-big;
if ~isempty(sdat)
  for j=1:ns
    u=sdat{j};
    n=size(u,2); tp=linspace(1,n,nspl)';
    zp=spline(1:n,u(1,:)+i*u(2,:),tp); 
    X=real(zp)*cr; Y=real(zp)*sr; Z=imag(zp)*ones(1,nrot+1);
    xmin=min([xmin;X(:)]); xmax=max([xmax;X(:)]);
    ymin=min([ymin;Y(:)]); ymax=max([ymax;Y(:)]);
    zmin=min([zmin;Z(:)]); zmax=max([zmax;Z(:)]);  
    surf(X,Y,Z), colormap([1 1 0]), hold on    
  end
end
if ~isempty(pdat)
  for j=1:np
    u=pdat{j};  
    X=u(1,:)'*cr; Y=u(1,:)'*sr; Z=u(2,:)'*ones(1,nrot+1);
    xmin=min([xmin;X(:)]); xmax=max([xmax;X(:)]);
    ymin=min([ymin;Y(:)]); ymax=max([ymax;Y(:)]);
    zmin=min([zmin;Z(:)]); zmax=max([zmax;Z(:)]);
    surf(X,Y,Z), colormap([1 1 0]), hold on     
  end
end
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
title(titl) 
dx=0.1*(xmax-xmin); dy=0.1*(ymax-ymin); dz=0.1*(zmax-zmin); 
range=[xmin-dx,xmax+dx,ymin-dy,ymax+dy,zmin-dz,zmax+dz];
axis equal, axis(range), hold off
shg