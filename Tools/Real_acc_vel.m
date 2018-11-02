% to plot real acceleration measured
% LBY20180617

function [time_vel,veloc,time_acc,accel] = Real_acc_vel(fig_flag)

if ~nargin
    fig_flag = 1;
end

colorDefsLBY;
load('Z:\LBY\System\TEMPO1_Acceleration');

system_delay = 0.17; % unit in s
duration = 1.5; % unit in s

% the sensitivity of this accelerator is 400mV/g
acc = (TEMPO1_Acceleration_Ch1.values-mean(TEMPO1_Acceleration_Ch1.values))/0.4*9.8;


a = 0;

for i = 2:length(acc)
    
a = acc(i)*(TEMPO1_Acceleration_Ch1.times(i)-TEMPO1_Acceleration_Ch1.times(i-1))+a;
    vel(i) = a;

end
% plot(TEMPO1_Acceleration_Ch1.times(0.2*2000+2:1.7*2000+1)-0.2,acc(0.2*2000+2:1.7*2000+2),'linewidth',3); hold on;
% plot(TEMPO1_Acceleration_Ch1.times(0.2*2000+2:1.7*2000+2)-0.2,vel(0.2*2000+2:1.7*2000+2),'linewidth',3,'color','r'); hold on;
time_vel = TEMPO1_Acceleration_Ch1.times(system_delay*2000+2:(system_delay+duration)*2000+2)-system_delay;
time_acc = TEMPO1_Acceleration_Ch1.times(system_delay*2000+2:(system_delay+duration)*2000+2)-system_delay;
veloc = vel(system_delay*2000+2:(system_delay+duration)*2000+2);
accel = acc(system_delay*2000+2:(system_delay+duration)*2000+2);

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
xlabel('Time (s)');
% title('Time profile');
SetFigure(25);
end