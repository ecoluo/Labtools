% For 3D tuning with 26 directions in 3D space
% Translation & Rotation
% fig.2 plot PSTH for each trial and raster plot across directions
% fig.3 plot mean PSTHs across directions
% fig.4 plot PSTH with peaks
% fig.6 plot PSTH with peaks with direction tuning
% fig.11 plot coutour tuning responses (sum response of middle 1s)
% fig.12 plot coutour tuning responses (at peak(DS) time)
% fig.5 PSTH - spon
% fig.10 3D model
%
% @LBY, Gu lab, 201612
% @LBY, Gu lab, 201711



function Tuning_3D_analysis_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, ~, StopOffset, PATH, FILE, batch_flag)

% tic;

global PSTH3Dmodel PSTH1Dmodel PSTH;
PSTH3Dmodel = [];PSTH = []; PSTH1Dmodel = [];

% contains protocol etc. specific keywords
TEMPO_Defs;
Path_Defs;
ProtocolDefs;

stimType{1}='Vestibular';
stimType{2}='Visual';
stimType{3}='Combined';

PSTH.monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch PSTH.monkey_inx
    case '5'
        PSTH.monkey = 'Polo';
    case '6'
        PSTH.monkey = 'Qiaoqiao';
    otherwise
        PSTH.monkey = 'MSTd';
end


%% get data
% stimulus type,azi,ele,amp and duration

% temporarily, for htb missing cells
if data.one_time_params(NULL_VALUE) == 0
    data.one_time_params(NULL_VALUE) = -9999;
end

