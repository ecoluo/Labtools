% to plot real velocity measured
% LBY20210107
% note that the gyro measures velocity, not acceleration of rotation

function [time_vel,veloc,time_acc,accel] = Real_acc_vel_withdelay_rotation(fig_flag)

if ~nargin
    fig_flag = 1;
end

colorDefsLBY;

load('Z:\LBY\System\rotation_speed\m4c1000r2.mat');
TEMPO1_Velocity = Average4_m4c1000r2__Ch1;
TEMPO1_Velocity.values = -TEMPO1_Velocity.values; % invert the profile

duration = 1.5; % unit in s
delay = 0.145; % unit in s
delay = delay*(1/TEMPO1_Velocity.interval);
% the sensitivity of this accelerator is 12.5mV/deg/s
vel = (TEMPO1_Velocity.values-min(TEMPO1_Velocity.values))/0.0125;


a = 0;

for i = 2:length(vel)
    
acc(i) = (vel(i)-vel(i-1))/(TEMPO1_Velocity.times(i)-TEMPO1_Velocity.times(i-1));

end


time_vel = TEMPO1_Velocity.times(3:duration*2000+2);
time_acc = TEMPO1_Velocity.times(3:duration*2000+2);
veloc = vel([3:duration*2000+2]+delay);
accel = acc([3:duration*2000+2]+delay);
[~,vMaxT] = max(veloc); vMaxT = vMaxT/2
[~,vMinT] = min(veloc); vMinT = vMinT/2
[~,aMaxT] = max(accel); aMaxT = aMaxT/2
[~,aMinT] = min(accel); aMinT = aMinT/2
velSmooth = smooth(veloc,100);
accSmooth = smooth(accel,100);
[~,vMaxTSmooth] = max(velSmooth); vMaxTSmooth = vMaxTSmooth/2
[~,aMaxTSmooth] = max(accSmooth); aMaxTSmooth = aMaxTSmooth/2
[~,aMinTSmooth] = min(accSmooth); aMinTSmooth = aMinTSmooth/2


figure(3);clf;
if fig_flag == 0
    set(gcf,'visible','off');
end
set(gcf,'name','Gaussian Curve','pos',[200 200 1200 700]);
axes('pos',[0.2,0.2,0.6,0.6]);
[h,hLine1,hLine2] = plotyy(time_vel,veloc,time_acc,accel);
set(hLine1,'LineStyle','-','color','r','linewidth',4);
set(hLine2,'LineStyle','-','color',colorDBlue,'linewidth',4);
set(h(1),'yColor','r');
set(h(2),'yColor',colorDBlue);
ylabel(h(1),'Velocity (m/s) ');
ylabel(h(2),'Acceleration (m/s^2) ');
set(gca,'xlim',[0,1.5]);
xlabel('Time (s)');
title('Time profile(Real): Rotation');
SetFigure(25);

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
set(gca,'xlim',[0,1.5]);
% set(h(1),'ylim',[0 max(velSmooth)*1.1]);
% set(h(2),'ylim',[min(accSmooth)*1.1 max(accSmooth)*1.1]);
set(h(1),'ylim',[0 20]);
% set(h(1),'ytick',[0 0.1 0.2 0.3]);
set(h(2),'ylim',[-80 80]);
xlabel('Time (s)');
title('Time profile(Real, with smoothing): Rotation');
SetFigure(25);

end