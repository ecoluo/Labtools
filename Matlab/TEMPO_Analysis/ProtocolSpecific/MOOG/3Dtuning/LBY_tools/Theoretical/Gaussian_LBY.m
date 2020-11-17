% To plot curve of position, velocity, acceleration and jerk of the
% stimulus in our lab, theoretically
% adapted from Gu & HH, LBY20170320

clear all;
colorDefsLBY;
duration = 1.5; % unit in s
num_sigs = 4.5;
amp = 8; % unit in m
step = 0.0005;
t = 0:step:duration;

% --------------------  The Equations -------------------- %

%pos = ampl*0.5*(erf(2*num_sigs1/3*(t-1)) + 1); % Gu
pos = amp*0.5*(erf(sqrt(2)*num_sigs*(t-duration/2)/duration) + 1); % HH
%pos = ampl*normcdf(t,1,1/num_sigs);
veloc = diff(pos)/step;
accel = diff(veloc)/step;
jerk = diff(accel)/step;

% calculate the peak value of some of the above 4 parameters
% & find the T of these peaks
[pMax pMaxI] = max(pos);
[vMax vMaxI] = max(veloc)
[aMax aMaxI] = max(accel)
[aMin aMinI] = min(accel);
[jMax jMaxI] = max(jerk);
[jMin jMinI] = min(jerk);
vMaxT = (vMaxI+1)*step;
aMaxT = (aMaxI+2)*step;
aMinT = (aMinI+2)*step;
jMaxT = (jMaxI+3)*step;
jMinT = (jMinI+3)*step;



% -------------------- Plot Figures ---------------------- %
%{
figure(3);clf;
% figure('name','Gaussian Curve');
set(gcf,'name','Gaussian Curve','pos',[200 20 1200 1000]);
% set(gcf,'name','Gaussian Curve','pos',[200 20 400 500]);

set(0,'defaultaxesfontsize',20);


% % plot all 4 curves in one figure
% subplot(5,4,[1:12]);

% plot(t,pos,'k-','linewidth',2);
% hold on;
plot(t(1:length(t)-1),veloc./(vMax/pMax),'r-','linewidth',8);
hold on;
plot(t(1:length(t)-2),accel./(aMax/pMax),'-','linewidth',8,'color',colorDBlue);
hold on;
% plot(t(1:length(t)-3),jerk./(jMin/pMax*(-1)),'g-','linewidth',2);
hold on;
% plot(xlim,[0 0],'k:');
hold on;
% plot([vMaxT vMaxT],ylim,'k:');hold on;text(vMaxT-0.05,aMin./(aMax/pMax)-0.05,'Max v','FontSize',14);text(vMaxT-0.08,aMin./(aMax/pMax)-0.05-0.02,sprintf('%6.3fs', vMaxT),'FontSize',14);
% plot([aMaxT aMaxT],ylim,'k:');hold on;text(aMaxT-0.05,aMin./(aMax/pMax),'Max a','FontSize',14);text(aMaxT-0.08,aMin./(aMax/pMax)-0.02,sprintf('%6.3fs', aMaxT),'FontSize',14);
% plot([aMinT aMinT],ylim,'k:');hold on;text(aMinT-0.05,aMin./(aMax/pMax),'Min a','FontSize',14);text(aMinT-0.08,aMin./(aMax/pMax)-0.02,sprintf('%6.3fs', aMinT),'FontSize',14);
% plot([jMaxT jMaxT],ylim,'k:');hold on;text(jMaxT-0.05,aMin./(aMax/pMax)+0.05,'Max j','FontSize',14);text(jMaxT-0.08,aMin./(aMax/pMax)+0.05-0.02,sprintf('%6.3fs', jMaxT),'FontSize',14);
% plot([jMinT jMinT],ylim,'k:');hold on;text(jMinT-0.05,aMin./(aMax/pMax)+0.05,'Min j','FontSize',14);text(jMinT-0.08,aMin./(aMax/pMax)+0.05-0.02,sprintf('%6.3fs', jMinT),'FontSize',14);
% axis off;
% text(-0.05,0,'0','FontSize',20);
% text(duration+0.05,0,'1.5','FontSize',20);

set(gca,'linewidth',2,'box','off');
set(gca,'ytick',[-pMax 0 pMax],'xtick',[0 0.5 1 1.5]);
%}

