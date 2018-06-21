% difference between Dark & Fixation
% LBY 20171105

clear all;
load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\PSTH_OriData_Dark.mat');
QQ_3DTuning_T_Dark = QQ_3DTuning_T;
QQ_3DTuning_R_Dark = QQ_3DTuning_R;
load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\PSTH_OriData.mat');

%%%%%%%%%%%%%%%%   pack data for cells with dark control   %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% for Translation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_name = cat(1,QQ_3DTuning_T.name);
T_ch = cat(1,QQ_3DTuning_T.ch);
TDark_name = cat(1,QQ_3DTuning_T_Dark.name);
TDark_ch = cat(1,QQ_3DTuning_T_Dark.ch);

pc = 0;
for Dark_inx = 1:length(TDark_name)
    ind_c = find(T_name == TDark_name(Dark_inx));
    if ~isempty(ind_c) % find the cell for cells performed dark control
        index = find(T_ch(ind_c) == TDark_ch(Dark_inx));
        if ~isempty(index) % find the exact channel
            pc = pc+1;
            T_inx = ind_c(index);
            T_DarknN(pc).name = QQ_3DTuning_T_Dark(Dark_inx).name;
            T_DarknN(pc).ch = QQ_3DTuning_T_Dark(Dark_inx).ch;
            if ~isempty(find(QQ_3DTuning_T(T_inx).stimType == 1))
                T_DarknN(pc).Tvesti_DDI = QQ_3DTuning_T(T_inx).DDI(find(QQ_3DTuning_T(T_inx).stimType == 1));
                T_DarknN(pc).Tvesti_ANOVA = QQ_3DTuning_T(T_inx).ANOVA(find(QQ_3DTuning_T(T_inx).stimType == 1));
                T_DarknN(pc).Tvesti_PreDir = QQ_3DTuning_T(T_inx).preDir{find(QQ_3DTuning_T(T_inx).stimType == 1)};
                T_DarknN(pc).Tvesti_ResponSig = QQ_3DTuning_T(T_inx).responSig(find(QQ_3DTuning_T(T_inx).stimType == 1));
                T_DarknN(pc).Tvesti_maxFR = QQ_3DTuning_T(T_inx).maxFR(find(QQ_3DTuning_T(T_inx).stimType == 1));
                T_DarknN(pc).Tvesti_minFR = QQ_3DTuning_T(T_inx).minFR(find(QQ_3DTuning_T(T_inx).stimType == 1));
                
                T_DarknN(pc).Tdark_DDI = QQ_3DTuning_T_Dark(Dark_inx).DDI;
                T_DarknN(pc).Tdark_ANOVA = QQ_3DTuning_T_Dark(Dark_inx).ANOVA;
                T_DarknN(pc).Tdark_PreDir = QQ_3DTuning_T_Dark(Dark_inx).preDir{:};
                T_DarknN(pc).Tdark_ResponSig = QQ_3DTuning_T_Dark(Dark_inx).responSig;
                T_DarknN(pc).Tdark_maxFR = QQ_3DTuning_T_Dark(Dark_inx).maxFR;
                T_DarknN(pc).Tdark_minFR = QQ_3DTuning_T_Dark(Dark_inx).minFR;
                
            end
        end
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for Rotation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R_name = cat(1,QQ_3DTuning_R.name);
R_ch = cat(1,QQ_3DTuning_R.ch);
RDark_name = cat(1,QQ_3DTuning_R_Dark.name);
RDark_ch = cat(1,QQ_3DTuning_R_Dark.ch);

