% Authors:
%           Brent Justice - justiceb@purdue.edu
%           Ian Means
% Purpose:
%           Design contour for zero pressure balloon
%           With given mission criteria
% References:
%           "A Parallel Shooting Method for Determining the Natural
%            shape of a Large Scientific Balloon", Frank Baginski,
%            William Collier, Tami Williams
%
%           "Scientific Ballooning", Nobuyuki Yajima, Naoki Izutsu,
%            Takeshi Imamura, Toyoo Abe
%{
The balloon shape is determined early on in the design process with a
predicted payload weight.  All of these design inputs are placed at the top
of the create_balloon script file.  Once the balloon is created, these
inputs cannot be changed.  However, we often find that the actual measured
payload weight on the day of the launch is slightly different from the
designed payload weight.  We also often find that the balloon weight is
slightly different.  For the remainder of this integrated sim, we will use 
these measure values for increased sim accuracy.  The only value that we
extract from the balloon_shape sim is the balloon volume when fully 
deployed.  This will stay relatively accurate for small deviations from
the designed payload weight.
%}

%% Dependencies
Parent = pwd;
NAME = 'null';
while ~strcmp(NAME,'Matlab')
    [Parent,NAME,EXT] = fileparts(Parent);
end
Parent = strcat(Parent,'\',NAME,'\');
addpath(genpath(strcat(Parent,'Common_Functions')));

%% Inputs (Mission Criteria)
rho_PE = 1000;                 %kg/m^3  density of polyethlyene we purchased
thickness_PE = 18 * 1E-6;     %m  thickness of polyethylene we purchased
Wpayload = 10*4.44822162;      %N  payload weight
alt_apogee = 70000 * 0.3048;  %altitude at apogee (m)
numGores = 7;                %number of gores

%constants  (mission criteria and materials)
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)
goreTheta = (2*pi)/numGores;  %radians rotation per gore

%% float conditions (at apogee)
[rho_air,a_apogee,T,P,nu,ZorH]=stdatmo(alt_apogee);   %SI  (standard atmosphere)
rho_H2 = P/(R_H2*T);                           %Ideal gas law, assume ambient pressure
a = 0;                                         %distance from zero pressure line to base (0 for apogee)
k = (2*pi)^(-1/3);                             %constant of geometry
tb = 1;                                        % == b/bd  == 1 at apogee
rho = 1;                                       % == w/wd  == 1 at apogee
bd = (rho_air - rho_H2) * g;                   %effective bouyant force per unit volume at apogee  (N/m^3)
wd = rho_PE * thickness_PE;                    %mass per unit area of PE at apogee (kg/m^2)  [changes with altitude]
lambda = (Wpayload/bd)^(1/3);                  %shaping parameter (m)
epsilon = (2*pi)^(1/3) * wd * g / (bd*lambda); %shaping parameter []
a_dash = a/lambda; 

%print sizing parameters in english units (easier to digest)
fprintf('bd = %f lbs/ft^3 \n',bd / 157.087464)
fprintf('Payload = %f lbs \n',Wpayload / 4.44822162)
fprintf('lambda = %f ft\n',lambda*3.28084)
fprintf('wd = %f lbs/ft^2 \n',wd *0.204816144)
fprintf('epsilon = %f \n',epsilon)
fprintf('Number of gores = %f\n', numGores)

%% Shooting method simulation for finding gore contour shape
%constant initial conditions
r0 = 0;              %radius at base = 0
z0 = 0;              %height at base = 0
S0 = 0;              %area at base = 0
V0 = 0;              %volume at base = 0

%final value conditions
r_end_condition = 0;       %radius at apex = 0
theta_end_condition = -pi/2;    %angle at apex = -90 (radians)

