% difference between Translation & Rotation
% LBY 20171125

clear all;
load('Z:\Data\TEMPO\BATCH\Polo_3DTuning\PSTH_OriData.mat');
Monkey = 'Polo';

%%%%%%%%%%%%%%%%   pack data for cells with both T&R task   %%%%%%%%%%%%%%%

T_name = cat(1,Polo_3DTuning_T.name);
T_ch = cat(1,Polo_3DTuning_T.ch);
R_name = cat(1,Polo_3DTuning_R.name);
R_ch = cat(1,Polo_3DTuning_R.ch);

pc = 0;
for R_inx = 1:length(R_name)
    ind_c = find(T_name == R_name(R_inx));
    if ~isempty(ind_c) % find the cell for both T&R
        index = find(T_ch(ind_c) == R_ch(R_inx));
        if ~isempty(index) % find the exact channel for the cell for both T&R
            pc = pc+1;
            T_inx = ind_c(index);
            TnR(pc).name = Polo_3DTuning_R(R_inx).name;
            TnR(pc).ch = Polo_3DTuning_R(R_inx).ch;
            TnR(pc).T_stimType = Polo_3DTuning_T(T_inx).stimType;
            TnR(pc).R_stimType = Polo_3DTuning_R(R_inx).stimType;
            if ~isempty(find(Polo_3DTuning_T(T_inx).stimType == 1))
                TnR(pc).Tvesti = 1;
                TnR(pc).Tvesti_DDI = Polo_3DTuning_T(T_inx).DDI(find(Polo_3DTuning_T(T_inx).stimType == 1));
                TnR(pc).Tvesti_ANOVA = Polo_3DTuning_T(T_inx).ANOVA(find(Polo_3DTuning_T(T_inx).stimType == 1));
                TnR(pc).Tvesti_PreDir = Polo_3DTuning_T(T_inx).preDir{find(Polo_3DTuning_T(T_inx).stimType == 1)};
                TnR(pc).Tvesti_ResponSig = Polo_3DTuning_T(T_inx).responSig(find(Polo_3DTuning_T(T_inx).stimType == 1));
                
            else
                TnR(pc).Tvesti = nan;
                TnR(pc).Tvesti_ANOVA = nan;
                TnR(pc).Tvesti_DDI = nan;
                TnR(pc).Tvesti_ResponSig = nan;
                TnR(pc).Tvesti_PreDir = nan*ones(1,3);
            end
            if ~isempty(find(Polo_3DTuning_T(T_inx).stimType == 2))
                TnR(pc).Tvis = 1;
                TnR(pc).Tvis_DDI = Polo_3DTuning_T(T_inx).DDI(find(Polo_3DTuning_T(T_inx).stimType == 2));
                TnR(pc).Tvis_ANOVA = Polo_3DTuning_T(T_inx).ANOVA(find(Polo_3DTuning_T(T_inx).stimType == 2));
                TnR(pc).Tvis_PreDir = Polo_3DTuning_T(T_inx).preDir{find(Polo_3DTuning_T(T_inx).stimType == 2)};
                TnR(pc).Tvis_ResponSig = Polo_3DTuning_T(T_inx).responSig(find(Polo_3DTuning_T(T_inx).stimType == 2));
            else
                TnR(pc).Tvis = nan;
                TnR(pc).Tvis_ANOVA = nan;
                TnR(pc).Tvis_DDI = nan;
                TnR(pc).Tvis_ResponSig = nan;
                TnR(pc).Tvis_PreDir = nan*ones(1,3);
            end
            if ~isempty(find(Polo_3DTuning_R(R_inx).stimType == 1))
                TnR(pc).Rvesti = 1;
                TnR(pc).Rvesti_DDI = Polo_3DTuning_R(R_inx).DDI(find(Polo_3DTuning_R(R_inx).stimType == 1));
                TnR(pc).Rvesti_ANOVA = Polo_3DTuning_R(R_inx).ANOVA(find(Polo_3DTuning_R(R_inx).stimType == 1));
                TnR(pc).Rvesti_PreDir = Polo_3DTuning_R(R_inx).preDir{find(Polo_3DTuning_R(R_inx).stimType == 1)};
                TnR(pc).Rvesti_ResponSig = Polo_3DTuning_R(R_inx).responSig(find(Polo_3DTuning_R(R_inx).stimType == 1));
            else
                TnR(pc).Rvesti = nan;
                TnR(pc).Rvesti_ANOVA = nan;
                TnR(pc).Rvesti_DDI = nan;
                TnR(pc).Rvesti_ResponSig = nan;
                TnR(pc).Rvesti_PreDir = nan*ones(1,3);
            end
            if ~isempty(find(Polo_3DTuning_R(R_inx).stimType == 2))
                TnR(pc).Rvis = 1;
                TnR(pc).Rvis_DDI = Polo_3DTuning_R(R_inx).DDI(find(Polo_3DTuning_R(R_inx).stimType == 2));
                TnR(pc).Rvis_ANOVA = Polo_3DTuning_R(R_inx).ANOVA(find(Polo_3DTuning_R(R_inx).stimType == 2));
                TnR(pc).Rvis_PreDir = Polo_3DTuning_R(R_inx).preDir{find(Polo_3DTuning_R(R_inx).stimType == 2)};
                TnR(pc).Rvis_ResponSig = Polo_3DTuning_R(R_inx).responSig(find(Polo_3DTuning_R(R_inx).stimType == 2));
            else
                TnR(pc).Rvis = nan;
                TnR(pc).Rvis_ANOVA = nan;
                TnR(pc).Rvis_DDI = nan;
                TnR(pc).Rvis_ResponSig = nan;
                TnR(pc).Rvis_PreDir = nan*ones(1,3);
            end
        end
    end
    
