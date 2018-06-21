% Analysis for location-related
% depth: depth
% LocX: Medial-lateral
% LocY: Anterior-posterior
% 暂时手动导入以上数据
% LBY 20171214


load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\LocationInfo.mat');

% pack DDI data, according to p value (ANOVA)
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

% DDI vs depth
T_vestiDepthSig = T_depth(TResponSigVesti &TANOVASigVesti);
T_visDepthSig = T_depth(TResponSigVis &TANOVASigVis);
T_vestiDepthnSig = T_depth(~TANOVASigVesti &TResponSigVesti);
T_visDepthnSig = T_depth(~TANOVASigVis &TResponSigVis);

R_vestiDepthSig = R_depth(RResponSigVesti &RANOVASigVesti);
R_visDepthSig = R_depth(RResponSigVis &RANOVASigVis);
R_vestiDepthnSig = R_depth(~RANOVASigVesti &RResponSigVesti);
R_visDepthnSig = R_depth(~RANOVASigVis &RResponSigVis);

% DDI vs location
T_vestiLocXSig = T_locX(TResponSigVesti &TANOVASigVesti);
T_visLocXSig = T_locX(TResponSigVis &TANOVASigVis);
T_vestiLocXnSig = T_locX(~TANOVASigVesti &TResponSigVesti);
T_visLocXnSig = T_locX(~TANOVASigVis &TResponSigVis);

T_vestiLocYSig = T_locY(TResponSigVesti &TANOVASigVesti);
T_visLocYSig = T_locY(TResponSigVis &TANOVASigVis);
T_vestiLocYnSig = T_locY(~TANOVASigVesti &TResponSigVesti);
T_visLocYnSig = T_locY(~TANOVASigVis &TResponSigVis);

R_vestiLocXSig = R_locX(RResponSigVesti &RANOVASigVesti);
R_visLocXSig = R_locX(RResponSigVis &RANOVASigVis);
R_vestiLocXnSig = R_locX(~RANOVASigVesti &RResponSigVesti);
R_visLocXnSig = R_locX(~RANOVASigVis &RResponSigVis);

R_vestiLocYSig = R_locY(RResponSigVesti &RANOVASigVesti);
R_visLocYSig = R_locY(RResponSigVis &RANOVASigVis);
R_vestiLocYnSig = R_locY(~RANOVASigVesti &RResponSigVesti);
R_visLocYnSig = R_locY(~RANOVASigVis &RResponSigVis);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DDI vs. depth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(101);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,[0.2 0.02],0.15);

axes(h_subplot(2));
hold on;
axis square;axis on;
T_p_vesti_Depth = polyfit(T_vestiDepthSig, T_vestiDDISig, 1);
plot(T_vestiDepthSig, polyval(T_p_vesti_Depth, T_vestiDepthSig),'color',colorDBlue,'linewidth',3);
plot(T_vestiDepthnSig,T_vestiDDInSig,'ko','markerfacecolor','w');
% plot(T_vestiDepthSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue,'markeredgecolor',colorDBlue);
plot(T_vestiDepthSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue);

[T_r_vesti_Depth,T_pp_vesti_Depth] =corrcoef(T_vestiDepthSig,T_vestiDDISig);

title(sprintf('r = %g \np = %g',T_r_vesti_Depth(1,2),T_pp_vesti_Depth(1,2)));

axes(h_subplot(3));
hold on;
axis square;axis on;
T_p_vis_Depth = polyfit(T_visDepthSig, T_visDDISig, 1);
plot(T_visDepthSig, polyval(T_p_vis_Depth, T_visDepthSig),'color',colorDRed,'linewidth',3);
plot(T_visDepthnSig,T_visDDInSig,'ko','markerfacecolor','w');
% plot(T_visDepthSig,T_visDDISig,'ko','markerfacecolor',colorDRed,'markeredgecolor',colorDRed);
plot(T_visDepthSig,T_visDDISig,'ko','markerfacecolor',colorDRed);

[T_r_vis_Depth,T_pp_vis_Depth] =corrcoef(T_visDepthSig,T_visDDISig);

title(sprintf('r = %g \np = %g',T_r_vis_Depth(1,2),T_pp_vis_Depth(1,2)));

