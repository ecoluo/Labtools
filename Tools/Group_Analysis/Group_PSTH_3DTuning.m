function function_handles = Group_PSTH_3DTuning(XlsData,if_tolerance)

%% Get data

num = XlsData.num;
txt = XlsData.txt;
raw = XlsData.raw;
header = XlsData.header;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BATCH address
mat_address = {
    % 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6_m5','PSTH_T','3DT';
    % 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6_m5','PSTH_R','3DR';
    
    %     'Z:\Data\TEMPO\BATCH\20181008_3DModel_noModel_PCC_m6_m5','PSTH_T','3DT';
    %     'Z:\Data\TEMPO\BATCH\20181008_3DModel_noModel_PCC_m6_m5','PSTH_R','3DR';
    %         'Z:\Data\TEMPO\BATCH\20181008_3DModel_noModel_PCC_m6_m5','PSTH_T','3DT_dark';
    %         'Z:\Data\TEMPO\BATCH\20181008_3DModel_noModel_PCC_m6_m5','PSTH_R','3DR_dark';
    %         'Z:\Data\TEMPO\BATCH\20191213_3DModel_noModel_RSC_m6','PSTH_T','3DT';
    %         'Z:\Data\TEMPO\BATCH\20191213_3DModel_noModel_RSC_m6','PSTH_R','3DR';
    
    %     'Z:\Data\TEMPO\BATCH\20181008_3D&1DModel_Sync_PCC_m6_m5','PSTH_T','3DT';
    %     'Z:\Data\TEMPO\BATCH\20181008_3D&1DModel_Sync_PCC_m6_m5','PSTH_R','3DR';
    
%                 'Z:\Data\TEMPO\BATCH\20181008_3DModel_Sync_PCC_m6_m5','PSTH_T','3DT';
%                 'Z:\Data\TEMPO\BATCH\20181008_3DModel_Sync_PCC_m6_m5','PSTH_R','3DR';
%         'Z:\Data\TEMPO\BATCH\20181008_3DModel_Sync_PCC_m6_m5','PSTH_T','3DT_dark';
%         'Z:\Data\TEMPO\BATCH\20181008_3DModel_Sync_PCC_m6_m5','PSTH_R','3DR_dark';
%         'Z:\Data\TEMPO\BATCH\20191213_3DModel_Sync_RSC_m6','PSTH_T','3DT';
%             'Z:\Data\TEMPO\BATCH\20191213_3DModel_Sync_RSC_m6','PSTH_R','3DR';
%     'Z:\Data\TEMPO\BATCH\20191213_3DModel_Sync_A23_m6','PSTH_T','3DT';
%     'Z:\Data\TEMPO\BATCH\20191213_3DModel_Sync_A23_m6','PSTH_R','3DR';
        'Z:\Data\TEMPO\BATCH\20191220_3DModel_Sync_PCC_QY_m6','PSTH_T','3DT';
            'Z:\Data\TEMPO\BATCH\20191220_3DModel_Sync_PCC_QY_m6','PSTH_R','3DR';

%     
    %     'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_T','3DT';
    %     'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_R','3DR';
    %         'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_T','3DT_dark';
    %     'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_R','3DR_dark';
    
    %--------------------MSTd
    %             'Z:\Data\TEMPO\BATCH\MSTd_vis_sync','PSTH_T','3DT';
    
    %         'Z:\Data\TEMPO\BATCH\MSTd_vis_out-sync','PSTH_T','3DT';
    };

