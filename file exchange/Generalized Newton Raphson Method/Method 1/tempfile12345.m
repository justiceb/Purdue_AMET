
function var1=tempfile12345()
bx=1; 
by=1; 
l1=2; 
l2=3; 
ex=3; 
ey=4; 
syms th1 th2 th3 real 
var=[th1 th2 th3 ]'; % variables matrix 
f(1,1)= 2*bx+l1*cos(th1)+l2*cos(th1+th2+th3)-ex; %functions array 
f(2,1)= by+l1*sin(th1)+l2*sin(th1+th2+th3)-ey  ; %functions array 
var1=[0.1 0.1 0.1 ]'; 
tol=0.0001; 
nmax=30; 
%% Core Code 
numvar=length(var); 
numeq=length(f); 
for j=1:numeq 
for i=1:numvar 
    J(j,i)=diff(f(j),var(i)); 
end 
end 
n=0;  
dmain=0.1*ones(size(var,1),1); 
 
while(any(abs(dmain)>tol)&&(n<nmax)) 
    f1=subs(f,var,var1); 
    J1=subs(J,var,var1); 
    dmain=pinv(J1)*f1; 
    var1=var1-dmain; 
    n=n+1; 
end 
if(n==nmax) 
    error('no feasible solution'); 
end 
return 