pc = 0;
for Dark_inx = 1:length(RDark_name)
    ind_c = find(R_name == RDark_name(Dark_inx));
    if ~isempty(ind_c) % find the cell for cells performed dark control
        index = find(R_ch(ind_c) == RDark_ch(Dark_inx));
        if ~isempty(index) % find the exact channel
            pc = pc+1;
            R_inx = ind_c(index);
            R_DarknN(pc).name = QQ_3DTuning_R_Dark(Dark_inx).name;
            R_DarknN(pc).ch = QQ_3DTuning_R_Dark(Dark_inx).ch;
            if ~isempty(find(QQ_3DTuning_R(R_inx).stimType == 1))
                R_DarknN(pc).Rvesti_DDI = QQ_3DTuning_R(R_inx).DDI(find(QQ_3DTuning_R(R_inx).stimType == 1));
                R_DarknN(pc).Rvesti_ANOVA = QQ_3DTuning_R(R_inx).ANOVA(find(QQ_3DTuning_R(R_inx).stimType == 1));
                R_DarknN(pc).Rvesti_PreDir = QQ_3DTuning_R(R_inx).preDir{find(QQ_3DTuning_R(R_inx).stimType == 1)};
                R_DarknN(pc).Rvesti_ResponSig = QQ_3DTuning_R(R_inx).responSig(find(QQ_3DTuning_R(R_inx).stimType == 1));
                R_DarknN(pc).Rvesti_maxFR = QQ_3DTuning_R(R_inx).maxFR(find(QQ_3DTuning_R(R_inx).stimType == 1));
                R_DarknN(pc).Rvesti_minFR = QQ_3DTuning_R(R_inx).minFR(find(QQ_3DTuning_R(R_inx).stimType == 1));
                
                R_DarknN(pc).Rdark_DDI = QQ_3DTuning_R_Dark(Dark_inx).DDI;
                R_DarknN(pc).Rdark_ANOVA = QQ_3DTuning_R_Dark(Dark_inx).ANOVA;
                R_DarknN(pc).Rdark_PreDir = QQ_3DTuning_R_Dark(Dark_inx).preDir{:};
                R_DarknN(pc).Rdark_ResponSig = QQ_3DTuning_R_Dark(Dark_inx).responSig;
                R_DarknN(pc).Rdark_maxFR = QQ_3DTuning_R_Dark(Dark_inx).maxFR;
                R_DarknN(pc).Rdark_minFR = QQ_3DTuning_R_Dark(Dark_inx).minFR;
                
            end
        end
        
    end
end

%% classified cells according to temporal tuning & ANOVA

T_vestiResponSig = cat(1,T_DarknN.Tvesti_ResponSig);
T_darkResponSig = cat(1,T_DarknN.Tdark_ResponSig);
T_vestiANOVA = cat(1,T_DarknN.Tvesti_ANOVA);
T_darkANOVA = cat(1,T_DarknN.Tdark_ANOVA);

R_vestiResponSig = cat(1,R_DarknN.Rvesti_ResponSig);
R_darkResponSig = cat(1,R_DarknN.Rdark_ResponSig);
R_vestiANOVA = cat(1,R_DarknN.Rvesti_ANOVA);
R_darkANOVA = cat(1,R_DarknN.Rdark_ANOVA);

% cells classified according to temporal response
TResponSigboth = logical(T_vestiResponSig==1)&logical(T_darkResponSig==1);
TResponSigVesti = logical(T_vestiResponSig==1);
TResponSigDark = logical(T_darkResponSig==1);

RResponSigboth = logical(R_vestiResponSig==1)&logical(R_darkResponSig==1);
RResponSigVesti = logical(R_vestiResponSig==1);
RResponSigDark = logical(R_darkResponSig==1);

% cells classified according to ANOVA
TANOVASigboth = logical(T_vestiANOVA<0.05)&logical(T_darkANOVA<0.05);
TANOVASigVesti = logical(T_vestiANOVA<0.05);
TANOVASigDark = logical(T_darkANOVA<0.05);

RANOVASigboth = logical(R_vestiANOVA<0.05)&logical(R_darkANOVA<0.05);
RANOVASigVesti = logical(R_vestiANOVA<0.05);
RANOVASigDark = logical(R_darkANOVA<0.05);
%% pack data

% DDI
T_DDI = cat(1,T_DarknN.Tvesti_DDI);
T_Dark_DDI = cat(1,T_DarknN.Tdark_DDI);
R_DDI = cat(1,R_DarknN.Rvesti_DDI);
R_Dark_DDI = cat(1,R_DarknN.Rdark_DDI);

% preferred direction
T_PreDir = reshape(cat(2,T_DarknN.Tvesti_PreDir),3,[])';
T_Dark_PreDir = reshape(cat(2,T_DarknN.Tdark_PreDir),3,[])';
R_PreDir = reshape(cat(2,R_DarknN.Rvesti_PreDir),3,[])';
R_Dark_PreDir = reshape(cat(2,R_DarknN.Rdark_PreDir),3,[])';

% delta preferred direction
T_PreDir_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDir,ones(1,length(T_PreDir)),3),mat2cell(T_Dark_PreDir,ones(1,length(T_Dark_PreDir)),3));
R_PreDir_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(R_PreDir,ones(1,length(R_PreDir)),3),mat2cell(R_Dark_PreDir,ones(1,length(R_Dark_PreDir)),3));

