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