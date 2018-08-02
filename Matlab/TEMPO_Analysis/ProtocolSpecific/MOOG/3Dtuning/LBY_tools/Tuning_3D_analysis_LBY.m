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


global PSTH3Dmodel PSTH;
PSTH3Dmodel = [];PSTH = [];

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
% tOffset1 = 000; % in ms
% tOffset2 = 000; % in ms

if strcmp(PSTH.monkey ,'MSTd') == 1
    delay = 115; % in ms, MSTd, 1806
    %for MSTd delay is 100 ms
    aMax = 770; % in ms, peak acceleration time, measured time
    aMin = 1250; % in ms, trough acceleration time, measured time
else % for PCC
    delay = 200; % in ms, system time delay, LBY added, 180523
    aMax = 530; % in ms, peak acceleration time relative to stim on, measured time
    aMin = 900; % in ms, trough acceleration time relative to stim on, measured time
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
                PSTH.spk_data_bin_rate_aov{k,pc} = [];% for PSTH ANOVA
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
            try
            PSTH.spk_data_bin_rate{k,j,i} = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spk_data{k,j,i}(:,:), 2, gau_sig);
            PSTH.spk_data_bin_rate_aov{k,pc}(:,:) = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spk_data{k,j,i}(:,:), 2, gau_sig);
            PSTH.spk_data_bin_mean_rate_aov{k}(pc,:) = mean(PSTH.spk_data_bin_rate_aov{k,pc}(:,:),2);
            
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
            
            catch
                keyboard;
            end
            % pack data for contour
            try
                PSTH.spk_data_count_rate{k,j,i} = sum(spk_data{k,j,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000); % rates
                PSTH.spk_data_count_mean_rate{k}(j,i) = mean(PSTH.spk_data_count_rate{k,j,i}(:));% for countour plot and ANOVA
                PSTH.spk_data_vector{k} = PSTH.spk_data_count_mean_rate{k}; % for preferred direction
                PSTH.spk_data_vector{k}([1,5],2:end) = 0;
                PSTH.spk_data_count_rate_all{k,j,i} = sum(spk_data{k,j,i}(stimOnT(1):stimOffT(1),:),1)/(unique_duration(1,1)/1000); % rates of all duration
                PSTH.spk_data_count_mean_rate_all{k}(j,i) = mean(PSTH.spk_data_count_rate_all{k,j,i}(:));% for models
            catch
                keyboard;
            end
        end
    end
    
    % preliminary analysis
    PSTH.time_profile{k} = squeeze(sum(sum(PSTH.spk_data_bin_mean_rate{k}(j,i,:),1),2));
    
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
    [Azi, Ele, Amp] = vectorsum(squeeze(PSTH.spk_data_vector{k}(:,:)));
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
% wilcoxon rank sum test
% 500 ms after stim. on to 50ms before stim off

baselineBinBeg = stimOnBin-floor(100/timeStep);
baselineBinEnd = stimOnBin+floor(300/timeStep);

for k = 1:length(unique_stimType)
    spk_data_bin_rate_mean_minusSpon{k} = PSTH.spk_data_bin_mean_rate_aov{k}-repmat(PSTH.spon_spk_data_bin_mean_rate',size(PSTH.spk_data_bin_mean_rate_aov{k},1),1);
    % significant temporal modulation (response to the stimulus)
    peak{k} = [];
    PSTH.peak{k} = []; % location of peaks
    peak_DS{k} = [];
    PSTH.peak_DS{k} = []; % location of peaks for direction tuning
    PSTH.respon_sigTrue(k) = 0; % PSTH.sigTrue(pc) -> sig. of this cell
    for pc = 1:size(PSTH.spk_data_bin_rate_aov,2)
        PSTH.sigBin{k,pc} = []; % find if this bin is sig.
        PSTH.sigTrue{k}(pc) = 0; % PSTH.sigTrue(pc) -> sig. of this direction
        %         PSTH.respon_sigTrue(k) = 0; % PSTH.sigTrue(pc) -> sig. of this cell
        PSTH.localPeak{k,pc} = []; % find the local peak bin of each direction
        PSTH.localTrough{k,pc} = []; % find the local trough bin of each direction
        PSTH.s{k,pc} = []; % just for check
        %         peak{k} = [];
        %         PSTH.peak{k} = []; % location of peaks
        %         peak_DS{k} = [];
        %         PSTH.peak_DS{k} = []; % location of peaks for direction tuning
        %         for nn = stimOnBin+500/timeStep : stimOnBin+floor(stimOffBin - stimOnBin)-3
        for nn = stimOnBin : stimOffBin
            PSTH.s{k,pc}(nn) = 0;
            % if 5 consecutive bins are sig.,then we say this bin is sig.
            for ii = nn-2:nn+2
                try
                    if ranksum(squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(ii,:))',squeeze(nanmean(PSTH.spk_data_bin_rate_aov{k,pc}(baselineBinBeg:baselineBinEnd,:)))') < 0.05
                        PSTH.s{k,pc}(nn) =  PSTH.s{k,pc}(nn)+1;
                    end
                catch
                    keyboard;
                end
            end
            if  PSTH.s{k,pc}(nn) == 5
                PSTH.sigBin{k,pc}= [PSTH.sigBin{k,pc};nn]; % find the bin with significant response to the stim.
            end
            
            for ii = 1:length(PSTH.sigBin{k,pc})
                pp = 0;tt = 0;
                if (spk_data_bin_rate_mean_minusSpon{k}(pc,nn)>=spk_data_bin_rate_mean_minusSpon{k}(pc,nn-1)) &&(spk_data_bin_rate_mean_minusSpon{k}(pc,nn)>=spk_data_bin_rate_mean_minusSpon{k}(pc,nn-1))
                    pp = pp+1;
                    PSTH.localPeak{k,pc}(pp,1)= nn; % indicate the bin num.
                    PSTH.localPeak{k,pc}(pp,2) = spk_data_bin_rate_mean_minusSpon{k}(pc,nn); % indicate the mean-value of this peak
                else if (spk_data_bin_rate_mean_minusSpon{k}(pc,nn)<=spk_data_bin_rate_mean_minusSpon{k}(pc,nn-1)) &&(spk_data_bin_rate_mean_minusSpon{k}(pc,nn)<=spk_data_bin_rate_mean_minusSpon{k}(pc,nn-1))
                        tt = tt+1;
                        PSTH.localTrough{k,pc}(tt,1) = nn; % indicate the bin num.
                        PSTH.localTrough{k,pc}(tt,2) = spk_data_bin_rate_mean_minusSpon{k}(pc,nn); % indicate the mean-value of this trough
                    end
                end
            end
        end
        if (~isempty(PSTH.localPeak{k,pc})) || (~isempty(PSTH.localTrough{k,pc}))
            PSTH.sigTrue{k}(pc) = 1; % PSTH.sigTrue(pc) -> sig. of this direction
        end
    end
    
    if respon_True(PSTH.sigTrue{k}(:)) == 1
        PSTH.respon_sigTrue(k) = 1;
        
        %         %%%%%%%%%%% find peaks & DS peaks %%%%%%%%%%%
        
        for nn = stimOnBin-2 : stimOffBin+2
            [Rmax(nn,1),~]= max(mean(PSTH.spk_data_bin_rate_aov{k,pc}(nn,:),3));
            Pmax(nn) = anova1(squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(nn,:))','','off');
        end
        for nn = stimOnBin : stimOffBin
            if (Rmax(nn,1)>Rmax(nn-1,1)) && (Rmax(nn,1)>Rmax(nn+1,1)) && Pmax(nn)<0.05 && Pmax(nn-1)<0.05 && Pmax(nn-2)<0.05 && Pmax(nn+1)<0.05 && Pmax(nn+2)<0.01
                peak_DS{k} = [peak_DS{k},[ Rmax(nn,1);nn]];
            end
            if (Rmax(nn,1)>Rmax(nn-1,1)) && (Rmax(nn,1)>Rmax(nn+1,1))
                peak{k} = [peak{k},[ Rmax(nn,1);nn]];
            end
        end
        if ~isempty(peak{k})
            peak{k} = sortrows(peak{k}',-1)';
            PSTH.peak{k} = peak{k}(2,1); % True peaks
            if length(peak{k})>1
                n = 1;
                while n < size(peak{k},2)
                    ii = n+1;
                    while ii < size(peak{k},2)+1
                        [r,p] = corrcoef(squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(peak{k}(2,n),:)),squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(peak{k}(2,ii),:)));
                        if ~(r(1,2) > 0 && p(1,2) < 0.05)
                            PSTH.peak{k} = [PSTH.peak{k} peak{k}(2,ii)];
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
        if ~isempty(peak_DS{k})
            peak_DS{k} = sortrows(peak_DS{k}',-1)';
            PSTH.peak_DS{k} = peak_DS{k}(2,1); % True peak_DSs
            if length(peak_DS{k})>1
                n = 1;
                while n < size(peak_DS{k},2)
                    ii = n+1;
                    while ii < size(peak_DS{k},2)+1
                        [r,p] = corrcoef(squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(peak_DS{k}(2,n),:)),squeeze(PSTH.spk_data_bin_rate_aov{k,pc}(peak_DS{k}(2,ii),:)));
                        if ~(r(1,2) > 0 && p(1,2) < 0.05)
                            PSTH.peak_DS{k} = [PSTH.peak_DS{k} peak_DS{k}(2,ii)];
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
    end
    PSTH.NoPeaks(k) = length(PSTH.peak{k});
    PSTH.NoDSPeaks(k) = length(PSTH.peak_DS{k});
    PSTH.sig(k) = sum(PSTH.sigTrue{k}(:)); % sig No.of directions
