%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hrishi Shah
% Generalized Newton Raphson Method
% Direct Substitution File
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function var1=method2()
% specify parameters here
bx=1;
by=1; 
l1=2; 
l2=3; 
ex=3; 
ey=4;
% specify symbolic variables here
syms th1 th2 real 
var=[th1 th2]; % variables matrix 
% specify function lists here
f(1,1)= bx+l1*cos(th1)+l2*cos(th1+th2)-ex; %functions array 
f(2,1)= by+l1*sin(th1)+l2*sin(th1+th2)-ey; %functions array 
% specify initial values here
var1=[0.1 0.1 ]'; 
% tolerance
tol=0.0001;
% maximum number of iterations
nmax=30; 
%% Core Code - no changes required
numvar=length(var); 
numeq=length(f); 
for j=1:numeq 
for i=1:numvar 
    J(j,i)=diff(f(j),var(i)); 
end 
end 
n=0;  
dmain=1.1*tol*ones(size(var,1)); 
 
while(any(abs(dmain)>tol)&&(n<nmax)) 
    f1=subs(f,var,var1); 
    J1=subs(J,var,var1); 
    if(abs(det(J1))>tol*tol) % remove when numel(f)~=numel(variables)
    dmain=inv(J1)*f1; 
    end % remove when numel(f)~=numel(variables)
    var1=var1-dmain; 
    n=n+1; 
end 
if(n==nmax) 
    error('no feasible solution'); % specify values if in-feasible
end 
return