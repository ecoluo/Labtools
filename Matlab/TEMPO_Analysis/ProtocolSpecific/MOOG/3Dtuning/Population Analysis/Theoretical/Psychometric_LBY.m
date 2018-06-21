% plot psychometric function
% LBY 20160407

clear all;
clc;
duration = 1.5; % unit in s
num_sigs = 10;
amp = 0.11; % unit in m
step = 0.0005;
t = 0:step:duration;

pos = amp*0.5*(erf(sqrt(2)*num_sigs*(t-duration/2)/duration) + 1); % HH

figure(101);
set(gcf,'name','Gaussian Curve','pos',[200 20 600 700]);
set(0,'defaultaxesfontsize',20);

axes('pos',[0.2 0.2 0.7 0.7]);
plot(t,pos,'k-','linewidth',4);
set(gca,'linewidth',2,'box','off');
set(gca,'xtick',[0 0.75/2  0.75 0.75+0.75/2 1.5], 'ytick',[0 0.055 0.11]);
% set(gca,'xticklabel',{'-10','-5','0','+5','+10 '},'yticklabel',{'0','0.5','1'});
set(gca,'xticklabel',{'-10','-5','0','+5','+10 '},'yticklabel',{' ',' ',' '});
xlabel('Heading direction (\circ)');
% ylabel('Proportion of ''rightward'' choice');
ylabel('Firing rate ( spk/s )');
SetFigure(15);

title('Neurometric function');
% saveas(gcf,'Z:\LBY\\Psychometric curve_G','emf');
% saveas(gcf,'Z:\LBY\\Neurometric curve','emf');