end
%}
%% plot figures
%
% k=1,2,3
% j= -90,-45,0,45,90 (up->down)
% i=0 45 90 135 180 225 270 315

% 270-225-180-135-90-45-0-315-270 for figures
iAzi = [7 6 5 4 3 2 1 8 7];

% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% the lines markers
markers = {
    % markerName % markerTime % marker bin time % color
    %     'FPOnT',FPOnT(1),(FPOnT(1)-PSTH_onT+timeStep)/timeStep,colorDGray;
    %     'stim_on',stimOnT(1),stimOnBin,colorDRed;
    %     'stim_off',stimOffT(1),stimOffBin,colorDRed;
    'aMax',stimOnT(1)+aMax,(stimOnT(1)+aMax-PSTH_onT+timeStep)/timeStep,colorDBlue;
    'aMin',stimOnT(1)+aMin,(stimOnT(1)+aMin-PSTH_onT+timeStep)/timeStep,colorDBlue;
    'v',stimOnT(1)+aMax+(aMin-aMax)/2,(stimOnT(1)+aMax+(aMin-aMax)/2-PSTH_onT+timeStep)/timeStep,'r';
    };

Bin = [nBins,(stimOnT(1)-PSTH_onT+timeStep)/timeStep,(stimOffT(1)-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+719-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+1074-PSTH_onT+timeStep)/timeStep];
% preferDirectionOfTime;
% CosineTuningPlot;
% PSTH_3D_Tuning; % plot PSTHs across sessions;
% Contour_3D_Tuning; % plot countour figures;
% Contour_3D_Tuning_GIF; % plot countour figures(PD across time);
% spatial_tuning;
%% models nalysis
% %{
% model_catg = 'Sync model'; % tau is the same
model_catg = 'Out-sync model'; % each component has its own tau

% models = {'VA','VO','AO'};
% models_color = {'k','r',colorDBlue};

% models = {'VO','AO','VA','VJ','AJ','VAJ'};
% models_color = {'r',colorDBlue,colorDGreen,colorLRed,colorLBlue,'k'};

models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
models_color = {'r',colorDBlue,colorDGreen,colorLRed,colorLBlue,colorLRed,colorLRed,'k','k','k'};

% models = {'AO'};
% models_color = {'k'};

% models = {'VAJ','VA'};
% models_color = {colorDGreen,'k'};

reps = 20;
% reps = 5;
for k = 1:length(unique_stimType)
% for k = 1
    if PSTH.respon_sigTrue(k) == 1
        models_fitting(model_catg,models,models_color,FILE,SpikeChan, Protocol,k,meanSpon,PSTH.spk_data_bin_mean_rate{k}(:,:,stimOnBin:stimOffBin),PSTH.spk_data_count_mean_rate_all{k},PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);        
        if sum(ismember(models,'PVAJ')) ~= 0
            
            PSTH3Dmodel{k}.PVAJ_wP = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(21))*PSTH3Dmodel{k}.modelFitPara_PVAJ(20);
            PSTH3Dmodel{k}.PVAJ_wV = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(21))*(1-PSTH3Dmodel{k}.modelFitPara_PVAJ(20));
            PSTH3Dmodel{k}.PVAJ_wA = (1-PSTH3Dmodel{k}.modelFitPara_PVAJ(22))*PSTH3Dmodel{k}.modelFitPara_PVAJ(21);
            PSTH3Dmodel{k}.PVAJ_wJ = PSTH3Dmodel{k}.modelFitPara_PVAJ(22);
            
        elseif sum(ismember(models,'PVAJ')) == 0
            PSTH3Dmodel{k}.PVAJ_wV = nan;
            PSTH3Dmodel{k}.PVAJ_wA = nan;
            PSTH3Dmodel{k}.PVAJ_wJ = nan;
            PSTH3Dmodel{k}.PVAJ_wP = nan;
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
        elseif sum(ismember(models,'VAJ')) == 0
            PSTH3Dmodel{k}.VAJ_wV = nan;
            PSTH3Dmodel{k}.VAJ_wA = nan;
            PSTH3Dmodel{k}.VAJ_wJ = nan;
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
        elseif sum(ismember(models,'VAP')) == 0
            PSTH3Dmodel{k}.VAP_wV = nan;
            PSTH3Dmodel{k}.VAP_wA = nan;
            PSTH3Dmodel{k}.VAP_wP = nan;
        end
        
        if sum(ismember(models,'VA')) ~= 0
            PSTH3Dmodel{k}.VA_wV = PSTH3Dmodel{k}.modelFitPara_VA(12);
            PSTH3Dmodel{k}.VA_wA = 1-PSTH3Dmodel{k}.modelFitPara_VA(12);
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
        end
        
    else
        PSTH3Dmodel{k} = nan;
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
    timeWin, timeStep, tOffset1, tOffset2,nBins,Bin, ... % PSTH slide window info
    meanSpon, p_anova_dire, DDI,preferDire,PSTH,... % PSTH and mean FR info
    PSTH3Dmodel); % model info

