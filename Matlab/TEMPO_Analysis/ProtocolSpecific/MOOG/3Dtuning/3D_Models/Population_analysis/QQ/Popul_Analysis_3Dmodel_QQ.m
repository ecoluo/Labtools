% Population analysis for 3D model
% 101# Best model fit distribution according to BIC
% 102# R_squared distribution of each model
% 103# Partial R_squared distribution
% LBY 20171205

%% load data & pack data
clear all;
Model_catg = 2;
switch Model_catg
    case 1
        cd('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Sync model');
        load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Sync model\PSTH3DModel_T_OriData.mat');
        load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Sync model\PSTH3DModel_R_OriData.mat');
    case 2
        cd('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Out-sync model');
        load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Out-sync model\PSTH3DModel_T_OriData.mat');
        load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Out-sync model\PSTH3DModel_R_OriData.mat');
end

Monkey = 'QQ';
% models = {'VO','AO','VA','VJ','AJ','VAJ'};
% models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
models = {'VA','VAJ'};
%% analysis

colorDefsLBY;
T_vestiSig = cat(1,T_model.vestiSig);
T_visSig = cat(1,T_model.visSig);
R_vestiSig = cat(1,R_model.vestiSig);
R_visSig = cat(1,R_model.visSig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% basic infos.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');
disp([Monkey,':']);
disp('Total cells for Translation 3D model: ');
disp(['[ vestibular: ',num2str(T_vestiNo),' ]   [  visual: ',num2str(T_visNo),' ]']);
disp('Total cells for Rotation 3D model: ');
disp(['[ vestibular: ',num2str(R_vestiNo),' ]   [  visual: ',num2str(R_visNo),' ]']);

%%%%%%%%%%%%%%%%%%%% Best model fit according to BIC %%%%%%%%%%%%%%%%%%%%%%

[~,T_BIC_min_inx_vesti] = min(squeeze(cell2mat(struct2cell(T_BIC_vesti))));
[~,T_BIC_min_inx_vis] = min(squeeze(cell2mat(struct2cell(T_BIC_vis))));
[~,R_BIC_min_inx_vesti] = min(squeeze(cell2mat(struct2cell(R_BIC_vesti))));
[~,R_BIC_min_inx_vis] = min(squeeze(cell2mat(struct2cell(R_BIC_vis))));

T_BIC_min_inx_vesti(T_vestiSig==0) = nan;T_BIC_min_inx_vesti(isnan(T_BIC_min_inx_vesti)) = [];
T_BIC_min_inx_vis(T_visSig==0) = nan;T_BIC_min_inx_vis(isnan(T_BIC_min_inx_vis)) = [];
R_BIC_min_inx_vesti(R_vestiSig==0) = nan;R_BIC_min_inx_vesti(isnan(R_BIC_min_inx_vesti)) = [];
R_BIC_min_inx_vis(R_visSig==0) = nan;R_BIC_min_inx_vis(isnan(R_BIC_min_inx_vis)) = [];

T_BIC_min_vesti_hist = hist(T_BIC_min_inx_vesti,1:length(models));
T_BIC_min_vis_hist = hist(T_BIC_min_inx_vis,1:length(models));
R_BIC_min_vesti_hist = hist(R_BIC_min_inx_vesti,1:length(models));
R_BIC_min_vis_hist = hist(R_BIC_min_inx_vis,1:length(models));

RSquared_T_vesti = squeeze(cell2mat(struct2cell(T_Rsquared_vesti)))';
RSquared_T_vis = squeeze(cell2mat(struct2cell(T_Rsquared_vis)))';
RSquared_R_vesti = squeeze(cell2mat(struct2cell(R_Rsquared_vesti)))';
RSquared_R_vis = squeeze(cell2mat(struct2cell(R_Rsquared_vis)))';

RSquared_T_vesti(T_vestiSig==0) = nan;
RSquared_T_vis(T_vestiSig==0) = nan;
RSquared_R_vesti(R_vestiSig==0) = nan;
RSquared_R_vis(R_vestiSig==0) = nan;

T_vestiPreDir_V = reshape(cat(2,T_preDir_VA_vesti.V),3,[])';
T_visPreDir_V = reshape(cat(2,T_preDir_VA_vis.V),3,[])';
R_vestiPreDir_V = reshape(cat(2,R_preDir_VA_vesti.V),3,[])';
R_visPreDir_V = reshape(cat(2,R_preDir_VA_vis.V),3,[])';
T_vestiPreDir_A = reshape(cat(2,T_preDir_VA_vesti.A),3,[])';
T_visPreDir_A = reshape(cat(2,T_preDir_VA_vis.A),3,[])';
R_vestiPreDir_A = reshape(cat(2,R_preDir_VA_vesti.A),3,[])';
R_visPreDir_A = reshape(cat(2,R_preDir_VA_vis.A),3,[])';

T_vesti_angleDiff = angleDiff(T_vestiPreDir_V(:,1),T_vestiPreDir_V(:,2),T_vestiPreDir_V(:,3),T_vestiPreDir_A(:,1),T_vestiPreDir_A(:,2),T_vestiPreDir_A(:,3));
T_vis_angleDiff = angleDiff(T_visPreDir_V(:,1),T_visPreDir_V(:,2),T_visPreDir_V(:,3),T_visPreDir_A(:,1),T_visPreDir_A(:,2),T_visPreDir_A(:,3));
R_vesti_angleDiff = angleDiff(R_vestiPreDir_V(:,1),R_vestiPreDir_V(:,2),R_vestiPreDir_V(:,3),R_vestiPreDir_A(:,1),R_vestiPreDir_A(:,2),R_vestiPreDir_A(:,3));
R_vis_angleDiff = angleDiff(R_visPreDir_V(:,1),R_visPreDir_V(:,2),R_visPreDir_V(:,3),R_visPreDir_A(:,1),R_visPreDir_A(:,2),R_visPreDir_A(:,3));

T_vesti_VA_w = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
T_vesti_VA_ratio = log(T_vesti_VA_w(:,1)./T_vesti_VA_w(:,2));
T_vesti_VA_ratio = T_vesti_VA_ratio(~isnan(T_vesti_VA_ratio));
T_vesti_VA_r2 = cat(1,T_Rsquared_vesti.VA);
T_vesti_VA_r2 = T_vesti_VA_r2(~isnan(T_vesti_VA_r2));
T_vis_VA_w = squeeze(cell2mat(struct2cell(T_wVA_vis)))';
T_vis_VA_ratio = log(T_vis_VA_w(:,1)./T_vis_VA_w(:,2));
T_vis_VA_ratio = T_vis_VA_ratio(~isnan(T_vis_VA_ratio));
T_vis_VA_r2 = cat(1,T_Rsquared_vis.VA);
T_vis_VA_r2 = T_vis_VA_r2(~isnan(T_vis_VA_r2));
R_vesti_VA_w = squeeze(cell2mat(struct2cell(R_wVA_vesti)))';
R_vesti_VA_ratio = log(R_vesti_VA_w(:,1)./R_vesti_VA_w(:,2));
R_vesti_VA_ratio = R_vesti_VA_ratio(~isnan(R_vesti_VA_ratio));
R_vesti_VA_r2 = cat(1,R_Rsquared_vesti.VA);
R_vesti_VA_r2 = R_vesti_VA_r2(~isnan(R_vesti_VA_r2));
R_vis_VA_w = squeeze(cell2mat(struct2cell(R_wVA_vis)))';
R_vis_VA_ratio = log(R_vis_VA_w(:,1)./R_vis_VA_w(:,2));
R_vis_VA_ratio = R_vis_VA_ratio(~isnan(R_vis_VA_ratio));
R_vis_VA_r2 = cat(1,R_Rsquared_vis.VA);
R_vis_VA_r2 = R_vis_VA_r2(~isnan(R_vis_VA_r2));


T_vesti_VAJ_w = squeeze(cell2mat(struct2cell(T_wVAJ_vesti)))';
T_vis_VAJ_w = squeeze(cell2mat(struct2cell(T_wVAJ_vis)))';
R_vesti_VAJ_w = squeeze(cell2mat(struct2cell(R_wVAJ_vesti)))';
R_vis_VAJ_w = squeeze(cell2mat(struct2cell(R_wVAJ_vis)))';

for ii = 1:size(T_vesti_VAJ_w,1)
    T_vesti_VAJ_wV_norm(ii) = T_vesti_VAJ_w(ii,1)/(T_vesti_VAJ_w(ii,1)+T_vesti_VAJ_w(ii,2));
    T_vesti_VAJ_wA_norm(ii) = T_vesti_VAJ_w(ii,2)/(T_vesti_VAJ_w(ii,1)+T_vesti_VAJ_w(ii,2));
    T_vis_VAJ_wV_norm(ii) = T_vis_VAJ_w(ii,1)/(T_vis_VAJ_w(ii,1)+T_vis_VAJ_w(ii,2));
    T_vis_VAJ_wA_norm(ii) = T_vis_VAJ_w(ii,2)/(T_vis_VAJ_w(ii,1)+T_vis_VAJ_w(ii,2));
end

for ii = 1:size(R_vesti_VAJ_w,1)
    R_vesti_VAJ_wV_norm(ii) = R_vesti_VAJ_w(ii,1)/(R_vesti_VAJ_w(ii,1)+R_vesti_VAJ_w(ii,2));
    R_vesti_VAJ_wA_norm(ii) = R_vesti_VAJ_w(ii,2)/(R_vesti_VAJ_w(ii,1)+R_vesti_VAJ_w(ii,2));
    R_vis_VAJ_wV_norm(ii) = R_vis_VAJ_w(ii,1)/(R_vis_VAJ_w(ii,1)+R_vis_VAJ_w(ii,2));
    R_vis_VAJ_wA_norm(ii) = R_vis_VAJ_w(ii,2)/(R_vis_VAJ_w(ii,1)+R_vis_VAJ_w(ii,2));
end


T_vesti_VA_n = squeeze(cell2mat(struct2cell(T_VA_n_vesti)));
T_vis_VA_n = squeeze(cell2mat(struct2cell(T_VA_n_vis)));
T_vesti_VAJ_n = squeeze(cell2mat(struct2cell(T_VAJ_n_vesti)));
T_vis_VAJ_n = squeeze(cell2mat(struct2cell(T_VAJ_n_vis)));
R_vesti_VA_n = squeeze(cell2mat(struct2cell(R_VA_n_vesti)));
R_vis_VA_n = squeeze(cell2mat(struct2cell(R_VA_n_vis)));
R_vesti_VAJ_n = squeeze(cell2mat(struct2cell(R_VAJ_n_vesti)));
R_vis_VAJ_n = squeeze(cell2mat(struct2cell(R_VAJ_n_vis)));

%%%%%%% compare BIC value across different delay(V to A) (VA model) %%%%%%%
%{
% [~,inx] = ismember('VA',models);
% BIC_vesti_VA_T = cat(1,T_BIC_vesti.VA);
% BIC_vis_VA_T = cat(1,T_BIC_vis.VA);
% BIC_vesti_VA_R = cat(1,R_BIC_vesti.VA);
% BIC_vis_VA_R = cat(1,R_BIC_vis.VA);
% 
% save('BIC_500.mat','BIC_vesti_VA_T','BIC_vis_VA_T','BIC_vesti_VA_R','BIC_vis_VA_R');

aa = {'BIC_100.mat','BIC_200.mat','BIC_300.mat','BIC_400.mat','BIC_500.mat'};

for ii = 1:5
    
load(aa{ii});

BIC_vesti_T_VA(:,ii) = BIC_vesti_VA_T;
BIC_vis_T_VA(:,ii) = BIC_vis_VA_T;
BIC_vesti_R_VA(:,ii) = BIC_vesti_VA_R;
BIC_vis_R_VA(:,ii) = BIC_vis_VA_R;

end

figure(99);set(gcf,'pos',[200 20 1300 950]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.2],0.15);

axes(h_subplot(1));hold on;
plot(BIC_vesti_T_VA','-','color',colorLGray,'linewidth',0.5);
plot(BIC_vesti_T_VA','ko','color',colorDBlue);
xlabel('time delay (V to A)');
ylabel('BIC');
set(gca,'box','off');
axis on;
xlim([1 5]);
ylim([-0.5 1]*10^4);
title('T-vestibular');

axes(h_subplot(2));hold on;
plot(BIC_vis_T_VA','-','color',colorLGray,'linewidth',0.5);
plot(BIC_vis_T_VA','ko','color',colorDRed);
xlabel('time delay (V to A)');
ylabel('BIC');
set(gca,'box','off');
axis on;
xlim([1 5]);
ylim([-0.5 1]*10^4);
title('T-visual');

axes(h_subplot(3));hold on;
plot(BIC_vesti_R_VA','-','color',colorLGray,'linewidth',0.5);
plot(BIC_vesti_R_VA','ko','color',colorLBlue);
xlabel('time delay (V to A)');
ylabel('BIC');
set(gca,'box','off');
axis on;
xlim([1 5]);
ylim([-0.5 1]*10^4);
title('R-vestibular');

axes(h_subplot(4));hold on;
plot(BIC_vis_R_VA','-','color',colorLGray,'linewidth',0.5);
plot(BIC_vis_R_VA','ko','color',colorLRed);
xlabel('time delay (V to A)');
ylabel('BIC');
set(gca,'box','off');
axis on;
xlim([1 5]);
ylim([-0.5 1]*10^4);
title('R-visual');

SetFigure(25);
%}




%%%%%%%%%%%%%%%%% BIC %%%%%%%%%%%%%%%%%%%
%{
figure(100);set(gcf,'pos',[300 200 1500 600]);clf;
BestFitModel = [T_BIC_min_vesti_hist;T_BIC_min_vis_hist;R_BIC_min_vesti_hist;R_BIC_min_vis_hist]';
h = bar(BestFitModel,'grouped');
xlabel('Models');ylabel('Cell Numbers (n)');
set(gca,'xticklabel',models);
set(h(1),'facecolor',colorDBlue,'edgecolor',colorDBlue);
set(h(2),'facecolor',colorDRed,'edgecolor',colorDRed);
set(h(3),'facecolor',colorLBlue,'edgecolor',colorLBlue);
set(h(4),'facecolor',colorLRed,'edgecolor',colorLRed);
title('Best model fit');
h_l = legend(['Translation (Vestibular), n = ',num2str(T_vestiNo)],['Translation (Visual), n = ',num2str(T_visNo)],['Rotation (Vestibular), n = ',num2str(R_vestiNo)],['Rotation (Visual), n = ',num2str(R_visNo)],'location','NorthWest');
set(h_l,'fontsize',15);
SetFigure(25);
set(gcf,'paperpositionmode','auto');
saveas(100,'Z:\LBY\Population Results\BestFitModel','emf');
%}
%%%%%%%%%%%%%%%%%  R_squared distribution of each model %%%%%%%%%%%%%%%%%%%
%{

% figures
figure(101);set(gcf,'pos',[60 70 1800 800]);clf;
[~,h_subplot] = tight_subplot(2,3,0.1,0.1);

axes(h_subplot(1));
text(0.9,-0.3,'R^2','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
plot(RSquared_T_vesti','-o','color',colorLGray,'markeredgecolor',colorDBlue);
axis on;
xlim([0.5 length(models)+0.5]);ylim([-0.5 1]);
set(gca,'xTick',1:length(models),'xticklabel',models);
title('Vestibular');

axes(h_subplot(3));
hold on;
plot(RSquared_T_vis','-o','color',colorLGray,'markeredgecolor',colorDRed);
axis on;
xlim([0.5 length(models)+0.5]);ylim([-0.5 1]);
set(gca,'xTick',1:length(models),'xticklabel',models);
title('Visual');

axes(h_subplot(5));
hold on;
plot(RSquared_R_vesti','-o','color',colorLGray,'markeredgecolor',colorLBlue);
axis on;
xlim([0.5 length(models)+0.5]);ylim([-0.5 1]);
set(gca,'xTick',1:length(models),'xticklabel',models);
xlabel('Models');

axes(h_subplot(6));
hold on;
plot(RSquared_R_vis','-o','color',colorLGray,'markeredgecolor',colorLRed);
axis on;
xlim([0.5 length(models)+0.5]);ylim([-0.5 1]);
set(gca,'xTick',1:length(models),'xticklabel',models);
xlabel('Models');


SetFigure(25);
set(gcf,'paperpositionmode','auto');
saveas(101,'Z:\LBY\Population Results\RSquared_Distribution','emf');

%}
%%%%%%%%%%%%%%%%%%%% Partial R_squared distribution  %%%%%%%%%%%%%%%%%%%%%%
%{

PartR2_T_vesti = squeeze(cell2mat(struct2cell(T_PartR2_VAT_vesti)))';
PartR2_T_vis = squeeze(cell2mat(struct2cell(T_PartR2_VAT_vis)))';
PartR2_R_vesti = squeeze(cell2mat(struct2cell(R_PartR2_VAT_vesti)))';
PartR2_R_vis = squeeze(cell2mat(struct2cell(R_PartR2_VAT_vis)))';

PartR2_T_vesti(T_vestiSig==0) = nan;
PartR2_T_vis(T_visSig==0) = nan;
PartR2_R_vesti(R_vestiSig==0) = nan;
PartR2_R_vis(R_visSig==0) = nan;

% figures
figure(102);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,0.1,0.15);

axes(h_subplot(1));
text(0.9,-0.3,'Partial R^2','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
plot(PartR2_T_vesti','-o','color',colorLGray,'markeredgecolor',colorDBlue);
axis on;
xlim([0.5 3.5]);ylim([-0.5 1]);
set(gca,'xTick',1:3,'xticklabel',{'V/AJ','A/VJ','J/VA'});
title('Vestibular');

axes(h_subplot(3));
hold on;
plot(PartR2_T_vis','-o','color',colorLGray,'markeredgecolor',colorDRed);
axis on;
xlim([0.5 3.5]);ylim([-0.5 1]);
set(gca,'xTick',1:3,'xticklabel',{'V/AJ','A/VJ','J/VA'});
title('Visual');

axes(h_subplot(5));
hold on;
plot(PartR2_R_vesti','-o','color',colorLGray,'markeredgecolor',colorLBlue);
axis on;
xlim([0.5 3.5]);ylim([-0.5 1]);
set(gca,'xTick',1:3,'xticklabel',{'V/AJ','A/VJ','J/VA'});
xlabel('Models');

axes(h_subplot(6));
hold on;
plot(PartR2_R_vis','-o','color',colorLGray,'markeredgecolor',colorLRed);
axis on;
xlim([0.5 3.5]);ylim([-0.5 1]);
set(gca,'xTick',1:3,'xticklabel',{'V/AJ','A/VJ','J/VA'});
xlabel('Models');

SetFigure(25);
set(gcf,'paperpositionmode','auto');
saveas(102,'Z:\LBY\Population Results\Partial_RSquared_Distribution','emf');
%}
%%%%%%%%%%%%%%%%%%%  R_squared distribution  %%%%%%%%%%%%%%%%%%%%%%
%{
xR2 = 0.05:0.1:0.75;

% figures
figure(103);set(gcf,'pos',[30 50 1800 300]);clf;
[~,h_subplot] = tight_subplot(1,length(models),0.05,0.2);

for ii = 1:length(models)
    
axes(h_subplot(ii));
hold on;
[nelements, ncenters] = hist(RSquared_T_vesti(:,ii),xR2);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiSPeakT_plot))]);
plot(nanmedian(RSquared_T_vesti(:,ii)),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(RSquared_T_vesti(:,ii))*1.1,max(nelements)*1.2,num2str(nanmedian(RSquared_T_vesti(:,ii))));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
title([models{ii},' model']);
axis on;
hold off;
          
end

suptitle('Translation - vestibular');
SetFigure(25);

figure(104);set(gcf,'pos',[30 400 1800 300]);clf;
[~,h_subplot] = tight_subplot(1,length(models),0.05,0.2);

for ii = 1:length(models)
    
axes(h_subplot(ii));
hold on;
[nelements, ncenters] = hist(RSquared_T_vis(:,ii),xR2);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visSPeakT_plot))]);
plot(nanmedian(RSquared_T_vis(:,ii)),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(RSquared_T_vis(:,ii))*1.1,max(nelements)*1.2,num2str(nanmedian(RSquared_T_vis(:,ii))));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
title([models{ii},' model']);
axis on;
hold off;
          
end

suptitle('Translation - visual');
SetFigure(25);


% figures
figure(106);set(gcf,'pos',[30 70 1800 300]);clf;
[~,h_subplot] = tight_subplot(1,length(models),0.05,0.2);

for ii = 1:length(models)
    
axes(h_subplot(ii));
hold on;
[nelements, ncenters] = hist(RSquared_R_vesti(:,ii),xR2);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiSPeakR_plot))]);
plot(nanmedian(RSquared_R_vesti(:,ii)),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(RSquared_R_vesti(:,ii))*1.1,max(nelements)*1.2,num2str(nanmedian(RSquared_R_vesti(:,ii))));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
title([models{ii},' model']);
axis on;
hold off;
          
end

suptitle('Rotation - vestibular');
SetFigure(25);

figure(105);set(gcf,'pos',[30 420 1800 300]);clf;
[~,h_subplot] = tight_subplot(1,length(models),0.05,0.2);

for ii = 1:length(models)
    
axes(h_subplot(ii));
hold on;
[nelements, ncenters] = hist(RSquared_R_vis(:,ii),xR2);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visSPeakR_plot))]);
plot(nanmedian(RSquared_R_vis(:,ii)),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(RSquared_R_vis(:,ii))*1.1,max(nelements)*1.2,num2str(nanmedian(RSquared_R_vis(:,ii))));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Single-peaked');
title([models{ii},' model']);
axis on;
hold off;
          
end

suptitle('Rotation - visual');
SetFigure(25);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Weight for VAJ model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
figure(105);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,[0.1 0.02],0.15);

axes(h_subplot(2));

%-- Plot the axis system
[h,hg,htick]=terplot(5);
%-- Plot the data ...
hter=ternaryc(T_vesti_VAJ_w(:,3),T_vesti_VAJ_w(:,1),T_vesti_VAJ_w(:,2));
%-- ... and modify the symbol:
set(hter,'marker','o','markerfacecolor',colorDBlue,'markersize',7,'markeredgecolor','w');
terlabel('wJ','wV','wA');
% view(180,-90);
title('T - vestibular');
% axis off;

axes(h_subplot(3));

%-- Plot the axis system
[h,hg,htick]=terplot(5);
%-- Plot the data ...
hter=ternaryc(T_vis_VAJ_w(:,3),T_vis_VAJ_w(:,1),T_vis_VAJ_w(:,2));
%-- ... and modify the symbol:
set(hter,'marker','o','markerfacecolor',colorDRed,'markersize',7,'markeredgecolor','w');
terlabel('wJ','wV','wA');

title('T - visual');
% axis off;

axes(h_subplot(5));
%-- Plot the axis system
[h,hg,htick]=terplot(5);
%-- Plot the data ...
hter=ternaryc(R_vesti_VAJ_w(:,3),R_vesti_VAJ_w(:,1),R_vesti_VAJ_w(:,2));
%-- ... and modify the symbol:
set(hter,'marker','o','markerfacecolor',colorLBlue,'markersize',7,'markeredgecolor','w');
terlabel('wJ','wV','wA');

title('R - vestibular');
% axis off;

axes(h_subplot(6));
%-- Plot the axis system
[h,hg,htick]=terplot(5);
%-- Plot the data ...
hter=ternaryc(R_vis_VAJ_w(:,3),R_vis_VAJ_w(:,1),R_vis_VAJ_w(:,2));
%-- ... and modify the symbol:
set(hter,'marker','o','markerfacecolor',colorLRed,'markersize',7,'markeredgecolor','w');
terlabel('wJ','wV','wA');

title('R - visual');
% axis off;

SetFigure(25);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% weight for VA model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
figure(106);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,[0.1 0.02],0.15);

