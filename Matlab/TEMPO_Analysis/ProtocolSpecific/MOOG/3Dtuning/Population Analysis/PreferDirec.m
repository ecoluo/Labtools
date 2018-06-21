% Analysis for preferred direction distribution & differences
% LBY 18171123

% pack preferred direction data, according to p value (ANOVA)

% considering specific stim type itself
T_vestiPreDirSig = T_vestiPreDir(TResponSigVesti &TANOVASigVesti,:);
T_visPreDirSig = T_visPreDir(TResponSigVis &TANOVASigVis,:);
T_vestiPreDirnSig = T_vestiPreDir(~TANOVASigVesti &TResponSigVesti,:);
T_visPreDirnSig = T_visPreDir(~TANOVASigVis &TResponSigVis,:);
R_vestiPreDirSig = R_vestiPreDir(RResponSigVesti &RANOVASigVesti,:);
R_visPreDirSig = R_visPreDir(RResponSigVis &RANOVASigVis,:);
R_vestiPreDirnSig = R_vestiPreDir(~RANOVASigVesti &RResponSigVesti,:);
R_visPreDirnSig = R_visPreDir(~RANOVASigVis &RResponSigVis,:);

% both vesti & visual are significant or not significant
T_vestiPreDirSig_all = T_vestiPreDir(TResponSigboth &TANOVASigboth,:);
T_visPreDirSig_all = T_visPreDir(TResponSigboth &TANOVASigboth,:);
T_vestiPreDirnSig_all = T_vestiPreDir(~TANOVASigboth &TResponSigboth,:);
T_visPreDirnSig_all = T_visPreDir(~TANOVASigboth &TResponSigboth,:);
R_vestiPreDirSig_all = R_vestiPreDir(RResponSigboth &RANOVASigboth,:);
R_visPreDirSig_all = R_visPreDir(RResponSigboth &RANOVASigboth,:);
R_vestiPreDirnSig_all = R_vestiPreDir(~RANOVASigboth &RResponSigboth,:);
R_visPreDirnSig_all = R_visPreDir(~RANOVASigboth &RResponSigboth,:);

% delta preferred direction between vetibular & visual
T_PreDirSig_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_vestiPreDirSig_all,ones(1,size(T_vestiPreDirSig_all,1)),3),mat2cell(T_visPreDirSig_all,ones(1,size(T_visPreDirSig_all,1)),3));
T_PreDirnSig_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_vestiPreDirnSig_all,ones(1,size(T_vestiPreDirnSig_all,1)),3),mat2cell(T_visPreDirnSig_all,ones(1,size(T_visPreDirnSig_all,1)),3));
R_PreDirSig_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(R_vestiPreDirSig_all,ones(1,size(R_vestiPreDirSig_all,1)),3),mat2cell(R_visPreDirSig_all,ones(1,size(R_visPreDirSig_all,1)),3));
R_PreDirnSig_diff = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(R_vestiPreDirnSig_all,ones(1,size(R_vestiPreDirnSig_all,1)),3),mat2cell(R_visPreDirnSig_all,ones(1,size(R_visPreDirnSig_all,1)),3));

T_PreDirSig_diff_median = median(T_PreDirSig_diff);
R_PreDirSig_diff_median = median(R_PreDirSig_diff);
%% plot figures for PreDir distribution

%%%%%%%%%%%%%%%%%%%%% PreDir - vestibular vs. visual %%%%%%%%%%%%%%%%%%%%%%

xazi = 18:36:(360-18);
xele = (-90+9):18:(90-9);
xdiffPreDir = 9:18:(180-9);

figure(102);set(gcf,'pos',[15 15 1800 1000]);clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%% for Translation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% text(1,-0.05,'Translation','Fontsize',30,'rotation',90);
% text(1.6,-0.5,'Elevation(deg)','Fontsize',25,'rotation',90);
% axis off;

