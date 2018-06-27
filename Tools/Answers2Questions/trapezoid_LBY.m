% To plot curve of position, velocity, acceleration and jerk of the trapezoid stimulus, theoretically
% LBY20180626

clear all;
colorDefsLBY;
duration1 = 0.25; % duration of up and down stage
duration2 = 1; % duration of platform stage
duration = duration1*2+duration2;
a = 2;
amp = 0.011; % unit in m
step = 0.005;
t1 = 0:step:duration1;
t2 = max(t1):step:duration2+duration1;
t3 = max(t2):step:duration;
t = [t1 t2 t3];

% --------------------  The Equations -------------------- %

accel1 = ones(1,length(t1)).*amp*2/(duration1^2);
accel2 = ones(1,length(t2)).*0;
accel3 = ones(1,length(t3)).*amp*2/(duration1^2)*(-1);
accel = [accel1 accel2 accel3];
veloc = 0;
pos = 0;
for ii = 1:length(accel)-1 
    veloc(ii+1) = veloc(ii)+accel(ii).* (t(ii+1)-t(ii));
    pos(ii+1) = pos(ii) + veloc(ii+1) .* (t(ii+1)-t(ii));
end





% figure; axes; hold on;
% plot(accel,'b-');
% plot(veloc,'r-');
% plot(pos,'k-');

figure(3);clf;
set(gcf,'name','Trapezoid Curve','pos',[200 200 1200 700]);
axes('pos',[0.2,0.2,0.5,0.5]);
% [h,hLine1,hLine2] = plotyy(t,veloc,t,accel);
[h,hLines] = plotyyy(t,veloc,t,accel,t,pos);

set(hLines(1),'LineStyle','-','color','r','linewidth',4);
set(hLines(2),'LineStyle','-','color',colorDBlue,'linewidth',4);
set(hLines(3),'LineStyle','-','color','k','linewidth',4);
set(h(1),'yColor','r');
set(h(2),'yColor',colorDBlue);
set(h(3),'yColor','k');
ylabel(h(1),'Velocity (m/s) ');
ylabel(h(2),'Acceleration (m/s^2) ');
ylabel(h(3),'Position (m) ');
xlabel('Time (s)');
% title('Time profile');
SetFigure(25);