%iterate
theta_end_error = 0.1;                         %set error high to enter loop
theta_0_guess = 60 * 0.0174532925;             %angle at base (rads)  [GUESS]
m0 = 2*pi*cos(theta_0_guess);                  %calculation dependant on guess
while abs(theta_end_error) > 0.00174532925     %while error high, keep iterating
    r_end_error = 2;                            %set error high to enter loop
    s_dash_end_guess = 2;                       %arclength of gore (m/lambda) [GUESS]
    while abs(r_end_error) > 0.001               %shooting method until error for r is small
            sim('natural_balloon')              %run simulink model
            s_dash = simout.time;               %format sim outputs
            z_dash = simout.data(:,1);
            r_dash = simout.data(:,2);
            S_dash = simout.data(:,4);
            V_dash = simout.data(:,5);
            theta = simout.data(:,3);
            
            %Calcuate non-dashed values
            r = r_dash*lambda; %m
            s = s_dash*lambda; %m
            z = z_dash*lambda; %m
            S = S_dash(end)*lambda^2;  %balloon surface area (m^2)
            V = V_dash(end)*lambda^3;  %balloon volume (m^3)
        
            %calculate radius error
            r_end_error = (r_end_condition - r(end));
            theta_end_error = theta_end_condition - theta(end);
            
            %Use interpolation to determine next guess
            if exist('shoot1') == 0                                  %this was our first guess.  We must pick a 2nd arbitrary guess
                shoot1.A2 = s_dash_end_guess;                        
                shoot1.Z2 = r(end);
                
                s_dash_end_guess = s_dash_end_guess + 0.0001;        %set next guess to our first guess + some small amount
            else
                shoot1.A1 = shoot1.A2;
                shoot1.Z1 = shoot1.Z2;
                shoot1.A2 = s_dash_end_guess;
                shoot1.Z2 = r(end);
                Zsol = r_end_condition;
                a = Zsol - shoot1.Z1;
                b = shoot1.Z2 - Zsol;
                
                Anew = (a*shoot1.A2 + b*shoot1.A1)/(a+b);            %calculate next guess based upon interpolation of previous 2 results
                s_dash_end_guess = Anew;
            end  
    end
    clearvars shoot1;

    %calculate theta_0 guess for next iteration using interpolation method
    if exist('shoot2') == 0
        shoot2.A2 = theta_0_guess;
        shoot2.Z2 = theta(end);
                
        theta_0_guess = theta_0_guess + 0.001;
    else
        shoot2.A1 = shoot2.A2;
        shoot2.Z1 = shoot2.Z2;
        shoot2.A2 = theta_0_guess;
        shoot2.Z2 = theta(end);
        Zsol = theta_end_condition;
        a = Zsol - shoot2.Z1;
        b = shoot2.Z2 - Zsol;
                
        Anew = (a*shoot2.A2 + b*shoot2.A1)/(a+b);
        theta_0_guess = Anew;
        m0 = 2*pi*cos(theta_0_guess);
    end
end

%% Calculate sea level hydrogen needed
m_H2 = rho_H2*V;                                        %kg --> mass of hydrogen needed
[rho_air_SL,a_SL,T_SL,P_SL,nu_SL,ZorH_SL]=stdatmo(0);   %SI  (standard atmosphere)
rho_H2_SL = P_SL/(R_H2*T_SL);                           %Ideal gas law, assume ambient pressure
V_H2_SL = m_H2 / rho_H2_SL;                             %m^3 Hydrogen Volume at Sea Level

%% Print outputs
fprintf('balloon surface area = %f m^2 \n',S )
fprintf('balloon volume = %f m^3 \n',V )
fprintf('balloon volume = %f ft^3 \n',V *35.3147)
fprintf('balloon mass = %f kg \n',S*wd )
fprintf('payload mass = %f kg \n',Wpayload/g )
fprintf('total weight = %f N \n',Wpayload+S*wd*g )
fprintf('total lift = %f N \n',V*bd )
fprintf('Hydrogen Volume at Sea Level = %f ft^3 \n',V_H2_SL *35.3147 )
fprintf('angle at apex = %f degrees  (shoot for -90) \n',theta(end)/ 0.0174532925 )
fprintf('angle at base = %f degrees  (shoot for -90) \n',theta(1)/ 0.0174532925 )
fprintf('radius at apex = %f m  (shoot for 0) \n',r(end) )
fprintf('arclength of gore = %f m \n',s(end) )

f1 = figure(1);
subplot(1,2,1)
plot(r,z)
xlabel('radius to center of balloon (m)')
ylabel('distance from balloon base (m)')
grid on
axis equal
title('balloon gore contour at apogee')

%% Determine Gore Shape
lengthTot = 0;
q = length(r);
marker = 1;
Vlength = 0;
Vwidth = 0;
for i=1:1:q-1
    dx=r(i+1)-r(i);
    dy=z(i+1)-z(i);
    lengthSec = sqrt((dx)^2+(dy)^2);
    lengthTot = lengthTot + lengthSec;
    Vlength = [Vlength, lengthTot*3.28];
    
    goreWidth=r(i)*3.28*goreTheta;
    Vwidth = [Vwidth, goreWidth];
    %fprintf('At %f inches from bottom, gore is %f inches from center\n',lengthTot*3.28*12,goreWidth/2*12)
    %fprintf('At %f feet from bottom, gore is %f feet wide\n',lengthTot*3.28,goreWidth)
end
fprintf('arclength of gore (method 2)= %f m \n',lengthTot)

subplot(1,2,2)
plot(Vwidth/2,Vlength,'--',-Vwidth/2,Vlength,'--')
hold all
plot(Vwidth/2+0.25,Vlength,-Vwidth/2-0.25,Vlength)
%xlim([-35,35]);
%ylim([0,70]);
xlabel('width (ft)')
ylabel('length (ft)')
title('Gore shape')
axis equal
legend('conventional gore','','3-D design gore','')
grid on

%% 3D plot
y = r_dash*lambda;
x = z_dash*lambda;
ni = length(x);
nj = 2*ni-1;
tt = linspace(0,2*pi,nj);
for i=1:ni
for j=1:nj
   xx(i,j) = x(i);
   rr(i,j) = y(i);
   yy(i,j) = rr(i,j)*cos(tt(j));
   zz(i,j) = rr(i,j)*sin(tt(j));
end
end

f2 = figure(2);
surfl(yy,zz,xx)
colormap(gray)
axis('equal')
xlabel('(meters)')
ylabel('(meters)')
zlabel('height (meters)')
title('Balloon Shape at Apogee')
axis equal

