% plot figures of 3D models for PSTH
% red: velocity only (VO)
% blue: acceleration only (AO)
% green: VA
% magenta: VJ
% cyan: AJ
% black: VAJ
% white: PVAJ
% 100# PSTH model figures
% 110# contour model figures
% LBY 20170328
% LBY 20170603
% LBY 20171210 add contour figures

global PSTH3Dmodel PSTH;

nBins = stimOffBin - stimOnBin +1;
%
% k=1,2,3
% j= -90,-45,0,45,90 (up->down)
% i=0 45 90 135 180 225 270 315

stimType{1}='Vestibular';
stimType{2}='Visual';
stimType{3}='Combined';

% 270-225-180-135-90-45-0-315 for figures
% iAzi = [7 6 5 4 3 2 1 8 7];
iAzi = [7 6 5 4 3 2 1 8];
xAzi = 1:8;
yEle = [-1,-0.707,0,0.707,1];
% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% the lines markers
markers = {
    'aMax',aMax/timeStep,colorDBlue;
    'aMin',aMin/timeStep,colorDBlue;
    'vMax',(aMin+aMax)/2/timeStep,'r';
    };

unique_elevation = [-90,-45,0,45,90];
unique_azimuth = [0 45 90 135 180 225 270 315];

sprintf('Plot model figures...')