end


%% Analysis

%%%%%%%%%%%%%%%%%%%%%%%%%   classify cells   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pack data
T_vestiANOVA = cat(1,TnR.Tvesti_ANOVA);
T_visANOVA = cat(1,TnR.Tvis_ANOVA);
T_vestiDDI = cat(1,TnR.Tvesti_DDI);
T_visDDI = cat(1,TnR.Tvis_DDI);
T_vestiResponSig = cat(1,TnR.Tvesti_ResponSig);
T_visResponSig = cat(1,TnR.Tvis_ResponSig);
T_vestiPreDir = reshape(cat(2,TnR.Tvesti_PreDir),3,[])';
T_visPreDir = reshape(cat(2,TnR.Tvis_PreDir),3,[])';

R_vestiANOVA = cat(1,TnR.Rvesti_ANOVA);
R_visANOVA = cat(1,TnR.Rvis_ANOVA);
R_vestiDDI = cat(1,TnR.Rvesti_DDI);
R_visDDI = cat(1,TnR.Rvis_DDI);
R_vestiResponSig = cat(1,TnR.Rvesti_ResponSig);
R_visResponSig = cat(1,TnR.Rvis_ResponSig);
R_vestiPreDir = reshape(cat(2,TnR.Rvesti_PreDir),3,[])';
R_visPreDir = reshape(cat(2,TnR.Rvis_PreDir),3,[])';

% cells classified according to temporal response
ResponSigboth_vesti = logical(T_vestiResponSig==1)&logical(R_vestiResponSig==1);
ResponSigboth_vis = logical(T_visResponSig==1)&logical(R_visResponSig==1);

% cells classified according to ANOVA
ANOVASigboth_vesti = logical(T_vestiANOVA<0.05)&logical(R_vestiANOVA<0.05);
ANOVASigboth_vis = logical(T_visANOVA<0.05)&logical(R_visANOVA<0.05);

