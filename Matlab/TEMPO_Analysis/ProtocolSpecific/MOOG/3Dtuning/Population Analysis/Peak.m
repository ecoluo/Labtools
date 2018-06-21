% Analysis for Peak distribution (Peak_DS)
% LBY 20171209

timeStep = 25;
tOffset1 = 100;
stimOnBin = floor(tOffset1/timeStep)+1;
% classify cells into single-peaked, double-peaked, triple-peaked, no-peak and others

T_vesti_NPeakInx = logical(cat(1,T.vestiNoDSPeaks) == 0) & logical(T_vestiResponSig == 1);
T_vesti_SPeakInx = find(cat(1,T.vestiNoDSPeaks) == 1);
T_vesti_DPeakInx = find(cat(1,T.vestiNoDSPeaks) == 2);
T_vesti_TPeakInx = find(cat(1,T.vestiNoDSPeaks) == 3);

T_vis_NPeakInx = logical(cat(1,T.visNoDSPeaks) == 0) & logical(T_visResponSig == 1);
T_vis_SPeakInx = find(cat(1,T.visNoDSPeaks) == 1);
T_vis_DPeakInx = find(cat(1,T.visNoDSPeaks) == 2);
T_vis_TPeakInx = find(cat(1,T.visNoDSPeaks) == 3);

R_vesti_NPeakInx = logical(cat(1,R.vestiNoDSPeaks) == 0) & logical(R_vestiResponSig == 1);
R_vesti_SPeakInx = find(cat(1,R.vestiNoDSPeaks) == 1);
R_vesti_DPeakInx = find(cat(1,R.vestiNoDSPeaks) == 2);
R_vesti_TPeakInx = find(cat(1,R.vestiNoDSPeaks) == 3);

R_vis_NPeakInx = logical(cat(1,R.visNoDSPeaks) == 0) & logical(R_visResponSig == 1);
R_vis_SPeakInx = find(cat(1,R.visNoDSPeaks) == 1);
R_vis_DPeakInx = find(cat(1,R.visNoDSPeaks) == 2);
R_vis_TPeakInx = find(cat(1,R.visNoDSPeaks) == 3);

% pack peak data, according to p value (ANOVA)
% considering specific stim type itself
% T_vestiTPeakT = repmat(cat(1,T(T_vesti_DPeakInx).vestipeakDS),[],3);

T_vestiSPeakT = cat(1,T(T_vesti_SPeakInx).vestipeakDS);
T_vestiDPeakT = cat(1,T(T_vesti_DPeakInx).vestipeakDS);
T_visSPeakT = cat(1,T(T_vis_SPeakInx).vispeakDS);
T_visDPeakT = cat(1,T(T_vis_DPeakInx).vispeakDS);
T_vestiSPeakTMedian = (median(T_vestiSPeakT) - stimOnBin)*timeStep;
T_vestiDPeakT1Median = (median(T_vestiDPeakT(:,1)) - stimOnBin)*timeStep;
T_vestiDPeakT2Median = (median(T_vestiDPeakT(:,2)) - stimOnBin)*timeStep;
T_visSPeakTMedian = (median(T_visSPeakT) - stimOnBin)*timeStep;
T_visDPeakT1Median = (median(T_visDPeakT(:,1)) - stimOnBin)*timeStep;
T_visDPeakT2Median = (median(T_visDPeakT(:,2)) - stimOnBin)*timeStep;

R_vestiSPeakT = cat(1,R(R_vesti_SPeakInx).vestipeakDS);
R_vestiDPeakT = cat(1,R(R_vesti_DPeakInx).vestipeakDS);
R_visSPeakT = cat(1,R(R_vis_SPeakInx).vispeakDS);
R_visDPeakT = cat(1,R(R_vis_DPeakInx).vispeakDS);
R_vestiSPeakTMedian = (median(R_vestiSPeakT) - stimOnBin)*timeStep;
R_vestiDPeakT1Median = (median(R_vestiDPeakT(:,1)) - stimOnBin)*timeStep;
R_vestiDPeakT2Median = (median(R_vestiDPeakT(:,2)) - stimOnBin)*timeStep;
R_visSPeakTMedian = (median(R_visSPeakT) - stimOnBin)*timeStep;
R_visDPeakT1Median = (median(R_visDPeakT(:,1)) - stimOnBin)*timeStep;
R_visDPeakT2Median = (median(R_visDPeakT(:,2)) - stimOnBin)*timeStep;

% pack PSTH data, according to peak