%%%%%%%%%%%% vestibular
% scatter
axes('unit','pixels','pos',[300 500 180 180]);
hold on;
plot(T_vestiPreDirSig(:,1),T_vestiPreDirSig(:,2),'wo','markersize',6,'markerfacecolor',colorDBlue,'markeredgecolor',colorDBlue);
plot(T_vestiPreDirnSig(:,1),T_vestiPreDirnSig(:,2),'ko','markersize',6,'markeredgecolor',colorDBlue,'markerfacecolor','w');
xlabel('\leftarrow    \uparrow    \rightarrow    \downarrow    \leftarrow','fontsize',15);
ylabel('\leftarrow          \downarrow         \rightarrow','fontsize',15);
% text(400,-118,['n = ',num2str(TResponSigVestiNo)]);
text(400,-118,['n = ',num2str(length(T_vestiPreDirSig(:,1)))]);

axis square;
set(gca,'box','on','xtick',[0 90 180 270 360],'ytick',[-90 -45 0 45 90],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ylim',[-90 90]);
set(gca,'ydir','reverse');
hold off;
% azimuth
axes('unit','pixels','pos',[300 500+180 180 50]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_vestiPreDirSig(:,1),xazi);
[nelements_nsig, ncenters_nsig] = hist([T_vestiPreDirSig(:,1);T_vestiPreDirnSig(:,1)],xazi);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ycolor','w');
[h_Tvesti_azi_uniform,p_Tvesti_azi_uniform] = UniformTest_LBY(T_vestiPreDirSig(:,1))
[h_Tvesti_azi_norm,p_Tvesti_azi_norm] = NormalTest_LBY(T_vestiPreDirSig(:,1))
hold off;
% elevation
axes('unit','pixels','pos',[300+180 500 50 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_vestiPreDirSig(:,2),xele);
[nelements_nsig, ncenters_nsig] = hist([T_vestiPreDirSig(:,2);T_vestiPreDirnSig(:,2)],xele);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[-90 90],'ycolor','w');
[h_Tvesti_ele_uniform,p_Tvesti_ele_uniform] = UniformTest_LBY(T_vestiPreDirSig(:,2))
[h_Tvesti_ele_norm,p_Tvesti_ele_norm] = NormalTest_LBY(T_vestiPreDirSig(:,2))
view(90,90);
hold off;

%%%%%%%%%%%% visual
axes('unit','pixels','pos',[718 500 180 180]);
hold on;
plot(T_visPreDirSig(:,1),T_visPreDirSig(:,2),'wo','markersize',6,'markerfacecolor',colorDRed,'markeredgecolor',colorDRed);
plot(T_visPreDirnSig(:,1),T_visPreDirnSig(:,2),'ko','markersize',6,'markeredgecolor',colorDRed,'markerfacecolor','w');
xlabel('\leftarrow    \uparrow    \rightarrow    \downarrow    \leftarrow','fontsize',15);
ylabel('\leftarrow          \downarrow         \rightarrow','fontsize',15);
% text(400,-118,['n = ',num2str(TResponSigVisNo)]);
text(400,-118,['n = ',num2str(length(T_visPreDirSig(:,1)))]);
axis square;
set(gca,'box','on','xtick',[0 90 180 270 360],'ytick',[-90 -45 0 45 90],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ylim',[-90 90]);
set(gca,'ydir','reverse');
hold off;

% azimuth
axes('unit','pixels','pos',[718 500+180 180 50]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_visPreDirSig(:,1),xazi);
[nelements_nsig, ncenters_nsig] = hist([T_visPreDirSig(:,1);T_visPreDirnSig(:,1)],xazi);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ycolor','w');
[h_Tvis_azi_uniform,p_Tvis_azi_uniform] = UniformTest_LBY(T_visPreDirSig(:,1))
[h_Tvis_azi_norm,p_Tvis_azi_norm] = NormalTest_LBY(T_visPreDirSig(:,1))
hold off;

% elevation
axes('unit','pixels','pos',[718+180 500 50 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_visPreDirSig(:,2),xele);
[nelements_nsig, ncenters_nsig] = hist([T_visPreDirSig(:,2);T_visPreDirnSig(:,2)],xele);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[-90 90],'ycolor','w');
[h_Tvis_ele_uniform,p_Tvis_ele_uniform] = UniformTest_LBY(T_visPreDirSig(:,2))
[h_Tvis_ele_norm,p_Tvis_ele_norm] = NormalTest_LBY(T_visPreDirSig(:,2))
view(90,90);
hold off;


% Delta preferred direction between vestibular & visual
axes('unit','pixels','pos',[1250 500 400 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(T_PreDirSig_diff,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([T_PreDirSig_diff;T_PreDirnSig_diff],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
% text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(TResponSigbothNo)]);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(T_PreDirSig_diff))]);
plot(T_PreDirSig_diff_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(T_PreDirSig_diff_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(T_PreDirSig_diff_median));
% ylabel('Translation');
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[0 180]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%% for Rotation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% vestibular
axes('unit','pixels','pos',[300 110 180 180]);
hold on;
plot(R_vestiPreDirSig(:,1),R_vestiPreDirSig(:,2),'wo','markersize',6,'markerfacecolor',colorLBlue,'markeredgecolor',colorLBlue);
plot(R_vestiPreDirnSig(:,1),R_vestiPreDirnSig(:,2),'ko','markersize',6,'markeredgecolor',colorLBlue,'markerfacecolor','w');
% xlabel('Azimuth (deg)');
xlabel('\leftarrow    \uparrow    \rightarrow    \downarrow    \leftarrow','fontsize',15);
ylabel('\leftarrow          \downarrow         \rightarrow','fontsize',15);
% text(400,-118,['n = ',num2str(RResponSigVestiNo)]);
text(400,-118,['n = ',num2str(length(R_vestiPreDirSig(:,1)))]);
axis on;axis square;
set(gca,'box','on','xtick',[0 90 180 270 360],'ytick',[-90 -45 0 45 90],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ylim',[-90 90]);
set(gca,'ydir','reverse');
hold off;

% azimuth
axes('unit','pixels','pos',[300 110+180 180 50]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_vestiPreDirSig(:,1),xazi);
[nelements_nsig, ncenters_nsig] = hist([R_vestiPreDirSig(:,1);R_vestiPreDirnSig(:,1)],xazi);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorLBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorLBlue,'edgecolor',colorLBlue);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ycolor','w');
[h_Rvesti_azi_uniform,p_Rvesti_azi_uniform] = UniformTest_LBY(R_vestiPreDirSig(:,1))
[h_Rvesti_azi_norm,p_Rvesti_azi_norm] = NormalTest_LBY(R_vestiPreDirSig(:,1))
hold off;

% elevation
axes('unit','pixels','pos',[300+180 110 50 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_vestiPreDirSig(:,2),xele);
[nelements_nsig, ncenters_nsig] = hist([R_vestiPreDirSig(:,2);R_vestiPreDirnSig(:,2)],xele);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorLBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorLBlue,'edgecolor',colorLBlue);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[-90 90],'ycolor','w');
[h_Rvesti_ele_uniform,p_Rvesti_ele_uniform] = UniformTest_LBY(R_vestiPreDirSig(:,2))
[h_Rvesti_ele_norm,p_Rvesti_ele_norm] = NormalTest_LBY(R_vestiPreDirSig(:,2))
view(90,90);
hold off;

%%%%%%%%%%%%%% visual
axes('unit','pixels','pos',[718 110 180 180]);
hold on;
plot(R_visPreDirSig(:,1),R_visPreDirSig(:,2),'wo','markersize',6,'markerfacecolor',colorLRed,'markeredgecolor',colorLRed);
plot(R_visPreDirnSig(:,1),R_visPreDirnSig(:,2),'ko','markersize',6,'markerfacecolor','w','markeredgecolor',colorLRed);
% xlabel('Azimuth (deg)');
xlabel('\leftarrow    \uparrow    \rightarrow    \downarrow    \leftarrow','fontsize',15);
ylabel('\leftarrow          \downarrow         \rightarrow','fontsize',15);
% text(400,-118,['n = ',num2str(RResponSigVisNo)]);
text(400,-118,['n = ',num2str(length(R_visPreDirSig(:,1)))]);
axis on;axis square;
set(gca,'box','on','xtick',[0 90 180 270 360],'ytick',[-90 -45 0 45 90],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ylim',[-90 90]);
set(gca,'ydir','reverse');
hold off;

% azimuth
axes('unit','pixels','pos',[718 110+180 180 50]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_visPreDirSig(:,1),xazi);
[nelements_nsig, ncenters_nsig] = hist([R_visPreDirSig(:,1);R_visPreDirnSig(:,1)],xazi);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorLRed);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorLRed,'edgecolor',colorLRed);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[0 360],'ycolor','w');
[h_Rvis_azi_uniform,p_Rvis_azi_uniform] = UniformTest_LBY(R_visPreDirSig(:,1))
[h_Rvis_azi_norm,p_Rvis_azi_norm] = NormalTest_LBY(R_visPreDirSig(:,1))
hold off;