% Rmax - Rmin
T_maxFR = cat(1,T_DarknN.Tvesti_maxFR);
T_minFR = cat(1,T_DarknN.Tvesti_minFR);
T_Dark_maxFR = cat(1,T_DarknN.Tdark_maxFR);
T_Dark_minFR = cat(1,T_DarknN.Tdark_minFR);
R_maxFR = cat(1,R_DarknN.Rvesti_maxFR);
R_minFR = cat(1,R_DarknN.Rvesti_minFR);
R_Dark_maxFR = cat(1,R_DarknN.Rdark_maxFR);
R_Dark_minFR = cat(1,R_DarknN.Rdark_minFR);

T_ResponDiff = T_maxFR - T_minFR;
T_Dark_ResponDiff = T_Dark_maxFR - T_Dark_minFR;
R_ResponDiff = R_maxFR - R_minFR;
R_Dark_ResponDiff = R_Dark_maxFR - R_Dark_minFR;

%% pack data
T_DDISig = T_DDI(TResponSigboth &TANOVASigboth);
T_Dark_DDISig = T_Dark_DDI(TResponSigboth &TANOVASigboth);
T_DDInSig = T_DDI(~(TResponSigboth &TANOVASigboth));
T_Dark_DDInSig = T_Dark_DDI(~(TResponSigboth &TANOVASigboth));
T_PreDirSig = T_PreDir(TResponSigboth &TANOVASigboth);
T_Dark_PreDirSig = T_Dark_PreDir(TResponSigboth &TANOVASigboth,:);
T_PreDirnSig = T_PreDir(~(TResponSigboth &TANOVASigboth),:);
T_PreDir_diffSig = T_PreDir_diff(TResponSigboth &TANOVASigboth,:);
T_PreDir_diffnSig = T_PreDir_diff(~(TResponSigboth &TANOVASigboth),:);
T_Dark_PreDirnSig = T_Dark_PreDir(~(TResponSigboth &TANOVASigboth),:);
T_ResponDiffSig = T_ResponDiff(TResponSigboth &TANOVASigboth);
T_Dark_ResponDiffSig = T_Dark_ResponDiff(TResponSigboth &TANOVASigboth);
T_ResponDiffnSig = T_ResponDiff(~(TResponSigboth &TANOVASigboth));
T_Dark_ResponDiffnSig = T_Dark_ResponDiff(~(TResponSigboth &TANOVASigboth));


R_DDISig = R_DDI(RResponSigboth &RANOVASigboth);
R_Dark_DDISig = R_Dark_DDI(RResponSigboth &RANOVASigboth);
R_DDInSig = R_DDI(~(RResponSigboth &RANOVASigboth));
R_Dark_DDInSig = R_Dark_DDI(~(RResponSigboth &RANOVASigboth));
R_PreDirSig = R_PreDir(RResponSigboth &RANOVASigboth);
R_Dark_PreDirSig = R_Dark_PreDir(RResponSigboth &RANOVASigboth,:);
R_PreDirnSig = R_PreDir(~(RResponSigboth &RANOVASigboth),:);
R_Dark_PreDirnSig = R_Dark_PreDir(~(RResponSigboth &RANOVASigboth),:);
R_PreDir_diffSig = R_PreDir_diff(RResponSigboth &RANOVASigboth,:);
R_PreDir_diffnSig = R_PreDir_diff(~(RResponSigboth &RANOVASigboth),:);
R_ResponDiffSig = R_ResponDiff(RResponSigboth &RANOVASigboth);
R_Dark_ResponDiffSig = R_Dark_ResponDiff(RResponSigboth &RANOVASigboth);
R_ResponDiffnSig = R_ResponDiff(~(RResponSigboth &RANOVASigboth));
R_Dark_ResponDiffnSig = R_Dark_ResponDiff(~(RResponSigboth &RANOVASigboth));

T_PreDir_diffSigMedian = median(T_PreDir_diffSig);
R_PreDir_diffSigMedian = median(R_PreDir_diffSig);

%% Analysis

colorDefsLBY;

figure(301);set(gcf,'pos',[60 70 1700 800]);clf;
[~,h_subplot] = tight_subplot(2,4,0.11,0.2);

%%%%%%%%%%%%%%%%%%%%%%%% DDI distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(h_subplot(1));
text(1,-0.05,'Translation','Fontsize',30,'rotation',90);
text(1.3,-0.7,'Fixation DDI','Fontsize',25,'rotation',90);
axis off;
axes(h_subplot(5));
text(1,0.1,'Rotation','Fontsize',30,'rotation',90);
axis off;