T_vestiPSTHSPeak = T_vestiPSTH(T_vesti_SPeakInx,:);
T_vestiPSTHDPeak = T_vestiPSTH(T_vesti_DPeakInx,:);
T_visPSTHSPeak = T_visPSTH(T_vis_SPeakInx,:);
T_visPSTHDPeak = T_visPSTH(T_vis_DPeakInx,:);
R_vestiPSTHSPeak = R_vestiPSTH(R_vesti_SPeakInx,:);
R_vestiPSTHDPeak = R_vestiPSTH(R_vesti_DPeakInx,:);
R_visPSTHSPeak = R_visPSTH(R_vis_SPeakInx,:);
R_visPSTHDPeak = R_visPSTH(R_vis_DPeakInx,:);


% plot figures for peak time distribution

%%%%%%%%%%%%%%%%%%%%%%%% Peak time distribution   %%%%%%%%%%%%%%%%%%%%%%%%%

T_vestiSPeakT_plot = (T_vestiSPeakT - stimOnBin)*timeStep;
T_visSPeakT_plot = (T_visSPeakT - stimOnBin)*timeStep;
T_vestiDPeakT_plot = (T_vestiDPeakT - stimOnBin)*timeStep;
T_visDPeakT_plot = (T_visDPeakT - stimOnBin)*timeStep;
R_vestiSPeakT_plot = (R_vestiSPeakT - stimOnBin)*timeStep;
R_visSPeakT_plot = (R_visSPeakT - stimOnBin)*timeStep;
R_vestiDPeakT_plot = (R_vestiDPeakT - stimOnBin)*timeStep;
R_visDPeakT_plot = (R_visDPeakT - stimOnBin)*timeStep;


xPeakT = linspace(0,1500,16);

figure(104);set(gcf,'pos',[60 20 1200 1000]);clf;
[~,h_subplot] = tight_subplot(7,3,[0.04 0.1],0.1);


axes(h_subplot(1));
text(0.8,-3,'Translation','Fontsize',26,'rotation',90);
text(0.8,-8.6,'Rotation','Fontsize',25,'rotation',90);
axis off;

%%%% Translation
% for Vestibular
% Single-peaked time
axes(h_subplot(2));
hold on;
[nelements, ncenters] = hist(T_vestiSPeakT_plot,xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiSPeakT_plot))]);
plot(T_vestiSPeakTMedian,max(nelements)*1.1,'kv');
text(T_vestiSPeakTMedian*1.1,max(nelements)*1.2,num2str(T_vestiSPeakTMedian/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
axis on;
hold off;

% Double-peaked time
axes(h_subplot(5));
hold on;
[nelements, ncenters] = hist(T_vestiDPeakT_plot(:,1),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiDPeakT_plot))]);
plot(T_vestiDPeakT1Median,max(nelements)*1.1,'kv');
text(T_vestiDPeakT1Median*1.1,max(nelements)*1.2,num2str(T_vestiDPeakT1Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;

axes(h_subplot(8));
hold on;
[nelements, ncenters] = hist(T_vestiDPeakT_plot(:,2),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiDPeakT_plot))]);
plot(T_vestiDPeakT2Median,max(nelements)*1.1,'kv');
text(T_vestiDPeakT2Median*1.1,max(nelements)*1.2,num2str(T_vestiDPeakT2Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
% xlabel('Double-peaked, late');
axis on;
hold off;

%%%% Visual
% Single-peaked time
axes(h_subplot(3));
hold on;
[nelements, ncenters] = hist(T_visSPeakT_plot,xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visSPeakT_plot))]);
plot(T_visSPeakTMedian,max(nelements)*1.1,'kv');
text(T_visSPeakTMedian*1.1,max(nelements)*1.2,num2str(T_visSPeakTMedian/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
axis on;
hold off;

% Double-peaked time
axes(h_subplot(6));
hold on;
[nelements, ncenters] = hist(T_visDPeakT_plot(:,1),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(T_visDPeakT1Median,max(nelements)*1.1,'kv');
text(T_visDPeakT1Median*1.1,max(nelements)*1.2,num2str(T_visDPeakT1Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;

axes(h_subplot(9));
hold on;
[nelements, ncenters] = hist(T_visDPeakT_plot(:,2),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(T_visDPeakT2Median,max(nelements)*1.1,'kv');
text(T_visDPeakT2Median*1.1,max(nelements)*1.2,num2str(T_visDPeakT2Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
% xlabel('Double-peaked, late');
axis on;
hold off;

%%%% Rotation
% for Vestibular
% Single-peaked time
axes(h_subplot(14));
hold on;
[nelements, ncenters] = hist(R_vestiSPeakT_plot,xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiSPeakT_plot))]);
plot(R_vestiSPeakTMedian,max(nelements)*1.1,'kv');
text(R_vestiSPeakTMedian*1.1,max(nelements)*1.2,num2str(R_vestiSPeakTMedian/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
axis on;
hold off;

% Double-peaked time
axes(h_subplot(17));
hold on;
[nelements, ncenters] = hist(R_vestiDPeakT_plot(:,1),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiDPeakT_plot))]);
plot(R_vestiDPeakT1Median,max(nelements)*1.1,'kv');
text(R_vestiDPeakT1Median*1.1,max(nelements)*1.2,num2str(R_vestiDPeakT1Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;

axes(h_subplot(20));
hold on;
[nelements, ncenters] = hist(R_vestiDPeakT_plot(:,2),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiDPeakT_plot))]);
plot(R_vestiDPeakT2Median,max(nelements)*1.1,'kv');
text(R_vestiDPeakT2Median*1.1,max(nelements)*1.2,num2str(R_vestiDPeakT2Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
% xlabel('Double-peaked, late');
axis on;
hold off;

%%%% Visual
% Single-peaked time
axes(h_subplot(15));
hold on;
[nelements, ncenters] = hist(R_visSPeakT_plot,xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visSPeakT_plot))]);
plot(R_visSPeakTMedian,max(nelements)*1.1,'kv');
text(R_visSPeakTMedian*1.1,max(nelements)*1.2,num2str(R_visSPeakTMedian/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
axis on;
hold off;

% Double-peaked time
axes(h_subplot(18));
hold on;
[nelements, ncenters] = hist(R_visDPeakT_plot(:,1),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakT_plot))]);
plot(R_visDPeakT1Median,max(nelements)*1.1,'kv');
text(R_visDPeakT1Median*1.1,max(nelements)*1.2,num2str(R_visDPeakT1Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;

axes(h_subplot(21));
hold on;
[nelements, ncenters] = hist(R_visDPeakT_plot(:,2),xPeakT);
h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
% set(h1,'linewidth',1.5);
text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakT_plot))]);
plot(R_visDPeakT2Median,max(nelements)*1.1,'kv');
text(R_visDPeakT2Median*1.1,max(nelements)*1.2,num2str(R_visDPeakT2Median/1000));
set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
% xlabel('Double-peaked, late');
axis on;
hold off;