%%%%%%% pack preferred direction data, according to p value (ANOVA) %%%%%%%
% DDI
T_DDISig_vesti = T_vestiDDI(ResponSigboth_vesti &ANOVASigboth_vesti);
T_DDISig_vis = T_visDDI(ResponSigboth_vis &ANOVASigboth_vis);
R_DDISig_vesti = R_vestiDDI(ResponSigboth_vesti &ANOVASigboth_vesti);
R_DDISig_vis = R_visDDI(ResponSigboth_vis &ANOVASigboth_vis);
T_DDInSig_vesti = T_vestiDDI(~ANOVASigboth_vesti &ResponSigboth_vesti );
T_DDInSig_vis = T_visDDI(~ANOVASigboth_vis &ResponSigboth_vis );
R_DDInSig_vesti = R_vestiDDI(~ANOVASigboth_vesti &ResponSigboth_vesti );
R_DDInSig_vis = R_visDDI(~ANOVASigboth_vis &ResponSigboth_vis );

% preferred direction 

T_PreDirSig_vesti = T_vestiPreDir(ResponSigboth_vesti &ANOVASigboth_vesti,:);
T_PreDirSig_vis = T_visPreDir(ResponSigboth_vis &ANOVASigboth_vis,:);
R_PreDirSig_vesti = R_vestiPreDir(ResponSigboth_vesti &ANOVASigboth_vesti,:);
R_PreDirSig_vis = R_visPreDir(ResponSigboth_vis &ANOVASigboth_vis,:);
T_PreDirnSig_vesti = T_vestiPreDir(~ANOVASigboth_vesti &ResponSigboth_vesti ,:);
T_PreDirnSig_vis = T_visPreDir(~ANOVASigboth_vis &ResponSigboth_vis ,:);
R_PreDirnSig_vesti = R_vestiPreDir(~ANOVASigboth_vesti &ResponSigboth_vesti ,:);
R_PreDirnSig_vis = R_visPreDir(~ANOVASigboth_vis &ResponSigboth_vis ,:);


% delta preferred direction
PreDirSig_diff_vesti = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirSig_vesti,ones(1,length(T_PreDirSig_vesti)),3),mat2cell(R_PreDirSig_vesti,ones(1,length(R_PreDirSig_vesti)),3));
PreDirSig_diff_vis = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirSig_vis,ones(1,length(T_PreDirSig_vis)),3),mat2cell(R_PreDirSig_vis,ones(1,length(R_PreDirSig_vis)),3));
PreDirnSig_diff_vesti = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirnSig_vesti,ones(1,length(T_PreDirnSig_vesti)),3),mat2cell(R_PreDirnSig_vesti,ones(1,length(R_PreDirnSig_vesti)),3));
PreDirnSig_diff_vis = cellfun(@(x,y) angleDiff(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirnSig_vis,ones(1,length(T_PreDirnSig_vis)),3),mat2cell(R_PreDirnSig_vis,ones(1,length(R_PreDirnSig_vis)),3));

PreDirSig_diff_vesti_median = nanmedian(PreDirSig_diff_vesti);
PreDirSig_diff_vis_median = nanmedian(PreDirSig_diff_vis);

% delta preferred direction in 3 planes
[PreDirSig_diff_vesti_xy,PreDirSig_diff_vesti_xz,PreDirSig_diff_vesti_yz] = cellfun(@(x,y) angleDiff_2D(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirSig_vesti,ones(1,length(T_PreDirSig_vesti)),3),mat2cell(R_PreDirSig_vesti,ones(1,length(R_PreDirSig_vesti)),3));
[PreDirSig_diff_vis_xy,PreDirSig_diff_vis_xz,PreDirSig_diff_vis_yz ]= cellfun(@(x,y) angleDiff_2D(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirSig_vis,ones(1,length(T_PreDirSig_vis)),3),mat2cell(R_PreDirSig_vis,ones(1,length(R_PreDirSig_vis)),3));
[PreDirnSig_diff_vesti_xy,PreDirnSig_diff_vesti_xz,PreDirnSig_diff_vesti_yz]= cellfun(@(x,y) angleDiff_2D(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirnSig_vesti,ones(1,length(T_PreDirnSig_vesti)),3),mat2cell(R_PreDirnSig_vesti,ones(1,length(R_PreDirnSig_vesti)),3));
[PreDirnSig_diff_vis_xy,PreDirnSig_diff_vis_xz,PreDirnSig_diff_vis_yz]= cellfun(@(x,y) angleDiff_2D(x(1),x(2),x(3),y(1),y(2),y(3)),mat2cell(T_PreDirnSig_vis,ones(1,length(T_PreDirnSig_vis)),3),mat2cell(R_PreDirnSig_vis,ones(1,length(R_PreDirnSig_vis)),3));

