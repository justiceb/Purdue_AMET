function CD = sphere_CD( RE )
% references:
% http://www.chem.mtu.edu/~fmorriso/DataCorrelationForSphereDrag2013.pdf

CD = (24./RE) + (2.6*(RE./5))/(1+(RE./5).^1.52) + 0.411*(RE/263000).^-7.94./(1+(RE/263000).^-8) + RE.^0.8/461000;

end

