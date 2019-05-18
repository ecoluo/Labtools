% plot psychometric function
% LBY 20160407

clear all;
clc;
duration = 1.5; % unit in s
num_sigs1 = 4;
num_sigs2 = 2;
amp = 0.11; % unit in m
step = 0.0005;
t = 0:step:duration;

pos1 = amp*0.5*(erf(sqrt(2)*num_sigs1*(t-duration/2)/duration) + 1); % HH
pos2 = amp*0.5*(erf(sqrt(2)*num_sigs2*(t-duration/2)/duration) + 1);

figure(101);clf;
set(gcf,'name','Gaussian Curve','pos',[200 20 1100 700]);
set(0,'defaultaxesfontsize',20);

axes('pos',[0.2 0.2 0.7 0.7]);hold on;
plot(t+duration*0.02,pos1,'b-','linewidth',4);
plot(t-duration*0.02,pos1,'r-','linewidth',4);
plot(t+duration*0.02,pos2,'b--','linewidth',4);
plot(t,pos1,'r--','linewidth',4);
plot([-8 -3.2 -1.28 0  1.28 3.2 8 ]*duration/16+duration/2,[0 0.07 0.27 0.47 0.67 0.87 1]*max(pos1),'b.','markersize',40);
plot([-8 -3.2 -1.28 0  1.28 3.2 8 ]*duration/16+duration/2,[0.02 0.22 0.37 0.47 0.57 0.72 0.95]*max(pos1),'b*','markersize',12);
plot([-8 -3.2 -1.28 0  1.28 3.2 8 ]*duration/16+duration/2,[0 0.13 0.33 0.53 0.73 0.93 1]*max(pos1),'r.','markersize',40);
plot([-8 -3.2 -1.28 0  1.28 3.2 8 ]*duration/16+duration/2,[0 0.1 0.3 0.5 0.7 0.9 1]*max(pos1),'r*','markersize',12);
set(gca,'linewidth',2,'box','off');
set(gca,'xlim',[0 duration]);
set(gca,'xtick',[0 0.75/2  0.75 0.75+0.75/2 1.5], 'ytick',[0 0.055 0.11]);
set(gca,'xticklabel',{'-10','-5','0','+5','+10 '},'yticklabel',{'0','0.5','1'});
% set(gca,'xticklabel',{'-10','-5','0','+5','+10 '},'yticklabel',{' ',' ',' '});
xlabel('Heading direction (\circ)');
ylabel('Proportion of ''rightward'' choice');
legend({'Vestibular','Visual','Inactivation, vestibular','Inactivation, visual'},'location','bestoutside');

% ylabel('Firing rate ( spk/s )');
SetFigure(10);

% title('Neurometric function');
title('Psychometric function');
% saveas(gcf,'Z:\LBY\\Psychometric curve_G','emf');
% saveas(gcf,'Z:\LBY\\Neurometric curve','emf');