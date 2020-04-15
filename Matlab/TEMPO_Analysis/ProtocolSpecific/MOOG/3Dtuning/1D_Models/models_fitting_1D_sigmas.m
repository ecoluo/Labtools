% Model-fitting for 3D tuning PSTH
% models = {'VO','AO','VA','VJ','AJ','VAJ','PVAJ'};
% LBY 20200407



function models_fitting_1D_sigmas(model_catg,models,models_color,FILE,SpikeChan, Protocol,nSigmaInx,meanSpon,PSTH_data,spatial_data,temp_spon,nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,duration,nSigma,sig)

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
            eval(['[PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFitRespon_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFit_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFit_spatial',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFitPara_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.BIC_',models{m_inx},...
                ',PSTH1Dmodel{',num2str(nSigmaInx),'}.RSquared_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.rss_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.time, PSTH1Dmodel{',num2str(nSigmaInx),'}.',models{m_inx},'_peak_A_T]=fit',models{m_inx},...
                '_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration,sig);']);
            % [PSTH1Dmodel{1}.modelFitRespon_VO,PSTH1Dmodel{1}.modelFitPara_VO,PSTH1Dmodel{1}.BIC_VO,PSTH1Dmodel{1}.RSquared_VO,PSTH1Dmodel{1}.rss_VO,PSTH1Dmodel{1}.time]=fitVO_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
    case 'Out-sync model'
        for m_inx = 1:length(models)
            eval(['[PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFitRespon_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFit_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFit_spatial',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.modelFitPara_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.BIC_',models{m_inx},...
                ',PSTH1Dmodel{',num2str(nSigmaInx),'}.RSquared_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.rss_',models{m_inx},',PSTH1Dmodel{',num2str(nSigmaInx),'}.time, PSTH1Dmodel{',num2str(nSigmaInx),'}.',models{m_inx},'_peak_A_T]=fit',models{m_inx},'_O',...
                '_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration,sig);']);
            % [PSTH1Dmodel{1}.modelFitRespon_VO,PSTH1Dmodel{1}.modelFitPara_VO,PSTH1Dmodel{1}.BIC_VO,PSTH1Dmodel{1}.RSquared_VO,PSTH1Dmodel{1}.rss_VO,PSTH1Dmodel{1}.time]=fitVO_1D(meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
end

% %{
% for plotting figures
% transform for figures

% % 270-225-180-135-90-45-0-315-270 for figures
% % iAzi = [7 6 5 4 3 2 1 8 7];
iAzi = [7 6 5 4 3 2 1 8];


if sum(ismember(models,'PVAJ')) ~= 0
    % for PSTH plots of V, A, J, P respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.V = PSTH1Dmodel{nSigmaInx}.modelFit_PVAJ.V;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.A = PSTH1Dmodel{nSigmaInx}.modelFit_PVAJ.A;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.J = PSTH1Dmodel{nSigmaInx}.modelFit_PVAJ.J;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.P = PSTH1Dmodel{nSigmaInx}.modelFit_PVAJ.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_PVAJ.V(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.V(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_PVAJ.A(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.A(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_PVAJ.J(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.J(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_PVAJ.P(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_PVAJ.P(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, J, P respectively
    % % only use spatial fitted data
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.V = PSTH1Dmodel{nSigmaInx}.modelFit_spatialPVAJ.V;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.A = PSTH1Dmodel{nSigmaInx}.modelFit_spatialPVAJ.A;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.J = PSTH1Dmodel{nSigmaInx}.modelFit_spatialPVAJ.J;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.P = PSTH1Dmodel{nSigmaInx}.modelFit_spatialPVAJ.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_PVAJ.V(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.V(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_PVAJ.A(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.A(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_PVAJ.J(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.J(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_PVAJ.P(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_PVAJ.P(iAzi(i));
        
    end
end

if sum(ismember(models,'VAJ')) ~= 0
    % for PSTH plots of V, A, J respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.V = PSTH1Dmodel{nSigmaInx}.modelFit_VAJ.V;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.A = PSTH1Dmodel{nSigmaInx}.modelFit_VAJ.A;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.J = PSTH1Dmodel{nSigmaInx}.modelFit_VAJ.J;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAJ.V(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.V(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAJ.A(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.A(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAJ.J(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAJ.J(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, J respectively
    % % only use spatial fitted data
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.V = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAJ.V;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.A = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAJ.A;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.J = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAJ.J;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAJ.V(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.V(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAJ.A(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.A(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAJ.J(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAJ.J(iAzi(i));
        
    end
end

if sum(ismember(models,'VAP')) ~= 0
    % for PSTH plots of V, A, P respectively
    % use spatial-temporal data
    
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.V = PSTH1Dmodel{nSigmaInx}.modelFit_VAP.V;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.A = PSTH1Dmodel{nSigmaInx}.modelFit_VAP.A;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.P = PSTH1Dmodel{nSigmaInx}.modelFit_VAP.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAP.V(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.V(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAP.A(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.A(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VAP.P(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VAP.P(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A, P respectively
    % % only use spatial fitted data
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.V = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAP.V;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.A = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAP.A;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.P = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVAP.P;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAP.V(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.V(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAP.A(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.A(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VAP.P(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VAP.P(iAzi(i));
        
    end
end

if sum(ismember(models,'VA')) ~= 0
    % for PSTH plots of V, A respectively
    % use spatial-temporal data
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VA.V = PSTH1Dmodel{nSigmaInx}.modelFit_VA.V;
    PSTH1Dmodel{nSigmaInx}.modelFitMean_VA.A = PSTH1Dmodel{nSigmaInx}.modelFit_VA.A;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VA.V(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VA.V(iAzi(i),:);
        PSTH1Dmodel{nSigmaInx}.modelFitMeanTrans_VA.A(i,:) = PSTH1Dmodel{nSigmaInx}.modelFitMean_VA.A(iAzi(i),:);
    end
    
    
    % % for contour plots of V, A respectively
    % % only use spatial fitted data
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VA.V = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVA.V;
    PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VA.A = PSTH1Dmodel{nSigmaInx}.modelFit_spatialVA.A;
    
    for i = 1:length(iAzi)
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VA.V(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VA.V(iAzi(i));
        PSTH1Dmodel{nSigmaInx}.modelFitTrans_spatial_VA.A(i) = PSTH1Dmodel{nSigmaInx}.modelFit_spatial_VA.A(iAzi(i));
        
    end
end

% % keyboard;
models_figure_1D_sigmas;
%}
end
