%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hrishi Shah
% Generalized Newton Raphson Method
% File Generation and Evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function var1=newton_raphson(f, variables, paramnames, paramvalues, initial_values, tol, nmax)
%%
if nargin<2
    error('insufficient number of inputs, enter atleast two inputs of functions and variable names');
end
if nargin<4
   paramnames=[]; paramvalues=[]; 
end
if nargin<5
    initial_values=0.1*ones(size(variables,1),1);
end
if nargin<6
    tol=1e-4;
end
if nargin<7
    nmax=30;
end
fid=fopen('tempfile12345.m','w+');

fprintf(fid,'\nfunction var1=tempfile12345()');
% write parameters to file
for i=1:size(paramnames,1)
fprintf(fid,'\n%s=%g; ',paramnames(i,:),paramvalues(i));
end

% write symbolic variables to file
fprintf(fid,'\nsyms ');
for i=1:size(variables,1)
fprintf(fid,'%s ',variables(i,:));
end
fprintf(fid,'real ');

fprintf(fid,'\nvar=[');
for i=1:size(variables,1)
fprintf(fid,'%s ',variables(i,:));
end
fprintf(fid,']''; %% variables matrix ');

% write functions to file
for i=1:size(f,1)
fprintf(fid,'\nf(%d,1)= %s; %%functions array ',i,f(i,:));
end

% write initial values to file
fprintf(fid,'\nvar1=[');
for i=1:size(variables,1)
    fprintf(fid,'%g ',initial_values(i));
end
fprintf(fid,']''; % initial approximation ');
fprintf(fid,'\ntol=%g; % tolerance values ',tol);
fprintf(fid,'\nnmax=%d; % maximum number of iterations ',nmax);
fprintf(fid,'\n%%%% Core Code ');
fprintf(fid,'\nnumvar=length(var); ');
fprintf(fid,'\nnumeq=length(f); ');
fprintf(fid,'\nfor j=1:numeq ');
fprintf(fid,'\nfor i=1:numvar ');
fprintf(fid,'\n    J(j,i)=diff(f(j),var(i)); ');
fprintf(fid,'\nend ');
fprintf(fid,'\nend ');
fprintf(fid,'\nn=0;  ');
fprintf(fid,'\ndmain=0.1*ones(size(var,1),1); ');
fprintf(fid,'\n ');
fprintf(fid,'\nwhile(any(abs(dmain)>tol)&&(n<nmax)) ');
fprintf(fid,'\n    f1=subs(f,var,var1); ');
fprintf(fid,'\n    J1=subs(J,var,var1); ');
% fprintf(fid,'\n    if(abs(det(J1))>tol*tol) '); % if a determinant check
% is required - works only if numel(f)==numel(variables)
fprintf(fid,'\n    dmain=pinv(J1)*f1; ');
% fprintf(fid,'\n    end '); % end statement for determinant check
fprintf(fid,'\n    var1=var1-dmain; ');
fprintf(fid,'\n    n=n+1; ');
fprintf(fid,'\nend ');
fprintf(fid,'\nif(n==nmax) ');
fprintf(fid,'\n    error(''no feasible solution''); ');
fprintf(fid,'\nend ');
fprintf(fid,'\nreturn ');
fclose(fid);
var1=feval(@tempfile12345);
% winopen('tempfile12345.m'); % to open file used to get the results