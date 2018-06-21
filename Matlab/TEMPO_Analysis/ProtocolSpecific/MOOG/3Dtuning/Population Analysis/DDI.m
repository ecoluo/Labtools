% Analysis for DDI distribution
% LBY 20171123

% pack DDI data, according to p value (ANOVA)
% both vesti & visual are significant or not significant
T_vestiDDISig_all = T_vestiDDI(TResponSigboth &TANOVASigboth);
T_visDDISig_all = T_visDDI(TResponSigboth &TANOVASigboth);
T_vestiDDInSig_all = T_vestiDDI(~TANOVASigboth &TResponSigboth);
T_visDDInSig_all = T_visDDI(~TANOVASigboth &TResponSigboth);
R_vestiDDISig_all = R_vestiDDI(RResponSigboth &RANOVASigboth);
R_visDDISig_all = R_visDDI(RResponSigboth &RANOVASigboth);
R_vestiDDInSig_all = R_vestiDDI(~RANOVASigboth &RResponSigboth);
R_visDDInSig_all = R_visDDI(~RANOVASigboth &RResponSigboth);


% considering specific stim type itself

T_vestiDDISig = T_vestiDDI(TResponSigVesti &TANOVASigVesti);
T_visDDISig = T_visDDI(TResponSigVis &TANOVASigVis);
T_vestiDDInSig = T_vestiDDI(~TANOVASigVesti &TResponSigVesti);
T_visDDInSig = T_visDDI(~TANOVASigVis &TResponSigVis);
R_vestiDDISig = R_vestiDDI(RResponSigVesti &RANOVASigVesti);
R_visDDISig = R_visDDI(RResponSigVis &RANOVASigVis);
R_vestiDDInSig = R_vestiDDI(~RANOVASigVesti &RResponSigVesti);
R_visDDInSig = R_visDDI(~RANOVASigVis &RResponSigVis);

T_vestiDDISigMedian = median(T_vestiDDISig);
T_visDDISigMedian = median(T_visDDISig);
R_vestiDDISigMedian = median(R_vestiDDISig);
R_visDDISigMedian = median(R_visDDISig);

%% plot figures for DDI distribution

%%%%%%%%%%%%%%%%%%%%% DDI - vestibular vs. visual %%%%%%%%%%%%%%%%%%%%%%%%%



xDDI = 0.05:0.1:0.85;

figure(101);set(gcf,'pos',[60 70 1700 800]);clf;
[~,h_subplot] = tight_subplot(2,4,0.1,0.17);


% for Translation
axes(h_subplot(1));
text(1,-0.05,'Translation','Fontsize',30,'rotation',90);
text(1.3,-0.7,'Visual DDI','Fontsize',25,'rotation',90);
axis off;
% vestibular vs. visual
axes(h_subplot(2));
hold on;
plot(T_vestiDDISig_all,T_visDDISig_all,'ko','markersize',8,'markerfacecolor','k');
plot(T_vestiDDInSig_all,T_visDDInSig_all,'ko','markersize',8,'markerfacecolor','w');
plot([0 0.85],[0 0.85],'--','color',colorLGray,'linewidth',3);
% text(0.1,0.8,['n = ',num2str(TResponSigbothNo)]);
text(0.1,0.8,['n = ',num2str(length(T_vestiDDISig_all))]);
axis on;
hold off;

% vestibular distribution
axes(h_subplot(3));
hold on;
[nelements_sig, ncenters_sig] = hist(T_vestiDDISig,xDDI);
[nelements_nsig, ncenters_nsig] = hist([T_vestiDDISig;T_vestiDDInSig],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',3);
% text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(TResponSigVestiNo)]);
text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(T_vestiDDISig))]);
plot(T_vestiDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(T_vestiDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_vestiDDISigMedian));
axis on;
hold off;

% visual distribution
axes(h_subplot(4));
hold on;
[nelements_sig, ncenters_sig] = hist(T_visDDISig,xDDI);
[nelements_nsig, ncenters_nsig] = hist([T_visDDISig;T_visDDInSig],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',3);
% text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(TResponSigVisNo)]);
text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(T_visDDISig))]);
plot(T_visDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(T_visDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_visDDISigMedian));
axis on;
hold off;

% for Rotation
axes(h_subplot(5));
text(1,0.1,'Rotation','Fontsize',30,'rotation',90);
axis off;
% vestibular vs. visual
axes(h_subplot(6));
hold on;
plot(R_vestiDDISig_all,R_visDDISig_all,'ko','markersize',8,'markerfacecolor','k');
plot(R_vestiDDInSig_all,R_visDDInSig_all,'ko','markersize',8,'markerfacecolor','w');
plot([0 0.85],[0 0.85],'--','color',colorLGray,'linewidth',3);
% text(0.1,0.8,['n = ',num2str(RResponSigbothNo)]);
text(0.1,0.8,['n = ',num2str(length(R_vestiDDISig_all))]);
xlabel('Vestibular DDI'); 
axis on;
hold off;

% vestibular distribution
axes(h_subplot(7));
hold on;
[nelements_sig, ncenters_sig] = hist(R_vestiDDISig,xDDI);
[nelements_nsig, ncenters_nsig] = hist([R_vestiDDISig;R_vestiDDInSig],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorLBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorLBlue,'edgecolor',colorLBlue);
set(h1,'linewidth',3);
% text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(RResponSigVestiNo)]);
text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(R_vestiDDISig))]);
plot(R_vestiDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(R_vestiDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_vestiDDISigMedian));
xlabel('Vestibular DDI');
axis on;
hold off;

% visual distribution
axes(h_subplot(8));
hold on;
[nelements_sig, ncenters_sig] = hist(R_visDDISig,xDDI);
[nelements_nsig, ncenters_nsig] = hist([R_visDDISig;R_visDDInSig],xDDI);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorLRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorLRed,'edgecolor',colorLRed);
set(h1,'linewidth',3);
% text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(RResponSigVisNo)]);
text(0.7,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(R_visDDISig))]);
plot(R_visDDISigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(R_visDDISigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_visDDISigMedian));
xlabel('Visual DDI');
axis on;
hold off;

suptitle('DDI distribution');
SetFigure(25);

set(gcf,'paperpositionmode','auto');
saveas(101,'Z:\LBY\Population Results\DDI','emf');