% Translation
axes(h_subplot(2));
hold on;
plot([0 0.95],[0 0.95],'--','color',colorLGray,'linewidth',3);
plot(T_DDISig,T_Dark_DDISig,'ko','markersize',10,'markerfacecolor','k');
plot(T_DDInSig,T_Dark_DDInSig,'ko','markersize',10,'markerfacecolor','w','markeredgecolor','k');
text(0.1,0.8,['n = ',num2str(length(T_DDISig))]);
[h,p_DDI_T] = ttest(T_DDISig,T_Dark_DDISig)
axis on;
hold off;

% Rotation
axes(h_subplot(6));
hold on;
plot([0 0.95],[0 0.95],'--','color',colorLGray,'linewidth',3);
plot(R_DDISig,R_Dark_DDISig,'ko','markersize',10,'markerfacecolor','k');
plot(R_DDInSig,R_Dark_DDInSig,'ko','markersize',10,'markerfacecolor','w','markeredgecolor','k');
text(0.1,0.8,['n = ',num2str(length(R_DDISig))]);
xlabel('Dark DDI');
[h,p_DDI_R] = ttest(R_DDISig,R_Dark_DDISig)
axis on;
hold off;

%%%%%%%%%%%% delta preferred direction distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xdiffPreDir = 9:18:(180-9);

% Translation
axes(h_subplot(3));
hold on;
[nelements_sig, ncenters_sig] = hist(T_PreDir_diffSig,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([T_PreDir_diffSig;T_PreDir_diffnSig],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(T_PreDir_diffSig))]);
plot(T_PreDir_diffSigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv','markerfacecolor','k');
text(T_PreDir_diffSigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_PreDir_diffSigMedian));
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[0 180]);
[h p_preDir_T] = ttest(T_PreDir_diffSig,0)
axis on;
hold off;

% Rotation
axes(h_subplot(7));
hold on;
[nelements_sig, ncenters_sig] = hist(R_PreDir_diffSig,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([R_PreDir_diffSig;R_PreDir_diffnSig],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(R_PreDir_diffSig))]);
plot(R_PreDir_diffSigMedian,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv','markerfacecolor','k');
text(R_PreDir_diffSigMedian*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_PreDir_diffSigMedian));
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[0 180]);
xlabel('\Delta preferred direction');
[h,p_preDir_R] = ttest(R_PreDir_diffSig,0)
axis on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%% Rmax - Rmin distribution %%%%%%%%%%%%%%%%%%%%%%%%%

% Translation
axes(h_subplot(4));
hold on;
plot([0 max(max(T_ResponDiff),max(T_Dark_ResponDiff))+20],[0 max(max(T_ResponDiff),max(T_Dark_ResponDiff))+20],'--','color',colorLGray,'linewidth',3);
plot(T_ResponDiffSig,T_Dark_ResponDiffSig,'ko','markersize',10,'markerfacecolor','k');
plot(T_ResponDiffnSig,T_Dark_ResponDiffnSig,'ko','markersize',10,'markerfacecolor','w');
text(max(T_ResponDiff)+20,max(T_Dark_ResponDiff)+20,['n = ',num2str(length(T_ResponDiffSig))]);
h = legend('','p < 0.05', 'p > 0.05','location','NorthWest');
set(h,'fontsize',8);
[h,p_DDI_T] = ttest(T_ResponDiffSig,T_Dark_ResponDiffSig)
axis on;
hold off;

% Translation
axes(h_subplot(8));
hold on;
plot([0 max(max(R_ResponDiff),max(R_Dark_ResponDiff))+20],[0 max(max(R_ResponDiff),max(R_Dark_ResponDiff))+20],'--','color',colorLGray,'linewidth',3);
plot(R_ResponDiffSig,R_Dark_ResponDiffSig,'ko','markersize',10,'markerfacecolor','k');
plot(R_ResponDiffnSig,R_Dark_ResponDiffnSig,'ko','markersize',10,'markerfacecolor','w');
text(max(R_ResponDiff)+20,max(R_Dark_ResponDiff)+20,['n = ',num2str(length(R_ResponDiffSig))]);
xlabel('Dark (Rmax - Rmin)');
[h,p_DDI_R] = ttest(R_ResponDiffSig,R_Dark_ResponDiffSig)
axis on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% text figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes();
hold on;xlim([0 1]);ylim([0 1]);
text(0.49,0.3,'Cell numbers','Fontsize',25,'rotation',90);
text(0.8,0.1,'Fixation (Rmax - Rmin)','Fontsize',25,'rotation',90);
axis off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% save figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suptitle('Dark vs. Fixation');
SetFigure(25);

set(gcf,'paperpositionmode','auto');
saveas(301,'Z:\LBY\Population Results\Dark_Fixation','emf');
