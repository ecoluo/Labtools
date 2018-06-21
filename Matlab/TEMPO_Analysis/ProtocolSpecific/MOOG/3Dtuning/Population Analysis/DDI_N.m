% Analysis for DDI distribution
% LBY 20171123

% pack DDI data, according to p value (ANOVA)
% both vesti & visual are responded & significant
T_vestiDDISig_all = T_vestiDDI(TResponSigboth &TANOVASigboth);
T_visDDISig_all = T_visDDI(TResponSigboth &TANOVASigboth);
R_vestiDDISig_all = R_vestiDDI(RResponSigboth &RANOVASigboth);
R_visDDISig_all = R_visDDI(RResponSigboth &RANOVASigboth);

% either responded to vestibular or visual, but not significant
T_vestiDDInSig_all = T_vestiDDI((~TANOVASigVesti &TResponSigVesti )|(~TANOVASigVis &TResponSigVis));
T_visDDInSig_all = T_visDDI((~TANOVASigVesti &TResponSigVesti )|(~TANOVASigVis &TResponSigVis));
R_vestiDDInSig_all = R_vestiDDI((~RANOVASigVesti &RResponSigVesti )|(~RANOVASigVis &RResponSigVis));
R_visDDInSig_all = R_visDDI((~RANOVASigVesti &RResponSigVesti )|(~RANOVASigVis &RResponSigVis));

% only responded and significant to either vestibular or visual

T_vestiDDISig_vesti = T_vestiDDI(~TANOVASigVis &TResponSigVesti &TANOVASigVesti);
T_vestiDDISig_vis = T_visDDI(~TANOVASigVis &TResponSigVesti &TANOVASigVesti);
T_visDDISig_vis = T_visDDI(~TANOVASigVesti &TResponSigVis &TANOVASigVis);
T_visDDISig_vesti = T_visDDI(~TANOVASigVesti &TResponSigVis &TANOVASigVis);
T_vestiDDInSig = T_vestiDDI(~TANOVASigVesti &TResponSigVesti);
T_visDDInSig = T_visDDI(~TANOVASigVis &TResponSigVis);
R_vestiDDISig_vesti = R_vestiDDI(~RANOVASigVis &RResponSigVesti &RANOVASigVesti);
R_vestiDDISig_vis = R_visDDI(~RANOVASigVis &RResponSigVesti &RANOVASigVesti);
R_visDDISig_vis = R_visDDI(~RANOVASigVesti &RResponSigVis &RANOVASigVis);
R_visDDISig_vesti = R_visDDI(~RANOVASigVesti &RResponSigVis &RANOVASigVis);
R_vestiDDInSig = R_vestiDDI(~RANOVASigVesti &RResponSigVesti);
R_visDDInSig = R_visDDI(~RANOVASigVis &RResponSigVis);

T_vestiDDISigMedian = median(T_vestiDDISig_all);
T_visDDISigMedian = median(T_visDDISig_all);
R_vestiDDISigMedian = median(R_vestiDDISig_all);
R_visDDISigMedian = median(R_visDDISig_all);

%% plot figures for DDI distribution

%%%%%%%%%%%%%%%%%%%%% DDI - vestibular vs. visual %%%%%%%%%%%%%%%%%%%%%%%%%



xDDI = 0.05:0.1:0.85;

figure(101);set(gcf,'pos',[60 70 1700 800]);clf;
[~,h_subplot] = tight_subplot(2,4,0.1,0.17);


% for Translation
% scatter
axes('unit','pixels','pos',[200 150 300 300]);
hold on;
plot(T_vestiDDISig_all,T_visDDISig_all,'ko','markersize',8,'markerfacecolor','k');
plot(T_vestiDDInSig_all,T_visDDInSig_all,'ko','markersize',8,'markerfacecolor','w');
plot(T_vestiDDISig_vesti,T_vestiDDISig_vis,'ko','markersize',8,'markerfacecolor',colorDBlue);
plot(T_visDDISig_vesti,T_visDDISig_vis,'ko','markersize',8,'markerfacecolor',colorDRed);
plot([0 1],[0 1],'-','color',colorLGray);
text(0.1,0.8,['n = ',num2str(length(T_vestiDDISig_all))]);
axis on;axis square;
xlabel('Vestibular, DDI');ylabel('Visual, DDI');
hold off;

% azimuth
axes('unit','pixels','pos',[200 150+300 300 100]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_vestiDDISig_all,xDDI);
[nelements_nsig, ncenters_nsig] = hist([T_vestiDDISig_all;T_vestiDDInSig_all],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
plot(T_vestiDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(T_vestiDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_vestiDDISigMedian));
% axis off;
set(gca,'ycolor','w','xtick',[],'ytick',[]);
title('Translation');
hold off;

% elevation
axes('unit','pixels','pos',[200+300 150 100 300]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_visDDISig_all,xDDI);
[nelements_nsig, ncenters_nsig] = hist([T_visDDISig_all;T_visDDInSig_all],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
plot(T_visDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(T_visDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_visDDISigMedian));
% axis off;
set(gca,'ycolor','w','xtick',[],'ytick',[]);
view(90,270);
hold off;

% for Rotation

% azimuth
axes('unit','pixels','pos',[800 150+300 300 100]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_vestiDDISig_all,xDDI);
[nelements_nsig, ncenters_nsig] = hist([R_vestiDDISig_all;R_vestiDDInSig_all],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
plot(R_vestiDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(R_vestiDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_vestiDDISigMedian));
% axis off;
set(gca,'ycolor','w','xtick',[],'ytick',[]);
title('Rotation');
hold off;

% elevation
axes('unit','pixels','pos',[800+300 150 100 300]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_visDDISig_all,xDDI);
[nelements_nsig, ncenters_nsig] = hist([R_visDDISig_all;R_visDDInSig_all],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
plot(R_visDDISigMedian,max(max(nelements_sig)*1.1,max(nelements_nsig))*1.1,'kv');
text(R_visDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_visDDISigMedian));
% axis off;
set(gca,'ycolor','w','xtick',[],'ytick',[]);
view(90,270);
hold off;

% scatter
axes('unit','pixels','pos',[800 150 300 300]);
hold on;
plot(R_vestiDDISig_all,R_visDDISig_all,'ko','markersize',8,'markerfacecolor','k');
plot(R_vestiDDInSig_all,R_visDDInSig_all,'ko','markersize',8,'markerfacecolor','w');
plot(R_vestiDDISig_vesti,R_vestiDDISig_vis,'ko','markersize',8,'markerfacecolor',colorLBlue);
plot(R_visDDISig_vesti,R_visDDISig_vis,'ko','markersize',8,'markerfacecolor',colorLRed);plot([0 1],[0 1],'-','color',colorLGray);
text(0.1,0.8,['n = ',num2str(length(R_vestiDDISig_all))]);
axis on;axis square;box on;
xlabel('Vestibular, DDI');ylabel('Visual, DDI');
h = legend('p_{Vesti} < 0.05, p_{Vis} < 0.05 ','p_{Vesti} > 0.05, p_{Vis} > 0.05 ','p_{Vesti} < 0.05','p_{Vis} < 0.05');
set(h,'fontsize',12,'pos',[1300 600 200 100]);
hold off;


% title('DDI distribution');
SetFigure(25);

set(gcf,'paperpositionmode','auto');
saveas(101,'Z:\LBY\Population Results\DDI_N','emf');