axes(h_subplot(2));hold on;
T_vesti_w = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
plot(T_vesti_w(:,1),T_vesti_w(:,2),'o','markerfacecolor',colorDBlue,'markersize',7,'markeredgecolor','w');
xlabel('wV');ylabel('wA');
plot([0 1],[0.5 0.5],'--','color',colorLGray);
plot([0.5 0.5],[0 1],'--','color',colorLGray);
axis square;
% view(180,-90);
title('T - vestibular');
axis on;

axes(h_subplot(3));hold on;
T_vis_w = squeeze(cell2mat(struct2cell(T_wVA_vis)))';
plot(T_vis_w(:,1),T_vis_w(:,2),'o','markerfacecolor',colorDRed,'markersize',7,'markeredgecolor','w');
plot([0 1],[0.5 0.5],'--','color',colorLGray);
plot([0.5 0.5],[0 1],'--','color',colorLGray);
xlabel('wV');ylabel('wA');
axis square;
% view(180,-90);
title('T - visual');
axis on;

axes(h_subplot(5));hold on;
R_vesti_w = squeeze(cell2mat(struct2cell(R_wVA_vesti)))';
plot(R_vesti_w(:,1),R_vesti_w(:,2),'o','markerfacecolor',colorLBlue,'markersize',7,'markeredgecolor','w');
xlabel('wV');ylabel('wA');
plot([0 1],[0.5 0.5],'--','color',colorLGray);
plot([0.5 0.5],[0 1],'--','color',colorLGray);
axis square;
% view(180,-90);
title('R - vestibular');
axis on;