switch Protocol
    case DIRECTION_TUNING_3D
        config.suffix = 'PSTH_T';
    case ROTATION_TUNING_3D
        config.suffix = 'PSTH_R';
end
config.xls_column_begin = 'meanSpon';
config.xls_column_end = 'R2A_vis';
% figures to save
config.save_figures = [];

% Only once
config.sprint_once_marker = {'0.2f'};
config.sprint_once_contents = 'result.meanSpon';

% loop across stim_type
config.sprint_loop_marker = {{'0.0f','0.0f','0.2f','g'};
    {'d','d','d'};
    {'0.2f','0.2f','0.2f','0.2f','0.2f','0.2f',...
    '0.0f','0.0f','0.0f','0.0f','0.0f','0.0f',...
    '0.1f','0.2f','0.2f','0.2f','0.2f','0.2f',...
    '0.2f','0.2f','0.2f',...
    '0.1f','0.2f','0.2f','0.2f','0.2f',...
    '0.2f','0.2f'};
    };
config.sprint_loop_contents = {'result.preferDire{k}(1), result.preferDire{k}(2),result.DDI(k),result.p_anova_dire(k)';
    'result.PSTH.respon_sigTrue(k),result.PSTH.NoDSPeaks(k), result.PSTH.sig(k)';
    ['result.PSTH3Dmodel{k}.RSquared_VO,result.PSTH3Dmodel{k}.RSquared_AO,result.PSTH3Dmodel{k}.RSquared_VA,result.PSTH3Dmodel{k}.RSquared_VJ,result.PSTH3Dmodel{k}.RSquared_AJ,result.PSTH3Dmodel{k}.RSquared_VAJ,'...
    'result.PSTH3Dmodel{k}.BIC_VO,result.PSTH3Dmodel{k}.BIC_AO,result.PSTH3Dmodel{k}.BIC_VA,result.PSTH3Dmodel{k}.BIC_VJ,result.PSTH3Dmodel{k}.BIC_AJ,result.PSTH3Dmodel{k}.BIC_VAJ,'...
    'result.PSTH3Dmodel{k}.modelFitPara_VAJ(2),result.PSTH3Dmodel{k}.modelFitPara_VAJ(3),result.PSTH3Dmodel{k}.modelFitPara_VAJ(4),result.PSTH3Dmodel{k}.VAJ_wV,result.PSTH3Dmodel{k}.VAJ_wA,result.PSTH3Dmodel{k}.VAJ_wJ,'...
    'result.PSTH3Dmodel{k}.VAJ_R2V,result.PSTH3Dmodel{k}.VAJ_R2A,result.PSTH3Dmodel{k}.VAJ_R2J,'...
    'result.PSTH3Dmodel{k}.modelFitPara_VA(2),result.PSTH3Dmodel{k}.modelFitPara_VA(3),result.PSTH3Dmodel{k}.modelFitPara_VA(4),result.PSTH3Dmodel{k}.VA_wV,result.PSTH3Dmodel{k}.VA_wA,'...
    'result.PSTH3Dmodel{k}.VA_R2V,result.PSTH3Dmodel{k}.VA_R2A']};

config.append = 1; % Overwrite or append

SaveResult(config, result);

end