suptitle('Peak time distribution');
SetFigure(10);

set(gcf,'paperpositionmode','auto');
saveas(104,'Z:\LBY\Population Results\PeakT','emf');

%%%%%%%%%%%%%%%%%%%%%% FR according to Peak time   %%%%%%%%%%%%%%%%%%%%%%%%%
T_vestiPSTHDPeak_plot = [];
for ii = 1:size(T_vestiDPeakT,1)
    T_vestiPSTHDPeak_plot = [T_vestiPSTHDPeak_plot;T_vestiPSTHDPeak(ii,T_vestiDPeakT(ii,1)),T_vestiPSTHDPeak(ii,T_vestiDPeakT(ii,2))];
end
T_visPSTHDPeak_plot = [];
for ii = 1:size(T_visDPeakT,1)
    T_visPSTHDPeak_plot = [T_visPSTHDPeak_plot;T_visPSTHDPeak(ii,T_visDPeakT(ii,1)),T_visPSTHDPeak(ii,T_visDPeakT(ii,2))];
end
R_vestiPSTHDPeak_plot = [];
for ii = 1:size(R_vestiDPeakT,1)
    R_vestiPSTHDPeak_plot = [R_vestiPSTHDPeak_plot;R_vestiPSTHDPeak(ii,R_vestiDPeakT(ii,1)),R_vestiPSTHDPeak(ii,R_vestiDPeakT(ii,2))];
end
R_visPSTHDPeak_plot = [];
for ii = 1:size(R_visDPeakT,1)
    R_visPSTHDPeak_plot = [R_visPSTHDPeak_plot;R_visPSTHDPeak(ii,R_visDPeakT(ii,1)),R_visPSTHDPeak(ii,R_visDPeakT(ii,2))];
end


figure(105);set(gcf,'pos',[60 70 1500 900]);clf;
[~,h_subplot] = tight_subplot(2,5,[0.01 0.1],0.17);


axes(h_subplot(1));
text(1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1,-0.8,'Rotation','Fontsize',25,'rotation',90);
axis off;

%%%% FR - early peak vs. late peak (for double-peaked cells)
% Translation 
% for Vestibular
axes(h_subplot(2));
hold on;
plot(T_vestiPSTHDPeak_plot(:,1),T_vestiPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorDBlue);
axis on;axis square;
xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(T_vesti_DPeakInx))]);
title('Vestibular');
hold off;

