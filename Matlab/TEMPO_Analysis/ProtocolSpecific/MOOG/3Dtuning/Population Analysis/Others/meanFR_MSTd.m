% calculate mean firing rate for all cells
% LBY 20171127

% pack PSTH data, according to temporal tuning

T_vestiPSTHSig = T_vestiPSTH(TResponSigVesti,5:85);
T_visPSTHSig = T_visPSTH(TResponSigVis,5:85);


transparent = 0.5;

% plot figures
figure(101);set(gcf,'pos',[200 70 1300 800]);clf;
[~,h_subplot] = tight_subplot(1,2,0.15,0.3);

% Translation
axes(h_subplot(1));hold on;
% vestibular
% shadedErrorBar(1:size(T_vestiPSTHSig,2),nanmean(T_vestiPSTHSig,1),nanstd(T_vestiPSTHSig,1)/sqrt(size(T_vestiPSTHSig,2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
shadedErrorBar(1:size(T_vestiPSTHSig,2),nanmean(T_vestiPSTHSig,1),nanstd(T_vestiPSTHSig,1)/sqrt(size(T_vestiPSTHSig,2)),{'-','color',colorDBlue,'linewidth',4},transparent);

% visual
% shadedErrorBar(1:size(T_visPSTHSig,2),nanmean(T_visPSTHSig,1),nanstd(T_visPSTHSig,1)/sqrt(size(T_visPSTHSig,2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
shadedErrorBar(1:size(T_visPSTHSig,2),nanmean(T_visPSTHSig,1),nanstd(T_visPSTHSig,1)/sqrt(size(T_visPSTHSig,2)),{'-','color',colorDRed,'linewidth',4},transparent);

axis on;
xlim([1 size(T_vestiPSTHSig,2)]);
title(sprintf('Translation \n\n n(vestibular) = %d \n n(visual) = %d',size(T_vestiPSTHSig,1),size(T_visPSTHSig,1)));


SetFigure(25);

set(gcf,'paperpositionmode','auto');
saveas(101,'Z:\LBY\Population Results\MeanFR','emf');


%%%%%%%%%%%%%%%%%%%%%%%%%%  added a & v info. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

duration = 2000; % unit in ms
num_sigs = 4.5;
amp = 0.11; % unit in m
step = 25;
t = 0:25:duration;
delay = 000; % in ms, system time delay, LBY added, 180610

% --------------------  The Equations -------------------- %

%pos = ampl*0.5*(erf(2*num_sigs1/3*(t-1)) + 1); % Gu
pos = amp*0.5*(erf(sqrt(2)*num_sigs*(t-duration/2)/duration) + 1); % HH
%pos = ampl*normcdf(t,1,1/num_sigs);
veloc = diff(pos)/step;
accel = diff(veloc)/step;
jerk = diff(accel)/step;

T_vestiPSTHSig_ste = nanstd(T_vestiPSTHSig,1)/sqrt(size(T_vestiPSTHSig,2));
T_visPSTHSig_ste = nanstd(T_visPSTHSig,1)/sqrt(size(T_visPSTHSig,2));


% Normalize

% T_vestiPSTHSig_norm = (nanmean(T_vestiPSTHSig,1)-nanmin(nanmean(T_vestiPSTHSig,1)))/(nanmax(nanmean(T_vestiPSTHSig,1))-nanmin(nanmean(T_vestiPSTHSig,1)));
% T_vestiPSTHSig_ste_norm = (T_vestiPSTHSig_ste-nanmin(T_vestiPSTHSig_ste))/(nanmax(nanmean(T_vestiPSTHSig,1))-nanmin(nanmean(T_vestiPSTHSig,1)));
% T_visPSTHSig_norm = (nanmean(T_visPSTHSig,1)-nanmin(nanmean(T_visPSTHSig,1)))/(nanmax(nanmean(T_visPSTHSig,1))-nanmin(nanmean(T_visPSTHSig,1)));
% T_visPSTHSig_ste_norm = (T_visPSTHSig_ste-nanmin(T_visPSTHSig_ste))/(nanmax(nanmean(T_visPSTHSig,1))-nanmin(nanmean(T_visPSTHSig,1)));

T_vestiPSTHSig_norm = (nanmean(T_vestiPSTHSig,1)-nanmin(nanmin(nanmean(T_vestiPSTHSig)), nanmin(nanmean(T_visPSTHSig))))/(nanmax(nanmax(nanmean(T_vestiPSTHSig)), nanmax(nanmean(T_visPSTHSig)))-nanmin(nanmin(nanmean(T_vestiPSTHSig)), nanmin(nanmean(T_visPSTHSig))));
T_vestiPSTHSig_ste_norm = (T_vestiPSTHSig_ste-nanmin(T_vestiPSTHSig_ste))/(nanmax(nanmean(T_vestiPSTHSig,1))-nanmin(nanmean(T_vestiPSTHSig,1)));
% T_visPSTHSig_norm = (nanmean(T_visPSTHSig,1)-nanmin(nanmean([T_vestiPSTHSig; T_visPSTHSig],1)))/(nanmax(nanmean([T_vestiPSTHSig; T_visPSTHSig],1))-nanmin(nanmean([T_vestiPSTHSig; T_visPSTHSig],1)));
T_visPSTHSig_norm = (nanmean(T_visPSTHSig,1)-nanmin(nanmin(nanmean(T_vestiPSTHSig)), nanmin(nanmean(T_visPSTHSig))))/(nanmax(nanmax(nanmean(T_vestiPSTHSig)), nanmax(nanmean(T_visPSTHSig)))-nanmin(nanmin(nanmean(T_vestiPSTHSig)), nanmin(nanmean(T_visPSTHSig))));
T_visPSTHSig_ste_norm = (T_visPSTHSig_ste-nanmin(T_visPSTHSig_ste))/(nanmax(nanmean(T_visPSTHSig,1))-nanmin(nanmean(T_visPSTHSig,1)));


pos_norm = (pos-min(pos))/(max(pos)-min(pos));
veloc_norm = (veloc-min(veloc))/(max(veloc)-min(veloc));
accel_norm = (accel-min(accel))/(max(accel)-min(accel));
jerk_norm = (jerk-min(jerk))/(max(jerk)-min(jerk));

figure(102);set(gcf,'pos',[200 100 1300 800]);clf;
[~,h_subplot] = tight_subplot(1,2,0.1,0.3);


% Translation

axes(h_subplot(1));hold on;

plot(t(2+round(delay/step):end)-1,veloc_norm(1:end-round(delay/step)),'--','linewidth',3,'color',colorDRed);
plot(t(3+round(delay/step):end)-1,accel_norm(1:end-round(delay/step)),'--','linewidth',3,'color',colorDBlue);
% plot(t(2:end)-1,veloc_norm,'--','linewidth',3,'color',colorDRed);
% plot(t(3:end)-1,accel_norm,'--','linewidth',3,'color',colorDBlue);
% shadedErrorBar((0:size(T_vestiPSTHSig_norm,2)-1)*step,T_vestiPSTHSig_norm,T_vestiPSTHSig_ste_norm,'lineprops',{'-','color',colorDBlue,'linewidth',2});
% shadedErrorBar((0:size(T_visPSTHSig_norm,2)-1)*step,T_visPSTHSig_norm,T_visPSTHSig_ste_norm,'lineprops',{'-','color',colorDRed,'linewidth',2});
shadedErrorBar((0:size(T_vestiPSTHSig_norm,2)-1)*step,T_vestiPSTHSig_norm,T_vestiPSTHSig_ste_norm,{'-','color',colorDBlue,'linewidth',4},transparent);
shadedErrorBar((0:size(T_visPSTHSig_norm,2)-1)*step,T_visPSTHSig_norm,T_visPSTHSig_ste_norm,{'-','color',colorDRed,'linewidth',4},transparent);
axis on;
xlabel('Duration (ms)');
ylim([-0.2 1.2]);
title('Translation');
% legend('Vestibular','Visual');


suptitle('Mean firing rate (Hz)');
SetFigure(25);

set(gcf,'paperpositionmode','auto');
saveas(102,'Z:\LBY\Population Results\MeanFR2','emf');

% [h,hl] = plotyyy(t(2:end)-1,veloc,t(3:end)-1,accel,(0:size(T_vestiPSTHSig_norm,2)-1)*step,T_vestiPSTHSig_norm);
% set(hl(1),'linewidth',1.5,'color','r');
% set(hl(2),'linewidth',1.5,'color','b');
% set(hl(3),'linewidth',5,'color',colorDBlue);
% hold on;
% plot((0:size(T_visPSTHSig_norm,2)-1)*step,T_visPSTHSig_norm,'linewidth',5);