% elevation
axes('unit','pixels','pos',[718+180 110 50 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_visPreDirSig(:,2),xele);
[nelements_nsig, ncenters_nsig] = hist([R_visPreDirSig(:,2);R_visPreDirnSig(:,2)],xele);
h1 = bar(ncenters_nsig, nelements_nsig, 0.7,'w','edgecolor',colorLRed);
h2 = bar(ncenters_sig, nelements_sig, 0.7,'facecolor',colorLRed,'edgecolor',colorLRed);
set(h1,'linewidth',3);
set(gca,'xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'xlim',[-90 90],'ycolor','w');
[h_Rvis_ele_uniform,p_Rvis_ele_uniform] = UniformTest_LBY(R_visPreDirSig(:,2))
[h_Rvis_ele_norm,p_Rvis_ele_norm] = NormalTest_LBY(R_visPreDirSig(:,2))
view(90,90);
hold off;


% Delta preferred direction between vestibular & visual
axes('unit','pixels','pos',[1250 210 400 180]);
hold on;
[nelements_sig, ncenters_sig] = hist(R_PreDirSig_diff,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([R_PreDirSig_diff;R_PreDirnSig_diff],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor','k');
h2 = bar(ncenters_sig, nelements_sig, 0.8,'k','edgecolor','k');
set(h1,'linewidth',3);
% text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(RResponSigbothNo)]);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(length(R_PreDirSig_diff))]);

plot(R_PreDirSig_diff_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(R_PreDirSig_diff_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(R_PreDirSig_diff_median));
% ylabel('Rotation');
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[0 180]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes();
hold on;
text(0.07,0.85,'Vestibular','Fontsize',25);
text(0.39,0.85,'Visual','Fontsize',25);
text(-0.05,0.6,'Translation','Fontsize',25,'rotation',90);
text(-0.05,0.1,'Rotation','Fontsize',25,'rotation',90);
text(0.25,1,'Preferred direction distribution','Fontsize',30);
text(-0.02,0.3,'Elevation (deg)','Fontsize',20,'rotation',90);
text(0.19,-0.075,'Azimuth (deg)','Fontsize',20);
text(0.78,0.01,'\Delta preferred direction','Fontsize',20);
text(0.67,0.3,'Cell numbers','Fontsize',20,'rotation',90);
plot([0.6 0.6],[0 0.8],'--','color',colorLGray);
xlim([0 1]);ylim([0 1]);
axis off;

SetFigure(25);
set(gcf,'paperpositionmode','auto');
saveas(102,'Z:\LBY\Population Results\preferDir','emf');