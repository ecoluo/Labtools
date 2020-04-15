% To compare grating and optic flow in the fronto-parallel plane
% @LBY, Gu lab, 202003



function Grating_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, ~, StopOffset, PATH, FILE, batch_flag)

% tic;

global PSTH1Dmodel PSTH;
PSTH = []; PSTH1Dmodel = [];

% contains protocol etc. specific keywords
TEMPO_Defs;
Path_Defs;
ProtocolDefs;

% grating or optic flow
stimType{1}='Gratings';
stimType{2}='OpticFlow';

PSTH.monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch PSTH.monkey_inx
    case '5'
        PSTH.monkey = 'Polo';
    case '6'
        PSTH.monkey = 'Qiaoqiao';
end


%% get data
% stimulus type,azi,ele,amp and duration

% temporarily, for htb missing cells
if data.one_time_params(NULL_VALUE) == 0
    data.one_time_params(NULL_VALUE) = -9999;
end

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
spon_trials = select_trials & (data.moog_params(STIMULUS_TYPE,trials,MOOG) == data.one_time_params(NULL_VALUE));
real_trials = select_trials & (~(data.moog_params(STIMULUS_TYPE,trials,MOOG) == data.one_time_params(NULL_VALUE)));

temp_amplitude = data.moog_params(AMPLITUDE,real_trials,MOOG);
temp_stimType = data.moog_params(STIMULUS_TYPE,real_trials,MOOG);
temp_tempFre = data.moog_params(GRATE_TEMPFREQ,real_trials,MOOG);
temp_spatFre = data.moog_params(GRATE_FREQ,real_trials,MOOG);
temp_orient = data.moog_params(GRATE_ORIENTATION,real_trials,MOOG);

temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms

unique_amplitude = munique(temp_amplitude');
unique_duration = munique(temp_duration');
unique_stimType = munique(temp_stimType');
unique_tempFre = munique(temp_tempFre');
unique_tempFre(unique_tempFre == 0) = [];
unique_spatFre = munique(temp_spatFre');
unique_spatFre(unique_spatFre == 0) = [];
unique_orient = munique(temp_orient');

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

max_reps = ceil(sum(real_trials)/((length(unique_spatFre)*length(unique_tempFre)+length(unique_stimType)-1)*length(unique_orient))); % fake max repetations
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


delay = 155; % in ms, system time delay, LBY modified, 200311.real velocity peak-theoretical veolocity peak
aMax = 575; % in ms, peak acceleration time relative to real stim on time, measured time
aMin = 940; % in ms, trough acceleration time relative to real stim on time, measured time

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

%%%%%%%%%%%%% for optic flow
% %{

pc_opt = 0;

% initialize
% for contour
PSTH.opt_mean_rate = [];

% PSTH
PSTH.opt_bin_mean_rate = []; % mean spike count per time window (for PSTH) % 1*nbins
opt_bin_mean_rate_std = [];
PSTH.opt_bin_mean_rate_ste = [];
PSTH.opt_bin_rate_aov = [];% for PSTH ANOVA

PSTH.opt_bin_rate_aov = nan*ones(8,nBins,max_reps);

for i = 1:length(unique_orient)
    % initialize
    % for contour
    PSTH.opt_rate{i} = [];
    PSTH.opt_rate_all{i} = [];
    
    opt_data{i} = []; % raw spike count (transform spike_data to a more clear way)
    PSTH.opt_bin_rate{i} = []; % spike counts per time window (for PSTH across trials)
    
    % find specified conditions with repetitions -> pack the data
    select = find((temp_stimType == 2)&(temp_orient == unique_orient(i))) ;
    
    if sum(select)>0
        opt_data{i} = spike_data(:,select);
        pc_opt = pc_opt+1;
        
        % for contour
        opt_rate_anova{pc_opt} = [];
        % PSTH
        opt_rate_anova{pc_opt} =  sum(opt_data{i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000);
        opt_resp_sse(pc_opt) = sum((opt_rate_anova{pc_opt} - mean(opt_rate_anova{pc_opt})).^2); % for DDI
        opt_resp_trialnum(pc_opt)= size(opt_rate_anova{pc_opt},2); % for DDI
    else
        disp('There must be something wrong, no trials for this condition!');
    end
    
    % pack data for PSTH
    PSTH.opt_bin_rate{i} = PSTH_smooth(nBins, PSTH_onT, timeWin, timeStep, opt_data{i}, 2, gau_sig);
    temp = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, opt_data{i}, 2, gau_sig);
    PSTH.opt_bin_rate_aov(pc_opt,:,1:size(temp,2)) = temp;
    temp = PSTH_smooth( nBinsPCA, stimOnT, PCAWin, PCAStep, mean(opt_data{i},2), 1, 0);
    PSTH.opt_bin_rate_PCA(pc_opt,:,1:size(temp,2)) = temp;
    
    %     PSTH.opt_bin_mean_rate_PCA(pc_opt,:) = nanmean(PSTH.opt_bin_rate_PCA(pc_opt,:,:),2);
    %     PSTH.opt_bin_mean_rate_aov(pc_opt,:) = nanmean(PSTH.opt_bin_rate_aov(pc_opt,:,:),2);
    PSTH.opt_bin_mean_rate_PCA(pc_opt,:) = PSTH.opt_bin_rate_PCA(pc_opt,:,:);
    PSTH.opt_bin_mean_rate_aov(pc_opt,:) = nanmean(PSTH.opt_bin_rate_aov(pc_opt,:,:),3);
    
    % calculate correlation coefficient between response and V/A curve
    [R,P] = corrcoef(v_timeProfile,PSTH.opt_bin_mean_rate_aov(pc_opt,:));
    PSTH.coef_v_opt(1,pc_opt) = R(1,2);
    PSTH.coef_v_opt(2,pc_opt) = P(1,2);
    [R,P] = corrcoef(a_timeProfile,PSTH.opt_bin_mean_rate_aov(pc_opt,:));
    PSTH.coef_a_opt(1,pc_opt) = R(1,2);
    PSTH.coef_a_opt(2,pc_opt) = P(1,2);
    
    PSTH.opt_bin_mean_rate(i,:) = mean(PSTH.opt_bin_rate{i},2);
    PSTH.opt_spk_data_bin_vector = PSTH.opt_bin_mean_rate;
    opt_bin_mean_rate_std(i,:) = std(PSTH.opt_bin_rate{i},0,2);
    PSTH.opt_bin_mean_rate_ste(i,:) = opt_bin_mean_rate_std(i,:)/sqrt(size(PSTH.opt_bin_rate{i}(1,:),2));
    
    % pack data for contour
    PSTH.opt_rate{i} = sum(opt_data{i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000); % rates
    PSTH.opt_mean_rate(i) = mean(PSTH.opt_rate{i}(:));% for countour plot and ANOVA
    PSTH.opt_rate_all{i} = sum(opt_data{i}(stimOnT(1):stimOffT(1),:),1)/(unique_duration(1,1)/1000); % rates of all duration
    PSTH.opt_mean_rate_all(i) = mean(PSTH.opt_rate_all{i}(:));% for models
    opt_vector_rate{i} = sum(opt_data{i}(stimOnT(1)+tBeg:stimOnT(1)+tBeg+unique_duration(1,1)/2,:),1)/((unique_duration(1,1)/2)/1000); % rates
    PSTH.opt_vector(i) = mean(opt_vector_rate{i}(:)); % for preferred direction
end

% preliminary analysis

PSTH.opt_time_profile = squeeze(sum(sum(PSTH.opt_bin_mean_rate(i,:),1),2));
PSTH.opt_bin_mean_rate_aov_cell = mean(PSTH.opt_bin_mean_rate_aov,1);
opt_maxSpkRealMean = max(PSTH.opt_mean_rate(:));
opt_minSpkRealMean = min(PSTH.opt_mean_rate(:));
PSTH.opt_maxSpkRealBinMean = max(PSTH.opt_bin_mean_rate(:));
PSTH.opt_minSpkRealBinMean = min(PSTH.opt_bin_mean_rate(:));
PSTH.opt_maxSpkRealBinAll = max(PSTH.opt_bin_rate_aov(:));
PSTH.opt_maxSpkRealBinMeanSte = max(PSTH.opt_bin_mean_rate_ste(:));

% % calculate DDT & preferred directions for tuning
% numReps_opt = max(cell2mat(cellfun(@length,opt_rate_anova,'UniformOutput',false)));
% for nn = 1:length(opt_rate_anova)
%     if length(opt_rate_anova{nn})<numReps_opt
%         opt_rate_anova{nn} = [opt_rate_anova{nn} nan*ones(1,(numReps_opt-length(opt_rate_anova{nn})))];
%     end
% end
% opt_rate_anova_trans = reshape(cell2mat(opt_rate_anova),[numReps_opt,length(opt_rate_anova)]);
% opt_p_anova_dire = anova1(opt_rate_anova_trans,'','off'); % tuning anova
% opt_resp_std = sum(opt_resp_sse)/(sum(opt_resp_trialnum)-8);
% opt_DDI = (opt_maxSpkRealMean-opt_minSpkRealMean)/(opt_maxSpkRealMean-opt_minSpkRealMean+2*sqrt(opt_resp_std));

%}

%%%%%%%%%%%%% for grating

% initialize
% for contour
PSTH.mean_rate= [];

% PSTH
PSTH.bin_mean_rate = []; % mean spike count per time window (for PSTH) % 1*nbins
bin_mean_rate_std = [];
PSTH.bin_mean_rate_ste = [];
PSTH.bin_rate_aov = [];% for PSTH ANOVA

for spa = 1:length(unique_spatFre)
    for tt = 1:length(unique_tempFre)
        PSTH.bin_rate_aov{spa,tt} = nan*ones(length(unique_orient),nBins,max_reps);
        pc = 0;
        for i = 1:length(unique_orient)
            % initialize
            PSTH.rate{spa,tt,i} = [];
            PSTH.rate_all{spa,tt,i} = [];
            spk_data{spa,tt,i} = []; % raw spike count (transform spike_spk_data to a more clear way)
            PSTH.bin_rate{spa,tt,i} = []; % spike counts per time window (for PSTH across trials)
            
            % find specified conditions with repetitions -> pack the data
            select = find((temp_stimType == 1)&(temp_tempFre == unique_tempFre(tt))&(temp_spatFre == unique_spatFre(spa))&(temp_orient == unique_orient(i))) ;
            if sum(select)>0
                spk_data{spa,tt,i} = spike_data(:,select);
                pc = pc+1;
                % for contour
                rate_aov{spa,tt,pc} = [];
                rate_aov{spa,tt,pc} =  sum(spk_data{spa,tt,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000);
                resp_sse(spa,tt,pc) = sum((rate_aov{spa,tt,pc} - mean(rate_aov{spa,tt,pc})).^2); % for DDI
                resp_trialnum(spa,tt,pc)= size(rate_aov{spa,tt,pc},2); % for DDI
            else
                disp('There must be something wrong, no trials for this condition!');
            end
            
            % pack spk_data for PSTH
            
            PSTH.bin_rate{spa,tt,i} = PSTH_smooth(nBins, PSTH_onT, timeWin, timeStep, spk_data{spa,tt,i}, 2, gau_sig);
            temp = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spk_data{spa,tt,i}, 2, gau_sig);
            try
                PSTH.bin_rate_aov{spa,tt}(pc,:,1:size(temp,2)) = temp;
            catch
                keyboard;
            end
            temp = PSTH_smooth( nBinsPCA, stimOnT, PCAWin, PCAStep, mean(spk_data{spa,tt,i},2), 1, 0);
            PSTH.bin_rate_PCA{spa,tt}(pc,:,1:size(temp,2)) = temp;
            
            PSTH.bin_mean_rate_PCA{spa,tt}(pc,:) = nanmean(PSTH.bin_rate_PCA{spa,tt}(pc,:,:),3);
            PSTH.bin_mean_rate_aov{spa,tt}(pc,:) = nanmean(PSTH.bin_rate_aov{spa,tt}(pc,:,:),3);
            
            % calculate correlation coefficient between response and V/A curve
            [R,P] = corrcoef(v_timeProfile,PSTH.bin_mean_rate_aov{spa,tt}(pc,:));
            PSTH.coef_v{spa,tt}(1,pc) = R(1,2);
            PSTH.coef_v{spa,tt}(2,pc) = P(1,2);
            [R,P] = corrcoef(a_timeProfile,PSTH.bin_mean_rate_aov{spa,tt}(pc,:));
            PSTH.coef_a{spa,tt}(1,pc) = R(1,2);
            PSTH.coef_a{spa,tt}(2,pc) = P(1,2);
            
            a = mean(PSTH.bin_rate{spa,tt,i},2);
            PSTH.bin_mean_rate(spa,tt,i,:) = mean(PSTH.bin_rate{spa,tt,i},2);
            PSTH.spk_spk_data_bin_vector = PSTH.bin_mean_rate;
            PSTH.spk_spk_data_bin_vector([1,5],2:end,:) = 0;
            bin_mean_rate_std(spa,tt,i,:) = std(PSTH.bin_rate{spa,tt,i},0,2);
            PSTH.bin_mean_rate_ste(spa,tt,i,:) = bin_mean_rate_std(spa,tt,i,:)/sqrt(size(PSTH.bin_rate{spa,tt,i},2));
            
            % pack spk_data for contour
            PSTH.rate{spa,tt,i} = sum(spk_data{spa,tt,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000); % rates
            PSTH.mean_rate(spa,tt,i) = mean(PSTH.rate{spa,tt,i}(:));% for countour plot and ANOVA
            PSTH.rate_all{spa,tt,i} = sum(spk_data{spa,tt,i}(stimOnT(1):stimOffT(1),:),1)/(unique_duration(1,1)/1000); % rates of all duration
            PSTH.mean_rate_all(spa,tt,i) = mean(PSTH.rate_all{spa,tt,i}(:));% for models
            vector_rate{spa,tt,i} = sum(spk_data{spa,tt,i}(stimOnT(1)+tBeg:stimOnT(1)+tBeg+unique_duration(1,1)/2,:),1)/((unique_duration(1,1)/2)/1000); % rates
            
        end
        % preliminary analysis
        PSTH.time_profile{spa,tt} = squeeze(sum(sum(PSTH.bin_mean_rate(spa,tt,i,:),1),2));
        PSTH.bin_mean_rate_aov_cell{spa,tt} = mean(PSTH.bin_mean_rate_aov{spa,tt},1);
        maxSpkRealMean(spa,tt) = max(PSTH.mean_rate(spa,tt,:));
        minSpkRealMean(spa,tt) = min(PSTH.mean_rate(spa,tt,:));
        PSTH.maxSpkRealbin_mean(spa,tt) = max(max(PSTH.bin_mean_rate(spa,tt,:,:)));
        PSTH.minSpkRealbin_mean(spa,tt) = min(min(PSTH.bin_mean_rate(spa,tt,:,:)));
        PSTH.maxSpkRealBinAll(spa,tt) = max(PSTH.bin_rate_aov{spa,tt}(:));
        PSTH.maxSpkRealbin_meanSte(spa,tt) = max(max(PSTH.bin_mean_rate_ste(spa,tt,:,:)));
        
        % calculate DDT & preferred directions for tuning
%     numReps(spa,tt) = max(cell2mat(cellfun(@length,spk_data_count_rate_anova(spa,tt,:),'UniformOutput',false)));
%     for nn = 1:length(spk_data_count_rate_anova(spa,tt,:))
%         if length(spk_data_count_rate_anova{c,nn})<numReps(spa,tt)
%             spk_data_count_rate_anova{c,nn} = [spk_data_count_rate_anova{c,nn} nan*ones(1,(numReps(spa,tt)-length(spk_data_count_rate_anova{c,nn})))];
%         end
%     end
%     spk_data_count_rate_anova_trans{c} = reshape(cell2mat(spk_data_count_rate_anova(spa,tt,:)),[numReps(spa,tt),length(spk_data_count_rate_anova(spa,tt,:))]);
%     p_anova_dire(spa,tt) = anova1(spk_data_count_rate_anova_trans{c},'','off'); % tuning anova
%     resp_std(spa,tt) = sum(resp_sse(spa,tt,:))/(sum(resp_trialnum(spa,tt,:))-length(unique_azimuth));
%     DDI(spa,tt) = (maxSpkRealMean(spa,tt)-minSpkRealMean(spa,tt))/(maxSpkRealMean(spa,tt)-minSpkRealMean(spa,tt)+2*sqrt(resp_std(spa,tt)));
%     [Azi, Ele, Amp] = vectorsum(PSTH.spk_data_vector{c}(:,:));
%     preferDire{c} = [Azi, Ele, Amp];
%     
%     % calculate the differences between every direction and the preferred direction
%     azis = reshape(repmat([0 45 90 135 180 225 270 315],5,1),[],1);
%     eles = repmat([-90 -45 0 45 90],1,8)';
%     pre_diff{c} = angleDiff(azis,eles,ones(1,40),ones(1,40)*preferDire{c}(1),ones(1,40)*preferDire{c}(2),ones(1,40));
        
    end
end

%%%%%%%%%%%%%%%%%% pack data for sponteneous conditions
spon_spk_count_rate = sum(spon_spk_data(stimOnT(1)+tBeg:stimOffT(1)-tEnd, :),2)/((unique_duration(1,1)-tBeg-tEnd)/1000);
PSTH.spon_bin_rate = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spon_spk_data, 2, gau_sig);
PSTH.spon_spk_data_bin_mean_rate = mean(PSTH.spon_bin_rate,2);
PSTH.spon_bin_mean_rate_std = std(PSTH.spon_bin_rate,0,2);
PSTH.spon_spk_data_bin_mean_rate_ste = PSTH.spon_bin_mean_rate_std/sqrt(size(PSTH.spon_bin_rate,2));

% maximum spon value
maxSpkSponAll = max(max(PSTH.spon_bin_rate)); % for PSTH across trials
PSTH.maxSpkSponbin_mean = max(PSTH.spon_spk_data_bin_mean_rate); % for PSTH mean
maxSpkSponMean = max(spon_spk_count_rate); % for contour
PSTH.maxSpkSponbin_meanSte = max(PSTH.spon_spk_data_bin_mean_rate_ste);
% mean spon value
PSTH.meanSpkSponbin_mean = mean(PSTH.spon_spk_data_bin_mean_rate);% for PSTH mean & PSTH across trials
meanSpkSponMean = mean(spon_spk_count_rate);% for contour
meanSpon = meanSpkSponMean;

%% Temporal analysis

%%%%%%% for grating

% %{
% based on Chen, AH et al., 2010, JNS
% wilcoxon rank sum test
% 500 ms after stim. on to 50ms before stim off

baselineBinBeg = stimOnBin-floor(100/timeStep);
baselineBinEnd = stimOnBin+floor(200/timeStep);

for spa = 1:length(unique_spatFre)
    for ttt = 1:length(unique_tempFre)
        %     spk_data_bin_rate_mean_minusSpon{spa,tt} = PSTH.spk_data_bin_mean_rate_aov{spa,tt}-repmat(PSTH.spon_spk_data_bin_mean_rate',size(PSTH.spk_data_bin_mean_rate_aov{spa,tt},1),1);
        sPeak{spa,ttt} = zeros(1,size(PSTH.bin_rate_aov{spa,ttt},1)); % store the number of significant bins
        sTrough{spa,ttt} = zeros(1,size(PSTH.bin_rate_aov{spa,ttt},1)); % store the number of significant bins
        peakDir{spa,ttt} = []; % the number of local peak direction
        peakR{spa,ttt} = []; % the response of local peak direction
        localPeak{spa,ttt} = []; % find the local peak bin of each direction
        localTrough{spa,ttt} = []; % find the local trough bin of each direction
        PSTH.peak{spa,ttt} = []; % location of peaks
        PSTH.trough{spa,ttt} = []; % location of troughs
        PSTH.NoPeaks(spa,ttt) = 0; % number of peaks
        PSTH.NoTroughs(spa,ttt) = 0; % location of troughs
        PSTH.respon_sigTrue(spa,ttt) = 0; % PSTH.sigTrue(pc) -> sig. of this cell
        
        
        % --------- to test if this direction is temporally responded -------%
        
        for pc = 1:size(PSTH.bin_rate_aov{spa,ttt},1)
            
            PSTH.sigBin{spa,ttt,pc} = []; % find if this bin is sig.
            PSTH.sigTrue{spa,ttt}(pc) = 0; % PSTH.sigTrue(pc) -> sig. of this direction
            
            % if 5 consecutive bins are sig.,then we say this bin is sig.
            % That is, this direction is temporally responded
            for nn = stimOnBin : stimOffBin
                s{spa,ttt,pc}(nn) = 0;
                for ii = nn-2:nn+2
                    try
                        if ranksum(squeeze(PSTH.bin_rate_aov{spa,ttt}(pc,ii,:))',squeeze(nanmean(PSTH.bin_rate_aov{spa,ttt}(pc,baselineBinBeg:baselineBinEnd,:)))') < 0.05
                            s{spa,ttt,pc}(nn) =  s{spa,ttt,pc}(nn)+1;
                        end
                    catch
                        keyboard;
                    end
                end
                if s{spa,ttt,pc}(nn) == 5
                    PSTH.sigBin{spa,ttt,pc} = [PSTH.sigBin{spa,ttt,pc};nn]; %
                end
                
                if ~isempty(PSTH.sigBin{spa,ttt,pc})
                    PSTH.sigTrue{spa,ttt}(pc) = 1; % PSTH.sigTrue(pc) == 1 -> sig. of this direction
                end
            end
        end
        
        PSTH.sig(spa,ttt) = sum(PSTH.sigTrue{spa,ttt}(:)); % sig No.of directions
        
        % --------------- this cell is temporally responded ------------------%
        
        % 2个方向,不需要相邻
        if sum(PSTH.sigTrue{spa,ttt}(:)) >=2
            PSTH.respon_sigTrue(spa,ttt) = 1;
        end
        % 相邻2个方向
        %     if respon_True(PSTH.sigTrue{spa,ttt}(:)) == 1
        %         PSTH.respon_sigTrue(spa,ttt) = 1;
        %
        %     end
        
        p_anova_dire_t{spa,ttt} = nan;
        DDI_t{spa,ttt} = nan;
        DDI_p_t{spa,ttt} = nan;
        preferDire_t{spa,ttt} = nan(3,1);
        PSTH.spk_data_sorted_PCA{spa,ttt} = nan;
        
        if PSTH.respon_sigTrue(spa,ttt) == 1
            
            % --------- to find local peaks & throughs -------%
            peakR{spa,ttt} = NaN(1,nBins);peakDir{spa,ttt} = NaN(1,nBins);p{spa,ttt} = NaN(1,nBins);
            for nn = stimOnBin : stimOffBin
                [peakR{spa,ttt}(nn),peakDir{spa,ttt}(nn)] = max(PSTH.bin_mean_rate_aov{spa,ttt}(:,nn));
                try
                    p{spa,ttt}(nn) = anova1(squeeze(PSTH.bin_rate_aov{spa,ttt}(:,nn,:))','','off');
                catch
                    keyboard;
                end
            end
            pp = 0;th = 0;
            for tt = stimOnBin+2 : stimOffBin-2
                
                if (peakR{spa,ttt}(tt) > peakR{spa,ttt}(tt-1)) && (peakR{spa,ttt}(tt) > peakR{spa,ttt}(tt+1))...
                        && p{spa,ttt}(tt) < 0.05 && p{spa,ttt}(tt-1) < 0.05 && p{spa,ttt}(tt-2) < 0.05 && p{spa,ttt}(tt+1) < 0.05 && p{spa,ttt}(tt+2) < 0.05
                    pp = pp+1; % how many peaks
                    localPeak{spa,ttt}(pp,1)= tt;
                    localPeak{spa,ttt}(pp,2)= peakR{spa,ttt}(tt);
                end
                if (peakR{spa,ttt}(tt) < peakR{spa,ttt}(tt-1)) && (peakR{spa,ttt}(tt) < peakR{spa,ttt}(tt+1))...
                        && p{spa,ttt}(tt) < 0.05 && p{spa,ttt}(tt-1) < 0.05 && p{spa,ttt}(tt-2) < 0.05 && p{spa,ttt}(tt+1) < 0.05 && p{spa,ttt}(tt+2) < 0.05
                    th = th+1; % how many throughs
                    localTrough{spa,ttt}(th,1)= tt;
                    localTrough{spa,ttt}(th,2)= peakR{spa,ttt}(tt);
                end
            end
            
            % --------- to find real peaks & throughs? -------%
            
            if ~isempty(localPeak{spa,ttt})
                localPeak{spa,ttt} = sortrows(localPeak{spa,ttt},-2)'; % sort according to response
                PSTH.peak{spa,ttt} = localPeak{spa,ttt}(1,1); % True peaks, here the largest one is sure to be the 1st peak
                
                % find other peaks
                % conpare the correlation coefficient between the largest one and each other bin
                if size(localPeak{spa,ttt},2)>1
                    n = 1;
                    while n < size(localPeak{spa,ttt},1)
                        ii = n+1;
                        while ii < size(localPeak{spa,ttt},1)+1
                            try
                                [rCorr,pCorr] = corrcoef(PSTH.bin_mean_rate_aov{spa,ttt}(:,localPeak{spa,ttt}(1,n)),PSTH.bin_mean_rate_aov{spa,ttt}(:,localPeak{spa,ttt}(1,ii)));
                            catch
                                
                            end
                            if ~(rCorr(1,2) > 0 && pCorr(1,2) < 0.05)
                                PSTH.peak{spa,ttt} = [PSTH.peak{spa,ttt} localPeak{spa,ttt}(1,ii)];
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
            PSTH.NoPeaks(spa,ttt) = length(PSTH.peak{spa,ttt});
            % find the direction with the max peak response ( the first peak )
            if ~isempty(PSTH.peak{spa,ttt})
                [PSTH.peakMaxRespon(spa,ttt),PSTH.peakMaxDir(spa,ttt)] = max(PSTH.bin_mean_rate(spa,ttt,:,PSTH.peak{spa,ttt}(1)));
            else
                PSTH.peakMaxRespon(spa,ttt) = nan;
                PSTH.peakMaxDir(spa,ttt) = nan;
            end
            % calculate the half width of each direction
            for i = 1: length(unique_orient)
                try
                    PSTH.hwPeak(spa,ttt,i) = fwhm(1: nBins, squeeze(PSTH.bin_mean_rate(spa,ttt,i,:)));
                catch
                    keyboard;
                end
            end
            
            % calculate DDI for each peak time
            for pt = 1:PSTH.NoPeaks(spa,ttt)
                for pc = 1:size(PSTH.bin_rate_aov{spa,ttt},1)
                    resp_sse_t{spa,ttt}(pc,pt) = nansum((PSTH.bin_rate_aov{spa,ttt}(pc,PSTH.peak{spa,ttt}(pt),:) - nanmean(PSTH.bin_rate_aov{spa,ttt}(pc,PSTH.peak{spa,ttt}(pt),:))).^2); % for DDI
                    resp_trialnum_t{spa,ttt}(pc,pt)= size(PSTH.bin_rate_aov{spa,ttt}(pc,PSTH.peak{spa,ttt}(pt),:),3); % for DDI
                end
                
                try
                    p_anova_dire_t{spa,ttt}(pt) = anova1(squeeze(PSTH.bin_rate_aov{spa,ttt}(:,PSTH.peak{spa,ttt}(pt),:))','','off'); % tuning anova
                    resp_std_t{spa,ttt}(pt) = sum(resp_sse_t{spa,ttt}(:,pt))/(sum(resp_trialnum_t{spa,ttt}(:,pt))-length(unique_orient));
                    maxSpkRealMean_t{spa,ttt}(pt) = max(max(squeeze((PSTH.bin_rate_aov{spa,ttt}(:,PSTH.peak{spa,ttt}(pt),:)))));
                    minSpkRealMean_t{spa,ttt}(pt) = min(min(squeeze((PSTH.bin_rate_aov{spa,ttt}(:,PSTH.peak{spa,ttt}(pt),:)))));
                    DDI_t{spa,ttt}(pt) = (maxSpkRealMean_t{spa,ttt}(pt)-minSpkRealMean_t{spa,ttt}(pt))/(maxSpkRealMean_t{spa,ttt}(pt)-minSpkRealMean_t{spa,ttt}(pt)+2*sqrt(resp_std_t{spa,ttt}(pt)));
                    
                    % DDI permutation
                    num_perm = 1000;
                    for nn = 1 : num_perm
                        temp = squeeze(PSTH.bin_rate_aov{spa,ttt}(:,PSTH.peak{spa,ttt}(pt),:));
                        temp = temp(:);
                        temp = temp(randperm(length(unique_orient)*size(PSTH.bin_rate_aov{spa,ttt},3)));
                        temp = reshape(temp,length(unique_orient),[]);
                        temp = nanmean(temp,2);
                        maxSpkRealMean_perm_t{spa,ttt}(nn,pt) = max(temp);
                        minSpkRealMean_perm_t{spa,ttt}(nn,pt) = min(temp);
                        DDI_perm_t{spa,ttt}(pt,nn) = (maxSpkRealMean_perm_t{spa,ttt}(nn,pt)-minSpkRealMean_perm_t{spa,ttt}(nn,pt))/(maxSpkRealMean_perm_t{spa,ttt}(nn,pt)-minSpkRealMean_perm_t{spa,ttt}(nn,pt)+2*sqrt(resp_std_t{spa,ttt}(pt)));
                        
                    end
                    DDI_p_t{spa,ttt}(pt) = sum(DDI_perm_t{spa,ttt}(pt,:)>DDI_t{spa,ttt}(pt))/num_perm;
                    
                catch
                    keyboard;
                end
            end
            
            % sort PCA according to the maximum of direction
            if ~isempty(PSTH.peak{spa,ttt})
                [~, temp_inx] = sortrows(PSTH.bin_mean_rate_PCA{spa,ttt}(:,PSTH.peak{spa,ttt}(1)),-1);
                PSTH.sorted_PCA{spa,ttt} = PSTH.bin_mean_rate_PCA{spa,ttt}(temp_inx,:);
            else
                PSTH.sorted_PCA{spa,ttt} = PSTH.bin_mean_rate_PCA{spa,ttt};
            end
        end
    end
end


%}

%%%%%%% for optic flow

% %{

        %     spk_data_bin_rate_mean_minusSpon{spa,tt} = PSTH.bin_mean_rate_aov{spa,tt}-repmat(PSTH.spon_spk_data_bin_mean_rate',size(PSTH.bin_mean_rate_aov{spa,tt},1),1);
        sPeak_opt = zeros(1,size(PSTH.opt_bin_rate_aov,1)); % store the number of significant bins
        sTrough_opt = zeros(1,size(PSTH.opt_bin_rate_aov,1)); % store the number of significant bins
        peakDir_opt = []; % the number of local peak direction
        peakR_opt = []; % the response of local peak direction
        localPeak_opt = []; % find the local peak bin of each direction
        localTrough_opt = []; % find the local trough bin of each direction
        PSTH.peak_opt = []; % location of peaks
        PSTH.trough_opt = []; % location of troughs
        PSTH.NoPeaks_opt = 0; % number of peaks
        PSTH.NoTroughs_opt = 0; % location of troughs
        PSTH.respon_sigTrue_opt = 0; % PSTH.sigTrue(pc) -> sig. of this cell
        
        
        % --------- to test if this direction is temporally responded -------%
        
        for pc = 1:size(PSTH.opt_bin_rate_aov,1)
            
            PSTH.sigBin_opt{pc} = []; % find if this bin is sig.
            PSTH.sigTrue_opt(pc) = 0; % PSTH.sigTrue_opt(pc) -> sig. of this direction
            
            % if 5 consecutive bins are sig.,then we say this bin is sig.
            % That is, this direction is temporally responded
            for nn = stimOnBin : stimOffBin
                s{pc}(nn) = 0;
                for ii = nn-2:nn+2
                    try
                        if ranksum(squeeze(PSTH.opt_bin_rate_aov(pc,ii,:))',squeeze(nanmean(PSTH.opt_bin_rate_aov(pc,baselineBinBeg:baselineBinEnd,:)))') < 0.05
                            s{pc}(nn) =  s{pc}(nn)+1;
                        end
                    catch
                        keyboard;
                    end
                end
                if s{pc}(nn) == 5
                    PSTH.sigBin_opt{pc} = [PSTH.sigBin_opt{pc};nn]; %
                end
                
                if ~isempty(PSTH.sigBin_opt{pc})
                    PSTH.sigTrue_opt(pc) = 1; % PSTH.sigTrue_opt(pc) == 1 -> sig. of this direction
                end
            end
        end
        
        PSTH.sig_opt = sum(PSTH.sigTrue_opt(:)); % sig No.of directions
        
        % --------------- this cell is temporally responded ------------------%
        
        % 2个方向,不需要相邻
        if sum(PSTH.sigTrue_opt(:)) >=2
            PSTH.respon_sigTrue_opt = 1;
        end
        % 相邻2个方向
        %     if respon_True(PSTH.sigTrue_opt(:)) == 1
        %         PSTH.respon_sigTrue_opt = 1;
        %
        %     end
        
        p_anova_dire_t_opt = nan;
        DDI_t_opt = nan;
        DDI_p_t_opt = nan;
        preferDire_t_opt = nan(3,1);
        PSTH.spk_data_sorted_PCA_opt = nan;
        
        if PSTH.respon_sigTrue_opt == 1
            
            % --------- to find local peaks & throughs -------%
            peakR_opt = NaN(1,nBins);peakDir_opt = NaN(1,nBins);p = NaN(1,nBins);
            for nn = stimOnBin : stimOffBin
                [peakR_opt(nn),peakDir_opt(nn)] = max(PSTH.opt_bin_mean_rate_aov(:,nn));
                try
                    p(nn) = anova1(squeeze(PSTH.opt_bin_rate_aov(:,nn,:))','','off');
                catch
                    keyboard;
                end
            end
            pp = 0;th = 0;
            for tt = stimOnBin+2 : stimOffBin-2
                
                if (peakR_opt(tt) > peakR_opt(tt-1)) && (peakR_opt(tt) > peakR_opt(tt+1))...
                        && p(tt) < 0.05 && p(tt-1) < 0.05 && p(tt-2) < 0.05 && p(tt+1) < 0.05 && p(tt+2) < 0.05
                    pp = pp+1; % how many peaks
                    localPeak_opt(pp,1)= tt;
                    localPeak_opt(pp,2)= peakR_opt(tt);
                end
                if (peakR_opt(tt) < peakR_opt(tt-1)) && (peakR_opt(tt) < peakR_opt(tt+1))...
                        && p(tt) < 0.05 && p(tt-1) < 0.05 && p(tt-2) < 0.05 && p(tt+1) < 0.05 && p(tt+2) < 0.05
                    th = th+1; % how many throughs
                    localTrough_opt(th,1)= tt;
                    localTrough_opt(th,2)= peakR_opt(tt);
                end
            end
            
            % --------- to find real peaks & throughs? -------%
            
            if ~isempty(localPeak_opt)
                localPeak_opt = sortrows(localPeak_opt,-2)'; % sort according to response
                PSTH.peak_opt = localPeak_opt(1,1); % True peaks, here the largest one is sure to be the 1st peak
                
                % find other peaks
                % conpare the correlation coefficient between the largest one and each other bin
                if size(localPeak_opt,2)>1
                    n = 1;
                    while n < size(localPeak_opt,1)
                        ii = n+1;
                        while ii < size(localPeak_opt,1)+1
                            try
                                [rCorr,pCorr] = corrcoef(PSTH.opt_bin_mean_rate_aov(:,localPeak_opt(1,n)),PSTH.opt_bin_mean_rate_aov(:,localPeak_opt(1,ii)));
                            catch
                                
                            end
                            if ~(rCorr(1,2) > 0 && pCorr(1,2) < 0.05)
                                PSTH.peak_opt = [PSTH.peak_opt localPeak_opt(1,ii)];
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
            PSTH.NoPeaks_opt = length(PSTH.peak_opt);
            % find the direction with the max peak response ( the first peak )
            if ~isempty(PSTH.peak_opt)
                [PSTH.peakMaxRespon_opt,PSTH.peakMaxDir_opt] = max(PSTH.opt_bin_mean_rate(:,PSTH.peak_opt(1)));
            else
                PSTH.peakMaxRespon_opt = nan;
                PSTH.peakMaxDir_opt = nan;
            end
            % calculate the half width of each direction
            for i = 1: length(unique_orient)
                try
                    PSTH.hwPeak_opt(spa,ttt,i) = fwhm(1: nBins, PSTH.opt_bin_mean_rate(i,:));
                catch
                    keyboard;
                end
            end
            
            % calculate DDI for each peak time
            for pt = 1:PSTH.NoPeaks_opt
                for pc = 1:size(PSTH.opt_bin_rate_aov,1)
                    resp_sse_t_opt(pc,pt) = nansum((PSTH.opt_bin_rate_aov(pc,PSTH.peak_opt(pt),:) - nanmean(PSTH.opt_bin_rate_aov(pc,PSTH.peak_opt(pt),:))).^2); % for DDI
                    resp_trialnum_t_opt(pc,pt)= size(PSTH.opt_bin_rate_aov(pc,PSTH.peak_opt(pt),:),3); % for DDI
                end
                
                try
                    p_anova_dire_t_opt(pt) = anova1(squeeze(PSTH.opt_bin_rate_aov(:,PSTH.peak_opt(pt),:))','','off'); % tuning anova
                    resp_std_t_opt(pt) = sum(resp_sse_t_opt(:,pt))/(sum(resp_trialnum_t_opt(:,pt))-length(unique_orient));
                    maxSpkRealMean_t_opt(pt) = max(max(squeeze((PSTH.opt_bin_rate_aov(:,PSTH.peak_opt(pt),:)))));
                    minSpkRealMean_t_opt(pt) = min(min(squeeze((PSTH.opt_bin_rate_aov(:,PSTH.peak_opt(pt),:)))));
                    DDI_t_opt(pt) = (maxSpkRealMean_t_opt(pt)-minSpkRealMean_t_opt(pt))/(maxSpkRealMean_t_opt(pt)-minSpkRealMean_t_opt(pt)+2*sqrt(resp_std_t_opt(pt)));
                    
                    % DDI permutation
                    num_perm = 1000;
                    for nn = 1 : num_perm
                        temp = squeeze(PSTH.opt_bin_rate_aov(:,PSTH.peak_opt(pt),:));
                        temp = temp(:);
                        temp = temp(randperm(length(unique_orient)*size(PSTH.opt_bin_rate_aov,3)));
                        temp = reshape(temp,length(unique_orient),[]);
                        temp = nanmean(temp,2);
                        maxSpkRealMean_perm_t(nn,pt) = max(temp);
                        minSpkRealMean_perm_t(nn,pt) = min(temp);
                        DDI_perm_t(pt,nn) = (maxSpkRealMean_perm_t(nn,pt)-minSpkRealMean_perm_t(nn,pt))/(maxSpkRealMean_perm_t(nn,pt)-minSpkRealMean_perm_t(nn,pt)+2*sqrt(resp_std_t_opt(pt)));
                        
                    end
                    DDI_p_t_opt(pt) = sum(DDI_perm_t(pt,:)>DDI_t_opt(pt))/num_perm;
                    
                catch
                    keyboard;
                end
            end
            
            % sort PCA according to the maximum of direction
            if ~isempty(PSTH.peak_opt)
                [~, temp_inx] = sortrows(PSTH.opt_bin_mean_rate_PCA(:,PSTH.peak_opt(1)),-1);
                PSTH.opt_sorted_PCA_opt = PSTH.opt_bin_mean_rate_PCA(temp_inx,:);
            else
                PSTH.opt_sorted_PCA_opt = PSTH.opt_bin_mean_rate_PCA;
            end
        end

%}

%% plot figures
%
% k=1,2
% i=0 45 90 135 180 225 270 315

% 270-225-180-135-90-45-0-315-270 for figures
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

PSTH_gratings; % plot PSTHs across sessions;
% spatial_tuning;

%% 1D models nalysis
model_catg = [];
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
    if PSTH.respon_sigTrue == 1
        
        % fit data with raw PSTH data or - spon data
        switch spon_flag
            case 0 %raw data
                models_fitting_1D(model_catg,models,models_color,FILE,SpikeChan, Protocol,meanSpon,squeeze(PSTH.bin_mean_rate(3,:,stimOnBin:stimOffBin)),PSTH.mean_rate_all(3,:),PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
            case 1 % - spon data, so meanspon == 0
                PSTH.bin_mean_rate = PSTH.bin_mean_rate - permute(reshape(repmat(PSTH.spon_spk_data_bin_mean_rate,8,5),[],8,5),[3 2 1]);
                PSTH.mean_rate_all = PSTH.mean_rate_all - meanSpkSponMean; % 会出现负值
                %                 PSTH.spon_spk_data_bin_mean_rate = meanSpkSponMean;
                models_fitting_1D(model_catg,models,models_color,FILE,SpikeChan, Protocol,0,squeeze(PSTH.bin_mean_rate(3,:,stimOnBin:stimOffBin)),PSTH.mean_rate_all(3,:),PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax,aMin,timeStep,unique_duration);
        end
        
        if sum(ismember(models,'PVAJ')) ~= 0
            
            PSTH1Dmodel.PVAJ_wP = (1-PSTH1Dmodel.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel.modelFitPara_PVAJ(17))*PSTH1Dmodel.modelFitPara_PVAJ(16);
            PSTH1Dmodel.PVAJ_wV = (1-PSTH1Dmodel.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel.modelFitPara_PVAJ(17))*(1-PSTH1Dmodel.modelFitPara_PVAJ(16));
            PSTH1Dmodel.PVAJ_wA = (1-PSTH1Dmodel.modelFitPara_PVAJ(18))*PSTH1Dmodel.modelFitPara_PVAJ(17);
            PSTH1Dmodel.PVAJ_wJ = PSTH1Dmodel.modelFitPara_PVAJ(18);
            [PSTH1Dmodel.PVAJ_preDir_V(1),PSTH1Dmodel.PVAJ_preDir_V(2),PSTH1Dmodel.PVAJ_preDir_V(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_PVAJ.V);
            [PSTH1Dmodel.PVAJ_preDir_A(1),PSTH1Dmodel.PVAJ_preDir_A(2),PSTH1Dmodel.PVAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_PVAJ.A);
            PSTH1Dmodel.PVAJ_angleDiff_VA = angleDiff(PSTH1Dmodel.PVAJ_preDir_V(1),PSTH1Dmodel.PVAJ_preDir_V(2),PSTH1Dmodel.PVAJ_preDir_V(3),PSTH1Dmodel.PVAJ_preDir_A(1),PSTH1Dmodel.PVAJ_preDir_A(2),PSTH1Dmodel.PVAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.PVAJ_Delay_VA = PSTH1Dmodel.modelFitPara_PVAJ(19);
                PSTH1Dmodel.PVAJ_Delay_JA = PSTH1Dmodel.modelFitPara_PVAJ(20);
                PSTH1Dmodel.PVAJ_Delay_PA = PSTH1Dmodel.modelFitPara_PVAJ(21);
            end
            
        elseif sum(ismember(models,'PVAJ')) == 0
            PSTH1Dmodel.PVAJ_wV = nan;
            PSTH1Dmodel.PVAJ_wA = nan;
            PSTH1Dmodel.PVAJ_wJ = nan;
            PSTH1Dmodel.PVAJ_wP = nan;
            PSTH1Dmodel.PVAJ_preDir_V = nan*ones(1,3);
            PSTH1Dmodel.PVAJ_preDir_A = nan*ones(1,3);
            PSTH1Dmodel.PVAJ_angleDiff_VA = nan;
            PSTH1Dmodel.RSquared_PVAJ = nan;
            PSTH1Dmodel.BIC_PVAJ = nan;
            PSTH1Dmodel.modelFitPara_PVAJ = nan*ones(1,22);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.PVAJ_Delay_VA = nan;
                PSTH1Dmodel.PVAJ_Delay_JA = nan;
                PSTH1Dmodel.PVAJ_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VAJ')) ~= 0
            if sum(ismember(models,'AJ')) ~= 0
                PSTH1Dmodel.VAJ_R2V = ((PSTH1Dmodel.RSquared_VAJ)^2 - (PSTH1Dmodel.RSquared_AJ)^2)/(1-(PSTH1Dmodel.RSquared_AJ)^2);
            else
                PSTH1Dmodel.VAJ_R2V = nan;
            end
            if sum(ismember(models,'VJ')) ~= 0
                PSTH1Dmodel.VAJ_R2A = ((PSTH1Dmodel.RSquared_VAJ)^2 - (PSTH1Dmodel.RSquared_VJ)^2)/(1-(PSTH1Dmodel.RSquared_VJ)^2);
            else
                PSTH1Dmodel.VAJ_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH1Dmodel.VAJ_R2J = ((PSTH1Dmodel.RSquared_VAJ)^2 - (PSTH1Dmodel.RSquared_VA)^2)/(1-(PSTH1Dmodel.RSquared_VA)^2);
            else
                PSTH1Dmodel.VAJ_R2J = nan;
            end
            PSTH1Dmodel.VAJ_wV = PSTH1Dmodel.modelFitPara_VAJ(13)*(1-PSTH1Dmodel.modelFitPara_VAJ(14));
            PSTH1Dmodel.VAJ_wA = (1-PSTH1Dmodel.modelFitPara_VAJ(13))*(1-PSTH1Dmodel.modelFitPara_VAJ(14));
            PSTH1Dmodel.VAJ_wJ = PSTH1Dmodel.modelFitPara_VAJ(14);
            [PSTH1Dmodel.VAJ_preDir_V(1),PSTH1Dmodel.VAJ_preDir_V(2),PSTH1Dmodel.VAJ_preDir_V(3)] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VAJ.V);
            [PSTH1Dmodel.VAJ_preDir_A(1),PSTH1Dmodel.VAJ_preDir_A(2),PSTH1Dmodel.VAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VAJ.A);
            PSTH1Dmodel.VAJ_angleDiff_VA = angleDiff(PSTH1Dmodel.VAJ_preDir_V(1),PSTH1Dmodel.VAJ_preDir_V(2),PSTH1Dmodel.VAJ_preDir_V(3),PSTH1Dmodel.VAJ_preDir_A(1),PSTH1Dmodel.VAJ_preDir_A(2),PSTH1Dmodel.VAJ_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VAJ_Delay_VA = PSTH1Dmodel.modelFitPara_VAJ(15);
                PSTH1Dmodel.VAJ_Delay_JA = PSTH1Dmodel.modelFitPara_VAJ(16);
            end
        elseif sum(ismember(models,'VAJ')) == 0
            PSTH1Dmodel.VAJ_wV = nan;
            PSTH1Dmodel.VAJ_wA = nan;
            PSTH1Dmodel.VAJ_wJ = nan;
            PSTH1Dmodel.VAJ_preDir_V = nan*ones(1,3);
            PSTH1Dmodel.VAJ_preDir_A = nan*ones(1,3);
            PSTH1Dmodel.VAJ_angleDiff_VA = nan;
            PSTH1Dmodel.RSquared_VAJ = nan;
            PSTH1Dmodel.BIC_VAJ = nan;
            PSTH1Dmodel.modelFitPara_VAJ = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VAJ_Delay_VA = nan;
                PSTH1Dmodel.VAJ_Delay_JA = nan;
            end
        end
        
        if sum(ismember(models,'VAP')) ~= 0
            if sum(ismember(models,'AP')) ~= 0
                PSTH1Dmodel.VAP_R2V = ((PSTH1Dmodel.RSquared_VAP)^2 - (PSTH1Dmodel.RSquared_AP)^2)/(1-(PSTH1Dmodel.RSquared_AP)^2);
            else
                PSTH1Dmodel.VAP_R2V = nan;
            end
            if sum(ismember(models,'VP')) ~= 0
                PSTH1Dmodel.VAP_R2A = ((PSTH1Dmodel.RSquared_VAP)^2 - (PSTH1Dmodel.RSquared_VP)^2)/(1-(PSTH1Dmodel.RSquared_VP)^2);
            else
                PSTH1Dmodel.VAP_R2A = nan;
            end
            if sum(ismember(models,'VA')) ~= 0
                PSTH1Dmodel.VAP_R2P = ((PSTH1Dmodel.RSquared_VAP)^2 - (PSTH1Dmodel.RSquared_VA)^2)/(1-(PSTH1Dmodel.RSquared_VA)^2);
            else
                PSTH1Dmodel.VAP_R2P = nan;
            end
            PSTH1Dmodel.VAP_wV = PSTH1Dmodel.modelFitPara_VAP(13)*(1-PSTH1Dmodel.modelFitPara_VAP(14));
            PSTH1Dmodel.VAP_wA = (1-PSTH1Dmodel.modelFitPara_VAP(13))*(1-PSTH1Dmodel.modelFitPara_VAP(14));
            PSTH1Dmodel.VAP_wP = PSTH1Dmodel.modelFitPara_VAP(14);
            [PSTH1Dmodel.VAP_preDir_V(1),PSTH1Dmodel.VAP_preDir_V(2),PSTH1Dmodel.VAP_preDir_V(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VAP.V);
            [PSTH1Dmodel.VAP_preDir_A(1),PSTH1Dmodel.VAP_preDir_A(2), PSTH1Dmodel.VAP_preDir_A(3)] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VAP.A);
            PSTH1Dmodel.VAP_angleDiff_VA = angleDiff(PSTH1Dmodel.VAP_preDir_V(1),PSTH1Dmodel.VAP_preDir_V(2),PSTH1Dmodel.VAP_preDir_V(3),PSTH1Dmodel.VAP_preDir_A(1),PSTH1Dmodel.VAP_preDir_A(2),PSTH1Dmodel.VAP_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VAP_Delay_VA = PSTH1Dmodel.modelFitPara_VAP(15);
                PSTH1Dmodel.VAP_Delay_PA = PSTH1Dmodel.modelFitPara_VAP(16);
            end
        elseif sum(ismember(models,'VAP')) == 0
            PSTH1Dmodel.VAP_wV = nan;
            PSTH1Dmodel.VAP_wA = nan;
            PSTH1Dmodel.VAP_wP = nan;
            PSTH1Dmodel.VAP_preDir_V = nan*ones(1,3);
            PSTH1Dmodel.VAP_preDir_A = nan*ones(1,3);
            PSTH1Dmodel.VAP_angleDiff_VA = nan;
            PSTH1Dmodel.RSquared_VAP = nan;
            PSTH1Dmodel.BIC_VAP = nan;
            PSTH1Dmodel.modelFitPara_VAP = nan*ones(1,17);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VAP_Delay_VA = nan;
                PSTH1Dmodel.VAP_Delay_PA = nan;
            end
        end
        
        if sum(ismember(models,'VA')) ~= 0
            PSTH1Dmodel.VA_wV = PSTH1Dmodel.modelFitPara_VA(10);
            PSTH1Dmodel.VA_wA = 1-PSTH1Dmodel.modelFitPara_VA(10);
            [PSTH1Dmodel.VA_preDir_V(1),PSTH1Dmodel.VA_preDir_V(2),PSTH1Dmodel.VA_preDir_V(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VA.V);
            [PSTH1Dmodel.VA_preDir_A(1),PSTH1Dmodel.VA_preDir_A(2),PSTH1Dmodel.VA_preDir_A(3) ] = vectorsum(PSTH1Dmodel.modelFitTrans_spatial_VA.A);
            PSTH1Dmodel.VA_angleDiff_VA = angleDiff(PSTH1Dmodel.VA_preDir_V(1),PSTH1Dmodel.VA_preDir_V(2),PSTH1Dmodel.VA_preDir_V(3),PSTH1Dmodel.VA_preDir_A(1),PSTH1Dmodel.VA_preDir_A(2),PSTH1Dmodel.VA_preDir_A(3));
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VA_Delay_VA = PSTH1Dmodel.modelFitPara_VA(11);
            end
            if sum(ismember(models,'AO')) ~= 0
                PSTH1Dmodel.VA_R2V = ((PSTH1Dmodel.RSquared_VA)^2 - (PSTH1Dmodel.RSquared_AO)^2)/(1-(PSTH1Dmodel.RSquared_AO)^2);
            else
                PSTH1Dmodel.VA_R2A = nan;
            end
            if sum(ismember(models,'VO')) ~= 0
                PSTH1Dmodel.VA_R2A = ((PSTH1Dmodel.RSquared_VA)^2 - (PSTH1Dmodel.RSquared_VO)^2)/(1-(PSTH1Dmodel.RSquared_VO)^2);
            else
                PSTH1Dmodel.VA_R2V = nan;
            end
        elseif sum(ismember(models,'VA')) == 0
            PSTH1Dmodel.VA_wV = nan;
            PSTH1Dmodel.VA_wA = nan;
            PSTH1Dmodel.VA_preDir_V = nan*ones(1,3);
            PSTH1Dmodel.VA_preDir_A = nan*ones(1,3);
            PSTH1Dmodel.VA_angleDiff_VA = nan;
            PSTH1Dmodel.RSquared_VA = nan;
            PSTH1Dmodel.BIC_VA = nan;
            PSTH1Dmodel.modelFitPara_VA = nan*ones(1,12);
            if strcmp(model_catg,'Out-sync model') == 1
                PSTH1Dmodel.VA_Delay_VA = nan;
            end
        end
        if sum(ismember(models,'VO')) == 0
            PSTH1Dmodel.RSquared_VO = nan;
            PSTH1Dmodel.BIC_VO = nan;
        end
        if sum(ismember(models,'AO')) == 0
            PSTH1Dmodel.RSquared_AO = nan;
            PSTH1Dmodel.BIC_AO = nan;
        end
        if sum(ismember(models,'VJ')) == 0
            PSTH1Dmodel.RSquared_VJ = nan;
            PSTH1Dmodel.BIC_VJ = nan;
        end
        if sum(ismember(models,'AJ')) == 0
            PSTH1Dmodel.RSquared_AJ = nan;
            PSTH1Dmodel.BIC_AJ = nan;
        end
        if sum(ismember(models,'VP')) == 0
            PSTH1Dmodel.RSquared_VP = nan;
            PSTH1Dmodel.BIC_VP = nan;
        end
        if sum(ismember(models,'AP')) == 0
            PSTH1Dmodel.RSquared_AP = nan;
            PSTH1Dmodel.BIC_AP = nan;
        end
    else
        PSTH1Dmodel = nan;
    end
end

%}
%% Data Saving
% %{
% Reorganized. HH20141124
config.batch_flag = batch_flag;

% Output information for test. HH20160415
if isempty(batch_flag)
    config.batch_flag = 'test.m';
    disp('Saving results to \batch\test\ ');
end

%%%%%%%%%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = PackResult(FILE, PATH, SpikeChan, unique_tempFre, unique_spatFre, unique_stimType,Protocol, ... % Obligatory!!
    unique_orient, unique_amplitude, unique_duration,...   % paras' info of trial
    markers,...
    timeWin, timeStep, tOffset1, tOffset2,nBins,Bin,PCAStep,PCAWin,nBinsPCA, ... % PSTH slide window info
    meanSpon, PSTH, PSTH1Dmodel); % PSTH and mean FR info
%     p_anova_dire, DDI,preferDire); % model info


config.suffix = 'Grating';

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
            config.sprint_loop_contents = {'result.preferDire(1), result.preferDire(2),result.DDI,result.p_anova_dire';
                'result.PSTH.respon_sigTrue,result.PSTH.NoPeaks, result.PSTH.sig';};
            
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
            config.sprint_loop_contents = {'result.preferDire(1), result.preferDire(2),result.DDI,result.p_anova_dire';
                'result.PSTH.respon_sigTrue,result.PSTH.NoPeaks, result.PSTH.sig';
                ['result.PSTH3Dmodel.RSquared_VO,result.PSTH3Dmodel.RSquared_AO,result.PSTH3Dmodel.RSquared_VJ,result.PSTH3Dmodel.RSquared_AJ,result.PSTH3Dmodel.RSquared_VP,result.PSTH3Dmodel.RSquared_AP,result.PSTH3Dmodel.RSquared_VA,result.PSTH3Dmodel.RSquared_VAP,result.PSTH3Dmodel.RSquared_VAJ,result.PSTH3Dmodel.RSquared_PVAJ,'...
                'result.PSTH3Dmodel.BIC_VO,result.PSTH3Dmodel.BIC_AO,result.PSTH3Dmodel.BIC_VJ,result.PSTH3Dmodel.BIC_AJ,result.PSTH3Dmodel.BIC_VP,result.PSTH3Dmodel.BIC_AP,result.PSTH3Dmodel.BIC_VA,result.PSTH3Dmodel.BIC_VAP,result.PSTH3Dmodel.BIC_VAJ,result.PSTH3Dmodel.BIC_PVAJ,'...
                'result.PSTH3Dmodel.modelFitPara_VAJ(2),result.PSTH3Dmodel.modelFitPara_VAJ(3),result.PSTH3Dmodel.VAJ_wV,result.PSTH3Dmodel.VAJ_wA,result.PSTH3Dmodel.VAJ_wJ,result.PSTH3Dmodel.VAJ_preDir_V(1),result.PSTH3Dmodel.VAJ_preDir_V(2),result.PSTH3Dmodel.VAJ_preDir_A(1),result.PSTH3Dmodel.VAJ_preDir_A(2),result.PSTH3Dmodel.VAJ_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VAJ(4),result.PSTH3Dmodel.modelFitPara_VAJ(8),result.PSTH3Dmodel.modelFitPara_VAJ(12),'...
                'result.PSTH3Dmodel.modelFitPara_VA(2),result.PSTH3Dmodel.modelFitPara_VA(3),result.PSTH3Dmodel.VA_wV,result.PSTH3Dmodel.VA_wA,result.PSTH3Dmodel.VA_preDir_V(1),result.PSTH3Dmodel.VA_preDir_V(2),result.PSTH3Dmodel.VA_preDir_A(1),result.PSTH3Dmodel.VA_preDir_A(2),result.PSTH3Dmodel.VA_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VA(4),result.PSTH3Dmodel.modelFitPara_VA(8),'...
                'result.PSTH3Dmodel.modelFitPara_VAP(2),result.PSTH3Dmodel.modelFitPara_VAP(3),result.PSTH3Dmodel.VAP_wV,result.PSTH3Dmodel.VAP_wA,result.PSTH3Dmodel.VAP_wP,result.PSTH3Dmodel.VAP_preDir_V(1),result.PSTH3Dmodel.VAP_preDir_V(2),result.PSTH3Dmodel.VAP_preDir_A(1),result.PSTH3Dmodel.VAP_preDir_A(2),result.PSTH3Dmodel.VAP_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VAP(4),result.PSTH3Dmodel.modelFitPara_VAP(8),result.PSTH3Dmodel.modelFitPara_VAP(12),'...
                'result.PSTH3Dmodel.modelFitPara_PVAJ(2),result.PSTH3Dmodel.modelFitPara_PVAJ(3),result.PSTH3Dmodel.PVAJ_wV,result.PSTH3Dmodel.PVAJ_wA,result.PSTH3Dmodel.PVAJ_wJ,result.PSTH3Dmodel.PVAJ_wP,result.PSTH3Dmodel.PVAJ_preDir_V(1),result.PSTH3Dmodel.PVAJ_preDir_V(2),result.PSTH3Dmodel.PVAJ_preDir_A(1),result.PSTH3Dmodel.PVAJ_preDir_A(2),result.PSTH3Dmodel.PVAJ_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_PVAJ(4),result.PSTH3Dmodel.modelFitPara_PVAJ(8),result.PSTH3Dmodel.modelFitPara_PVAJ(12),result.PSTH3Dmodel.modelFitPara_PVAJ(16)']};
            
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
            config.sprint_loop_contents = {'result.preferDire(1), result.preferDire(2),result.DDI,result.p_anova_dire';
                'result.PSTH.respon_sigTrue,result.PSTH.NoPeaks, result.PSTH.sig';
                ['result.PSTH3Dmodel.RSquared_VO,result.PSTH3Dmodel.RSquared_AO,result.PSTH3Dmodel.RSquared_VJ,result.PSTH3Dmodel.RSquared_AJ,result.PSTH3Dmodel.RSquared_VP,result.PSTH3Dmodel.RSquared_AP,result.PSTH3Dmodel.RSquared_VA,result.PSTH3Dmodel.RSquared_VAP,result.PSTH3Dmodel.RSquared_VAJ,result.PSTH3Dmodel.RSquared_PVAJ,'...
                'result.PSTH3Dmodel.BIC_VO,result.PSTH3Dmodel.BIC_AO,result.PSTH3Dmodel.BIC_VJ,result.PSTH3Dmodel.BIC_AJ,result.PSTH3Dmodel.BIC_VP,result.PSTH3Dmodel.BIC_AP,result.PSTH3Dmodel.BIC_VA,result.PSTH3Dmodel.BIC_VAP,result.PSTH3Dmodel.BIC_VAJ,result.PSTH3Dmodel.BIC_PVAJ,'...
                'result.PSTH3Dmodel.modelFitPara_VAJ(2),result.PSTH3Dmodel.modelFitPara_VAJ(3),result.PSTH3Dmodel.VAJ_wV,result.PSTH3Dmodel.VAJ_wA,result.PSTH3Dmodel.VAJ_wJ,result.PSTH3Dmodel.VAJ_preDir_V(1),result.PSTH3Dmodel.VAJ_preDir_V(2),result.PSTH3Dmodel.VAJ_preDir_A(1),result.PSTH3Dmodel.VAJ_preDir_A(2),result.PSTH3Dmodel.VAJ_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VAJ(4),result.PSTH3Dmodel.modelFitPara_VAJ(8),result.PSTH3Dmodel.modelFitPara_VAJ(12),result.PSTH3Dmodel.VAJ_Delay_VA,result.PSTH3Dmodel.VAJ_Delay_JA,'...
                'result.PSTH3Dmodel.modelFitPara_VA(2),result.PSTH3Dmodel.modelFitPara_VA(3),result.PSTH3Dmodel.VA_wV,result.PSTH3Dmodel.VA_wA,result.PSTH3Dmodel.VA_preDir_V(1),result.PSTH3Dmodel.VA_preDir_V(2),result.PSTH3Dmodel.VA_preDir_A(1),result.PSTH3Dmodel.VA_preDir_A(2),result.PSTH3Dmodel.VA_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VA(4),result.PSTH3Dmodel.modelFitPara_VA(8),result.PSTH3Dmodel.VA_Delay_VA,'...
                'result.PSTH3Dmodel.modelFitPara_VAP(2),result.PSTH3Dmodel.modelFitPara_VAP(3),result.PSTH3Dmodel.VAP_wV,result.PSTH3Dmodel.VAP_wA,result.PSTH3Dmodel.VAP_wP,result.PSTH3Dmodel.VAP_preDir_V(1),result.PSTH3Dmodel.VAP_preDir_V(2),result.PSTH3Dmodel.VAP_preDir_A(1),result.PSTH3Dmodel.VAP_preDir_A(2),result.PSTH3Dmodel.VAP_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_VAP(4),result.PSTH3Dmodel.modelFitPara_VAP(8),result.PSTH3Dmodel.modelFitPara_VAP(12),result.PSTH3Dmodel.VAP_Delay_VA,result.PSTH3Dmodel.VAP_Delay_PA,'...
                'result.PSTH3Dmodel.modelFitPara_PVAJ(2),result.PSTH3Dmodel.modelFitPara_PVAJ(3),result.PSTH3Dmodel.PVAJ_wV,result.PSTH3Dmodel.PVAJ_wA,result.PSTH3Dmodel.PVAJ_wJ,result.PSTH3Dmodel.PVAJ_wP,result.PSTH3Dmodel.PVAJ_preDir_V(1),result.PSTH3Dmodel.PVAJ_preDir_V(2),result.PSTH3Dmodel.PVAJ_preDir_A(1),result.PSTH3Dmodel.PVAJ_preDir_A(2),result.PSTH3Dmodel.PVAJ_angleDiff_VA,result.PSTH3Dmodel.modelFitPara_PVAJ(4),result.PSTH3Dmodel.modelFitPara_PVAJ(8),result.PSTH3Dmodel.modelFitPara_PVAJ(12),result.PSTH3Dmodel.modelFitPara_PVAJ(16),result.PSTH3Dmodel.PVAJ_Delay_VA,result.PSTH3Dmodel.PVAJ_Delay_JA,result.PSTH3Dmodel.PVAJ_Delay_PA']};
            
    end
end
config.append = 1; % Overwrite or append
% keyboard;
SaveResult(config, result,model_catg);

% toc;
%}
end