axes(h_subplot(5));
hold on;
axis square;axis on;
R_p_vesti = polyfit(R_vestiDepthSig, R_vestiDDISig, 1);
plot(R_vestiDepthSig, polyval(R_p_vesti, R_vestiDepthSig),'color',colorLBlue,'linewidth',3);
plot(R_vestiDepthnSig,R_vestiDDInSig,'ko','markerfacecolor','w');
% plot(R_vestiDepthSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue,'markeredgecolor',colorLBlue);
plot(R_vestiDepthSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue);

[R_r_vesti_Depth, R_pp_vesti_Depth]=corrcoef(R_vestiDepthSig,R_vestiDDISig);

title(sprintf('r = %g \np = %g',R_r_vesti_Depth(1,2),R_pp_vesti_Depth(1,2)));

axes(h_subplot(6));
hold on;
axis square;axis on;
R_p_vis = polyfit(R_visDepthSig, R_visDDISig, 1);
plot(R_visDepthSig, polyval(R_p_vis, R_visDepthSig),'color',colorLRed,'linewidth',3);
plot(R_visDepthnSig,R_visDDInSig,'ko','markerfacecolor','w');
% plot(R_visDepthSig,R_visDDISig,'ko','markerfacecolor',colorLRed,'markeredgecolor',colorLRed);
plot(R_visDepthSig,R_visDDISig,'ko','markerfacecolor',colorLRed);

[R_r_vis_Depth, R_pp_vis_Depth] =corrcoef(R_visDepthSig,R_visDDISig);

title(sprintf('r = %g \np = %g',R_r_vis_Depth(1,2),R_pp_vis_Depth(1,2)));

SetFigure(15);

set(gcf,'paperpositionmode','auto');
saveas(101,'Z:\LBY\Population Results\DDI_Depth','emf');

%%%%%%%%%%%%%%%%%%%%%%%%% DDI vs. ML & AP location %%%%%%%%%%%%%%%%%%%%%%%%

figure(102);set(gcf,'pos',[60 70 1700 800]);clf;
[~,h_subplot] = tight_subplot(2,5,0.1,0.1);

axes(h_subplot(2));
hold on;
axis square;axis on;
T_p_vesti_LocX = polyfit(T_vestiLocXSig, T_vestiDDISig, 1);
plot(T_vestiLocXSig, polyval(T_p_vesti_LocX, T_vestiLocXSig),'color',colorDBlue,'linewidth',3);
plot(T_vestiLocXnSig,T_vestiDDInSig,'ko','markerfacecolor','w');
% plot(T_vestiLocXSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue,'markeredgecolor',colorDBlue);
plot(T_vestiLocXSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue);
[T_r_vesti_LocX, T_pp_vesti_LocX] =corrcoef(T_vestiLocXSig,T_vestiDDISig);

title(sprintf('r = %g \np = %g',T_r_vesti_LocX(1,2),T_pp_vesti_LocX(1,2)));

axes(h_subplot(4));
hold on;
axis square;axis on;
T_p_vesti_LocY = polyfit(T_vestiLocYSig, T_vestiDDISig, 1);
plot(T_vestiLocYSig, polyval(T_p_vesti_LocY, T_vestiLocYSig),'color',colorDBlue,'linewidth',3);
plot(T_vestiLocYnSig,T_vestiDDInSig,'ko','markerfacecolor','w');
% plot(T_vestiLocYSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue,'markeredgecolor',colorDBlue);
plot(T_vestiLocYSig,T_vestiDDISig,'ko','markerfacecolor',colorDBlue);
[T_r_vesti_LocY, T_pp_vesti_LocY] =corrcoef(T_vestiLocYSig,T_vestiDDISig);

title(sprintf('r = %g \np = %g',T_r_vesti_LocY(1,2),T_pp_vesti_LocY(1,2)));

axes(h_subplot(3));
hold on;
axis square;axis on;
T_p_vis_LocX = polyfit(T_visLocXSig, T_visDDISig, 1);
plot(T_visLocXSig, polyval(T_p_vis_LocX, T_visLocXSig),'color',colorDRed,'linewidth',3);
plot(T_visLocXnSig,T_visDDInSig,'ko','markerfacecolor','w');
% plot(T_visLocXSig,T_visDDISig,'ko','markerfacecolor',colorDRed,'markeredgecolor',colorDRed);
plot(T_visLocXSig,T_visDDISig,'ko','markerfacecolor',colorDRed);

[T_r_vis_LocX, T_pp_vis_LocX] =corrcoef(T_visLocXSig,T_visDDISig);

title(sprintf('r = %g \np = %g',T_r_vis_LocX(1,2),T_pp_vis_LocX(1,2)));