% ------ fig.100 plot 3D models (PSTH) ------%
% %{
for m_inx = 1:length(models)
    figure(100+m_inx);
    set(gcf,'pos',[0 0 1900 1000]);
    clf;
    [~,h_subplot] = tight_subplot(5,9,0.04,0.15);
    
    for j = 2:length(unique_elevation)-1
        for i = 1:length(unique_azimuth)
            axes(h_subplot(i+(j-1)*9));hold on;
            bar(squeeze(PSTH_data(j,iAzi(i),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
            for n = 1:size(markers,1)
                plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
                hold on;
            end
            eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'(',num2str(j),',',num2str(iAzi(i)),',:)));']);
            %             set(h,'linestyle','-','marker','.','color',models_color{m_inx},'markersize',8);
            set(h,'linestyle','-','linewidth',4,'color',models_color{m_inx});
            %                 keyboard;
            set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
            axis on;
            SetFigure(25);
            set(gca,'xtick',[],'xticklabel',[]);
            
        end
    end
    
    % 2 extra conditions
    axes(h_subplot(5+(1-1)*9));hold on;
    bar(squeeze(PSTH_data(1,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
    for n = 1:size(markers,1)
        plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
        hold on;
    end
    eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'(',num2str(1),',',num2str(iAzi(5)),',:)));']);
    %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
    set(h,'linestyle','-','linewidth',4,'color',models_color{m_inx});
    set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
    axis on;
    SetFigure(25);
    set(gca,'xtick',[],'xticklabel',[]);
    
    
    axes(h_subplot(5+(5-1)*9));hold on;
    bar(squeeze(PSTH_data(5,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
    for n = 1:size(markers,1)
        plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
        hold on;
    end
    eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'(',num2str(5),',',num2str(iAzi(5)),',:)));']);
    %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
    set(h,'linestyle','-','linewidth',4,'color',models_color{m_inx});
    set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
    axis on;
    SetFigure(25);
    set(gca,'xtick',[],'xticklabel',[]);
    
    
    % sponteneous
    axes(h_subplot(1+(1-1)*9));hold on;
    bar(temp_spon,'facecolor',colorLGray,'edgecolor',colorLGray);
    %     for n = 1:size(markers,1)
    %         plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',0.5);
    %         hold on;
    %     end
    set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
    axis on;
    SetFigure(25);
    set(gca,'xtick',[],'xticklabel',[]);
    
    
    % text on the figure
    axes('unit','pixels','pos',[60 800 1800 180]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(30,14,'PSTHs for each direction(T)','fontsize',40);
        case 112
            text(30,14,'PSTHs for each direction(R)','fontsize',40);
    end
    text(1,10,'Spontaneous','fontsize',30);
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  ',models{m_inx},' model_','    ',stimType{stimTypeInx}];
    text(60,0,str1,'fontsize',24);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_',models{m_inx},';']);
    text(60,-5,['R^2 = ',num2str(R_squared)],'fontsize',24);
    axis off;
    
    axes('unit','pixels','pos',[60 50 1800 100]);
    xlim([0,100]);
    ylim([0,10]);
    %     text(0,0,['Max spk mean FR(Hz): ',num2str(maxSpkRealAll(k))],'fontsize',15);
    text(0,10,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    text(0,6,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    
    if strcmp(models{m_inx},'VA')
        wV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(12),-2);
        wA = roundn(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(12),-2);
        text(80,15,['wV =  ',num2str(wV)],'fontsize',24);
        text(80,10,['wA =  ',num2str(wA)],'fontsize',24);
        nV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(4),-2);
        nA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(8),-2);
        text(20,4,['nV =  ',num2str(nV)],'fontsize',20);
        text(35,4,['nA =  ',num2str(nA)],'fontsize',20);
        
        if strcmp(model_catg,'Out-sync model')
            muA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(3),-2);
            muV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_VA(13),-2);
            text(20,0,['mu V =  ',num2str(muV)],'fontsize',20);
            text(35,0,['mu A =  ',num2str(muA)],'fontsize',20);
        end
        
    end
    if strcmp(models{m_inx},'VAJ')
        wV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(16)*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(17)),-2);
        wA = roundn((1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(16))*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(17)),-2);
        wJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(17),-2);
        text(80,15,['wV =  ',num2str(wV)],'fontsize',24);
        text(80,10,['wA =  ',num2str(wA)],'fontsize',24);
        text(80,5,['wJ =  ',num2str(wJ)],'fontsize',24);
        nV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(4),-2);
        nA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(8),-2);
        nJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(12),-2);
        text(20,4,['nV =  ',num2str(nV)],'fontsize',20);
        text(35,4,['nA =  ',num2str(nA)],'fontsize',20);
        text(50,4,['nJ =  ',num2str(nJ)],'fontsize',20);
        
        if strcmp(model_catg,'Out-sync model')
            muA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(3),-2);
            muV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(18),-2);
            muJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_VAJ(19),-2);
            text(20,0,['mu V =  ',num2str(muV)],'fontsize',20);
            text(35,0,['mu A =  ',num2str(muA)],'fontsize',20);
            text(50,0,['mu J =  ',num2str(muJ)],'fontsize',20);
        end
        
    end
    if strcmp(models{m_inx},'VAP')
        wV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(16)*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(17)),-2);
        wA = roundn((1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(16))*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(17)),-2);
        wP = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(17),-2);
        text(80,15,['wV =  ',num2str(wV)],'fontsize',24);
        text(80,10,['wA =  ',num2str(wA)],'fontsize',24);
        text(80,5,['wP =  ',num2str(wP)],'fontsize',24);
        nV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(4),-2);
        nA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(8),-2);
        nP = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(12),-2);
        text(20,4,['nV =  ',num2str(nV)],'fontsize',20);
        text(35,4,['nA =  ',num2str(nA)],'fontsize',20);
        text(50,4,['nP =  ',num2str(nP)],'fontsize',20);
        
        if strcmp(model_catg,'Out-sync model')
            muA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(3),-2);
            muV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(18),-2);
            muP = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_VAP(19),-2);
            text(20,0,['mu V =  ',num2str(muV)],'fontsize',20);
            text(35,0,['mu A =  ',num2str(muA)],'fontsize',20);
            text(50,0,['mu P =  ',num2str(muP)],'fontsize',20);
        end
        
    end
    if strcmp(models{m_inx},'PVAJ')
        wV = roundn((1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(21))*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(20)),-2);
        wA = roundn((1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(22))*PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(21),-2);
        wJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(22),-2);
        wP = roundn((1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(21))*PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(20),-2);
        text(80,15,['wV =  ',num2str(wV)],'fontsize',24);
        text(80,10,['wA =  ',num2str(wA)],'fontsize',24);
        text(80,5,['wJ =  ',num2str(wJ)],'fontsize',24);
        text(80,0,['wP =  ',num2str(wP)],'fontsize',24);
        nV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(4),-2);
        nA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(8),-2);
        nJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(12),-2);
        nP = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(16),-2);
        text(20,4,['nV =  ',num2str(nV)],'fontsize',20);
        text(35,4,['nA =  ',num2str(nA)],'fontsize',20);
        text(50,4,['nJ =  ',num2str(nJ)],'fontsize',20);
        text(65,4,['nP =  ',num2str(nP)],'fontsize',20);
        
        if strcmp(model_catg,'Out-sync model')
            muA = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(3),-2);
            muV = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(23),-2);
            muJ = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(24),-2);
            muP = roundn(PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(3)+PSTH3Dmodel{stimTypeInx}.modelFitPara_PVAJ(25),-2);
            text(20,0,['mu V =  ',num2str(muV)],'fontsize',20);
            text(35,0,['mu A =  ',num2str(muA)],'fontsize',20);
            text(50,0,['mu P =  ',num2str(muP)],'fontsize',20);
            text(65,0,['mu J =  ',num2str(muP)],'fontsize',20);
        end
        
    end
    
    
    
    %--- this is for annotation - the direction ----%
    %     text(3,0,'\downarrow ','fontsize',30);
    %     text(26,0,'\leftarrow ','fontsize',30);
    %     text(49,0,'\uparrow ','fontsize',30);
    %     text(71,0,'\rightarrow ','fontsize',30);
    %     text(93,0,'\downarrow ','fontsize',30);
    %     text(55,76,'\uparrow ','fontsize',30);
    %     text(55,13,'\downarrow ','fontsize',30);
    axis off;
    %--- this is for annotation - the direction ----%
    
    
    % to save the figures
    str3 = [str, '_',models{m_inx},'_model_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_T'];
        saveas(100+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_R'];
        saveas(100+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end
end
%}

% % ------ fig.110 plot 3D models (Contour) ------%
%{
for m_inx = 1:length(models)
    figure(110+m_inx);
    set(gcf,'pos',[60 200 1000 600]);
    clf;

    axes('unit','pixels','pos',[200 100 650 300]);
    %     contourf(xAzi,yEle,spk_data_count_mean_rate_trans{k},'linecolor','w','linestyle','none');
    eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitResponMeanTrans_',models{m_inx},');']);
    colorbar;
    set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
    set(gca, 'xtick', [] );
    set(gca, 'ytick', [] );
    box off;

    % text on the figure
    axes('unit','pixels','pos',[60 470 1000 100]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(15,14,'Spatial kernel(T)','fontsize',20);
        case 112
            text(15,14,'Spatial kernel(R)','fontsize',20);
    end
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  ',models{m_inx},' model_','    ',stimType{stimTypeInx}];
    text(40,4,str1,'fontsize',18);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_',models{m_inx},';']);
    text(40,-2,['R^2 = ',num2str(R_squared)],'fontsize',18);
    axis off;

    axes('unit','pixels','pos',[60 50 1000 100]);
    xlim([0,100]);
    ylim([0,10]);
    text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    axis off;

    % to save the figures
    str3 = [str, '_',models{m_inx},'_model_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_Contour_T'];
        saveas(100+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_Contour_R'];
        saveas(110+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end

end
%}

% % ------ fig.120 plot V,A,J direction tuning for VAJ models (Contour) ------%
%{
if sum(ismember(models,'VAJ')) ~= 0
components = {'V','A','J'};
figure(120);clf;set(gcf,'pos',[20 200 1800 200]);
for inx = 1:length(components)

    subplot(1,length(components),inx)
    eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAJ_',components{inx},');']);
    colorbar;
%     set(gca, 'linecolor' , 'w');
    set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
    set(gca, 'xtick', [] );
    set(gca, 'ytick', [] );
    box off;
end
% text on the figure
axes('unit','pixels','pos',[60 270 1800 100]);
xlim([0,100]);
ylim([0,20]);
switch Protocol
    case 100
        text(15,14,'Spatial kernel(T)','fontsize',20);
    case 112
        text(15,14,'Spatial kernel(R)','fontsize',20);
end
FileNameTemp = num2str(FILE);
%     FileNameTemp =  FileNameTemp(1:end-4);
str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
str1 = [FileNameTemp,'  ',components{inx},' model_','    ',stimType{stimTypeInx}];
text(40,4,str1,'fontsize',18);
eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAJ;']);
text(40,-2,['R^2 = ',num2str(R_squared)],'fontsize',18);
axis off;

% axes('unit','pixels','pos',[60 50 1000 100]);
% xlim([0,100]);
% ylim([0,10]);
% text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
% text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
% axis off;

% to save the figures
str3 = [str, '_VAJmodel_',stimType{stimTypeInx}];
set(gcf,'paperpositionmode','auto');
if Protocol == 100
    ss = [str3, '_Contour_T'];
    saveas(120,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
elseif Protocol == 112
    ss = [str3, '_Contour_R'];
    saveas(120,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
end
else
    disp('No VAJ model!');
end
%}

% % ------ fig.130 plot V,A,J direction tuning for VAJ models at corresponding peak time(Contour) ------%
%{
if sum(ismember(models,'VAJ')) ~= 0
components = {'V','A','J'};
figure(130);clf;set(gcf,'pos',[20 200 1800 200]);
for inx = 1:length(components)

    subplot(1,length(components),inx)
    eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAJ_',components{inx},'_peakT);']);
    colorbar;
%     set(gca, 'linecolor' , 'w');
    set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
    set(gca, 'xtick', [] );
    set(gca, 'ytick', [] );
    box off;
end
% text on the figure
axes('unit','pixels','pos',[60 270 1800 100]);
xlim([0,100]);
ylim([0,20]);
switch Protocol
    case 100
        text(15,14,'Spatial kernel(T)','fontsize',20);
    case 112
        text(15,14,'Spatial kernel(R)','fontsize',20);
end
FileNameTemp = num2str(FILE);
%     FileNameTemp =  FileNameTemp(1:end-4);
str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
str1 = [FileNameTemp,'  VAJ model_','    ',stimType{stimTypeInx}];
text(40,4,str1,'fontsize',18);
eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAJ;']);
text(40,-2,['R^2 = ',num2str(R_squared)],'fontsize',18);
axis off;

% axes('unit','pixels','pos',[60 50 1000 100]);
% xlim([0,100]);
% ylim([0,10]);
% text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
% text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
% axis off;

% to save the figures
str3 = [str, '_VAJmodel_peakT_',stimType{stimTypeInx}];
set(gcf,'paperpositionmode','auto');
if Protocol == 100
    ss = [str3, '_Contour_T'];
    saveas(130,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
elseif Protocol == 112
    ss = [str3, '_Contour_R'];
    saveas(130,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
end
else
    disp('No VAJ model!');
end
%}

% % ------ fig.140 plot V,A spatial tuning for VA models (Contour, use fitted data) ------%
%{
if sum(ismember(models,'VA')) ~= 0
    components = {'V','A'};
    figure(140);clf;set(gcf,'pos',[120 200 1400 750]);
    [~,h_subplot] = tight_subplot(1,2,0.1,0.3);
    for inx = 1:length(components)
        
        axes(h_subplot(inx));
        eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitTrans_spatial_VA.',components{inx},');']);
        a = cell2mat(struct2cell(PSTH3Dmodel{stimTypeInx}.modelFitTrans_spatial_VA));
        caxis([min(min(a)) max(max(a))]);
        colorbar;
        %     set(gca, 'linecolor' , 'w');
        set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
        set(gca, 'xtick', [] );
        set(gca, 'ytick', [] );
        box off;
        title(['Component -  ',components{inx}]);
    end
    % text on the figure
    axes('unit','pixels','pos',[60 600 1400 100]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(11,16,'Spatial kernel(T)','fontsize',40);
        case 112
            text(11,16,'Spatial kernel(R)','fontsize',40);
    end
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  VA model_','    ',stimType{stimTypeInx}];
    text(50,14,str1,'fontsize',18);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VA;']);
    text(60,7,['R^2 = ',num2str(R_squared)],'fontsize',18);
    axis off;
    
    % axes('unit','pixels','pos',[60 50 1000 100]);
    % xlim([0,100]);
    % ylim([0,10]);
    % text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    % text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    % axis off;
    
    % to save the figures
    str3 = [str, '_VAmodel_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_Contour_T'];
        saveas(140,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_Contour_R'];
        saveas(140,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end
else
    disp('No VA model!');
end
%}


% % ------ fig.150 plot V,A for VA model (PSTH) ------%
%{
if sum(ismember(models,'VA')) ~= 0
    components = {'V','A'};
    color_com = {'r',colorDBlue};
    for m_inx = 1:length(components)
        %     figure(150+m_inx);clf;set(gcf,'pos',[20+(m_inx-1)*910 200 900 500]);
        figure(150+m_inx);clf;set(gcf,'pos',[0 0 1900 1000]);
        [~,h_subplot] = tight_subplot(5,9,0.04,0.15);
        
        for j = 2:length(unique_elevation)-1
            for i = 1:length(unique_azimuth)
                axes(h_subplot(i+(j-1)*9));hold on;
                bar(squeeze(PSTH_data(j,iAzi(i),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
                for n = 1:size(markers,1)
                    plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
                    hold on;
                end
                eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VA.',components{m_inx},'(',num2str(j),',',num2str(iAzi(i)),',:)));']);
                %             set(h,'linestyle','-','marker','.','color',models_color{m_inx},'markersize',8);
                set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
                %                 keyboard;
                set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
                axis on;
                
                set(gca,'xtick',[],'xticklabel',[]);
                
            end
        end
        
        % 2 extra conditions
        axes(h_subplot(5+(1-1)*9));hold on;
        bar(squeeze(PSTH_data(1,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VA.',components{m_inx},'(',num2str(1),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        axes(h_subplot(5+(5-1)*9));hold on;
        bar(squeeze(PSTH_data(5,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VA.',components{m_inx},'(',num2str(5),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        %     % sponteneous
        %     axes(h_subplot(1+(1-1)*9));hold on;
        %     bar(temp_spon,'facecolor',colorLGray,'edgecolor',colorLGray);
        %     %     for n = 1:size(markers,1)
        %     %         plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',0.5);
        %     %         hold on;
        %     %     end
        %     set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        %     axis on;
        % %     SetFigure(25);
        %     set(gca,'xtick',[],'xticklabel',[]);
        
        
        % text on the figure
        axes('unit','pixels','pos',[60 800 1800 100]);
        xlim([0,100]);
        ylim([0,20]);
        switch Protocol
            case 100
                text(30,20,'PSTH (T)','fontsize',18);
            case 112
                text(30,20,'PSTH (R)','fontsize',18);
        end
        %     text(10,2,'Spontaneous','fontsize',30);
        FileNameTemp = num2str(FILE);
        %     FileNameTemp =  FileNameTemp(1:end-4);
        str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
        str1 = [FileNameTemp,'  VA model ',components{m_inx},'  ',stimType{stimTypeInx}];
        text(40,20,str1,'fontsize',18);
        eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VA;']);
        text(70,10,['R^2 = ',num2str(R_squared)],'fontsize',18);
        axis off;
        
        %     axes('unit','pixels','pos',[60 50 1800 100]);
        %     xlim([0,100]);
        %     ylim([0,10]);
        %     %     text(0,0,['Max spk mean FR(Hz): ',num2str(maxSpkRealAll(k))],'fontsize',15);
        %     text(0,10,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
        %     text(0,6,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
        
        %--- this is for annotation - the direction ----%
        %     text(3,0,'\downarrow ','fontsize',30);
        %     text(26,0,'\leftarrow ','fontsize',30);
        %     text(49,0,'\uparrow ','fontsize',30);
        %     text(71,0,'\rightarrow ','fontsize',30);
        %     text(93,0,'\downarrow ','fontsize',30);
        %     text(55,76,'\uparrow ','fontsize',30);
        %     text(55,13,'\downarrow ','fontsize',30);
        axis off;
        %--- this is for annotation - the direction ----%
        
        SetFigure(25);
        % to save the figures
        str3 = [str, '_VA_model_',components{m_inx},'_',stimType{stimTypeInx}];
        set(gcf,'paperpositionmode','auto');
        if Protocol == 100
            ss = [str3, '_T'];
            saveas(150+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
        elseif Protocol == 112
            ss = [str3, '_R'];
            saveas(150+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
        end
    end
else
    disp('No VA model!');
end
%}

% ------ fig.160 plot V,A,J spatial tuning for VAJ models (Contour, use fitted data) ------%
%{
if sum(ismember(models,'VAJ')) ~= 0
    components = {'V','A','J'};
    figure(160);clf;set(gcf,'pos',[20 200 1800 600]);
    [~,h_subplot] = tight_subplot(1,3,0.05,0.3);
    for inx = 1:length(components)
        
        axes(h_subplot(inx));
        eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitTrans_spatial_VAJ.',components{inx},');']);
        a = cell2mat(struct2cell(PSTH3Dmodel{stimTypeInx}.modelFitTrans_spatial_VAJ));
        caxis([min(min(a)) max(max(a))]);
        colorbar;
        %     set(gca, 'linecolor' , 'w');
        set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
        set(gca, 'xtick', [] );
        set(gca, 'ytick', [] );
        box off;
        title(['Component -  ',components{inx}]);
    end
    % text on the figure
    axes('unit','pixels','pos',[60 470 1400 100]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(11,16,'Spatial kernel(T)','fontsize',40);
        case 112
            text(11,16,'Spatial kernel(R)','fontsize',40);
    end
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  VAJ model_','    ',stimType{stimTypeInx}];
    text(50,14,str1,'fontsize',18);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAJ;']);
    text(60,7,['R^2 = ',num2str(R_squared)],'fontsize',18);
    axis off;
    
    % axes('unit','pixels','pos',[60 50 1000 100]);
    % xlim([0,100]);
    % ylim([0,10]);
    % text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    % text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    % axis off;
    
    % to save the figures
    str3 = [str, '_VAJmodel_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_Contour_T'];
        saveas(160,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_Contour_R'];
        saveas(160,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end
else
    disp('No VAJ model!');
end
%}


% ------ fig.170 plot V,A,J for VAJ model (PSTH) ------%
%{
if sum(ismember(models,'VAJ')) ~= 0
    components = {'V','A','J'};
    color_com = {'r',colorDBlue,colorDOrange};
    for m_inx = 1:length(components)
        %     figure(170+m_inx);clf;set(gcf,'pos',[20+(m_inx-1)*910 200 900 500]);
        figure(170+m_inx);clf;set(gcf,'pos',[0 0 1900 1000]);
        [~,h_subplot] = tight_subplot(5,9,0.04,0.15);
        
        for j = 2:length(unique_elevation)-1
            for i = 1:length(unique_azimuth)
                axes(h_subplot(i+(j-1)*9));hold on;
                bar(squeeze(PSTH_data(j,iAzi(i),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
                for n = 1:size(markers,1)
                    plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
                    hold on;
                end
                eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAJ.',components{m_inx},'(',num2str(j),',',num2str(iAzi(i)),',:)));']);
                %             set(h,'linestyle','-','marker','.','color',models_color{m_inx},'markersize',8);
                set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
                %                 keyboard;
                set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
                axis on;
                
                set(gca,'xtick',[],'xticklabel',[]);
                
            end
        end
        
        % 2 extra conditions
        axes(h_subplot(5+(1-1)*9));hold on;
        bar(squeeze(PSTH_data(1,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAJ.',components{m_inx},'(',num2str(1),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        axes(h_subplot(5+(5-1)*9));hold on;
        bar(squeeze(PSTH_data(5,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAJ.',components{m_inx},'(',num2str(5),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        %     % sponteneous
        %     axes(h_subplot(1+(1-1)*9));hold on;
        %     bar(temp_spon,'facecolor',colorLGray,'edgecolor',colorLGray);
        %     %     for n = 1:size(markers,1)
        %     %         plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',0.5);
        %     %         hold on;
        %     %     end
        %     set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        %     axis on;
        % %     SetFigure(25);
        %     set(gca,'xtick',[],'xticklabel',[]);
        
        
        % text on the figure
        axes('unit','pixels','pos',[60 800 1800 100]);
        xlim([0,100]);
        ylim([0,20]);
        switch Protocol
            case 100
                text(30,20,'PSTH (T)','fontsize',18);
            case 112
                text(30,20,'PSTH (R)','fontsize',18);
        end
        %     text(10,2,'Spontaneous','fontsize',30);
        FileNameTemp = num2str(FILE);
        %     FileNameTemp =  FileNameTemp(1:end-4);
        str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
        str1 = [FileNameTemp,'  VAJ model ',components{m_inx},'  ',stimType{stimTypeInx}];
        text(40,20,str1,'fontsize',18);
        eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAJ;']);
        text(70,10,['R^2 = ',num2str(R_squared)],'fontsize',18);
        axis off;
        
        %     axes('unit','pixels','pos',[60 50 1800 100]);
        %     xlim([0,100]);
        %     ylim([0,10]);
        %     %     text(0,0,['Max spk mean FR(Hz): ',num2str(maxSpkRealAll(k))],'fontsize',15);
        %     text(0,10,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
        %     text(0,6,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
        
        %--- this is for annotation - the direction ----%
        %     text(3,0,'\downarrow ','fontsize',30);
        %     text(26,0,'\leftarrow ','fontsize',30);
        %     text(49,0,'\uparrow ','fontsize',30);
        %     text(71,0,'\rightarrow ','fontsize',30);
        %     text(93,0,'\downarrow ','fontsize',30);
        %     text(55,76,'\uparrow ','fontsize',30);
        %     text(55,13,'\downarrow ','fontsize',30);
        axis off;
        %--- this is for annotation - the direction ----%
        
        SetFigure(25);
        % to save the figures
        str3 = [str, '_VAJ_model_',components{m_inx},'_',stimType{stimTypeInx}];
        set(gcf,'paperpositionmode','auto');
        if Protocol == 100
            ss = [str3, '_T'];
            saveas(170+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
        elseif Protocol == 112
            ss = [str3, '_R'];
            saveas(170+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
        end
    end
else
    disp('No VAJ model!');
end
%}

% % ------ fig.180 plot V,A spatial tuning for VA models (Contour, use fitted data,GIF) 未完成，不能用5*8的spatial画 要用PSTH ------%
%{
if sum(ismember(models,'VA')) ~= 0
components = {'V','A'};

pic_num = 1;
for ii = stimOnBin : stimOffBin
        clf;
        figure(180);clf;set(gcf,'pos',[120 200 1400 600]);
[~,h_subplot] = tight_subplot(1,2,0.1,0.3);
for inx = 1:length(components)
    
    axes(h_subplot(inx));
    eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitTrans_spatial_VA.',components{inx},');']);
    a = cell2mat(struct2cell(PSTH3Dmodel{stimTypeInx}.modelFitTrans_spatial_VA));
    caxis([min(min(a)) max(max(a))]);
    colorbar;
%         set(gca, 'linestyleOrder' , 'none');
    set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
    title(gca,[components{inx},'  t = ',num2str((ii*timeStep-tOffset1)/1000),' s']);
    set(gca, 'xtick', [] );
    set(gca, 'ytick', [] );
    box off;
%     title(['Component -  ',components{inx}]);
end
% text on the figure
axes('unit','pixels','pos',[60 470 1400 100]);
xlim([0,100]);
ylim([0,20]);
switch Protocol
    case 100
        text(11,16,'Spatial kernel(T)','fontsize',20);
    case 112
        text(11,16,'Spatial kernel(R)','fontsize',20);
end
FileNameTemp = num2str(FILE);
%     FileNameTemp =  FileNameTemp(1:end-4);
str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
str1 = [FileNameTemp,'  VA model_','    ',stimType{stimTypeInx}];
text(50,14,str1,'fontsize',18);
eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VA;']);
text(60,7,['R^2 = ',num2str(R_squared)],'fontsize',18);
axis off;

% axes('unit','pixels','pos',[60 50 1000 100]);
% xlim([0,100]);
% ylim([0,10]);
% text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
% text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
% axis off;

drawnow;
        
        F=getframe(gcf);
        I=frame2im(F);
        [I,map]=rgb2ind(I,256);
% to save the figures
str3 = [str, '_VAmodel_',stimType{stimTypeInx}];
set(gcf,'paperpositionmode','auto');
if Protocol == 100
    ss = [str3, '_Contour_T'];
    file = ['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\Translation\' ss,'.gif'];
elseif Protocol == 112
    ss = [str3, '_Contour_R'];
    saveas(180,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning\Translation\' ss], 'emf');
end
if pic_num == 1
            imwrite(I,map, file,'gif', 'Loopcount',inf,'DelayTime',0.2);
        else
            imwrite(I,map, file,'gif','WriteMode','append','DelayTime',0.2);
        end
pic_num = pic_num + 1;
end
else
    disp('No VA model!');
end
%}

% ------ fig.190 plot V,A,P spatial tuning for VAP models (Contour, use fitted data) ------%
%{
if sum(ismember(models,'VAP')) ~= 0
    components = {'V','A','P'};
    figure(190);clf;set(gcf,'pos',[20 200 1800 600]);
    [~,h_subplot] = tight_subplot(1,3,0.05,0.3);
    for inx = 1:length(components)
        
        axes(h_subplot(inx));
        eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitTrans_spatial_VAP.',components{inx},');']);
        a = cell2mat(struct2cell(PSTH3Dmodel{stimTypeInx}.modelFitTrans_spatial_VAP));
        caxis([min(min(a)) max(max(a))]);
        colorbar;
        %     set(gca, 'linecolor' , 'w');
        set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
        set(gca, 'xtick', [] );
        set(gca, 'ytick', [] );
        box off;
        title(['Component -  ',components{inx}]);
    end
    % text on the figure
    axes('unit','pixels','pos',[60 470 1400 100]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(11,16,'Spatial kernel(T)','fontsize',40);
        case 112
            text(11,16,'Spatial kernel(R)','fontsize',40);
    end
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  VAP model_','    ',stimType{stimTypeInx}];
    text(50,14,str1,'fontsize',18);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAP;']);
    text(60,7,['R^2 = ',num2str(R_squared)],'fontsize',18);
    axis off;
    
    % axes('unit','pixels','pos',[60 50 1000 100]);
    % xlim([0,100]);
    % ylim([0,10]);
    % text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    % text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    % axis off;
    
    % to save the figures
    str3 = [str, '_VAPmodel_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_Contour_T'];
        saveas(190,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_Contour_R'];
        saveas(190,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end
else
    disp('No VAP model!');
end
%}


% ------ fig.200 plot V,A,P for VAP model (PSTH) ------%
%{
if sum(ismember(models,'VAP')) ~= 0
    components = {'V','A','P'};
    color_com = {'r',colorDBlue,colorDOrange};
    for m_inx = 1:length(components)
        %     figure(200+m_inx);clf;set(gcf,'pos',[20+(m_inx-1)*910 200 900 500]);
        figure(200+m_inx);clf;set(gcf,'pos',[0 0 1900 1000]);
        [~,h_subplot] = tight_subplot(5,9,0.04,0.15);
        
        for j = 2:length(unique_elevation)-1
            for i = 1:length(unique_azimuth)
                axes(h_subplot(i+(j-1)*9));hold on;
                bar(squeeze(PSTH_data(j,iAzi(i),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
                for n = 1:size(markers,1)
                    plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
                    hold on;
                end
                eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAP.',components{m_inx},'(',num2str(j),',',num2str(iAzi(i)),',:)));']);
                %             set(h,'linestyle','-','marker','.','color',models_color{m_inx},'markersize',8);
                set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
                %                 keyboard;
                set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
                axis on;
                
                set(gca,'xtick',[],'xticklabel',[]);
                
            end
        end
        
        % 2 extra conditions
        axes(h_subplot(5+(1-1)*9));hold on;
        bar(squeeze(PSTH_data(1,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAP.',components{m_inx},'(',num2str(1),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        axes(h_subplot(5+(5-1)*9));hold on;
        bar(squeeze(PSTH_data(5,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_VAP.',components{m_inx},'(',num2str(5),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        %     % sponteneous
        %     axes(h_subplot(1+(1-1)*9));hold on;
        %     bar(temp_spon,'facecolor',colorLGray,'edgecolor',colorLGray);
        %     %     for n = 1:size(markers,1)
        %     %         plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',0.5);
        %     %         hold on;
        %     %     end
        %     set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        %     axis on;
        % %     SetFigure(25);
        %     set(gca,'xtick',[],'xticklabel',[]);
        
        
        % text on the figure
        axes('unit','pixels','pos',[60 800 1800 100]);
        xlim([0,100]);
        ylim([0,20]);
        switch Protocol
            case 100
                text(30,20,'PSTH (T)','fontsize',18);
            case 112
                text(30,20,'PSTH (R)','fontsize',18);
        end
        %     text(10,2,'Spontaneous','fontsize',30);
        FileNameTemp = num2str(FILE);
        %     FileNameTemp =  FileNameTemp(1:end-4);
        str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
        str1 = [FileNameTemp,'  VAP model ',components{m_inx},'  ',stimType{stimTypeInx}];
        text(40,20,str1,'fontsize',18);
        eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_VAP;']);
        text(70,10,['R^2 = ',num2str(R_squared)],'fontsize',18);
        axis off;
        
        %     axes('unit','pixels','pos',[60 50 1800 100]);
        %     xlim([0,100]);
        %     ylim([0,10]);
        %     %     text(0,0,['Max spk mean FR(Hz): ',num2str(maxSpkRealAll(k))],'fontsize',15);
        %     text(0,10,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
        %     text(0,6,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
        
        %--- this is for annotation - the direction ----%
        %     text(3,0,'\downarrow ','fontsize',30);
        %     text(26,0,'\leftarrow ','fontsize',30);
        %     text(49,0,'\uparrow ','fontsize',30);
        %     text(71,0,'\rightarrow ','fontsize',30);
        %     text(93,0,'\downarrow ','fontsize',30);
        %     text(55,76,'\uparrow ','fontsize',30);
        %     text(55,13,'\downarrow ','fontsize',30);
        axis off;
        %--- this is for annotation - the direction ----%
        
        SetFigure(25);
        % to save the figures
        str3 = [str, '_VAP_model_',components{m_inx},'_',stimType{stimTypeInx}];
        set(gcf,'paperpositionmode','auto');
        if Protocol == 100
            ss = [str3, '_T'];
            saveas(200+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
        elseif Protocol == 112
            ss = [str3, '_R'];
            saveas(200+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
        end
    end
else
    disp('No VAP model!');
end
%}

% ------ fig.210 plot V,A,J,P spatial tuning for PVAJ models (Contour, use fitted data) ------%
%{
if sum(ismember(models,'PVAJ')) ~= 0
    components = {'V','A','J','P'};
    figure(210);clf;set(gcf,'pos',[20 220 1800 600]);
    [~,h_subplot] = tight_subplot(1,4,0.05,0.3);
    for inx = 1:length(components)
        
        axes(h_subplot(inx));
        eval(['h = contourf(xAzi,yEle,PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitTrans_spatial_PVAJ.',components{inx},');']);
        a = cell2mat(struct2cell(PSTH3Dmodel{stimTypeInx}.modelFitTrans_spatial_PVAJ));
        caxis([min(min(a)) max(max(a))]);
        colorbar;
        %     set(gca, 'linecolor' , 'w');
        set(gca, 'ydir' , 'reverse'); % so that up is up, down is down
        set(gca, 'xtick', [] );
        set(gca, 'ytick', [] );
        box off;
        title(['Component -  ',components{inx}]);
    end
    % text on the figure
    axes('unit','pixels','pos',[60 470 1400 100]);
    xlim([0,100]);
    ylim([0,20]);
    switch Protocol
        case 100
            text(11,16,'Spatial kernel(T)','fontsize',40);
        case 112
            text(11,16,'Spatial kernel(R)','fontsize',40);
    end
    FileNameTemp = num2str(FILE);
    %     FileNameTemp =  FileNameTemp(1:end-4);
    str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
    str1 = [FileNameTemp,'  PVAJ model_','    ',stimType{stimTypeInx}];
    text(50,14,str1,'fontsize',18);
    eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_PVAJ;']);
    text(60,7,['R^2 = ',num2str(R_squared)],'fontsize',18);
    axis off;
    
    % axes('unit','pixels','pos',[60 50 1000 100]);
    % xlim([0,100]);
    % ylim([0,10]);
    % text(0,3,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
    % text(0,-1,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
    % axis off;
    
    % to save the figures
    str3 = [str, '_PVAJmodel_',stimType{stimTypeInx}];
    set(gcf,'paperpositionmode','auto');
    if Protocol == 100
        ss = [str3, '_Contour_T'];
        saveas(210,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
    elseif Protocol == 112
        ss = [str3, '_Contour_R'];
        saveas(210,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
    end
else
    disp('No PVAJ model!');
end
%}


% ------ fig.220 plot V,A,J,P for PVAJ model (PSTH) ------%
%{
if sum(ismember(models,'PVAJ')) ~= 0
    components = {'V','A','J','P'};
    color_com = {'r',colorDBlue,colorDOrange,colorDGray};
    for m_inx = 1:length(components)
        %     figure(220+m_inx);clf;set(gcf,'pos',[20+(m_inx-1)*910 220 900 500]);
        figure(220+m_inx);clf;set(gcf,'pos',[0 0 1900 1000]);
        [~,h_subplot] = tight_subplot(5,9,0.04,0.15);
        
        for j = 2:length(unique_elevation)-1
            for i = 1:length(unique_azimuth)
                axes(h_subplot(i+(j-1)*9));hold on;
                bar(squeeze(PSTH_data(j,iAzi(i),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
                for n = 1:size(markers,1)
                    plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
                    hold on;
                end
                eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_PVAJ.',components{m_inx},'(',num2str(j),',',num2str(iAzi(i)),',:)));']);
                %             set(h,'linestyle','-','marker','.','color',models_color{m_inx},'markersize',8);
                set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
                %                 keyboard;
                set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
                axis on;
                
                set(gca,'xtick',[],'xticklabel',[]);
                
            end
        end
        
        % 2 extra conditions
        axes(h_subplot(5+(1-1)*9));hold on;
        bar(squeeze(PSTH_data(1,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_PVAJ.',components{m_inx},'(',num2str(1),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        axes(h_subplot(5+(5-1)*9));hold on;
        bar(squeeze(PSTH_data(5,iAzi(5),:)),'facecolor',colorLGray,'edgecolor',colorLGray);
        for n = 1:size(markers,1)
            plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',3);
            hold on;
        end
        eval(['h = plot(1:nBins,squeeze(PSTH3Dmodel{',num2str(stimTypeInx),'}.modelFitMeanTrans_PVAJ.',components{m_inx},'(',num2str(5),',',num2str(iAzi(5)),',:)));']);
        %     set(h,'linestyle','none','marker','.','color',models_color{m_inx},'markersize',8);
        set(h,'linestyle','-','linewidth',4,'color',color_com{m_inx});
        set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        axis on;
        %     SetFigure(25);
        set(gca,'xtick',[],'xticklabel',[]);
        
        
        %     % sponteneous
        %     axes(h_subplot(1+(1-1)*9));hold on;
        %     bar(temp_spon,'facecolor',colorLGray,'edgecolor',colorLGray);
        %     %     for n = 1:size(markers,1)
        %     %         plot([markers{n,2} markers{n,2}], [0,max(PSTH.maxSpkRealBinMean(stimTypeInx),PSTH.maxSpkSponBinMean)], '--','color',markers{n,3},'linewidth',0.5);
        %     %         hold on;
        %     %     end
        %     set(gca,'ylim',[0 max(max(PSTH_data(:)),max(temp_spon))+5],'xlim',[1 nBins]);
        %     axis on;
        % %     SetFigure(25);
        %     set(gca,'xtick',[],'xticklabel',[]);
        
        
        % text on the figure
        axes('unit','pixels','pos',[60 800 1800 100]);
        xlim([0,100]);
        ylim([0,20]);
        switch Protocol
            case 100
                text(30,20,'PSTH (T)','fontsize',18);
            case 112
                text(30,20,'PSTH (R)','fontsize',18);
        end
        %     text(10,2,'Spontaneous','fontsize',30);
        FileNameTemp = num2str(FILE);
        %     FileNameTemp =  FileNameTemp(1:end-4);
        str = [FileNameTemp, '_',num2str(SpikeChan),'_'];
        str1 = [FileNameTemp,'  PVAJ model ',components{m_inx},'  ',stimType{stimTypeInx}];
        text(40,20,str1,'fontsize',18);
        eval(['R_squared = ','PSTH3Dmodel{',num2str(stimTypeInx),'}.RSquared_PVAJ;']);
        text(70,10,['R^2 = ',num2str(R_squared)],'fontsize',18);
        axis off;
        
        %     axes('unit','pixels','pos',[60 50 1800 100]);
        %     xlim([0,100]);
        %     ylim([0,10]);
        %     %     text(0,0,['Max spk mean FR(Hz): ',num2str(maxSpkRealAll(k))],'fontsize',15);
        %     text(0,10,['Spon max mean FR(Hz): ',num2str(max(temp_spon))],'fontsize',15);
        %     text(0,6,['Spon mean FR(Hz): ',num2str(meanSpon)],'fontsize',15);
        
        %--- this is for annotation - the direction ----%
        %     text(3,0,'\downarrow ','fontsize',30);
        %     text(26,0,'\leftarrow ','fontsize',30);
        %     text(49,0,'\uparrow ','fontsize',30);
        %     text(71,0,'\rightarrow ','fontsize',30);
        %     text(93,0,'\downarrow ','fontsize',30);
        %     text(55,76,'\uparrow ','fontsize',30);
        %     text(55,13,'\downarrow ','fontsize',30);
        axis off;
        %--- this is for annotation - the direction ----%
        
        SetFigure(25);
        % to save the figures
        str3 = [str, '_PVAJ_model_',components{m_inx},'_',stimType{stimTypeInx}];
        set(gcf,'paperpositionmode','auto');
        if Protocol == 100
            ss = [str3, '_T'];
            saveas(220+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Translation\' ss], 'emf');
        elseif Protocol == 112
            ss = [str3, '_R'];
            saveas(220+m_inx,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning_models\',model_catg,'\Rotation\' ss], 'emf');
        end
    end
else
    disp('No PVAJ model!');
end
%}

