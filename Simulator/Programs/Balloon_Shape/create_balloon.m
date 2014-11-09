function balloon_output = create_balloon(balloon_input_filename)
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
% Units:
%           ALL calculations performaed in SI units.  Only converted
%           to english units for printing or plotting

%% Inputs (Mission Criteria)
load(balloon_input_filename) %load the following input parameters
%rho_PE         --> kg/m^3  density of polyethlyene we purchased
%thickness_PE   --> m  thickness of polyethylene we purchased
%Wpayload       --> N  payload weight
%alt_apogee     --> altitude at apogee (m)
%numGores       --> number of gores

%constants  (mission criteria and materials)
g = 9.81;                     %m/s/s
R_air = 287.058;              %specific gas constant air (SI)
R_H2 = 4124;                  %specific gas constant hydrogen (SI)

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
%fprintf('bd = %f lbs/ft^3 \n',bd / 157.087464)
%fprintf('Payload = %f lbs \n',Wpayload / 4.44822162)
%fprintf('lambda = %f ft\n',lambda*3.28084)
%fprintf('wd = %f lbs/ft^2 \n',wd *0.204816144)
%fprintf('epsilon = %f \n',epsilon)
%fprintf('Number of gores = %f\n', numGores)

%% Shooting method simulation for finding gore contour shape
%constant initial conditions
r0 = 0;              %radius at base = 0
z0 = 0;              %height at base = 0
S0 = 0;              %area at base = 0
V0 = 0;              %volume at base = 0

%final value conditions
r_end_condition = 0;       %radius at apex = 0
theta_end_condition = -pi/2;    %angle at apex = -90 (radians)

options = simset('SrcWorkspace','current');
%iterate
theta_end_error = 0.1;                         %set error high to enter loop
theta_0_guess = 60 * 0.0174532925;             %angle at base (rads)  [GUESS]
m0 = 2*pi*cos(theta_0_guess);                  %calculation dependant on guess
while abs(theta_end_error) > 0.00174532925     %while error high, keep iterating
    r_end_error = 2;                            %set error high to enter loop
    s_dash_end_guess = 2;                       %arclength of gore (m/lambda) [GUESS]
    while abs(r_end_error) > 0.001               %shooting method until error for r is small
            sim('natural_balloon',[],options)              %run simulink model
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
m_PE = S*wd;  %kg
m_payload = Wpayload / g;
arclength = s(end);
height = z(end);
fprintf('epsilon = %f \n',epsilon)
fprintf('balloon surface area = %f m^2 \n',S )
fprintf('balloon volume = %f m^3 \n',V )
fprintf('balloon volume = %f ft^3 \n',V *35.3147)
fprintf('balloon mass = %f kg \n',m_PE )
fprintf('payload mass = %f kg \n',Wpayload/g )
fprintf('total weight = %f N \n',Wpayload+m_PE*g )
fprintf('total lift = %f N \n',V*bd )
fprintf('Hydrogen Volume at Sea Level = %f ft^3 \n',V_H2_SL *35.3147 )
fprintf('angle at apex = %f degrees  (shoot for -90) \n',theta(end)/ 0.0174532925 )
fprintf('angle at base = %f degrees  (shoot for -90) \n',theta(1)/ 0.0174532925 )
fprintf('radius at apex = %f m  (shoot for 0) \n',r(end) )
fprintf('arclength of gore = %f m \n',arclength )
fprintf('\n')

f1 = figure(1);
subplot(1,2,1)
plot(r,z)
xlabel('radius to center of balloon (m)')
ylabel('distance from balloon base (m)')
grid on
axis equal
title('balloon gore contour at apogee')

%% Determine Gore Shape
goreTheta = (2*pi)/numGores;              %radians rotation per gore
s_print = 0:0.1:s(end);
for n = 1:1:length(s_print);
    r_print = interp1(s,r,s_print(n));
    goreWidth(n) = r_print*goreTheta;    %m arc length formula
    fprintf('At %.1f cm from bottom, gore is %.2f cm from center\n',s_print(n)*100,goreWidth(n)/2*100)
end

subplot(1,2,2)
plot(goreWidth/2,s_print,-goreWidth/2,s_print)
xlabel('width (m)')
ylabel('length (m)')
title('Flat Gore Shape (stencil)')
axis equal
grid on

%% 3D plot
y = r;
x = z;
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

%% Output
w = whos;
for a = 1:length(w) 
balloon_output.(w(a).name) = eval(w(a).name); 
end

end
