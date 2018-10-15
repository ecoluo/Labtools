% population analysis of those 3D models
% VAJ, VA, VJ, AJ, VO, AO
% Protocol: 1->translation, 2-> rotation
% models = {'VO','AO','VA','VJ','AJ','VAJ','PVAJ'};
% LBY 20171130

clear all;
%% load data & pack data

Model_catg = 2;
switch Model_catg
    case 1
        cd('Z:\Data\TEMPO\BATCH\Polo_3DTuning\Sync model');
        load('Z:\Data\TEMPO\BATCH\Polo_3DTuning\Sync model\PSTH_OriData.mat');
    case 2
        cd('Z:\Data\TEMPO\BATCH\Polo_3DTuning\Out-sync model');
        load('Z:\Data\TEMPO\BATCH\Polo_3DTuning\Out-sync model\PSTH_OriData.mat');
end

Monkey = 'Polo';

% models = {'VO','AO','VA','VJ','AJ','VAJ','PVAJ'};
% models = {'VO','AO','VJ','AJ','VA','VAJ'};
models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
% models = {'VO','AO','VA','VAJ'};
global PSTH3Dmodel PSTH;

%%%%%%%%%%%%%%%%%%%%%%%%%% for Translation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_vestiNo = 0;
T_visNo = 0;
for cell_inx = 1:length(Polo_3DTuning_T)
    T_model(cell_inx).name = Polo_3DTuning_T(cell_inx).name;
    T_model(cell_inx).ch = Polo_3DTuning_T(cell_inx).ch;
    
    % for Translation - Vestibular
    if ~isempty(find(Polo_3DTuning_T(cell_inx).stimType == 1))
        T_model(cell_inx).vestiPSTH3Dmodel = Polo_3DTuning_T(cell_inx).PSTH3Dmodel{find(Polo_3DTuning_T(cell_inx).stimType == 1)};
    else
        T_model(cell_inx).vestiPSTH3Dmodel = nan;
    end
    % for Translation - Visual
    if ~isempty(find(Polo_3DTuning_T(cell_inx).stimType == 2))
        T_model(cell_inx).visPSTH3Dmodel = Polo_3DTuning_T(cell_inx).PSTH3Dmodel{find(Polo_3DTuning_T(cell_inx).stimType == 2)};
    else
        T_model(cell_inx).visPSTH3Dmodel = nan;
    end
    
    if isstruct(T_model(cell_inx).vestiPSTH3Dmodel)
        T_vestiNo = T_vestiNo+1;
        T_model(cell_inx).vestiSig = 1;
        % Partial R_squared
        T_PartR2_VAT_vesti(cell_inx).R2V = T_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2V;
        T_PartR2_VAT_vesti(cell_inx).R2A = T_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2A;
        T_PartR2_VAT_vesti(cell_inx).R2J = T_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2J;
        T_wVAJ_vesti(cell_inx).wV =  T_model(cell_inx).vestiPSTH3Dmodel.VAJ_wV;
        T_wVAJ_vesti(cell_inx).wA =  T_model(cell_inx).vestiPSTH3Dmodel.VAJ_wA;
        T_wVAJ_vesti(cell_inx).wJ =  T_model(cell_inx).vestiPSTH3Dmodel.VAJ_wJ;
        T_wVA_vesti(cell_inx).wV =  T_model(cell_inx).vestiPSTH3Dmodel.VA_wV;
        T_wVA_vesti(cell_inx).wA =  T_model(cell_inx).vestiPSTH3Dmodel.VA_wA;
        T_PartR2VA_vesti(cell_inx).wV =  T_model(cell_inx).vestiPSTH3Dmodel.VA_R2V;
        T_PartR2VA_vesti(cell_inx).wA =  T_model(cell_inx).vestiPSTH3Dmodel.VA_R2A;
        T_spatial_VA_vesti(cell_inx).V =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitTrans_spatial_VA.V;
        T_spatial_VA_vesti(cell_inx).A =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitTrans_spatial_VA.A;
        T_spatial_VA_vesti(cell_inx).V([1 5],2:end) = 0;
        T_spatial_VA_vesti(cell_inx).A([1 5],2:end) = 0;
        [T_preDir_VA_vesti(cell_inx).V(1) T_preDir_VA_vesti(cell_inx).V(2) T_preDir_VA_vesti(cell_inx).V(3)] = vectorsum(T_spatial_VA_vesti(cell_inx).V);
        [T_preDir_VA_vesti(cell_inx).A(1) T_preDir_VA_vesti(cell_inx).A(2) T_preDir_VA_vesti(cell_inx).A(3)] =  vectorsum(T_spatial_VA_vesti(cell_inx).A);
        T_VA_n_vesti(cell_inx).V =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(4);
        T_VA_n_vesti(cell_inx).A =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(8);
        T_VAJ_n_vesti(cell_inx).V =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(4);
        T_VAJ_n_vesti(cell_inx).A =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(8);
        T_VAJ_n_vesti(cell_inx).J =  T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(12);
        if Model_catg == 2
            T_VA_vesti_delayV(cell_inx) = T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(13);
        end
        T_VA_vesti_muA(cell_inx) = T_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(3);
        T_VA_vesti_spatial_V{cell_inx} = T_model(cell_inx).vestiPSTH3Dmodel.modelFit_spatial_VA.V;
        T_VA_vesti_spatial_A{cell_inx} = T_model(cell_inx).vestiPSTH3Dmodel.modelFit_spatial_VA.A;
        
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['T_RSS_vesti(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').vestiPSTH3Dmodel.rss_', models{m_inx} , ';']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['T_Rsquared_vesti(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').vestiPSTH3Dmodel.RSquared_', models{m_inx} , ';']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['T_BIC_vesti(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').vestiPSTH3Dmodel.BIC_', models{m_inx}, ';']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['T_PARA_vesti(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').vestiPSTH3Dmodel.modelFitPara_', models{m_inx}, ';']);
            
        end
    else
        T_model(cell_inx).vestiSig = 0;
        % Partial R_squared
        T_PartR2_VAT_vesti(cell_inx).R2V = nan;
        T_PartR2_VAT_vesti(cell_inx).R2A = nan;
        T_PartR2_VAT_vesti(cell_inx).R2J = nan;
        T_wVAJ_vesti(cell_inx).wV = nan;
        T_wVAJ_vesti(cell_inx).wA = nan;
        T_wVAJ_vesti(cell_inx).wJ = nan;
        T_wVA_vesti(cell_inx).wV = nan;
        T_wVA_vesti(cell_inx).wA = nan;
        T_PartR2VA_vesti(cell_inx).wV =  nan;
        T_PartR2VA_vesti(cell_inx).wA =  nan;
        T_spatial_VA_vesti(cell_inx).V =  nan;
        T_spatial_VA_vesti(cell_inx).A =  nan;
        T_preDir_VA_vesti(cell_inx).V =  nan*ones(1,3);
        T_preDir_VA_vesti(cell_inx).A =  nan*ones(1,3);
        T_VA_n_vesti(cell_inx).V =  nan;
        T_VA_n_vesti(cell_inx).A =  nan;
        T_VAJ_n_vesti(cell_inx).V =  nan;
        T_VAJ_n_vesti(cell_inx).A =  nan;
        T_VAJ_n_vesti(cell_inx).J =  nan;
        if Model_catg == 2
            T_VA_vesti_delayV(cell_inx) = nan;
        end
        T_VA_vesti_muA(cell_inx) = nan;
        T_VA_vesti_spatial_V{cell_inx} = nan;
        T_VA_vesti_spatial_A{cell_inx} = nan;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['T_RSS_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['T_Rsquared_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['T_BIC_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['T_PARA_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            
        end
    end
    
    if isstruct(T_model(cell_inx).visPSTH3Dmodel)
        T_model(cell_inx).visSig = 1;
        T_visNo = T_visNo+1;
        % Partial R_squared
        T_PartR2_VAT_vis(cell_inx).R2V = T_model(cell_inx).visPSTH3Dmodel.VAJ_R2V;
        T_PartR2_VAT_vis(cell_inx).R2A = T_model(cell_inx).visPSTH3Dmodel.VAJ_R2A;
        T_PartR2_VAT_vis(cell_inx).R2J = T_model(cell_inx).visPSTH3Dmodel.VAJ_R2J;
        T_wVAJ_vis(cell_inx).wV =  T_model(cell_inx).visPSTH3Dmodel.VAJ_wV;
        T_wVAJ_vis(cell_inx).wA =  T_model(cell_inx).visPSTH3Dmodel.VAJ_wA;
        T_wVAJ_vis(cell_inx).wJ =  T_model(cell_inx).visPSTH3Dmodel.VAJ_wJ;
        T_wVA_vis(cell_inx).wV =  T_model(cell_inx).visPSTH3Dmodel.VA_wV;
        T_wVA_vis(cell_inx).wA =  T_model(cell_inx).visPSTH3Dmodel.VA_wA;
        T_PartR2VA_vis(cell_inx).wV =  T_model(cell_inx).visPSTH3Dmodel.VA_R2V;
        T_PartR2VA_vis(cell_inx).wA =  T_model(cell_inx).visPSTH3Dmodel.VA_R2A;
        T_spatial_VA_vis(cell_inx).V =  T_model(cell_inx).visPSTH3Dmodel.modelFitTrans_spatial_VA.V;
        T_spatial_VA_vis(cell_inx).A =  T_model(cell_inx).visPSTH3Dmodel.modelFitTrans_spatial_VA.A;
        T_spatial_VA_vis(cell_inx).V([1 5],2:end) = 0;
        T_spatial_VA_vis(cell_inx).A([1 5],2:end) = 0;
        [T_preDir_VA_vis(cell_inx).V(1) T_preDir_VA_vis(cell_inx).V(2) T_preDir_VA_vis(cell_inx).V(3)] =  vectorsum(T_spatial_VA_vis(cell_inx).V);
        [T_preDir_VA_vis(cell_inx).A(1) T_preDir_VA_vis(cell_inx).A(2) T_preDir_VA_vis(cell_inx).A(3)] =  vectorsum(T_spatial_VA_vis(cell_inx).A);
        T_VA_n_vis(cell_inx).V =  T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(4);
        T_VA_n_vis(cell_inx).A =  T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(8);
        T_VAJ_n_vis(cell_inx).V =  T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(4);
        T_VAJ_n_vis(cell_inx).A =  T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(8);
        T_VAJ_n_vis(cell_inx).J =  T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(12);
        if Model_catg == 2
            T_VA_vis_delayV(cell_inx) = T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(13);
        end
        T_VA_vis_muA(cell_inx) = T_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(3);
        T_VA_vis_spatial_V{cell_inx} = T_model(cell_inx).visPSTH3Dmodel.modelFit_spatial_VA.V;
        T_VA_vis_spatial_A{cell_inx} = T_model(cell_inx).visPSTH3Dmodel.modelFit_spatial_VA.A;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['T_RSS_vis(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').visPSTH3Dmodel.rss_', models{m_inx} , ';']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['T_Rsquared_vis(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').visPSTH3Dmodel.RSquared_', models{m_inx} , ';']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['T_BIC_vis(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').visPSTH3Dmodel.BIC_', models{m_inx}, ';']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['T_PARA_vis(',num2str(cell_inx),').', models{m_inx},' = T_model(',num2str(cell_inx),').visPSTH3Dmodel.modelFitPara_', models{m_inx}, ';']);
            
        end
    else
        T_model(cell_inx).visSig = 0;
        % Partial R_squared
        T_PartR2_VAT_vis(cell_inx).R2V = nan;
        T_PartR2_VAT_vis(cell_inx).R2A = nan;
        T_PartR2_VAT_vis(cell_inx).R2J = nan;
        T_wVAJ_vis(cell_inx).wV = nan;
        T_wVAJ_vis(cell_inx).wA = nan;
        T_wVAJ_vis(cell_inx).wJ = nan;
        T_wVA_vis(cell_inx).wV = nan;
        T_wVA_vis(cell_inx).wA = nan;
        T_PartR2VA_vis(cell_inx).wV =  nan;
        T_PartR2VA_vis(cell_inx).wA =  nan;
        T_spatial_VA_vis(cell_inx).V =  nan;
        T_spatial_VA_vis(cell_inx).A =  nan;
        T_preDir_VA_vis(cell_inx).V =  nan*ones(1,3);
        T_preDir_VA_vis(cell_inx).A =  nan*ones(1,3);
        T_VA_n_vis(cell_inx).V =  nan;
        T_VA_n_vis(cell_inx).A =  nan;
        T_VAJ_n_vis(cell_inx).V =  nan;
        T_VAJ_n_vis(cell_inx).A =  nan;
        T_VAJ_n_vis(cell_inx).J =  nan;
        if Model_catg == 2
            T_VA_vis_delayV(cell_inx) = nan;
        end
        T_VA_vis_muA(cell_inx) = nan;
        T_VA_vis_spatial_V{cell_inx} = nan;
        T_VA_vis_spatial_A{cell_inx} = nan;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['T_RSS_vis(',num2str(cell_inx),').', models{m_inx}, ' = nan;']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['T_Rsquared_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['T_BIC_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['T_PARA_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
        end
    end
end

disp('T model data loaded SUCCESS!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for Rotation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_vestiNo = 0;
R_visNo = 0;
for cell_inx = 1:length(Polo_3DTuning_R)
    R_model(cell_inx).name = Polo_3DTuning_R(cell_inx).name;
    R_model(cell_inx).ch = Polo_3DTuning_R(cell_inx).ch;
    % for Rotation - Vestibular
    
    if ~isempty(find(Polo_3DTuning_R(cell_inx).stimType == 1))
        R_model(cell_inx).vestiPSTH3Dmodel = Polo_3DTuning_R(cell_inx).PSTH3Dmodel{find(Polo_3DTuning_R(cell_inx).stimType == 1)};
    else
        R_model(cell_inx).vestiPSTH3Dmodel = nan;
    end
    
    % for Rotation - Visual
    if ~isempty(find(Polo_3DTuning_R(cell_inx).stimType == 2))
        R_model(cell_inx).visPSTH3Dmodel = Polo_3DTuning_R(cell_inx).PSTH3Dmodel{find(Polo_3DTuning_R(cell_inx).stimType == 2)};
    else
        R_model(cell_inx).visPSTH3Dmodel = nan;
    end
    
    if isstruct(R_model(cell_inx).vestiPSTH3Dmodel)
        R_model(cell_inx).vestiSig = 1;
        R_vestiNo = R_vestiNo+1;
        % Partial R_squared
        R_PartR2_VAT_vesti(cell_inx).R2V = R_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2V;
        R_PartR2_VAT_vesti(cell_inx).R2A = R_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2A;
        R_PartR2_VAT_vesti(cell_inx).R2J = R_model(cell_inx).vestiPSTH3Dmodel.VAJ_R2J;
        R_wVAJ_vesti(cell_inx).wV =  R_model(cell_inx).vestiPSTH3Dmodel.VAJ_wV;
        R_wVAJ_vesti(cell_inx).wA =  R_model(cell_inx).vestiPSTH3Dmodel.VAJ_wA;
        R_wVAJ_vesti(cell_inx).wJ =  R_model(cell_inx).vestiPSTH3Dmodel.VAJ_wJ;
        R_wVA_vesti(cell_inx).wV =  R_model(cell_inx).vestiPSTH3Dmodel.VA_wV;
        R_wVA_vesti(cell_inx).wA =  R_model(cell_inx).vestiPSTH3Dmodel.VA_wA;
        R_PartR2VA_vesti(cell_inx).wV =  R_model(cell_inx).vestiPSTH3Dmodel.VA_R2V;
        R_PartR2VA_vesti(cell_inx).wA =  R_model(cell_inx).vestiPSTH3Dmodel.VA_R2A;
        R_spatial_VA_vesti(cell_inx).V =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitTrans_spatial_VA.V;
        R_spatial_VA_vesti(cell_inx).A =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitTrans_spatial_VA.A;
        R_spatial_VA_vesti(cell_inx).V([1 5],2:end) = 0;
        R_spatial_VA_vesti(cell_inx).A([1 5],2:end) = 0;
        [R_preDir_VA_vesti(cell_inx).V(1) R_preDir_VA_vesti(cell_inx).V(2) R_preDir_VA_vesti(cell_inx).V(3) ]=  vectorsum(R_spatial_VA_vesti(cell_inx).V);
        [R_preDir_VA_vesti(cell_inx).A(1) R_preDir_VA_vesti(cell_inx).A(2) R_preDir_VA_vesti(cell_inx).A(3)]=  vectorsum(R_spatial_VA_vesti(cell_inx).A);
        R_VA_n_vesti(cell_inx).V =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(4);
        R_VA_n_vesti(cell_inx).A =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(8);
        R_VAJ_n_vesti(cell_inx).V =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(4);
        R_VAJ_n_vesti(cell_inx).A =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(8);
        R_VAJ_n_vesti(cell_inx).J =  R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VAJ(12);
        if Model_catg == 2
            R_VA_vesti_delayV(cell_inx) = R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(13);
        end
        R_VA_vesti_muA(cell_inx) = R_model(cell_inx).vestiPSTH3Dmodel.modelFitPara_VA(3);
        R_VA_vesti_spatial_V{cell_inx} = R_model(cell_inx).vestiPSTH3Dmodel.modelFit_spatial_VA.V;
        R_VA_vesti_spatial_A{cell_inx} = R_model(cell_inx).vestiPSTH3Dmodel.modelFit_spatial_VA.A;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['R_RSS_vesti(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').vestiPSTH3Dmodel.rss_', models{m_inx} , ';']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['R_Rsquared_vesti(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').vestiPSTH3Dmodel.RSquared_', models{m_inx} , ';']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['R_BIC_vesti(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').vestiPSTH3Dmodel.BIC_', models{m_inx}, ';']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['R_PARA_vesti(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').vestiPSTH3Dmodel.modelFitPara_', models{m_inx}, ';']);
            
        end
    else
        R_model(cell_inx).vestiSig = 0;
        % Partial R_squared
        R_PartR2_VAT_vesti(cell_inx).R2V = nan;
        R_PartR2_VAT_vesti(cell_inx).R2A = nan;
        R_PartR2_VAT_vesti(cell_inx).R2J = nan;
        R_wVAJ_vesti(cell_inx).wV = nan;
        R_wVAJ_vesti(cell_inx).wA = nan;
        R_wVAJ_vesti(cell_inx).wJ = nan;
        R_wVA_vesti(cell_inx).wV = nan;
        R_wVA_vesti(cell_inx).wA = nan;
        R_PartR2VA_vesti(cell_inx).wV =  nan;
        R_PartR2VA_vesti(cell_inx).wA =  nan;
        R_spatial_VA_vesti(cell_inx).V =  nan;
        R_spatial_VA_vesti(cell_inx).A =  nan;
        R_preDir_VA_vesti(cell_inx).V =  nan*ones(1,3);
        R_preDir_VA_vesti(cell_inx).A =  nan*ones(1,3);
        R_VA_n_vesti(cell_inx).V =  nan;
        R_VA_n_vesti(cell_inx).A =  nan;
        R_VAJ_n_vesti(cell_inx).V =  nan;
        R_VAJ_n_vesti(cell_inx).A =  nan;
        R_VAJ_n_vesti(cell_inx).J =  nan;
        if Model_catg == 2
            R_VA_vesti_delayV(cell_inx) = nan;
        end
        R_VA_vesti_muA(cell_inx) = nan;
        R_VA_vesti_spatial_V{cell_inx} = nan;
        R_VA_vesti_spatial_A{cell_inx} = nan;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['R_RSS_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['R_Rsquared_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['R_BIC_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['R_PARA_vesti(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
        end
    end
    
    if isstruct(R_model(cell_inx).visPSTH3Dmodel)
        R_model(cell_inx).visSig = 1;
        R_visNo = R_visNo+1;
        % Partial R_squared
        R_PartR2_VAT_vis(cell_inx).R2V = R_model(cell_inx).visPSTH3Dmodel.VAJ_R2V;
        R_PartR2_VAT_vis(cell_inx).R2A = R_model(cell_inx).visPSTH3Dmodel.VAJ_R2A;
        R_PartR2_VAT_vis(cell_inx).R2J = R_model(cell_inx).visPSTH3Dmodel.VAJ_R2J;
        R_wVAJ_vis(cell_inx).wV =  R_model(cell_inx).visPSTH3Dmodel.VAJ_wV;
        R_wVAJ_vis(cell_inx).wA =  R_model(cell_inx).visPSTH3Dmodel.VAJ_wA;
        R_wVAJ_vis(cell_inx).wJ =  R_model(cell_inx).visPSTH3Dmodel.VAJ_wJ;
        R_wVA_vis(cell_inx).wV =  R_model(cell_inx).visPSTH3Dmodel.VA_wV;
        R_wVA_vis(cell_inx).wA =  R_model(cell_inx).visPSTH3Dmodel.VA_wA;
        R_PartR2VA_vis(cell_inx).wV =  R_model(cell_inx).visPSTH3Dmodel.VA_R2V;
        R_PartR2VA_vis(cell_inx).wA =  R_model(cell_inx).visPSTH3Dmodel.VA_R2A;
        R_spatial_VA_vis(cell_inx).V =  R_model(cell_inx).visPSTH3Dmodel.modelFitTrans_spatial_VA.V;
        R_spatial_VA_vis(cell_inx).A =  R_model(cell_inx).visPSTH3Dmodel.modelFitTrans_spatial_VA.A;
        R_spatial_VA_vis(cell_inx).V([1 5],2:end) = 0;
        R_spatial_VA_vis(cell_inx).A([1 5],2:end) = 0;
        [R_preDir_VA_vis(cell_inx).V(1) R_preDir_VA_vis(cell_inx).V(2) R_preDir_VA_vis(cell_inx).V(3) ] =  vectorsum(R_spatial_VA_vis(cell_inx).V);
        [R_preDir_VA_vis(cell_inx).A(1) R_preDir_VA_vis(cell_inx).A(2) R_preDir_VA_vis(cell_inx).A(3) ] =  vectorsum(R_spatial_VA_vis(cell_inx).A);
        R_VA_n_vis(cell_inx).V =  R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(4);
        R_VA_n_vis(cell_inx).A =  R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(8);
        R_VAJ_n_vis(cell_inx).V =  R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(4);
        R_VAJ_n_vis(cell_inx).A =  R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(8);
        R_VAJ_n_vis(cell_inx).J =  R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VAJ(12);
        if Model_catg == 2
            R_VA_vis_delayV(cell_inx) = R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(13);
        end
        R_VA_vis_muA(cell_inx) = R_model(cell_inx).visPSTH3Dmodel.modelFitPara_VA(3);
        R_VA_vis_spatial_V{cell_inx} = R_model(cell_inx).visPSTH3Dmodel.modelFit_spatial_VA.V;
        R_VA_vis_spatial_A{cell_inx} = R_model(cell_inx).visPSTH3Dmodel.modelFit_spatial_VA.A;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['R_RSS_vis(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').visPSTH3Dmodel.rss_', models{m_inx} , ';']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['R_Rsquared_vis(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').visPSTH3Dmodel.RSquared_', models{m_inx} , ';']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['R_BIC_vis(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').visPSTH3Dmodel.BIC_', models{m_inx}, ';']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['R_PARA_vis(',num2str(cell_inx),').', models{m_inx},' = R_model(',num2str(cell_inx),').visPSTH3Dmodel.modelFitPara_', models{m_inx}, ';']);
            
        end
    else
        R_model(cell_inx).visSig = 0;
        % Partial R_squared
        R_PartR2_VAT_vis(cell_inx).R2V = nan;
        R_PartR2_VAT_vis(cell_inx).R2A = nan;
        R_PartR2_VAT_vis(cell_inx).R2J = nan;
        R_wVAJ_vis(cell_inx).wV = nan;
        R_wVAJ_vis(cell_inx).wA = nan;
        R_wVAJ_vis(cell_inx).wJ = nan;
        R_wVA_vis(cell_inx).wV = nan;
        R_wVA_vis(cell_inx).wA = nan;
        R_PartR2VA_vis(cell_inx).wV =  nan;
        R_PartR2VA_vis(cell_inx).wA =  nan;
        R_spatial_VA_vis(cell_inx).V =  nan;
        R_spatial_VA_vis(cell_inx).A =  nan;
        R_preDir_VA_vis(cell_inx).V =  nan*ones(1,3);
        R_preDir_VA_vis(cell_inx).A =  nan*ones(1,3);
        R_VA_n_vis(cell_inx).V =  nan;
        R_VA_n_vis(cell_inx).A =  nan;
        R_VAJ_n_vis(cell_inx).V =  nan;
        R_VAJ_n_vis(cell_inx).A =  nan;
        R_VAJ_n_vis(cell_inx).J =  nan;
        if Model_catg == 2
            R_VA_vis_delayV(cell_inx) = nan;
        end
        R_VA_vis_muA(cell_inx) = nan;
        R_VA_vis_spatial_V{cell_inx} = nan;
        R_VA_vis_spatial_A{cell_inx} = nan;
        
        for m_inx = 1:length(models)
            % pack RSS values to RSS.*(* the model)
            eval(['R_RSS_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack R_squared values to RSS.*(* the model)
            eval(['R_Rsquared_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack BIC values to RSS.*(* the model)
            eval(['R_BIC_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
            % pack model fitting parameters to PARA.*.#
            eval(['R_PARA_vis(',num2str(cell_inx),').', models{m_inx},' = nan;']);
            
        end
    end
end

disp('R model data loaded SUCCESS!');

% save the data
if Model_catg == 2
    save('PSTH3DModel_T_OriData.mat','T_model','T_PARA_vis', 'T_RSS_vis', 'T_BIC_vis','T_Rsquared_vis','T_PARA_vesti', 'T_RSS_vesti', 'T_BIC_vesti','T_Rsquared_vesti','T_vestiNo','T_visNo','T_PartR2_VAT_vis','T_PartR2_VAT_vesti','T_PartR2VA_vis','T_PartR2VA_vis','T_wVAJ_vis','T_wVAJ_vesti','T_wVA_vis','T_wVA_vesti','T_preDir_VA_vis','T_preDir_VA_vesti','T_VA_n_vesti','T_VA_n_vis','T_VAJ_n_vesti','T_VAJ_n_vis','T_VA_vis_delayV','T_VA_vesti_delayV','T_VA_vesti_muA','T_VA_vis_muA','T_VA_vesti_spatial_V','T_VA_vis_spatial_V','T_VA_vesti_spatial_A','T_VA_vis_spatial_A');
    save('PSTH3DModel_R_OriData.mat','R_model','R_PARA_vis', 'R_RSS_vis', 'R_BIC_vis','R_Rsquared_vis','R_PARA_vesti', 'R_RSS_vesti', 'R_BIC_vesti','R_Rsquared_vesti','R_vestiNo','R_visNo','R_PartR2_VAT_vesti','R_PartR2VA_vis','R_wVAJ_vis','R_wVAJ_vesti','R_wVA_vis','R_wVA_vesti','R_preDir_VA_vis','R_preDir_VA_vesti','R_VA_n_vesti','R_VA_n_vis','R_VAJ_n_vesti','R_VAJ_n_vis','R_VA_vis_delayV','R_VA_vesti_delayV','R_VA_vesti_muA','R_VA_vis_muA','R_VA_vesti_spatial_V','R_VA_vis_spatial_V','R_VA_vesti_spatial_A','R_VA_vis_spatial_A');
elseif Model_catg == 1
    save('PSTH3DModel_T_OriData.mat','T_model','T_PARA_vis', 'T_RSS_vis', 'T_BIC_vis','T_Rsquared_vis','T_PARA_vesti', 'T_RSS_vesti', 'T_BIC_vesti','T_Rsquared_vesti','T_vestiNo','T_visNo','T_PartR2_VAT_vis','T_PartR2_VAT_vesti','T_PartR2VA_vis','T_PartR2VA_vis','T_wVAJ_vis','T_wVAJ_vesti','T_wVA_vis','T_wVA_vesti','T_preDir_VA_vis','T_preDir_VA_vesti','T_VA_n_vesti','T_VA_n_vis','T_VAJ_n_vesti','T_VAJ_n_vis','T_VA_vesti_muA','T_VA_vis_muA','T_VA_vesti_spatial_V','T_VA_vis_spatial_V','T_VA_vesti_spatial_A','T_VA_vis_spatial_A');
    save('PSTH3DModel_R_OriData.mat','R_model','R_PARA_vis', 'R_RSS_vis', 'R_BIC_vis','R_Rsquared_vis','R_PARA_vesti', 'R_RSS_vesti', 'R_BIC_vesti','R_Rsquared_vesti','R_vestiNo','R_visNo','R_PartR2_VAT_vesti','R_PartR2VA_vis','R_wVAJ_vis','R_wVAJ_vesti','R_wVA_vis','R_wVA_vesti','R_preDir_VA_vis','R_preDir_VA_vesti','R_VA_n_vesti','R_VA_n_vis','R_VAJ_n_vesti','R_VAJ_n_vis','R_VA_vesti_muA','R_VA_vis_muA','R_VA_vesti_spatial_V','R_VA_vis_spatial_V','R_VA_vesti_spatial_A','R_VA_vis_spatial_A');
end
disp('DATA SAVED!');

