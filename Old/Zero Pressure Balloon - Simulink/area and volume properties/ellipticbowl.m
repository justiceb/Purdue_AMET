function ellipticbowl
% Example 8: Elliptic Bowl with a Semi-circular Rim
titl='Example 8: Elliptic Bowl';
a=2; b=1; t=.3; s1=[a*cos(pi/2*(-1:1/30:0));...
b*sin(pi/2*(-1:1/30:0))]; s2=(a-t)/a*s1(:,end:-1:1);
s3=a-t/2+t/2*exp(i*pi*(0:1/5:1)); s={s1,s2,s3};
volprop(i*[-b+t,-b],s,0,360,titl,1);