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
'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_T','3DT';
'Z:\Data\TEMPO\BATCH\20181008_3DModel_Out-Sync_PCC_m6_m5','PSTH_R','3DR';
'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6_m5','PSTH_T','3DT_dark';
'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6_m5','PSTH_R','3DR_dark';
% 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_Dark_PCC_m6_m5','PSTH_T','3DT_dark';
% 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_Dark_PCC_m6_m5','PSTH_R','3DR_dark';
};

mask_all = {
    strcmp(txt(:,header.Protocol),'3DT') & ~strcmp(txt(:,header.Dark),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    strcmp(txt(:,header.Protocol),'3DT') & strcmp(txt(:,header.Dark),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    strcmp(txt(:,header.Protocol),'3DR') & strcmp(txt(:,header.Dark),'1')...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    
    }; % Now no constraint on monkeys

% Add flexible monkey mask here (but I've still decided to choose monkey for analysis below). HH20150723
monkey_included_for_loading = [6 5];
Monkeys{5} = 'Polo';
Monkeys{6} = 'QQ';

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
                            
                            
                            %                             if strcmp('3DT',xls_txt{pp}(file_i(ii),header.Protocol)) && ~strcmp('1',xls_txt{pp}(file_i(ii),header.Dark)) % 3DT
                            %                                 group_result(major_i).(['mat_raw_' mat_address{pp,2}])(ii) = raw.result;  % Dynamic structure
                            %                             elseif strcmp('3DR',xls_txt{pp}(file_i(ii),header.Protocol)) && ~strcmp('1',xls_txt{pp}(file_i(ii),header.Dark))% 3DR
                            %                                 group_result(major_i).(['mat_raw_' mat_address{pp,2}])(ii) = raw.result;  % Dynamic structure
                            %                             elseif strcmp('3DT',xls_txt{pp}(file_i(ii),header.Protocol)) && strcmp('1',xls_txt{pp}(file_i(ii),header.Dark))% 3DT,dark
                            %                                 group_result(major_i).(['mat_raw_Dark_' mat_address{pp,2}])(ii) = raw.result;  % Dynamic structure
                            %                             elseif strcmp('3DR',xls_txt{pp}(file_i(ii),header.Protocol)) && strcmp('1',xls_txt{pp}(file_i(ii),header.Dark))% 3DR,dark
                            %                                 group_result(major_i).(['mat_raw_Dark_' mat_address{pp,2}])(ii) = raw.result;  % Dynamic structure
                            %                             end
                            group_result(major_i).('mat_raw'){pp}{ii} = raw.result;  % Dynamic structure
                            
                        end
                    catch
                        fprintf('Error Loading %s\n',[mat_file_name '_' mat_address{pp,3}]);
                        keyboard;
                    end
                    %{
                 else
                    %                     if ~strcmp('1',xls_txt{pp}(file_i,header.Dark))
                    %                         group_result(major_i).(['mat_raw_' mat_address{pp,2}]) = [];
                    %                     elseif strcmp('1',xls_txt{pp}(file_i,header.Dark))% dark
                    %                         group_result(major_i).(['mat_raw_Dark' mat_address{pp,2}]) = [];
                    %                     end
                    %}
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
models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};

for i = 1:length(group_result)
    for pp = 1:size(mat_address,1)
        if isempty(group_result(i).mat_raw{pp}) % no this protocol for this cell
            group_result(i).uStimType{pp} = [];
            group_result(i).pANOVA{pp} = [];
            group_result(i).preDir{pp} = [];
            group_result(i).DDI{pp} = [];
            group_result(i).meanSpon{pp} = [];
            group_result(i).responSig{pp} = [];
            group_result(i).PSTH{pp} = [];
            group_result(i).Rextre{pp} =[];
            group_result(i).PSTH3Dmodel{pp}{ii} = [];
        else
            for ii = 1:length(group_result(i).mat_raw{pp}) % >= one files for this protocol
                
                group_result(i).uStimType{pp}{ii} = group_result(i).mat_raw{pp}{ii}.unique_stimType;
                group_result(i).pANOVA{pp}{ii} = group_result(i).mat_raw{pp}{ii}.p_anova_dire;
                group_result(i).preDir{pp}{ii} = group_result(i).mat_raw{pp}{ii}.preferDire;
                group_result(i).DDI{pp}{ii} = group_result(i).mat_raw{pp}{ii}.DDI;
                group_result(i).meanSpon{pp}{ii} = group_result(i).mat_raw{pp}{ii}.meanSpon;
                group_result(i).responSig{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.respon_sigTrue;
                %                 group_result(i).PSTH{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.spk_data_bin_mean_rate_aov_cell;
                group_result(i).Rextre{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH.maxSpkRealBinMean-group_result(i).mat_raw{pp}{ii}.PSTH.minSpkRealBinMean;
                group_result(i).PSTH3Dmodel{pp}{ii} = group_result(i).mat_raw{pp}{ii}.PSTH3Dmodel;
                
                
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
% initialize with NaN

for pp = 1:size(mat_address,1)
    % independent on stim types
    meanSpon{pp} = NaN(size(cell_true,1),1);
    uStimType{pp} = zeros(size(cell_true,1),3);
    % dependent on stim types
    PSTH3Dmodel{pp} = cell(size(cell_true,1),length(stimType));
    pANOVA{pp} = NaN(size(cell_true,1),length(stimType));
    DDI{pp} = NaN(size(cell_true,1),length(stimType));
    responSig{pp} = NaN(size(cell_true,1),length(stimType));
    Rextre{pp} = NaN(size(cell_true,1),length(stimType));
    pANOVA{pp} = NaN(size(cell_true,1),length(stimType));
    
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
                    preDir{pp}{jj}(i,:) = group_result(i).preDir{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    DDI{pp}(i,jj) = group_result(i).DDI{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    responSig{pp}(i,jj) = group_result(i).responSig{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    %                     PSTH{pp}{jj}(i,:) = group_result(i).PSTH{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)};
                    Rextre{pp}(i,jj) = group_result(i).Rextre{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    PSTH3Dmodel{pp}{i,jj} = group_result(i).PSTH3Dmodel{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                end
            end
        end
    end
    uStimType{pp}(:,3) = (uStimType{pp}(:,1)) & (uStimType{pp}(:,2));
end

for pp = 1:size(mat_address,1)
    wV_VA{pp} = nan(length(group_result),2);wA_VA{pp} = nan(length(group_result),2);
    wV_VAJ{pp} = nan(length(group_result),2);wA_VAJ{pp} = nan(length(group_result),2);wJ_VAJ{pp} = nan(length(group_result),2);
    wV_VAP{pp} = nan(length(group_result),2);wA_VAP{pp} = nan(length(group_result),2);wP_VAP{pp} = nan(length(group_result),2);
    wV_PVAJ{pp} = nan(length(group_result),2);wA_PVAJ{pp} = nan(length(group_result),2);wJ_PVAJ{pp} = nan(length(group_result),2);wP_PVAJ{pp} = nan(length(group_result),2);
    
    parR2V_VA{pp} = nan(length(group_result),2);parR2A_VA{pp} = nan(length(group_result),2);
    parR2V_VAJ{pp} = nan(length(group_result),2);parR2A_VAJ{pp} = nan(length(group_result),2);parR2J_VAJ{pp} = nan(length(group_result),2);
    parR2V_VAP{pp} = nan(length(group_result),2);parR2A_VAP{pp} = nan(length(group_result),2);parR2P_VAP{pp} = nan(length(group_result),2);
    
    angleDiff_VA_VA{pp} = nan(length(group_result),2);
    
    
    for jj = 1:length(stimType)
        R2{pp}{jj} = nan(length(group_result),length(models));
        BIC{pp}{jj} = nan(length(group_result),length(models));
        Para{pp}{jj} = cell(length(group_result),length(models));
        
        preDir_V_VA{pp}{jj} = nan(length(group_result),3);preDir_A_VA{pp}{jj} = nan(length(group_result),3);
        
        for i = 1:length(group_result)
            if responSig{pp}(i,jj) == 1
                for m_inx = 1:length(models)
                    temp = isfield(PSTH3Dmodel{pp}{i,jj}{1},{['RSquared_',models{m_inx}],['BIC_',models{m_inx}],['modelFitPara_',models{m_inx}]});
                    if temp(1) == 1
                        % pack R_squared values to group_result.R2.*(* the model)
                        eval(['R2{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.RSquared_', models{m_inx}, ';']);
                        % R2{pp}{jj}(i,m_inx) = PSTH3Dmodel{pp}{i,jj}{1}.RSquared_VO;
                        
                    end
                    if temp(2) == 1
                        % pack BIC values to group_result.BIC.*(* the model)
                        eval(['BIC{',num2str(pp),'}{',num2str(jj),'}(',num2str(i),',',num2str(m_inx),') = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.BIC_', models{m_inx}, ';']);
                        % BIC{pp}{jj}(i,m_inx) = PSTH3Dmodel{pp}{i,jj}{1}.BIC_VO;
                        
                    end
                    if temp(3) == 1
                        % pack model fitting parameters to group_result.Para*.(* the model)
                        eval(['Para{',num2str(pp),'}{',num2str(jj),'}{',num2str(i),',',num2str(m_inx),'} = PSTH3Dmodel{',num2str(pp),'}{',num2str(i),',',num2str(jj),'}{1}.modelFitPara_', models{m_inx}, ';']);
                        % Para{pp}{jj}{i,m_inx} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitPara_VO;
                        
                    end
                    
                end
                
                if sum(strcmp(models,'VA'))
                    wV_VA{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_wV;
                    wA_VA{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_wA;
                    if sum(ismember(models,'AO')) && sum(ismember(models,'VO'))
                        parR2V_VA{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_R2V;
                        parR2A_VA{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VA_R2A;
                    end
                    spatial_VA{pp}{jj}.V{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.V;
                    spatial_VA{pp}{jj}.V{i}([1 5],2:end) = 0;
                    spatial_VA{pp}{jj}.A{i} = PSTH3Dmodel{pp}{i,jj}{1}.modelFitTrans_spatial_VA.A;
                    spatial_VA{pp}{jj}.A{i}([1 5],2:end) = 0;
                    [preDir_V_VA{pp}{jj}(i,1),preDir_V_VA{pp}{jj}(i,2),preDir_V_VA{pp}{jj}(i,3)] = vectorsum(spatial_VA{pp}{jj}.V{i});
                    [preDir_A_VA{pp}{jj}(i,1),preDir_A_VA{pp}{jj}(i,2),preDir_A_VA{pp}{jj}(i,3)] = vectorsum(spatial_VA{pp}{jj}.A{i});
                    angleDiff_VA_VA{pp}(i,jj) = angleDiff(preDir_V_VA{pp}{jj}(i,1),preDir_V_VA{pp}{jj}(i,2),preDir_V_VA{pp}{jj}(i,3),preDir_A_VA{pp}{jj}(i,1),preDir_A_VA{pp}{jj}(i,2),preDir_A_VA{pp}{jj}(i,3));
                end
                
                if sum(strcmp(models,'VAJ'))
                    wV_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wV;
                    wA_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wA;
                    wJ_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_wJ;
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VJ')) && sum(ismember(models,'AJ'))
                        parR2V_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2V;
                        parR2A_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2A;
                        parR2J_VAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAJ_R2J;
                    end
                end
                
                if sum(strcmp(models,'VAP'))
                    wV_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wV;
                    wA_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wA;
                    wP_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_wP;
                    if sum(ismember(models,'VA')) && sum(ismember(models,'VP')) && sum(ismember(models,'AP'))
                        parR2V_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2V;
                        parR2A_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2A;
                        parR2P_VAP{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.VAP_R2P;
                    end
                end
                
                if sum(strcmp(models,'PVAJ'))
                    wV_PVAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wV;
                    wA_PVAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wA;
                    wJ_PVAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wJ;
                    wP_PVAJ{pp}(i,jj) = PSTH3Dmodel{pp}{i,jj}{1}.PVAJ_wP;
                    
                end
            end
            
        end
    end
end

% Classify cells

for pp = 1:size(mat_address,1)
    
    % cells classified according to temporal response
    temporalSig_i{pp}(:,1) = responSig{pp}(:,1) == 1;
    temporalSig_i{pp}(:,2) = responSig{pp}(:,2) == 1;
    temporalSig_i{pp}(:,3) = temporalSig_i{pp}(:,1) & temporalSig_i{pp}(:,2);
    
    % cells classified according to spatial & temporal response (ANOVA)
    spatialSig_i{pp}(:,1) = (pANOVA{pp}(:,1) <= 0.05) & responSig{pp}(:,1) == 1;
    spatialSig_i{pp}(:,2) = (pANOVA{pp}(:,2) <= 0.05) & responSig{pp}(:,2) == 1;
    spatialSig_i{pp}(:,3) = spatialSig_i{pp}(:,1) & spatialSig_i{pp}(:,2);
    
end

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
            'Cells are temporally tunned ',temporalSig_i;
            
            % spatially based
            'Cells are spatially tunned t',spatialSig_i;
            
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

%{
GM = -1;    % Gray matter without visual modulation
PCC = -2;
RSC = -3;
IPS = -4;
B3a = -5;

drawmapping_data = { % Monkey_hemi    % Grid No. of (AP0,Middle)   % Data
    'Qiaoqiao_L',[14,0];
    'Qiaoqiao_R',[14,0]
    'Polo_R',[18,0]};

%  QQ_left
drawmapping_data{1,3} = {
    %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
    % When you are not sure about one area, use "AreaType-100" instead
    {68,[15,6],[2.5 0],[PCC 26.4 33;PCC 47 57;]};
    {69,[15,4],[2.25 0],[PCC 48 59;PCC 66 85;]};
    {69,[16,5],[2.5 0],[PCC 26 60;]};
    {70,[21,6],[2.2 0],[PCC 50 61;PCC 86 108;]};
    {71,[18,6],[2.3 0],[PCC 51 61;PCC 72.5 88;]};
    {72,[17,4],[2.3 0],[PCC 50 60;PCC 65 75;]};
    {72,[18,4],[2.3 0],[PCC 48.5 60;PCC 70 82;]};
    {73,[19,4],[2.3 0],[PCC 50 83;]};
    {73,[20,4],[2.3 0],[B3a 11 40;PCC 68 80;PCC 90 100;]};
    {74,[17,5],[2.3 0],[GM 22 30;PCC 61 78;PCC 85 90;]};
    {75,[18,5],[2.4 0],[PCC 56 70;PCC 82 90;]};
    {76,[17,3],[2.3 0],[PCC 48 61;PCC 68.6 76.3;]};
    {77,[18,3],[2.3 0],[GM 10.7 20;PCC 54 65;PCC 72 83;]};
    {78,[16,4],[2.4 0],[PCC 38 48;PCC 62 75;]};
    {79,[18,7],[2.4 0],[PCC 47 54;PCC 68 78;]};
    {80,[15,5],[2.4 0],[GM 11 27;PCC 41 51;PCC 59 68;]};
    {81,[16,7],[2.4 0],[GM 9 28;PCC 40 65;]};
    {82,[15,3],[2.4 0],[GM 10 27;PCC 38 72;]};
    {83,[15,7],[2.4 0],[GM 7.3 23;PCC 38 49;IPS 77 80;]};
    {83,[19,3],[2.4 0],[PCC 40 51;PCC 57 60;]};
    {84,[20,5],[2.3 0],[GM 0 23;B3a 32 43;PCC 73 86;]};
    {84,[17,2],[2.3 0],[PCC 42 53;PCC 63 71;]};
    {85,[20,3],[2.3 0],[PCC 47 68;]};
    {85,[16,2],[2.4 0],[PCC 20 49;PCC 53 61;]};
    {86,[18,2],[2.3 0],[PCC 52 62;PCC 65 73;]};
    {87,[16,8],[2.4 0],[GM 10 25;PCC 36 52;]};
    {88,[22,6],[2.3 0],[B3a 16 50;PCC 74 130;]};
    {89,[23,5],[2.4 0],[B3a 23 54;PCC 80 88;PCC 99 110;]};
    {89,[22,5],[2.4 0],[B3a 26 40;PCC 67.5 73;]};
    {90,[21,4],[2.4 0],[B3a 33 46;PCC 58 72;]};
    {91,[18,5],[2.4 0],[PCC 48 61;PCC 67 79;]};
    {91,[18,7],[2.5 0],[PCC 38 45;]};
    {93,[17,5],[2.4 0],[GM 10 25.5;PCC 33 50;RSC 95 135;]};
    {93,[17,3],[2.3 0],[GM 12.5 25;PCC 54 67;PCC 71.5 83;]};
    {94,[18,4],[2.4 0],[PCC 53 84;]};
    {94,[19,5],[2.4 0],[PCC 56 84;]};
    {95,[16,5],[2.4 0],[PCC 41 85;]};
    {96,[16,3],[2.5 0],[PCC 40 59;GM 63 86;]};
    {96,[17,6],[2.4 0],[PCC 52 53;]};
    {97,[18,8],[2.5 0],[GM 6 26;PCC 44 65;]};
    {97,[18,9],[2.5 0],[GM 8 13;GM 22 27;PCC 38 47;]};
    {98,[17,8],[2.5 0],[GM 15 24;PCC 32 60;]};
    {99,[15,8],[2.55 0],[GM 6 10;PCC 38 45;IPS 63 85;]};
    {99,[15,9],[2.55 0],[PCC 12 25;PCC 32 50;IPS 62 95;]};
    {100,[15,10],[2.55 0],[GM 0 8;IPS 59 68;IPS 76 87;]};
    {101,[16,9],[2.55 0],[GM 5 27;PCC 30 50;]};
    {101,[16,10],[2.55 0],[GM 0 16;PCC 30 35;]};
    {102,[15,11],[2.55 0],[IPS 52 72;IPS 78 85;]};
    {102,[14,6],[2.55 0],[PCC 5 11;PCC 34 51;]};
    {102,[14,8],[2.5 0],[PCC 29 53;]};
    {103,[14,5],[2.4 0],[PCC 12 25;PCC 36 39;]};
    {104,[14,4],[2.4 0],[PCC 20 31;PCC 45 48;PCC 70 80;]};
    {105,[19,5],[2.55 0],[PCC 49 73;]};
    {105,[19,7],[2.55 0],[PCC 55 73;]};
    {106,[19,10],[2.55 0],[GM 15 46;PCC 61 73;]};
    
    
    }';

%  QQ_right
drawmapping_data{2,3} = {
    %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
    % When you are not sure about one area, use "AreaType-100" instead
    %             {1,[21,5],[1.8 0],[GM 34 71.13;]};
    {2,[21,4],[1.75 0],[GM 0 4.5;]};
    %             {3,[22,6],[2.0 0],[GM 7 31; GM 33 40;GM 42 52.57]};
    {4,[21,3],[2.0 0],[B3a 18 35; PCC 65 90;]};
    %             {5,[22,4],[2.0 0],[GM 0 35; GM 43 52;GM 62 86;GM 92.69 109.5;]};
    {6,[23,6],[2.0 0],[B3a 57.88 59.5; PCC 62 64.5;PCC 87 110]};
    {7,[24,6],[2.0 0],[B3a 5.82 56.5; PCC 80 85.6;PCC 89 89.3]};
    {8,[24,8],[2.0 0],[B3a 24.22 62.86;]};
    {8,[25,6],[2.0 0],[GM 8 21.6;]};
    {9,[25,8],[2.0 0],[GM 6 24; GM 46.8 64;]};
    {10,[20,6],[1.9 0],[B3a 0 39.77; B3a 49 53; GM 59 60; PCC 75.8 113;]};
    {11,[20,10],[2.0 0],[B3a 16 54; PCC 90 97;]};
    {12,[26,6],[2.0 0],[GM 15 45;]};
    {13,[26,4],[1.9 0],[GM 0 23;GM 36.22 40;PCC 63.55 72.13;]};
    {14,[20,2],[2.0 0],[GM 19.65 40;PCC 47 52.55;]};
    {15,[19,6],[2.0 0],[B3a 10 21.54;B3a 26.3 39.63;PCC 44 64.31;]};
    {16,[18,6],[2.0 0],[PCC 41.98 65;]};
    {17,[17,6],[2.0 0],[PCC 27.47 39;PCC 50.38 58.69;]};
    {18,[16,6],[2.0 0],[PCC 33.5 36.71;]};
    {19,[19,3],[2.0 0],[B3a 11.65 36;]};
    {20,[18,2],[2.0 0],[GM 16.53 53.79;]};
    {21,[17,2],[1.8 0],[PCC 69.58 74.25;]};
    {22,[25,10],[1.8 0],[GM 65 112.9;]};
    {23,[22,2],[1.75 0],[GM 37.5 97.8;]};
    {24,[20,4],[1.9 0],[B3a 12 48;]};
    {25,[20,3],[1.9 0],[B3a 14 60;PCC 60 130;]};
    {26,[20,7],[1.9 0],[B3a 13 31;PCC 60 79;]};
    {27,[21,7],[1.8 0],[B3a 30 45;PCC 105 127;]};
    {28,[22,3],[1.8 0],[B3a 17.7 41;PCC 72 92;PCC 100 120;RSC 135.4 150;]};
    {29,[22,5],[1.8 0],[B3a 42 63;PCC 100 116.5;]};
    {30,[22,4],[1.9 0],[B3a 15 61;PCC 89 112.6;PCC 121.3 136;]};
    {31,[22,6],[1.8 0],[B3a 25 46;PCC 73 88;PCC 108 137;]};
    {32,[23,5],[1.9 0],[B3a 17 56.5;PCC 86 108;PCC 115 130;]};
    {33,[23,6],[1.8 0],[B3a 20 45;PCC 111 135;]};
    {34,[23,7],[1.9 0],[B3a 47 63.6;PCC 122 147.3;]};
    {35,[24,4],[1.8 0],[PCC 92 115;PCC 124 141;]};
    {35,[24,3],[1.8 0],[PCC 85 100;]};
    {36,[19,4],[1.8 0],[PCC 69 90;]};
    {37,[19,7],[1.75 0],[PCC 84 127;]};
    {38,[21,2],[1.8 0],[PCC 72.7 90;PCC 96 110;RSC 138.5 153;]};
    {39,[24,6],[1.9 0],[B3a 53 65;PCC 100 122;]};
    {39,[22,1],[1.8 0],[GM 15 34;GM 55.5 65;GM 72 75;RSC 115 150; RSC 150 170;]};
    {40,[20,1],[2.05 0],[PCC 43 64;PCC 70 87;RSC 110 148;]};
    {45,[21,6],[2.3 0],[PCC 18 50;PCC 82 94;RSC 97 134;]};
    {46,[21,4],[2.3 0],[B3a 7 28;PCC 70.5 87;RSC 92 126;]};
    {47,[20,5],[2.2 0],[B3a 21 50;PCC 82 90;PCC 91.5 95.5;]};
    {48,[22,4],[2.2 0],[PCC 65 76;PCC 82 94;]};
    {49,[22,5],[2.2 0],[B3a 20 40;PCC 73 110;]};
    {50,[22,7],[2.2 0],[B3a 3 20;B3a 29 43;PCC 79 93;PCC 98 103.5;]};
    {51,[23,5],[2.1 0],[B3a 25 36;PCC 73 90;PCC 99 112;]};
    {51,[23,6],[2.1 0],[B3a 12 48;PCC 85 110;]};
    {52,[23,7],[2.1 0],[B3a 3.5 20;B3a 38 48;PCC 91 125.6;]};
    {53,[24,3],[2.1 0],[GM 3.7 21;PCC 66 110;]};
    {54,[19,5],[2.1 0],[PCC 47 68;]};
    {55,[19,6],[2.1 0],[PCC 61 80;]};
    {56,[19,7],[2.1 0],[PCC 62 78;PCC 84 94;]};
    {56,[19,4],[2.1 0],[B3a 16 26;PCC 63 68;]};
    {57,[20,5],[2.1 0],[B3a 6 19;PCC 73 86;PCC 91 102;]};
    {58,[20,6],[2.1 0],[PCC 66.6 76;PCC 86 98;]};
    {59,[20,7],[2.1 0],[B3a 4.5 13;PCC 67 105;]};
    {60,[21,5],[2.1 0],[PCC 65 79;PCC 84 96;]};
    {61,[21,8],[2.15 0],[B3a 13.5 26.5;PCC 65 80;PCC 86 96;]};
    {62,[23,6],[2.1 0],[B3a 9 23;PCC 60 65;]};
    {63,[23,7],[2.1 0],[B3a 41 54;PCC 95 105;PCC 114 119;]};
    {64,[23,4],[2.1 0],[PCC 83 110;]};
    {64,[24,6],[2.1 0],[B3a 9 38;PCC 80 93;PCC 97.7 110;]};
    {65,[24,7],[2.1 0],[B3a 10 25;PCC 76 91;PCC 97 110;]};
    {66,[25,5],[2.1 0],[GM 12 25;PCC 85 99;PCC 108 118;]};
    {67,[25,4],[2.1 0],[GM 9 15;PCC 75 88;PCC 93 108;]};
    
    
    }';


%  Polo_right
drawmapping_data{3,3} = {
    %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
    % When you are not sure about one area, use "AreaType-100" instead
    {107,[8,6],[2.4 0],[PCC 48 67]}
    {108,[9,5],[2.25 0],[GM 33.5 44;PCC 68 80;PCC 115 131]}
    {109,[10,6],[2.25 0],[GM 37 56;PCC 69 75]}
    {110,[11,5],[2.25 0],[GM 3.6 19;GM 36 56;PCC 63 115]}
    {111,[14,6],[2.25 0],[GM 9.5 23;GM 33 48;PCC 72 94;PCC 103 123]}
    %             {112,[9,5],[2.25 0],[GM 33.5 44;GM 68 80;GM 11500 13100]}
    {113,[22,8],[2.45 0],[B3a 47 58]}
    {114,[20,6],[2.45 0],[GM 10 30;PCC 61 73;]}
    {115,[23,6],[2.55 0],[B3a 6 12;PCC 50 67;PCC 79 96;]}
    {116,[24,8],[2.55 0],[B3a 9 16;PCC 64 85;PCC 94 108;]}
    {117,[25,8],[2.55 0],[B3a 15 34;PCC 63 82;PCC 101 119;]}
    {118,[27,7],[2.35 0],[PCC 57 77;]}
    {118,[25,7],[2.35 0],[B3a 26 39;PCC 78 81;]}
    {119,[23,7],[2.45 0],[B3a 37 52;PCC 76 85;PCC 100 118;]}
    {119,[25,5],[2.45 0],[PCC 22 66;]}
    {120,[26,8],[2.45 0],[GM 63 78;]}
    {121,[24,5],[2.45 0],[B3a 0 15;PCC 65 68;]}
    {122,[26,5],[2.45 0],[GM 9 55;PCC 67 84;PCC 94 110;]}
    {123,[22,7],[2.45 0],[B3a 12 34;PCC 67 80;PCC 110 120;]}
    {124,[24,6],[2.4 0],[PCC 69 83;PCC 107 123;]}
    {125,[25,4],[2.55 0],[PCC 33 73;PCC 82 90;]}
    {126,[22,3],[2.55 0],[PCC 14 42;PCC 47 65;]}
    {127,[23,4],[2.55 0],[PCC 33.5 38;]}
    {128,[26,4],[2.55 0],[PCC 70 90;PCC 103 121;]}
    {129,[27,8],[2.55 0],[PCC 43 57;PCC 111 134;]}
    {130,[27,5],[2.55 0],[PCC 78 105;PCC 131 136;]}
    {131,[27,9],[2.55 0],[GM 17.5 30;PCC 105 129;PCC 139 147;]}
    {131,[28,6],[2.55 0],[PCC 108 136;]}
    {132,[28,4],[2.55 0],[GM 15 26;PCC 75 105;]}
    {133,[28,5],[2.55 0],[PCC 60 81;]}
    {134,[24,6],[2.55 0],[PCC 75 92;PCC 107 128;]}
    {135,[23,5],[2.55 0],[B3a 10 26;PCC 68 81;PCC 97 109;PCC 111 122;]}
    {136,[23,7],[2.55 0],[B3a 11 35;PCC 69 82;PCC 100 115;]}
    {137,[23,6],[2.55 0],[B3a 9 20;]}
    {138,[23,4],[2.65 0],[PCC 11 53;PCC 72 81;]}
    {139,[22,5],[2.55 0],[PCC 105 110;]}
    {139,[21,5],[2.55 0],[B3a 22 40;PCC 77 92;PCC 103 115;]}
    {140,[19,8],[2.65 0],[PCC 10 15;PCC 40 54;IPS 75 95;]}
    {141,[19,5],[2.85 0],[PCC 29 39;PCC 45 68;RSC 130 141;]}
    {142,[18,5],[2.85 0],[PCC 36 49;PCC 60 82;GM 99 148;]}
    {143,[18,7],[2.55 0],[PCC 12 46;PCC 63 77.5;IPS 105 132;]}
    {144,[17,8],[2.65 0],[PCC 12 33;PCC 46 58;]}
    {145,[17,7],[2.65 0],[PCC 9 39;PCC 51 71;RSC 140 156;]}
    {146,[17,5],[2.85 0],[PCC 13 26;PCC 39 46;]}
    {147,[20,5],[2.65 0],[PCC 41 55;PCC 66 81;]}
    {148,[20,9],[2.65 0],[GM 37 49;IPS 69 86;]}
    {149,[22,8],[2.55 0],[B3a 17 28;PCC 60 76;PCC 90 107;]}
    {150,[23,4],[2.65 0],[GM 0 8;PCC 20 56;PCC 63 83;RSC 110 147;]}
    {151,[23,6],[2.65 0],[PCC 45 50;]}
    {152,[25,5],[2.65 0],[PCC 4 54;PCC 66 76;]}
    {153,[25,5],[2.65 0],[PCC 4 54;PCC 66 76;]}
    {155,[24,6],[2.65 0],[PCC 61 79;PCC 97 107;]}
    {156,[20,5],[2.65 0],[PCC 43 54;PCC 65 84;]}
    {157,[25,4],[2.65 0],[PCC 0 47;PCC 61 77;RSC 106 114;]}
    {157,[25,6],[2.65 0],[PCC 35 63;PCC 74 81;]}
    
    
    }';

%}

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
    '    DDI distribution',@f1p2p1;
    '    Preferred direction distribution',@f1p2p2;
    'Comparisons between T & R',@f1p3;
    '    DDI distribution',@f1p3p1;
    '    Preferred direction distribution',@f1p3p2;
    'Dark control',@f1p4;
    '    Preferred direction distribution',@f1p4p1;
    '    Rmax-Rmin',@f1p4p2;
    '    DDI distribution',@f1p4p3;
    'Spontaneous FR',@f1p5;
    };
    
    'Temporal-spatial models', {
    'model fitting evaluation', @f2p1;
    '    BIC distribution across models', @f2p1p1;
    '    R_squared distribution across models', @f2p1p2;
    'Parameter analysis',@f2p2;
    '    Weight ratio (V/A) distribution', @f2p2p1;
    '    Weight distribution', @f2p2p5;
    '    Partial R_squared distribution', @f2p2p4;
    '    Preferred direction & angle difference distribution ( V vs. A)', @f2p2p2;
    '    time delay distribution ( V/A, P/V, P/A)', @f2p2p3;
    'check',@f2p3;
    '    Weight ratio (V/A) distribution', @f2p3p1;
    
    };
    
    'Others',{
    'Cell Counter',@f5p1;
    'Test',@f5p9;
    };
    
    'NoShow',{@cell_selection};
    
    };

%{
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
nHist = [];
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
        Disp('Not written yet..')
        %{
        timeStep = 25;
        tOffset1 = 100;
        stimOnBin = floor(tOffset1/timeStep)+1;
        % classify cells into single-peaked, double-peaked, triple-peaked, no-peak and others
        
        T_vesti_NPeakInx = logical(cat(1,T.vestiNoDSPeaks) == 0) & logical(T_vestiResponSig == 1);
        T_vesti_SPeakInx = find(cat(1,T.vestiNoDSPeaks) == 1);
        T_vesti_DPeakInx = find(cat(1,T.vestiNoDSPeaks) == 2);
        T_vesti_TPeakInx = find(cat(1,T.vestiNoDSPeaks) == 3);
        
        T_vis_NPeakInx = logical(cat(1,T.visNoDSPeaks) == 0) & logical(T_visResponSig == 1);
        T_vis_SPeakInx = find(cat(1,T.visNoDSPeaks) == 1);
        T_vis_DPeakInx = find(cat(1,T.visNoDSPeaks) == 2);
        T_vis_TPeakInx = find(cat(1,T.visNoDSPeaks) == 3);
        
        R_vesti_NPeakInx = logical(cat(1,R.vestiNoDSPeaks) == 0) & logical(R_vestiResponSig == 1);
        R_vesti_SPeakInx = find(cat(1,R.vestiNoDSPeaks) == 1);
        R_vesti_DPeakInx = find(cat(1,R.vestiNoDSPeaks) == 2);
        R_vesti_TPeakInx = find(cat(1,R.vestiNoDSPeaks) == 3);
        
        R_vis_NPeakInx = logical(cat(1,R.visNoDSPeaks) == 0) & logical(R_visResponSig == 1);
        R_vis_SPeakInx = find(cat(1,R.visNoDSPeaks) == 1);
        R_vis_DPeakInx = find(cat(1,R.visNoDSPeaks) == 2);
        R_vis_TPeakInx = find(cat(1,R.visNoDSPeaks) == 3);
        
        % pack peak data, according to p value (ANOVA)
        % considering specific stim type itself
        % T_vestiTPeakT = repmat(cat(1,T(T_vesti_DPeakInx).vestipeakDS),[],3);
        
        % T_vestiSPeakT = cat(1,T(T_vesti_SPeakInx).vestipeakDS);
        % T_vestiDPeakT = cat(1,T(T_vesti_DPeakInx).vestipeakDS);
        % T_visSPeakT = cat(1,T(T_vis_SPeakInx).vispeakDS);
        % T_visDPeakT = cat(1,T(T_vis_DPeakInx).vispeakDS);
        % T_vestiSPeakTMedian = (median(T_vestiSPeakT) - stimOnBin)*timeStep;
        % T_vestiDPeakT1Median = (median(T_vestiDPeakT(:,1)) - stimOnBin)*timeStep;
        % T_vestiDPeakT2Median = (median(T_vestiDPeakT(:,2)) - stimOnBin)*timeStep;
        % T_visSPeakTMedian = (median(T_visSPeakT) - stimOnBin)*timeStep;
        % T_visDPeakT1Median = (median(T_visDPeakT(:,1)) - stimOnBin)*timeStep;
        % T_visDPeakT2Median = (median(T_visDPeakT(:,2)) - stimOnBin)*timeStep;
        %
        % R_vestiSPeakT = cat(1,R(R_vesti_SPeakInx).vestipeakDS);
        % R_vestiDPeakT = cat(1,R(R_vesti_DPeakInx).vestipeakDS);
        % R_visSPeakT = cat(1,R(R_vis_SPeakInx).vispeakDS);
        % R_visDPeakT = cat(1,R(R_vis_DPeakInx).vispeakDS);
        % R_vestiSPeakTMedian = (median(R_vestiSPeakT) - stimOnBin)*timeStep;
        % R_vestiDPeakT1Median = (median(R_vestiDPeakT(:,1)) - stimOnBin)*timeStep;
        % R_vestiDPeakT2Median = (median(R_vestiDPeakT(:,2)) - stimOnBin)*timeStep;
        % R_visSPeakTMedian = (median(R_visSPeakT) - stimOnBin)*timeStep;
        % R_visDPeakT1Median = (median(R_visDPeakT(:,1)) - stimOnBin)*timeStep;
        % R_visDPeakT2Median = (median(R_visDPeakT(:,2)) - stimOnBin)*timeStep;
        %
        % % pack PSTH data, according to peak
        %
        % T_vestiPSTHSPeak = T_vestiPSTH(T_vesti_SPeakInx,:);
        % T_vestiPSTHDPeak = T_vestiPSTH(T_vesti_DPeakInx,:);
        % T_visPSTHSPeak = T_visPSTH(T_vis_SPeakInx,:);
        % T_visPSTHDPeak = T_visPSTH(T_vis_DPeakInx,:);
        % R_vestiPSTHSPeak = R_vestiPSTH(R_vesti_SPeakInx,:);
        % R_vestiPSTHDPeak = R_vestiPSTH(R_vesti_DPeakInx,:);
        % R_visPSTHSPeak = R_visPSTH(R_vis_SPeakInx,:);
        % R_visPSTHDPeak = R_visPSTH(R_vis_DPeakInx,:);
        
        
        % plot figures for peak time distribution
        
        %%%%%%%%%%%%%%%%%%%%%%%% Peak time distribution   %%%%%%%%%%%%%%%%%%%%%%%%%
        
        T_vestiSPeakT_plot = (T_vestiSPeakT - stimOnBin)*timeStep;
        T_visSPeakT_plot = (T_visSPeakT - stimOnBin)*timeStep;
        T_vestiDPeakT_plot = (T_vestiDPeakT - stimOnBin)*timeStep;
        T_visDPeakT_plot = (T_visDPeakT - stimOnBin)*timeStep;
        R_vestiSPeakT_plot = (R_vestiSPeakT - stimOnBin)*timeStep;
        R_visSPeakT_plot = (R_visSPeakT - stimOnBin)*timeStep;
        R_vestiDPeakT_plot = (R_vestiDPeakT - stimOnBin)*timeStep;
        R_visDPeakT_plot = (R_visDPeakT - stimOnBin)*timeStep;
        
        
        xPeakT = linspace(0,1500,16);
        
        figure(104);set(gcf,'pos',[60 20 1200 1000]);clf;
        [~,h_subplot] = tight_subplot(7,3,[0.04 0.1],0.1);
        
        
        axes(h_subplot(1));
        text(0.8,-3,'Translation','Fontsize',26,'rotation',90);
        text(0.8,-8.6,'Rotation','Fontsize',25,'rotation',90);
        axis off;
        
        %%%% Translation
        % for Vestibular
        % Single-peaked time
        axes(h_subplot(2));
        hold on;
        [nelements, ncenters] = hist(T_vestiSPeakT_plot,xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiSPeakT_plot))]);
        plot(T_vestiSPeakTMedian,max(nelements)*1.1,'kv');
        text(T_vestiSPeakTMedian*1.1,max(nelements)*1.2,num2str(T_vestiSPeakTMedian/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Single-peaked');
        axis on;
        hold off;
        
        % Double-peaked time
        axes(h_subplot(5));
        hold on;
        [nelements, ncenters] = hist(T_vestiDPeakT_plot(:,1),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiDPeakT_plot))]);
        plot(T_vestiDPeakT1Median,max(nelements)*1.1,'kv');
        text(T_vestiDPeakT1Median*1.1,max(nelements)*1.2,num2str(T_vestiDPeakT1Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Double-peaked, early');
        axis on;
        hold off;
        
        axes(h_subplot(8));
        hold on;
        [nelements, ncenters] = hist(T_vestiDPeakT_plot(:,2),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_vestiDPeakT_plot))]);
        plot(T_vestiDPeakT2Median,max(nelements)*1.1,'kv');
        text(T_vestiDPeakT2Median*1.1,max(nelements)*1.2,num2str(T_vestiDPeakT2Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
        % xlabel('Double-peaked, late');
        axis on;
        hold off;
        
        %%%% Visual
        % Single-peaked time
        axes(h_subplot(3));
        hold on;
        [nelements, ncenters] = hist(T_visSPeakT_plot,xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visSPeakT_plot))]);
        plot(T_visSPeakTMedian,max(nelements)*1.1,'kv');
        text(T_visSPeakTMedian*1.1,max(nelements)*1.2,num2str(T_visSPeakTMedian/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Single-peaked');
        axis on;
        hold off;
        
        % Double-peaked time
        axes(h_subplot(6));
        hold on;
        [nelements, ncenters] = hist(T_visDPeakT_plot(:,1),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
        plot(T_visDPeakT1Median,max(nelements)*1.1,'kv');
        text(T_visDPeakT1Median*1.1,max(nelements)*1.2,num2str(T_visDPeakT1Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Double-peaked, early');
        axis on;
        hold off;
        
        axes(h_subplot(9));
        hold on;
        [nelements, ncenters] = hist(T_visDPeakT_plot(:,2),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(T_visDPeakT_plot))]);
        plot(T_visDPeakT2Median,max(nelements)*1.1,'kv');
        text(T_visDPeakT2Median*1.1,max(nelements)*1.2,num2str(T_visDPeakT2Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
        % xlabel('Double-peaked, late');
        axis on;
        hold off;
        
        %%%% Rotation
        % for Vestibular
        % Single-peaked time
        axes(h_subplot(14));
        hold on;
        [nelements, ncenters] = hist(R_vestiSPeakT_plot,xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiSPeakT_plot))]);
        plot(R_vestiSPeakTMedian,max(nelements)*1.1,'kv');
        text(R_vestiSPeakTMedian*1.1,max(nelements)*1.2,num2str(R_vestiSPeakTMedian/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Single-peaked');
        axis on;
        hold off;
        
        % Double-peaked time
        axes(h_subplot(17));
        hold on;
        [nelements, ncenters] = hist(R_vestiDPeakT_plot(:,1),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiDPeakT_plot))]);
        plot(R_vestiDPeakT1Median,max(nelements)*1.1,'kv');
        text(R_vestiDPeakT1Median*1.1,max(nelements)*1.2,num2str(R_vestiDPeakT1Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Double-peaked, early');
        axis on;
        hold off;
        
        axes(h_subplot(20));
        hold on;
        [nelements, ncenters] = hist(R_vestiDPeakT_plot(:,2),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_vestiDPeakT_plot))]);
        plot(R_vestiDPeakT2Median,max(nelements)*1.1,'kv');
        text(R_vestiDPeakT2Median*1.1,max(nelements)*1.2,num2str(R_vestiDPeakT2Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
        % xlabel('Double-peaked, late');
        axis on;
        hold off;
        
        %%%% Visual
        % Single-peaked time
        axes(h_subplot(15));
        hold on;
        [nelements, ncenters] = hist(R_visSPeakT_plot,xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visSPeakT_plot))]);
        plot(R_visSPeakTMedian,max(nelements)*1.1,'kv');
        text(R_visSPeakTMedian*1.1,max(nelements)*1.2,num2str(R_visSPeakTMedian/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Single-peaked');
        axis on;
        hold off;
        
        % Double-peaked time
        axes(h_subplot(18));
        hold on;
        [nelements, ncenters] = hist(R_visDPeakT_plot(:,1),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakT_plot))]);
        plot(R_visDPeakT1Median,max(nelements)*1.1,'kv');
        text(R_visDPeakT1Median*1.1,max(nelements)*1.2,num2str(R_visDPeakT1Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',[],'xlim',[0 1600]);
        % xlabel('Double-peaked, early');
        axis on;
        hold off;
        
        axes(h_subplot(21));
        hold on;
        [nelements, ncenters] = hist(R_visDPeakT_plot(:,2),xPeakT);
        h1 = bar(ncenters, nelements, 0.8,'k','edgecolor','k');
        % set(h1,'linewidth',1.5);
        text(170,max(max(nelements),max(nelements)),['n = ',num2str(length(R_visDPeakT_plot))]);
        plot(R_visDPeakT2Median,max(nelements)*1.1,'kv');
        text(R_visDPeakT2Median*1.1,max(nelements)*1.2,num2str(R_visDPeakT2Median/1000));
        set(gca,'xtick',[0 500 1000 1500],'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1600]);
        % xlabel('Double-peaked, late');
        axis on;
        hold off;
        
        suptitle('Peak time distribution');
        SetFigure(10);
        
        set(gcf,'paperpositionmode','auto');
        saveas(104,'Z:\LBY\Population Results\PeakT','emf');
        
        %%%%%%%%%%%%%%%%%%%%%% FR according to Peak time   %%%%%%%%%%%%%%%%%%%%%%%%%
        T_vestiPSTHDPeak_plot = [];
        for ii = 1:size(T_vestiDPeakT,1)
            T_vestiPSTHDPeak_plot = [T_vestiPSTHDPeak_plot;T_vestiPSTHDPeak(ii,T_vestiDPeakT(ii,1)),T_vestiPSTHDPeak(ii,T_vestiDPeakT(ii,2))];
        end
        T_visPSTHDPeak_plot = [];
        for ii = 1:size(T_visDPeakT,1)
            T_visPSTHDPeak_plot = [T_visPSTHDPeak_plot;T_visPSTHDPeak(ii,T_visDPeakT(ii,1)),T_visPSTHDPeak(ii,T_visDPeakT(ii,2))];
        end
        R_vestiPSTHDPeak_plot = [];
        for ii = 1:size(R_vestiDPeakT,1)
            R_vestiPSTHDPeak_plot = [R_vestiPSTHDPeak_plot;R_vestiPSTHDPeak(ii,R_vestiDPeakT(ii,1)),R_vestiPSTHDPeak(ii,R_vestiDPeakT(ii,2))];
        end
        R_visPSTHDPeak_plot = [];
        for ii = 1:size(R_visDPeakT,1)
            R_visPSTHDPeak_plot = [R_visPSTHDPeak_plot;R_visPSTHDPeak(ii,R_visDPeakT(ii,1)),R_visPSTHDPeak(ii,R_visDPeakT(ii,2))];
        end
        
        
        figure(105);set(gcf,'pos',[60 70 1500 900]);clf;
        [~,h_subplot] = tight_subplot(2,5,[0.01 0.1],0.17);
        
        
        axes(h_subplot(1));
        text(1,0.1,'Translation','Fontsize',25,'rotation',90);
        text(1,-0.8,'Rotation','Fontsize',25,'rotation',90);
        axis off;
        
        %%%% FR - early peak vs. late peak (for double-peaked cells)
        % Translation
        % for Vestibular
        axes(h_subplot(2));
        hold on;
        plot(T_vestiPSTHDPeak_plot(:,1),T_vestiPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorDBlue);
        axis on;axis square;
        xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
        set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
        plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
        text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(T_vesti_DPeakInx))]);
        title('Vestibular');
        hold off;
        
        % for Visual
        axes(h_subplot(3));
        hold on;
        plot(T_visPSTHDPeak_plot(:,1),T_visPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorDRed);
        axis on;axis square;
        xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
        set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
        plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
        text(max(get(gca,'xlim')), max(get(gca,'ylim')),['n = ',num2str(length(T_vis_DPeakInx))]);
        title('Visual');
        hold off;
        
        % Rotation
        % for Vestibular
        axes(h_subplot(7));
        hold on;
        plot(R_vestiPSTHDPeak_plot(:,1),R_vestiPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorLBlue);
        axis on;axis square;
        xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
        set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
        plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);
        text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(R_vesti_DPeakInx))]);
        hold off;
        
        % for Visual
        axes(h_subplot(8));
        hold on;
        plot(R_visPSTHDPeak_plot(:,1),R_visPSTHDPeak_plot(:,2),'ko','markersize',8,'markerfacecolor',colorLRed);
        axis on;axis square;
        xylim = max([get(gca,'xlim'),get(gca,'ylim')]);
        set(gca,'xlim',[0 xylim],'ylim',[0 xylim]);
        plot([0 get(gca,'xlim')],[0 get(gca,'xlim')],'-','color',colorLGray);text(max(get(gca,'xlim')),max(get(gca,'ylim')),['n = ',num2str(length(R_vis_DPeakInx))]);
        hold off;
        
        
        %%%% mean PSTH - (divided into single- and  double-peaked cells)
        % % Translation
        % % Vestibular
        % axes(h_subplot(4));
        % hold on;
        % shadedErrorBar(1:size(T_vestiPSTHSPeak(:,5:65),2),nanmean(T_vestiPSTHSPeak(:,5:65),1),nanstd(T_vestiPSTHSPeak(:,5:65),1)/sqrt(size(T_vestiPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
        % shadedErrorBar(1:size(T_vestiPSTHDPeak(:,5:65),2),nanmean(T_vestiPSTHDPeak(:,5:65),1),nanstd(T_vestiPSTHDPeak(:,5:65),1)/sqrt(size(T_vestiPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
        % axis on;axis square;
        % xlim([1 size(T_vestiPSTHSPeak(:,5:65),2)]);
        % title('Vestibular');
        % set(gca,'xtick',[]);
        % % Visual
        % axes(h_subplot(5));
        % hold on;
        % shadedErrorBar(1:size(T_visPSTHSPeak(:,5:65),2),nanmean(T_visPSTHSPeak(:,5:65),1),nanstd(T_visPSTHSPeak(:,5:65),1)/sqrt(size(T_visPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
        % shadedErrorBar(1:size(T_visPSTHDPeak(:,5:65),2),nanmean(T_visPSTHDPeak(:,5:65),1),nanstd(T_visPSTHDPeak(:,5:65),1)/sqrt(size(T_visPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
        % axis on;axis square;
        % xlim([1 size(T_visPSTHSPeak(:,5:65),2)]);
        % title('Visual');
        % set(gca,'xtick',[]);
        % % Rotation
        % % Vestibular
        % axes(h_subplot(9));
        % hold on;
        % shadedErrorBar(1:size(R_vestiPSTHSPeak(:,5:65),2),nanmean(R_vestiPSTHSPeak(:,5:65),1),nanstd(R_vestiPSTHSPeak(:,5:65),1)/sqrt(size(R_vestiPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
        % shadedErrorBar(1:size(R_vestiPSTHDPeak(:,5:65),2),nanmean(R_vestiPSTHDPeak(:,5:65),1),nanstd(R_vestiPSTHDPeak(:,5:65),1)/sqrt(size(R_vestiPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
        % axis on;axis square;
        % xlim([1 size(R_vestiPSTHSPeak(:,5:65),2)]);
        % set(gca,'xtick',[0 500 1000 1500]/timeStep,'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1550]/timeStep);
        %
        % % Visual
        % axes(h_subplot(10));
        % hold on;
        % shadedErrorBar(1:size(R_visPSTHSPeak(:,5:65),2),nanmean(R_visPSTHSPeak(:,5:65),1),nanstd(R_visPSTHSPeak(:,5:65),1)/sqrt(size(R_visPSTHSPeak(:,5:65),2)),'lineprops',{'-','color',colorDRed,'linewidth',2});
        % shadedErrorBar(1:size(R_visPSTHDPeak(:,5:65),2),nanmean(R_visPSTHDPeak(:,5:65),1),nanstd(R_visPSTHDPeak(:,5:65),1)/sqrt(size(R_visPSTHDPeak(:,5:65),2)),'lineprops',{'-','color',colorDBlue,'linewidth',2});
        % xlim([1 size(R_visPSTHSPeak(:,5:65),2)]);
        % axis on;axis square;
        % set(gca,'xtick',[0 500 1000 1500]/timeStep,'xticklabel',{'0','0.5','1','1.5'},'xlim',[0 1550]/timeStep);
        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % axes();
        % hold on;
        % text(0.18,0,'Response, early peak (spk/s)','Fontsize',20);
        % text(0.08,0.2,'Response, late peak (spk/s)','Fontsize',20,'rotation',90);
        % text(0.8,0,'Time (s)','Fontsize',20);
        %
        % axis off;
        
        suptitle('PSTH distribution (Peak time)');
        SetFigure(15);
        
        set(gcf,'paperpositionmode','auto');
        saveas(105,'Z:\LBY\Population Results\PSTH_PeakT','emf');
        
        
        
        SetFigure(15);
        %}
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
        xdiff = linspace(0,180,11);
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
        for jj = 1:2
            for pp = 1:2
                preDir_spatial{pp}{jj}.tempoSig = reshape(preDir{pp}{jj}(repmat(select_temporalSig{1}(:,jj)&select_temporalSig{2}(:,jj),1,3)),[],3);
                preDir_spatial{pp}{jj}.spatialSig = reshape(preDir{pp}{jj}(repmat(select_spatialSig{1}(:,jj)&select_spatialSig{2}(:,jj),1,3)),[],3);
            end
            preDir_diff{jj}.tempoSig = angleDiff(preDir_spatial{1}{jj}.tempoSig(:,1),preDir_spatial{1}{jj}.tempoSig(:,2),preDir_spatial{1}{jj}.tempoSig(:,3),preDir_spatial{2}{jj}.tempoSig(:,1),preDir_spatial{2}{jj}.tempoSig(:,2),preDir_spatial{2}{jj}.tempoSig(:,3));
            preDir_diff{jj}.spatialSig = angleDiff(preDir_spatial{1}{jj}.spatialSig(:,1),preDir_spatial{1}{jj}.spatialSig(:,2),preDir_spatial{1}{jj}.spatialSig(:,3),preDir_spatial{2}{jj}.spatialSig(:,1),preDir_spatial{2}{jj}.spatialSig(:,2),preDir_spatial{2}{jj}.spatialSig(:,3));
        end
        
        % plot figures for delta preferred direction distribution (between vestibular & visual)
        
        xdiff = linspace(0,180,11);
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
        DDI_spatial = [];
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

    function f2p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p1p1(debug)      % BIC distribution across models
        if debug  ; dbstack;   keyboard;      end
        
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                [~, temp] =  min(BIC{pp}{jj},[],2);
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

    function f2p1p2(debug)      % R_squared distribution across models
        if debug  ; dbstack;   keyboard;      end
        xR2 = linspace(0,1,11);
        for pp = 1:size(mat_address,1)
            for jj = 1:2
                
                temp = 1: length(group_result);
                R2_plot{pp}{jj} = R2{pp}{jj}(temp(select_temporalSig{pp}(:,jj)),:);
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

    function f2p2(debug)      % Parameter analysis
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p2p1(debug)      % Weight ratio (V/A) distribution
        if debug  ; dbstack;   keyboard;      end
        xVA = -3:0.5:3;
        
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of log(wV/wA) (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    RatioVA_VA{pp}{jj} = log(wV_VA{pp}(select_temporalSig{pp}(:,jj),jj)./wA_VA{pp}(select_temporalSig{pp}(:,jj),jj));
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
            suptitle(['Distribution of log(wV/wA) (VA model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAJ'))
            figure(12);set(figure(12),'name','Distribution of log(wV/wA) (VAJ model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAJ{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAJ{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
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
            suptitle(['Distribution of log(wV/wA) (VAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'VAP'))
            figure(13);set(figure(13),'name','Distribution of log(wV/wA) (VAP model)','unit','normalized' ,'pos',[-0.55 -0.2 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_VAP{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_VAP{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_VAP{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
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
            suptitle(['Distribution of log(wV/wA) (VAP model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        if sum(strcmp(models,'PVAJ'))
            figure(14);set(figure(14),'name','Distribution of log(wV/wA) (PVAJ model)','unit','normalized' ,'pos',[-0.55 -0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    % to normalize
                    temp = [];
                    temp(:,1) = wV_PVAJ{pp}(select_temporalSig{pp}(:,jj),jj);
                    temp(:,2) = wA_PVAJ{pp}(select_temporalSig{pp}(:,jj),jj);
                    RatioVA_PVAJ{pp}{jj} = log((temp(:,1)./(temp(:,1)+temp(:,2)))./(temp(:,2)./(temp(:,1)+temp(:,2))));
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
            suptitle(['Distribution of log(wV/wA) (PVAJ model) (Monkey = ',monkey_to_print,')']);
            SetFigure(12);
        end
        
        
    end

    function f2p2p2(debug)      % Preferred direction & angle difference distribution ( V vs. A)
        if debug  ; dbstack;   keyboard;      end
        
        xDiff = linspace(0,180,11);
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of the preferred directions (V&A, VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,4,0.1,0.1,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    
                    preDir_V_VA_azi{pp}{jj} = preDir_V_VA{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_V_VA_ele{pp}{jj} = preDir_V_VA{pp}{jj}(select_temporalSig{pp}(:,jj),2);
                    preDir_A_VA_azi{pp}{jj} = preDir_A_VA{pp}{jj}(select_temporalSig{pp}(:,jj),1);
                    preDir_A_VA_ele{pp}{jj} = preDir_A_VA{pp}{jj}(select_temporalSig{pp}(:,jj),2);
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
                    
                    
                    angleDiff_VA_VA_plot{pp}{jj} = angleDiff_VA_VA{pp}(select_temporalSig{pp}(:,jj),jj);
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

    function f2p2p3(debug)      % time delay distribution ( V/A, P/V, P/A)
        if debug  ; dbstack;   keyboard;      end
        xDelay = linspace(0,0.5,11);
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Distribution of delay of V/A (VA model)','unit','normalized' ,'pos',[-0.55 0.2 0.5 0.6]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.15 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = Para{pp}{jj}(:,find(strcmp(models,'VA')));
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

    function f2p2p4(debug)      % Partial R_squared distribution
        if debug  ; dbstack;   keyboard;      end
        if sum(strcmp(models,'VA'))
            figure(11);set(figure(11),'name','Partial R2 (VA model)','unit','normalized' ,'pos',[-0.55 0.6 0.5 0.3]); clf;
            [~,h_subplot] = tight_subplot(2,2,0.15,0.2,[0.1 0.02]);
            for pp = 1:2
                for jj = 1:2
                    temp = [parR2V_VA{pp}(:,jj) parR2A_VA{pp}(:,jj)];
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
                    temp = [parR2V_VAJ{pp}(:,jj) parR2A_VAJ{pp}(:,jj) parR2J_VAJ{pp}(:,jj)];
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
                    temp = [parR2V_VAP{pp}(:,jj) parR2A_VAP{pp}(:,jj) parR2P_VAP{pp}(:,jj)];
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
        
        
    end


    function f2p3(debug)      % check
        if debug  ; dbstack;   keyboard;      end
        
        
    end

    function f2p3p1(debug)      % model fitting evaluation
        if debug  ; dbstack;   keyboard;      end
        
        
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