%%%%%%%%%%%%%%%%%%%%% DDI - Translation vs. Rotation %%%%%%%%%%%%%%%%%%%%%%

TotalNoVest = nansum(cat(1,TnR.Tvesti) == 1 & cat(1,TnR.Rvesti) == 1);
TotalNoVis = nansum(cat(1,TnR.Tvis) == 1 & cat(1,TnR.Rvis) == 1);
TResponVest = nansum(cat(1,TnR.Tvesti_ResponSig));
RResponVest = nansum(cat(1,TnR.Rvesti_ResponSig));
ResponVestBoth = nansum(cat(1,TnR.Tvesti_ResponSig) == 1 &cat(1,TnR.Rvesti_ResponSig) == 1);
TResponVis = nansum(cat(1,TnR.Tvis_ResponSig));
RResponVis = nansum(cat(1,TnR.Rvis_ResponSig));
ResponVisBoth = nansum(cat(1,TnR.Tvis_ResponSig) == 1 &cat(1,TnR.Rvis_ResponSig) == 1);

sprintf('\n Monkey %s :\n\n Total cells recorded for both Translation & Rotation:\n [ Vestibular %d ]  [ Visual %d ]',Monkey,TotalNoVest,TotalNoVis)
Temporal_Tuning = sprintf('Vestibular:\n [ Translation: %d ] [ Rotation: %d ] [ Both: %d ] \n Visual:\n [ Translation: %d ] [ Rotation: %d ] [ Both: %d ] ',TResponVest,RResponVest,ResponVestBoth,TResponVis,RResponVis,ResponVisBoth);
Temporal_Tuning

%%%%%%%%%%%%%%%%%%%%%%%%%%   now, plot figures   %%%%%%%%%%%%%%%%%%%%%%%%%%

colorDefsLBY;

%%%%%%%%%%%%%%%%%%%%% DDI - Translation vs. Rotation %%%%%%%%%%%%%%%%%%%%%%



xDDI = 0.05:0.1:0.85;

figure(201);set(gcf,'pos',[60 70 1700 800]);clf;
[~,h_subplot] = tight_subplot(2,4,0.11,0.2);

axes(h_subplot(1));
text(1,-0.05,'Vestibular','Fontsize',30,'rotation',90);
text(1.3,-0.8,'Rotation, DDI','Fontsize',25,'rotation',90);
axis off;
axes(h_subplot(5));
text(1,0.1,'Visual','Fontsize',30,'rotation',90);
axis off;

% vestibular
axes(h_subplot(2));
hold on;
plot(T_DDISig_vesti,R_DDISig_vesti,'ko','markersize',8,'markerfacecolor',colorDBlue);
plot(T_DDInSig_vesti,R_DDInSig_vesti,'ko','markersize',8,'markerfacecolor','w');
plot([0 0.85],[0 0.85],'--','color',colorLGray);
text(0.1,0.8,['n = ',num2str(sum(ResponSigboth_vesti))]);
[p,h] = ranksum(T_DDISig_vesti,R_DDISig_vesti)
[h,p] = ttest(T_DDISig_vesti,R_DDISig_vesti)
axis on;
hold off;

% visual
axes(h_subplot(6));
hold on;
plot(T_DDISig_vis,R_DDISig_vis,'ko','markersize',8,'markerfacecolor',colorDRed);
plot(T_DDInSig_vis,R_DDInSig_vis,'ko','markersize',8,'markerfacecolor','w');
plot([0 0.85],[0 0.85],'--','color',colorLGray);
text(0.1,0.8,['n = ',num2str(sum(ResponSigboth_vis))]);
[p,h] = ranksum(T_DDISig_vis,R_DDISig_vis)
[h,p] = ttest(T_DDISig_vis,R_DDISig_vis)
xlabel('Translation, DDI');
axis on;
hold off;

