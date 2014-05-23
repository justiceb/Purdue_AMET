function v=splder(td,zd,t)
% v=splder(td,zd,t) cubic spline differentiation
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