axes(h_subplot(5));
hold on;
axis square;axis on;
T_p_vis_LocY = polyfit(T_visLocYSig, T_visDDISig, 1);
plot(T_visLocYSig, polyval(T_p_vis_LocY, T_visLocYSig),'color',colorDRed,'linewidth',3);
plot(T_visLocYnSig,T_visDDInSig,'ko','markerfacecolor','w');
% plot(T_visLocYSig,T_visDDISig,'ko','markerfacecolor',colorDRed,'markeredgecolor',colorDRed);
plot(T_visLocYSig,T_visDDISig,'ko','markerfacecolor',colorDRed);

[T_r_vis_LocY, T_pp_vis_LocY] =corrcoef(T_visLocYSig,T_visDDISig);

title(sprintf('r = %g \np = %g',T_r_vis_LocY(1,2),T_pp_vis_LocY(1,2)));

axes(h_subplot(7));
hold on;
axis square;axis on;
R_p_vesti_LocX = polyfit(R_vestiLocXSig, R_vestiDDISig, 1);
plot(R_vestiLocXSig, polyval(R_p_vesti_LocX, R_vestiLocXSig),'color',colorLBlue,'linewidth',3);
plot(R_vestiLocXnSig,R_vestiDDInSig,'ko','markerfacecolor','w');
% plot(R_vestiLocXSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue,'markeredgecolor',colorLBlue);
plot(R_vestiLocXSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue);

[R_r_vesti_LocX, R_pp_vesti_LocX] =corrcoef(R_vestiLocXSig,R_vestiDDISig);

title(sprintf('r = %g \np = %g',R_r_vesti_LocX(1,2),R_pp_vesti_LocX(1,2)));

axes(h_subplot(9));
hold on;
axis square;axis on;
R_p_vesti_LocY = polyfit(R_vestiLocYSig, R_vestiDDISig, 1);
plot(R_vestiLocYSig, polyval(R_p_vesti_LocY, R_vestiLocYSig),'color',colorLBlue,'linewidth',3);
plot(R_vestiLocYnSig,R_vestiDDInSig,'ko','markerfacecolor','w');
% plot(R_vestiLocYSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue,'markeredgecolor',colorLBlue);
plot(R_vestiLocYSig,R_vestiDDISig,'ko','markerfacecolor',colorLBlue);
[R_r_vesti_LocY, R_pp_vesti_LocY] =corrcoef(R_vestiLocYSig,R_vestiDDISig);

title(sprintf('r = %g \np = %g',R_r_vesti_LocY(1,2),R_pp_vesti_LocY(1,2)));

axes(h_subplot(8));
hold on;
axis square;axis on;
R_p_vis_LocX = polyfit(R_visLocXSig, R_visDDISig, 1);
plot(R_visLocXSig, polyval(R_p_vis_LocX, R_visLocXSig),'color',colorLRed,'linewidth',3);
plot(R_visLocXnSig,R_visDDInSig,'ko','markerfacecolor','w');
% plot(R_visLocXSig,R_visDDISig,'ko','markerfacecolor',colorLRed,'markeredgecolor',colorLRed);
plot(R_visLocXSig,R_visDDISig,'ko','markerfacecolor',colorLRed);

[R_r_vis_LocX, R_pp_vis_LocX] =corrcoef(R_visLocXSig,R_visDDISig);

title(sprintf('r = %g \np = %g',R_r_vis_LocX(1,2),R_pp_vis_LocX(1,2)));

axes(h_subplot(10));
hold on;
axis square;axis on;
R_p_vis_LocY = polyfit(R_visLocYSig, R_visDDISig, 1);
plot(R_visLocYSig, polyval(R_p_vis_LocY, R_visLocYSig),'color',colorLRed,'linewidth',3);

plot(R_visLocYnSig,R_visDDInSig,'ko','markerfacecolor','w');
% plot(R_visLocYSig,R_visDDISig,'ko','markerfacecolor',colorLRed,'markeredgecolor',colorLRed);
plot(R_visLocYSig,R_visDDISig,'ko','markerfacecolor',colorLRed);

[R_r_vis_LocY, R_pp_vis_LocY] =corrcoef(R_visLocYSig,R_visDDISig);

title(sprintf('r = %g \np = %g',R_r_vis_LocY(1,2),R_pp_vis_LocY(1,2)));


SetFigure(15);

set(gcf,'paperpositionmode','auto');
saveas(102,'Z:\LBY\Population Results\DDI_Location','emf');