%%%%%%%%% Delta preferred direction - Translation vs. Rotation %%%%%%%%%%%%

xdiffPreDir = 9:18:(180-9);

% Vestibular
axes(h_subplot(3));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vesti,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vesti;PreDirnSig_diff_vesti],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vesti))]);
plot(PreDirSig_diff_vesti_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(PreDirSig_diff_vesti_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vesti_median));
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[-15 195]);
axis on;
hold off;

% Vis
axes(h_subplot(7));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vis,xdiffPreDir);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vis;PreDirnSig_diff_vis],xdiffPreDir);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vis))]);
plot(PreDirSig_diff_vis_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
text(PreDirSig_diff_vis_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vis_median));
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'},'xlim',[-15 195]);
xlabel('\Delta preferred direction');
axis on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% text figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes();
hold on;xlim([0 1]);ylim([0 1]);
text(0.49,0.3,'Cell numbers','Fontsize',25,'rotation',90);
% text(0.8,0.1,'Fixation (Rmax - Rmin)','Fontsize',25,'rotation',90);
axis off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% save figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
suptitle('Translation vs. Rotation');
SetFigure(15);
set(gcf,'paperpositionmode','auto');
% saveas(201,'Z:\LBY\Population Results\TnR','emf');

%%%%%%%%%%%%%%%%%% DDI - Translation vs. Rotation (2D) %%%%%%%%%%%%%%%%%%%%

xdiffPreDir_2D = linspace(-180,180,10);

figure(202);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(3,3,0.11,0.2);

axes(h_subplot(1));

% Vestibular
axes(h_subplot(2));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vesti_xy,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vesti_xy;PreDirnSig_diff_vesti_xy],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vesti))]);
% plot(PreDirSig_diff_vesti_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vesti_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vesti_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

axes(h_subplot(5));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vesti_xz,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vesti_xz;PreDirnSig_diff_vesti_xz],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vesti))]);
% plot(PreDirSig_diff_vesti_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vesti_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vesti_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

axes(h_subplot(8));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vesti_yz,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vesti_yz;PreDirnSig_diff_vesti_yz],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDBlue);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vesti))]);
% plot(PreDirSig_diff_vesti_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vesti_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vesti_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

% Vis
axes(h_subplot(3));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vis_xy,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vis_xy;PreDirnSig_diff_vis_xy],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vis))]);
% plot(PreDirSig_diff_vis_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vis_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vis_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

axes(h_subplot(6));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vis_xz,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vis_xz;PreDirnSig_diff_vis_xz],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vis))]);
% plot(PreDirSig_diff_vis_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vis_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vis_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

axes(h_subplot(9));
hold on;
[nelements_sig, ncenters_sig] = hist(PreDirSig_diff_vis_yz,xdiffPreDir_2D);
[nelements_nsig, ncenters_nsig] = hist([PreDirSig_diff_vis_yz;PreDirnSig_diff_vis_yz],xdiffPreDir_2D);
h1 = bar(ncenters_nsig, nelements_nsig, 0.8,'w','edgecolor',colorDRed);
h2 = bar(ncenters_sig, nelements_sig, 0.8,'facecolor',colorDRed,'edgecolor',colorDRed);
set(h1,'linewidth',1.5);
text(170,max(max(nelements_sig),max(nelements_nsig)),['n = ',num2str(sum(ResponSigboth_vis))]);
% plot(PreDirSig_diff_vis_median,max(max(nelements_sig),max(nelements_nsig))*1.1,'kv');
% text(PreDirSig_diff_vis_median*1.1,max(max(nelements_sig),max(nelements_nsig))*1.2,num2str(PreDirSig_diff_vis_median));
set(gca,'xtick',[-180 -90 0 90 180],'xticklabel',{'-180','-90','0','90','180'},'xlim',[-230 230]);
axis on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% save figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
suptitle('Translation vs. Rotation AngleDiff2D');
SetFigure(15);
set(gcf,'paperpositionmode','auto');
saveas(202,'Z:\LBY\Population Results\TnR_angleDiff2D','emf');


