% to plot real acceleration measured
% LBY20180617

function [time_vel,veloc,time_acc,accel] = Real_acc_vel(fig_flag)

if ~nargin
    fig_flag = 1;
end

colorDefsLBY;

% load('Z:\LBY\System\20180731_e0_a0_T_sigma4.5.mat');
% TEMPO1_Acceleration = Average4_180731_e0_a0_T__Ch1;

% load('Z:\LBY\System\20200323_e0_a90_T_sigma3');
% TEMPO1_Acceleration = Average4_acc_T_sigma3_20200323_90degree__Ch1;

% load('Z:\LBY\System\20200323_e0_a90_T_sigma4');
% TEMPO1_Acceleration = Average3_acc_T_sigma4_20200323_90degree__Ch1;

% load('Z:\LBY\System\20200323_e0_a90_T_sigma6');
% TEMPO1_Acceleration = Average2_acc_T_sigma6_20200323_90degree_1__Ch1;


% load('Z:\LBY\System\change_sigmas\acc_T_sigma6_20200408_90degree_amp10.mat');
% TEMPO1_Acceleration = Average1_acc_T_sigma6_20200408_90degree_amp10__Ch1;
% 
% load('Z:\LBY\System\change_sigmas\acc_T_sigma2_7_20200408_90degree_amp24.mat');
% TEMPO1_Acceleration = Average1_acc_T_sigma2_7_20200408_90degree_amp24__Ch1;

load('Z:\LBY\System\sig6_delay2_return8_dur2');
TEMPO1_Acceleration = Average3_sig6_delay2_return8_dur2__Ch1;

% system_delay = 0.17; % unit in s
% duration = 1.5; % unit in s
duration = 2; % unit in s

% the sensitivity of this accelerator is 400mV/g
acc = (TEMPO1_Acceleration.values-mean(TEMPO1_Acceleration.values))/0.4*9.8;


a = 0;

for i = 2:length(acc)
    
a = acc(i)*(TEMPO1_Acceleration.times(i)-TEMPO1_Acceleration.times(i-1))+a;
    vel(i) = a;

end

% time_vel = TEMPO1_Acceleration.times(system_delay*2000+2:(system_delay+duration)*2000+2)-system_delay;
% time_acc = TEMPO1_Acceleration.times(system_delay*2000+2:(system_delay+duration)*2000+2)-system_delay;
% veloc = vel(system_delay*2000+2:(system_delay+duration)*2000+2);
% accel = acc(system_delay*2000+2:(system_delay+duration)*2000+2);
time_vel = TEMPO1_Acceleration.times(3:duration*(1/TEMPO1_Acceleration.interval)+2);
time_acc = TEMPO1_Acceleration.times(3:duration*(1/TEMPO1_Acceleration.interval)+2);
veloc = vel(3:duration*(1/TEMPO1_Acceleration.interval)+2);
accel = acc(3:duration*(1/TEMPO1_Acceleration.interval)+2);
[vMax,vMaxT] = max(veloc); 
vMax
vMaxT = vMaxT/2
[aMax,aMaxT] = max(accel); 
aMax
aMaxT = aMaxT/2
[~,aMinT] = min(accel); aMinT = aMinT/2
velSmooth = smooth(veloc,10);
accSmooth = smooth(accel,80);
[~,vMaxTSmooth] = max(velSmooth); vMaxTSmooth = vMaxTSmooth/2
[~,aMaxTSmooth] = max(accSmooth); aMaxTSmooth = aMaxTSmooth/2
[~,aMinTSmooth] = min(accSmooth); aMinTSmooth = aMinTSmooth/2


% figure(3);clf;
% if fig_flag == 0
%     set(gcf,'visible','off');
% end
% set(gcf,'name','Gaussian Curve','pos',[200 200 1200 700]);
% axes('pos',[0.2,0.2,0.6,0.6]);
% [h,hLine1,hLine2] = plotyy(time_vel,veloc,time_acc,accel);
% set(hLine1,'LineStyle','-','color','r','linewidth',4);
% set(hLine2,'LineStyle','-','color',colorDBlue,'linewidth',4);
% set(h(1),'yColor','r');
% set(h(2),'yColor',colorDBlue);
% ylabel(h(1),'Velocity (m/s) ');
% ylabel(h(2),'Acceleration (m/s^2) ');
% set(gca,'xlim',[0,1.5]);
% xlabel('Time (s)');
% title('Time profile(Real)');
% SetFigure(25);

% plot figures with smoothing
figure(4);clf;
if fig_flag == 0
    set(gcf,'visible','off');
end
set(gcf,'name','Gaussian Curve','pos',[200 200 1200 700]);
axes('pos',[0.2,0.2,0.6,0.6]);
[h,hLine1,hLine2] = plotyy(time_vel,velSmooth,time_acc,accSmooth);
set(hLine1,'LineStyle','-','color','r','linewidth',4);
set(hLine2,'LineStyle','-','color',colorDBlue,'linewidth',4);
set(h(1),'yColor','r');
set(h(2),'yColor',colorDBlue);
ylabel(h(1),'Velocity (m/s) ');
ylabel(h(2),'Acceleration (m/s^2) ');
set(h(1),'ylim',[0 0.3]);
set(gca,'xlim',[0,duration]);
xlabel('Time (s)');
title('Time profile(Real, with smoothing)');
SetFigure(25);

end