% plot curves of position, velocity, acceleration and jerk as functions of time respectively
%{
subplot(5,4,17);
plot(t,pos,'k-','linewidth',4);
hold on;
% plot(xlim,[0 0],'k:');
ylim([min(pos) max(pos)]*1.1);
xlim([0-0.2 duration+0.2]);
% title(sprintf('Max pos = %6.2f m', pMax));
title('Position');
axis off;


subplot(5,4,18);
plot(t(1:length(t)-1),veloc,'r-','linewidth',4);
hold on;
% plot(xlim,[0 0],'k:');
% hold on;
% plot([vMaxT vMaxT],ylim,'k:');
xlim([0-0.2 duration+0.2]);
ylim([min(veloc) max(veloc)]*1.1);
% title(sprintf('Max veloc = %6.2f m/s', vMax));
title('Velocity');
axis off;

subplot(5,4,19);
plot(t(1:length(t)-2),accel,'-','linewidth',4,'color',colorDBlue);
hold on;
% plot(xlim,[0 0],'k:');
% hold on;
% plot([aMaxT aMaxT],ylim,'k:');
% hold on;
% plot([aMinT aMinT],ylim,'k:');
xlim([0-0.2 duration+0.2]);
ylim([min(accel) max(accel)]*1.1);
% title(sprintf('Max accel = %6.2f g', aMax));
title('Acceleration');
axis off;

subplot(5,4,20);
plot(t(1:length(t)-3),jerk,'g-','linewidth',4);
hold on;
% plot(xlim,[0 0],'k:');
% hold on;
% plot([jMaxT jMaxT],ylim,'k:');
% hold on;
% plot([jMinT jMinT],ylim,'k:');
xlim([0-0.2 duration+0.2]);
ylim([min(jerk) max(jerk)]*1.1);
% title(sprintf('Min jerk = %6.2f', jMin));
title('Jerk');
axis off;

subplot(5,4,[13:16]);
text(0,1,sprintf('Duration = %2.1f s ',duration),'fontsize',14);
text(0,0.7,sprintf('Num.of Sigs = %2.1f',num_sigs),'fontsize',14);
text(0,0.4,sprintf('Amplitude = %3.2f m',amp),'fontsize',14);
axis off;

suptitle('Curves of Stimulus');
SetFigure(25);
saveas(gcf,'Z:\LBY\Population Results\Gaussian_curves_all','emf');
%}
figure(3);clf;
set(gcf,'name','Gaussian Curve','pos',[200 200 1200 700]);
axes('pos',[0.2,0.2,0.7,0.7]);
% [h,hLines] = plotyyy(t(1:length(t)-1),veloc,t(1:length(t)-2),accel,t,pos);
[h,hLines] = ploty4(t(1:length(t)-1),veloc,t(1:length(t)-2),accel,t,pos,t(1:length(t)-3),jerk);
% [h,hLines] = plot(t(1:length(t)-1),veloc,t(1:length(t)-2),accel);

set(hLines(1),'LineStyle','-','color','r','linewidth',4);
set(hLines(2),'LineStyle','-','color',colorDBlue,'linewidth',4);
% set(hLines(3),'LineStyle','-','color','k','linewidth',4);
% set(hLines(4),'LineStyle','-','color',colorDOrange,'linewidth',4);
set(h(1),'yColor','r');
set(h(2),'yColor',colorDBlue);
% set(h(3),'yColor','k');
% set(h(4),'yColor',colorDOrange);
ylabel(h(1),'Velocity (m/s) ');
ylabel(h(2),'Acceleration (m/s^2) ');
% ylabel(h(3),'Position (m) ');
% ylabel(h(4),'jerk (m/s^3) ');
xlabel('Time (s)');
% title('Time profile');
SetFigure(25);