% for Visual
axes(h_subplot(3));
hold on;
plot(T_visPSTHDPeak_plot(:,1),T_visPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorDRed);
axis on;axis square;
xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
text(max(get(gca,'xlim')), max(get(gca,'ylim')),['n = ',num2str(length(T_vis_DPeakInx))]);
title('Visual');
hold off;

% Rotation
% for Vestibular
axes(h_subplot(7));
hold on;
plot(R_vestiPSTHDPeak_plot(:,1),R_vestiPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorLBlue);
axis on;axis square;
xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(R_vesti_DPeakInx))]);
hold off;

% for Visual
axes(h_subplot(8));
hold on;
plot(R_visPSTHDPeak_plot(:,1),R_visPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorLRed);
axis on;axis square;
xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(R_vis_DPeakInx))]);
hold off;


%%%% mean PSTH - (divided into single- and  double-peaked cells)
% % Translation 
% % Vestibular
% axes(h_subplot(4));
% hold on;
% shadedErrorBar(1:size(T_vestiPSTHSPeak(:,5:65),2),nanmean(T_vestiPSTHSPeak(:,5:65),1),nanstd(T_vestiPSTHSPeak(:,5:65),1)/sqrt(size(T_vestiPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
% shadedErrorBar(1:size(T_vestiPSTHDPeak(:,5:65),2),nanmean(T_vestiPSTHDPeak(:,5:65),1),nanstd(T_vestiPSTHDPeak(:,5:65),1)/sqrt(size(T_vestiPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
% axis on;axis square;
% xlim([1 size(T_vestiPSTHSPeak(:,5:65),2)]);
% title('Vestibular');
% set(gca,'xtick',[]);
% % Visual
% axes(h_subplot(5));
% hold on;
% shadedErrorBar(1:size(T_visPSTHSPeak(:,5:65),2),nanmean(T_visPSTHSPeak(:,5:65),1),nanstd(T_visPSTHSPeak(:,5:65),1)/sqrt(size(T_visPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
% shadedErrorBar(1:size(T_visPSTHDPeak(:,5:65),2),nanmean(T_visPSTHDPeak(:,5:65),1),nanstd(T_visPSTHDPeak(:,5:65),1)/sqrt(size(T_visPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
% axis on;axis square;
% xlim([1 size(T_visPSTHSPeak(:,5:65),2)]);
% title('Visual');
% set(gca,'xtick',[]);
% % Rotation
% % Vestibular
% axes(h_subplot(9));
% hold on;
% shadedErrorBar(1:size(R_vestiPSTHSPeak(:,5:65),2),nanmean(R_vestiPSTHSPeak(:,5:65),1),nanstd(R_vestiPSTHSPeak(:,5:65),1)/sqrt(size(R_vestiPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
% shadedErrorBar(1:size(R_vestiPSTHDPeak(:,5:65),2),nanmean(R_vestiPSTHDPeak(:,5:65),1),nanstd(R_vestiPSTHDPeak(:,5:65),1)/sqrt(size(R_vestiPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
% axis on;axis square;
% xlim([1 size(R_vestiPSTHSPeak(:,5:65),2)]);
% set(gca,'xtick',[0 500 1000 1500]/timeStep,'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1550]/timeStep);
% 
% % Visual
% axes(h_subplot(10));
% hold on;
% shadedErrorBar(1:size(R_visPSTHSPeak(:,5:65),2),nanmean(R_visPSTHSPeak(:,5:65),1),nanstd(R_visPSTHSPeak(:,5:65),1)/sqrt(size(R_visPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
% shadedErrorBar(1:size(R_visPSTHDPeak(:,5:65),2),nanmean(R_visPSTHDPeak(:,5:65),1),nanstd(R_visPSTHDPeak(:,5:65),1)/sqrt(size(R_visPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
% xlim([1 size(R_visPSTHSPeak(:,5:65),2)]);
% axis on;axis square;
% set(gca,'xtick',[0 500 1000 1500]/timeStep,'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1550]/timeStep);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% axes();
% hold on;
% text(0.18,0,'Response, early peak (spk/s)','Fontsize',20);
% text(0.08,0.2,'Response, late peak (spk/s)','Fontsize',20,'rotation',90);
% text(0.8,0,'Time (s)','Fontsize',20);
% 
% axis off;

suptitle('PSTH distribution (Peak time)');
SetFigure(15);

set(gcf,'paperpositionmode','auto');
saveas(105,'Z:\LBY\Population Results\PSTH_PeakT','emf');