axes(h_subplot(6));hold on;
R_vis_w = squeeze(cell2mat(struct2cell(R_wVA_vis)))';
plot(R_vis_w(:,1),R_vis_w(:,2),'o','markerfacecolor',colorLRed,'markersize',7,'markeredgecolor','w');
plot([0 1],[0.5 0.5],'--','color',colorLGray);
plot([0.5 0.5],[0 1],'--','color',colorLGray);
xlabel('wV');ylabel('wA');
axis square;
% view(180,-90);
title('R - visual');
axis on;

SetFigure(25);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% weight for VA model (ratio distribution) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
xRatio = -2:0.4:2;

figure(110);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.1],0.15);

axes(h_subplot(1));hold on;
T_vesti_w = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
T_vesti_ratio = log(T_vesti_w(:,1)./T_vesti_w(:,2));
[nelements, ncenters] = hist(T_vesti_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(nanmedian(T_vesti_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vesti_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vesti_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
[h,p_T_vesti] = ttest(T_vesti_ratio,0)
title('T-vestibular');
xlim([-2 2]);
% set(gca,'xscal','log');
axis on;
hold off;

axes(h_subplot(2));hold on;
T_vis_w = squeeze(cell2mat(struct2cell(T_wVA_vis)))';
T_vis_ratio = log(T_vis_w(:,1)./T_vis_w(:,2));
[nelements, ncenters] = hist(T_vis_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(nanmedian(T_vis_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vis_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vis_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;
title('T-visual');
xlim([-2 2]);
[h,p_T_vis] = ttest(T_vis_ratio,0)

axes(h_subplot(3));hold on;
R_vesti_w = squeeze(cell2mat(struct2cell(R_wVA_vesti)))';
R_vesti_ratio = log(R_vesti_w(:,1)./R_vesti_w(:,2));
[nelements, ncenters] = hist(R_vesti_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakR_plot))]);
plot(nanmedian(R_vesti_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vesti_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vesti_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;
title('R-vestibular');
xlim([-2 2]);
[h,p_R_vesti] = ttest(R_vesti_ratio,0)

axes(h_subplot(4));hold on;
R_vis_w = squeeze(cell2mat(struct2cell(R_wVA_vis)))';
R_vis_ratio = log(R_vis_w(:,1)./R_vis_w(:,2));
[nelements, ncenters] = hist(R_vis_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakR_plot))]);
plot(nanmedian(R_vis_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vis_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vis_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;
title('R-visual');
xlim([-2 2]);
[h,p_R_vis] = ttest(R_vis_ratio,0)
suptitle('VA model');
SetFigure(25);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% weight(V&A, normalized) for VAJ model (ratio distribution) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
xRatio = -2:0.4:2;

figure(111);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.2],0.15);

axes(h_subplot(1));hold on;
T_vesti_ratio = log(T_vesti_VAJ_wV_norm./T_vesti_VAJ_wA_norm);
[nelements, ncenters] = hist(T_vesti_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(nanmedian(T_vesti_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vesti_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vesti_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
[h,p_T_vesti] = ttest(T_vesti_ratio,0)
title('T-vestibular');
xlim([-2 2]);
% set(gca,'xscal','log');
axis on;
hold off;

axes(h_subplot(2));hold on;
T_vis_ratio = log(T_vis_VAJ_wV_norm./T_vis_VAJ_wA_norm);
[nelements, ncenters] = hist(T_vis_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(nanmedian(T_vis_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vis_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vis_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;
title('T-visual');
xlim([-2 2]);
[h,p_T_vis] = ttest(T_vis_ratio,0)


axes(h_subplot(3));hold on;
R_vesti_ratio = log(R_vesti_VAJ_wV_norm./R_vesti_VAJ_wA_norm);
[nelements, ncenters] = hist(R_vesti_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakR_plot))]);
plot(nanmedian(R_vesti_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vesti_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vesti_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
[h,p_R_vesti] = ttest(R_vesti_ratio,0)
title('R-vestibular');
xlim([-2 2]);
% set(gca,'xscal','log');
axis on;
hold off;

axes(h_subplot(4));hold on;
R_vis_ratio = log(R_vis_VAJ_wV_norm./R_vis_VAJ_wA_norm);
[nelements, ncenters] = hist(R_vis_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakR_plot))]);
plot(nanmedian(R_vis_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vis_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vis_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
axis on;
hold off;
title('R-visual');
xlim([-2 2]);
[h,p_R_vis] = ttest(R_vis_ratio,0)
suptitle('VAJ model');

SetFigure(25);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% weight of (V&A, normalized) for VA model vs.VAJ model (ratio distribution) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

figure(112);set(gcf,'pos',[60 70 1000 800]);clf;
[~,h_subplot] = tight_subplot(2,2,0.2,0.15);

axes(h_subplot(1));hold on;
T_vesti_w_VA = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
T_vesti_ratio_VA = log(T_vesti_w_VA(:,1)./T_vesti_w_VA(:,2));
T_vesti_ratio_VAJ = log(T_vesti_VAJ_wV_norm./T_vesti_VAJ_wA_norm);
plot(T_vesti_ratio_VA,T_vesti_ratio_VAJ,'ko');
plot([-3,3],[-3 3],'--','color',colorLGray);
xlabel('VA model');
ylabel('VAJ model');
title('T-vestibular');
axis square;
xlim([-3 3]);
ylim([-3 3]);
axis on;
hold off;

axes(h_subplot(2));hold on;
T_vis_w_VA = squeeze(cell2mat(struct2cell(T_wVA_vis)))';
T_vis_ratio_VA = log(T_vis_w_VA(:,1)./T_vis_w_VA(:,2));
T_vis_ratio_VAJ = log(T_vis_VAJ_wV_norm./T_vis_VAJ_wA_norm);
plot(T_vis_ratio_VA,T_vis_ratio_VAJ,'ko');
plot([-3,3],[-3 3],'--','color',colorLGray);
xlabel('VA model');
ylabel('VAJ model');
title('T-visual');
axis square;
xlim([-3 3]);
ylim([-3 3]);
axis on;
hold off;

axes(h_subplot(3));hold on;
R_vesti_w_VA = squeeze(cell2mat(struct2cell(R_wVA_vesti)))';
R_vesti_ratio_VA = log(R_vesti_w_VA(:,1)./R_vesti_w_VA(:,2));
R_vesti_ratio_VAJ = log(R_vesti_VAJ_wV_norm./R_vesti_VAJ_wA_norm);
plot(R_vesti_ratio_VA,R_vesti_ratio_VAJ,'ko');
plot([-3,3],[-3 3],'--','color',colorLGray);
xlabel('VA model');
ylabel('VAJ model');
title('R-vestibular');
axis square;
xlim([-3 3]);
ylim([-3 3]);
axis on;
hold off;

axes(h_subplot(4));hold on;
R_vis_w_VA = squeeze(cell2mat(struct2cell(R_wVA_vis)))';
R_vis_ratio_VA = log(R_vis_w_VA(:,1)./R_vis_w_VA(:,2));
R_vis_ratio_VAJ = log(R_vis_VAJ_wV_norm./R_vis_VAJ_wA_norm);
plot(R_vis_ratio_VA,R_vis_ratio_VAJ,'ko');
plot([-3,3],[-3 3],'--','color',colorLGray);
xlabel('VA model');
ylabel('VAJ model');
title('R-visual');
axis square;
xlim([-3 3]);
ylim([-3 3]);
axis on;
hold off;
suptitle('PCC-QQ');
SetFigure(25);

%}


% %%%%%%%%%%%%% compared with other areas %%%%%%%%%%%%%%%%%%%%%%%%
% % data from Laurens, VAJ model, normalized
%{
xRatio = -4:0.5:4;

figure(108);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,5,[0.2 0.02],0.15);

axes(h_subplot(1));hold on;
OA_ratio = log(OA_N(:,1)./OA_N(:,2));
[nelements, ncenters] = hist(OA_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(OA_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(OA_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(OA_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
[p,h] = ranksum(OA_ratio,0)
title('OA');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(3));hold on;
VN_ratio = log(VN_N(:,1)./VN_N(:,2));
[nelements, ncenters] = hist(VN_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(VN_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(VN_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(VN_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(VN_ratio,1)
title('VN');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(4));hold on;
CN_ratio = log(CN_N(:,1)./CN_N(:,2));
[nelements, ncenters] = hist(CN_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(CN_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(CN_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(CN_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(CN_ratio,1)
title('CN');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(5));hold on;
T_vesti_w = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
T_vesti_ratio = log(T_vesti_w(:,1)./T_vesti_w(:,2));
[nelements, ncenters] = hist(T_vesti_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
% text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
plot(nanmedian(T_vesti_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vesti_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vesti_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(T_vesti_ratio,1)
title('PCC');
% % xlim([-1 5]);
% set(gca,'xscal','log');
axis on;
hold off;


axes(h_subplot(6));hold on;
PIVC_ratio = log(PIVC_N(:,1)./PIVC_N(:,2));
[nelements, ncenters] = hist(PIVC_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(PIVC_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(PIVC_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(PIVC_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(PIVC_ratio,1)
title('PIVC');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(7));hold on;
VPS_ratio = log(VPS_N(:,1)./VPS_N(:,2));
[nelements, ncenters] = hist(VPS_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(VPS_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(VPS_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(VPS_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(VPS_ratio,1)
title('VPS');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(8));hold on;
MST_ratio = log(MST_N(:,1)./MST_N(:,2));
[nelements, ncenters] = hist(MST_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(MST_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(MST_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(MST_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
[p,h] = ranksum(MST_ratio,1)
title('MST');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(9));hold on;
VIP_ratio = log(VIP_N(:,1)./VIP_N(:,2));
[nelements, ncenters] = hist(VIP_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(VIP_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(VIP_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(VIP_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(VIP_ratio,1)
title('VIP');
% xlim([-1 5]);
axis on;
hold off;

axes(h_subplot(10));hold on;
FEF_ratio = log(FEF_N(:,1)./FEF_N(:,2));
[nelements, ncenters] = hist(FEF_ratio,xRatio);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(FEF_ratio),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(FEF_ratio)*1.1,max(nelements)*1.2,num2str(nanmedian(FEF_ratio)));
% set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
% xlabel('Double-peaked, early');
% [p,h] = ranksum(FEF_ratio,1)
title('FEF');
% xlim([-1 5]);
axis on;
hold off;

SetFigure(25);
%}

%%%%%%%%%%%%%%%%%%%%%%%%% Weight vs. R2 (VA model) %%%%%%%%%%%%%%%%%%%%%%%%
%{
figure(108);set(gcf,'pos',[60 70 1200 800]);clf;
[~,h_subplot] = tight_subplot(2,3,[0.2 0.2],0.15);

T_vesti_r2 = RSquared_T_vesti(:,5)';
T_vis_r2 = RSquared_T_vis(:,5)';
T_vesti_ratio = T_vesti_ratio(~isnan(T_vesti_ratio));
T_vis_ratio = T_vis_ratio(~isnan(T_vis_ratio));
T_vesti_r2 = T_vesti_r2(~isnan(T_vesti_r2));
T_vis_r2 = T_vis_r2(~isnan(T_vis_r2));

R_vesti_r2 = RSquared_R_vesti(:,5)';
R_vis_r2 = RSquared_R_vis(:,5)';
R_vesti_ratio = R_vesti_ratio(~isnan(R_vesti_ratio));
R_vis_ratio = R_vis_ratio(~isnan(R_vis_ratio));
R_vesti_r2 = R_vesti_r2(~isnan(R_vesti_r2));
R_vis_r2 = R_vis_r2(~isnan(R_vis_r2));


axes(h_subplot(2));hold on;

plot(T_vesti_ratio,T_vesti_r2,'o','markersize',6,'markerfacecolor',colorDBlue);
T_vesti = polyfit(T_vesti_ratio, T_vesti_r2, 1);
plot(T_vesti_ratio, polyval(T_vesti, T_vesti_ratio),'color',colorDBlue,'linewidth',3);
[T_r_vesti,T_p_vesti] =corrcoef(T_vesti_ratio,T_vesti_r2);
title(sprintf('T-vestibular, r = %g \np = %g',T_r_vesti(1,2),T_p_vesti(1,2)));
axis on;
ylabel('R^2');
% title('T-vestibular');

axes(h_subplot(3));hold on;

plot(T_vis_ratio,T_vis_r2,'o','markersize',6,'markerfacecolor',colorDRed);
T_vis = polyfit(T_vis_ratio, T_vis_r2, 1);
plot(T_vis_ratio, polyval(T_vis, T_vis_ratio),'color',colorDRed,'linewidth',3);
[T_r_vis,T_p_vis] =corrcoef(T_vis_ratio,T_vis_r2);
title(sprintf('T-visual, r = %g \np = %g',T_r_vis(1,2),T_p_vis(1,2)));
axis on;
ylabel('R^2');
% title('T-visual');



axes(h_subplot(5));hold on;

plot(R_vesti_ratio,R_vesti_r2,'o','markersize',6,'markerfacecolor',colorLBlue);
R_vesti = polyfit(R_vesti_ratio, R_vesti_r2, 1);
plot(R_vesti_ratio, polyval(R_vesti, R_vesti_ratio),'color',colorLBlue,'linewidth',3);
[R_r_vesti,R_p_vesti] =corrcoef(R_vesti_ratio,R_vesti_r2);
title(sprintf('R-vestibular,r = %g \np = %g',R_r_vesti(1,2),R_p_vesti(1,2)));
axis on;
ylabel('R^2');


axes(h_subplot(6));hold on;

plot(R_vis_ratio,R_vis_r2,'o','markersize',6,'markerfacecolor',colorLRed);
R_vis = polyfit(R_vis_ratio, R_vis_r2, 1);
plot(R_vis_ratio, polyval(R_vis, R_vis_ratio),'color',colorLRed,'linewidth',3);
[R_r_vis,R_p_vis] =corrcoef(R_vis_ratio,R_vis_r2);
title(sprintf('R-visual,r = %g \np = %g',R_r_vis(1,2),R_p_vis(1,2)));
axis on;
ylabel('R^2');
% title('T-visual');

SetFigure(25);
%}

%%%%%%%%% spatial tuning-prefer direction distribution (VA model) %%%%%%%%%
%{

% figures
figure(112);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,5,0.1,0.15);

axes(h_subplot(1));
text(0.7,-1,'Preferred direction','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
plot([0 360],[0 360],'--','linewidth',1.5,'color',colorLGray);
plot(T_vestiPreDir_V(:,1),T_vestiPreDir_A(:,1),'o','color',colorDBlue,'markerfacecolor',colorDBlue);
axis on;axis square;box on;
xlim([0 360]);ylim([0 360]);
xlabel('v');ylabel('a');
set(gca,'xTick',0:45:360,'yTick',0:45:360,'xticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'},'yticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'});
title('Vestibular,azi');

axes(h_subplot(3));
hold on;
plot([0 360],[0 360],'--','linewidth',1.5,'color',colorLGray);
plot(T_visPreDir_V(:,1),T_visPreDir_A(:,1),'o','color',colorDRed,'markerfacecolor',colorDRed);
axis on;axis square;box on;
xlim([0 360]);ylim([0 360]);
xlabel('v');ylabel('a');
set(gca,'xTick',0:45:360,'yTick',0:45:360,'xticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'},'yticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'});
title('Visual,azi');

axes(h_subplot(4));
hold on;
plot([-90 90],[-90 90],'--','linewidth',1.5,'color',colorLGray);
plot(T_vestiPreDir_V(:,2),T_vestiPreDir_A(:,2),'o','color',colorDBlue,'markerfacecolor',colorDBlue);
axis on;axis square;box on;
xlim([-90 90]);ylim([-90 90]);
xlabel('v');ylabel('a');
set(gca,'xTick',-90:45:90,'yTick',-90:45:90,'xticklabel',{'-90',' ','0',' ','90'},'yticklabel',{'-90',' ','0',' ','90'});
title('Vestibular,ele');

axes(h_subplot(5));
hold on;
plot([-90 90],[-90 90],'--','linewidth',1.5,'color',colorLGray);
plot(T_visPreDir_V(:,2),T_visPreDir_A(:,2),'o','color',colorDRed,'markerfacecolor',colorDRed);
axis on;axis square;box on;
xlim([-90 90]);ylim([-90 90]);
xlabel('v');ylabel('a');
set(gca,'xTick',-90:45:90,'yTick',-90:45:90,'xticklabel',{'-90',' ','0',' ','90'},'yticklabel',{'-90',' ','0',' ','90'});
title('Visual,ele');

axes(h_subplot(7));
hold on;
plot([0 360],[0 360],'--','linewidth',1.5,'color',colorLGray);
plot(R_vestiPreDir_V(:,1),R_vestiPreDir_A(:,1),'o','color',colorLBlue,'markerfacecolor',colorLBlue);
axis on;axis square;box on;
xlim([0 360]);ylim([0 360]);
xlabel('v');ylabel('a');
set(gca,'xTick',0:45:360,'yTick',0:45:360,'xticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'},'yticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'});
title('Vestibular,azi');

axes(h_subplot(8));
hold on;
plot([0 360],[0 360],'--','linewidth',1.5,'color',colorLGray);
plot(R_visPreDir_V(:,1),R_visPreDir_A(:,1),'o','color',colorLRed,'markerfacecolor',colorLRed);
axis on;axis square;box on;
xlim([0 360]);ylim([0 360]);
xlabel('v');ylabel('a');
set(gca,'xTick',0:45:360,'yTick',0:45:360,'xticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'},'yticklabel',{'0',' ',' ',' ','180',' ',' ',' ','360'});
title('Visual,azi');

axes(h_subplot(9));
hold on;
plot([-90 90],[-90 90],'--','linewidth',1.5,'color',colorLGray);
plot(R_vestiPreDir_V(:,2),R_vestiPreDir_A(:,2),'o','color',colorLBlue,'markerfacecolor',colorLBlue);
axis on;axis square;box on;
xlim([-90 90]);ylim([-90 90]);
xlabel('v');ylabel('a');
set(gca,'xTick',-90:45:90,'yTick',-90:45:90,'xticklabel',{'-90',' ','0',' ','90'},'yticklabel',{'-90',' ','0',' ','90'});
title('Vestibular,ele');

axes(h_subplot(10));
hold on;
plot([-90 90],[-90 90],'--','linewidth',1.5,'color',colorLGray);
plot(R_visPreDir_V(:,2),R_visPreDir_A(:,2),'o','color',colorLRed,'markerfacecolor',colorLRed);
axis on;axis square;box on;
xlim([-90 90]);ylim([-90 90]);
xlabel('v');ylabel('a');
set(gca,'xTick',-90:45:90,'yTick',-90:45:90,'xticklabel',{'-90',' ','0',' ','90'},'yticklabel',{'-90',' ','0',' ','90'});
title('Visual,ele');



SetFigure(25);
%}

%%%%%%%%% spatial tuning-Diff of prefer direction (V,A) distribution (VA model) %%%%%%%%%
%{
xdiffPreDir = 9:18:(180-9);
% figures
figure(113);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,0.1,0.15);

axes(h_subplot(1));
text(0.9,-0.3,'Angle Diff','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
[nelements, ncenters] = hist(T_vesti_angleDiff,xdiffPreDir);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(T_vesti_angleDiff),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vesti_angleDiff)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vesti_angleDiff)));
title('Vestibular');
xlim([0 180])
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'});
axis on;
hold off;

axes(h_subplot(3));
hold on;
[nelements, ncenters] = hist(T_vis_angleDiff,xdiffPreDir);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(T_vis_angleDiff),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(T_vis_angleDiff)*1.1,max(nelements)*1.2,num2str(nanmedian(T_vis_angleDiff)));
title('Visual');
xlim([0 180])
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'});
axis on;
hold off;

axes(h_subplot(5));
hold on;
[nelements, ncenters] = hist(R_vesti_angleDiff,xdiffPreDir);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(R_vesti_angleDiff),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vesti_angleDiff)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vesti_angleDiff)));
xlim([0 180])
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'});
axis on;
hold off;

axes(h_subplot(6));
hold on;
[nelements, ncenters] = hist(R_vis_angleDiff,xdiffPreDir);
h1 = bar(ncenters, nelements, 0.7,'k','edgecolor','k');
set(h1,'linewidth',1.5);
plot(nanmedian(R_vis_angleDiff),max(nelements)*1.1,'kv', 'markerfacecolor','k');
text(nanmedian(R_vis_angleDiff)*1.1,max(nelements)*1.2,num2str(nanmedian(R_vis_angleDiff)));
xlim([0 180])
set(gca,'xtick',[0 45 90 135 180],'xticklabel',{'0',' ','90',' ','180'});
axis on;
hold off;


SetFigure(25);
%}

%%%%%%%%% plot weight of V&A vesus n (VA model) %%%%%%%%%

%{
% figures
figure(114);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,0.2,0.15);

axes(h_subplot(1));
text(0.9,-0.3,'wV vs. nonlinearty','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
plot(T_vesti_VA_w(:,1),T_vesti_VA_n(1,:),'wo', 'markerfacecolor',colorDBlue);
plot(T_vesti_VA_w(:,2),T_vesti_VA_n(2,:),'wo', 'markeredgecolor',colorDBlue);
title('Vestibular');
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(3));
hold on;
plot(T_vis_VA_w(:,1),T_vis_VA_n(1,:),'wo', 'markerfacecolor',colorDRed);
plot(T_vis_VA_w(:,2),T_vis_VA_n(2,:),'wo', 'markeredgecolor',colorDRed);
title('Visual');
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(5));
hold on;
plot(R_vesti_VA_w(:,1),R_vesti_VA_n(1,:),'wo', 'markerfacecolor',colorLBlue);
plot(R_vesti_VA_w(:,2),R_vesti_VA_n(2,:),'wo', 'markeredgecolor',colorLBlue);
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(6));
hold on;
plot(R_vis_VA_w(:,1),R_vis_VA_n(1,:),'wo', 'markerfacecolor',colorLRed);
plot(R_vis_VA_w(:,2),R_vis_VA_n(2,:),'wo', 'markeredgecolor',colorLRed);
xlabel('wV');
ylabel('n');
axis on;
hold off;

SetFigure(25);
%}

%%%%%%%%% plot weight of V vesus n (VAJ model) %%%%%%%%%

%{
% figures
figure(115);set(gcf,'pos',[60 70 1500 800]);clf;
[~,h_subplot] = tight_subplot(2,3,0.2,0.15);

axes(h_subplot(1));
text(0.9,-0.3,'wV vs. nonlinearty','Fontsize',30,'rotation',90);
text(1.1,0.1,'Translation','Fontsize',25,'rotation',90);
text(1.1,-1.1,'Rotation','Fontsize',25,'rotation',90);
axis off;

axes(h_subplot(2));
hold on;
plot(T_vesti_VAJ_w(:,1),T_vesti_VAJ_n(1,:),'wo', 'markerfacecolor',colorDBlue);
title('Vestibular');
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(3));
hold on;
plot(T_vis_VAJ_w(:,1),T_vis_VAJ_n(1,:),'wo', 'markerfacecolor',colorDRed);
title('Visual');
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(5));
hold on;
plot(R_vesti_VAJ_w(:,1),R_vesti_VAJ_n(1,:),'wo', 'markerfacecolor',colorLBlue);
xlabel('wV');
ylabel('n');
axis on;
hold off;

axes(h_subplot(6));
hold on;
plot(R_vis_VAJ_w(:,1),R_vis_VAJ_n(1,:),'wo', 'markerfacecolor',colorLRed);
xlabel('wV');
ylabel('n');
axis on;
hold off;

SetFigure(25);
%}

%%%%%%%%% plot ratio of wV/wA (VA model) %%%%%%%%%

%{

figure(116);set(gcf,'pos',[60 70 700 400]);clf;
% [~,h_subplot] = tight_subplot(2,2,[0.2 0.1],0.15);

T_vesti_w = squeeze(cell2mat(struct2cell(T_wVA_vesti)))';
T_vesti_ratio = log(T_vesti_w(:,1)./T_vesti_w(:,2));
T_vis_w = squeeze(cell2mat(struct2cell(T_wVA_vis)))';
T_vis_ratio = log(T_vis_w(:,1)./T_vis_w(:,2));
R_vesti_w = squeeze(cell2mat(struct2cell(R_wVA_vesti)))';
R_vesti_ratio = log(R_vesti_w(:,1)./R_vesti_w(:,2));
R_vis_w = squeeze(cell2mat(struct2cell(R_wVA_vis)))';
R_vis_ratio = log(R_vis_w(:,1)./R_vis_w(:,2));



T_vesti_r2 = RSquared_T_vesti(:,5)';
T_vis_r2 = RSquared_T_vis(:,5)';
T_vesti_ratio = T_vesti_ratio(~isnan(T_vesti_ratio));
T_vis_ratio = T_vis_ratio(~isnan(T_vis_ratio));
T_vesti_r2 = T_vesti_r2(~isnan(T_vesti_r2));
T_vis_r2 = T_vis_r2(~isnan(T_vis_r2));

R_vesti_r2 = RSquared_R_vesti(:,5)';
R_vis_r2 = RSquared_R_vis(:,5)';
R_vesti_ratio = R_vesti_ratio(~isnan(R_vesti_ratio));
R_vis_ratio = R_vis_ratio(~isnan(R_vis_ratio));
R_vesti_r2 = R_vesti_r2(~isnan(R_vesti_r2));
R_vis_r2 = R_vis_r2(~isnan(R_vis_r2));

T_vesti_ratio(T_vesti_r2<0.7) = [];
T_vis_ratio(T_vis_r2<0.7) = [];
R_vesti_ratio(R_vesti_r2<0.7) = [];
R_vis_ratio(R_vis_r2<0.7) = [];

x = -2:0.25:2;
for ii = 1:length(x)
    
    p_T_vesti(ii) = sum(logical(T_vesti_ratio<x(ii)))/length(T_vesti_ratio);
    p_T_vis(ii) = sum(logical(T_vis_ratio<x(ii)))/length(T_vis_ratio);
    p_R_vesti(ii) = sum(logical(R_vesti_ratio<x(ii)))/length(R_vesti_ratio);
    p_R_vis(ii) = sum(logical(R_vis_ratio<x(ii)))/length(R_vis_ratio);
    
end


axes;hold on;
plot(x,p_T_vesti,'-o','color',colorDBlue,'linewidth',3);
plot(x,p_R_vesti,'-^','color',colorLBlue,'linewidth',3);
plot(x,p_T_vis,'-^','color',colorDRed,'linewidth',3);
plot(x,p_R_vis,'-^','color',colorLRed,'linewidth',3);

plot([x(1) x(end)],[0.5 0.5],'--','color',colorLGray);
plot([0 0],[0 1],'--','color',colorLGray);
% title('T-vestibular');
% xlim([-2 2]);
% set(gca,'xscal','log');
axis on;
hold off;
xlabel('log(wV/wA)');
ylabel('Proportion of cells');

SetFigure(25);

%}

%%%%%%%%% plot time delay of Velocity to Acceleration (VA model) %%%%%%%%%

%{

figure(117);set(gcf,'pos',[200 200 1200 600]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.1],0.15);

axes(h_subplot(1));
hist(T_VA_vesti_delayV,20);
xlim([0 0.5]);
title('T-vestibular');

axes(h_subplot(2));
hist(T_VA_vis_delayV,20);
xlim([0 0.5]);
title('T-visual');

axes(h_subplot(3));
hist(R_VA_vesti_delayV,20);
xlim([0 0.5]);
title('R-vestibular');

axes(h_subplot(4));
hist(R_VA_vis_delayV,20);
xlim([0 0.5]);
title('R-visual');

SetFigure(25);
%}

%%%%%%%%% plot nV vs nA (VA model) %%%%%%%%%

%{
% figures
figure(118);set(gcf,'pos',[200 200 1000 800]);clf;
[~,h_subplot] = tight_subplot(2,2,0.2,0.15);

axes(h_subplot(1));
hold on;
plot(T_vesti_VA_n(1,:),T_vesti_VA_n(2,:),'wo', 'markerfacecolor',colorDBlue);
title('T-Vestibular');
xlabel('nV');
ylabel('nA');
axis on;
axis square;
hold off;

axes(h_subplot(2));
hold on;
plot(T_vis_VA_n(1,:),T_vis_VA_n(2,:),'wo', 'markerfacecolor',colorDRed);
title('T-Visual');
xlabel('nV');
ylabel('nA');
axis on;
axis square;
hold off;

axes(h_subplot(3));
hold on;
plot(R_vesti_VA_n(1,:),R_vesti_VA_n(2,:),'wo', 'markerfacecolor',colorLBlue);
title('R-Vestibular');
xlabel('nV');
ylabel('nA');
axis on;
axis square;
hold off;

axes(h_subplot(4));
hold on;
plot(R_vis_VA_n(1,:),R_vis_VA_n(2,:),'wo', 'markerfacecolor',colorLRed);
title('R-Visual');
xlabel('nV');
ylabel('nA');
axis on;
axis square;
hold off;


SetFigure(25);
%}

%%%%%%%%% plot time delay of Acceleration vs time delay of Velocity to Acceleration (VA model) %%%%%%%%%

%{

figure(119);set(gcf,'pos',[200 200 900 800]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.1],0.15);

axes(h_subplot(1));
plot(T_VA_vesti_muA,T_VA_vesti_delayV,'ko');
axis square;
xlabel('muA');
ylabel('delay (V to A)');
title('T-vestibular');

axes(h_subplot(2));
plot(T_VA_vis_muA,T_VA_vis_delayV,'ko');
axis square;
xlabel('muA');
ylabel('delay (V to A)');
title('T-visual');

axes(h_subplot(3));
plot(R_VA_vesti_muA,R_VA_vesti_delayV,'ko');
axis square;
xlabel('muA');
ylabel('delay (V to A)');
title('R-vestibular');

axes(h_subplot(4));
plot(R_VA_vis_muA,R_VA_vis_delayV,'ko');
axis square;
xlabel('muA');
ylabel('delay (V to A)');
title('R-visual');

SetFigure(25);
%}

%%%%%%%%% plot correlation of Acceleration and Velocity spatial kernel (VA model) %%%%%%%%%

% %{

T_vesti_s_V = inversePackSpatial(T_VA_vesti_spatial_V);
T_vesti_s_A = inversePackSpatial(T_VA_vesti_spatial_A);
T_vis_s_V = inversePackSpatial(T_VA_vis_spatial_V);
T_vis_s_A = inversePackSpatial(T_VA_vis_spatial_A);
R_vesti_s_V = inversePackSpatial(R_VA_vesti_spatial_V);
R_vesti_s_A = inversePackSpatial(R_VA_vesti_spatial_A);
R_vis_s_V = inversePackSpatial(R_VA_vis_spatial_V);
R_vis_s_A = inversePackSpatial(R_VA_vis_spatial_A);

for ii = 1:size(T_vesti_s_V,1)
    coef = corrcoef(T_vesti_s_V(ii,:),T_vesti_s_A(ii,:));
    T_vesti_coef(ii) = coef(1,2);
end

T_vesti_coef = T_vesti_coef(~isnan(T_vesti_coef));

for ii = 1:size(R_vesti_s_V,1)
    coef = corrcoef(R_vesti_s_V(ii,:),R_vesti_s_A(ii,:));
    R_vesti_coef(ii) = coef(1,2);
end

R_vesti_coef = R_vesti_coef(~isnan(R_vesti_coef));

for ii = 1:size(T_vis_s_V,1)
    coef = corrcoef(T_vis_s_V(ii,:),T_vis_s_A(ii,:));
    T_vis_coef(ii) = coef(1,2);
end

T_vis_coef = T_vis_coef(~isnan(T_vis_coef));

for ii = 1:size(R_vis_s_V,1)
    coef = corrcoef(R_vis_s_V(ii,:),R_vis_s_A(ii,:));
    R_vis_coef(ii) = coef(1,2);
end

R_vis_coef = R_vis_coef(~isnan(R_vis_coef));


figure(120);set(gcf,'pos',[200 200 1000 800]);clf;
[~,h_subplot] = tight_subplot(2,2,[0.2 0.2],0.2);

axes(h_subplot(1));
hist(T_vesti_coef,10);
% axis square;
xlabel('coef');
ylabel('cell #');
title('T-vestibular');

axes(h_subplot(2));
hist(T_vis_coef,10);
% axis square;
xlabel('coef');
ylabel('cell #');
title('T-visual');

axes(h_subplot(3));
hist(R_vesti_coef,10);
% axis square;
xlabel('coef');
ylabel('cell #');
title('R-vestibular');

axes(h_subplot(4));
hist(R_vis_coef,10);
% axis square;
xlabel('coef');
ylabel('cell #');
title('R-visual');

SetFigure(25);
%}




