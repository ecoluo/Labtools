% Model-fitting for 3D tuning PSTH
% models = {'VO','AO','VA','VJ','AJ','VAJ','PVAJ'};
% LBY 20170329
% LBY 20170603,0607
% LBY 201806



function models_fitting_1D(model_catg,models,models_color,FILE,SpikeChan, Protocol,stimTypeInx,meanSpon,PSTH_data,spatial_data,temp_spon,nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,duration)

global PSTH PSTH1Dmodel;

PSTH.monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch PSTH.monkey_inx
    case '5'
        PSTH.monkey = 'Polo';
    case '6'
        PSTH.monkey = 'Qiaoqiao';
end

switch model_catg
    
    case 'Sync model'
        for m_inx = 1:length(models)
            eval(['[PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFit_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFit_spatial',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitPara_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.BIC_',models{m_inx},...
                ',PSTH1Dmodel{',num2str(stimTypeInx),'}.RSquared_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.rss_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.time]=fit',models{m_inx},...
                '_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration);']);
            % [PSTH1Dmodel{1}.modelFitRespon_VO,PSTH1Dmodel{1}.modelFitPara_VO,PSTH1Dmodel{1}.BIC_VO,PSTH1Dmodel{1}.RSquared_VO,PSTH1Dmodel{1}.rss_VO,PSTH1Dmodel{1}.time]=fitVO_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
    case 'Out-sync model'
        for m_inx = 1:length(models)
            eval(['[PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFit_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFit_spatial',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitPara_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.BIC_',models{m_inx},...
                ',PSTH1Dmodel{',num2str(stimTypeInx),'}.RSquared_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.rss_',models{m_inx},',PSTH1Dmodel{',num2str(stimTypeInx),'}.time]=fit',models{m_inx},'_O',...
                '_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration);']);
            % [PSTH1Dmodel{1}.modelFitRespon_VO,PSTH1Dmodel{1}.modelFitPara_VO,PSTH1Dmodel{1}.BIC_VO,PSTH1Dmodel{1}.RSquared_VO,PSTH1Dmodel{1}.rss_VO,PSTH1Dmodel{1}.time]=fitVO_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
end

