clc; clear; close all;

addpath('C:\GitHub\Matlab\APRS Analysis')

aprs = APRS_analyze('aprs.csv',1);


%%
%parse ardupilot data
ardu.raw = load('IGNITOR_trunc.TXT');
ardu.time = ardu.raw(:,1)*0.001;      %s;
ardu.press = ardu.raw(:,9);

%sync ardu t-clock with aprs t-clock
ardu.t0 = ardu.time - ardu.time(1) - 532.08;   %s t-clock
ardu.t0_hrs = ardu.t0*0.000277778;    %hours

%Interpolate standard atmosphere to find pressure altitude
Hchart = 0:0.01:35;                    %km
Pchart = atmo_p(Hchart);               %Pa
ardu.alt = interp1(Pchart,Hchart,ardu.press)*1000;  %m

figure(7)
plot(ardu.t0_hrs,ardu.press)

figure(8)
plot(aprs.t0_hrs,aprs.altitude,'o',ardu.t0_hrs,ardu.alt)