% PCC
% %{
mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
%     strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%     & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
%     strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%     & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    
    }; % Now no constraint on monkeys
    %}
    
    % RSC
    %{
    mask_all = {
        strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
        & strcmp(txt(:,header.Area),'RSC');
        strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
        & strcmp(txt(:,header.Area),'RSC');
%     strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%         & strcmp(txt(:,header.Area),'RSC');
%         strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%         & strcmp(txt(:,header.Area),'RSC');
        }; % Now no constraint on monkeys
    %}
    
    % 23A
    %{
mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'A23');
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'A23');
%     strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%     & strcmp(txt(:,header.Area),'A23');
%     strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
%     & strcmp(txt(:,header.Area),'A23');

    }; % Now no constraint on monkeys
    %}
    
    
    
    % PCCl
    %{
mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    
    }; % Now no constraint on monkeys
    %}
    
    % PCCu
    %{
mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1') & ~strcmp(txt(:,header.Sound),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    
    }; % Now no constraint on monkeys
    %}
    
    
    
    % % Add flexible monkey mask here (but I've still decided to choose monkey for analysis below). HH20150723
    monkey_included_for_loading = [6 5];
    Monkeys{5} = 'Polo';
    Monkeys{6} = 'QQ';
    
    % MSTd
    %{
mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & (strcmp(txt(:,header.Area),'MSTd'));
    
    }; % Now no constraint on monkeys


monkey_included_for_loading = [3 1];
Monkeys{3} = 'Que';
Monkeys{1} = 'Zebulon';

    %}
    
    monkey_mask_for_loading = false(size(num,1),1);
    for mm = 1:length(monkey_included_for_loading)
        monkey_mask_for_loading = monkey_mask_for_loading | (num(:,header.Monkey) == monkey_included_for_loading(mm));
    end
    
    % Now apply monkey mask
    for mm = 1:length(mask_all)
        mask_all{mm} = mask_all{mm} & monkey_mask_for_loading;
    end
    
    %{
% if monkey == 1 % Qiaoqiao
%     mat_address = 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6\';
%     mask_all = (strcmp(txt(:,header.Protocol),'3DT')| strcmp(txt(:,header.Protocol),'3DR') ) & (num(:,header.Monkey) == 6) & ~strcmp(txt(:,header.Dark),'1') & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
% elseif monkey == 2 % Polo
%     mat_address = 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m5\';
%     mask_all = (strcmp(txt(:,header.Protocol),'3DT')| strcmp(txt(:,header.Protocol),'3DR') ) & (num(:,header.Monkey) == 5) &  ~strcmp(txt(:,header.Dark),'1') & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
% end
    %}
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cell_true = [];
    
    for pp = 1:size(mat_address,1)
        % Xls Data
        xls_num{pp} = num(mask_all{pp},:);
        xls_txt{pp} = txt(mask_all{pp},:);
        xls_raw{pp} = raw(mask_all{pp},:);
        
        % Basic information : E.g.  '20140721m05s034h2x04y12d08478u6m5c67r2'
        % date,monkey,session,hemi,xloc,yloc,depth,unit
        cell_info_tmp = xls_num{pp}(:,[header.Date:header.Yloc header.Depth header.Chan1]);
        
        % Override MU with SU. HH20150422
        cell_info_tmp(xls_num{pp}(:,header.Units_RealSU)==1 & xls_num{pp}(:,header.Chan1)==1,end) = 5;
        
        cell_info{pp} = strsplit(sprintf('%8dm%02ds%03dh%01dx%02dy%02dd%05du%02d\n',cell_info_tmp'),'\n')';
        cell_info{pp} = strcat(cell_info{pp}(1:end-1),xls_txt{pp}(:,header.FileNo));
        cell_true = cat(1,cell_true,cell_info{pp});
    end
    cd(mat_address{1,1});
    
    % to find exactly how many cells
    cell_true = cellfun(@(x) x(1:end-2),cell_true,'UniformOutput',false);
    cell_true = unique(cell_true);
    
    %% Establish mat-to-xls relationship and load data into group_result.mat
    % %{
    
    global group_result; % This lets me reload the whole m.file without loading group_result, which speeds up my debugging.
    
    %
    if isempty(group_result)
        group_result(size(cell_true,1)).cellID = [];  % The unique cellID
        load_group_result();
    end
    
    function load_group_result()
        %
        % Load .mat files and put the data into a large structure array "group_result(i).mat_raw"
        
        tic;
        progressbar('Load .mat files');
        not_match(size(mat_address,1)) = 0;
        
        for major_i = 1:length(group_result) % Major protocol loop
            group_result(major_i).monkeyID = str2double(cell_true{major_i}(34));
            for pp = 1:size(mat_address,1) % pp is the index of cells
                
                %%%% Get basic information for cellID
                
                %1 Search for corresponding files in .mat
                match_i = find(strncmp(cell_true{major_i},cell_info{pp},38));
                
                if ~isempty(match_i) % have >1 match
                    file_i = match_i;
                else % no this protocol for this cell
                    %                     fprintf('No exact matched files for %s, ID = %s\n', mat_address{pp,3},cell_true{major_i}(30:end));
                    not_match(pp) = not_match(pp) + 1;
                    file_i = NaN;
                end
                
                %2 Load .mat
                if ~isnan(file_i)
                    try
                        for ii = 1:length(file_i)
                            mat_file_name = sprintf('%s_%g',xls_txt{pp}{file_i(ii),header.FileNo},xls_num{pp}(file_i(ii),header.Chan1));
                            mat_file_fullname = [mat_address{pp,1} '\' mat_file_name '_' mat_address{pp,2}];
                            
                            raw = load(mat_file_fullname);
                            group_result(major_i).cellID{pp}{ii} = cell_info{pp}{file_i(ii)};
                            
                            
                            group_result(major_i).('mat_raw'){pp}{ii} = raw.result;  % Dynamic structure
                            
                        end
                    catch
                        fprintf('Error Loading %s\n',[mat_file_name '_' mat_address{pp,3}]);
                        keyboard;
                    end
                    
                else
                    group_result(major_i).cellID{pp} = [];
                    group_result(major_i).('mat_raw'){pp} = [];
                end
            end
            progressbar(major_i/length(group_result));
        end
        toc
        fprintf('\nLoaded %g cells\n\n ',length(group_result));
        for pp = 1:size(mat_address,1)
            fprintf('%s, %g cells\n ',mat_address{pp,3},length(group_result)-not_match(pp));
        end
        
    end

%% Get some values from group_result(i).mat_raw_xxx our to group_result(i) for easier access

stimType = {'vestibular';'visual'};
% models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
models = {'VO','AO','VA','VJ','AJ','VAJ'};
% models = {'VA','VAP','VAJ','PVAJ'};
% models = {'VO'};
model_cat = 1; % Sync model
% model_cat = 2; % Out-sync model
% nParaModel_3D{1} = [7 7 12 12 12 12 12 17 17 22]; % how many free parameters for each 3D model
% nParaModel_3D{2} = [7 7 13 13 13 13 13 19 19 25];
nParaModel_3D{1} = [7 7 12 12 12 17]; % how many free parameters for each 3D model
nParaModel_3D{2} = [7 7 13 13 13 19];
% nParaModel_3D{1} = [6 6 10 10 10 10 10 14 14 18]; % how many free parameters for each 1D model
% nParaModel_3D{2} = [7 7 13 13 13 13 13 19 19 25];
% nParaModel_3D{1} = [6 6 10 10 10 10 10 14 14 18];
% models = {'VA'};

for i = 1:length(group_result)
    for pp = 1:size(mat_address,1)
        if isempty(group_result(i).mat_raw{pp}) % no this protocol for this cell
            group_result(i).uStimType{pp} = [];
            group_result(i).pANOVA{pp} = [];
            group_result(i).pANOVAPeak{pp} = [];
            group_result(i).preDir{pp} = [];
            group_result(i).preDir_peak{pp} = [];
            group_result(i).DDI{pp} = [];
            group_result(i).DDI_peak{pp} = [];
            group_result(i).DDI_pPeak{pp}{ii} = [];
            group_result(i).meanSpon{pp} = [];
            group_result(i).responSig{pp} = [];
            group_result(i).PSTH{pp} = [];
            group_result(i).Rextre{pp} =[];
            group_result(i).PSTH3Dmodel{pp}{ii} = [];
            %             group_result(i).PSTH1Dmodel{pp}{ii} = [];
            group_result(i).peakT{pp} = [];
            group_result(i).data_PCA{pp} = [];
        else
            for ii = 1:length(group_result(i).mat_raw{pp}) % >= one files for this protocol
                
                group_result(i).uStimType{pp}{ii} = group_result(i).mat_raw{pp}{ii}.unique_stimType;
                group_result(i).pANOVA{pp}{ii} = group_result(i).mat_raw{pp}{ii}.p_anova_dire;
                group_result(i).pANOVAPeak{pp}{ii} = group_result(i).mat_raw{pp}{ii}.p_anova_dire_t;
                group_result(i).preDir{pp}{ii} = group_result(i).mat_raw{pp}{ii}.preferDire;
                group_result(i).preDir_peak{pp}{ii} = group_result(i).mat_raw{pp}{ii}.preferDire_t;
                group_result(i).DDI{pp}{ii} = group_result(i).mat_raw{pp}{ii}.DDI;
                group_result(i).DDI_peak{pp}{ii} = group_result(i).mat_raw{pp}{ii}.DDI_t;
                group_result(i).DDI_pPeak{pp}{ii} = group_result(i).mat_raw{pp}{ii}.DDI_p_t;
                group_result(i).meanSpon{pp}{ii} = group_result(i).mat_raw{pp}{ii}.meanSpon;
                group_result(i).responSig{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.respon_sigTrue;
                group_result(i).PSTH{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.spk_data_bin_mean_rate_aov_cell;
                group_result(i).Rextre{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.maxSpkRealBinMean-group_result(i).mat_raw{pp}{ii}.PSTH.minSpkRealBinMean;
                group_result(i).PSTH3Dmodel{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH3Dmodel;
                %                 group_result(i).PSTH1Dmodel{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH1Dmodel;
                group_result(i).peakT{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.peak;
                group_result(i).data_PCA{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.spk_data_sorted_PCA';
                
            end
        end
    end
    
end


% ------ Load Gaussian velocity -----
% Measured by accelerometer at System building room 212 (TEMPO 1).
% 20161220&20180731, measured 2 times, results are similar, LBY
temp = load('Z:\Data\TEMPO\BATCH\TEMPO1_Acceleration_sigma4_5p_11');
% [time_vel,veloc_value,time_acc,accel_value] = Real_acc_vel;

%% Reorganize data into matrices which are easier to plot and compare


nBins = group_result(1).mat_raw{1}{1}.nBins;
PCAStep = group_result(1).mat_raw{1}{1}.PCAStep;
nBinsPCA = group_result(1).mat_raw{1}{1}.nBinsPCA;
duration = group_result(1).mat_raw{1}{1}.unique_duration; % unit in ms
totalBinT = group_result(1).mat_raw{1}{1}.unique_duration + group_result(1).mat_raw{1}{1}.tOffset1 + group_result(1).mat_raw{1}{1}.tOffset2;
stimOnBin = group_result(1).mat_raw{1}{1}.markers{1,3};
stimOffBin = group_result(1).mat_raw{1}{1}.markers{2,3};
% initialize with NaN

for pp = 1:size(mat_address,1)
    % independent on stim types
    meanSpon{pp} = NaN(size(cell_true,1),1);
    uStimType{pp} = zeros(size(cell_true,1),3);
    % dependent on stim types
    PSTH3Dmodel{pp} = cell(size(cell_true,1),length(stimType));
    pANOVA{pp} = NaN(size(cell_true,1),length(stimType));
    pANOVAPeak{pp} = NaN(size(cell_true,1),length(stimType));
    DDI{pp} = NaN(size(cell_true,1),length(stimType));
    responSig{pp} = NaN(size(cell_true,1),length(stimType));
    Rextre{pp} = NaN(size(cell_true,1),length(stimType));
    
    for jj = 1:length(stimType)
        
        %         pANOVA{pp}(:,jj) = NaN(size(cell_true,1),1);
        preDir{pp}{jj} = NaN(size(cell_true,1),3);
        %         DDI{pp}(:,jj) = NaN(size(cell_true,1),1);
        %         responSig{pp}(:,jj) = NaN(size(cell_true,1),1);
        PSTH{pp}{jj} = NaN(size(cell_true,1),nBins);
        %         Rextre{pp}(:,jj) = NaN(size(cell_true,1),1);
        
    end
end
% re-organize data according to stim types
for pp = 1:size(mat_address,1)
    for i = 1:length(group_result)
        if ~isempty(group_result(i).uStimType{pp})
            for ii = 1:length(group_result(i).uStimType{pp})
                % independent on stim types
                meanSpon{pp}(i) = group_result(i).meanSpon{pp}{ii};
                for jj = (group_result(i).uStimType{pp}{ii})'
                    % dependent on stim types
                    uStimType{pp}(i,jj) = 1;
                    pANOVA{pp}(i,jj) = group_result(i).pANOVA{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    pANOVAPeak{pp}(i,jj) = group_result(i).pANOVAPeak{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)}(1);
                    preDir{pp}{jj}(i,:) = group_result(i).preDir{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    preDir_peak{pp}{jj}{i} = group_result(i).preDir_peak{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    DDI{pp}(i,jj) = group_result(i).DDI{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    DDI_peak{pp}{jj}{i} = group_result(i).DDI_peak{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    DDI_pPeak{pp}{jj}{i} = group_result(i).DDI_pPeak{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    peakT{pp}{jj}{i} = group_result(i).peakT{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    responSig{pp}(i,jj) = group_result(i).responSig{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    PSTH{pp}{jj}(i,:) = group_result(i).PSTH{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    Rextre{pp}(i,jj) = group_result(i).Rextre{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    PSTH3Dmodel{pp}{i,jj} = group_result(i).PSTH3Dmodel{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    %                                         PSTH1Dmodel{pp}{i,jj} = group_result(i).PSTH1Dmodel{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    data_PCA{pp}{jj}{i} = group_result(i).data_PCA{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                end
            end
        end
    end
    uStimType{pp}(:,3) = (uStimType{pp}(:,1)) & (uStimType{pp}(:,2));
end

% for 3D models
% %{
for pp = 1:size(mat_address,1)
    wV_VA_3D{pp} = nan(length(group_result),2);wA_VA_3D{pp} = nan(length(group_result),2);
    wV_VAJ_3D{pp} = nan(length(group_result),2);wA_VAJ_3D{pp} = nan(length(group_result),2);wJ_VAJ_3D{pp} = nan(length(group_result),2);
    wV_VAP_3D{pp} = nan(length(group_result),2);wA_VAP_3D{pp} = nan(length(group_result),2);wP_VAP_3D{pp} = nan(length(group_result),2);
    wV_PVAJ_3D{pp} = nan(length(group_result),2);wA_PVAJ_3D{pp} = nan(length(group_result),2);wJ_PVAJ_3D{pp} = nan(length(group_result),2);wP_PVAJ_3D{pp} = nan(length(group_result),2);
    
    parR2V_VA_3D{pp} = nan(length(group_result),2);parR2A_VA_3D{pp} = nan(length(group_result),2);
    parR2V_VAJ_3D{pp} = nan(length(group_result),2);parR2A_VAJ_3D{pp} = nan(length(group_result),2);parR2J_VAJ_3D{pp} = nan(length(group_result),2);
    parR2V_VAP_3D{pp} = nan(length(group_result),2);parR2A_VAP_3D{pp} = nan(length(group_result),2);parR2P_VAP_3D{pp} = nan(length(group_result),2);
    
    angleDiff_VA_VA_3D{pp} = nan(length(group_result),2);
    angleDiff_VA_VAJ_3D{pp} = nan(length(group_result),2);
    angleDiff_VA_VAP_3D{pp} = nan(length(group_result),2);
    angleDiff_VA_PVAJ_3D{pp} = nan(length(group_result),2);
    
    
    for jj = 1:length(stimType)
        R2_3D{pp}{jj} = nan(length(group_result),length(models));
        BIC_3D{pp}{jj} = nan(length(group_result),length(models));
        Para_3D{pp}{jj} = cell(length(group_result),length(models));
        RSS_3D{pp}{jj} = nan(length(group_result),length(models));
        
        preDir_V_VA_3D{pp}{jj} = nan(length(group_result),3);preDir_A_VA_3D{pp}{jj} = nan(length(group_result),3);
        preDir_V_PVAJ_3D{pp}{jj} = nan(length(group_result),3);preDir_A_PVAJ_3D{pp}{jj} = nan(length(group_result),3);
        preDir_V_VAP_3D{pp}{jj} = nan(length(group_result),3);preDir_A_VAP_3D{pp}{jj} = nan(length(group_result),3);
        preDir_V_VAJ_3D{pp}{jj} = nan(length(group_result),3);preDir_A_VAJ_3D{pp}{jj} = nan(length(group_result),3);
        
        for i = 1:length(group_result)
            if responSig{pp}(i,jj) == 1
                for m_inx = 1:length(models)
                    temp = isfield(PSTH3Dmodel{pp}{i,jj}{1},{['RSquared_',models{m_inx}],['BIC_',models{m_inx}],['modelFitPara_',models{m_inx}],['rss_',models{m_inx}]});
                    if temp(1) == 1
                        % pack R_squared values to group_result.R2.*(* the model)
                        eval(['R2_3D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.RSquared_', models{m_inx}, ';']);
                        % R2{pp}{jj}(i,m_inx) = PSTH3Dmodel{pp}{i,jj}{1}.RSquared_VO;
                        
                    end
                    if temp(2) == 1
                        % pack BIC values to group_result.BIC.*(* the model)
                        eval(['BIC_3D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.BIC_', models{m_inx}, ';']);
                        % BIC{pp}{jj}(i,m_inx) = PSTH3Dmodel{pp}{i,jj}{1}.BIC_VO;
                        
                    end
                    if temp(3) == 1
                        % pack model fitting parameters to group_result.Para*.(* the model)
                        eval(['Para_3D{',num2str(pp),'}{',num2str(jj),'}{',num2str(i),',',num2str(m_inx),'} = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.modelFitPara_', models{m_inx}, ';']);
                        % Para{pp}{jj}{i,m_inx} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitPara_VO;
                        
                    end
                    if temp(4) == 1
                        % pack rss values to group_result.R2.*(* the model)
                        eval(['RSS_3D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.rss_', models{m_inx}, ';']);
                        % RSS{pp}{jj}(i,m_inx) = PSTH3Dmodel{pp}{i,jj}{1}.RSquared_VO;
                        
                    end
                end
                
                if sum(strcmp(models,'VA'))
                    wV_VA_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_wV;
                    wA_VA_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_wA;
                    if sum(ismember(models,'AO')) && sum(ismember(models,'VO'))
                        parR2V_VA_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_R2V;
                        parR2A_VA_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_R2A;
                    end
                    
                    spatial_VA_3D{pp}{jj}.V{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.V;
                    spatial_VA_3D{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_VA_3D{pp}{jj}.A{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.A;
                    spatial_VA_3D{pp}{jj}.A{i}([1 5],2:end) = 0;
                    
                    % PD of VA model
                    [preDir_V_VA_3D{pp}{jj}(i,1),preDir_V_VA_3D{pp}{jj}(i,2),preDir_V_VA_3D{pp}{jj}(i,3)] = vectorsum(spatial_VA_3D{pp}{jj}.V{i});
                    [preDir_A_VA_3D{pp}{jj}(i,1),preDir_A_VA_3D{pp}{jj}(i,2),preDir_A_VA_3D{pp}{jj}(i,3)] = vectorsum(spatial_VA_3D{pp}{jj}.A{i});
                    angleDiff_VA_VA_3D{pp}(i,jj) = angleDiff(preDir_V_VA_3D{pp}{jj}(i,1),preDir_V_VA_3D{pp}{jj}(i,2),preDir_V_VA_3D{pp}{jj}(i,3),preDir_A_VA_3D{pp}{jj}(i,1),preDir_A_VA_3D{pp}{jj}(i,2),preDir_A_VA_3D{pp}{jj}(i,3));
                    
                    
                    
                end
                
                if sum(strcmp(models,'VAJ'))
                    wV_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wV;
                    wA_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wA;
                    wJ_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wJ;
                    
                    spatial_VAJ_3D{pp}{jj}.V{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAJ.V;
                    spatial_VAJ_3D{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_VAJ_3D{pp}{jj}.A{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAJ.A;
                    spatial_VAJ_3D{pp}{jj}.A{i}([1 5],2:end) = 0;
                    spatial_VAJ_3D{pp}{jj}.J{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAJ.J;
                    spatial_VAJ_3D{pp}{jj}.J{i}([1 5],2:end) = 0;
                    
                    % PD of VAJ model
                    [preDir_V_VAJ_3D{pp}{jj}(i,1),preDir_V_VAJ_3D{pp}{jj}(i,2),preDir_V_VAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAJ_3D{pp}{jj}.V{i});
                    [preDir_A_VAJ_3D{pp}{jj}(i,1),preDir_A_VAJ_3D{pp}{jj}(i,2),preDir_A_VAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAJ_3D{pp}{jj}.A{i});
                    [preDir_J_VAJ_3D{pp}{jj}(i,1),preDir_J_VAJ_3D{pp}{jj}(i,2),preDir_J_VAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAJ_3D{pp}{jj}.J{i});
                    angleDiff_VA_VAJ_3D{pp}(i,jj) = angleDiff(preDir_V_VAJ_3D{pp}{jj}(i,1),preDir_V_VAJ_3D{pp}{jj}(i,2),preDir_V_VAJ_3D{pp}{jj}(i,3),preDir_A_VAJ_3D{pp}{jj}(i,1),preDir_A_VAJ_3D{pp}{jj}(i,2),preDir_A_VAJ_3D{pp}{jj}(i,3));
                    angleDiff_VJ_VAJ_3D{pp}(i,jj) = angleDiff(preDir_V_VAJ_3D{pp}{jj}(i,1),preDir_V_VAJ_3D{pp}{jj}(i,2),preDir_V_VAJ_3D{pp}{jj}(i,3),preDir_J_VAJ_3D{pp}{jj}(i,1),preDir_J_VAJ_3D{pp}{jj}(i,2),preDir_J_VAJ_3D{pp}{jj}(i,3));
                    angleDiff_AJ_VAJ_3D{pp}(i,jj) = angleDiff(preDir_A_VAJ_3D{pp}{jj}(i,1),preDir_A_VAJ_3D{pp}{jj}(i,2),preDir_A_VAJ_3D{pp}{jj}(i,3),preDir_J_VAJ_3D{pp}{jj}(i,1),preDir_J_VAJ_3D{pp}{jj}(i,2),preDir_J_VAJ_3D{pp}{jj}(i,3));
                    
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VJ')) && sum(ismember(models,'AJ'))
                        parR2V_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2V;
                        parR2A_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2A;
                        parR2J_VAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2J;
                    end
                end
                
                if sum(strcmp(models,'VAP'))
                    wV_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wV;
                    wA_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wA;
                    wP_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wP;
                    
                    spatial_VAP_3D{pp}{jj}.V{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAP.V;
                    spatial_VAP_3D{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_VAP_3D{pp}{jj}.A{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAP.A;
                    spatial_VAP_3D{pp}{jj}.A{i}([1 5],2:end) = 0;
                    spatial_VAP_3D{pp}{jj}.P{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VAP.P;
                    spatial_VAP_3D{pp}{jj}.P{i}([1 5],2:end) = 0;
                    
                    % PD of VAP model
                    [preDir_V_VAP_3D{pp}{jj}(i,1),preDir_V_VAP_3D{pp}{jj}(i,2),preDir_V_VAP_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAP_3D{pp}{jj}.V{i});
                    [preDir_A_VAP_3D{pp}{jj}(i,1),preDir_A_VAP_3D{pp}{jj}(i,2),preDir_A_VAP_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAP_3D{pp}{jj}.A{i});
                    [preDir_P_VAP_3D{pp}{jj}(i,1),preDir_P_VAP_3D{pp}{jj}(i,2),preDir_P_VAP_3D{pp}{jj}(i,3)] = vectorsum(spatial_VAP_3D{pp}{jj}.P{i});
                    angleDiff_VA_VAP_3D{pp}(i,jj) = angleDiff(preDir_V_VAP_3D{pp}{jj}(i,1),preDir_V_VAP_3D{pp}{jj}(i,2),preDir_V_VAP_3D{pp}{jj}(i,3),preDir_A_VAP_3D{pp}{jj}(i,1),preDir_A_VAP_3D{pp}{jj}(i,2),preDir_A_VAP_3D{pp}{jj}(i,3));
                    angleDiff_AP_VAP_3D{pp}(i,jj) = angleDiff(preDir_A_VAP_3D{pp}{jj}(i,1),preDir_A_VAP_3D{pp}{jj}(i,2),preDir_A_VAP_3D{pp}{jj}(i,3),preDir_P_VAP_3D{pp}{jj}(i,1),preDir_P_VAP_3D{pp}{jj}(i,2),preDir_P_VAP_3D{pp}{jj}(i,3));
                    angleDiff_VP_VAP_3D{pp}(i,jj) = angleDiff(preDir_V_VAP_3D{pp}{jj}(i,1),preDir_V_VAP_3D{pp}{jj}(i,2),preDir_V_VAP_3D{pp}{jj}(i,3),preDir_P_VAP_3D{pp}{jj}(i,1),preDir_P_VAP_3D{pp}{jj}(i,2),preDir_P_VAP_3D{pp}{jj}(i,3));
                    
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VP')) && sum(ismember(models,'AP'))
                        parR2V_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2V;
                        parR2A_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2A;
                        parR2P_VAP_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2P;
                    end
                end
                
                if sum(strcmp(models,'PVAJ'))
                    wV_PVAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wV;
                    wA_PVAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wA;
                    wJ_PVAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wJ;
                    wP_PVAJ_3D{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wP;
                    
                    spatial_PVAJ_3D{pp}{jj}.V{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_PVAJ.V;
                    spatial_PVAJ_3D{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_PVAJ_3D{pp}{jj}.A{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_PVAJ.A;
                    spatial_PVAJ_3D{pp}{jj}.A{i}([1 5],2:end) = 0;
                    spatial_PVAJ_3D{pp}{jj}.J{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_PVAJ.J;
                    spatial_PVAJ_3D{pp}{jj}.J{i}([1 5],2:end) = 0;
                    spatial_PVAJ_3D{pp}{jj}.P{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_PVAJ.P;
                    spatial_PVAJ_3D{pp}{jj}.P{i}([1 5],2:end) = 0;
                    
                    % PD of PVAJ model
                    [preDir_V_PVAJ_3D{pp}{jj}(i,1),preDir_V_PVAJ_3D{pp}{jj}(i,2),preDir_V_PVAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_PVAJ_3D{pp}{jj}.V{i});
                    [preDir_A_PVAJ_3D{pp}{jj}(i,1),preDir_A_PVAJ_3D{pp}{jj}(i,2),preDir_A_PVAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_PVAJ_3D{pp}{jj}.A{i});
                    [preDir_J_PVAJ_3D{pp}{jj}(i,1),preDir_J_PVAJ_3D{pp}{jj}(i,2),preDir_J_PVAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_PVAJ_3D{pp}{jj}.J{i});
                    [preDir_P_PVAJ_3D{pp}{jj}(i,1),preDir_P_PVAJ_3D{pp}{jj}(i,2),preDir_P_PVAJ_3D{pp}{jj}(i,3)] = vectorsum(spatial_PVAJ_3D{pp}{jj}.P{i});
                    angleDiff_VA_PVAJ_3D{pp}(i,jj) = angleDiff(preDir_V_PVAJ_3D{pp}{jj}(i,1),preDir_V_PVAJ_3D{pp}{jj}(i,2),preDir_V_PVAJ_3D{pp}{jj}(i,3),preDir_A_PVAJ_3D{pp}{jj}(i,1),preDir_A_PVAJ_3D{pp}{jj}(i,2),preDir_A_PVAJ_3D{pp}{jj}(i,3));
                    angleDiff_AP_PVAJ_3D{pp}(i,jj) = angleDiff(preDir_A_PVAJ_3D{pp}{jj}(i,1),preDir_A_PVAJ_3D{pp}{jj}(i,2),preDir_A_PVAJ_3D{pp}{jj}(i,3),preDir_P_PVAJ_3D{pp}{jj}(i,1),preDir_P_PVAJ_3D{pp}{jj}(i,2),preDir_P_PVAJ_3D{pp}{jj}(i,3));
                    angleDiff_VP_PVAJ_3D{pp}(i,jj) = angleDiff(preDir_V_PVAJ_3D{pp}{jj}(i,1),preDir_V_PVAJ_3D{pp}{jj}(i,2),preDir_V_PVAJ_3D{pp}{jj}(i,3),preDir_P_PVAJ_3D{pp}{jj}(i,1),preDir_P_PVAJ_3D{pp}{jj}(i,2),preDir_P_PVAJ_3D{pp}{jj}(i,3));
                    angleDiff_VJ_PVAJ_3D{pp}(i,jj) = angleDiff(preDir_V_PVAJ_3D{pp}{jj}(i,1),preDir_V_PVAJ_3D{pp}{jj}(i,2),preDir_V_PVAJ_3D{pp}{jj}(i,3),preDir_J_PVAJ_3D{pp}{jj}(i,1),preDir_J_PVAJ_3D{pp}{jj}(i,2),preDir_J_PVAJ_3D{pp}{jj}(i,3));
                    angleDiff_AJ_PVAJ_3D{pp}(i,jj) = angleDiff(preDir_A_PVAJ_3D{pp}{jj}(i,1),preDir_A_PVAJ_3D{pp}{jj}(i,2),preDir_A_PVAJ_3D{pp}{jj}(i,3),preDir_J_PVAJ_3D{pp}{jj}(i,1),preDir_J_PVAJ_3D{pp}{jj}(i,2),preDir_J_PVAJ_3D{pp}{jj}(i,3));
                    
                end
            end
            
        end
    end
end
%}

% for 1D models
%{
for pp = 1:size(mat_address,1)
    wV_VA_1D{pp} = nan(length(group_result),2);wA_VA_1D{pp} = nan(length(group_result),2);
    wV_VAJ_1D{pp} = nan(length(group_result),2);wA_VAJ_1D{pp} = nan(length(group_result),2);wJ_VAJ_1D{pp} = nan(length(group_result),2);
    wV_VAP_1D{pp} = nan(length(group_result),2);wA_VAP_1D{pp} = nan(length(group_result),2);wP_VAP_1D{pp} = nan(length(group_result),2);
    wV_PVAJ_1D{pp} = nan(length(group_result),2);wA_PVAJ_1D{pp} = nan(length(group_result),2);wJ_PVAJ_1D{pp} = nan(length(group_result),2);wP_PVAJ_1D{pp} = nan(length(group_result),2);
    
    parR2V_VA_1D{pp} = nan(length(group_result),2);parR2A_VA_1D{pp} = nan(length(group_result),2);
    parR2V_VAJ_1D{pp} = nan(length(group_result),2);parR2A_VAJ_1D{pp} = nan(length(group_result),2);parR2J_VAJ_1D{pp} = nan(length(group_result),2);
    parR2V_VAP_1D{pp} = nan(length(group_result),2);parR2A_VAP_1D{pp} = nan(length(group_result),2);parR2P_VAP_1D{pp} = nan(length(group_result),2);
    
    angleDiff_VA_VA_1D{pp} = nan(length(group_result),2);
    
    
    for jj = 1:length(stimType)
        R2_1D{pp}{jj} = nan(length(group_result),length(models));
        BIC_1D{pp}{jj} = nan(length(group_result),length(models));
        Para_1D{pp}{jj} = cell(length(group_result),length(models));
        RSS_1D{pp}{jj} = nan(length(group_result),length(models));
        
        preDir_V_VA_1D{pp}{jj} = nan(length(group_result),3);preDir_A_VA_1D{pp}{jj} = nan(length(group_result),3);
        
        for i = 1:length(group_result)
            if responSig{pp}(i,jj) == 1
                for m_inx = 1:length(models)
                    temp = isfield(PSTH1Dmodel{pp}{i,jj}{1},{['RSquared_',models{m_inx}],['BIC_',models{m_inx}],['modelFitPara_',models{m_inx}],['rss_',models{m_inx}]});
                    if temp(1) == 1
                        % pack R_squared values to group_result.R2.*(* the model)
                        eval(['R2_1D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH1Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.RSquared_', models{m_inx}, ';']);
                        % R2{pp}{jj}(i,m_inx) = PSTH1Dmodel{pp}{i,jj}{1}.RSquared_VO;
                        
                    end
                    if temp(2) == 1
                        % pack BIC values to group_result.BIC.*(* the model)
                        eval(['BIC_1D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH1Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.BIC_', models{m_inx}, ';']);
                        % BIC{pp}{jj}(i,m_inx) = PSTH1Dmodel{pp}{i,jj}{1}.BIC_VO;
                        
                    end
                    if temp(3) == 1
                        % pack model fitting parameters to group_result.Para*.(* the model)
                        eval(['Para_1D{',num2str(pp),'}{',num2str(jj),'}{',num2str(i),',',num2str(m_inx),'} = PSTH1Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.modelFitPara_', models{m_inx}, ';']);
                        % Para{pp}{jj}{i,m_inx} = PSTH1Dmodel{pp}{i,jj}{1}.modelFitPara_VO;
                        
                    end
                    if temp(4) == 1
                        % pack rss values to group_result.R2.*(* the model)
                        eval(['RSS_1D{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH1Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.rss_', models{m_inx}, ';']);
                        % RSS{pp}{jj}(i,m_inx) = PSTH1Dmodel{pp}{i,jj}{1}.RSquared_VO;
                        
                    end
                end
                
                if sum(strcmp(models,'VA'))
                    wV_VA_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VA_wV;
                    wA_VA_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VA_wA;
                    if sum(ismember(models,'AO')) && sum(ismember(models,'VO'))
                        parR2V_VA_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VA_R2V;
                        parR2A_VA_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VA_R2A;
                    end
                    spatial_VA_1D{pp}{jj}.V{i} = PSTH1Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.V;
                    spatial_VA_1D{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_VA_1D{pp}{jj}.A{i} = PSTH1Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.A;
                    spatial_VA_1D{pp}{jj}.A{i}([1 5],2:end) = 0;
                    [preDir_V_VA_1D{pp}{jj}(i,1),preDir_V_VA_1D{pp}{jj}(i,2),preDir_V_VA_1D{pp}{jj}(i,3)] = vectorsum(spatial_VA_1D{pp}{jj}.V{i});
                    [preDir_A_VA_1D{pp}{jj}(i,1),preDir_A_VA_1D{pp}{jj}(i,2),preDir_A_VA_1D{pp}{jj}(i,3)] = vectorsum(spatial_VA_1D{pp}{jj}.A{i});
                    angleDiff_VA_VA_1D{pp}(i,jj) = angleDiff(preDir_V_VA_1D{pp}{jj}(i,1),preDir_V_VA_1D{pp}{jj}(i,2),preDir_V_VA_1D{pp}{jj}(i,3),preDir_A_VA_1D{pp}{jj}(i,1),preDir_A_VA_1D{pp}{jj}(i,2),preDir_A_VA_1D{pp}{jj}(i,3));
                end
                
                if sum(strcmp(models,'VAJ'))
                    wV_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_wV;
                    wA_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_wA;
                    wJ_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_wJ;
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VJ')) && sum(ismember(models,'AJ'))
                        parR2V_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_R2V;
                        parR2A_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_R2A;
                        parR2J_VAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAJ_R2J;
                    end
                end
                
                if sum(strcmp(models,'VAP'))
                    wV_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_wV;
                    wA_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_wA;
                    wP_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_wP;
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VP')) && sum(ismember(models,'AP'))
                        parR2V_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_R2V;
                        parR2A_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_R2A;
                        parR2P_VAP_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.VAP_R2P;
                    end
                end
                
                if sum(strcmp(models,'PVAJ'))
                    wV_PVAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.PVAJ_wV;
                    wA_PVAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.PVAJ_wA;
                    wJ_PVAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.PVAJ_wJ;
                    wP_PVAJ_1D{pp}(i,jj) = PSTH1Dmodel{pp}{i,jj}{1}.PVAJ_wP;
                    
                end
            end
            
        end
    end
end
%}


% Classify cells

for pp = 1:size(mat_address,1)
    
    
    % cells classified according to temporal response
    temporalSig_i{pp}(:,1) = responSig{pp}(:,1) == 1;
    temporalSig_i{pp}(:,2) = responSig{pp}(:,2) == 1;
    temporalSig_i{pp}(:,3) = temporalSig_i{pp}(:,1) & temporalSig_i{pp}(:,2);
    
    % cells classified according to spatial & temporal response (ANOVA)
    spatialSig_i{pp}(:,1) = (pANOVAPeak{pp}(:,1) <= 0.05) & responSig{pp}(:,1) == 1;
    spatialSig_i{pp}(:,2) = (pANOVAPeak{pp}(:,2) <= 0.05) & responSig{pp}(:,2) == 1;
    spatialSig_i{pp}(:,3) = spatialSig_i{pp}(:,1) & spatialSig_i{pp}(:,2);
    
end
PSTH_PCA = [];
cell_nums = [];
monkey_included_for_analysis = [];
select_all = [];select_temporalSig = [];select_spatialSig = [];
cell_selection();

%% Cell Selection and Cell Counter

    function cell_selection(t_cell_selection_num)  % Cell Selection and Cell Counter
        
        if nargin < 1
            t_cell_selection_num = 2; % Default
        end
        
        t_cell_selection_criteria = ...
            {  %  Logic     Notes
            % all
            'All cells',    uStimType;
            
            % temporally based
            'Cells are temporally tuned',temporalSig_i;
            
            % spatially based
            'Cells are spatially tuned',spatialSig_i;
            
            };
        
        
        select_tcells_all_monkey = t_cell_selection_criteria{t_cell_selection_num,2};
        
        % -------- Update actual dataset for analysis. --------
        monkey_included_for_analysis = monkey_included_for_loading(logical([get(findall(gcbf,'tag','QQ_data'),'value') get(findall(gcbf,'tag','Polo_data'),'value')]));
        monkey_mask_for_analysis = false(length(group_result),1);
        for mm = 1:length(monkey_included_for_analysis)
            monkey_mask_for_analysis = monkey_mask_for_analysis | (cat(1,group_result.monkeyID) == monkey_included_for_analysis(mm));
        end
        
        % -------- Count cell numbers for each monkey.  --------
        cell_nums_toPrint = nan(6,4);
        
        n_monkey = length(monkey_included_for_loading);
        for pp = 1:size(mat_address,1)
            cell_nums{pp} = zeros(length(stimType),n_monkey+1); % Vestibulat/visual
            for mm = 1:n_monkey
                for jj = 1: 2
                    select_monkey{mm} = cat(1,group_result.monkeyID) == monkey_included_for_loading(mm);
                    cell_nums{pp}(jj,mm) = sum(select_tcells_all_monkey{pp}(:,jj) & select_monkey{mm});
                    cell_nums{pp}(jj,n_monkey+1) = sum(select_tcells_all_monkey{pp}(:,jj) & monkey_mask_for_analysis); % cell in use
                end
            end
            cell_nums_toPrint(:,pp) = cell_nums{pp}(:);
        end
        
        
        
        % -------- Affect all analysis below --------
        for pp = 1:size(mat_address,1)
            for jj = 1:3
                select_all{pp}(:,jj) = uStimType{pp}(:,jj) & monkey_mask_for_analysis;
                select_temporalSig{pp}(:,jj) = temporalSig_i{pp}(:,jj) & monkey_mask_for_analysis;
                select_spatialSig{pp}(:,jj) = spatialSig_i{pp}(:,jj) & monkey_mask_for_analysis;
                
            end
        end
        % -------- Update cell counter ---------
        
        h_all = findall(gcbf,'tag','num_all_units');
        set(h_all,'string',sprintf('%3d%6d%9d%6d\n',cell_nums_toPrint'),'fontsize',12.5);
        
        
        h_t_criterion = findall(gcbf,'tag','t_criterion');
        set(h_t_criterion,'string',{t_cell_selection_criteria{:,1}});
        set(h_t_criterion,'value',t_cell_selection_num);
        
    end
%% Load DrawMapping data to get the cell location. HH20161024


%% Final Preparation

% =========== Data for common use ============
function_handles = [];

% to prepare for which monkey is in use to print to figures
monkey_to_print = [];
for ii = 1:length(monkey_included_for_analysis)
    monkey_to_print = [monkey_to_print,Monkeys{monkey_included_for_analysis(ii)},'   '];
end

% ================ Miscellaneous ===================
set(0,'defaultaxesfontsize',12);
% colorDefsLBY;
% Condition = {'Translation','Rotation','T_dark','R_dark'};
%
% set(0,'defaultAxesColorOrder',[0 0 1; 1 0 0; 0 0.8 0.4;]);
colors = {'b','r'};
markers = {'o','^'};
lines = {'-',':'};
transparent = .5;
figN = 2499;
nHist = 11;
%
% marker_for_time_markers{1} = {'-','-','--'};
% marker_for_time_markers{2} = {'--','--','-'};

% time markers
time_markers = group_result(1).mat_raw{1}{1}.markers;
% markerName % markerTime % marker bin time % color

%% ====================================== Function Handles =============================================%

function_handles = {
    'Temporal-spatial modulation', {
    'Temporal modulation', @f1p1;
    '    Mean PSTH', @f1p1p1;
    '    Peak distribution', @f1p1p2;
    'Spatial modulation',@f1p1;
    %     '    DDI distribution',@f1p2p1;
    '    DDI distribution at peak time',@f1p2p4;
    %     '    Preferred direction distribution',@f1p2p2;
    '    Preferred direction distribution at peak time',@f1p2p5;
    'Comparisons between T & R',@f1p3;
    '    DDI distribution',@f1p3p1; % 需要改成peak time
    '    Preferred direction distribution',@f1p3p2; % 需要改成peak time
    'Dark control',@f1p4;
    '    Preferred direction distribution',@f1p4p1; % 需要改成peak time
    '    Rmax-Rmin',@f1p4p2;
    '    DDI distribution',@f1p4p3; % 需要改成peak time
    'Spontaneous FR',@f1p5;
    'PCA',@f1p6
    '    ''Eigen-Time''',@f1p6p1;
    '    ''Eigen-Neuron''',@f1p6p2;
    'Targeted dimensionality reduction',@f1p7;
    '    v&a',@f1p7p1;
    '    ',@f1p7p2;
    };
    
    'Temporal-spatial 3D models', {
    'model fitting evaluation', @f2p1;
    '    BIC distribution across models', @f2p1p1;
    '    R_squared distribution across models', @f2p1p2;
    '    VAF comparison across models', @f2p1p3;
    'Parameter analysis',@f2p2;
    '    Weight ratio (V/A) distribution', @f2p2p1;
    '    Weight distribution (V/A)', @f2p2p5;
    '    Weight (V/A) vs. kmeans', @f2p2p11;
    '    Weight (V/A) vs. PCA', @f2p2p12;
    '    Weight distribution (P,V,A,J weight)', @f2p2p6;
    '    Partial R_squared distribution', @f2p2p4;
    '    Preferred direction & angle difference ( V vs. A)', @f2p2p2;
    '    Preferred direction & angle difference ( V/A vs. J)', @f2p2p7;
    '    Preferred direction & angle difference ( V/A vs. P)', @f2p2p8;
    '    time delay distribution ( V/A )', @f2p2p3;
    '    time delay distribution ( P/V, P/A)', @f2p2p9;
    '    time delay distribution ( J/V, J/A )', @f2p2p10;
    'check',@f2p3;
    '    Weight ratio (V/A) distribution', @f2p3p1;
    
    };
    
    'Temporal-spatial 1D models', {
    'model fitting evaluation', @f3p1;
    '    BIC distribution across models', @f3p1p1;
    '    R_squared distribution across models', @f3p1p2;
    '    VAF comparison across models', @f3p1p3;
    'Parameter analysis',@f3p2;
    '    Weight ratio (V/A) distribution', @f3p2p1;
    '    Weight distribution', @f3p2p5;
    '    Partial R_squared distribution', @f3p2p4;
    '    Preferred direction & angle difference distribution ( V vs. A)', @f3p2p2;
    '    time delay distribution ( V/A, P/V, P/A)', @f3p2p3;
    'check',@f3p3;
    '    Weight ratio (V/A) distribution', @f3p3p1;
    
    };
    
    'Comparison between 3D & 1D models', {
    'R_squared comparison', @f4p1;
    'Weight ratio (V/A) comparison', @f4p2;
    };
    
    'Others',{
    'Cell Counter',@f5p1;
    'Test',@f5p9;
    };
    
    'NoShow',{@cell_selection};
    
    };

% %{
responNo = [];
h = [];
hbar = [];
hl = [];

meanPSTH = [];
stePSTH = [];
stdPSTH = [];
sigI = [];
DDI_spatial = [];
xDDI = [];
n_vesti = [];
n_vis = [];
medianVesti = [];
medianVis = [];
select_inx = [];
h_subplot = [];
xazi = [];
xele = [];
preDir_spatial = [];
medianAzi = [];
medianEle = [];
n_azi = [];
n_ele = [];
preDir_diff = [];
n_diff  =[];
xdiff = [];
time_i = [];
time_vel = [];veloc_value=[];time_acc=[];accel_value=[];
vel_to_plot = [];
acc_to_plot = [];
vel_temp = [];
acc_temp = [];
medianT = [];
medianR = [];
n_T = [];
n_R = [];
medianDiff = [];
n_diff_tempo = [];
Rextre_spatial = [];
temp = [];
range = [];
BIC_min = [];
n_BIC = [];
BestFitModel = [];
R2_plot = [];
xR2 = [];
n_R2 = [];
medianTemp = [];
RatioVA_VA = [];
RatioVA_VAJ = [];
RatioVA_VAP = [];
RatioVA_PVAJ = [];
xVA = [];
n_VA_VA  =[];
n_VA_VAJ  =[];
n_VA_VAP  =[];
n_VA_PVAJ  =[];
medianVA_VA = [];
medianVA_VAJ = [];
medianVA_VAP = [];
medianVA_PVAJ = [];
xDiff = [];
angleDiff_VA_VA_plot = [];
n_Diff_VA_VA = [];
medianDiff_VA_VA = [];
preDir_V_VA_azi = [];
preDir_V_VA_ele = [];
preDir_A_VA_azi = [];
preDir_A_VA_ele = [];
n_Delay_VA_VA = [];
medianDelay_VA_VA = [];
delay_VA_VA = [];
xDelay = [];
DDI_plot = [];
wV_VA_plot = [];
wA_VA_plot = [];
idx2 = [];
idx1 = [];
peakT_plot= [];
DDI_peak_plot= [];
dPeakIdx= [];
sPeakIdx= [];
nPeakIdx= [];
noDPeak= [];
noSPeak= [];
noNPeak= [];
DDI_dPeak= [];
DDI_sPeak= [];
n_DDI = [];
medianDDI = [];
RSS_temp = [];
seqF = [];
R2_plot_sig = [];
n_DDI_early= [];
n_DDI_late= [];
medianDDI_early= [];
medianDDI_late= [];
dPeakT = [];
sPeakT = [];
n_peakT = [];
medianPeakT = [];
xPeakT = [];
n_peakT_early = [];
n_peakT_late = [];
medianPeakT_late = [];
medianPeakT_early = [];
dPeakT_late = [];
dPeakT_early = [];
dPeakIdx_early = [];
dPeakIdx_late = [];
DDI_dPeak_early = [];
DDI_dPeak_late = [];
preDir_peak_plot = [];
preDir_dPeak_early = [];
preDir_dPeak_late = [];
n_preDir_early= [];
n_preDir_late= [];
medianPreDir_early= [];
medianPreDir_late= [];
preDir_sPeak= [];
n_preDir = [];
medianPreDir = [];
preDir_plot_azi = [];
preDir_plot_ele = [];
preDir_sPeak_azi = [];
preDir_sPeak_ele = [];
preDir_dPeak_early_azi = [];
preDir_dPeak_early_ele = [];
preDir_dPeak_late_azi = [];
preDir_dPeak_late_ele = [];
bothSPeakIdx = [];
preDir_sPeak_diff = [];
bothDPeakIdx = [];
temp1 = [];
temp2 = [];
dataPCA = [];
weights_PCA_PC = [];
score = [];
latent = [];
PCA_explained{pp}{jj} = [];
PCA_projPC = [];
PCA_times = [];
R2_plot_1D = [];
R2_plot_3D = [];
r2_VA = [];
r2_thre = [];
a = 3;
b = 3;
c = 3;
%}
%     %{
%% ====================================== Function Definitions =============================================%

    function f1p1(debug)      % Temporal response
        if debug  ; dbstack;   keyboard;      end
        
        for sigI = 1:3
            responNo(:,(sigI-1)*3+1) = cell2mat(cellfun(@(x) sum(x(:,sigI)),select_all,'UniformOutput',false))';
            responNo(:,(sigI-1)*3+2) = cell2mat(cellfun(@(x) sum(x(:,sigI)),select_temporalSig,'UniformOutput',false))';
            responNo(:,(sigI-1)*3+3) = cell2mat(cellfun(@(x) sum(x(:,sigI)),select_spatialSig,'UniformOutput',false))';
        end
        
        figure(11);set(figure(11),'name','Distribution of number of cells (temporal & spatial response)','unit','normalized','pos',[-0.55 0.4 0.53 0.35]); clf;
        h = axes('pos',[0.1 0.2 0.8 0.6]);
        hbar = bar(responNo);
        set(hbar(1:3),'facecolor','b','edgecolor','b');set(hbar(4:6),'facecolor','r','edgecolor','r');set(hbar(7:9),'facecolor','k','edgecolor','k');
        set(gca,'xticklabel',{'Translation','Rotation','T (dark)','R (dark)'});ylabel(gca,'cell #');
        hl = legend('Total cells','Cells temporally tuned','Cells spatially tuned','location','northeast');set(hl,'Box','off');
        title(['Number of cells   (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
        barvalues(hbar);
        
    end

    function f1p1p1(debug)      % Mean PSTH
        if debug  ; dbstack;   keyboard;      end
        
        [time_vel,veloc_value,time_acc,accel_value] = Real_acc_vel(0);
        vel_temp = veloc_value((1:(time_markers{2,3}-time_markers{1,3}))*floor(length(time_vel)/(time_markers{2,3}-time_markers{1,3})));
        acc_temp = accel_value((1:(time_markers{2,3}-time_markers{1,3}))*floor(length(time_vel)/(time_markers{2,3}-time_markers{1,3})));
        
        % pack PSTH data, according to temporal tuning
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                % meanPSTH for each cell
                meanPSTH{1}{pp}(jj,:) = mean(PSTH{pp}{jj}(select_all{pp}(:,jj),:),1);
                meanPSTH{2}{pp}(jj,:) = mean(PSTH{pp}{jj}(select_temporalSig{pp}(:,jj),:),1);
                meanPSTH{3}{pp}(jj,:) = mean(PSTH{pp}{jj}(select_spatialSig{pp}(:,jj),:),1);
                
                stdPSTH{1}{pp}(jj,:) = std(PSTH{pp}{jj}(select_all{pp}(:,jj),:),0,1);
                stdPSTH{2}{pp}(jj,:) = std(PSTH{pp}{jj}(select_temporalSig{pp}(:,jj),:),0,1);
                stdPSTH{3}{pp}(jj,:) = std(PSTH{pp}{jj}(select_spatialSig{pp}(:,jj),:),0,1);
                
                stePSTH{1}{pp}(jj,:) = stdPSTH{1}{pp}(jj,:)/sqrt(sum(select_all{pp}(:,jj)));
                stePSTH{2}{pp}(jj,:) = stdPSTH{1}{pp}(jj,:)/sqrt(sum(select_temporalSig{pp}(:,jj)));
                stePSTH{3}{pp}(jj,:) = stdPSTH{1}{pp}(jj,:)/sqrt(sum(select_spatialSig{pp}(:,jj)));
            end
        end
        
        % plot figures
        figure(11);set(figure(11),'name','Mean PSTH for selected cells','unit','normalized','pos',[-0.55 0 0.53 0.8]); clf;
        [~,h_subplot] = tight_subplot(4,3,0.1,0.1,[0.15 0.02]);
        
        for pp = 1:size(mat_address,1)
            for select_inx = 1:3
                vel_to_plot{select_inx}{pp} = vel_temp * ((max(meanPSTH{select_inx}{pp}(:))-min(meanPSTH{select_inx}{pp}(:)))/(max(vel_temp)-min(vel_temp)))/2;
                acc_to_plot{select_inx}{pp} = acc_temp * ((max(meanPSTH{select_inx}{pp}(:))-min(meanPSTH{select_inx}{pp}(:)))/(max(vel_temp)-min(vel_temp)))/2;
                
                axes(h_subplot((pp-1)*3+select_inx));hold on;
                % vestibular
                % shadedErrorBar(1:size(T_vestiPSTHSig,2),nanmean(T_vestiPSTHSig,1),nanstd(T_vestiPSTHSig,1)/sqrt(size(T_vestiPSTHSig,2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
                shadedErrorBar(1:size(meanPSTH{select_inx}{pp}(1,:),2),meanPSTH{select_inx}{pp}(1,:),stePSTH{select_inx}{pp}(1,:),{'-','color','b','linewidth',4},transparent);
                shadedErrorBar(1:size(meanPSTH{select_inx}{pp}(2,:),2),meanPSTH{select_inx}{pp}(2,:),stePSTH{select_inx}{pp}(2,:),{'-','color','r','linewidth',4},transparent);
                set(gca,'xtick',[time_markers{1,3},(time_markers{1,3}+time_markers{2,3})/2,time_markers{2,3}],'xticklabel',{'0','0.75','1.5'},'xlim',[0 size(meanPSTH{select_inx}{pp}(1,:),2)]);xlabel('Time from stim on (s)');ylabel('Firing rate (Hz)');
                for time_i = 3:5
                    plot([time_markers{time_i,3} time_markers{time_i,3}],[0 max(meanPSTH{select_inx}{pp}(:))],'-','color',time_markers{time_i,4});
                end
                %             plot(time_markers{1,3}-time_markers{1,3}),vel_to_plot{select_inx}{pp},'r-','linewidth',2);
                %             plot(1:(time_markers{2,3}-time_markers{1,3}),acc_to_plot{select_inx}{pp},'b-','linewidth',2);
                axis on;
            end
        end
        
        suptitle(['Mean PSTH   (Monkey = ',monkey_to_print,')']);
        SetFigure(25);
        
        % text necessary infos
        h = axes('pos',[0.05 0.02 0.9 0.05]);
        text(0.2,0,'All cells');text(0.5,0,'Temporally tuned cells');text(0.85,0,'Spatially tuned cells');
        axis off;
        h = axes('pos',[0.05 0.1 0.05 0.75]);
        text(0.2,0.9,'Translation','rotation',90);text(0.2,0.6,'Rotation','rotation',90);text(0.2,0.35,'T (dark)','rotation',90);text(0.2,0.05,'R (dark)','rotation',90);
        axis off;
        
    end

    function f1p1p2(debug)      % Peak distribution
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:2
            for jj = 1:2
                peakT_plot{pp}{jj} = peakT{pp}{jj}(select_temporalSig{pp}(:,jj));
                dPeakIdx{pp}{jj} = logical(cellfun(@length,peakT_plot{pp}{jj}) == 2); % double peak
                sPeakIdx{pp}{jj} = logical(cellfun(@length,peakT_plot{pp}{jj}) == 1); % single peak
                nPeakIdx{pp}{jj} = logical(cellfun(@length,peakT_plot{pp}{jj}) == 0); % not tuned
                noDPeak(pp,jj) = sum(dPeakIdx{pp}{jj});
                noSPeak(pp,jj) = sum(sPeakIdx{pp}{jj});
                noNPeak(pp,jj) = sum(nPeakIdx{pp}{jj});
                dPeakT{pp}{jj} = (reshape(cell2mat(peakT_plot{pp}{jj}(dPeakIdx{pp}{jj})),2,[])-stimOnBin)*totalBinT/nBins;
                dPeakT_late{pp}{jj} = bsxfun(@max,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                dPeakT_early{pp}{jj} = bsxfun(@min,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                sPeakT{pp}{jj} = (cell2mat(peakT_plot{pp}{jj}(sPeakIdx{pp}{jj}))-stimOnBin)*totalBinT/nBins;
                
            end
        end
        
        % plot figures for peak time distribution (Single-peaked cells)
        xPeakT = linspace(0,duration,21);
        figure(11);set(figure(11),'name','Distribution of peak time (Single-peaked cells)','unit','pixels','pos',[-1070 300 1050 400]); clf;
        [~,h_subplot] = tight_subplot(1,4,0.05,0.2,[0.05 0.05]);
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((pp-1)*2+jj));hold on;
                n_peakT{pp}{jj} = hist(sPeakT{pp}{jj},xPeakT);
                medianPeakT{pp}(jj) = median(sPeakT{pp}{jj});
                hbar{pp} = bar(xPeakT,n_peakT{pp}{jj});set(hbar{pp},'facecolor',colors{jj},'edgecolor',colors{jj});
                xlabel('Time (ms)');ylabel('cell #');set(gca,'xlim',[0 duration]);
                plot([medianPeakT{pp}(jj) medianPeakT{pp}(jj)],[0 max(n_peakT{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                text(medianPeakT{pp}(jj),max(n_peakT{pp}{jj})*1.2,num2str(medianPeakT{pp}(jj)));
                text(1,max(n_peakT{pp}{jj}),['n = ',num2str(length(sPeakT{pp}{jj}))]);
                axis on;hold off;
                
            end
        end
        % text necessary infos
        axes('pos',[0.1 0.95 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of DDI   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        suptitle('Distribution of peak time (Single-peaked cells)');
        SetFigure(12);
        
        % plot figures for peak distribution (Double-peaked cells)
        xPeakT = linspace(0,duration,21);
        figure(12);set(figure(12),'name','Distribution of peak time (Double peaked cells)','unit','pixels','pos',[-1070 -200 1050 300]); clf;
        [~,h_subplot] = tight_subplot(1,4,0.05,0.2,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                
                if ~isempty(dPeakT_early{pp}{jj}) && ~isempty(dPeakT_late{pp}{jj})
                    n_peakT_early{pp}{jj} = hist(dPeakT_early{pp}{jj},xPeakT);
                    medianPeakT_early{pp}(jj) = median(dPeakT_early{pp}{jj});
                    n_peakT_late{pp}{jj} = hist(dPeakT_late{pp}{jj},xPeakT);
                    n_peakT_late{pp}{jj} = n_peakT_late{pp}{jj} * -1;
                    medianPeakT_late{pp}(jj) = median(dPeakT_late{pp}{jj});
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    %                 axes(h_subplot(((jj-1)*2+pp-1)*2+1));hold on;
                    hbar{pp,1} = bar(xPeakT,n_peakT_early{pp}{jj});set(hbar{pp,1},'facecolor',colors{jj},'edgecolor',colors{jj});
                    hbar{pp,2} = bar(xPeakT,n_peakT_late{pp}{jj});set(hbar{pp,2},'facecolor',colors{jj},'edgecolor',colors{jj});
                    xlabel('Time (ms)');ylabel('cell #');set(gca,'xlim',[0 duration]);
                    plot([medianPeakT_early{pp}(jj) medianPeakT_early{pp}(jj)],[0 max(n_peakT_early{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                    text(medianPeakT_early{pp}(jj),max(n_peakT_early{pp}{jj})*1.2,num2str(medianPeakT_early{pp}(jj)));
                    plot([medianPeakT_late{pp}(jj) medianPeakT_late{pp}(jj)],[0 min(n_peakT_late{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                    text(medianPeakT_late{pp}(jj),min(n_peakT_late{pp}{jj})*1.2,num2str(medianPeakT_late{pp}(jj)));
                    text(1,max(n_peakT_early{pp}{jj}),['n = ',num2str(size(dPeakT{pp}{jj},2))]);
                    axis on;hold off;
                end
            end
        end
        % text necessary infos
        axes('pos',[0.05 0.1 0.05 0.75]);
        text(-0.5,0.7,'Early-peak','rotation',90);text(-0.5,0.2,'Late-peak','rotation',90);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.2,0,'Translation');text(0.7,0,'Rotation'); axis off;
        suptitle('Distribution of peak time (Double peaked cells)');
        SetFigure(12);
    end

    function f1p2p1(debug)      % DDI distribution
        if debug  ; dbstack;   keyboard;      end
        DDI_spatial = [];DDI_plot = [];
        % pack data
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                DDI_spatial{pp}.tempoSig(:,jj) = DDI{pp}(select_temporalSig{pp}(:,1),jj);
                DDI_spatial{pp}.vestiSig(:,jj) = DDI{pp}(select_spatialSig{pp}(:,1),jj);
                DDI_spatial{pp}.visSig(:,jj) = DDI{pp}(select_spatialSig{pp}(:,2),jj);
                DDI_spatial{pp}.bothSig(:,jj) = DDI{pp}(select_spatialSig{pp}(:,3),jj);
                DDI_plot{pp}{jj} = {DDI_spatial{pp}.tempoSig(:,jj);DDI_spatial{pp}.vestiSig(:,jj);DDI_spatial{pp}.visSig(:,jj);DDI_spatial{pp}.bothSig(:,jj)};
                
            end
        end
        
        % plot figures for DDI distribution (vestibular DDI vs. visual DDI)
        figure(11);set(figure(11),'name','Distribution of DDI (vestibular vs. visual)','unit','pixels','pos',[-1070 200 1050 600]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.2,0.2,[0.1 0.1]);
        hl = [];
        for pp = 1:2
            hl{pp} = LinearCorrelation(DDI_plot{pp}{1},DDI_plot{pp}{2},...
                'Xlabel','DDI (Vestibular)','Ylabel','DDI (Visual)','FaceColors',{'w','b','r','k'},'EdgeColors',{'k','b','r','k'},'Markers',{'o'},...
                'LineStyles',{'w--','b--','r--','k--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'Xlim',[0 1],'Ylim',[0 1],...
                'LinearCorr',0,'figN',11,'Axes',h_subplot(pp),'LegendOn',0);
        end
        % text necessary infos
        axes('pos',[0.1 0.9 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of DDI   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        SetFigure(12);
        
    end

    function f1p2p4(debug)      % DDI distribution at peak time
        if debug  ; dbstack;   keyboard;      end
        hbar = [];
        for pp = 1:2
            for jj = 1:2
                peakT_plot{pp}{jj} = peakT{pp}{jj}(select_spatialSig{pp}(:,jj));
                DDI_peak_plot{pp}{jj} = DDI_peak{pp}{jj}(select_spatialSig{pp}(:,jj));
                DDI_pPeak_plot{pp}{jj} = DDI_pPeak{pp}{jj}(select_spatialSig{pp}(:,jj));
% peakT_plot{pp}{jj} = peakT{pp}{jj}(select_temporalSig{pp}(:,jj));
%                 DDI_peak_plot{pp}{jj} = DDI_peak{pp}{jj}(select_temporalSig{pp}(:,jj));
%                 DDI_pPeak_plot{pp}{jj} = DDI_pPeak{pp}{jj}(select_temporalSig{pp}(:,jj));
                dPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 2); % double peak
                sPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 1); % single peak
                nPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 0); % not tuned
                DDI_pPeak_plot_s{pp}{jj} = cell2mat(DDI_pPeak_plot{pp}{jj}(sPeakIdx{pp}{jj}));
                DDI_pPeak_plot_d{pp}{jj} = reshape(cell2mat(DDI_pPeak_plot{pp}{jj}(dPeakIdx{pp}{jj})),2,[]);
                noDPeak(pp,jj) = sum(dPeakIdx{pp}{jj});
                noSPeak(pp,jj) = sum(sPeakIdx{pp}{jj});
                noNPeak(pp,jj) = sum(nPeakIdx{pp}{jj});
                dPeakT{pp}{jj} = reshape(cell2mat(peakT_plot{pp}{jj}(dPeakIdx{pp}{jj})),2,[]);
                dPeakT_late{pp}{jj} = bsxfun(@max,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                dPeakT_early{pp}{jj} = bsxfun(@min,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                % initialize
                DDI_sPeak{pp}{jj} = [];
                DDI_dPeak_early{pp}{jj} = [];
                DDI_dPeak_late{pp}{jj} = [];
                
                for ii = 1:length(dPeakT_late{pp}{jj});
                    dPeakIdx_early{pp}{jj}(ii) = find(dPeakT{pp}{jj}(:,ii) == dPeakT_early{pp}{jj}(ii));
                    dPeakIdx_late{pp}{jj}(ii) = find(dPeakT{pp}{jj}(:,ii) == dPeakT_late{pp}{jj}(ii));
                    DDI_dPeak_early{pp}{jj}(ii) = DDI_peak_plot{pp}{jj}{dPeakIdx{pp}{jj}(ii)}(dPeakIdx_early{pp}{jj}(ii));
                    DDI_dPeak_early_sig{pp}{jj}(ii) = nan;
                    DDI_dPeak_late{pp}{jj}(ii) = DDI_peak_plot{pp}{jj}{dPeakIdx{pp}{jj}(ii)}(dPeakIdx_late{pp}{jj}(ii));
                    DDI_dPeak_late_sig{pp}{jj}(ii) = nan;
                end
                DDI_dPeak_early_sig{pp}{jj} = DDI_dPeak_early{pp}{jj}(DDI_pPeak_plot_d{pp}{jj}(1,:)<0.05);
                DDI_dPeak_late_sig{pp}{jj} = DDI_dPeak_late{pp}{jj}(DDI_pPeak_plot_d{pp}{jj}(2,:)<0.05);
                DDI_sPeak{pp}{jj} = cell2mat(DDI_peak_plot{pp}{jj}(sPeakIdx{pp}{jj}));
                DDI_sPeak_sig{pp}{jj} = nan(1,length(DDI_pPeak_plot_s{pp}{jj}));
                DDI_sPeak_sig{pp}{jj} = DDI_sPeak{pp}{jj}(DDI_pPeak_plot_s{pp}{jj}<0.05);
            end
        end
        
        
        % plot figures for DDI distribution (Single-peaked cells)
        xDDI = linspace(0,1,11);
        figure(11);set(figure(11),'name','Distribution of DDI at peak time (Single-peaked cells)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                n_DDI{pp}{jj} = hist(DDI_sPeak{pp}{jj},xDDI);
                medianDDI{pp}(jj) = median(DDI_sPeak{pp}{jj});
                n_DDI_sig{pp}{jj} = hist(DDI_sPeak_sig{pp}{jj},xDDI);
                medianDDI_sig{pp}(jj) = median(DDI_sPeak_sig{pp}{jj});
                hbar{pp} = bar(xDDI,n_DDI{pp}{jj});set(hbar{pp},'facecolor','w','edgecolor',colors{jj});
                hbar_sig{pp} = bar(xDDI,n_DDI_sig{pp}{jj});set(hbar_sig{pp},'facecolor',colors{jj},'edgecolor',colors{jj});
                xlabel('DDI');ylabel('cell #');set(gca,'xlim',[0 1]);
                plot([medianDDI_sig{pp}(jj) medianDDI_sig{pp}(jj)],[0 max(n_DDI_sig{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                text(medianDDI_sig{pp}(jj),max(n_DDI_sig{pp}{jj})*1.2,num2str(medianDDI_sig{pp}(jj)));
                text(0.1,max(n_DDI_sig{pp}{jj}),['n = ',num2str(length(DDI_sPeak_sig{pp}{jj}))]);
                axis on;hold off;
                
                
            end
        end
        % text necessary infos
        axes('pos',[0.1 0.95 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of DDI   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        suptitle('Distribution of DDI at peak time (Single-peaked cells)');
        SetFigure(12);
        
        % plot figures for DDI distribution (Double-peaked cells)
        xDDI = linspace(0,1,11);
        figure(12);set(figure(12),'name','Distribution of DDI at peak time (Double-peaked cells)','unit','pixels','pos',[-1070 -600 1050 1300]); clf;
        [~,h_subplot] = tight_subplot(4,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                
                if ~isempty(DDI_dPeak_early{pp}{jj})
                    n_DDI_early{pp}{jj} = hist(DDI_dPeak_early{pp}{jj},xDDI);
                    medianDDI_early{pp}(jj) = median(DDI_dPeak_early{pp}{jj});
                    n_DDI_early_sig{pp}{jj} = hist(DDI_dPeak_early_sig{pp}{jj},xDDI);
                    medianDDI_early_sig{pp}(jj) = median(DDI_dPeak_early_sig{pp}{jj});
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    %                 axes(h_subplot(((jj-1)*2+pp-1)*2+1));hold on;
                    hbar{pp,1} = bar(xDDI,n_DDI_early{pp}{jj});set(hbar{pp,1},'facecolor','w','edgecolor',colors{jj});
                    hbar_sig{pp,1} = bar(xDDI,n_DDI_early_sig{pp}{jj});set(hbar_sig{pp,1},'facecolor',colors{jj},'edgecolor',colors{jj});
                    xlabel('DDI');ylabel('cell #');set(gca,'xlim',[0 1]);
                    plot([medianDDI_early_sig{pp}(jj) medianDDI_early_sig{pp}(jj)],[0 max(n_DDI_early_sig{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                    text(medianDDI_early_sig{pp}(jj),max(n_DDI_early_sig{pp}{jj})*1.2,num2str(medianDDI_early_sig{pp}(jj)));
                    text(0.1,max(n_DDI_early_sig{pp}{jj}),['n = ',num2str(size(DDI_dPeak_early_sig{pp}{jj},2))]);
                    axis on;hold off;
                end
                if ~isempty(DDI_dPeak_late{pp}{jj})
                    n_DDI_late{pp}{jj} = hist(DDI_dPeak_late{pp}{jj},xDDI);
                    medianDDI_late{pp}(jj) = median(DDI_dPeak_late{pp}{jj});
                    n_DDI_late_sig{pp}{jj} = hist(DDI_dPeak_late_sig{pp}{jj},xDDI);
                    medianDDI_late_sig{pp}(jj) = median(DDI_dPeak_late_sig{pp}{jj});
                    axes(h_subplot(((pp-1)*2+jj)+4));hold on;
                    %                 axes(h_subplot(((jj-1)*2+pp)*2));hold on;
                    hbar{pp,2} = bar(xDDI,n_DDI_late{pp}{jj});set(hbar{pp,2},'facecolor','w','edgecolor',colors{jj});
                    hbar_sig{pp,2} = bar(xDDI,n_DDI_late_sig{pp}{jj});set(hbar_sig{pp,2},'facecolor',colors{jj},'edgecolor',colors{jj});
                    xlabel('DDI');ylabel('cell #');set(gca,'xlim',[0 1]);
                    plot([medianDDI_late_sig{pp}(jj) medianDDI_late_sig{pp}(jj)],[0 max(n_DDI_late_sig{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                    text(medianDDI_late_sig{pp}(jj),max(n_DDI_late_sig{pp}{jj})*1.2,num2str(medianDDI_late_sig{pp}(jj)));
                    text(0.1,max(n_DDI_late_sig{pp}{jj}),['n = ',num2str(size(DDI_dPeak_late_sig{pp}{jj},2))]);
                    axis on;hold off;
                end
            end
        end
        % text necessary infos
        axes('pos',[0.05 0.1 0.05 0.75]);
        text(-0.5,0.7,'Early-peak','rotation',90);text(-0.5,0.2,'Late-peak','rotation',90);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.2,0,'Translation');text(0.7,0,'Rotation'); axis off;
        suptitle('Distribution of DDI at peak time (Double-peaked cells)');
        SetFigure(12);
        
        figure(13);set(figure(13),'name','Distribution of DDI at peak time (Double-peaked cells, early peak vs. late peak)','unit','pixels','pos',[-1070 -850 1050 400]); clf;
        [~,h_subplot] = tight_subplot(1,4,0.07,0.05,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                if ~isempty(DDI_dPeak_early{pp}{jj}) && ~isempty(DDI_dPeak_late{pp}{jj})
                    axes(h_subplot((pp-1)*2+jj));hold on;axis square;
                    h  = plot(DDI_dPeak_early{pp}{jj},DDI_dPeak_late{pp}{jj},'ko','markersize',6,'markerfacecolor',colors{jj},'markeredgecolor','k');
                    xlabel('DDI, early peak');ylabel('DDI, late peak');set(gca,'xlim',[0 1],'ylim',[0 1]);
                    plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
                    text(0.1,0.7,['n = ',num2str(size(DDI_dPeak_late{pp}{jj},2))]);
                    axis on;hold off;
                end
            end
        end
        % text necessary infos
        axes('pos',[0.05 0.95 0.9 0.1]);
        text(0.2,0,'Translation');text(0.7,0,'Rotation'); axis off;
        suptitle('Distribution of DDI at peak time (Double-peaked cells, early peak vs. late peak)');
        SetFigure(12);
        
        % plot figures for DDI distribution (Single-peaked cells and early peak of double-peaked cells)
        xDDI = linspace(0,1,11);
        figure(13);set(figure(13),'name','Distribution of DDI at peak time (Single-peaked cells and  early peak of double-peaked cells)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                DDI_sdPeak{pp}{jj} = [DDI_sPeak{pp}{jj}, DDI_dPeak_early{pp}{jj}];
                n_DDI{pp}{jj} = hist(DDI_sdPeak{pp}{jj},xDDI);
                medianDDI{pp}(jj) = median(DDI_sdPeak{pp}{jj});
                DDI_sdPeak_sig{pp}{jj} = [DDI_sPeak_sig{pp}{jj}, DDI_dPeak_early_sig{pp}{jj}];
                n_DDI_sig{pp}{jj} = hist(DDI_sPeak_sig{pp}{jj},xDDI);
                medianDDI_sig{pp}(jj) = median(DDI_sdPeak_sig{pp}{jj});
                hbar{pp} = bar(xDDI,n_DDI{pp}{jj});set(hbar{pp},'facecolor','w','edgecolor',colors{jj});
                hbar_sig{pp} = bar(xDDI,n_DDI_sig{pp}{jj});set(hbar_sig{pp},'facecolor',colors{jj},'edgecolor',colors{jj});
                xlabel('DDI');ylabel('cell #');set(gca,'xlim',[0 1]);
                plot([medianDDI_sig{pp}(jj) medianDDI_sig{pp}(jj)],[0 max(n_DDI_sig{pp}{jj})*1.1],'k--','color',colors{jj},'linewidth',1.5);
                text(medianDDI_sig{pp}(jj),max(n_DDI_sig{pp}{jj})*1.2,num2str(medianDDI_sig{pp}(jj)));
                text(0.1,max(n_DDI_sig{pp}{jj}),['n = ',num2str(length(DDI_sPeak_sig{pp}{jj}))]);
                axis on;hold off;
                
                
            end
        end
        % text necessary infos
        axes('pos',[0.1 0.95 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of DDI   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        suptitle('Distribution of DDI at peak time (Single-peaked cells and early peak of double-peaked cells)');
        SetFigure(12);
        
    end

    function f1p2p2(debug)      % Preferred direction distribution
        if debug  ; dbstack;   keyboard;      end
        preDir_spatial = []; preDir_plot_azi = [];preDir_plot_ele = [];preDir_diff = [];
        % pack data
        for pp = 1:size(mat_address,1)
            preDir_spatial{pp}.tempoSig = cellfun(@(x) reshape(x(repmat(select_temporalSig{pp}(:,3),1,3)),[],3), preDir{pp},'UniformOutput',false);
            preDir_spatial{pp}.vestiSig = cellfun(@(x) reshape(x(repmat(select_spatialSig{pp}(:,1),1,3)),[],3), preDir{pp},'UniformOutput',false);
            preDir_spatial{pp}.visSig = cellfun(@(x) reshape(x(repmat(select_spatialSig{pp}(:,2),1,3)),[],3), preDir{pp},'UniformOutput',false);
            preDir_spatial{pp}.bothSig = cellfun(@(x) reshape(x(repmat(select_spatialSig{pp}(:,3),1,3)),[],3), preDir{pp},'UniformOutput',false);
            preDir_plot_azi{pp} = {preDir_spatial{pp}.tempoSig{1}(:,1);preDir_spatial{pp}.tempoSig{2}(:,1);preDir_spatial{pp}.vestiSig{1}(:,1);preDir_spatial{pp}.visSig{2}(:,1)};
            preDir_plot_ele{pp} = {preDir_spatial{pp}.tempoSig{1}(:,2);preDir_spatial{pp}.tempoSig{2}(:,2);preDir_spatial{pp}.vestiSig{1}(:,2);preDir_spatial{pp}.visSig{2}(:,2)};
            preDir_diff{pp}.tempoSig = angleDiff(preDir_spatial{pp}.tempoSig{1}(:,1),preDir_spatial{pp}.tempoSig{1}(:,2),preDir_spatial{pp}.tempoSig{1}(:,3),preDir_spatial{pp}.tempoSig{2}(:,1),preDir_spatial{pp}.tempoSig{2}(:,2),preDir_spatial{pp}.tempoSig{2}(:,3));
            preDir_diff{pp}.bothSig = angleDiff(preDir_spatial{pp}.bothSig{1}(:,1),preDir_spatial{pp}.bothSig{1}(:,2),preDir_spatial{pp}.bothSig{1}(:,3),preDir_spatial{pp}.bothSig{2}(:,1),preDir_spatial{pp}.bothSig{2}(:,2),preDir_spatial{pp}.bothSig{2}(:,3));
            
        end
        hl = [];hbar = [];
        % plot figures for preferred direction distribution (T & R)
        figure(11);set(figure(11),'name','Distribution of preferred direction','unit','pixels','pos',[-1070 200 1050 600]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.2,0.2,[0.1 0.1]);
        for pp = 1:2
            hl{pp} = LinearCorrelation(preDir_plot_azi{pp},preDir_plot_ele{pp},...
                'Xlabel','Preferred azimuth (degree)','Ylabel','Preferred elevation (degree)','FaceColors',{'w','w','b','r'},'EdgeColors',{'k','k','b','r'},'Markers',{'o'},...
                'LineStyles',{'w--','w--','b--','r--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'Xlim',[0 360],'Ylim',[-90 90],...
                'LinearCorr',0,'figN',11,'Axes',h_subplot(pp),'LegendOn',0,'YDirR',1,...
                'XTick',{[0 90 180 270 360];{'0','90','180','270','360'}},'YTick',{[-90 -45 0 45 90];{'-90','-45','0','45','90'}});
        end
        % text necessary infos
        axes('pos',[0.1 0.9 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of preferred direction   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        SetFigure(12);
        
        
        % plot figures for delta preferred direction distribution (between vestibular & visual)
        hl = [];hbar = [];
        xdiff = linspace(0,180,12);
        figure(12);set(figure(12),'name','Distribution of delta preferred direction (vestibular vs. visual)','unit','pixels','pos',[-1070 -300 1050 350]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.1,0.3,0.1);
        
        for pp = 1:2
            axes(h_subplot(pp));hold on;
            
            [n_diff{pp}(1,:), ~] = hist(preDir_diff{pp}.tempoSig,xdiff);
            [n_diff{pp}(2,:), ~] = hist(preDir_diff{pp}.bothSig,xdiff);
            
            medianAzi{pp}(1) = median(preDir_diff{pp}.bothSig);
            
            hbar{1}{pp} = bar(xdiff,n_diff{pp}(1,:));set(hbar{1}{pp},'facecolor','w','edgecolor','k');
            hbar{2}{pp} = bar(xdiff,n_diff{pp}(2,:));set(hbar{2}{pp},'facecolor','k','edgecolor','k');
            set(gca,'xtick',[0 90 180]);xlabel('\Delta preferred direction');ylabel('cell #');set(gca,'xlim',[0 180]);
            plot([medianAzi{pp}(1) medianAzi{pp}(1)],[0 max(n_diff{pp}(:))*1.1],'k--','linewidth',1.5);
            text(medianAzi{pp}(1),max(n_diff{pp}(:))*1.2,num2str(medianAzi{pp}(1)));
            axis on;hold off;
        end
        suptitle(['Distribution of \Delta preferred direction   (Monkey = ',monkey_to_print,')']);
        % text necessary infos
        axes('pos',[0.1 0.1 0.8 0.05]);
        text(0.1,0,['Translation, n = ',num2str(sum(select_spatialSig{1}(:,3)))]);
        text(0.7,0,['Rotation, n = ',num2str(sum(select_spatialSig{2}(:,3)))]);
        axis off;
        SetFigure(12);
        
    end

    function f1p2p5(debug)      % Preferred direction distribution at peak time
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:2
            for jj = 1:2
                peakT_plot{pp}{jj} = peakT{pp}{jj}(select_temporalSig{pp}(:,jj));
                preDir_peak_plot{pp}{jj} = preDir_peak{pp}{jj}(select_temporalSig{pp}(:,jj));
                dPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 2); % double peak
                sPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 1); % single peak
                nPeakIdx{pp}{jj} = find(cellfun(@length,peakT_plot{pp}{jj}) == 0); % not tuned
                noDPeak(pp,jj) = sum(dPeakIdx{pp}{jj});
                noSPeak(pp,jj) = sum(sPeakIdx{pp}{jj});
                noNPeak(pp,jj) = sum(nPeakIdx{pp}{jj});
                dPeakT{pp}{jj} = reshape(cell2mat(peakT_plot{pp}{jj}(dPeakIdx{pp}{jj})),2,[]);
                dPeakT_late{pp}{jj} = bsxfun(@max,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                dPeakT_early{pp}{jj} = bsxfun(@min,dPeakT{pp}{jj}(1,:),dPeakT{pp}{jj}(2,:));
                preDir_sPeak{pp}{jj} = []; % initialization
                preDir_dPeak_early{pp}{jj} = [];
                preDir_dPeak_late{pp}{jj} = [];
                % for plotting
                %                 preDir_dPeak_early_azi{pp}{jj} = [0;0;0];
                %                 preDir_dPeak_early_ele{pp}{jj} = [0;0;0];
                %                 preDir_dPeak_late_azi{pp}{jj} = [0;0;0];
                %                 preDir_dPeak_late_ele{pp}{jj} = [0;0;0];
                preDir_dPeak_early_azi{pp}{jj} = nan;
                preDir_dPeak_early_ele{pp}{jj} = nan;
                preDir_sPeak_azi{pp}{jj} = nan;
                preDir_sPeak_ele{pp}{jj} = nan;
                for ii = 1:length(dPeakT_late{pp}{jj});
                    dPeakIdx_early{pp}{jj}(ii) = find(dPeakT{pp}{jj}(:,ii) == dPeakT_early{pp}{jj}(ii));
                    dPeakIdx_late{pp}{jj}(ii) = find(dPeakT{pp}{jj}(:,ii) == dPeakT_late{pp}{jj}(ii));
                    preDir_dPeak_early{pp}{jj}(:,ii) = preDir_peak_plot{pp}{jj}{dPeakIdx{pp}{jj}(ii)}(:,dPeakIdx_early{pp}{jj}(ii));
                    preDir_dPeak_late{pp}{jj}(:,ii) = preDir_peak_plot{pp}{jj}{dPeakIdx{pp}{jj}(ii)}(:,dPeakIdx_late{pp}{jj}(ii));
                    preDir_dPeak_early_azi{pp}{jj}(ii) = preDir_dPeak_early{pp}{jj}(1,ii);
                    preDir_dPeak_early_ele{pp}{jj}(ii) = preDir_dPeak_early{pp}{jj}(2,ii);
                    preDir_dPeak_late_azi{pp}{jj}(ii) = preDir_dPeak_late{pp}{jj}(1,ii);
                    preDir_dPeak_late_ele{pp}{jj}(ii) = preDir_dPeak_late{pp}{jj}(2,ii);
                end
                
                preDir_sPeak{pp}{jj} = cell2mat(preDir_peak_plot{pp}{jj}(sPeakIdx{pp}{jj}));
                
                preDir_sPeak_azi{pp}{jj} = preDir_sPeak{pp}{jj}(1,:);
                preDir_sPeak_ele{pp}{jj} = preDir_sPeak{pp}{jj}(2,:);
                
                % uniform test
                [h_s_h(pp,jj),p_s_h(pp,jj)] = UniformTest_LBY(preDir_sPeak_azi{pp}{jj}); % horizontal
                [h_s_v(pp,jj),p_s_v(pp,jj)] = UniformTest_LBY(preDir_sPeak_ele{pp}{jj}); % vertical
                [h_d_h(pp,jj),p_d_h(pp,jj)] = UniformTest_LBY(preDir_dPeak_early_azi{pp}{jj}); % horizontal
                [h_d_v(pp,jj),p_d_v(pp,jj)] = UniformTest_LBY(preDir_dPeak_early_ele{pp}{jj}); % vertical
                
            end
            if ~isempty(sPeakIdx{pp}{1}) && ~isempty(sPeakIdx{pp}{2})
                bothSPeakIdx{pp}{jj} = intersect(sPeakIdx{pp}{1},sPeakIdx{pp}{2}); % both vestibular & visual
                temp1 = cell2mat(preDir_peak_plot{pp}{1}(bothSPeakIdx{pp}{jj}));
                temp2 = cell2mat(preDir_peak_plot{pp}{2}(bothSPeakIdx{pp}{jj}));
                %             reshape(cell2mat(peakT_plot{pp}{1}(bothSPeakIdx{pp}{jj})),2,[]);
                %             temp2 = reshape(cell2mat(peakT_plot{pp}{2}(bothSPeakIdx{pp}{jj})),2,[]);
                preDir_sPeak_diff{pp} = angleDiff(temp1(1,:),temp1(2,:),temp1(3,:),temp2(1,:),temp2(2,:),temp2(3,:));
            end
            if ~isempty(dPeakIdx{pp}{1}) && ~isempty(dPeakIdx{pp}{2})
                bothDPeakIdx{pp}{jj} = intersect(dPeakIdx{pp}{1},dPeakIdx{pp}{2}); % both vestibular & visual
                
            end
            
        end
        
        hl = [];hbar = [];
        % plot figures for preferred direction distribution (T & R) (Single-peaked cells)
        figure(11);set(figure(11),'name','Distribution of preferred direction at peak time (Single-peaked cells) ','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.2,0.2,[0.1 0.1]);
        for pp = 1:2
            if ~isempty(preDir_sPeak{pp})
                hl{pp} = LinearCorrelation(preDir_sPeak_azi{pp},preDir_sPeak_ele{pp},...
                    'Xlabel','Preferred azimuth (degree)','Ylabel','Preferred elevation (degree)','FaceColors',{'b','r'},'EdgeColors',{'b','r'},'Markers',{'o'},...
                    'LineStyles',{'b--','r--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'XHistLim',[0 360],'YHistLim',[-90 90],'Xlim',[0 360],'Xlim',[0 360],'Ylim',[-90 90],...
                    'LinearCorr',0,'figN',11,'Axes',h_subplot(pp),'LegendOn',0,'YDirR',1,...
                    'XTick',{[0 90 180 270 360];{'0','90','180','270','360'}},'YTick',{[-90 -45 0 45 90];{'-90','-45','0','45','90'}});
            end
        end
        % text necessary infos
        axes('pos',[0.1 0.9 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of preferred direction   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        SetFigure(12);
        
        
        hl = [];hbar = [];
        % plot figures for preferred direction distribution (T & R) (Double-peaked cells)
        figure(12);set(figure(12),'name','Distribution of preferred direction at peak time (Double-peaked cells) ','unit','pixels','pos',[-1070 -800 1050 1500]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.2,0.2,[0.1 0.1]);
        
        % early peak
        for pp = 1:2
            if ~isempty(preDir_dPeak_early{pp})
                hl{pp} = LinearCorrelation(preDir_dPeak_early_azi{pp},preDir_dPeak_early_ele{pp},...
                    'Xlabel','Preferred azimuth (degree)','Ylabel','Preferred elevation (degree)','FaceColors',{'b','r'},'EdgeColors',{'b','r'},'Markers',{'o'},...
                    'LineStyles',{'b--','r--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'XHistLim',[0 360],'YHistLim',[-90 90],'Xlim',[0 360],'Ylim',[-90 90],...
                    'LinearCorr',0,'figN',11,'Axes',h_subplot(pp),'LegendOn',0,'YDirR',1,...
                    'XTick',{[0 90 180 270 360];{'0','90','180','270','360'}},'YTick',{[-90 -45 0 45 90];{'-90','-45','0','45','90'}});
            end
        end
        
        
        % late peak
        for pp = 1:2
            if ~isempty(preDir_dPeak_late{pp})
                hl{pp} = LinearCorrelation(preDir_dPeak_late_azi{pp},preDir_dPeak_late_ele{pp},...
                    'Xlabel','Preferred azimuth (degree)','Ylabel','Preferred elevation (degree)','FaceColors',{'b','r'},'EdgeColors',{'b','r'},'Markers',{'o'},...
                    'LineStyles',{'b--','r--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'XHistLim',[0 360],'YHistLim',[-90 90],'Xlim',[0 360],'Xlim',[0 360],'Ylim',[-90 90],...
                    'LinearCorr',0,'figN',11,'Axes',h_subplot(pp+2),'LegendOn',0,'YDirR',1,...
                    'XTick',{[0 90 180 270 360];{'0','90','180','270','360'}},'YTick',{[-90 -45 0 45 90];{'-90','-45','0','45','90'}});
            end
        end
        
        % text necessary infos
        axes('pos',[0.1 0.9 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of preferred direction   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.03 0.1 0.1 0.9]);
        text(0.1,0.65,'Early-peak','rotation',90); text(0.05,0.2,'Late-peak','rotation',90);
        axis off;
        axes('pos',[0.05 0.05 0.9 0.1]);
        text(0.15,0,'Translation');text(0.75,0,'Rotation'); axis off;
        SetFigure(12);
        
        % plot figures for delta preferred direction distribution (between vestibular & visual)
        hbar = [];
        xdiff = linspace(0,180,12);
        figure(13);set(figure(13),'name','Distribution of delta preferred direction at peak time (vestibular vs. visual)','unit','pixels','pos',[-1070 -400 1050 900]); clf;
        [~,h_subplot] = tight_subplot(3,2,0.1,0.2,0.1);
        
        for pp = 1:2
            axes(h_subplot(pp));hold on;
            
            [n_diff{pp}, ~] = hist(preDir_sPeak_diff{pp},xdiff);
            medianAzi{pp} = median(preDir_sPeak_diff{pp});
            
            hbar{pp} = bar(xdiff,n_diff{pp});set(hbar{pp},'facecolor','k','edgecolor','k');
            set(gca,'xtick',[0 90 180]);xlabel('\Delta preferred direction');ylabel('cell #');set(gca,'xlim',[0 180]);
            plot([medianAzi{pp} medianAzi{pp}],[0 max(n_diff{pp}(:))*1.1],'k--','linewidth',1.5);
            text(medianAzi{pp},max(n_diff{pp}(:))*1.2,num2str(medianAzi{pp}));
            axis on;hold off;
        end
        suptitle(['Distribution of \Delta preferred direction   (Monkey = ',monkey_to_print,')']);
        % text necessary infos
        axes('pos',[0.1 0.55 0.8 0.05]);
        text(0.1,0,['Translation, n = ',num2str(length(preDir_sPeak_diff{1}))]);
        text(0.7,0,['Rotation, n = ',num2str(length(preDir_sPeak_diff{2}))]);
        axis off;
        axes('pos',[0.03 0.1 0.1 0.9]);
        text(0,0.6,'Single-peaked','rotation',90);text(0,0.25,'Double-peaked','rotation',90);
        text(0.5,0.1,'Late peak','rotation',90);text(0.5,0.35,'Early peak','rotation',90);
        axis off;
        SetFigure(12);
        
    end

    function f1p3(debug)      % Comparisons between T & R
        if debug  ; dbstack;   keyboard;      end
        % 有多少neurons同时对二者有反应？ temporal？ spatial？
        
    end

    function f1p3p1(debug)      % DDI distribution between T & R
        if debug  ; dbstack;   keyboard;      end
        % pack data
        DDI_spatial = [];DDI_plot = [];
        for pp = 1:2
            for jj = 1:2
                DDI_spatial{jj}.tempoSig(:,pp) = DDI{pp}(select_temporalSig{1}(:,jj)&select_temporalSig{2}(:,jj),jj);
                DDI_spatial{jj}.spatialSig(:,pp) = DDI{pp}(select_spatialSig{1}(:,jj)&select_spatialSig{2}(:,jj),jj);
            end
            DDI_plot{pp} = {DDI_spatial{1}.tempoSig(:,pp);DDI_spatial{2}.tempoSig(:,pp);DDI_spatial{1}.spatialSig(:,pp);DDI_spatial{2}.spatialSig(:,pp)};
        end
        
        % plot figures for DDI distribution (vestibular DDI vs. visual DDI)
        figure(11);set(figure(11),'name','Distribution of DDI (T vs. R)','unit','pixels','pos',[-1070 000 1050 900]); clf;
        h = axes('pos',[0.2,0.1,0.6,0.6],'visible','off');
        hl = LinearCorrelation(DDI_plot{1},DDI_plot{2},...
            'Xlabel','DDI (Translation)','Ylabel','DDI (Rotation)','FaceColors',{'w','w','b','r'},'EdgeColors',{'b','r','b','r'},'Markers',{'o'},...
            'LineStyles',{'w--','w--','b--','r--'},'MarkerSize',6,'XHist',nHist,'YHist',nHist,'Xlim',[0 1],'Ylim',[0 1],...
            'LinearCorr',0,'figN',11,'Axes',h,'LegendOn',0);
        % text necessary infos
        axes('pos',[0.1 0.9 0.9 0.1]);
        %             text(0.25,0.5,['Distribution of DDI   (Monkey = ',monkey_to_print,')']);
        axis off;
        axes('pos',[0.7 0.7 0.2 0.2]);
        text(0,1,['n(vestiSig) = ',num2str(sum(select_spatialSig{1}(:,1)&select_spatialSig{2}(:,1)))],'color','b');
        text(0,0.8,['n(visSig) = ',num2str(sum(select_spatialSig{1}(:,2)&select_spatialSig{2}(:,2)))],'color','r');
        axis off;
        SetFigure(12);
        
    end

    function f1p3p2(debug)      % Preferred direction distribution between T & R
        if debug  ; dbstack;   keyboard;      end
        % pack data
        preDir_spatial = [];
        for jj = 1:2
            for pp = 1:2
                preDir_spatial{pp}{jj}.tempoSig = reshape(preDir{pp}{jj}(repmat(select_temporalSig{1}(:,jj)&select_temporalSig{2}(:,jj),1,3)),[],3);
                preDir_spatial{pp}{jj}.spatialSig = reshape(preDir{pp}{jj}(repmat(select_spatialSig{1}(:,jj)&select_spatialSig{2}(:,jj),1,3)),[],3);
            end
            preDir_diff{jj}.tempoSig = angleDiff(preDir_spatial{1}{jj}.tempoSig(:,1),preDir_spatial{1}{jj}.tempoSig(:,2),preDir_spatial{1}{jj}.tempoSig(:,3),preDir_spatial{2}{jj}.tempoSig(:,1),preDir_spatial{2}{jj}.tempoSig(:,2),preDir_spatial{2}{jj}.tempoSig(:,3));
            preDir_diff{jj}.spatialSig = angleDiff(preDir_spatial{1}{jj}.spatialSig(:,1),preDir_spatial{1}{jj}.spatialSig(:,2),preDir_spatial{1}{jj}.spatialSig(:,3),preDir_spatial{2}{jj}.spatialSig(:,1),preDir_spatial{2}{jj}.spatialSig(:,2),preDir_spatial{2}{jj}.spatialSig(:,3));
        end
        
        % plot figures for delta preferred direction distribution (between vestibular & visual)
        
        xdiff = linspace(0,180,12);
        figure(12);set(figure(12),'name','Distribution of delta preferred direction (translation vs. rotation)','unit','normalized','pos',[-0.55 0.2 0.53 0.3]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.1,0.3,0.1);
        hbar = [];
        for jj = 1:2
            axes(h_subplot(jj));hold on;
            
            [n_diff_tempo{jj}, ~] = hist(preDir_diff{jj}.tempoSig,xdiff);
            [n_diff{jj}, ~] = hist(preDir_diff{jj}.spatialSig,xdiff);
            
            medianDiff{jj} = median(preDir_diff{jj}.spatialSig);
            
            hbar{1}{jj} = bar(xdiff,n_diff_tempo{jj});set(hbar{1}{jj},'facecolor','w','edgecolor','k');
            hbar{2}{jj} = bar(xdiff,n_diff{jj});set(hbar{2}{jj},'facecolor','k','edgecolor','k');
            set(gca,'xtick',[0 90 180]);xlabel('\Delta preferred direction');ylabel('cell #');set(gca,'xlim',[0-20 180+20]);
            plot([medianDiff{jj} medianDiff{jj}],[0 max(n_diff{jj})*1.1],'k--','linewidth',1.5);
            text(medianDiff{jj},max(n_diff{jj})*1.2,num2str(medianDiff{jj}));
            axis on;hold off;
        end
        suptitle(['Distribution of \Delta preferred direction (T vs. R)  (Monkey = ',monkey_to_print,')']);
        % text necessary infos
        axes('pos',[0.1 0.05 0.8 0.05]);
        text(0.1,0,['Vestibular, n = ',num2str(sum(select_spatialSig{1}(:,1)&select_spatialSig{2}(:,1)))]);
        text(0.7,0,['Visual, n = ',num2str(sum(select_spatialSig{1}(:,2)&select_spatialSig{2}(:,2)))]);
        axis off;
        SetFigure(12);
    end

    function f1p4p3(debug)      % DDI distribution between Fixation % Dark control
        if debug  ; dbstack;   keyboard;      end
        % pack data
        DDI_spatial{1}.tempoSig = DDI{1}(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1);
        DDI_spatial{3}.tempoSig = DDI{3}(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1);
        DDI_spatial{2}.tempoSig = DDI{2}(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1);
        DDI_spatial{4}.tempoSig = DDI{4}(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1);
        DDI_spatial{1}.spatialSig = DDI{1}(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1);
        DDI_spatial{3}.spatialSig = DDI{3}(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1);
        DDI_spatial{2}.spatialSig = DDI{2}(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1);
        DDI_spatial{4}.spatialSig = DDI{4}(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1);
        
        figure(11);set(figure(11),'name','Distribution of DDI (Fixation vs. dark)','unit','normalized','pos',[-0.55 0.1 0.5 0.6]); clf;
        h = [];
        % scatter
        h = axes('pos',[0.1 0.2 0.8 0.6]);hold on;axis square;
        plot(h,[0 1],[0 1],'-','color',[0.7 0.7 0.7],'linewidth',1.5); % diagonal line
        plot(h,DDI_spatial{1}.tempoSig,DDI_spatial{3}.tempoSig,'ko','markersize',8,'markerfacecolor','w');
        plot(h,DDI_spatial{2}.tempoSig,DDI_spatial{4}.tempoSig,'k^','markersize',8,'markerfacecolor','w');
        plot(h,DDI_spatial{1}.spatialSig,DDI_spatial{3}.spatialSig,'ko','markersize',8,'markerfacecolor','k');
        plot(h,DDI_spatial{2}.spatialSig,DDI_spatial{4}.spatialSig,'k^','markersize',8,'markerfacecolor','k');
        
        text(0.05,0.9,['n(Translation) = ',num2str(sum(select_spatialSig{3}(:,1)))]);
        text(0.05,0.8,['n(Rotation) = ',num2str(sum(select_spatialSig{4}(:,1)))]);
        
        xlabel('DDI (Vestibular)');ylabel('DDI (dark)');set(h,'xlim',[0 1],'ylim',[0,1]);
        hold off;
        
        suptitle(['Distribution of DDI (Fixation vs. dark)   (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
    end

    function f1p4p1(debug)      % Preferred direction distribution between Normal % Dark control
        if debug  ; dbstack;   keyboard;      end
        preDir_spatial = [];
        preDir_spatial{1}.tempoSig = reshape(preDir{1}{1}(repmat(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1,3)),[],3);
        preDir_spatial{3}.tempoSig = reshape(preDir{3}{1}(repmat(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1,3)),[],3);
        preDir_spatial{2}.tempoSig = reshape(preDir{2}{1}(repmat(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1,3)),[],3);
        preDir_spatial{4}.tempoSig = reshape(preDir{4}{1}(repmat(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1,3)),[],3);
        preDir_spatial{1}.spatialSig = reshape(preDir{1}{1}(repmat(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1,3)),[],3);
        preDir_spatial{3}.spatialSig = reshape(preDir{3}{1}(repmat(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1,3)),[],3);
        preDir_spatial{2}.spatialSig = reshape(preDir{2}{1}(repmat(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1,3)),[],3);
        preDir_spatial{4}.spatialSig = reshape(preDir{4}{1}(repmat(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1,3)),[],3);
        
        preDir_diff{1}.tempoSig = angleDiff(preDir_spatial{1}.tempoSig(:,1),preDir_spatial{1}.tempoSig(:,2),preDir_spatial{1}.tempoSig(:,3),preDir_spatial{3}.tempoSig(:,1),preDir_spatial{3}.tempoSig(:,2),preDir_spatial{3}.tempoSig(:,3));
        preDir_diff{1}.spatialSig = angleDiff(preDir_spatial{1}.spatialSig(:,1),preDir_spatial{1}.spatialSig(:,2),preDir_spatial{1}.spatialSig(:,3),preDir_spatial{3}.spatialSig(:,1),preDir_spatial{3}.spatialSig(:,2),preDir_spatial{3}.spatialSig(:,3));
        preDir_diff{2}.tempoSig = angleDiff(preDir_spatial{2}.tempoSig(:,1),preDir_spatial{2}.tempoSig(:,2),preDir_spatial{2}.tempoSig(:,3),preDir_spatial{4}.tempoSig(:,1),preDir_spatial{4}.tempoSig(:,2),preDir_spatial{4}.tempoSig(:,3));
        preDir_diff{2}.spatialSig = angleDiff(preDir_spatial{2}.spatialSig(:,1),preDir_spatial{2}.spatialSig(:,2),preDir_spatial{2}.spatialSig(:,3),preDir_spatial{4}.spatialSig(:,1),preDir_spatial{4}.spatialSig(:,2),preDir_spatial{4}.spatialSig(:,3));
        
        figure(11);set(figure(11),'name','Distribution of \Delta preferred direction (Fixation vs. dark)','unit','normalized','pos',[-0.55 0.1 0.5 0.4]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.1,0.3,0.1);
        xdiff = linspace(0,180,11);
        
        for pp = 1:2
            axes(h_subplot(pp));hold on;
            [n_diff_tempo{pp}, ~] = hist(preDir_diff{pp}.tempoSig,xdiff);
            [n_diff{pp}, ~] = hist(preDir_diff{pp}.spatialSig,xdiff);
            
            medianDiff{pp} = median(preDir_diff{pp}.spatialSig);
            
            hbar{1}{pp} = bar(xdiff,n_diff_tempo{pp});set(hbar{1}{pp},'facecolor','w','edgecolor','k');
            hbar{2}{pp} = bar(xdiff,n_diff{pp});set(hbar{2}{pp},'facecolor','k','edgecolor','k');
            set(gca,'xtick',[0 90 180]);xlabel('\Delta preferred direction');ylabel('cell #');set(gca,'xlim',[0-20 180+20]);
            plot([medianDiff{pp} medianDiff{pp}],[0 max(n_diff{pp})*1.1],'k--','linewidth',1.5);
            text(medianDiff{pp},max(n_diff{pp})*1.2,num2str(medianDiff{pp}));
            axis on;hold off;
        end
        % text necessary infos
        axes('pos',[0.1 0.05 0.8 0.05]);
        text(0.1,1,['n(Translation) = ',num2str(sum(select_spatialSig{3}(:,1)))]);
        text(0.7,1,['n(Rotation) = ',num2str(sum(select_spatialSig{4}(:,1)))]);
        axis off;
        suptitle(['Distribution of preferred direction (Fixation vs. dark)   (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
    end

    function f1p4p2(debug)      % Rmax-Rmin between Normal % Dark control
        if debug  ; dbstack;   keyboard;      end
        Rextre_spatial{1}.tempoSig = Rextre{1}(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1);
        Rextre_spatial{3}.tempoSig = Rextre{3}(select_temporalSig{1}(:,1)&select_temporalSig{3}(:,1),1);
        Rextre_spatial{2}.tempoSig = Rextre{2}(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1);
        Rextre_spatial{4}.tempoSig = Rextre{4}(select_temporalSig{2}(:,1)&select_temporalSig{4}(:,1),1);
        Rextre_spatial{1}.spatialSig = Rextre{1}(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1);
        Rextre_spatial{3}.spatialSig = Rextre{3}(select_spatialSig{1}(:,1)&select_spatialSig{3}(:,1),1);
        Rextre_spatial{2}.spatialSig = Rextre{2}(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1);
        Rextre_spatial{4}.spatialSig = Rextre{4}(select_spatialSig{2}(:,1)&select_spatialSig{4}(:,1),1);
        
        figure(11);set(figure(11),'name','Distribution of Rmax-Rmin (Fixation vs. dark)','unit','normalized','pos',[-0.55 0.1 0.5 0.6]); clf;
        % scatter
        temp = struct2cell(cell2mat(Rextre_spatial));
        range = max(cell2mat(temp(:)));
        h = [];
        h{1}(pp) = axes('pos',[0.1 0.2 0.8 0.6]);hold on;axis square;
        plot(h{1}(pp),Rextre_spatial{1}.spatialSig,Rextre_spatial{3}.spatialSig,'ko','markersize',8,'markerfacecolor','k');
        plot(h{1}(pp),Rextre_spatial{2}.spatialSig,Rextre_spatial{4}.spatialSig,'k^','markersize',8,'markerfacecolor','k');
        plot(h{1}(pp),[0 range],[0 range],'-','color',[0.7 0.7 0.7],'linewidth',1.5); % diagonal line
        plot(h{1}(pp),Rextre_spatial{1}.tempoSig,Rextre_spatial{3}.tempoSig,'ko','markersize',8,'markerfacecolor','w');
        plot(h{1}(pp),Rextre_spatial{2}.tempoSig,Rextre_spatial{4}.tempoSig,'k^','markersize',8,'markerfacecolor','w');
        plot(h{1}(pp),Rextre_spatial{1}.spatialSig,Rextre_spatial{3}.spatialSig,'ko','markersize',8,'markerfacecolor','k');
        plot(h{1}(pp),Rextre_spatial{2}.spatialSig,Rextre_spatial{4}.spatialSig,'k^','markersize',8,'markerfacecolor','k');
        
        text(0.2,range*0.75,['n(Translation) = ',num2str(sum(select_spatialSig{3}(:,1)))]);
        text(0.2,range*0.9,['n(Rotation) = ',num2str(sum(select_spatialSig{4}(:,1)))]);
        legend('Translation','Rotation','Location','southeast');
        xlabel('Rmax-Rmin (Vestibular)');ylabel('Rmax-Rmin (dark)');
        set(h{1}(pp),'xlim',[0 range],'ylim',[0,range]);
        hold off;
        
        suptitle(['Distribution of Rmax-Rmin (Fixation vs. dark)   (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
        
    end

    function f1p5(debug)      % spontaneous FR
        if debug  ; dbstack;   keyboard;      end
        
        figure(11);set(figure(11),'name','Distribution of mean spontaneous firing rate (Hz)','unit','normalized','pos',[-0.55 0.2 0.53 0.6]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.2,[0.15 0.05]);
        
        for pp = 1:size(mat_address,1)
            axes(h_subplot(pp));hold on;
            hist(meanSpon{pp});
            xlabel('Firing rate (Hz)');ylabel('cell #');
            axis on;hold off;
            
        end
        
        axes('pos',[0.1 0.05 0.8 0.1]);text(0.15,0,'Translation');text(0.7,0,'Rotation');axis off;
        axes('pos',[0.05 0.1 0.1 0.7]);text(0,0.8,'Fixation','rotation',90);text(0,0.3,'Dark','rotation',90);axis off;
        suptitle(['Distribution of mean spontaneous firing rate (Hz)   (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
    end

    function f1p6p1(debug)      % PCA,'Eigen-Time'
        if debug  ; dbstack;   keyboard;      end
        
        denoised_dim = 4; % how many PCs you want to plot
        
        %                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),26,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},1),size(dataPCA_raw{pp}{jj},1),1))./repmat(std(dataPCA_raw{pp}{jj},1,1),size(dataPCA_raw{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj}' * weights_PCA_PC{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                %                                 %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},1),size(dataPCA_raw1{pp}{jj},1),1))./repmat(std(dataPCA_raw1{pp}{jj},1,1),size(dataPCA_raw1{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj}' * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},1),size(dataPCA_raw2{pp}{jj},1),1))./repmat(std(dataPCA_raw2{pp}{jj},1,1),size(dataPCA_raw2{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj}' * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(26,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},1),size(dataPCA_raw3{pp}{jj},1),1))./repmat(std(dataPCA_raw3{pp}{jj},1,1),size(dataPCA_raw3{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj}' * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %{
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}, projPC{pp}{jj}{3}], 3,'start','uniform','emptyaction','drop');
                figure;
                col = {'b', 'r', 'g', 'k', 'm'};
                
                % Add colors according to the sorting result.
                for i=1: length(unique(Index{pp}{jj}))
                    plot(1:75,dataPCA_raw{pp}{jj}(:,Index{pp}{jj}==i),col{i}); hold on;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %}
                
            end
        end
        
        
        
        % ============   Weight distribution of PCs ===========
        %         %{
        %         colorsPCA{1} = {[8 32 51]/255,[23 70 107]/255,[15 139 184]/255,[138 188 209]/255,[204 207 226]/255,[239 239 247]/255};
        %         colorsPCA{2} = {[90 19 27]/255,[192 44 38]/255,[221 82 96]/255,[240 161 168]/255,[230 210 213]/255,[249 244 245]/255};
        colorsPCA{1} = {'b', 'r', 'g', 'k', 'm','c'};
        colorsPCA{2} = {'b', 'r', 'g', 'k', 'm','c'};
        labels = {{'T, vesti','T, vis'},{'R, vesti','R, vis'}};
        ds = 1:denoised_dim;
        
        %%%%%%%%%%%%%%%0
        figure(10);set(figure(10),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA{pp}{jj},1);
                for ii = 1:denoised_dim
                    %
                    %                     plot(PCA_times,weights_PCA_PC{pp}{jj}(:,ii),'k-','color',colorsPCA{jj}{ii},'linewidth',4);hold on;
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                    
                    
                end
                xlim([0 length(PCA_times)])
                ylim([min(weights_PCA_PC{pp}{jj}(:)) max(weights_PCA_PC{pp}{jj}(:))]);
                xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
                %                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
        end
        
        suptitle('Eigen-time, All directions');
        SetFigure(12);
        
        %%%%%%%%%%%%%%%1
        %{
figure(20);set(figure(20),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA1{pp}{jj},1);
               
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC1{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC1{pp}{jj}(:)) max(weights_PCA_PC1{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(with all directions)');
                SetFigure(12);
        %}
        %%%%%%%%%%%%%%%2
        %{
        figure(20);set(figure(20),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
                for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA2{pp}{jj},1);
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC2{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC2{pp}{jj}(:)) max(weights_PCA_PC2{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(Preferred direction)');
                SetFigure(12);
        %}
        %%%%%%%%%%%%%%%3
        %{
figure(30);set(figure(30),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA3{pp}{jj},1);
                
                for ii = 1:denoised_dim
                   axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC3{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC3{pp}{jj}(:)) max(weights_PCA_PC3{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(max & min direction)');
                SetFigure(12);
        %}
        %}
        
        % ============   clusters of neurons of different directions ===========
        %{
        %%%%%%%%%%%%%%%0 将每一个方向全部打乱
%         %{
        figure(17);set(figure(17),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC{pp}{jj}{1},projPC{pp}{jj}{2},projPC{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(18);set(figure(18),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC{pp}{jj}{1}(Index{pp}{jj}==i),projPC{pp}{jj}{2}(Index{pp}{jj}==i),projPC{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
        %{
        figure(27);set(figure(27),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
        for pp = 1:2
            for jj = 1:2
               
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC1{pp}{jj}{1},projPC1{pp}{jj}{2},projPC1{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(28);set(figure(28),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
        for pp = 1:2
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC1{pp}{jj}{1}, projPC1{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC1{pp}{jj}{1}(Index{pp}{jj}==i),projPC1{pp}{jj}{2}(Index{pp}{jj}==i),projPC1{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
        %{
        %---------------- raw data
        figure(37);set(figure(37),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
%         for pp = 1:2
            for pp = 1
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC2{pp}{jj}{1},projPC2{pp}{jj}{2},projPC2{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        %---------------- kmeans cluster
        figure(38);set(figure(38),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC2{pp}{jj}{1}(Index{pp}{jj}==i),projPC2{pp}{jj}{2}(Index{pp}{jj}==i),projPC2{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
        %{
        figure(47);set(figure(47),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
        for pp = 1:2
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC3{pp}{jj}{1},projPC3{pp}{jj}{2},projPC3{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(48);set(figure(48),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
        for pp = 1:2
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC3{pp}{jj}{1}, projPC3{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC3{pp}{jj}{1}(Index{pp}{jj}==i),projPC3{pp}{jj}{2}(Index{pp}{jj}==i),projPC3{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        %}
        
        % ============   Variance explained =================
        %                 %{
        %%%%%%%%%%%%%%%%%0
        figure(15);set(figure(15),'name','Variance explained, All directions','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained{pp}{jj}))', cumsum(PCA_explained{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        axes('unit','pixels','pos',[20 20 900 20]);hold on;
        text(0.25,0,'Translation');text(0.8,0,'Rotation');
        axis off;
        SetFigure(12);
        
        %%%%%%%%%%%%%%%%%1
        %{
        figure(25);set(figure(25),'name','Variance explained, All neurons (with all directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained1{pp}{jj}))', cumsum(PCA_explained1{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained1{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained1{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained1{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained1{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained1{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%2
        %{
        figure(35);set(figure(35),'name','Variance explained, All neurons (Preferred directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
                for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained2{pp}{jj}))', cumsum(PCA_explained2{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained2{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained2{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained2{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained2{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained2{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%3
        %{
        figure(45);set(figure(45),'name','Variance explained, All neurons (Preferred + Null directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained3{pp}{jj}))', cumsum(PCA_explained3{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained3{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained3{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained3{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained3{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained3{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        
        % ============  3. 2-D Trajectory  ===========
        %{
        figure(16);set(figure(16),'name','Population Dynamics','unit','pixels','pos',[-1000 -300 900 400]); clf;hold on;
        %         [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                plot(weights_PCA_PC{pp}{jj}(1,1),weights_PCA_PC{pp}{jj}(1,2),'k.','color',colors{jj},'markersize',20);
                plot(weights_PCA_PC{pp}{jj}(:,1),weights_PCA_PC{pp}{jj}(:,2),'k-','color',colors{jj},'linewidth',2,'linestyle',lines{pp});
                axis square;
            end
        end
        xlabel('PC1'); ylabel('PC2'); axis on;
        SetFigure(12);
        %}
        
        %}
        
    end

    function f1p6p2(debug)      % PCA,'Eigen-Neuron'
        if debug  ; dbstack;   keyboard;      end
        
        denoised_dim = 4; % how many PCs you want to plot
        
        for pp = 1:2
            %                     for pp = 1
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),26,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},2),1,size(dataPCA_raw{pp}{jj},2)))./repmat(std(dataPCA_raw{pp}{jj},1,2),1,size(dataPCA_raw{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj} * weights_PCA_PC{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},2),1,size(dataPCA_raw1{pp}{jj},2)))./repmat(std(dataPCA_raw1{pp}{jj},1,2),1,size(dataPCA_raw1{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj} * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},2),1,size(dataPCA_raw2{pp}{jj},2)))./repmat(std(dataPCA_raw2{pp}{jj},1,2),1,size(dataPCA_raw2{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj} * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                %{
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(26,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},2),1,size(dataPCA_raw3{pp}{jj},2)))./repmat(std(dataPCA_raw3{pp}{jj},1,2),1,size(dataPCA_raw3{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj} * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                %}
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %{
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}, projPC{pp}{jj}{3}], 3,'start','uniform','emptyaction','drop');
                figure;
                col = {'b', 'r', 'g', 'k', 'm'};
                
                % Add colors according to the sorting result.
                for i=1: length(unique(Index{pp}{jj}))
                    plot(1:75,dataPCA_raw{pp}{jj}(:,Index{pp}{jj}==i),col{i}); hold on;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %}
                
            end
        end
        
        
        %%%%%%%%%%%%%%%%%figures
        colors = {'b', 'r', 'g', 'k', 'm'};
        labels = {{'T, vesti','T, vis'},{'R, vesti','R, vis'}};
        % ============   1-D Trajectory of Eigen-neurons ===========
        %         %{
        %%%%%%%%%%%%%%%0 将每一个方向全部打乱
        %         %{
        figure(16);set(figure(16),'name','Eigen-neurons','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        PCA_times = 1:size(dataPCA{pp}{jj},1);
        for pp = 1:2
            %             for pp = 1
            for jj = 1:2
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:length(projPC{pp}{jj}{ii}),projPC{pp}{jj}{ii},'k-','linewidth',3,'color',colors{ii});
                end
                axis on;legend('PC1','PC2','PC3','PC4');
                xlim([0 length(PCA_times)])
                %                     ylim([min(projPC{pp}{jj}{ii}(:)) max(projPC{pp}{jj}{ii}(:))]);
                %                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'});title(['Eigen-time PC' num2str(ii)]); axis on;
                xlabel('time (s)'); ylabel('Firing rate (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','1500'});
                title(labels{pp}{jj});
            end
        end
        suptitle('Eigen-neurons, firing rate');
        SetFigure(12);
        %}
        
        % ============   2-D Trajectory  ===========
        %         %{
        figure(18);set(figure(18),'name','2-D Trajectory (PC1 vs PC2)','unit','pixels','pos',[-1000 -300 900 400]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            axes(h_subplot(pp));hold on;
            for jj = 1:2
                plot(projPC{pp}{jj}{1}(1),projPC{pp}{jj}{2}(1),'k.','color',colors{jj},'markersize',20);
                plot(projPC{pp}{jj}{1},projPC{pp}{jj}{2},'k-','color',colors{jj},'linewidth',2,'linestyle',lines{pp});
                
            end
            xlabel('PC1'); ylabel('PC2'); axis on;axis square;
        end
        
        SetFigure(12);
        suptitle('2-D Trajectory (PC1 vs PC2)');
        %}
        
        % ============   3-D Trajectory  ===========
        %         %{
        figure(17);set(figure(17),'name','3-D Trajectory (PC1, PC2, PC3)','unit','pixels','pos',[-1000 -300 900 400]); clf;
        [~,h_subplot] = tight_subplot(1,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            axes(h_subplot(pp));hold on;
            for jj = 1:2
                plot3(projPC{pp}{jj}{1}(1),projPC{pp}{jj}{2}(1), projPC{pp}{jj}{3}(1), 'k.','color',colors{jj},'markersize',20);
                plot3(projPC{pp}{jj}{1},projPC{pp}{jj}{2}, projPC{pp}{jj}{3},'k-','color',colors{jj},'linewidth',2,'linestyle',lines{pp});
                
            end
            xlabel('PC1'); ylabel('PC2');zlabel('PC3'); axis on;view(3);
        end
        
        SetFigure(12);
        suptitle('3-D Trajectory (PC1, PC2, PC3)');
        %}
        
        
        % ============   Variance explained =================
        %         %{
        %%%%%%%%%%%%%%%%%0
        figure(15);set(figure(15),'name','Variance explained, All directions','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained{pp}{jj}))', cumsum(PCA_explained{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        axes('unit','pixels','pos',[20 20 900 20]);hold on;
        text(0.25,0,'Translation');text(0.8,0,'Rotation');
        axis off;
        SetFigure(12);
        
        %%%%%%%%%%%%%%%%%1
        %{
        figure(25);set(figure(25),'name','Variance explained, All neurons (with all directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained1{pp}{jj}))', cumsum(PCA_explained1{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained1{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained1{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained1{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained1{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained1{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%2
        %{
        figure(35);set(figure(35),'name','Variance explained, All neurons (Preferred directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %         for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained2{pp}{jj}))', cumsum(PCA_explained2{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained2{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained2{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained2{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained2{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained2{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%3
        %{
        figure(45);set(figure(45),'name','Variance explained, All neurons (Preferred + Null directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained3{pp}{jj}))', cumsum(PCA_explained3{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained3{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained3{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained3{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained3{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained3{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %}
        
    end

    function f1p7p1(debug)      % Targeted dimensionality reduction, 'v&a'
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:2
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),26,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},2),1,size(dataPCA_raw{pp}{jj},2)))./repmat(std(dataPCA_raw{pp}{jj},1,2),1,size(dataPCA_raw{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj} * weights_PCA_PC{pp}{jj}(:,ii);
                end
                
            end
        end
    end


%%%%% 3D models

    function f2p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p1p1(debug)      % BIC distribution across models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
% for jj = 1
                
                [~, temp] =  min(BIC_3D{pp}{jj},[],2);
                BIC_min{pp,jj} = temp(select_temporalSig{pp}(:,jj));
                [n_BIC{pp}(jj,:), ~] = hist(BIC_min{pp,jj},1:length(models));
                %                 BIC_out{pp}{jj} = BIC_3D{pp}{jj}(select_temporalSig{pp}(:,jj),:);
            end
        end
        
        
        figure(11);set(figure(11),'name','Distribution of best fitting model (BIC)','unit','normalized','pos',[-0.55 0.4 0.53 0.35]); clf;
        h = axes('pos',[0.1 0.2 0.8 0.6]);
%         BestFitModel = [n_BIC{1}(1,:);n_BIC{1}(2,:);n_BIC{2}(1,:);n_BIC{2}(2,:)]';
BestFitModel = [n_BIC{1}(1,:);n_BIC{2}(1,:)]';
        hbar = bar(1:length(models),BestFitModel,'grouped');
        % set(h(1),'facecolor',colorDBlue,'edgecolor',colorDBlue);
        % set(h(2),'facecolor',colorDRed,'edgecolor',colorDRed);
        % set(h(3),'facecolor',colorLBlue,'edgecolor',colorLBlue);
        % set(h(4),'facecolor',colorLRed,'edgecolor',colorLRed);
        xlabel('Models');ylabel('Cell #');
        set(gca,'xticklabel',models);
        title('Distribution of best fitting model (BIC)');
%         legend(['Translation (Vestibular), n = ',num2str(sum(select_temporalSig{1}(:,1)))],['Translation (Visual), n = ',num2str(sum(select_temporalSig{1}(:,2)))],['Rotation (Vestibular), n = ',num2str(sum(select_temporalSig{2}(:,1)))],['Rotation (Visual), n = ',num2str(sum(select_temporalSig{2}(:,2)))],'location','NorthWest');
        legend(['Translation (Vestibular), n = ',num2str(sum(select_temporalSig{1}(:,1)))],['Rotation (Vestibular), n = ',num2str(sum(select_temporalSig{2}(:,1)))],'location','NorthWest');
SetFigure(12);
        
    end

    function f2p1p2(debug)      % R_squared distribution across models
        if debug  ; dbstack;   keyboard;      end
        xR2 = linspace(0,1,11);
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                temp = 1: length(group_result);
                R2_plot{pp}{jj} = R2_3D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                for m_inx = 1:length(models)
                    [n_R2{pp}{jj}(m_inx,:), ~] = hist(R2_plot{pp}{jj}(:,m_inx),xR2);
                end
            end
        end
        
        figure(11);set(figure(11),'name','Distribution of R2 across models','unit','normalized','pos',[-0.55 0 0.53 0.6]); clf;
        [~,h_subplot] = tight_subplot(4,length(models),[0.07 0.03],0.15,0.01);
        for pp = 1:2
            for jj = 1:2
                for m_inx = 1:length(models)
                    axes(h_subplot(((pp-1)*2+(jj-1))*length(models)+m_inx));hold on;
                    bar(xR2,n_R2{pp}{jj}(m_inx,:),'k');axis on;
                    medianTemp = median(R2_plot{pp}{jj}(:,m_inx));
                    plot([medianTemp medianTemp],[0 max(n_R2{pp}{jj}(m_inx,:))*1.1],'k--','linewidth',1.5);
                    text(medianTemp,max(n_R2{pp}{jj}(m_inx,:))*1.2,num2str(medianTemp),'fontsize',8);
                    set(gca,'xlim',[0 1]);
                    %                 set(gca,'xtick',[],'ytick',[]);
                end
            end
        end
        
        % text necessary infos
        axes('pos',[0.005 0.05 1 0.05]);
        for m_inx = 1:length(models)
            text(0.1*m_inx-0.075,0,models(m_inx));
        end
        %             text(0,0,['n visual (visSig) = ',num2str(sum(select_spatialSig{pp}(:,2)))],'color','r');
        axis off;
        suptitle('Distribution of R^2 across models');
        SetFigure(12);
    end

    function f2p1p3(debug)      % VAF comparison (R2) across models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                temp = 1: length(group_result);
                R2_plot{pp}{jj} = R2_3D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                %                 RSS_temp{pp}{jj} = RSS{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                
            end
        end
        
        figure(11);set(figure(11),'name','Comparison of VAF(R2) of different models','unit','normalized','pos',[-0.55 -0.7 0.53 1.6]); clf;
        [~,h_subplot] = tight_subplot(4,3,[0.1 0.02],0.1,0.01);
        
        if sum(strcmp(models,'PVAJ')) && sum(strcmp(models,'VAP'))
            idx1 = find(strcmp(models,'PVAJ'));
            idx2 = find(strcmp(models,'VAP'));
            axes(h_subplot(1));hold on;
            for pp = 1:2
                for jj = 1:2
                    %                     [~,seqF{pp}{jj}] = sequentialF(RSS_temp{pp}{jj}(:,idx1),nParaModel{model_cat}(idx1),RSS_temp{pp}{jj}(:,idx2),nParaModel{model_cat}(idx2),26*nBins);
                    %                     R2_plot_sig{pp}{jj} = R2_plot{pp}{jj}(seqF{pp}{jj}<0.05,:);
                    %                     plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor','w','markeredgecolor',colors{jj});
                    %                     plot(R2_plot_sig{pp}{jj}(:,idx2),R2_plot_sig{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VAP model');ylabel('VAF (r^2), PVAJ model');
        end
        
        if sum(strcmp(models,'PVAJ')) && sum(strcmp(models,'VAJ'))
            idx1 = find(strcmp(models,'PVAJ'));
            idx2 = find(strcmp(models,'VAJ'));
            axes(h_subplot(2));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VAJ model');ylabel('VAF (r^2), PVAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'AJ'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'AJ'));
            axes(h_subplot(4));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AJ model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'VJ'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'VJ'));
            axes(h_subplot(5));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VJ model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'VA'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'VA'));
            axes(h_subplot(6));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VA model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'AP'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'AP'));
            axes(h_subplot(7));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AP model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'VP'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'VP'));
            axes(h_subplot(8));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VP model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'VA'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'VA'));
            axes(h_subplot(9));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VA model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VA')) && sum(strcmp(models,'VO'))
            idx1 = find(strcmp(models,'VA'));
            idx2 = find(strcmp(models,'VO'));
            axes(h_subplot(10));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VO model');ylabel('VAF (r^2), VA model');
        end
        
        if sum(strcmp(models,'VA')) && sum(strcmp(models,'AO'))
            idx1 = find(strcmp(models,'VA'));
            idx2 = find(strcmp(models,'AO'));
            axes(h_subplot(11));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AO model');ylabel('VAF (r^2), VA model');
        end
        
        
        suptitle('Comparison of VAF(R^2) of different models');
        SetFigure(12);
    end

    function f2p2(debug)      % Parameter analysis
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p2p1(debug)      % Weight ratio (V/A) distribution
        if debug  ; dbstack;   keyboard;      end
        xVA = (-3:0.5:3)+0.25;
        r2_thre = 0.5;
        hbar = [];
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of log(wV/wA) (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                n_VA_VA{pp} = [];
                %                 for jj = 1:2
                for jj = 1
                    RatioVA_VA{pp}{jj} = log(wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj)./wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    RatioVA_VA{pp}{jj} = RatioVA_VA{pp}{jj}(r2_VA>r2_thre);
                    try
                        [p_VA(pp,jj),h_VA(pp,jj)] = ranksum(RatioVA_VA{pp}{jj},zeros(1,length(RatioVA_VA{pp}{jj})));
                    catch
                        keyboard;
                    end
                    [n_VA_VA{pp}(jj,:), ~] = hist(RatioVA_VA{pp}{jj},xVA);
                    medianVA_VA{pp}(jj) = median(RatioVA_VA{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{1} = bar(xVA,n_VA_VA{pp}(jj,:));
                    set(hbar{1},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VA{pp}(jj) medianVA_VA{pp}(jj)],[0 max(n_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VA{pp}(jj),max(n_VA_VA{pp}(jj,:))*1.2,num2str(medianVA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of log(wV/wA) (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                n_VA_VAJ{pp} = [];
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    RatioVA_VAJ{pp}{jj} = RatioVA_VAJ{pp}{jj}(r2_VAJ>r2_thre);
                    
                    [p_VAJ(pp,jj),h_VAJ(pp,jj)] = ranksum(RatioVA_VAJ{pp}{jj},zeros(1,length(RatioVA_VAJ{pp}{jj})));
                    
                    [n_VA_VAJ{pp}(jj,:), ~] = hist(RatioVA_VAJ{pp}{jj},xVA);
                    medianVA_VAJ{pp}(jj) = median(RatioVA_VAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_VAJ{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VAJ{pp}(jj) medianVA_VAJ{pp}(jj)],[0 max(n_VA_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VAJ{pp}(jj),max(n_VA_VAJ{pp}(jj,:))*1.2,num2str(medianVA_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of log(wV/wA) (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                n_VA_VAP{pp} = [];
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAP{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    RatioVA_VAP{pp}{jj} = RatioVA_VAP{pp}{jj}(r2_VAP>r2_thre);
                    
                    [p_VAP(pp,jj),h_VAP(pp,jj)] = ranksum(RatioVA_VAP{pp}{jj},zeros(1,length(RatioVA_VAP{pp}{jj})));
                    
                    [n_VA_VAP{pp}(jj,:), ~] = hist(RatioVA_VAP{pp}{jj},xVA);
                    medianVA_VAP{pp}(jj) = median(RatioVA_VAP{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_VAP{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VAP{pp}(jj) medianVA_VAP{pp}(jj)],[0 max(n_VA_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VAP{pp}(jj),max(n_VA_VAP{pp}(jj,:))*1.2,num2str(medianVA_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of log(wV/wA) (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                n_VA_PVAJ{pp} = [];
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_PVAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    RatioVA_PVAJ{pp}{jj} = RatioVA_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [p_PVAJ(pp,jj),h_PVAJ(pp,jj)] = ranksum(RatioVA_PVAJ{pp}{jj},zeros(1,length(RatioVA_PVAJ{pp}{jj})));
                    
                    [n_VA_PVAJ{pp}(jj,:), ~] = hist(RatioVA_PVAJ{pp}{jj},xVA);
                    medianVA_PVAJ{pp}(jj) = median(RatioVA_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_PVAJ{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_PVAJ{pp}(jj) medianVA_PVAJ{pp}(jj)],[0 max(n_VA_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_PVAJ{pp}(jj),max(n_VA_PVAJ{pp}(jj,:))*1.2,num2str(medianVA_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f2p2p2(debug)      % Preferred direction & angle difference distribution ( V vs. A)
        if debug  ; dbstack;   keyboard;      end
        
        xDiff = linspace(0,180,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of the preferred directions (V&A, VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    preDir_V_VA_azi{pp}{jj} = preDir_V_VA_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VA_ele{pp}{jj} = preDir_V_VA_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_VA_azi{pp}{jj} = preDir_A_VA_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VA_ele{pp}{jj} = preDir_A_VA_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    preDir_V_VA_azi{pp}{jj} = preDir_V_VA_azi{pp}{jj}(r2_VA>r2_thre);
                    preDir_V_VA_ele{pp}{jj} = preDir_V_VA_ele{pp}{jj}(r2_VA>r2_thre);
                    preDir_A_VA_azi{pp}{jj} = preDir_A_VA_azi{pp}{jj}(r2_VA>r2_thre);
                    preDir_A_VA_ele{pp}{jj} = preDir_A_VA_ele{pp}{jj}(r2_VA>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VA_azi{pp}{jj},preDir_A_VA_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, A');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VA_ele{pp}{jj},preDir_A_VA_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, A');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&A, VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(12);set(figure(12),'name','Distribution of the difference between preferred directions (V&A,VA model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VA_VA_plot{pp}{jj} = angleDiff_VA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    angleDiff_VA_VA_plot{pp}{jj} = angleDiff_VA_VA_plot{pp}{jj}(r2_VA>r2_thre);
                    
                    [n_Diff_VA_VA{pp}(jj,:), ~] = hist(angleDiff_VA_VA_plot{pp}{jj},xDiff);
                    medianDiff_VA_VA{pp}(jj) = median(angleDiff_VA_VA_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VA_VA{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. A)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VA_VA{pp}(jj) medianDiff_VA_VA{pp}(jj)],[0 max(n_Diff_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VA_VA{pp}(jj),max(n_Diff_VA_VA{pp}(jj,:))*1.2,num2str(medianDiff_VA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&A,VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(13);set(figure(13),'name','Distribution of the preferred directions (V&A, PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_PVAJ_azi{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_PVAJ_azi{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    preDir_V_PVAJ_azi{pp}{jj} = preDir_V_PVAJ_azi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_A_PVAJ_azi{pp}{jj} = preDir_A_PVAJ_azi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_azi{pp}{jj},preDir_A_PVAJ_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, A');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_ele{pp}{jj},preDir_A_PVAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, A');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&A, PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(14);set(figure(14),'name','Distribution of the difference between preferred directions (V&A,PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VA_PVAJ_plot{pp}{jj} = angleDiff_VA_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    angleDiff_VA_PVAJ_plot{pp}{jj} = angleDiff_VA_PVAJ_plot{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_Diff_VA_PVAJ{pp}(jj,:), ~] = hist(angleDiff_VA_PVAJ_plot{pp}{jj},xDiff);
                    medianDiff_VA_PVAJ{pp}(jj) = median(angleDiff_VA_PVAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VA_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. A)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VA_PVAJ{pp}(jj) medianDiff_VA_PVAJ{pp}(jj)],[0 max(n_Diff_VA_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VA_PVAJ{pp}(jj),max(n_Diff_VA_PVAJ{pp}(jj,:))*1.2,num2str(medianDiff_VA_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&A,PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(15);set(figure(15),'name','Distribution of the preferred directions (V&A, VAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_VAJ_azi{pp}{jj} = preDir_V_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VAJ_ele{pp}{jj} = preDir_V_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_VAJ_azi{pp}{jj} = preDir_A_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VAJ_ele{pp}{jj} = preDir_A_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    preDir_V_VAJ_azi{pp}{jj} = preDir_V_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_V_VAJ_ele{pp}{jj} = preDir_V_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_A_VAJ_azi{pp}{jj} = preDir_A_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_A_VAJ_ele{pp}{jj} = preDir_A_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAJ_azi{pp}{jj},preDir_A_VAJ_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, A');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAJ_ele{pp}{jj},preDir_A_VAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, A');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&A, VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(16);set(figure(16),'name','Distribution of the difference between preferred directions (V&A,VAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VA_VAJ_plot{pp}{jj} = angleDiff_VA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    angleDiff_VA_VAJ_plot{pp}{jj} = angleDiff_VA_VAJ_plot{pp}{jj}(r2_VAJ>r2_thre);
                    
                    [n_Diff_VA_VAJ{pp}(jj,:), ~] = hist(angleDiff_VA_VAJ_plot{pp}{jj},xDiff);
                    medianDiff_VA_VAJ{pp}(jj) = median(angleDiff_VA_VAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VA_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. A)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VA_VAJ{pp}(jj) medianDiff_VA_VAJ{pp}(jj)],[0 max(n_Diff_VA_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VA_VAJ{pp}(jj),max(n_Diff_VA_VAJ{pp}(jj,:))*1.2,num2str(medianDiff_VA_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&A,VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(17);set(figure(17),'name','Distribution of the preferred directions (V&A, VAP model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_VAP_azi{pp}{jj} = preDir_V_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VAP_ele{pp}{jj} = preDir_V_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_VAP_azi{pp}{jj} = preDir_A_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VAP_ele{pp}{jj} = preDir_A_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    preDir_V_VAP_azi{pp}{jj} = preDir_V_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_V_VAP_ele{pp}{jj} = preDir_V_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    preDir_A_VAP_azi{pp}{jj} = preDir_A_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_A_VAP_ele{pp}{jj} = preDir_A_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAP_azi{pp}{jj},preDir_A_VAP_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, A');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAP_ele{pp}{jj},preDir_A_VAP_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, A');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&A, VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(18);set(figure(18),'name','Distribution of the difference between preferred directions (V&A,VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VA_VAP_plot{pp}{jj} = angleDiff_VA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    angleDiff_VA_VAP_plot{pp}{jj} = angleDiff_VA_VAP_plot{pp}{jj}(r2_VAP>r2_thre);
                    
                    [n_Diff_VA_VAP{pp}(jj,:), ~] = hist(angleDiff_VA_VAP_plot{pp}{jj},xDiff);
                    medianDiff_VA_VAP{pp}(jj) = median(angleDiff_VA_VAP_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VA_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. A)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VA_VAP{pp}(jj) medianDiff_VA_VAP{pp}(jj)],[0 max(n_Diff_VA_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VA_VAP{pp}(jj),max(n_Diff_VA_VAP{pp}(jj,:))*1.2,num2str(medianDiff_VA_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&A,VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f2p2p7(debug)      % Preferred direction & angle difference distribution ( V/A vs. J)
        if debug  ; dbstack;   keyboard;      end
        
        xDiff = linspace(0,180,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'PVAJ'))
            figure(11);set(figure(11),'name','Distribution of the preferred directions (V&J, PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_PVAJ_Jzi{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_J_PVAJ_Jzi{pp}{jj} = preDir_J_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_J_PVAJ_ele{pp}{jj} = preDir_J_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    preDir_V_PVAJ_Jzi{pp}{jj} = preDir_V_PVAJ_Jzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_J_PVAJ_Jzi{pp}{jj} = preDir_J_PVAJ_Jzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_J_PVAJ_ele{pp}{jj} = preDir_J_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_Jzi{pp}{jj},preDir_J_PVAJ_Jzi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, J');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_ele{pp}{jj},preDir_J_PVAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, J');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&J, PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(12);set(figure(12),'name','Distribution of the difference between preferred directions (V&J,PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VJ_PVAJ_plot{pp}{jj} = angleDiff_VJ_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    angleDiff_VJ_PVAJ_plot{pp}{jj} = angleDiff_VJ_PVAJ_plot{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_Diff_VJ_PVAJ{pp}(jj,:), ~] = hist(angleDiff_VJ_PVAJ_plot{pp}{jj},xDiff);
                    medianDiff_VJ_PVAJ{pp}(jj) = median(angleDiff_VJ_PVAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VJ_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. J)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VJ_PVAJ{pp}(jj) medianDiff_VJ_PVAJ{pp}(jj)],[0 max(n_Diff_VJ_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VJ_PVAJ{pp}(jj),max(n_Diff_VJ_PVAJ{pp}(jj,:))*1.2,num2str(medianDiff_VJ_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&J,PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(13);set(figure(13),'name','Distribution of the preferred directions (A&J, PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_A_PVAJ_Jzi{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_J_PVAJ_Jzi{pp}{jj} = preDir_J_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_J_PVAJ_ele{pp}{jj} = preDir_J_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    preDir_A_PVAJ_Jzi{pp}{jj} = preDir_A_PVAJ_Jzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_J_PVAJ_Jzi{pp}{jj} = preDir_J_PVAJ_Jzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_J_PVAJ_ele{pp}{jj} = preDir_J_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_PVAJ_Jzi{pp}{jj},preDir_J_PVAJ_Jzi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, A');ylabel('Preferred Azi, J');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_PVAJ_ele{pp}{jj},preDir_J_PVAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, A');ylabel('Preferred Ele, J');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (A&J, PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(14);set(figure(14),'name','Distribution of the difference between preferred directions (A&J,PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_AJ_PVAJ_plot{pp}{jj} = angleDiff_AJ_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    angleDiff_AJ_PVAJ_plot{pp}{jj} = angleDiff_AJ_PVAJ_plot{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_Diff_AJ_PVAJ{pp}(jj,:), ~] = hist(angleDiff_AJ_PVAJ_plot{pp}{jj},xDiff);
                    medianDiff_AJ_PVAJ{pp}(jj) = median(angleDiff_AJ_PVAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_AJ_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( A vs. J)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_AJ_PVAJ{pp}(jj) medianDiff_AJ_PVAJ{pp}(jj)],[0 max(n_Diff_AJ_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_AJ_PVAJ{pp}(jj),max(n_Diff_AJ_PVAJ{pp}(jj,:))*1.2,num2str(medianDiff_AJ_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (A&J,PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(15);set(figure(15),'name','Distribution of the preferred directions (V&J, VAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_VAJ_azi{pp}{jj} = preDir_V_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VAJ_ele{pp}{jj} = preDir_V_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_J_VAJ_azi{pp}{jj} = preDir_J_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_J_VAJ_ele{pp}{jj} = preDir_J_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    preDir_V_VAJ_azi{pp}{jj} = preDir_V_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_V_VAJ_ele{pp}{jj} = preDir_V_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_J_VAJ_azi{pp}{jj} = preDir_J_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_J_VAJ_ele{pp}{jj} = preDir_J_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAJ_azi{pp}{jj},preDir_J_VAJ_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, J');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAJ_ele{pp}{jj},preDir_J_VAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, J');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&J, VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(16);set(figure(16),'name','Distribution of the difference between preferred directions (V&J,VAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VJ_VAJ_plot{pp}{jj} = angleDiff_VA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    angleDiff_VJ_VAJ_plot{pp}{jj} = angleDiff_VJ_VAJ_plot{pp}{jj}(r2_VAJ>r2_thre);
                    
                    [n_Diff_VJ_VAJ{pp}(jj,:), ~] = hist(angleDiff_VJ_VAJ_plot{pp}{jj},xDiff);
                    medianDiff_VJ_VAJ{pp}(jj) = median(angleDiff_VJ_VAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VJ_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. J)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VJ_VAJ{pp}(jj) medianDiff_VJ_VAJ{pp}(jj)],[0 max(n_Diff_VJ_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VJ_VAJ{pp}(jj),max(n_Diff_VJ_VAJ{pp}(jj,:))*1.2,num2str(medianDiff_VJ_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&J,VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(17);set(figure(17),'name','Distribution of the preferred directions (A&J, VAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_A_VAJ_azi{pp}{jj} = preDir_A_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VAJ_ele{pp}{jj} = preDir_A_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_J_VAJ_azi{pp}{jj} = preDir_J_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_J_VAJ_ele{pp}{jj} = preDir_J_VAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    preDir_A_VAJ_azi{pp}{jj} = preDir_A_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_A_VAJ_ele{pp}{jj} = preDir_A_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_J_VAJ_azi{pp}{jj} = preDir_J_VAJ_azi{pp}{jj}(r2_VAJ>r2_thre);
                    preDir_J_VAJ_ele{pp}{jj} = preDir_J_VAJ_ele{pp}{jj}(r2_VAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_VAJ_azi{pp}{jj},preDir_J_VAJ_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, A');ylabel('Preferred Azi, J');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_VAJ_ele{pp}{jj},preDir_J_VAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, A');ylabel('Preferred Ele, J');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (A&J, VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(18);set(figure(18),'name','Distribution of the difference between preferred directions (A&J,VAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_AJ_VAJ_plot{pp}{jj} = angleDiff_VA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    angleDiff_AJ_VAJ_plot{pp}{jj} = angleDiff_AJ_VAJ_plot{pp}{jj}(r2_VAJ>r2_thre);
                    
                    [n_Diff_AJ_VAJ{pp}(jj,:), ~] = hist(angleDiff_AJ_VAJ_plot{pp}{jj},xDiff);
                    medianDiff_AJ_VAJ{pp}(jj) = median(angleDiff_AJ_VAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_AJ_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( A vs. J)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_AJ_VAJ{pp}(jj) medianDiff_AJ_VAJ{pp}(jj)],[0 max(n_Diff_AJ_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_AJ_VAJ{pp}(jj),max(n_Diff_AJ_VAJ{pp}(jj,:))*1.2,num2str(medianDiff_AJ_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (A&J,VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
    end

    function f2p2p8(debug)      % Preferred direction & angle difference distribution ( V/A vs. P)
        if debug  ; dbstack;   keyboard;      end
        
        xDiff = linspace(0,180,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'PVAJ'))
            figure(11);set(figure(11),'name','Distribution of the preferred directions (V&P, PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_PVAJ_Pzi{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_P_PVAJ_Pzi{pp}{jj} = preDir_P_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_P_PVAJ_ele{pp}{jj} = preDir_P_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    preDir_V_PVAJ_Pzi{pp}{jj} = preDir_V_PVAJ_Pzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_V_PVAJ_ele{pp}{jj} = preDir_V_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_P_PVAJ_Pzi{pp}{jj} = preDir_P_PVAJ_Pzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_P_PVAJ_ele{pp}{jj} = preDir_P_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_Pzi{pp}{jj},preDir_P_PVAJ_Pzi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, P');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_PVAJ_ele{pp}{jj},preDir_P_PVAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, P');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&P, PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(12);set(figure(12),'name','Distribution of the difference between preferred directions (V&P,PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VP_PVAJ_plot{pp}{jj} = angleDiff_VP_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    angleDiff_VP_PVAJ_plot{pp}{jj} = angleDiff_VP_PVAJ_plot{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_Diff_VP_PVAJ{pp}(jj,:), ~] = hist(angleDiff_VP_PVAJ_plot{pp}{jj},xDiff);
                    medianDiff_VP_PVAJ{pp}(jj) = median(angleDiff_VP_PVAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VP_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. P)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VP_PVAJ{pp}(jj) medianDiff_VP_PVAJ{pp}(jj)],[0 max(n_Diff_VP_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VP_PVAJ{pp}(jj),max(n_Diff_VP_PVAJ{pp}(jj,:))*1.2,num2str(medianDiff_VP_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&P,PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(13);set(figure(13),'name','Distribution of the preferred directions (A&P, PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_A_PVAJ_Pzi{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_P_PVAJ_Pzi{pp}{jj} = preDir_P_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_P_PVAJ_ele{pp}{jj} = preDir_P_PVAJ_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    preDir_A_PVAJ_Pzi{pp}{jj} = preDir_A_PVAJ_Pzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_A_PVAJ_ele{pp}{jj} = preDir_A_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_P_PVAJ_Pzi{pp}{jj} = preDir_P_PVAJ_Pzi{pp}{jj}(r2_PVAJ>r2_thre);
                    preDir_P_PVAJ_ele{pp}{jj} = preDir_P_PVAJ_ele{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_PVAJ_Pzi{pp}{jj},preDir_P_PVAJ_Pzi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, A');ylabel('Preferred Azi, P');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_PVAJ_ele{pp}{jj},preDir_P_PVAJ_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, A');ylabel('Preferred Ele, P');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (A&P, PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(14);set(figure(14),'name','Distribution of the difference between preferred directions (A&P,PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_AP_PVAJ_plot{pp}{jj} = angleDiff_AP_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    angleDiff_AP_PVAJ_plot{pp}{jj} = angleDiff_AP_PVAJ_plot{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_Diff_AP_PVAJ{pp}(jj,:), ~] = hist(angleDiff_AP_PVAJ_plot{pp}{jj},xDiff);
                    medianDiff_AP_PVAJ{pp}(jj) = median(angleDiff_AP_PVAJ_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_AP_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( A vs. P)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_AP_PVAJ{pp}(jj) medianDiff_AP_PVAJ{pp}(jj)],[0 max(n_Diff_AP_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_AP_PVAJ{pp}(jj),max(n_Diff_AP_PVAJ{pp}(jj,:))*1.2,num2str(medianDiff_AP_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (A&P,PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(15);set(figure(15),'name','Distribution of the preferred directions (V&P, VAP model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_V_VAP_azi{pp}{jj} = preDir_V_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VAP_ele{pp}{jj} = preDir_V_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_P_VAP_azi{pp}{jj} = preDir_P_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_P_VAP_ele{pp}{jj} = preDir_P_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    preDir_V_VAP_azi{pp}{jj} = preDir_V_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_V_VAP_ele{pp}{jj} = preDir_V_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    preDir_P_VAP_azi{pp}{jj} = preDir_P_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_P_VAP_ele{pp}{jj} = preDir_P_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAP_azi{pp}{jj},preDir_P_VAP_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, P');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VAP_ele{pp}{jj},preDir_P_VAP_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, P');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&P, VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(16);set(figure(16),'name','Distribution of the difference between preferred directions (V&P,VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VP_VAP_plot{pp}{jj} = angleDiff_VA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    angleDiff_VP_VAP_plot{pp}{jj} = angleDiff_VP_VAP_plot{pp}{jj}(r2_VAP>r2_thre);
                    
                    [n_Diff_VP_VAP{pp}(jj,:), ~] = hist(angleDiff_VP_VAP_plot{pp}{jj},xDiff);
                    medianDiff_VP_VAP{pp}(jj) = median(angleDiff_VP_VAP_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VP_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. P)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VP_VAP{pp}(jj) medianDiff_VP_VAP{pp}(jj)],[0 max(n_Diff_VP_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VP_VAP{pp}(jj),max(n_Diff_VP_VAP{pp}(jj,:))*1.2,num2str(medianDiff_VP_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&P,VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(17);set(figure(17),'name','Distribution of the preferred directions (A&P, VAP model)','unit','normalized' ,'pos',[-0.55 -0.4 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    preDir_A_VAP_azi{pp}{jj} = preDir_A_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VAP_ele{pp}{jj} = preDir_A_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_P_VAP_azi{pp}{jj} = preDir_P_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_P_VAP_ele{pp}{jj} = preDir_P_VAP_3D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    preDir_A_VAP_azi{pp}{jj} = preDir_A_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_A_VAP_ele{pp}{jj} = preDir_A_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    preDir_P_VAP_azi{pp}{jj} = preDir_P_VAP_azi{pp}{jj}(r2_VAP>r2_thre);
                    preDir_P_VAP_ele{pp}{jj} = preDir_P_VAP_ele{pp}{jj}(r2_VAP>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_VAP_azi{pp}{jj},preDir_P_VAP_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, A');ylabel('Preferred Azi, P');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_A_VAP_ele{pp}{jj},preDir_P_VAP_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, A');ylabel('Preferred Ele, P');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Translation';'Visual'});
            text(0.65,0,{'Rotation';'Vestibular'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (A&P, VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(18);set(figure(18),'name','Distribution of the difference between preferred directions (A&P,VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_AP_VAP_plot{pp}{jj} = angleDiff_VA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    angleDiff_AP_VAP_plot{pp}{jj} = angleDiff_AP_VAP_plot{pp}{jj}(r2_VAP>r2_thre);
                    
                    [n_Diff_AP_VAP{pp}(jj,:), ~] = hist(angleDiff_AP_VAP_plot{pp}{jj},xDiff);
                    medianDiff_AP_VAP{pp}(jj) = median(angleDiff_AP_VAP_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_AP_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( A vs. P)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_AP_VAP{pp}(jj) medianDiff_AP_VAP{pp}(jj)],[0 max(n_Diff_AP_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_AP_VAP{pp}(jj),max(n_Diff_AP_VAP{pp}(jj,:))*1.2,num2str(medianDiff_AP_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (A&P,VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f2p2p3(debug)      % time delay distribution ( V/A )
        if debug  ; dbstack;   keyboard;      end
        xDelay = linspace(0,0.5,11);
        r2_thre = 0.5;
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of delay of V/A (VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VA')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VA_VA{pp}{jj} = cell2mat(cellfun(@(x) x(13), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    delay_VA_VA{pp}{jj} = delay_VA_VA{pp}{jj}(r2_VA>r2_thre);
                    
                    
                    [n_Delay_VA_VA{pp}(jj,:), ~] = hist(delay_VA_VA{pp}{jj},xDelay);
                    medianDelay_VA_VA{pp}(jj) = median(delay_VA_VA{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VA_VA{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( V vs. A, VA model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VA_VA{pp}(jj) medianDelay_VA_VA{pp}(jj)],[0 max(n_Delay_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VA_VA{pp}(jj),max(n_Delay_VA_VA{pp}(jj,:))*1.2,num2str(medianDelay_VA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of V/A (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(12);set(figure(12),'name','Distribution of delay of V/A (PVAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VA_PVAJ{pp}{jj} = cell2mat(cellfun(@(x) x(23), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    delay_VA_PVAJ{pp}{jj} = delay_VA_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    
                    [n_Delay_VA_PVAJ{pp}(jj,:), ~] = hist(delay_VA_PVAJ{pp}{jj},xDelay);
                    medianDelay_VA_PVAJ{pp}(jj) = median(delay_VA_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VA_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( V vs. A, PVAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VA_PVAJ{pp}(jj) medianDelay_VA_PVAJ{pp}(jj)],[0 max(n_Delay_VA_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VA_PVAJ{pp}(jj),max(n_Delay_VA_PVAJ{pp}(jj,:))*1.2,num2str(medianDelay_VA_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of V/A (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(13);set(figure(13),'name','Distribution of delay of V/A (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VA_VAJ{pp}{jj} = cell2mat(cellfun(@(x) x(18), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    delay_VA_VAJ{pp}{jj} = delay_VA_VAJ{pp}{jj}(r2_VAJ>r2_thre);
                    
                    
                    [n_Delay_VA_VAJ{pp}(jj,:), ~] = hist(delay_VA_VAJ{pp}{jj},xDelay);
                    medianDelay_VA_VAJ{pp}(jj) = median(delay_VA_VAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VA_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( V vs. A, VAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VA_VAJ{pp}(jj) medianDelay_VA_VAJ{pp}(jj)],[0 max(n_Delay_VA_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VA_VAJ{pp}(jj),max(n_Delay_VA_VAJ{pp}(jj,:))*1.2,num2str(medianDelay_VA_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of V/A (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(14);set(figure(14),'name','Distribution of delay of V/A (VAP model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAP')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VA_VAP{pp}{jj} = cell2mat(cellfun(@(x) x(18), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    delay_VA_VAP{pp}{jj} = delay_VA_VAP{pp}{jj}(r2_VAP>r2_thre);
                    
                    
                    [n_Delay_VA_VAP{pp}(jj,:), ~] = hist(delay_VA_VAP{pp}{jj},xDelay);
                    medianDelay_VA_VAP{pp}(jj) = median(delay_VA_VAP{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VA_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( V vs. A, VAP model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VA_VAP{pp}(jj) medianDelay_VA_VAP{pp}(jj)],[0 max(n_Delay_VA_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VA_VAP{pp}(jj),max(n_Delay_VA_VAP{pp}(jj,:))*1.2,num2str(medianDelay_VA_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of V/A (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f2p2p10(debug)      % time delay distribution ( J/V, J/A )
        if debug  ; dbstack;   keyboard;      end
        xDelay = linspace(0,0.5,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'PVAJ'))
            figure(12);set(figure(12),'name','Distribution of delay of J/V (PVAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VJ_PVAJ{pp}{jj} = cell2mat(cellfun(@(x) x(24)-x(23), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    delay_VJ_PVAJ{pp}{jj} = delay_VJ_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    
                    [n_Delay_VJ_PVAJ{pp}(jj,:), ~] = hist(delay_VJ_PVAJ{pp}{jj},xDelay);
                    medianDelay_VJ_PVAJ{pp}(jj) = median(delay_VJ_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VJ_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( J vs. V, PVAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VJ_PVAJ{pp}(jj) medianDelay_VJ_PVAJ{pp}(jj)],[0 max(n_Delay_VJ_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VJ_PVAJ{pp}(jj),max(n_Delay_VJ_PVAJ{pp}(jj,:))*1.2,num2str(medianDelay_VJ_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of J/V (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(13);set(figure(13),'name','Distribution of delay of J/V (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VJ_VAJ{pp}{jj} = cell2mat(cellfun(@(x) x(19)-x(18), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    delay_VJ_VAJ{pp}{jj} = delay_VJ_VAJ{pp}{jj}(r2_VAJ>r2_thre);
                    
                    
                    [n_Delay_VJ_VAJ{pp}(jj,:), ~] = hist(delay_VJ_VAJ{pp}{jj},xDelay);
                    medianDelay_VJ_VAJ{pp}(jj) = median(delay_VJ_VAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VJ_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( J vs. V, VAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VJ_VAJ{pp}(jj) medianDelay_VJ_VAJ{pp}(jj)],[0 max(n_Delay_VJ_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VJ_VAJ{pp}(jj),max(n_Delay_VJ_VAJ{pp}(jj,:))*1.2,num2str(medianDelay_VJ_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of J/V (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of delay of J/A (PVAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_AJ_PVAJ{pp}{jj} = cell2mat(cellfun(@(x) x(24), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    delay_AJ_PVAJ{pp}{jj} = delay_AJ_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    
                    [n_Delay_AJ_PVAJ{pp}(jj,:), ~] = hist(delay_AJ_PVAJ{pp}{jj},xDelay);
                    medianDelay_AJ_PVAJ{pp}(jj) = median(delay_AJ_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_AJ_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( J vs. A, PVAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_AJ_PVAJ{pp}(jj) medianDelay_AJ_PVAJ{pp}(jj)],[0 max(n_Delay_AJ_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_AJ_PVAJ{pp}(jj),max(n_Delay_AJ_PVAJ{pp}(jj,:))*1.2,num2str(medianDelay_AJ_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of J/A (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(15);set(figure(15),'name','Distribution of delay of J/A (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_AJ_VAJ{pp}{jj} = cell2mat(cellfun(@(x) x(19), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    delay_AJ_VAJ{pp}{jj} = delay_AJ_VAJ{pp}{jj}(r2_VAJ>r2_thre);
                    
                    
                    [n_Delay_AJ_VAJ{pp}(jj,:), ~] = hist(delay_AJ_VAJ{pp}{jj},xDelay);
                    medianDelay_AJ_VAJ{pp}(jj) = median(delay_AJ_VAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_AJ_VAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( J vs. A, VAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_AJ_VAJ{pp}(jj) medianDelay_AJ_VAJ{pp}(jj)],[0 max(n_Delay_AJ_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_AJ_VAJ{pp}(jj),max(n_Delay_AJ_VAJ{pp}(jj,:))*1.2,num2str(medianDelay_AJ_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of J/A (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f2p2p9(debug)      % time delay distribution ( P/V, P/A )
        if debug  ; dbstack;   keyboard;      end
        xDelay = linspace(0,0.5,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'PVAJ'))
            figure(12);set(figure(12),'name','Distribution of delay of P/V (PVAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VP_PVAJ{pp}{jj} = cell2mat(cellfun(@(x) x(25)-x(23), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    delay_VP_PVAJ{pp}{jj} = delay_VP_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    
                    [n_Delay_VP_PVAJ{pp}(jj,:), ~] = hist(delay_VP_PVAJ{pp}{jj},xDelay);
                    medianDelay_VP_PVAJ{pp}(jj) = median(delay_VP_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VP_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( P vs. V, PVAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VP_PVAJ{pp}(jj) medianDelay_VP_PVAJ{pp}(jj)],[0 max(n_Delay_VP_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VP_PVAJ{pp}(jj),max(n_Delay_VP_PVAJ{pp}(jj,:))*1.2,num2str(medianDelay_VP_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of P/V (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of delay of P/V (VAP model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAP')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VP_VAP{pp}{jj} = cell2mat(cellfun(@(x) x(19)-x(18), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    delay_VP_VAP{pp}{jj} = delay_VP_VAP{pp}{jj}(r2_VAP>r2_thre);
                    
                    
                    [n_Delay_VP_VAP{pp}(jj,:), ~] = hist(delay_VP_VAP{pp}{jj},xDelay);
                    medianDelay_VP_VAP{pp}(jj) = median(delay_VP_VAP{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VP_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( P vs. V, VAP model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VP_VAP{pp}(jj) medianDelay_VP_VAP{pp}(jj)],[0 max(n_Delay_VP_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VP_VAP{pp}(jj),max(n_Delay_VP_VAP{pp}(jj,:))*1.2,num2str(medianDelay_VP_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of P/V (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of delay of P/A (PVAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_AP_PVAJ{pp}{jj} = cell2mat(cellfun(@(x) x(25), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    delay_AP_PVAJ{pp}{jj} = delay_AP_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    
                    [n_Delay_AP_PVAJ{pp}(jj,:), ~] = hist(delay_AP_PVAJ{pp}{jj},xDelay);
                    medianDelay_AP_PVAJ{pp}(jj) = median(delay_AP_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_AP_PVAJ{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( P vs. A, PVAJ model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_AP_PVAJ{pp}(jj) medianDelay_AP_PVAJ{pp}(jj)],[0 max(n_Delay_AP_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_AP_PVAJ{pp}(jj),max(n_Delay_AP_PVAJ{pp}(jj,:))*1.2,num2str(medianDelay_AP_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of P/A (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(15);set(figure(15),'name','Distribution of delay of P/A (VAP model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_3D{pp}{jj}(:,find(strcmp(models,'VAP')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_AP_VAP{pp}{jj} = cell2mat(cellfun(@(x) x(19), temp,'UniformOutput',false));
                    
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    delay_AP_VAP{pp}{jj} = delay_AP_VAP{pp}{jj}(r2_VAP>r2_thre);
                    
                    
                    [n_Delay_AP_VAP{pp}(jj,:), ~] = hist(delay_AP_VAP{pp}{jj},xDelay);
                    medianDelay_AP_VAP{pp}(jj) = median(delay_AP_VAP{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_AP_VAP{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( P vs. A, VAP model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_AP_VAP{pp}(jj) medianDelay_AP_VAP{pp}(jj)],[0 max(n_Delay_AP_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_AP_VAP{pp}(jj),max(n_Delay_AP_VAP{pp}(jj,:))*1.2,num2str(medianDelay_AP_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of P/A (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end
    function f2p2p4(debug)      % Partial R_squared distribution
        if debug  ; dbstack;   keyboard;      end
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Partial R2 (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VA_3D{pp}(:,jj) parR2A_VA_3D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2],'xticklabel',{'V/VA','A/VA'},'xlim',[0.5 2.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Partial R2 (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VAJ_3D{pp}(:,jj) parR2A_VAJ_3D{pp}(:,jj) parR2J_VAJ_3D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V/VAJ','A/VAJ','J/VAJ'},'xlim',[0.5 3.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Partial R2 (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VAP_3D{pp}(:,jj) parR2A_VAP_3D{pp}(:,jj) parR2P_VAP_3D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V/VAP','A/VAP','P/VAP'},'xlim',[0.5 3.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f2p2p5(debug)      % Weight distribution
        if debug  ; dbstack;   keyboard;      end
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2],1,sum(select_temporalSig{pp}(:,jj))),[wV_VA_plot{pp}{jj},wA_VA_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2],'xticklabel',{'V','A'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 2.5],'ylim',[0 1]);
                    
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of weight (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VAJ_plot{pp}{jj} = wV_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VAJ_plot{pp}{jj} = wA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wJ_VAJ_plot{pp}{jj} = wJ_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3],1,sum(select_temporalSig{pp}(:,jj))),[wV_VAJ_plot{pp}{jj},wA_VAJ_plot{pp}{jj},wJ_VAJ_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V','A','J'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 3.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of weight (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VAP_plot{pp}{jj} = wV_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VAP_plot{pp}{jj} = wA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wP_VAP_plot{pp}{jj} = wP_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3],1,sum(select_temporalSig{pp}(:,jj))),[wV_VAP_plot{pp}{jj},wA_VAP_plot{pp}{jj},wP_VAP_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V','A','P'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 3.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of weight (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_PVAJ_plot{pp}{jj} = wV_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_PVAJ_plot{pp}{jj} = wA_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wJ_PVAJ_plot{pp}{jj} = wJ_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wP_PVAJ_plot{pp}{jj} = wP_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3;4],1,sum(select_temporalSig{pp}(:,jj))),[wV_PVAJ_plot{pp}{jj},wA_PVAJ_plot{pp}{jj},wJ_PVAJ_plot{pp}{jj},wP_PVAJ_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3 4],'xticklabel',{'V','A','J','P'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 4.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f2p2p11(debug)      % Weight V/A vs. kmeans
        if debug  ; dbstack;   keyboard;      end
        
        %--------------- PCA
        denoised_dim = 4; % how many PCs you want to plot
        numClassics = 3; % number of clusters
        
        for pp = 1:2
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                %{
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),26,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},1),size(dataPCA_raw{pp}{jj},1),1))./repmat(std(dataPCA_raw{pp}{jj},1,1),size(dataPCA_raw{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj}' * weights_PCA_PC{pp}{jj}(:,ii);
                end
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}, projPC2{pp}{jj}{3}, projPC2{pp}{jj}{4}], numClassics,'start','uniform','emptyaction','drop');
                %}
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},1),size(dataPCA_raw1{pp}{jj},1),1))./repmat(std(dataPCA_raw1{pp}{jj},1,1),size(dataPCA_raw1{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj}' * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}, projPC2{pp}{jj}{3}, projPC2{pp}{jj}{4}], numClassics,'start','uniform','emptyaction','drop');
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},1),size(dataPCA_raw2{pp}{jj},1),1))./repmat(std(dataPCA_raw2{pp}{jj},1,1),size(dataPCA_raw2{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj}' * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}, projPC2{pp}{jj}{3}, projPC2{pp}{jj}{4}], numClassics,'start','uniform','emptyaction','drop');
                
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                %{
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(26,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},1),size(dataPCA_raw3{pp}{jj},1),1))./repmat(std(dataPCA_raw3{pp}{jj},1,1),size(dataPCA_raw3{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj}' * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}, projPC2{pp}{jj}{3}, projPC2{pp}{jj}{4}], numClassics,'start','uniform','emptyaction','drop');
                %}
                
            end
        end
        
        %         for pp = 1:2
        %             for jj = 1:2
        %
        %                 axes(h_subplot((jj-1)*2+pp));hold on;
        %                 for i=1: length(unique(Index{pp}{jj}))
        %                     plot3(projPC2{pp}{jj}{1}(Index{pp}{jj}==i),projPC2{pp}{jj}{2}(Index{pp}{jj}==i),projPC2{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
        %                 end
        %                 xlabel('PC1');ylabel('PC2');zlabel('PC3');
        %                 view(3);axis on;
        %             end
        %         end
        
        color = {'r','g','b','k'};h = [];
        %--------------- Weight
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0 0.4 0.7]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.1,0.1,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    for i = 1:length(Index{pp}{jj})
                        if ~isempty(find(Index{pp}{jj} == i))
                            h = plot(wV_VA_plot{pp}{jj}(Index{pp}{jj} == i),wA_VA_plot{pp}{jj}(Index{pp}{jj} == i),'ko','markersize',12,'markerfacecolor',color{i},'markeredgecolor','w');
                            h.color(4) = 0.5;
                        end
                    end
                    xlabel('Weight V');ylabel('Weight A');axis on;
                    set(gca,'xlim',[0 1],'ylim',[0 1]);
                    axis square;
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
    end

    function f2p2p12(debug)      % Weight V/A vs. PCA
        if debug  ; dbstack;   keyboard;      end
        figure(31);set(figure(31),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %--------------- PCA
        denoised_dim = 4; % how many PCs you want to plot
        numClassics = 3; % number of clusters
        
        for pp = 1:2
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                %{
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),26,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},1),size(dataPCA_raw{pp}{jj},1),1))./repmat(std(dataPCA_raw{pp}{jj},1,1),size(dataPCA_raw{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj}' * weights_PCA_PC{pp}{jj}(:,ii);
                end
                colors = {[239 239 247]/255, [204 207 226]/255, [138 188 209]/255, [15 139 184]/255, [23 70 107]/255, [8 32 51]/255};h = [];
        
        %--------------- Weight
        figure(31);set(figure(31),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0 0.4 0.7]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.1,0.1,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）

                axes(h_subplot((jj-1)*2+pp));hold on;
                pc = 0;
                for ii = 0:0.2:0.9
                    pc = pc+1;
                plot3(projPC{pp}{jj}{1}(wV_VA_plot{pp}{jj}>ii),projPC{pp}{jj}{2}(wV_VA_plot{pp}{jj}>ii),projPC{pp}{jj}{3}(wV_VA_plot{pp}{jj}>ii),'k.','color',colors{pc});
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
                
            end
        end
        SetFigure(12);

            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
                %}
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},1),size(dataPCA_raw1{pp}{jj},1),1))./repmat(std(dataPCA_raw1{pp}{jj},1,1),size(dataPCA_raw1{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj}' * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                colors = {[239 239 247]/255, [204 207 226]/255, [138 188 209]/255, [15 139 184]/255, [23 70 107]/255, [8 32 51]/255};h = [];
        
        %--------------- Weight
        figure(31);set(figure(31),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0 0.4 0.7]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.1,0.1,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）

                axes(h_subplot((jj-1)*2+pp));hold on;
                pc = 0;
                for ii = 0:0.2:0.9
                    pc = pc+1;
                plot3(projPC1{pp}{jj}{1}(wV_VA_plot{pp}{jj}>ii),projPC1{pp}{jj}{2}(wV_VA_plot{pp}{jj}>ii),projPC1{pp}{jj}{3}(wV_VA_plot{pp}{jj}>ii),'k.','color',colors{pc});
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
                
            end
        end
        SetFigure(12);

            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
                
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},1),size(dataPCA_raw2{pp}{jj},1),1))./repmat(std(dataPCA_raw2{pp}{jj},1,1),size(dataPCA_raw2{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj}' * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                
                colors = {[239 239 247]/255, [204 207 226]/255, [138 188 209]/255, [15 139 184]/255, [23 70 107]/255, [8 32 51]/255};h = [];
                
                %--------------- Weight
                
                
                if sum(strcmp(models,'VA'))
                    
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    pc = 0;
                    for ii = 0:0.2:0.9
                        pc = pc+1;
                        try
                            if ~isempty(find(wV_VA_plot{pp}{jj}>ii))
                                plot3(projPC2{pp}{jj}{1}(wV_VA_plot{pp}{jj}>ii),projPC2{pp}{jj}{2}(wV_VA_plot{pp}{jj}>ii),projPC2{pp}{jj}{3}(wV_VA_plot{pp}{jj}>ii),'k.','color',colors{pc});
                            end
                        catch
                            keyboard;
                        end
                    end
                    xlabel('PC1');ylabel('PC2');zlabel('PC3');
                    view(3);axis on;
                    
                end
                
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                %{
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(26,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},1),size(dataPCA_raw3{pp}{jj},1),1))./repmat(std(dataPCA_raw3{pp}{jj},1,1),size(dataPCA_raw3{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj}' * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                colors = {[239 239 247]/255, [204 207 226]/255, [138 188 209]/255, [15 139 184]/255, [23 70 107]/255, [8 32 51]/255};h = [];
        
        %--------------- Weight
        figure(31);set(figure(31),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0 0.4 0.7]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.1,0.1,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）

                axes(h_subplot((jj-1)*2+pp));hold on;
                pc = 0;
                for ii = 0:0.2:0.9
                    pc = pc+1;
                plot3(projPC3{pp}{jj}{1}(wV_VA_plot{pp}{jj}>ii),projPC3{pp}{jj}{2}(wV_VA_plot{pp}{jj}>ii),projPC3{pp}{jj}{3}(wV_VA_plot{pp}{jj}>ii),'k.','color',colors{pc});
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
                
            end
        end
        SetFigure(12);

            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
                %}
                
            end
        end
        
        SetFigure(12);
        
        % text necessary infos
        axes('pos',[0.05 0.2 0.1 0.7]);
        text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
        axis off;
        axes('pos',[0.2 0.9 0.7 0.1]);
        text(0.15,0,'Translation');text(0.85,0,'Rotation');
        axis off;
        suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
        SetFigure(12);
        
    end

    function f2p2p6(debug)      % Weight distribution (P,V,A,J weight)
        if debug  ; dbstack;   keyboard;      end
        r2_thre = 0.5;
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % only use which r2 > threshold (0.5)
                    wV_VA{pp}{jj} = wV_VA_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VA')))>r2_thre,jj);
                    wA_VA{pp}{jj} = wA_VA_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VA')))>r2_thre,jj);
                    
                    step = 20;
                    for w_inx = 1:step
                        nV_VA{pp}{jj}(w_inx) = sum(logical(wV_VA{pp}{jj}<=0+1/step*w_inx))/length(wV_VA{pp}{jj})*100;
                        nA_VA{pp}{jj}(w_inx) = sum(logical(wA_VA{pp}{jj}<=0+1/step*w_inx))/length(wA_VA{pp}{jj})*100;
                    end
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:step,nV_VA{pp}{jj},'r-',1:step,nA_VA{pp}{jj},'b-');
                    set(gca,'xtick',[0 step/2 step],'xticklabel',{'0','0.5','1'});
                    xlabel('Weight');ylabel('% cells');axis on;
                    set(gca,'xlim',[0 step],'ylim',[0 100]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of weight (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % only use which r2 > threshold (0.5)
                    wV_VAJ{pp}{jj} = wV_VAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAJ')))>r2_thre,jj);
                    wA_VAJ{pp}{jj} = wA_VAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAJ')))>r2_thre,jj);
                    wJ_VAJ{pp}{jj} = wJ_VAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAJ')))>r2_thre,jj);
                    
                    step = 20;
                    for w_inx = 1:step
                        nV_VAJ{pp}{jj}(w_inx) = sum(logical(wV_VAJ{pp}{jj}<=0+1/step*w_inx))/length(wV_VAJ{pp}{jj})*100;
                        nA_VAJ{pp}{jj}(w_inx) = sum(logical(wA_VAJ{pp}{jj}<=0+1/step*w_inx))/length(wA_VAJ{pp}{jj})*100;
                        nJ_VAJ{pp}{jj}(w_inx) = sum(logical(wJ_VAJ{pp}{jj}<=0+1/step*w_inx))/length(wJ_VAJ{pp}{jj})*100;
                    end
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:step,nV_VAJ{pp}{jj},'r-',1:step,nA_VAJ{pp}{jj},'b-',1:step,nJ_VAJ{pp}{jj},'y-');
                    set(gca,'xtick',[0 step/2 step],'xticklabel',{'0','0.5','1'});
                    xlabel('Weight');ylabel('% cells');axis on;
                    set(gca,'xlim',[0 step],'ylim',[0 100]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of weight (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % only use which r2 > threshold (0.5)
                    wV_VAP{pp}{jj} = wV_VAP_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAP')))>r2_thre,jj);
                    wA_VAP{pp}{jj} = wA_VAP_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAP')))>r2_thre,jj);
                    wP_VAP{pp}{jj} = wP_VAP_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'VAP')))>r2_thre,jj);
                    
                    step = 20;
                    for w_inx = 1:step
                        nV_VAP{pp}{jj}(w_inx) = sum(logical(wV_VAP{pp}{jj}<=0+1/step*w_inx))/length(wV_VAP{pp}{jj})*100;
                        nA_VAP{pp}{jj}(w_inx) = sum(logical(wA_VAP{pp}{jj}<=0+1/step*w_inx))/length(wA_VAP{pp}{jj})*100;
                        nP_VAP{pp}{jj}(w_inx) = sum(logical(wP_VAP{pp}{jj}<=0+1/step*w_inx))/length(wP_VAP{pp}{jj})*100;
                    end
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:step,nV_VAP{pp}{jj},'r-',1:step,nA_VAP{pp}{jj},'b-',1:step,nP_VAP{pp}{jj},'g-');
                    set(gca,'xtick',[0 step/2 step],'xticklabel',{'0','0.5','1'});
                    xlabel('Weight');ylabel('% cells');axis on;
                    set(gca,'xlim',[0 step],'ylim',[0 100]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of weight (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    % only use which r2 > threshold (0.5)
                    wV_PVAJ{pp}{jj} = wV_PVAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')))>r2_thre,jj);
                    wA_PVAJ{pp}{jj} = wA_PVAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')))>r2_thre,jj);
                    wJ_PVAJ{pp}{jj} = wJ_PVAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')))>r2_thre,jj);
                    wP_PVAJ{pp}{jj} = wP_PVAJ_3D{pp}(R2_3D{pp}{jj}(:,find(strcmp(models,'PVAJ')))>r2_thre,jj);
                    
                    step = 20;
                    for w_inx = 1:step
                        nV_PVAJ{pp}{jj}(w_inx) = sum(logical(wV_PVAJ{pp}{jj}<=0+1/step*w_inx))/length(wV_PVAJ{pp}{jj})*100;
                        nA_PVAJ{pp}{jj}(w_inx) = sum(logical(wA_PVAJ{pp}{jj}<=0+1/step*w_inx))/length(wA_PVAJ{pp}{jj})*100;
                        nJ_PVAJ{pp}{jj}(w_inx) = sum(logical(wJ_PVAJ{pp}{jj}<=0+1/step*w_inx))/length(wJ_PVAJ{pp}{jj})*100;
                        nP_PVAJ{pp}{jj}(w_inx) = sum(logical(wP_PVAJ{pp}{jj}<=0+1/step*w_inx))/length(wP_PVAJ{pp}{jj})*100;
                    end
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:step,nV_PVAJ{pp}{jj},'r-',1:step,nA_PVAJ{pp}{jj},'b-',1:step,nJ_PVAJ{pp}{jj},'y-',1:step,nP_PVAJ{pp}{jj},'g-');
                    set(gca,'xtick',[0 step/2 step],'xticklabel',{'0','0.5','1'});
                    xlabel('Weight');ylabel('% cells');axis on;
                    set(gca,'xlim',[0 step],'ylim',[0 100]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f2p3(debug)      % check
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p3p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
    end

%%%%% 1D models

    function f3p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
        
    end

    function f3p1p1(debug)      % BIC distribution across models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                [~, temp] =  min(BIC_1D{pp}{jj},[],2);
                BIC_min{pp,jj} = temp(select_temporalSig{pp}(:,jj));
                [n_BIC{pp}(jj,:), ~] = hist(BIC_min{pp,jj},1:length(models));
                
            end
        end
        
        
        figure(11);set(figure(11),'name','Distribution of best fitting model (BIC)','unit','normalized','pos',[-0.55 0.4 0.53 0.35]); clf;
        h = axes('pos',[0.1 0.2 0.8 0.6]);
        BestFitModel = [n_BIC{1}(1,:);n_BIC{1}(2,:);n_BIC{2}(1,:);n_BIC{2}(2,:)]';
        hbar = bar(1:length(models),BestFitModel,'grouped');
        % set(h(1),'facecolor',colorDBlue,'edgecolor',colorDBlue);
        % set(h(2),'facecolor',colorDRed,'edgecolor',colorDRed);
        % set(h(3),'facecolor',colorLBlue,'edgecolor',colorLBlue);
        % set(h(4),'facecolor',colorLRed,'edgecolor',colorLRed);
        xlabel('Models');ylabel('Cell #');
        set(gca,'xticklabel',models);
        title('Distribution of best fitting model (BIC)');
        legend(['Translation (Vestibular), n = ',num2str(sum(select_temporalSig{1}(:,1)))],['Translation (Visual), n = ',num2str(sum(select_temporalSig{1}(:,2)))],['Rotation (Vestibular), n = ',num2str(sum(select_temporalSig{2}(:,1)))],['Rotation (Visual), n = ',num2str(sum(select_temporalSig{2}(:,2)))],'location','NorthWest');
        SetFigure(12);
        
    end

    function f3p1p2(debug)      % R_squared distribution across models
        if debug  ; dbstack;   keyboard;      end
        xR2 = linspace(0,1,11);
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                temp = 1: length(group_result);
                R2_plot{pp}{jj} = R2_1D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                for m_inx = 1:length(models)
                    [n_R2{pp}{jj}(m_inx,:), ~] = hist(R2_plot{pp}{jj}(:,m_inx),xR2);
                end
            end
        end
        
        figure(11);set(figure(11),'name','Distribution of R2 across models','unit','normalized','pos',[-0.55 0 0.53 0.6]); clf;
        [~,h_subplot] = tight_subplot(4,length(models),[0.07 0.03],0.15,0.01);
        for pp = 1:2
            for jj = 1:2
                for m_inx = 1:length(models)
                    axes(h_subplot(((pp-1)*2+(jj-1))*length(models)+m_inx));hold on;
                    bar(xR2,n_R2{pp}{jj}(m_inx,:),'k');axis on;
                    medianTemp = median(R2_plot{pp}{jj}(:,m_inx));
                    plot([medianTemp medianTemp],[0 max(n_R2{pp}{jj}(m_inx,:))*1.1],'k--','linewidth',1.5);
                    text(medianTemp,max(n_R2{pp}{jj}(m_inx,:))*1.2,num2str(medianTemp),'fontsize',8);
                    set(gca,'xlim',[0 1]);
                    %                 set(gca,'xtick',[],'ytick',[]);
                end
            end
        end
        
        % text necessary infos
        axes('pos',[0.005 0.05 1 0.05]);
        for m_inx = 1:length(models)
            text(0.1*m_inx-0.075,0,models(m_inx));
        end
        %             text(0,0,['n visual (visSig) = ',num2str(sum(select_spatialSig{pp}(:,2)))],'color','r');
        axis off;
        suptitle('Distribution of R^2 across models');
        SetFigure(12);
    end

    function f3p1p3(debug)      % VAF comparison (R2) across models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                temp = 1: length(group_result);
                R2_plot{pp}{jj} = R2_1D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                %                 RSS_temp{pp}{jj} = RSS{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                
            end
        end
        
        figure(11);set(figure(11),'name','Comparison of VAF(R2) of different models','unit','normalized','pos',[-0.55 -0.7 0.53 1.6]); clf;
        [~,h_subplot] = tight_subplot(4,3,[0.1 0.02],0.1,0.01);
        
        if sum(strcmp(models,'PVAJ')) && sum(strcmp(models,'VAP'))
            idx1 = find(strcmp(models,'PVAJ'));
            idx2 = find(strcmp(models,'VAP'));
            axes(h_subplot(1));hold on;
            for pp = 1:2
                for jj = 1:2
                    %                     [~,seqF{pp}{jj}] = sequentialF(RSS_temp{pp}{jj}(:,idx1),nParaModel{model_cat}(idx1),RSS_temp{pp}{jj}(:,idx2),nParaModel{model_cat}(idx2),26*nBins);
                    %                     R2_plot_sig{pp}{jj} = R2_plot{pp}{jj}(seqF{pp}{jj}<0.05,:);
                    %                     plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor','w','markeredgecolor',colors{jj});
                    %                     plot(R2_plot_sig{pp}{jj}(:,idx2),R2_plot_sig{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VAP model');ylabel('VAF (r^2), PVAJ model');
        end
        
        if sum(strcmp(models,'PVAJ')) && sum(strcmp(models,'VAJ'))
            idx1 = find(strcmp(models,'PVAJ'));
            idx2 = find(strcmp(models,'VAJ'));
            axes(h_subplot(2));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VAJ model');ylabel('VAF (r^2), PVAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'AJ'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'AJ'));
            axes(h_subplot(4));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AJ model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'VJ'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'VJ'));
            axes(h_subplot(5));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VJ model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAJ')) && sum(strcmp(models,'VA'))
            idx1 = find(strcmp(models,'VAJ'));
            idx2 = find(strcmp(models,'VA'));
            axes(h_subplot(6));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VA model');ylabel('VAF (r^2), VAJ model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'AP'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'AP'));
            axes(h_subplot(7));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AP model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'VP'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'VP'));
            axes(h_subplot(8));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VP model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VAP')) && sum(strcmp(models,'VA'))
            idx1 = find(strcmp(models,'VAP'));
            idx2 = find(strcmp(models,'VA'));
            axes(h_subplot(9));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VA model');ylabel('VAF (r^2), VAP model');
        end
        
        if sum(strcmp(models,'VA')) && sum(strcmp(models,'VO'))
            idx1 = find(strcmp(models,'VA'));
            idx2 = find(strcmp(models,'VO'));
            axes(h_subplot(10));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), VO model');ylabel('VAF (r^2), VA model');
        end
        
        if sum(strcmp(models,'VA')) && sum(strcmp(models,'AO'))
            idx1 = find(strcmp(models,'VA'));
            idx2 = find(strcmp(models,'AO'));
            axes(h_subplot(11));hold on;
            for pp = 1:2
                for jj = 1:2
                    plot(R2_plot{pp}{jj}(:,idx2),R2_plot{pp}{jj}(:,idx1),'linestyle','none','marker',markers{pp},'markersize',5,'markerfacecolor',colors{jj},'markeredgecolor','k');
                end
            end
            plot([0 1],[0 1],':','color',[0.3 0.3 0.3]);
            axis on;axis square;
            set(gca,'xlim',[0 1],'ylim',[0 1]); xlabel('VAF (r^2), AO model');ylabel('VAF (r^2), VA model');
        end
        
        
        suptitle('Comparison of VAF(R^2) of different models');
        SetFigure(12);
    end

    function f3p2(debug)      % Parameter analysis
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f3p2p1(debug)      % Weight ratio (V/A) distribution
        if debug  ; dbstack;   keyboard;      end
        xVA = -3:0.5:3;
        r2_thre = 0.5;
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of log(wV/wA) (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    RatioVA_VA{pp}{jj} = log(wV_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj)./wA_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = RatioVA_VA{pp}{jj}(select_temporalSig{pp}(:,jj),3);
                    RatioVA_VA{pp}{jj} = RatioVA_VA{pp}{jj}(r2_VA>r2_thre);
                    
                    [n_VA_VA{pp}(jj,:), ~] = hist(RatioVA_VA{pp}{jj},xVA);
                    medianVA_VA{pp}(jj) = median(RatioVA_VA{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{1} = bar(xVA,n_VA_VA{pp}(jj,:));
                    set(hbar{1},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VA{pp}(jj) medianVA_VA{pp}(jj)],[0 max(n_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VA{pp}(jj),max(n_VA_VA{pp}(jj,:))*1.2,num2str(medianVA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of log(wV/wA) (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAJ')));
                    RatioVA_VAJ{pp}{jj} = RatioVA_VAJ{pp}{jj}(r2_VAJ>r2_thre);
                    
                    [n_VA_VAJ{pp}(jj,:), ~] = hist(RatioVA_VAJ{pp}{jj},xVA);
                    medianVA_VAJ{pp}(jj) = median(RatioVA_VAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_VAJ{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VAJ{pp}(jj) medianVA_VAJ{pp}(jj)],[0 max(n_VA_VAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VAJ{pp}(jj),max(n_VA_VAJ{pp}(jj,:))*1.2,num2str(medianVA_VAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of log(wV/wA) (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAP{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_VAP = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VAP')));
                    RatioVA_VAP{pp}{jj} = RatioVA_VAP{pp}{jj}(r2_VAP>r2_thre);
                    
                    [n_VA_VAP{pp}(jj,:), ~] = hist(RatioVA_VAP{pp}{jj},xVA);
                    medianVA_VAP{pp}(jj) = median(RatioVA_VAP{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_VAP{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_VAP{pp}(jj) medianVA_VAP{pp}(jj)],[0 max(n_VA_VAP{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_VAP{pp}(jj),max(n_VA_VAP{pp}(jj,:))*1.2,num2str(medianVA_VAP{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of log(wV/wA) (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_PVAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    
                    % only use which r2 > threshold (0.5)
                    r2_PVAJ = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'PVAJ')));
                    RatioVA_PVAJ{pp}{jj} = RatioVA_PVAJ{pp}{jj}(r2_PVAJ>r2_thre);
                    
                    [n_VA_PVAJ{pp}(jj,:), ~] = hist(RatioVA_PVAJ{pp}{jj},xVA);
                    medianVA_PVAJ{pp}(jj) = median(RatioVA_PVAJ{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar{2} = bar(xVA,n_VA_PVAJ{pp}(jj,:));
                    set(hbar{2},'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('log(wV/wA)');ylabel('cell #');axis on;
                    set(gca,'xlim',[min(xVA) max(xVA)]);
                    plot([medianVA_PVAJ{pp}(jj) medianVA_PVAJ{pp}(jj)],[0 max(n_VA_PVAJ{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianVA_PVAJ{pp}(jj),max(n_VA_PVAJ{pp}(jj,:))*1.2,num2str(medianVA_PVAJ{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.85 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of log(wV/wA) (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f3p2p2(debug)      % Preferred direction & angle difference distribution ( V vs. A)
        if debug  ; dbstack;   keyboard;      end
        
        xDiff = linspace(0,180,11);
        r2_thre = 0.5;
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of the preferred directions (V&A, VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    preDir_V_VA_azi{pp}{jj} = preDir_V_VA_1D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VA_ele{pp}{jj} = preDir_V_VA_1D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_VA_azi{pp}{jj} = preDir_A_VA_1D{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VA_ele{pp}{jj} = preDir_A_VA_1D{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    preDir_V_VA_azi{pp}{jj} = preDir_V_VA_azi{pp}{jj}(r2_VA>r2_thre);
                    preDir_V_VA_ele{pp}{jj} = preDir_V_VA_ele{pp}{jj}(r2_VA>r2_thre);
                    preDir_A_VA_azi{pp}{jj} = preDir_A_VA_azi{pp}{jj}(r2_VA>r2_thre);
                    preDir_A_VA_ele{pp}{jj} = preDir_A_VA_ele{pp}{jj}(r2_VA>r2_thre);
                    
                    axes(h_subplot((pp-1)*2+jj));hold on;
                    plot([0 360],[0 360],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VA_azi{pp}{jj},preDir_A_VA_azi{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[0 360],'ylim',[0 360]);set(gca,'xtick',[0 90 180 270 360],'ytick',[0 90 180 270 360]);
                    xlabel('Preferred Azi, V');ylabel('Preferred Azi, A');
                    axes(h_subplot((pp-1)*2+jj+4));hold on;
                    plot([-90 90],[-90 90],'-','color',[0.7 0.7 0.7]);
                    plot(preDir_V_VA_ele{pp}{jj},preDir_A_VA_ele{pp}{jj},'o','markeredgecolor','k');
                    axis on;axis square;set(gca,'xlim',[-90 90],'ylim',[-90 90]);set(gca,'xtick',[-90 -45 0 45 90],'ytick',[-90 -45 0 45 90]);
                    xlabel('Preferred Ele, V');ylabel('Preferred Ele, A');
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.45 0.9 0.05]);
            text(0.13,0,{'Translation';'Vestibular'});
            text(0.4,0,{'Rotation';'Vestibular'});
            text(0.65,0,{'Translation';'Visual'});
            text(0.92,0,{'Rotation';'Visual'});
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.2,'Elevation','rotation',90);text(0,0.8,'Azimuth','rotation',90);
            axis off;
            suptitle(['Distribution of the preferred directions (V&A, VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
            
            figure(12);set(figure(12),'name','Distribution of the difference between preferred directions (V&A,VA model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    
                    angleDiff_VA_VA_plot{pp}{jj} = angleDiff_VA_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    % only use which r2 > threshold (0.5)
                    r2_VA = R2_3D{pp}{jj}(select_temporalSig{pp}(:,jj),find(strcmp(models,'VA')));
                    angleDiff_VA_VA_plot{pp}{jj} = angleDiff_VA_VA_plot{pp}{jj}(r2_VA>r2_thre);
                    
                    [n_Diff_VA_VA{pp}(jj,:), ~] = hist(angleDiff_VA_VA_plot{pp}{jj},xDiff);
                    medianDiff_VA_VA{pp}(jj) = median(angleDiff_VA_VA_plot{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDiff,n_Diff_VA_VA{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('Angle diff ( V vs. A)');ylabel('cell #');axis on;
                    set(gca,'xlim',[0-30 180+30]);
                    plot([medianDiff_VA_VA{pp}(jj) medianDiff_VA_VA{pp}(jj)],[0 max(n_Diff_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDiff_VA_VA{pp}(jj),max(n_Diff_VA_VA{pp}(jj,:))*1.2,num2str(medianDiff_VA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            suptitle(['Distribution of the difference between preferred directions (V&A,VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f3p2p3(debug)      % time delay distribution ( V/A, P/V, P/A)
        if debug  ; dbstack;   keyboard;      end
        xDelay = linspace(0,0.5,11);
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of delay of V/A (VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para_1D{pp}{jj}(:,find(strcmp(models,'VA')));
                    temp = temp(select_temporalSig{pp}(:,jj));
                    delay_VA_VA{pp}{jj} = cell2mat(cellfun(@(x) x(13), temp,'UniformOutput',false));
                    [n_Delay_VA_VA{pp}(jj,:), ~] = hist(delay_VA_VA{pp}{jj},xDelay);
                    medianDelay_VA_VA{pp}(jj) = median(delay_VA_VA{pp}{jj});
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    hbar = bar(xDelay,n_Delay_VA_VA{pp}(jj,:));
                    set(hbar,'facecolor','k','edgecolor','k');
                    %             set(gca,'xtick',[]);
                    xlabel('delay ( V vs. A, VA model)');ylabel('cell #');axis on;
                    set(gca,'xlim',[-0.05 0.55]);
                    plot([medianDelay_VA_VA{pp}(jj) medianDelay_VA_VA{pp}(jj)],[0 max(n_Delay_VA_VA{pp}(jj,:))*1.1],'k--','linewidth',1.5);
                    text(medianDelay_VA_VA{pp}(jj),max(n_Delay_VA_VA{pp}(jj,:))*1.2,num2str(medianDelay_VA_VA{pp}(jj)),'color','k','fontsize',8);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.05 0.9 0.05]);
            text(0.25,0,'Translation');
            text(0.8,0,'Rotation');
            axis off;
            axes('pos',[0.05 0.1 0.1 0.7]);
            text(0,0.25,'Visual','rotation',90);text(0,0.75,'Vestibular','rotation',90);
            axis off;
            suptitle(['Distribution of delay of V/A (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
    end

    function f3p2p4(debug)      % Partial R_squared distribution
        if debug  ; dbstack;   keyboard;      end
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Partial R2 (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VA_1D{pp}(:,jj) parR2A_VA_1D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2],'xticklabel',{'V/VA','A/VA'},'xlim',[0.5 2.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Partial R2 (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VAJ_1D{pp}(:,jj) parR2A_VAJ_1D{pp}(:,jj) parR2J_VAJ_1D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V/VAJ','A/VAJ','J/VAJ'},'xlim',[0.5 3.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Partial R2 (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VAP_1D{pp}(:,jj) parR2A_VAP_1D{pp}(:,jj) parR2P_VAP_1D{pp}(:,jj)];
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(temp','-o','color',[0.7 0.7 0.7],'markeredgecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V/VAP','A/VAP','P/VAP'},'xlim',[0.5 3.5]);
                    xlabel('Partial R^2');ylabel('cell #');axis on;
                end
            end
            suptitle(['Partial R^2 (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end

    function f3p2p5(debug)      % Weight distribution
        if debug  ; dbstack;   keyboard;      end
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of weight (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VA_plot{pp}{jj} = wV_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VA_plot{pp}{jj} = wA_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2],1,sum(select_temporalSig{pp}(:,jj))),[wV_VA_plot{pp}{jj},wA_VA_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2],'xticklabel',{'V','A'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 2.5],'ylim',[0 1]);
                    
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of weight (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VAJ_plot{pp}{jj} = wV_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VAJ_plot{pp}{jj} = wA_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wJ_VAJ_plot{pp}{jj} = wJ_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3],1,sum(select_temporalSig{pp}(:,jj))),[wV_VAJ_plot{pp}{jj},wA_VAJ_plot{pp}{jj},wJ_VAJ_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V','A','J'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 3.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of weight (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.4 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_VAP_plot{pp}{jj} = wV_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_VAP_plot{pp}{jj} = wA_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wP_VAP_plot{pp}{jj} = wP_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3],1,sum(select_temporalSig{pp}(:,jj))),[wV_VAP_plot{pp}{jj},wA_VAP_plot{pp}{jj},wP_VAP_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3],'xticklabel',{'V','A','P'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 3.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of weight (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    wV_PVAJ_plot{pp}{jj} = wV_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wA_PVAJ_plot{pp}{jj} = wA_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wJ_PVAJ_plot{pp}{jj} = wJ_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    wP_PVAJ_plot{pp}{jj} = wP_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(repmat([1;2;3;4],1,sum(select_temporalSig{pp}(:,jj))),[wV_PVAJ_plot{pp}{jj},wA_PVAJ_plot{pp}{jj},wJ_PVAJ_plot{pp}{jj},wP_PVAJ_plot{pp}{jj}]','k-o','color',[0.7 0.7 0.7],'markersize',6,'markerfacecolor','k');
                    set(gca,'xtick',[1 2 3 4],'xticklabel',{'V','A','J','P'});
                    xlabel('Component');ylabel('Weight');axis on;
                    set(gca,'xlim',[0.5 4.5],'ylim',[0 1]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0,'Visual','rotation',90);text(0,0.5,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.9 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Distribution of weight (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end


    function f3p3(debug)      % check
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f3p3p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f4p1(debug)      % R_squared comparison between 3D & 1D models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                temp = 1: length(group_result);
                R2_plot_1D{pp}{jj} = R2_1D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
                R2_plot_3D{pp}{jj} = R2_3D{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
            end
        end
        
        for m_inx = 1: length(models)
            figure(10+m_inx);set(figure(10+m_inx),'name',['Comparison of R_Squared between 3D & 1D models', models{m_inx},'   model'],'unit','normalized' ,'pos',[-0.5 -0.52 0.45 1.4]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.1,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    h{1} = plot([1 2],[R2_plot_3D{pp}{jj}(:,m_inx),R2_plot_1D{pp}{jj}(:,m_inx)],'ko-');
                    median3D = median(R2_plot_3D{pp}{jj}(:,m_inx));
                    median1D = median(R2_plot_1D{pp}{jj}(:,m_inx));
                    plot(0.5,median3D,'g*',2.5,median1D,'g*');
                    [hh,p] = ttest(R2_plot_3D{pp}{jj}(:,m_inx),R2_plot_1D{pp}{jj}(:,m_inx));
                    title(['p = ', num2str(p)]);
                    xlabel('3D     vs     1D');ylabel('R^2');axis on;
                    set(gca,'xlim',[0 3],'xtick',[]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0.1,'Visual','rotation',90);text(0,0.8,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.95 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Comparison of R^2 between 3D & 1D (',models{m_inx},'  model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
    end

    function f4p2(debug)      % Weight ratio (V/A) comparison between 3D & 1D models
        if debug  ; dbstack;   keyboard;      end
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Comparison of R_Squared between 3D & 1D VA models','unit','normalized' ,'pos',[-0.5 -0.52 0.45 1.4]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.1,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    RatioVA_VA_3D{pp}{jj} = log(wV_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj)./wA_VA_3D{pp}(select_temporalSig{pp}(:,jj),jj));
                    RatioVA_VA_1D{pp}{jj} = log(wV_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj)./wA_VA_1D{pp}(select_temporalSig{pp}(:,jj),jj));
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    h{1} = plot([1 2],[RatioVA_VA_3D{pp}{jj},RatioVA_VA_1D{pp}{jj}],'ko-');
                    median3D = median(RatioVA_VA_3D{pp}{jj});
                    median1D = median(RatioVA_VA_1D{pp}{jj});
                    plot(0.5,median3D,'g*',2.5,median1D,'g*');
                    [hh,p] = ttest(RatioVA_VA_3D{pp}{jj},RatioVA_VA_1D{pp}{jj});
                    title(['p = ', num2str(p)]);
                    xlabel('3D     vs     1D');ylabel('Weight ratio (V/A)');axis on;
                    set(gca,'xlim',[0 3],'xtick',[]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0.1,'Visual','rotation',90);text(0,0.8,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.95 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Comparison of weight ratio (V/A) between 3D & 1D VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Comparison of R_Squared between 3D & 1D VAJ models','unit','normalized' ,'pos',[-0.5 -0.52 0.45 1.4]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.1,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAJ_3D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    temp(:,1) = wV_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAJ_1D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    h{1} = plot([1 2],[RatioVA_VAJ_3D{pp}{jj},RatioVA_VAJ_1D{pp}{jj}],'ko-');
                    median3D = median(RatioVA_VAJ_3D{pp}{jj});
                    median1D = median(RatioVA_VAJ_1D{pp}{jj});
                    plot(0.5,median3D,'g*',2.5,median1D,'g*');
                    [hh,p] = ttest(RatioVA_VAJ_3D{pp}{jj},RatioVA_VAJ_1D{pp}{jj});
                    title(['p = ', num2str(p)]);
                    xlabel('3D     vs     1D');ylabel('Weight ratio (V/A)');axis on;
                    set(gca,'xlim',[0 3],'xtick',[]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0.1,'Visual','rotation',90);text(0,0.8,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.95 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Comparison of weight ratio (V/A) between 3D & 1D VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Comparison of R_Squared between 3D & 1D VAP models','unit','normalized' ,'pos',[-0.5 -0.52 0.45 1.4]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.1,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAP_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAP_3D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    temp(:,1) = wV_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAP_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAP_1D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    h{1} = plot([1 2],[RatioVA_VAP_3D{pp}{jj},RatioVA_VAP_1D{pp}{jj}],'ko-');
                    median3D = median(RatioVA_VAP_3D{pp}{jj});
                    median1D = median(RatioVA_VAP_1D{pp}{jj});
                    plot(0.5,median3D,'g*',2.5,median1D,'g*');
                    [hh,p] = ttest(RatioVA_VAP_3D{pp}{jj},RatioVA_VAP_1D{pp}{jj});
                    title(['p = ', num2str(p)]);
                    xlabel('3D     vs     1D');ylabel('Weight ratio (V/A)');axis on;
                    set(gca,'xlim',[0 3],'xtick',[]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0.1,'Visual','rotation',90);text(0,0.8,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.95 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Comparison of weight ratio (V/A) between 3D & 1D VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Comparison of R_Squared between 3D & 1D PVAJ models','unit','normalized' ,'pos',[-0.5 -0.52 0.45 1.4]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.1,[0.2 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_PVAJ_3D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_PVAJ_3D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    temp(:,1) = wV_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_PVAJ_1D{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_PVAJ_1D{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    h{1} = plot([1 2],[RatioVA_PVAJ_3D{pp}{jj},RatioVA_PVAJ_1D{pp}{jj}],'ko-');
                    median3D = median(RatioVA_PVAJ_3D{pp}{jj});
                    median1D = median(RatioVA_PVAJ_1D{pp}{jj});
                    plot(0.5,median3D,'g*',2.5,median1D,'g*');
                    [hh,p] = ttest(RatioVA_PVAJ_3D{pp}{jj},RatioVA_PVAJ_1D{pp}{jj});
                    title(['p = ', num2str(p)]);
                    xlabel('3D     vs     1D');ylabel('Weight ratio (V/A)');axis on;
                    set(gca,'xlim',[0 3],'xtick',[]);
                end
            end
            % text necessary infos
            axes('pos',[0.05 0.2 0.1 0.7]);
            text(0,0.1,'Visual','rotation',90);text(0,0.8,'Vestibular','rotation',90);
            axis off;
            axes('pos',[0.2 0.95 0.7 0.1]);
            text(0.15,0,'Translation');text(0.85,0,'Rotation');
            axis off;
            suptitle(['Comparison of weight ratio (V/A) between 3D & 1D PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
    end


    function Show_individual_cell(~,~,h_line, select_for_this, couples)    % Show individual cell selected from the figure. @HH20150424
        
        if nargin < 5
            couples = 1; % HH20150515 Show coupled cells in the figure
        end
        
        h_marker = guidata(gcbo);
        
        allX = get(h_line,'xData');
        allY = get(h_line,'yData');
        n_single_group = length(allX)/couples;
        
        % ------- Recover the cell number -------
        
        if ismember('control',get(gcf,'currentModifier'))  % Select cell from file name and show in the figure. @HH20150527
            fileN = input('Which cell do you want from the figure?    ','s');
            available_cells = find(select_for_this);
            
            if fileN(1) == '#'  % HH20160905. Direct input the original cell #
                ori_cell_no = str2double(fileN(2:end));
                ind = sum(select_for_this(1:ori_cell_no));
            else
                
                nn = 1; iffind = [];
                while nn <= length(available_cells) && isempty(iffind) % Find the first match
                    iffind = strfind(group_result(available_cells(nn)).cellID{1}{1},fileN);
                    nn = nn + 1;
                end
                
                if ~isempty(iffind)
                    ind = nn - 1;
                else
                    fprintf('Are you kidding...?\n');
                    return
                end
                
                ori_cell_no = find(cumsum(select_for_this)==ind,1);
            end
        else   % Select cell from figure
            pos = get(gca,'currentPoint'); posX = pos(1,1); posY = pos(1,2);
            [min_dis,ind] = min(abs(((posX-allX)/range(xlim)).^2+((posY-allY)/range(ylim)).^2));
            if min_dis > (range(xlim)^2+range(ylim)^2)/100 +inf ; return; end
            
            ind = mod(ind-1,n_single_group) + 1; % Deal with coupled cells
            ori_cell_no = find(cumsum(select_for_this)==ind,1);
        end
        
        % Plotting
        if ~isempty(h_marker) ; try delete(h_marker); catch ; end ;end
        
        all_inds = mod(1:length(allX),n_single_group) == mod(ind,n_single_group); % Deal with coupled cells
        h_marker = plot(allX(all_inds),allY(all_inds),'x','color','m','markersize',15,'linew',3);
        
        % Do plot
        Plot_HD([],[],ori_cell_no);
        
        guidata(gcbo,h_marker);
    end



%}
















end