switch Protocol
    case DIRECTION_TUNING_3D % for translation
        trials = 1:size(data.moog_params,2); % the No. of all trials
        % find the trials for analysis
        temp_trials = trials(find( (data.moog_params(AZIMUTH,trials,MOOG) ~= data.one_time_params(NULL_VALUE)) )); % 26*rept trials
        temp_stimType = data.moog_params(STIM_TYPE,temp_trials,MOOG);
        unique_stimType = munique(temp_stimType');
        trials = 1:size(data.moog_params,2);		% a vector of trial indices
        
        % If length(BegTrial) > 1 and all elements are positive, they are trials to be included.
        % Else, if all elements are negative, they are trials to be excluded.
        % This enable us to exclude certain trials ** DURING ** the recording more easily. HH20150410
        select_trials = false(size(trials));
        if length(BegTrial) == 1 && BegTrial > 0 % Backward compatibility
            select_trials(BegTrial:EndTrial) = true;
        elseif all(BegTrial > 0) % To be included
            select_trials(BegTrial) = true;
        elseif all(BegTrial < 0) % To be excluded
            select_trials(-BegTrial) = true;
            select_trials = ~ select_trials;
        else
            disp('Trial selection error...');
            keyboard;
        end
        
        %         spon_trials = false(size(trials));
        spon_trials = select_trials & (data.moog_params(AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE));
        real_trials = select_trials & (~(data.moog_params(AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE)));
        
        temp_azimuth = data.moog_params(AZIMUTH,real_trials,MOOG);
        temp_elevation = data.moog_params(ELEVATION,real_trials,MOOG);
        temp_amplitude = data.moog_params(AMPLITUDE,real_trials,MOOG);
        temp_stimType = data.moog_params(STIM_TYPE,real_trials,MOOG);
        
        
    case ROTATION_TUNING_3D % for rotation
        trials = 1:size(data.moog_params,2); % the No. of all trials
        % find the trials for analysis
        temp_trials = trials(find( (data.moog_params(ROT_AZIMUTH,trials,MOOG) ~= data.one_time_params(NULL_VALUE)) )); % 26*rept trials
        temp_stimType = data.moog_params(STIM_TYPE,temp_trials,MOOG);
        unique_stimType = munique(temp_stimType');
        trials = 1:size(data.moog_params,2);		% a vector of trial indices
        
        % If length(BegTrial) > 1 and all elements are positive, they are trials to be included.
        % Else, if all elements are negative, they are trials to be excluded.
        % This enable us to exclude certain trials ** DURING ** the recording more easily. HH20150410
        select_trials = false(size(trials));
        if length(BegTrial) == 1 && BegTrial > 0 % Backward compatibility
            select_trials(BegTrial:EndTrial) = true;
        elseif all(BegTrial > 0) % To be included
            select_trials(BegTrial) = true;
        elseif all(BegTrial < 0) % To be excluded
            select_trials(-BegTrial) = true;
            select_trials = ~ select_trials;
        else
            disp('Trial selection error...');
            keyboard;
        end
        
        %         spon_trials = false(size(trials));
        spon_trials = select_trials & (data.moog_params(ROT_AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE));
        real_trials = select_trials & (~(data.moog_params(ROT_AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE)));
        
        temp_azimuth = data.moog_params(ROT_AZIMUTH,real_trials,MOOG);
        temp_elevation = data.moog_params(ROT_ELEVATION,real_trials,MOOG);
        temp_amplitude = data.moog_params(ROT_AMPLITUDE,real_trials,MOOG);
        temp_stimType = data.moog_params(STIM_TYPE,real_trials,MOOG);
        
end

temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms

unique_azimuth = munique(temp_azimuth');
unique_elevation = munique(temp_elevation');
unique_amplitude = munique(temp_amplitude');
unique_duration = munique(temp_duration');
unique_stimType = munique(temp_stimType');

% time information?
eye_timeWin = 1000/(data.htb_header{EYE_DB}.speed_units/data.htb_header{EYE_DB}.speed/(data.htb_header{EYE_DB}.skip+1)); % in ms
spike_timeWin = 1000/(data.htb_header{SPIKE_DB}.speed_units/data.htb_header{SPIKE_DB}.speed/(data.htb_header{SPIKE_DB}.skip+1)); % in ms
event_timeWin = 1000/(data.htb_header{EVENT_DB}.speed_units/data.htb_header{EVENT_DB}.speed/(data.htb_header{EVENT_DB}.skip+1)); % in ms

% time marks for each trial
event_in_bin = squeeze(data.event_data(:,:,trials));
stimOnT = find(event_in_bin == VSTIM_ON_CD);
stimOffT = find(event_in_bin == VSTIM_OFF_CD);
FPOnT = find(event_in_bin == FP_ON_CD);
FixInT = find(event_in_bin == IN_FIX_WIN_CD);

% spike data
% 5000*260 (for 5 repetitions)
spike_data = squeeze(data.spike_data(SpikeChan,:,real_trials)); % sipke data in 5000ms for each trial
spike_data( spike_data > 100 ) = 1; % something is absolutely wrong, recorrect to 1
spon_spk_data = squeeze(data.spike_data(SpikeChan,:,spon_trials));

max_reps = ceil(sum(real_trials)/length(unique_stimType)/26); % fake max repetations
%% pack data for PSTH, modeling and analysis
% conditions: k=1,2,3
% Elevation: j= -90,-45,0,45,90 (up->down)
% Azimuth: i=0 45 90 135 180 225 270 315

% time markers
% for PSTH & models
timeWin = 300; % in ms
timeStep = 25; % in ms
gau_sig = 100; % parameters for smoothing
tOffset1 = 100; % in ms, time before stim on ( at least -100)
tOffset2 = 100; % in ms, time after stim off

% just for report
% tOffset1 = 000; % in ms
% tOffset2 = 000; % in ms

PCAStep = 20; % for PCA
PCAWin = 100; % for PCA
nBinsPCA = floor(temp_duration(1)/PCAStep); % in ms

if strcmp(PSTH.monkey ,'MSTd') == 1
    delay = 115; % in ms, MSTd, 1806
    %for MSTd delay is 100 ms
    aMax = 770; % in ms, peak acceleration time, measured time
    aMin = 1250; % in ms, trough acceleration time, measured time
else % for PCC
    delay = 145; % in ms, system time delay, LBY modified, 200311.real velocity peak-theoretical veolocity peak
    aMax = 585; % in ms, peak acceleration time relative to real stim on time, measured time
    aMin = 950; % in ms, trough acceleration time relative to real stim on time, measured time
end

stimOnT = stimOnT + delay;
stimOffT = stimOffT + delay;

% align all time points to stim on T
nBins = floor((temp_duration(1)+tOffset2)/timeStep)+floor(tOffset1/timeStep); % in ms
PSTH_onT = stimOnT(1) - floor(tOffset1/timeStep)*timeStep; % the exact PSTH-ontime point
stimOnBin = floor(tOffset1/timeStep)+1;
stimOffBin = floor(tOffset1/timeStep)+floor(temp_duration(1)/timeStep);

% for contour figures
tBeg = 250; % in ms
tEnd = 250; % in ms

% V, A time profile
mu = (aMax+aMin)/2/1000;
sig = sqrt(sqrt(2))/6;
v_timeProfile = [ones(1,stimOnBin-1)*vel_profile([mu sig],stimOnBin*timeStep/1000),vel_profile([mu sig],(stimOnBin:stimOffBin)*timeStep/1000),ones(1,nBins-stimOffBin)*vel_profile([mu sig],stimOffBin*timeStep/1000)];
a_timeProfile = [ones(1,stimOnBin-1)*acc_profile([mu sig],stimOnBin*timeStep/1000),acc_profile([mu sig],(stimOnBin:stimOffBin)*timeStep/1000),ones(1,nBins-stimOffBin)*acc_profile([mu sig],stimOffBin*timeStep/1000)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now, pack the data
% spk rates of real trials (no spon)
for k = 1:length(unique_stimType)
    
    pc = 0;
    
    % initialize
    % for contour
    PSTH.spk_data_count_mean_rate{k} = [];
    
    % PSTH
    PSTH.spk_data_bin_mean_rate{k} = []; % mean spike count per time window (for PSTH) % 1*nbins
    spk_data_bin_mean_rate_std{k} = [];
    PSTH.spk_data_bin_mean_rate_ste{k} = [];
    PSTH.spk_data_bin_rate_aov{k} = [];% for PSTH ANOVA
    
    PSTH.spk_data_bin_rate_aov{k} = nan*ones(26,nBins,max_reps);
    
    for j = 1:length(unique_elevation)
        for i = 1:length(unique_azimuth)
            % initialize
            % for contour
            PSTH.spk_data_count_rate{k,j,i} = [];
            PSTH.spk_data_count_rate_all{k,j,i} = [];
            
            
            spk_data{k,j,i} = []; % raw spike count (transform spike_data to a more clear way)
            PSTH.spk_data_bin_rate{k,j,i} = []; % spike counts per time window (for PSTH across trials)
            
            % find specified conditions with repetitions -> pack the data
            select = find( (temp_azimuth == unique_azimuth(i)) & (temp_elevation == unique_elevation(j)) & (temp_stimType == unique_stimType(k))) ;
            if sum(select)>0
                spk_data{k,j,i}(:,:) = spike_data(:,select);
                pc = pc+1;
                
                % for contour
                spk_data_count_rate_anova{k,pc} = [];
                % PSTH
                %                 PSTH.spk_data_bin_rate_aov{k,pc} = [];% for PSTH ANOVA
                
                try
                    spk_data_count_rate_anova{k,pc} =  sum(spk_data{k,j,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000);
                catch
                    keyboard;
                end
                resp_sse(k,pc) = sum((spk_data_count_rate_anova{k,pc} - mean(spk_data_count_rate_anova{k,pc})).^2); % for DDI
                resp_trialnum(k,pc)= size(spk_data_count_rate_anova{k,pc},2); % for DDI
            else
                spk_data{k,j,i}(:,:) = spk_data{k,j,1}(:,:);
            end
            
            % pack data for PSTH
            PSTH.spk_data_bin_rate{k,j,i} = PSTH_smooth(nBins, PSTH_onT, timeWin, timeStep, spk_data{k,j,i}(:,:), 2, gau_sig);
            try
                temp = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spk_data{k,j,i}(:,:), 2, gau_sig);
                PSTH.spk_data_bin_rate_aov{k}(pc,:,1:size(temp,2)) = temp;
                temp = PSTH_smooth( nBinsPCA, stimOnT, PCAWin, PCAStep, mean(spk_data{k,j,i}(:,:),2), 1, 0);
                PSTH.spk_data_bin_rate_PCA{k}(pc,:,1:size(temp,2)) = temp;
            catch
                
            end
            
            PSTH.spk_data_bin_mean_rate_PCA{k}(pc,:) = nanmean(PSTH.spk_data_bin_rate_PCA{k}(pc,:,:),3);
            PSTH.spk_data_bin_mean_rate_aov{k}(pc,:) = nanmean(PSTH.spk_data_bin_rate_aov{k}(pc,:,:),3);
            
            % calculate correlation coefficient between response and V/A curve
            [R,P] = corrcoef(v_timeProfile,PSTH.spk_data_bin_mean_rate_aov{k}(pc,:));
            PSTH.coef_v{k}(1,pc) = R(1,2);
            PSTH.coef_v{k}(2,pc) = P(1,2);
            [R,P] = corrcoef(a_timeProfile,PSTH.spk_data_bin_mean_rate_aov{k}(pc,:));
            PSTH.coef_a{k}(1,pc) = R(1,2);
            PSTH.coef_a{k}(2,pc) = P(1,2);
            
            PSTH.spk_data_bin_mean_rate{k}(j,i,:) = mean(PSTH.spk_data_bin_rate{k,j,i},2);
            PSTH.spk_data_bin_vector{k} = PSTH.spk_data_bin_mean_rate{k};
            PSTH.spk_data_bin_vector{k}([1,5],2:end,:) = 0;
            spk_data_bin_mean_rate_std{k}(j,i,:) = std(PSTH.spk_data_bin_rate{k,j,i},0,2);
            PSTH.spk_data_bin_mean_rate_ste{k}(j,i,:) = spk_data_bin_mean_rate_std{k}(j,i,:)/sqrt(size(PSTH.spk_data_bin_rate{k,j,i}(1,:),2));
            
            % pack data for contour
            PSTH.spk_data_count_rate{k,j,i} = sum(spk_data{k,j,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000); % rates
            PSTH.spk_data_count_mean_rate{k}(j,i) = mean(PSTH.spk_data_count_rate{k,j,i}(:));% for countour plot and ANOVA
            PSTH.spk_data_count_rate_all{k,j,i} = sum(spk_data{k,j,i}(stimOnT(1):stimOffT(1),:),1)/(unique_duration(1,1)/1000); % rates of all duration
            PSTH.spk_data_count_mean_rate_all{k}(j,i) = mean(PSTH.spk_data_count_rate_all{k,j,i}(:));% for models
            spk_data_vector_rate{k,j,i} = sum(spk_data{k,j,i}(stimOnT(1)+tBeg:stimOnT(1)+tBeg+unique_duration(1,1)/2,:),1)/((unique_duration(1,1)/2)/1000); % rates
            PSTH.spk_data_vector{k}(j,i) = mean(spk_data_vector_rate{k,j,i}(:)); % for preferred direction
            PSTH.spk_data_vector{k}([1,5],2:end) = 0;
        end
    end
    
    % preliminary analysis
    
    PSTH.time_profile{k} = squeeze(sum(sum(PSTH.spk_data_bin_mean_rate{k}(j,i,:),1),2));
    PSTH.spk_data_bin_mean_rate_aov_cell{k} = mean(PSTH.spk_data_bin_mean_rate_aov{k},1);
    maxSpkRealMean(k) = max(PSTH.spk_data_count_mean_rate{k}(:));
    minSpkRealMean(k) = min(PSTH.spk_data_count_mean_rate{k}(:));
    PSTH.maxSpkRealBinMean(k) = max(PSTH.spk_data_bin_mean_rate{k}(:));
    PSTH.minSpkRealBinMean(k) = min(PSTH.spk_data_bin_mean_rate{k}(:));
    PSTH.maxSpkRealBinAll(k) = max(PSTH.spk_data_bin_rate_aov{k}(:));
    PSTH.maxSpkRealBinMeanSte(k) = max(PSTH.spk_data_bin_mean_rate_ste{k}(:));
    
    % calculate DDT & preferred directions for tuning
    numReps(k) = max(cell2mat(cellfun(@length,spk_data_count_rate_anova(k,:),'UniformOutput',false)));
    for nn = 1:length(spk_data_count_rate_anova(k,:))
        if length(spk_data_count_rate_anova{k,nn})<numReps(k)
            spk_data_count_rate_anova{k,nn} = [spk_data_count_rate_anova{k,nn} nan*ones(1,(numReps(k)-length(spk_data_count_rate_anova{k,nn})))];
        end
    end
    spk_data_count_rate_anova_trans{k} = reshape(cell2mat(spk_data_count_rate_anova(k,:)),[numReps(k),length(spk_data_count_rate_anova(k,:))]);
    p_anova_dire(k) = anova1(spk_data_count_rate_anova_trans{k},'','off'); % tuning anova
    resp_std(k) = sum(resp_sse(k,:))/(sum(resp_trialnum(k,:))-26);
    DDI(k) = (maxSpkRealMean(k)-minSpkRealMean(k))/(maxSpkRealMean(k)-minSpkRealMean(k)+2*sqrt(resp_std(k)));
    [Azi, Ele, Amp] = vectorsum(PSTH.spk_data_vector{k}(:,:));
    preferDire{k} = [Azi, Ele, Amp];
    
    % calculate the differences between every direction and the preferred direction
    azis = reshape(repmat([0 45 90 135 180 225 270 315],5,1),[],1);
    eles = repmat([-90 -45 0 45 90],1,8)';
    pre_diff{k} = angleDiff(azis,eles,ones(1,40),ones(1,40)*preferDire{k}(1),ones(1,40)*preferDire{k}(2),ones(1,40));
    
end

% pack data for sponteneous conditions
spon_spk_count_rate = sum(spon_spk_data(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000);
PSTH.spon_spk_data_bin_rate = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spon_spk_data, 2, gau_sig);
PSTH.spon_spk_data_bin_mean_rate = mean(PSTH.spon_spk_data_bin_rate(:,:),2);
PSTH.spon_spk_data_bin_mean_rate_std = std(PSTH.spon_spk_data_bin_rate(:,:),0,2);
PSTH.spon_spk_data_bin_mean_rate_ste = PSTH.spon_spk_data_bin_mean_rate_std/sqrt(size(PSTH.spon_spk_data_bin_rate(:,:),2));

% maximum spon value
maxSpkSponAll = max(max(PSTH.spon_spk_data_bin_rate)); % for PSTH across trials
PSTH.maxSpkSponBinMean = max(PSTH.spon_spk_data_bin_mean_rate); % for PSTH mean
maxSpkSponMean = max(spon_spk_count_rate); % for contour
PSTH.maxSpkSponBinMeanSte = max(PSTH.spon_spk_data_bin_mean_rate_ste);
% mean spon value
PSTH.meanSpkSponBinMean = mean(PSTH.spon_spk_data_bin_mean_rate);% for PSTH mean & PSTH across trials
meanSpkSponMean = mean(spon_spk_count_rate);% for contour
meanSpon = meanSpkSponMean;


%% Analysis - angle diff for each bin
%{
% find the max Firing Rate (FR) of every time bin

for k = 1:length(unique_stimType)
    preDirAcrossTBin{k} = [];
    angleDiffs{k} = [];
    for nn = 1:nBins(1,1)
        PSTH.spk_data_bin_mean_rate{k}(j,i,nn);
        [Azi, Ele, Amp] = vectorsum(squeeze(PSTH.spk_data_bin_vector{k}(:,:,nn)));
        preDirAcrossTBin{k}(nn,:) = [Azi, Ele, Amp];
        for j = 1:length(unique_elevation)
            for i = 1:length(unique_azimuth)
                try
                    angleDiffs{k}(j,i,nn) = angleDiff(unique_azimuth(i),unique_elevation(j),0.11,preDirAcrossTBin{k}(nn,1),preDirAcrossTBin{k}(nn,2),preDirAcrossTBin{k}(nn,3));
                catch
                    keyboard;
                end
            end
            
        end
    end
end
%}
%% Temporal analysis
% %{
% based on Chen, AH et al., 2010, JNS
% wilcoxon rank sum test
% 500 ms after stim. on to 50ms before stim off

baselineBinBeg = stimOnBin-floor(100/timeStep);
baselineBinEnd = stimOnBin+floor(200/timeStep);

for k = 1:length(unique_stimType)
    %     spk_data_bin_rate_mean_minusSpon{k} = PSTH.spk_data_bin_mean_rate_aov{k}-repmat(PSTH.spon_spk_data_bin_mean_rate',size(PSTH.spk_data_bin_mean_rate_aov{k},1),1);
    sPeak{k} = zeros(1,size(PSTH.spk_data_bin_rate_aov{k},1)); % store the number of significant bins
    sTrough{k} = zeros(1,size(PSTH.spk_data_bin_rate_aov{k},1)); % store the number of significant bins
    peakDir{k} = []; % the number of local peak direction
    peakR{k} = []; % the response of local peak direction
    localPeak{k} = []; % find the local peak bin of each direction
    localTrough{k} = []; % find the local trough bin of each direction
    PSTH.peak{k} = []; % location of peaks
    PSTH.trough{k} = []; % location of troughs
    PSTH.NoPeaks(k) = 0; % number of peaks
    PSTH.NoTroughs(k) = 0; % location of troughs
    PSTH.respon_sigTrue(k) = 0; % PSTH.sigTrue(pc) -> sig. of this cell
    
    
    % --------- to test if this direction is temporally responded -------%
    
    for pc = 1:size(PSTH.spk_data_bin_rate_aov{k},1)
        
        PSTH.sigBin{k,pc} = []; % find if this bin is sig.
        PSTH.sigTrue{k}(pc) = 0; % PSTH.sigTrue(pc) -> sig. of this direction
        
        % if 5 consecutive bins are sig.,then we say this bin is sig.
        % That is, this direction is temporally responded
        for nn = stimOnBin : stimOffBin
            s{k,pc}(nn) = 0;
            for ii = nn-2:nn+2
                try
                    if ranksum(squeeze(PSTH.spk_data_bin_rate_aov{k}(pc,ii,:))',squeeze(nanmean(PSTH.spk_data_bin_rate_aov{k}(pc,baselineBinBeg:baselineBinEnd,:)))') < 0.01
                        s{k,pc}(nn) =  s{k,pc}(nn)+1;
                    end
                catch
                    keyboard;
                end
            end
            if s{k,pc}(nn) == 5
                PSTH.sigBin{k,pc} = [PSTH.sigBin{k,pc};nn]; %
            end
            
            if ~isempty(PSTH.sigBin{k,pc})
                PSTH.sigTrue{k}(pc) = 1; % PSTH.sigTrue(pc) == 1 -> sig. of this direction
            end
        end
    end
    
    PSTH.sig(k) = sum(PSTH.sigTrue{k}(:)); % sig No.of directions
    
    % --------------- this cell is temporally responded ------------------%
    
    % 2个方向,不需要相邻
    if sum(PSTH.sigTrue{k}(:)) >=2
        PSTH.respon_sigTrue(k) = 1;
    end
    % 相邻2个方向
    %     if respon_True(PSTH.sigTrue{k}(:)) == 1
    %         PSTH.respon_sigTrue(k) = 1;
    %
    %     end
    
    p_anova_dire_t{k} = nan;
    DDI_t{k} = nan;
    DDI_p_t{k} = nan;
    preferDire_t{k} = nan(3,1);
    PSTH.spk_data_sorted_PCA{k} = nan;
    
    if PSTH.respon_sigTrue(k) == 1
        
        % --------- to find local peaks & throughs -------%
        peakR{k} = NaN(1,nBins);peakDir{k} = NaN(1,nBins);p{k} = NaN(1,nBins);
        for nn = stimOnBin : stimOffBin
            [peakR{k}(nn),peakDir{k}(nn)] = max(PSTH.spk_data_bin_mean_rate_aov{k}(:,nn));
            try
                p{k}(nn) = anova1(squeeze(PSTH.spk_data_bin_rate_aov{k}(:,nn,:))','','off');
            catch
                keyboard;
            end
        end
        pp = 0;th = 0;
        for tt = stimOnBin+2 : stimOffBin-2
            
            if (peakR{k}(tt) > peakR{k}(tt-1)) && (peakR{k}(tt) > peakR{k}(tt+1))...
                    && p{k}(tt) < 0.01 && p{k}(tt-1) < 0.01 && p{k}(tt-2) < 0.01 && p{k}(tt+1) < 0.01 && p{k}(tt+2) < 0.01
                pp = pp+1; % how many peaks
                localPeak{k}(pp,1)= tt;
                localPeak{k}(pp,2)= peakR{k}(tt);
            end
            if (peakR{k}(tt) < peakR{k}(tt-1)) && (peakR{k}(tt) < peakR{k}(tt+1))...
                    && p{k}(tt) < 0.01 && p{k}(tt-1) < 0.01 && p{k}(tt-2) < 0.01 && p{k}(tt+1) < 0.01 && p{k}(tt+2) < 0.01
                th = th+1; % how many throughs
                localTrough{k}(th,1)= tt;
                localTrough{k}(th,2)= peakR{k}(tt);
            end
        end
        
        % --------- to find real peaks & throughs? -------%
        
        if ~isempty(localPeak{k})
            localPeak{k} = sortrows(localPeak{k},-2)'; % sort according to response
            PSTH.peak{k} = localPeak{k}(1,1); % True peaks, here the largest one is sure to be the 1st peak
            
            % find other peaks
            % conpare the correlation coefficient between the largest one and each other bin
            if size(localPeak{k},2)>1
                n = 1;
                while n < size(localPeak{k},1)
                    ii = n+1;
                    while ii < size(localPeak{k},1)+1
                        try
                            [rCorr,pCorr] = corrcoef(PSTH.spk_data_bin_mean_rate_aov{k}(:,localPeak{k}(1,n)),PSTH.spk_data_bin_mean_rate_aov{k}(:,localPeak{k}(1,ii)));
                        catch
                            
                        end
                        if ~(rCorr(1,2) > 0 && pCorr(1,2) < 0.05)
                            PSTH.peak{k} = [PSTH.peak{k} localPeak{k}(1,ii)];
                            n = ii;
                            break;
                        else
                            ii = ii+1;
                        end
                    end
                    n = n+1;
                end
            end
        end
        PSTH.NoPeaks(k) = length(PSTH.peak{k});
        
        
        % calculate DDI for each peak time
        for pt = 1:PSTH.NoPeaks(k)
            for pc = 1:size(PSTH.spk_data_bin_rate_aov{k},1)
                resp_sse_t{k}(pc,pt) = nansum((PSTH.spk_data_bin_rate_aov{k}(pc,PSTH.peak{k}(pt),:) - nanmean(PSTH.spk_data_bin_rate_aov{k}(pc,PSTH.peak{k}(pt),:))).^2); % for DDI
                resp_trialnum_t{k}(pc,pt)= size(PSTH.spk_data_bin_rate_aov{k}(pc,PSTH.peak{k}(pt),:),3); % for DDI
            end
            
            try
                p_anova_dire_t{k}(pt) = anova1(squeeze(PSTH.spk_data_bin_rate_aov{k}(:,PSTH.peak{k}(pt),:))','','off'); % tuning anova
                resp_std_t{k}(pt) = sum(resp_sse_t{k}(:,pt))/(sum(resp_trialnum_t{k}(:,pt))-26);
                maxSpkRealMean_t{k}(pt) = max(max(squeeze((PSTH.spk_data_bin_rate_aov{k}(:,PSTH.peak{k}(pt),:)))));
                minSpkRealMean_t{k}(pt) = min(min(squeeze((PSTH.spk_data_bin_rate_aov{k}(:,PSTH.peak{k}(pt),:)))));
                DDI_t{k}(pt) = (maxSpkRealMean_t{k}(pt)-minSpkRealMean_t{k}(pt))/(maxSpkRealMean_t{k}(pt)-minSpkRealMean_t{k}(pt)+2*sqrt(resp_std_t{k}(pt)));
                
                % DDI permutation
                num_perm = 1000;
                for nn = 1 : num_perm
                    temp = squeeze(PSTH.spk_data_bin_rate_aov{k}(:,PSTH.peak{k}(pt),:));
                    temp = temp(:);
                    temp = temp(randperm(26*size(PSTH.spk_data_bin_rate_aov{k},3)));
                    temp = reshape(temp,26,[]);
                    temp = nanmean(temp,2);
                    maxSpkRealMean_perm_t{k}(nn,pt) = max(temp);
                    minSpkRealMean_perm_t{k}(nn,pt) = min(temp);
                    DDI_perm_t{k}(pt,nn) = (maxSpkRealMean_perm_t{k}(nn,pt)-minSpkRealMean_perm_t{k}(nn,pt))/(maxSpkRealMean_perm_t{k}(nn,pt)-minSpkRealMean_perm_t{k}(nn,pt)+2*sqrt(resp_std_t{k}(pt)));
                    
                end
                DDI_p_t{k}(pt) = sum(DDI_perm_t{k}(pt,:)>DDI_t{k}(pt))/num_perm;
                
                % preferred direction
                [Azi, Ele, Amp] = vectorsum(squeeze(PSTH.spk_data_bin_vector{k}(:,:,PSTH.peak{k}(pt))));
                preferDire_t{k}(:,pt) = [Azi, Ele, Amp];
            catch
                keyboard;
            end
        end
        
        % sort PCA according to the maximum of direction
        if ~isempty(PSTH.peak{k})
            [~, temp_inx] = sortrows(PSTH.spk_data_bin_mean_rate_PCA{k}(:,PSTH.peak{k}(1)),-1);
            PSTH.spk_data_sorted_PCA{k} = PSTH.spk_data_bin_mean_rate_PCA{k}(temp_inx,:);
        else
            PSTH.spk_data_sorted_PCA{k} = PSTH.spk_data_bin_mean_rate_PCA{k};
        end
    end
end


%}
%% plot figures
%

% k=1,2,3
% j= -90,-45,0,45,90 (up->down)
% i=0 45 90 135 180 225 270 315

% 270-225-180-135-90-45-0-315-270 for figures
% iAzi = [7 6 5 4 3 2 1 8 7];
iAzi = [7 6 5 4 3 2 1 8];

% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% the lines markers
markers = {
    % markerName % markerTime % marker bin time % color % linestyle
    %     'FPOnT',FPOnT(1),(FPOnT(1)-PSTH_onT+timeStep)/timeStep,colorDGray;
    %     'stim_on',stimOnT(1),stimOnBin,colorDRed,'.';
    %     'stim_off',stimOffT(1),stimOffBin,colorDRed,'.';
    'aMax',stimOnT(1)+aMax,(stimOnT(1)+aMax-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'aMin',stimOnT(1)+aMin,(stimOnT(1)+aMin-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'v',stimOnT(1)+aMax+(aMin-aMax)/2,(stimOnT(1)+aMax+(aMin-aMax)/2-PSTH_onT+timeStep)/timeStep,'r','--';
    };

Bin = [nBins,(stimOnT(1)-PSTH_onT+timeStep)/timeStep,(stimOffT(1)-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+719-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+1074-PSTH_onT+timeStep)/timeStep];
% preferDirectionOfTime;
% CosineTuningPlot;
PSTH_3D_Tuning; % plot PSTHs across sessions;
% Contour_3D_Tuning; % plot countour figures;
% Contour_3D_Tuning_GIF; % plot countour figures(PD across time);
% spatial_tuning;

model_catg = [];
%% 3D models nalysis

% %{
model_catg = 'Sync model'; % tau is the same
% model_catg = 'Out-sync model'; % each component has its own tau

% models = {'VA','VO','AO'};
% models_color = {'k','r',colorDBlue};

models = {'VO','AO','VA','VJ','AJ','VAJ'};
models_color = {'r',colorDBlue,colorDGreen,colorLRed,colorLBlue,'k'};

% models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
% models_color = {'r',colorDBlue,colorDGreen,colorLRed,colorLBlue,colorLRed,colorLRed,'k','k','k'};

% models = {'PVAJ'};
% models_color = {'k'};

% models = {'VAJ','VA'};
% models_color = {'k','g'};

% models = {'VAJ'};
% models_color = {'k'};

% models = {'VA','VAJ','VAP','PVAJ'};
% models_color = {'k','k','k','k'};

spon_flag = 0; % 0 means raw data; 1 means mean(raw)-mean(spon) data

reps = 20;

% reps = 2;

for k = 1:length(unique_stimType)
    % for k = 1
%     if PSTH.respon_sigTrue(k) == 1
        
        % fit data with raw PSTH data or - spon data
        switch spon_flag
            case 0 %raw data
                models_fitting(model_catg,models,models_color,FILE,SpikeChan, Protocol,k,meanSpon,PSTH.spk_data_bin_mean_rate{k}(:,:,stimOnBin:stimOffBin),PSTH.spk_data_count_mean_rate_all{k},PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
            case 1 % - spon data, so meanspon == 0
                PSTH.spk_data_bin_mean_rate{k} = PSTH.spk_data_bin_mean_rate{k} - permute(reshape(repmat(PSTH.spon_spk_data_bin_mean_rate,8,5),[],8,5),[3 2 1]);
                PSTH.spk_data_count_mean_rate_all{k} = PSTH.spk_data_count_mean_rate_all{k} - meanSpkSponMean; % 会出现负值
                %                 PSTH.spon_spk_data_bin_mean_rate = meanSpkSponMean;
                models_fitting(model_catg,models,models_color,FILE,SpikeChan, Protocol,k,0,PSTH.spk_data_bin_mean_rate{k}(:,:,stimOnBin:stimOffBin),PSTH.spk_data_count_mean_rate_all{k},PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
        end
        
        if sum(ismember(models,'PVAJ')) ~= 0
            
            PSTH3Dmodel{k}.PVAJ_wP = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(21))*PSTH3Dmodel{k}.modelFitPara_PVAJ(20);
            PSTH3Dmodel{k}.PVAJ_wV = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(21))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(20));
            PSTH3Dmodel{k}.PVAJ_wA = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*PSTH3Dmodel{k}.modelFitPara_PVAJ(21);
            PSTH3Dmodel{k}.PVAJ_wJ = PSTH3Dmodel{k}.modelFitPara_PVAJ(22);
            [PSTH3Dmodel{k}.PVAJ_preDir_V(1),PSTH3Dmodel{k}.PVAJ_preDir_V(2),PSTH3Dmodel{k}.PVAJ_preDir_V(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_PVAJ.V);
            [PSTH3Dmodel{k}.PVAJ_preDir_A(1),PSTH3Dmodel{k}.PVAJ_preDir_A(2),PSTH3Dmodel{k}.PVAJ_preDir_A(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_PVAJ.A);
            PSTH3Dmodel{k}.PVAJ_angleDiff_VA = angleDiff(PSTH3Dmodel{k}.PVAJ_preDir_V(1),PSTH3Dmodel{k}.PVAJ_preDir_V(2),PSTH3Dmodel{k}.PVAJ_preDir_V(3),PSTH3Dmodel{k}.PVAJ_preDir_A(1),PSTH3Dmodel{k}.PVAJ_preDir_A(2),PSTH3Dmodel{k}.PVAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.PVAJ_Delay_VA = PSTH3Dmodel{k}.modelFitPara_PVAJ(23);
                PSTH3Dmodel{k}.PVAJ_Delay_JA = PSTH3Dmodel{k}.modelFitPara_PVAJ(24);
                PSTH3Dmodel{k}.PVAJ_Delay_PA = PSTH3Dmodel{k}.modelFitPara_PVAJ(25);
            end
            
        elseif sum(ismember(models,'PVAJ')) == 0
            PSTH3Dmodel{k}.PVAJ_wV = nan;
            PSTH3Dmodel{k}.PVAJ_wA = nan;
            PSTH3Dmodel{k}.PVAJ_wJ = nan;
            PSTH3Dmodel{k}.PVAJ_wP = nan;
            PSTH3Dmodel{k}.PVAJ_preDir_V = nan*ones(1,3);
            PSTH3Dmodel{k}.PVAJ_preDir_A = nan*ones(1,3);
            PSTH3Dmodel{k}.PVAJ_angleDiff_VA = nan;
            PSTH3Dmodel{k}.RSquared_PVAJ = nan;
            PSTH3Dmodel{k}.BIC_PVAJ = nan;
            PSTH3Dmodel{k}.modelFitPara_PVAJ = nan*ones(1,22);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.PVAJ_Delay_VA = nan;
                PSTH3Dmodel{k}.PVAJ_Delay_JA = nan;
                PSTH3Dmodel{k}.PVAJ_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VAJ')) ~= 0
            if sum(ismember(models,'AJ')) ~= 0
                PSTH3Dmodel{k}.VAJ_R2V = ((PSTH3Dmodel{k}.RSquared_VAJ)^2 - (PSTH3Dmodel{k}.RSquared_AJ)^2)/(1-(PSTH3Dmodel{k}.RSquared_AJ)^2);
            else
                PSTH3Dmodel{k}.VAJ_R2V = nan;
            end
            if sum(ismember(models,'VJ')) ~= 0
                PSTH3Dmodel{k}.VAJ_R2A = ((PSTH3Dmodel{k}.RSquared_VAJ)^2 - (PSTH3Dmodel{k}.RSquared_VJ)^2)/(1-(PSTH3Dmodel{k}.RSquared_VJ)^2);
            else
                PSTH3Dmodel{k}.VAJ_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH3Dmodel{k}.VAJ_R2J = ((PSTH3Dmodel{k}.RSquared_VAJ)^2 - (PSTH3Dmodel{k}.RSquared_VA)^2)/(1-(PSTH3Dmodel{k}.RSquared_VA)^2);
            else
                PSTH3Dmodel{k}.VAJ_R2J = nan;
            end
            PSTH3Dmodel{k}.VAJ_wV = PSTH3Dmodel{k}.modelFitPara_VAJ(16)*(1-PSTH3Dmodel{k}.modelFitPara_VAJ(17));
            PSTH3Dmodel{k}.VAJ_wA = (1-PSTH3Dmodel{k}.modelFitPara_VAJ(16))*(1-PSTH3Dmodel{k}.modelFitPara_VAJ(17));
            PSTH3Dmodel{k}.VAJ_wJ = PSTH3Dmodel{k}.modelFitPara_VAJ(17);
            [PSTH3Dmodel{k}.VAJ_preDir_V(1),PSTH3Dmodel{k}.VAJ_preDir_V(2),PSTH3Dmodel{k}.VAJ_preDir_V(3)] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VAJ.V);
            [PSTH3Dmodel{k}.VAJ_preDir_A(1),PSTH3Dmodel{k}.VAJ_preDir_A(2),PSTH3Dmodel{k}.VAJ_preDir_A(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VAJ.A);
            PSTH3Dmodel{k}.VAJ_angleDiff_VA = angleDiff(PSTH3Dmodel{k}.VAJ_preDir_V(1),PSTH3Dmodel{k}.VAJ_preDir_V(2),PSTH3Dmodel{k}.VAJ_preDir_V(3),PSTH3Dmodel{k}.VAJ_preDir_A(1),PSTH3Dmodel{k}.VAJ_preDir_A(2),PSTH3Dmodel{k}.VAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VAJ_Delay_VA = PSTH3Dmodel{k}.modelFitPara_VAJ(18);
                PSTH3Dmodel{k}.VAJ_Delay_JA = PSTH3Dmodel{k}.modelFitPara_VAJ(19);
            end
        elseif sum(ismember(models,'VAJ')) == 0
            PSTH3Dmodel{k}.VAJ_wV = nan;
            PSTH3Dmodel{k}.VAJ_wA = nan;
            PSTH3Dmodel{k}.VAJ_wJ = nan;
            PSTH3Dmodel{k}.VAJ_preDir_V = nan*ones(1,3);
            PSTH3Dmodel{k}.VAJ_preDir_A = nan*ones(1,3);
            PSTH3Dmodel{k}.VAJ_angleDiff_VA = nan;
            PSTH3Dmodel{k}.RSquared_VAJ = nan;
            PSTH3Dmodel{k}.BIC_VAJ = nan;
            PSTH3Dmodel{k}.modelFitPara_VAJ = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VAJ_Delay_VA = nan;
                PSTH3Dmodel{k}.VAJ_Delay_JA = nan;
            end
        end
        
        if sum(ismember(models,'VAP')) ~= 0
            if sum(ismember(models,'AP')) ~= 0
                PSTH3Dmodel{k}.VAP_R2V = ((PSTH3Dmodel{k}.RSquared_VAP)^2 - (PSTH3Dmodel{k}.RSquared_AP)^2)/(1-(PSTH3Dmodel{k}.RSquared_AP)^2);
            else
                PSTH3Dmodel{k}.VAP_R2V = nan;
            end
            if sum(ismember(models,'VP')) ~= 0
                PSTH3Dmodel{k}.VAP_R2A = ((PSTH3Dmodel{k}.RSquared_VAP)^2 - (PSTH3Dmodel{k}.RSquared_VP)^2)/(1-(PSTH3Dmodel{k}.RSquared_VP)^2);
            else
                PSTH3Dmodel{k}.VAP_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH3Dmodel{k}.VAP_R2P = ((PSTH3Dmodel{k}.RSquared_VAP)^2 - (PSTH3Dmodel{k}.RSquared_VA)^2)/(1-(PSTH3Dmodel{k}.RSquared_VA)^2);
            else
                PSTH3Dmodel{k}.VAP_R2P = nan;
            end
            PSTH3Dmodel{k}.VAP_wV = PSTH3Dmodel{k}.modelFitPara_VAP(16)*(1-PSTH3Dmodel{k}.modelFitPara_VAP(17));
            PSTH3Dmodel{k}.VAP_wA = (1-PSTH3Dmodel{k}.modelFitPara_VAP(16))*(1-PSTH3Dmodel{k}.modelFitPara_VAP(17));
            PSTH3Dmodel{k}.VAP_wP = PSTH3Dmodel{k}.modelFitPara_VAP(17);
            [PSTH3Dmodel{k}.VAP_preDir_V(1),PSTH3Dmodel{k}.VAP_preDir_V(2),PSTH3Dmodel{k}.VAP_preDir_V(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VAP.V);
            [PSTH3Dmodel{k}.VAP_preDir_A(1),PSTH3Dmodel{k}.VAP_preDir_A(2), PSTH3Dmodel{k}.VAP_preDir_A(3)] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VAP.A);
            PSTH3Dmodel{k}.VAP_angleDiff_VA = angleDiff(PSTH3Dmodel{k}.VAP_preDir_V(1),PSTH3Dmodel{k}.VAP_preDir_V(2),PSTH3Dmodel{k}.VAP_preDir_V(3),PSTH3Dmodel{k}.VAP_preDir_A(1),PSTH3Dmodel{k}.VAP_preDir_A(2),PSTH3Dmodel{k}.VAP_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VAP_Delay_VA = PSTH3Dmodel{k}.modelFitPara_VAP(18);
                PSTH3Dmodel{k}.VAP_Delay_PA = PSTH3Dmodel{k}.modelFitPara_VAP(19);
            end
        elseif sum(ismember(models,'VAP')) == 0
            PSTH3Dmodel{k}.VAP_wV = nan;
            PSTH3Dmodel{k}.VAP_wA = nan;
            PSTH3Dmodel{k}.VAP_wP = nan;
            PSTH3Dmodel{k}.VAP_preDir_V = nan*ones(1,3);
            PSTH3Dmodel{k}.VAP_preDir_A = nan*ones(1,3);
            PSTH3Dmodel{k}.VAP_angleDiff_VA = nan;
            PSTH3Dmodel{k}.RSquared_VAP = nan;
            PSTH3Dmodel{k}.BIC_VAP = nan;
            PSTH3Dmodel{k}.modelFitPara_VAP = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VAP_Delay_VA = nan;
                PSTH3Dmodel{k}.VAP_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VA')) ~= 0
            PSTH3Dmodel{k}.VA_wV = PSTH3Dmodel{k}.modelFitPara_VA(12);
            PSTH3Dmodel{k}.VA_wA = 1-PSTH3Dmodel{k}.modelFitPara_VA(12);
            [PSTH3Dmodel{k}.VA_preDir_V(1),PSTH3Dmodel{k}.VA_preDir_V(2),PSTH3Dmodel{k}.VA_preDir_V(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VA.V);
            [PSTH3Dmodel{k}.VA_preDir_A(1),PSTH3Dmodel{k}.VA_preDir_A(2),PSTH3Dmodel{k}.VA_preDir_A(3) ] = vectorsum(PSTH3Dmodel{k}.modelFitTrans_spatial_VA.A);
            PSTH3Dmodel{k}.VA_angleDiff_VA = angleDiff(PSTH3Dmodel{k}.VA_preDir_V(1),PSTH3Dmodel{k}.VA_preDir_V(2),PSTH3Dmodel{k}.VA_preDir_V(3),PSTH3Dmodel{k}.VA_preDir_A(1),PSTH3Dmodel{k}.VA_preDir_A(2),PSTH3Dmodel{k}.VA_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VA_Delay_VA = PSTH3Dmodel{k}.modelFitPara_VA(13);
            end
            if sum(ismember(models,'AO')) ~= 0
                PSTH3Dmodel{k}.VA_R2V = ((PSTH3Dmodel{k}.RSquared_VA)^2 - (PSTH3Dmodel{k}.RSquared_AO)^2)/(1-(PSTH3Dmodel{k}.RSquared_AO)^2);
            else
                PSTH3Dmodel{k}.VA_R2A = nan;
            end
            if sum(ismember(models,'VO')) ~= 0
                PSTH3Dmodel{k}.VA_R2A = ((PSTH3Dmodel{k}.RSquared_VA)^2 - (PSTH3Dmodel{k}.RSquared_VO)^2)/(1-(PSTH3Dmodel{k}.RSquared_VO)^2);
            else
                PSTH3Dmodel{k}.VA_R2V = nan;
            end
        elseif sum(ismember(models,'VA')) == 0
            PSTH3Dmodel{k}.VA_wV = nan;
            PSTH3Dmodel{k}.VA_wA = nan;
            PSTH3Dmodel{k}.VA_preDir_V = nan*ones(1,3);
            PSTH3Dmodel{k}.VA_preDir_A = nan*ones(1,3);
            PSTH3Dmodel{k}.VA_angleDiff_VA = nan;
            PSTH3Dmodel{k}.RSquared_VA = nan;
            PSTH3Dmodel{k}.BIC_VA = nan;
            PSTH3Dmodel{k}.modelFitPara_VA = nan*ones(1,12);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH3Dmodel{k}.VA_Delay_VA = nan;
            end
        end
        if sum(ismember(models,'VO')) == 0
            PSTH3Dmodel{k}.RSquared_VO = nan;
            PSTH3Dmodel{k}.BIC_VO = nan;
        end
        if sum(ismember(models,'AO')) == 0
            PSTH3Dmodel{k}.RSquared_AO = nan;
            PSTH3Dmodel{k}.BIC_AO = nan;
        end
        if sum(ismember(models,'VJ')) == 0
            PSTH3Dmodel{k}.RSquared_VJ = nan;
            PSTH3Dmodel{k}.BIC_VJ = nan;
        end
        if sum(ismember(models,'AJ')) == 0
            PSTH3Dmodel{k}.RSquared_AJ = nan;
            PSTH3Dmodel{k}.BIC_AJ = nan;
        end
        if sum(ismember(models,'VP')) == 0
            PSTH3Dmodel{k}.RSquared_VP = nan;
            PSTH3Dmodel{k}.BIC_VP = nan;
        end
        if sum(ismember(models,'AP')) == 0
            PSTH3Dmodel{k}.RSquared_AP = nan;
            PSTH3Dmodel{k}.BIC_AP = nan;
        end
%     else
%         PSTH3Dmodel{k} = nan;
%     end
end

%}
%% 1D models nalysis

%{
% model_catg = 'Sync model'; % tau is the same
% model_catg = 'Out-sync model'; % each component has its own tau

% models = {'VA','VO','AO'};
% models_color = {'k','r',colorDBlue};

% models = {'VO','AO','VJ','AJ','VP','AP'};
% models_color = {'r',colorDBlue,colorLRed,colorLBlue,colorLRed,colorLBlue};

models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
models_color = {'r',colorDBlue,colorDGreen,colorLRed,colorLBlue,colorLRed,colorLRed,'k','k','k'};

% models = {'PVAJ'};
% models_color = {'k'};

% models = {'VAJ','VA'};
% models_color = {'k','g'};
%
% models = {'VA','VAJ','VAP','PVAJ'};
% models_color = {'k','k','k','k'};


spon_flag = 0; % 0 means raw data; 1 means mean(raw)-mean(spon) data

% reps = 20;
reps = 2;

for k = 1:length(unique_stimType)
    % for k = 1
    if PSTH.respon_sigTrue(k) == 1
        
        % fit data with raw PSTH data or - spon data
        switch spon_flag
            case 0 %raw data
                models_fitting_1D(model_catg,models,models_color,FILE,SpikeChan, Protocol,k,meanSpon,squeeze(PSTH.spk_data_bin_mean_rate{k}(3,:,stimOnBin:stimOffBin)),PSTH.spk_data_count_mean_rate_all{k}(3,:),PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
            case 1 % - spon data, so meanspon == 0
                PSTH.spk_data_bin_mean_rate{k} = PSTH.spk_data_bin_mean_rate{k} - permute(reshape(repmat(PSTH.spon_spk_data_bin_mean_rate,8,5),[],8,5),[3 2 1]);
                PSTH.spk_data_count_mean_rate_all{k} = PSTH.spk_data_count_mean_rate_all{k} - meanSpkSponMean; % 会出现负值
                %                 PSTH.spon_spk_data_bin_mean_rate = meanSpkSponMean;
                models_fitting_1D(model_catg,models,models_color,FILE,SpikeChan, Protocol,k,0,squeeze(PSTH.spk_data_bin_mean_rate{k}(3,:,stimOnBin:stimOffBin)),PSTH.spk_data_count_mean_rate_all{k}(3,:),PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
        end
        
        if sum(ismember(models,'PVAJ')) ~= 0
            
            PSTH1Dmodel{k}.PVAJ_wP = (1-PSTH1Dmodel{k}.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel{k}.modelFitPara_PVAJ(17))*PSTH1Dmodel{k}.modelFitPara_PVAJ(16);
            PSTH1Dmodel{k}.PVAJ_wV = (1-PSTH1Dmodel{k}.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel{k}.modelFitPara_PVAJ(17))*(1-PSTH1Dmodel{k}.modelFitPara_PVAJ(16));
            PSTH1Dmodel{k}.PVAJ_wA = (1-PSTH1Dmodel{k}.modelFitPara_PVAJ(18))*PSTH1Dmodel{k}.modelFitPara_PVAJ(17);
            PSTH1Dmodel{k}.PVAJ_wJ = PSTH1Dmodel{k}.modelFitPara_PVAJ(18);
            [PSTH1Dmodel{k}.PVAJ_preDir_V(1),PSTH1Dmodel{k}.PVAJ_preDir_V(2),PSTH1Dmodel{k}.PVAJ_preDir_V(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_PVAJ.V);
            [PSTH1Dmodel{k}.PVAJ_preDir_A(1),PSTH1Dmodel{k}.PVAJ_preDir_A(2),PSTH1Dmodel{k}.PVAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_PVAJ.A);
            PSTH1Dmodel{k}.PVAJ_angleDiff_VA = angleDiff(PSTH1Dmodel{k}.PVAJ_preDir_V(1),PSTH1Dmodel{k}.PVAJ_preDir_V(2),PSTH1Dmodel{k}.PVAJ_preDir_V(3),PSTH1Dmodel{k}.PVAJ_preDir_A(1),PSTH1Dmodel{k}.PVAJ_preDir_A(2),PSTH1Dmodel{k}.PVAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.PVAJ_Delay_VA = PSTH1Dmodel{k}.modelFitPara_PVAJ(19);
                PSTH1Dmodel{k}.PVAJ_Delay_JA = PSTH1Dmodel{k}.modelFitPara_PVAJ(20);
                PSTH1Dmodel{k}.PVAJ_Delay_PA = PSTH1Dmodel{k}.modelFitPara_PVAJ(21);
            end
            
        elseif sum(ismember(models,'PVAJ')) == 0
            PSTH1Dmodel{k}.PVAJ_wV = nan;
            PSTH1Dmodel{k}.PVAJ_wA = nan;
            PSTH1Dmodel{k}.PVAJ_wJ = nan;
            PSTH1Dmodel{k}.PVAJ_wP = nan;
            PSTH1Dmodel{k}.PVAJ_preDir_V = nan*ones(1,3);
            PSTH1Dmodel{k}.PVAJ_preDir_A = nan*ones(1,3);
            PSTH1Dmodel{k}.PVAJ_angleDiff_VA = nan;
            PSTH1Dmodel{k}.RSquared_PVAJ = nan;
            PSTH1Dmodel{k}.BIC_PVAJ = nan;
            PSTH1Dmodel{k}.modelFitPara_PVAJ = nan*ones(1,22);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.PVAJ_Delay_VA = nan;
                PSTH1Dmodel{k}.PVAJ_Delay_JA = nan;
                PSTH1Dmodel{k}.PVAJ_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VAJ')) ~= 0
            if sum(ismember(models,'AJ')) ~= 0
                PSTH1Dmodel{k}.VAJ_R2V = ((PSTH1Dmodel{k}.RSquared_VAJ)^2 - (PSTH1Dmodel{k}.RSquared_AJ)^2)/(1-(PSTH1Dmodel{k}.RSquared_AJ)^2);
            else
                PSTH1Dmodel{k}.VAJ_R2V = nan;
            end
            if sum(ismember(models,'VJ')) ~= 0
                PSTH1Dmodel{k}.VAJ_R2A = ((PSTH1Dmodel{k}.RSquared_VAJ)^2 - (PSTH1Dmodel{k}.RSquared_VJ)^2)/(1-(PSTH1Dmodel{k}.RSquared_VJ)^2);
            else
                PSTH1Dmodel{k}.VAJ_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH1Dmodel{k}.VAJ_R2J = ((PSTH1Dmodel{k}.RSquared_VAJ)^2 - (PSTH1Dmodel{k}.RSquared_VA)^2)/(1-(PSTH1Dmodel{k}.RSquared_VA)^2);
            else
                PSTH1Dmodel{k}.VAJ_R2J = nan;
            end
            PSTH1Dmodel{k}.VAJ_wV = PSTH1Dmodel{k}.modelFitPara_VAJ(13)*(1-PSTH1Dmodel{k}.modelFitPara_VAJ(14));
            PSTH1Dmodel{k}.VAJ_wA = (1-PSTH1Dmodel{k}.modelFitPara_VAJ(13))*(1-PSTH1Dmodel{k}.modelFitPara_VAJ(14));
            PSTH1Dmodel{k}.VAJ_wJ = PSTH1Dmodel{k}.modelFitPara_VAJ(14);
            [PSTH1Dmodel{k}.VAJ_preDir_V(1),PSTH1Dmodel{k}.VAJ_preDir_V(2),PSTH1Dmodel{k}.VAJ_preDir_V(3)] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VAJ.V);
            [PSTH1Dmodel{k}.VAJ_preDir_A(1),PSTH1Dmodel{k}.VAJ_preDir_A(2),PSTH1Dmodel{k}.VAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VAJ.A);
            PSTH1Dmodel{k}.VAJ_angleDiff_VA = angleDiff(PSTH1Dmodel{k}.VAJ_preDir_V(1),PSTH1Dmodel{k}.VAJ_preDir_V(2),PSTH1Dmodel{k}.VAJ_preDir_V(3),PSTH1Dmodel{k}.VAJ_preDir_A(1),PSTH1Dmodel{k}.VAJ_preDir_A(2),PSTH1Dmodel{k}.VAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VAJ_Delay_VA = PSTH1Dmodel{k}.modelFitPara_VAJ(15);
                PSTH1Dmodel{k}.VAJ_Delay_JA = PSTH1Dmodel{k}.modelFitPara_VAJ(16);
            end
        elseif sum(ismember(models,'VAJ')) == 0
            PSTH1Dmodel{k}.VAJ_wV = nan;
            PSTH1Dmodel{k}.VAJ_wA = nan;
            PSTH1Dmodel{k}.VAJ_wJ = nan;
            PSTH1Dmodel{k}.VAJ_preDir_V = nan*ones(1,3);
            PSTH1Dmodel{k}.VAJ_preDir_A = nan*ones(1,3);
            PSTH1Dmodel{k}.VAJ_angleDiff_VA = nan;
            PSTH1Dmodel{k}.RSquared_VAJ = nan;
            PSTH1Dmodel{k}.BIC_VAJ = nan;
            PSTH1Dmodel{k}.modelFitPara_VAJ = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VAJ_Delay_VA = nan;
                PSTH1Dmodel{k}.VAJ_Delay_JA = nan;
            end
        end
        
        if sum(ismember(models,'VAP')) ~= 0
            if sum(ismember(models,'AP')) ~= 0
                PSTH1Dmodel{k}.VAP_R2V = ((PSTH1Dmodel{k}.RSquared_VAP)^2 - (PSTH1Dmodel{k}.RSquared_AP)^2)/(1-(PSTH1Dmodel{k}.RSquared_AP)^2);
            else
                PSTH1Dmodel{k}.VAP_R2V = nan;
            end
            if sum(ismember(models,'VP')) ~= 0
                PSTH1Dmodel{k}.VAP_R2A = ((PSTH1Dmodel{k}.RSquared_VAP)^2 - (PSTH1Dmodel{k}.RSquared_VP)^2)/(1-(PSTH1Dmodel{k}.RSquared_VP)^2);
            else
                PSTH1Dmodel{k}.VAP_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH1Dmodel{k}.VAP_R2P = ((PSTH1Dmodel{k}.RSquared_VAP)^2 - (PSTH1Dmodel{k}.RSquared_VA)^2)/(1-(PSTH1Dmodel{k}.RSquared_VA)^2);
            else
                PSTH1Dmodel{k}.VAP_R2P = nan;
            end
            PSTH1Dmodel{k}.VAP_wV = PSTH1Dmodel{k}.modelFitPara_VAP(13)*(1-PSTH1Dmodel{k}.modelFitPara_VAP(14));
            PSTH1Dmodel{k}.VAP_wA = (1-PSTH1Dmodel{k}.modelFitPara_VAP(13))*(1-PSTH1Dmodel{k}.modelFitPara_VAP(14));
            PSTH1Dmodel{k}.VAP_wP = PSTH1Dmodel{k}.modelFitPara_VAP(14);
            [PSTH1Dmodel{k}.VAP_preDir_V(1),PSTH1Dmodel{k}.VAP_preDir_V(2),PSTH1Dmodel{k}.VAP_preDir_V(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VAP.V);
            [PSTH1Dmodel{k}.VAP_preDir_A(1),PSTH1Dmodel{k}.VAP_preDir_A(2), PSTH1Dmodel{k}.VAP_preDir_A(3)] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VAP.A);
            PSTH1Dmodel{k}.VAP_angleDiff_VA = angleDiff(PSTH1Dmodel{k}.VAP_preDir_V(1),PSTH1Dmodel{k}.VAP_preDir_V(2),PSTH1Dmodel{k}.VAP_preDir_V(3),PSTH1Dmodel{k}.VAP_preDir_A(1),PSTH1Dmodel{k}.VAP_preDir_A(2),PSTH1Dmodel{k}.VAP_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VAP_Delay_VA = PSTH1Dmodel{k}.modelFitPara_VAP(15);
                PSTH1Dmodel{k}.VAP_Delay_PA = PSTH1Dmodel{k}.modelFitPara_VAP(16);
            end
        elseif sum(ismember(models,'VAP')) == 0
            PSTH1Dmodel{k}.VAP_wV = nan;
            PSTH1Dmodel{k}.VAP_wA = nan;
            PSTH1Dmodel{k}.VAP_wP = nan;
            PSTH1Dmodel{k}.VAP_preDir_V = nan*ones(1,3);
            PSTH1Dmodel{k}.VAP_preDir_A = nan*ones(1,3);
            PSTH1Dmodel{k}.VAP_angleDiff_VA = nan;
            PSTH1Dmodel{k}.RSquared_VAP = nan;
            PSTH1Dmodel{k}.BIC_VAP = nan;
            PSTH1Dmodel{k}.modelFitPara_VAP = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VAP_Delay_VA = nan;
                PSTH1Dmodel{k}.VAP_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VA')) ~= 0
            PSTH1Dmodel{k}.VA_wV = PSTH1Dmodel{k}.modelFitPara_VA(10);
            PSTH1Dmodel{k}.VA_wA = 1-PSTH1Dmodel{k}.modelFitPara_VA(10);
            [PSTH1Dmodel{k}.VA_preDir_V(1),PSTH1Dmodel{k}.VA_preDir_V(2),PSTH1Dmodel{k}.VA_preDir_V(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VA.V);
            [PSTH1Dmodel{k}.VA_preDir_A(1),PSTH1Dmodel{k}.VA_preDir_A(2),PSTH1Dmodel{k}.VA_preDir_A(3) ] = vectorsum(PSTH1Dmodel{k}.modelFitTrans_spatial_VA.A);
            PSTH1Dmodel{k}.VA_angleDiff_VA = angleDiff(PSTH1Dmodel{k}.VA_preDir_V(1),PSTH1Dmodel{k}.VA_preDir_V(2),PSTH1Dmodel{k}.VA_preDir_V(3),PSTH1Dmodel{k}.VA_preDir_A(1),PSTH1Dmodel{k}.VA_preDir_A(2),PSTH1Dmodel{k}.VA_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VA_Delay_VA = PSTH1Dmodel{k}.modelFitPara_VA(11);
            end
            if sum(ismember(models,'AO')) ~= 0
                PSTH1Dmodel{k}.VA_R2V = ((PSTH1Dmodel{k}.RSquared_VA)^2 - (PSTH1Dmodel{k}.RSquared_AO)^2)/(1-(PSTH1Dmodel{k}.RSquared_AO)^2);
            else
                PSTH1Dmodel{k}.VA_R2A = nan;
            end
            if sum(ismember(models,'VO')) ~= 0
                PSTH1Dmodel{k}.VA_R2A = ((PSTH1Dmodel{k}.RSquared_VA)^2 - (PSTH1Dmodel{k}.RSquared_VO)^2)/(1-(PSTH1Dmodel{k}.RSquared_VO)^2);
            else
                PSTH1Dmodel{k}.VA_R2V = nan;
            end
        elseif sum(ismember(models,'VA')) == 0
            PSTH1Dmodel{k}.VA_wV = nan;
            PSTH1Dmodel{k}.VA_wA = nan;
            PSTH1Dmodel{k}.VA_preDir_V = nan*ones(1,3);
            PSTH1Dmodel{k}.VA_preDir_A = nan*ones(1,3);
            PSTH1Dmodel{k}.VA_angleDiff_VA = nan;
            PSTH1Dmodel{k}.RSquared_VA = nan;
            PSTH1Dmodel{k}.BIC_VA = nan;
            PSTH1Dmodel{k}.modelFitPara_VA = nan*ones(1,12);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel{k}.VA_Delay_VA = nan;
            end
        end
        if sum(ismember(models,'VO')) == 0
            PSTH1Dmodel{k}.RSquared_VO = nan;
            PSTH1Dmodel{k}.BIC_VO = nan;
        end
        if sum(ismember(models,'AO')) == 0
            PSTH1Dmodel{k}.RSquared_AO = nan;
            PSTH1Dmodel{k}.BIC_AO = nan;
        end
        if sum(ismember(models,'VJ')) == 0
            PSTH1Dmodel{k}.RSquared_VJ = nan;
            PSTH1Dmodel{k}.BIC_VJ = nan;
        end
        if sum(ismember(models,'AJ')) == 0
            PSTH1Dmodel{k}.RSquared_AJ = nan;
            PSTH1Dmodel{k}.BIC_AJ = nan;
        end
        if sum(ismember(models,'VP')) == 0
            PSTH1Dmodel{k}.RSquared_VP = nan;
            PSTH1Dmodel{k}.BIC_VP = nan;
        end
        if sum(ismember(models,'AP')) == 0
            PSTH1Dmodel{k}.RSquared_AP = nan;
            PSTH1Dmodel{k}.BIC_AP = nan;
        end
    else
        PSTH1Dmodel{k} = nan;
    end
end

%}
%% Data Saving

% Reorganized. HH20141124
config.batch_flag = batch_flag;

% Output information for test. HH20160415
if isempty(batch_flag)
    config.batch_flag = 'test.m';
    disp('Saving results to \batch\test\ ');
end

%%%%%%%%%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = PackResult(FILE, PATH, SpikeChan, unique_stimType,Protocol, ... % Obligatory!!
    unique_azimuth, unique_elevation, unique_amplitude, unique_duration,...   % paras' info of trial
    markers,...
    timeWin, timeStep, tOffset1, tOffset2,nBins,Bin,PCAStep,PCAWin,nBinsPCA, ... % PSTH slide window info
    meanSpon, p_anova_dire, DDI,preferDire,PSTH,p_anova_dire_t,DDI_t,DDI_p_t,preferDire_t, ... % PSTH and mean FR info
    PSTH3Dmodel,PSTH1Dmodel); % model info

switch Protocol
    case DIRECTION_TUNING_3D
        config.suffix = 'PSTH_T';
    case ROTATION_TUNING_3D
        config.suffix = 'PSTH_R';
end

if isempty(model_catg)
    config.xls_column_begin = 'meanSpon';
            config.xls_column_end = 'SigDireNum_vis';
            % config.xls_column_end = 'end';
            % figures to save
            config.save_figures = [];
            
            % Only once
            config.sprint_once_marker = {'0.2f'};
            config.sprint_once_contents = 'result.meanSpon';
            
            % loop across stim_type
            config.sprint_loop_marker = {{'0.0f','0.0f','0.2f','g'};
                {'d','d','d'};
                };
            config.sprint_loop_contents = {'result.preferDire{k}(1), result.preferDire{k}(2),result.DDI(k),result.p_anova_dire(k)';
                'result.PSTH.respon_sigTrue(k),result.PSTH.NoPeaks(k), result.PSTH.sig(k)';};
            
else
    switch model_catg
        case 'Sync model'
            config.xls_column_begin = 'meanSpon';
            config.xls_column_end = 'nP_vis';
            % config.xls_column_end = 'end';
            % figures to save
            config.save_figures = [];
            
            % Only once
            config.sprint_once_marker = {'0.2f'};
            config.sprint_once_contents = 'result.meanSpon';
            
            % loop across stim_type
            config.sprint_loop_marker = {{'0.0f','0.0f','0.2f','g'};
                {'d','d','d'};
                {'0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f',...
                '0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
                '0.1f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f'};
                };
            config.sprint_loop_contents = {'result.preferDire{k}(1), result.preferDire{k}(2),result.DDI(k),result.p_anova_dire(k)';
                'result.PSTH.respon_sigTrue(k),result.PSTH.NoPeaks(k), result.PSTH.sig(k)';
                ['result.PSTH3Dmodel{k}.RSquared_VO,result.PSTH3Dmodel{k}.RSquared_AO,result.PSTH3Dmodel{k}.RSquared_VJ,result.PSTH3Dmodel{k}.RSquared_AJ,result.PSTH3Dmodel{k}.RSquared_VP,result.PSTH3Dmodel{k}.RSquared_AP,result.PSTH3Dmodel{k}.RSquared_VA,result.PSTH3Dmodel{k}.RSquared_VAP,result.PSTH3Dmodel{k}.RSquared_VAJ,result.PSTH3Dmodel{k}.RSquared_PVAJ,'...
                'result.PSTH3Dmodel{k}.BIC_VO,result.PSTH3Dmodel{k}.BIC_AO,result.PSTH3Dmodel{k}.BIC_VJ,result.PSTH3Dmodel{k}.BIC_AJ,result.PSTH3Dmodel{k}.BIC_VP,result.PSTH3Dmodel{k}.BIC_AP,result.PSTH3Dmodel{k}.BIC_VA,result.PSTH3Dmodel{k}.BIC_VAP,result.PSTH3Dmodel{k}.BIC_VAJ,result.PSTH3Dmodel{k}.BIC_PVAJ,'...
                'result.PSTH3Dmodel{k}.modelFitPara_VAJ(2),result.PSTH3Dmodel{k}.modelFitPara_VAJ(3),result.PSTH3Dmodel{k}.VAJ_wV,result.PSTH3Dmodel{k}.VAJ_wA,result.PSTH3Dmodel{k}.VAJ_wJ,result.PSTH3Dmodel{k}.VAJ_preDir_V(1),result.PSTH3Dmodel{k}.VAJ_preDir_V(2),result.PSTH3Dmodel{k}.VAJ_preDir_A(1),result.PSTH3Dmodel{k}.VAJ_preDir_A(2),result.PSTH3Dmodel{k}.VAJ_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VAJ(4),result.PSTH3Dmodel{k}.modelFitPara_VAJ(8),result.PSTH3Dmodel{k}.modelFitPara_VAJ(12),'...
                'result.PSTH3Dmodel{k}.modelFitPara_VA(2),result.PSTH3Dmodel{k}.modelFitPara_VA(3),result.PSTH3Dmodel{k}.VA_wV,result.PSTH3Dmodel{k}.VA_wA,result.PSTH3Dmodel{k}.VA_preDir_V(1),result.PSTH3Dmodel{k}.VA_preDir_V(2),result.PSTH3Dmodel{k}.VA_preDir_A(1),result.PSTH3Dmodel{k}.VA_preDir_A(2),result.PSTH3Dmodel{k}.VA_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VA(4),result.PSTH3Dmodel{k}.modelFitPara_VA(8),'...
                'result.PSTH3Dmodel{k}.modelFitPara_VAP(2),result.PSTH3Dmodel{k}.modelFitPara_VAP(3),result.PSTH3Dmodel{k}.VAP_wV,result.PSTH3Dmodel{k}.VAP_wA,result.PSTH3Dmodel{k}.VAP_wP,result.PSTH3Dmodel{k}.VAP_preDir_V(1),result.PSTH3Dmodel{k}.VAP_preDir_V(2),result.PSTH3Dmodel{k}.VAP_preDir_A(1),result.PSTH3Dmodel{k}.VAP_preDir_A(2),result.PSTH3Dmodel{k}.VAP_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VAP(4),result.PSTH3Dmodel{k}.modelFitPara_VAP(8),result.PSTH3Dmodel{k}.modelFitPara_VAP(12),'...
                'result.PSTH3Dmodel{k}.modelFitPara_PVAJ(2),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(3),result.PSTH3Dmodel{k}.PVAJ_wV,result.PSTH3Dmodel{k}.PVAJ_wA,result.PSTH3Dmodel{k}.PVAJ_wJ,result.PSTH3Dmodel{k}.PVAJ_wP,result.PSTH3Dmodel{k}.PVAJ_preDir_V(1),result.PSTH3Dmodel{k}.PVAJ_preDir_V(2),result.PSTH3Dmodel{k}.PVAJ_preDir_A(1),result.PSTH3Dmodel{k}.PVAJ_preDir_A(2),result.PSTH3Dmodel{k}.PVAJ_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_PVAJ(4),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(8),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(12),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(16)']};
            
        case 'Out-sync model'
            config.xls_column_begin = 'meanSpon';
            config.xls_column_end = 'Delay_P_to_A_vis';
            % config.xls_column_end = 'end';
            % figures to save
            config.save_figures = [];
            
            % Only once
            config.sprint_once_marker = {'0.2f'};
            config.sprint_once_contents = 'result.meanSpon';
            
            % loop across stim_type
            config.sprint_loop_marker = {{'0.0f','0.0f','0.2f','g'};
                {'d','d','d'};
                {'0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f','0.2f',...
                '0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.3f','0.3f',...
                '0.1f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.3f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.3f','0.3f',...
                '0.1f','0.2f','0.2f','0.2f','0.2f','0.2f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.0f','0.3f','0.3f','0.3f'};
                };
            config.sprint_loop_contents = {'result.preferDire{k}(1), result.preferDire{k}(2),result.DDI(k),result.p_anova_dire(k)';
                'result.PSTH.respon_sigTrue(k),result.PSTH.NoPeaks(k), result.PSTH.sig(k)';
                ['result.PSTH3Dmodel{k}.RSquared_VO,result.PSTH3Dmodel{k}.RSquared_AO,result.PSTH3Dmodel{k}.RSquared_VJ,result.PSTH3Dmodel{k}.RSquared_AJ,result.PSTH3Dmodel{k}.RSquared_VP,result.PSTH3Dmodel{k}.RSquared_AP,result.PSTH3Dmodel{k}.RSquared_VA,result.PSTH3Dmodel{k}.RSquared_VAP,result.PSTH3Dmodel{k}.RSquared_VAJ,result.PSTH3Dmodel{k}.RSquared_PVAJ,'...
                'result.PSTH3Dmodel{k}.BIC_VO,result.PSTH3Dmodel{k}.BIC_AO,result.PSTH3Dmodel{k}.BIC_VJ,result.PSTH3Dmodel{k}.BIC_AJ,result.PSTH3Dmodel{k}.BIC_VP,result.PSTH3Dmodel{k}.BIC_AP,result.PSTH3Dmodel{k}.BIC_VA,result.PSTH3Dmodel{k}.BIC_VAP,result.PSTH3Dmodel{k}.BIC_VAJ,result.PSTH3Dmodel{k}.BIC_PVAJ,'...
                'result.PSTH3Dmodel{k}.modelFitPara_VAJ(2),result.PSTH3Dmodel{k}.modelFitPara_VAJ(3),result.PSTH3Dmodel{k}.VAJ_wV,result.PSTH3Dmodel{k}.VAJ_wA,result.PSTH3Dmodel{k}.VAJ_wJ,result.PSTH3Dmodel{k}.VAJ_preDir_V(1),result.PSTH3Dmodel{k}.VAJ_preDir_V(2),result.PSTH3Dmodel{k}.VAJ_preDir_A(1),result.PSTH3Dmodel{k}.VAJ_preDir_A(2),result.PSTH3Dmodel{k}.VAJ_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VAJ(4),result.PSTH3Dmodel{k}.modelFitPara_VAJ(8),result.PSTH3Dmodel{k}.modelFitPara_VAJ(12),result.PSTH3Dmodel{k}.VAJ_Delay_VA,result.PSTH3Dmodel{k}.VAJ_Delay_JA,'...
                'result.PSTH3Dmodel{k}.modelFitPara_VA(2),result.PSTH3Dmodel{k}.modelFitPara_VA(3),result.PSTH3Dmodel{k}.VA_wV,result.PSTH3Dmodel{k}.VA_wA,result.PSTH3Dmodel{k}.VA_preDir_V(1),result.PSTH3Dmodel{k}.VA_preDir_V(2),result.PSTH3Dmodel{k}.VA_preDir_A(1),result.PSTH3Dmodel{k}.VA_preDir_A(2),result.PSTH3Dmodel{k}.VA_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VA(4),result.PSTH3Dmodel{k}.modelFitPara_VA(8),result.PSTH3Dmodel{k}.VA_Delay_VA,'...
                'result.PSTH3Dmodel{k}.modelFitPara_VAP(2),result.PSTH3Dmodel{k}.modelFitPara_VAP(3),result.PSTH3Dmodel{k}.VAP_wV,result.PSTH3Dmodel{k}.VAP_wA,result.PSTH3Dmodel{k}.VAP_wP,result.PSTH3Dmodel{k}.VAP_preDir_V(1),result.PSTH3Dmodel{k}.VAP_preDir_V(2),result.PSTH3Dmodel{k}.VAP_preDir_A(1),result.PSTH3Dmodel{k}.VAP_preDir_A(2),result.PSTH3Dmodel{k}.VAP_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_VAP(4),result.PSTH3Dmodel{k}.modelFitPara_VAP(8),result.PSTH3Dmodel{k}.modelFitPara_VAP(12),result.PSTH3Dmodel{k}.VAP_Delay_VA,result.PSTH3Dmodel{k}.VAP_Delay_PA,'...
                'result.PSTH3Dmodel{k}.modelFitPara_PVAJ(2),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(3),result.PSTH3Dmodel{k}.PVAJ_wV,result.PSTH3Dmodel{k}.PVAJ_wA,result.PSTH3Dmodel{k}.PVAJ_wJ,result.PSTH3Dmodel{k}.PVAJ_wP,result.PSTH3Dmodel{k}.PVAJ_preDir_V(1),result.PSTH3Dmodel{k}.PVAJ_preDir_V(2),result.PSTH3Dmodel{k}.PVAJ_preDir_A(1),result.PSTH3Dmodel{k}.PVAJ_preDir_A(2),result.PSTH3Dmodel{k}.PVAJ_angleDiff_VA,result.PSTH3Dmodel{k}.modelFitPara_PVAJ(4),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(8),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(12),result.PSTH3Dmodel{k}.modelFitPara_PVAJ(16),result.PSTH3Dmodel{k}.PVAJ_Delay_VA,result.PSTH3Dmodel{k}.PVAJ_Delay_JA,result.PSTH3Dmodel{k}.PVAJ_Delay_PA']};
            
    end
end
config.append = 1; % Overwrite or append
% keyboard;
SaveResult(config, result,model_catg);

% toc;
end