% %{
% for plotting figures
% transform for figures

% % 270-225-180-135-90-45-0-315-270 for figures
% % iAzi = [7 6 5 4 3 2 1 8 7];
iAzi = [7 6 5 4 3 2 1 8];
%
% for m_inx = 1:length(models)
%     % add the 9th
%     % PSTH1Dmodel{1}.modelFitRespon_VO= [PSTH1Dmodel{1}.modelFitRespon_VO;PSTH1Dmodel{1}.modelFitRespon_VO(1,:,:)];
%     eval(['PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'= [PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',...
%         models{m_inx},';PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'(1,:,:)];']);
%     % transform
%     % PSTH1Dmodel{1}.modelFitRespon_VO= permute(PSTH1Dmodel{1}.modelFitRespon_VO,[2 1 3]);
%     eval(['PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',models{m_inx},'= permute(PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',...
%         models{m_inx},',[2 1 3]);']);
%     % for contour
%     % PSTH1Dmodel{1}.modelFitResponMean_VAJ= squeeze(nanmean(PSTH1Dmodel{1}.modelFitRespon_VAJ,3));
%     eval(['PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitResponMean_',models{m_inx},'= squeeze(nanmean(PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitRespon_',...
%         models{m_inx},',3));']);
%     % transform
%     % PSTH1Dmodel{1}.modelFitResponMeanTrans_VAJ(:,1)= PSTH1Dmodel{1}.modelFitResponMean_VAJ(:,7);
%     for i = 1:length(iAzi)
%         eval(['PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitResponMeanTrans_',models{m_inx},'(:,',num2str(i),')= PSTH1Dmodel{',num2str(stimTypeInx),'}.modelFitResponMean_',...
%             models{m_inx},'(:,',num2str(iAzi(i)),');']);
%
%     end
%
% end

% % for contour plots of V, A, J respectively
% % use spatial-temporal data
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_V = squeeze(permute(nanmean(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.V,3),[2,1,3]));
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_A = squeeze(permute(nanmean(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.A,3),[2,1,3]));
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_J = squeeze(permute(nanmean(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.J,3),[2,1,3]));
% for i = 1:length(iAzi)
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_V(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_V(:,iAzi(i));
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_A(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_A(:,iAzi(i));
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_J(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_J(:,iAzi(i))*(-1);
% end


% % for contour plots of V, A, J respectively at peak times
% aMaxBin = round((125+(PSTH1Dmodel{stimTypeInx}.modelFitPara_VAJ(3)-PSTH1Dmodel{stimTypeInx}.modelFitPara_VAJ(4))*1000)/25);
% vMaxBin = round((125+(PSTH1Dmodel{stimTypeInx}.modelFitPara_VAJ(3))*1000)/25);
% jMaxBin = vMaxBin;
%
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_V_peakT = squeeze(permute(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.V(:,:,vMaxBin),[2,1,3]));
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_A_peakT = squeeze(permute(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.A(:,:,aMaxBin),[2,1,3]));
% PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_J_peakT = squeeze(permute(PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.J(:,:,jMaxBin),[2,1,3]));
% for i = 1:length(iAzi)
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_V_peakT(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_V_peakT(:,iAzi(i));
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_A_peakT(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_A_peakT(:,iAzi(i));
%     PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ_J_peakT(:,i) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ_J_peakT(:,iAzi(i));
% end

if sum(ismember(models,'PVAJ')) ~= 0
    % for PSTH plots of V, A, J, P respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.V = PSTH1Dmodel{stimTypeInx}.modelFit_PVAJ.V;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.A = PSTH1Dmodel{stimTypeInx}.modelFit_PVAJ.A;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.J = PSTH1Dmodel{stimTypeInx}.modelFit_PVAJ.J;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.P = PSTH1Dmodel{stimTypeInx}.modelFit_PVAJ.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_PVAJ.V(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.V(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_PVAJ.A(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.A(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_PVAJ.J(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.J(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_PVAJ.P(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_PVAJ.P(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, J, P respectively
    % % only use spatial fitted data
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.V = PSTH1Dmodel{stimTypeInx}.modelFit_spatialPVAJ.V;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.A = PSTH1Dmodel{stimTypeInx}.modelFit_spatialPVAJ.A;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.J = PSTH1Dmodel{stimTypeInx}.modelFit_spatialPVAJ.J;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.P = PSTH1Dmodel{stimTypeInx}.modelFit_spatialPVAJ.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_PVAJ.V(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.V(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_PVAJ.A(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.A(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_PVAJ.J(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.J(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_PVAJ.P(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_PVAJ.P(iAzi(i));
        
    end
end

if sum(ismember(models,'VAJ')) ~= 0
    % for PSTH plots of V, A, J respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.V = PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.V;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.A = PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.A;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.J = PSTH1Dmodel{stimTypeInx}.modelFit_VAJ.J;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ.V(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.V(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ.A(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.A(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAJ.J(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAJ.J(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, J respectively
    % % only use spatial fitted data
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.V = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAJ.V;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.A = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAJ.A;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.J = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAJ.J;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAJ.V(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.V(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAJ.A(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.A(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAJ.J(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAJ.J(iAzi(i));
        
    end
end

if sum(ismember(models,'VAP')) ~= 0
    % for PSTH plots of V, A, P respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.V = PSTH1Dmodel{stimTypeInx}.modelFit_VAP.V;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.A = PSTH1Dmodel{stimTypeInx}.modelFit_VAP.A;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.P = PSTH1Dmodel{stimTypeInx}.modelFit_VAP.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAP.V(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.V(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAP.A(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.A(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VAP.P(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VAP.P(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, P respectively
    % % only use spatial fitted data
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.V = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAP.V;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.A = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAP.A;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.P = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVAP.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAP.V(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.V(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAP.A(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.A(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VAP.P(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VAP.P(iAzi(i));
        
    end
end

if sum(ismember(models,'VA')) ~= 0
    % for PSTH plots of V, A respectively
    % use spatial-temporal data
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VA.V = PSTH1Dmodel{stimTypeInx}.modelFit_VA.V;
    PSTH1Dmodel{stimTypeInx}.modelFitMean_VA.A = PSTH1Dmodel{stimTypeInx}.modelFit_VA.A;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VA.V(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VA.V(iAzi(i),:);
        PSTH1Dmodel{stimTypeInx}.modelFitMeanTrans_VA.A(i,:) = PSTH1Dmodel{stimTypeInx}.modelFitMean_VA.A(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A respectively
    % % only use spatial fitted data
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VA.V = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVA.V;
    PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VA.A = PSTH1Dmodel{stimTypeInx}.modelFit_spatialVA.A;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VA.V(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VA.V(iAzi(i));
        PSTH1Dmodel{stimTypeInx}.modelFitTrans_spatial_VA.A(i) = PSTH1Dmodel{stimTypeInx}.modelFit_spatial_VA.A(iAzi(i));
        
    end
end

% % keyboard;
% models_figure_1D;
%}
end
