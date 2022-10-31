clear all;
duration = 1;
step = 0.001;
t = 0:step:duration;
amp = 0.3125; % amplitude of acceleration
w = 2*pi/duration;

pos = amp.*(-sin(w.*t)/(w^2)+t/w);
% v = amp.*(-cos(w.*t)/w+1/w);
% a = amp.*sin(w.*t);
veloc = diff(pos)/step;
accel = diff(veloc)/step;
jerk = diff(accel)/step;

% figure;
% plot(t,a,'b');
% hold on;
% plot(t,v,'r');
% hold on;
% plot(t,p,'k');

figure;
[h,hLines] = plotyyy(t(1:length(t)-1),veloc,t(1:length(t)-2),accel,t,pos);
set(hLines(1),'LineStyle','-','color','r','linewidth',4);
set(hLines(2),'LineStyle','-','color','b','linewidth',4);
set(hLines(3),'LineStyle','-','color','g','linewidth',4);
set(h(1),'yColor','r');
set(h(2),'yColor','b');
set(h(3),'yColor','g');
ylabel(h(1),'Velocity (m/s) ');
ylabel(h(2),'Acceleration (m/s^2) ');
ylabel(h(3),'Position (m) ');
xlabel('Time (s)');
% title('Time profile');
SetFigure(25);
