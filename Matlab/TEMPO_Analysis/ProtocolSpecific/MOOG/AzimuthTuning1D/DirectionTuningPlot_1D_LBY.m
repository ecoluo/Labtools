% % AZIMUTH_TUNING_1D.m -- Plots PSTHs for 1D tuning
% %     LBY, 20200319
% %-----------------------------------------------------------------------------------------------------------------------
function DirectionTuningPlot_1D_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag);

global PSTH PSTH1Dmodel;
PSTH = []; PSTH1Dmodel = [];

TEMPO_Defs;
Path_Defs;
ProtocolDefs; %contains protocol specific keywords - 1/4/01 BJP

monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch monkey_inx
    case '5'
        PSTH.monkey = 'Polo';
    case '6'
        PSTH.monkey = 'Qiaoqiao';
    case '4'
        PSTH.monkey = 'Whitefang';
end

nSigmas = [3,4.5,6];
nSigma{1}='3';
nSigma{2}='4_5';
nSigma{3}='6';

% nSigmas = [2.7,6];
% nSigma{1}='2_7';
% nSigma{2}='6';

%% get data
% stimulus type,azi,ele,amp and duration

% temporarily, for htb missing cells
if data.one_time_params(NULL_VALUE) == 0
    data.one_time_params(NULL_VALUE) = -9999;
end


trials = 1:size(data.moog_params,2); % the No. of all trials
% find the trials for analysis
temp_trials = trials(find( (data.moog_params(STIMULUS_TYPE,trials,MOOG) ~= data.one_time_params(NULL_VALUE)) )); % 26*rept trials
temp_stimType = data.moog_params(STIMULUS_TYPE,temp_trials,MOOG);

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
temp_num_sigmas = data.moog_params(NUM_SIGMAS,real_trials,MOOG);
temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms

unique_azimuth = munique(temp_azimuth');
unique_elevation = munique(temp_elevation');
unique_amplitude = munique(temp_amplitude');
unique_duration = munique(temp_duration');
unique_stimType = munique(temp_stimType');
unique_num_sigmas = munique(temp_num_sigmas');

% descide whether loop is stim_type or num_sigmas (and it's the vestibular only condition)

if length(unique_num_sigmas)>1
    temp_condition_num = temp_num_sigmas;
else
    temp_condition_num = temp_stim_type;
end

unique_condition_num = munique(temp_condition_num');

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


% If this is a discrimination protocol, Transferred from azimuth to heading. HH20140415
unique_azimuth_plot_heading = aziToHeading(unique_azimuth');
[unique_azimuth_plot_heading, aziToHeadingSort] = sort(unique_azimuth_plot_heading);

if sum(abs(unique_azimuth_plot_heading) == 180) > 0 % Make it circular
    unique_azimuth_plot_heading = [unique_azimuth_plot_heading unique_azimuth_plot_heading(1)+360];
    %     aziToHeadingSort = [aziToHeadingSort aziToHeadingSort(1)];
else % Don't make it circular
end

%%%%%%%% pack data for PSTH, modeling and analysis
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

% sigma = 3, 4.5, 6
delay = [130,145,136]; % in ms, system time delay, LBY modified, 20200311.real velocity peak-theoretical veolocity peak
aMax = [490,585,630]; % in ms, peak acceleration time relative to real stim on time, measured time
aMin = [990,950,886]; % in ms, trough acceleration time relative to real stim on time, measured time

% % sigma = 2.7, 6
% delay = [176,176]; % in ms, system time delay, LBY modified, 20200311.real velocity peak-theoretical veolocity peak
% aMax = [421,606]; % in ms, peak acceleration time relative to real stim on time, measured time
% aMin = [1029,850]; % in ms, trough acceleration time relative to real stim on time, measured time


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
% sig = 1.5/2/4.5; % sig =  duration/2/num_of_sigma
sig = unique_duration/1000/2./nSigmas;
for cc = 1:length(sig)
    v_timeProfile{cc} = [ones(1,stimOnBin-1)*vel_profile([mu sig(cc)],stimOnBin*timeStep/1000),vel_profile([mu sig(cc)],(stimOnBin:stimOffBin)*timeStep/1000),ones(1,nBins-stimOffBin)*vel_profile([mu sig(cc)],stimOffBin*timeStep/1000)];
    a_timeProfile{cc} = [ones(1,stimOnBin-1)*acc_profile([mu sig(cc)],stimOnBin*timeStep/1000),acc_profile([mu sig(cc)],(stimOnBin:stimOffBin)*timeStep/1000),ones(1,nBins-stimOffBin)*acc_profile([mu sig(cc)],stimOffBin*timeStep/1000)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now, pack the data
% spk rates of real trials (no spon)
for c = 1:length(unique_condition_num)
    
    pc = 0;
    
    % initialize
    % for contour
    PSTH.spk_data_count_mean_rate{c} = [];
    
    % PSTH
    PSTH.spk_data_bin_mean_rate{c} = []; % mean spike count per time window (for PSTH) % 1*nbins
    spk_data_bin_mean_rate_std{c} = [];
    PSTH.spk_data_bin_mean_rate_ste{c} = [];
    PSTH.spk_data_bin_rate_aov{c} = [];% for PSTH ANOVA
    PSTH.spk_data_bin_rate_aov{c} = nan*ones(length(unique_azimuth),nBins,max_reps);
    
    for i = 1:length(unique_azimuth)
        % initialize
        % for contour
        PSTH.spk_data_count_rate{c,i} = [];
        PSTH.spk_data_count_rate_all{c,i} = [];
        
        spk_data{c,i} = []; % raw spike count (transform spike_data to a more clear way)
        PSTH.spk_data_bin_rate{c,i} = []; % spike counts per time window (for PSTH across trials)
        
        % find specified conditions with repetitions -> pack the data
        select = find( (temp_azimuth == unique_azimuth(i)) & (temp_num_sigmas == unique_num_sigmas(c))) ;
        if sum(select)>0
            spk_data{c,i} = spike_data(:,select);
            pc = pc+1;
            
            % for contour
            spk_data_count_rate_anova{c,pc} = [];
            spk_data_count_rate_anova{c,pc} =  sum(spk_data{c,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000);
            resp_sse(c,pc) = sum((spk_data_count_rate_anova{c,pc} - mean(spk_data_count_rate_anova{c,pc})).^2); % for DDI
            resp_trialnum(c,pc)= size(spk_data_count_rate_anova{c,pc},2); % for DDI
        else
            disp('There must be something wrong with your files!');
        end
        
        % pack data for PSTH
        PSTH.spk_data_bin_rate{c,i} = PSTH_smooth(nBins, PSTH_onT, timeWin, timeStep, spk_data{c,i}(:,:), 2, gau_sig);
        try
            temp = PSTH_smooth( nBins, PSTH_onT, timeWin, timeStep, spk_data{c,i}(:,:), 2, gau_sig);
            PSTH.spk_data_bin_rate_aov{c}(pc,:,1:size(temp,2)) = temp;
            temp = PSTH_smooth( nBinsPCA, stimOnT, PCAWin, PCAStep, mean(spk_data{c,i}(:,:),2), 1, 0);
            PSTH.spk_data_bin_rate_PCA{c}(pc,:,1:size(temp,2)) = temp;
        catch
            
        end
        
        PSTH.spk_data_bin_mean_rate_PCA{c}(pc,:) = nanmean(PSTH.spk_data_bin_rate_PCA{c}(pc,:,:),3);
        PSTH.spk_data_bin_mean_rate_aov{c}(pc,:) = nanmean(PSTH.spk_data_bin_rate_aov{c}(pc,:,:),3);
        
        % calculate correlation coefficient between response and V/A curve
        [R,P] = corrcoef(v_timeProfile{c},PSTH.spk_data_bin_mean_rate_aov{c}(pc,:));
        PSTH.coef_v{c}(1,pc) = R(1,2);
        PSTH.coef_v{c}(2,pc) = P(1,2);
        [R,P] = corrcoef(a_timeProfile{c},PSTH.spk_data_bin_mean_rate_aov{c}(pc,:));
        PSTH.coef_a{c}(1,pc) = R(1,2);
        PSTH.coef_a{c}(2,pc) = P(1,2);
        
        PSTH.spk_data_bin_mean_rate{c}(i,:) = mean(PSTH.spk_data_bin_rate{c,i},2);
        PSTH.spk_data_bin_vector{c} = PSTH.spk_data_bin_mean_rate{c};
        PSTH.spk_data_bin_vector{c}([1,5],2:end,:) = 0;
        spk_data_bin_mean_rate_std{c}(i,:) = std(PSTH.spk_data_bin_rate{c,i},0,2);
        PSTH.spk_data_bin_mean_rate_ste{c}(i,:) = spk_data_bin_mean_rate_std{c}(i,:)/sqrt(size(PSTH.spk_data_bin_rate{c,i}(1,:),2));
        
        % pack data for contour
        PSTH.spk_data_count_rate{c,i} = sum(spk_data{c,i}(stimOnT(1)+tBeg:stimOffT(1)-tEnd,:),1)/((unique_duration(1,1)-tBeg-tEnd)/1000); % rates
        PSTH.spk_data_count_mean_rate{c}(i) = mean(PSTH.spk_data_count_rate{c,i}(:));% for countour plot and ANOVA
        PSTH.spk_data_count_rate_all{c,i} = sum(spk_data{c,i}(stimOnT(1):stimOffT(1),:),1)/(unique_duration(1,1)/1000); % rates of all duration
        PSTH.spk_data_count_mean_rate_all{c}(i) = mean(PSTH.spk_data_count_rate_all{c,i}(:));% for models
        spk_data_vector_rate{c,i} = sum(spk_data{c,i}(stimOnT(1)+tBeg:stimOnT(1)+tBeg+unique_duration(1,1)/2,:),1)/((unique_duration(1,1)/2)/1000); % rates
        PSTH.spk_data_vector{c}(i) = mean(spk_data_vector_rate{c,i}(:)); % for preferred direction
        PSTH.spk_data_vector{c}([1,5],2:end) = 0;
        
    end
    
    % preliminary analysis
    
    PSTH.time_profile{c} = sum(PSTH.spk_data_bin_mean_rate{c},1);
    PSTH.spk_data_bin_mean_rate_aov_cell{c} = mean(PSTH.spk_data_bin_mean_rate_aov{c},1);
    maxSpkRealMean(c) = max(PSTH.spk_data_count_mean_rate{c}(:));
    minSpkRealMean(c) = min(PSTH.spk_data_count_mean_rate{c}(:));
    PSTH.maxSpkRealBinMean(c) = max(PSTH.spk_data_bin_mean_rate{c}(:));
    PSTH.minSpkRealBinMean(c) = min(PSTH.spk_data_bin_mean_rate{c}(:));
    PSTH.maxSpkRealBinAll(c) = max(PSTH.spk_data_bin_rate_aov{c}(:));
    PSTH.maxSpkRealBinMeanSte(c) = max(PSTH.spk_data_bin_mean_rate_ste{c}(:));
    
    % calculate DDT & preferred directions for tuning
    numReps(c) = max(cell2mat(cellfun(@length,spk_data_count_rate_anova(c,:),'UniformOutput',false)));
    for nn = 1:length(spk_data_count_rate_anova(c,:))
        if length(spk_data_count_rate_anova{c,nn})<numReps(c)
            spk_data_count_rate_anova{c,nn} = [spk_data_count_rate_anova{c,nn} nan*ones(1,(numReps(c)-length(spk_data_count_rate_anova{c,nn})))];
        end
    end
    spk_data_count_rate_anova_trans{c} = reshape(cell2mat(spk_data_count_rate_anova(c,:)),[numReps(c),length(spk_data_count_rate_anova(c,:))]);
    p_anova_dire(c) = anova1(spk_data_count_rate_anova_trans{c},'','off'); % tuning anova
    resp_std(c) = sum(resp_sse(c,:))/(sum(resp_trialnum(c,:))-length(unique_azimuth));
    DDI(c) = (maxSpkRealMean(c)-minSpkRealMean(c))/(maxSpkRealMean(c)-minSpkRealMean(c)+2*sqrt(resp_std(c)));
    [Azi, Ele, Amp] = vectorsum(PSTH.spk_data_vector{c}(:,:));
    preferDire{c} = [Azi, Ele, Amp];
    
    % calculate the differences between every direction and the preferred direction
    azis = reshape(repmat([0 45 90 135 180 225 270 315],5,1),[],1);
    eles = repmat([-90 -45 0 45 90],1,8)';
    pre_diff{c} = angleDiff(azis,eles,ones(1,40),ones(1,40)*preferDire{c}(1),ones(1,40)*preferDire{c}(2),ones(1,40));
    
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

%% Temporal analysis
% %{
% based on Chen, AH et al., 2010, JNS
% wilcoxon rank sum test
% 500 ms after stim. on to 50ms before stim off

baselineBinBeg = stimOnBin-floor(100/timeStep);
baselineBinEnd = stimOnBin+floor(200/timeStep);

for c = 1:length(unique_condition_num)
    %     spk_data_bin_rate_mean_minusSpon{c} = PSTH.spk_data_bin_mean_rate_aov{c}-repmat(PSTH.spon_spk_data_bin_mean_rate',size(PSTH.spk_data_bin_mean_rate_aov{c},1),1);
    sPeak{c} = zeros(1,size(PSTH.spk_data_bin_rate_aov{c},1)); % store the number of significant bins
    sTrough{c} = zeros(1,size(PSTH.spk_data_bin_rate_aov{c},1)); % store the number of significant bins
    peakDir{c} = []; % the number of local peak direction
    peakR{c} = []; % the response of local peak direction
    localPeak{c} = []; % find the local peak bin of each direction
    localTrough{c} = []; % find the local trough bin of each direction
    PSTH.peak{c} = []; % location of peaks
    PSTH.trough{c} = []; % location of troughs
    PSTH.NoPeaks(c) = 0; % number of peaks
    PSTH.NoTroughs(c) = 0; % location of troughs
    PSTH.respon_sigTrue(c) = 0; % PSTH.sigTrue(pc) -> sig. of this cell
    
    
    % --------- to test if this direction is temporally responded -------%
    
    for pc = 1:size(PSTH.spk_data_bin_rate_aov{c},1)
        
        PSTH.sigBin{c,pc} = []; % find if this bin is sig.
        PSTH.sigTrue{c}(pc) = 0; % PSTH.sigTrue(pc) -> sig. of this direction
        
        % if 5 consecutive bins are sig.,then we say this bin is sig.
        % That is, this direction is temporally responded
        for nn = stimOnBin : stimOffBin
            s{c,pc}(nn) = 0;
            for ii = nn-2:nn+2
                try
                    if ranksum(squeeze(PSTH.spk_data_bin_rate_aov{c}(pc,ii,:))',squeeze(nanmean(PSTH.spk_data_bin_rate_aov{c}(pc,baselineBinBeg:baselineBinEnd,:)))') < 0.05
                        s{c,pc}(nn) =  s{c,pc}(nn)+1;
                    end
                catch
                    keyboard;
                end
            end
            if s{c,pc}(nn) == 5
                PSTH.sigBin{c,pc} = [PSTH.sigBin{c,pc};nn]; %
            end
            
            if ~isempty(PSTH.sigBin{c,pc})
                PSTH.sigTrue{c}(pc) = 1; % PSTH.sigTrue(pc) == 1 -> sig. of this direction
            end
        end
    end
    
    PSTH.sig(c) = sum(PSTH.sigTrue{c}(:)); % sig No.of directions
    
    % --------------- this cell is temporally responded ------------------%
    
    % 2个方向,不需要相邻
    if sum(PSTH.sigTrue{c}(:)) >=2
        PSTH.respon_sigTrue(c) = 1;
    end
    % 相邻2个方向
    %     if respon_True(PSTH.sigTrue{c}(:)) == 1
    %         PSTH.respon_sigTrue(c) = 1;
    %
    %     end
    
    p_anova_dire_t{c} = nan;
    DDI_t{c} = nan;
    DDI_p_t{c} = nan;
    preferDire_t{c} = nan(3,1);
    PSTH.spk_data_sorted_PCA{c} = nan;
    
    if PSTH.respon_sigTrue(c) == 1
        
        % --------- to find local peaks & throughs -------%
        peakR{c} = NaN(1,nBins);peakDir{c} = NaN(1,nBins);p{c} = NaN(1,nBins);
        for nn = stimOnBin : stimOffBin
            [peakR{c}(nn),peakDir{c}(nn)] = max(PSTH.spk_data_bin_mean_rate_aov{c}(:,nn));
            try
                p{c}(nn) = anova1(squeeze(PSTH.spk_data_bin_rate_aov{c}(:,nn,:))','','off');
            catch
                keyboard;
            end
        end
        pp = 0;th = 0;
        for tt = stimOnBin+2 : stimOffBin-2
            
            if (peakR{c}(tt) > peakR{c}(tt-1)) && (peakR{c}(tt) > peakR{c}(tt+1))...
                    && p{c}(tt) < 0.05 && p{c}(tt-1) < 0.05 && p{c}(tt-2) < 0.05 && p{c}(tt+1) < 0.05 && p{c}(tt+2) < 0.05
                pp = pp+1; % how many peaks
                localPeak{c}(pp,1)= tt;
                localPeak{c}(pp,2)= peakR{c}(tt);
            end
            if (peakR{c}(tt) < peakR{c}(tt-1)) && (peakR{c}(tt) < peakR{c}(tt+1))...
                    && p{c}(tt) < 0.05 && p{c}(tt-1) < 0.05 && p{c}(tt-2) < 0.05 && p{c}(tt+1) < 0.05 && p{c}(tt+2) < 0.05
                th = th+1; % how many throughs
                localTrough{c}(th,1)= tt;
                localTrough{c}(th,2)= peakR{c}(tt);
            end
        end
        
        % --------- to find real peaks & throughs? -------%
        
        if ~isempty(localPeak{c})
            localPeak{c} = sortrows(localPeak{c},-2)'; % sort according to response
            PSTH.peak{c} = localPeak{c}(1,1); % True peaks, here the largest one is sure to be the 1st peak
            
            % find other peaks
            % conpare the correlation coefficient between the largest one and each other bin
            if size(localPeak{c},2)>1
                n = 1;
                while n < size(localPeak{c},1)
                    ii = n+1;
                    while ii < size(localPeak{c},1)+1
                        try
                            [rCorr,pCorr] = corrcoef(PSTH.spk_data_bin_mean_rate_aov{c}(:,localPeak{c}(1,n)),PSTH.spk_data_bin_mean_rate_aov{c}(:,localPeak{c}(1,ii)));
                        catch
                            
                        end
                        if ~(rCorr(1,2) > 0 && pCorr(1,2) < 0.05)
                            PSTH.peak{c} = [PSTH.peak{c} localPeak{c}(1,ii)];
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
        PSTH.NoPeaks(c) = length(PSTH.peak{c});
        % find the direction with the max peak response ( the first peak )
        if ~isempty(PSTH.peak{c})
            [PSTH.peakMaxRespon(c),PSTH.peakMaxDir(c)] = max(PSTH.spk_data_bin_mean_rate{c}(:,PSTH.peak{c}(1)));
        else
            PSTH.peakMaxRespon(c) = nan;
            PSTH.peakMaxDir(c) = nan;
        end
        % calculate the half width of each direction
        for i = 1: length(unique_azimuth)
            try
            PSTH.hwPeak(c,i) = fwhm(1: nBins, PSTH.spk_data_bin_mean_rate{c}(i,:));
            catch
                keyboard;
            end
        end
        
        % calculate DDI for each peak time
        for pt = 1:PSTH.NoPeaks(c)
            for pc = 1:size(PSTH.spk_data_bin_rate_aov{c},1)
                resp_sse_t{c}(pc,pt) = nansum((PSTH.spk_data_bin_rate_aov{c}(pc,PSTH.peak{c}(pt),:) - nanmean(PSTH.spk_data_bin_rate_aov{c}(pc,PSTH.peak{c}(pt),:))).^2); % for DDI
                resp_trialnum_t{c}(pc,pt)= size(PSTH.spk_data_bin_rate_aov{c}(pc,PSTH.peak{c}(pt),:),3); % for DDI
            end
            
            try
                p_anova_dire_t{c}(pt) = anova1(squeeze(PSTH.spk_data_bin_rate_aov{c}(:,PSTH.peak{c}(pt),:))','','off'); % tuning anova
                resp_std_t{c}(pt) = sum(resp_sse_t{c}(:,pt))/(sum(resp_trialnum_t{c}(:,pt))-length(unique_azimuth));
                maxSpkRealMean_t{c}(pt) = max(max(squeeze((PSTH.spk_data_bin_rate_aov{c}(:,PSTH.peak{c}(pt),:)))));
                minSpkRealMean_t{c}(pt) = min(min(squeeze((PSTH.spk_data_bin_rate_aov{c}(:,PSTH.peak{c}(pt),:)))));
                DDI_t{c}(pt) = (maxSpkRealMean_t{c}(pt)-minSpkRealMean_t{c}(pt))/(maxSpkRealMean_t{c}(pt)-minSpkRealMean_t{c}(pt)+2*sqrt(resp_std_t{c}(pt)));
                
                % DDI permutation
                num_perm = 1000;
                for nn = 1 : num_perm
                    temp = squeeze(PSTH.spk_data_bin_rate_aov{c}(:,PSTH.peak{c}(pt),:));
                    temp = temp(:);
                    temp = temp(randperm(length(unique_azimuth)*size(PSTH.spk_data_bin_rate_aov{c},3)));
                    temp = reshape(temp,length(unique_azimuth),[]);
                    temp = nanmean(temp,2);
                    maxSpkRealMean_perm_t{c}(nn,pt) = max(temp);
                    minSpkRealMean_perm_t{c}(nn,pt) = min(temp);
                    DDI_perm_t{c}(pt,nn) = (maxSpkRealMean_perm_t{c}(nn,pt)-minSpkRealMean_perm_t{c}(nn,pt))/(maxSpkRealMean_perm_t{c}(nn,pt)-minSpkRealMean_perm_t{c}(nn,pt)+2*sqrt(resp_std_t{c}(pt)));
                    
                end
                DDI_p_t{c}(pt) = sum(DDI_perm_t{c}(pt,:)>DDI_t{c}(pt))/num_perm;
                
                % preferred direction
                %                 [Azi, Ele, Amp] = vectorsum(squeeze(PSTH.spk_data_bin_vector{c}(:,:,PSTH.peak{c}(pt))));
                %                 preferDire_t{c}(:,pt) = [Azi, Ele, Amp];
            catch
                keyboard;
            end
        end
        
        % sort PCA according to the maximum of direction
        if ~isempty(PSTH.peak{c})
            [~, temp_inx] = sortrows(PSTH.spk_data_bin_mean_rate_PCA{c}(:,PSTH.peak{c}(1)),-1);
            PSTH.spk_data_sorted_PCA{c} = PSTH.spk_data_bin_mean_rate_PCA{c}(temp_inx,:);
        else
            PSTH.spk_data_sorted_PCA{c} = PSTH.spk_data_bin_mean_rate_PCA{c};
        end
    end
end


%}

%% Figures
% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% the time markers
markers = {
    % markerName % markerTime % marker bin time % color % linestyle
    'aMax',stimOnT(1)+aMax,(stimOnT(1)+aMax-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'aMin',stimOnT(1)+aMin,(stimOnT(1)+aMin-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'v',stimOnT(1)+aMax+(aMin-aMax)/2,(stimOnT(1)+aMax+(aMin-aMax)/2-PSTH_onT+timeStep)/timeStep,'r','--';
    };

Bin = [nBins,(stimOnT(1)-PSTH_onT+timeStep)/timeStep,(stimOffT(1)-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+719-PSTH_onT+timeStep)/timeStep,(stimOnT(1)+1074-PSTH_onT+timeStep)/timeStep];

% % ------ fig.3 plot mean PSTHs across directions and num_sigmas (with errorbar)------%
% %{
figure(3);
set(gcf,'pos',[60 100 1800 800]);
clf;
[~,h_subplot] = tight_subplot(4,length(aziToHeadingSort)+1,0.04,0.15);

for c = 1:length(unique_condition_num)
    for i = 1:length(unique_azimuth)
        axes(h_subplot(i+c*(length(aziToHeadingSort)+1)));
        errorbar(PSTH.spk_data_bin_mean_rate{c}(aziToHeadingSort(i),:),PSTH.spk_data_bin_mean_rate_ste{c}(aziToHeadingSort(i),:),'color','k');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3}(c) markers{n,3}(c)], [0,max(max(max(PSTH.maxSpkRealBinMean)+max(PSTH.maxSpkRealBinMeanSte),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte))], '--','color',markers{n,4},'linewidth',3);
            hold on;
        end
        set(gca,'ylim',[0 max(max(PSTH.maxSpkRealBinMean)+max(PSTH.maxSpkRealBinMeanSte),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte)],'xlim',[1 nBins(1,1)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
        %         set(gca,'yticklabel',[]);
        
    end
    
axes(h_subplot((c+1)*(length(aziToHeadingSort)+1)));
text(0,0.5,['sigma = ',nSigma{c}],'fontsize',15);
axis off;

end

% spontaneous
axes(h_subplot(1));
errorbar(PSTH.spon_spk_data_bin_mean_rate,PSTH.spon_spk_data_bin_mean_rate_ste,'color','k');
hold on;
set(gca,'ylim',[0 max(PSTH.maxSpkRealBinMean(c)+PSTH.maxSpkRealBinMeanSte(c),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte)],'xlim',[1 nBins(1,1)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);
% text on the figure
axes('unit','pixels','pos',[60 810 1800 80]);
xlim([0,100]);
ylim([0,10]);

text(36,-10,'PSTHs for different sigmas, in horizontal plane','fontsize',20);

text(2,-14,'spontaneous','fontsize',15);
FileNameTemp = num2str(FILE);
FileNameTemp =  FileNameTemp(1:end);
str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan)];
text(70,-15,str1,'fontsize',18);
axis off;

axes('unit','pixels','pos',[60 -40 1800 100]);
xlim([0,100]);
ylim([0,10]);
text(0,7,['Spon max FR(Hz): ',num2str(PSTH.maxSpkSponBinMean), ' (Bin)'],'fontsize',15);
text(0,10,['Spon mean FR(Hz): ',num2str(PSTH.meanSpkSponBinMean), ' (Bin)'],'fontsize',15);
axis off;


% to save the figures
str3 = [str, '_PSTH_1D_vestibular'];
set(gcf,'paperpositionmode','auto');
ss = [str3, '_T'];
saveas(3,['Z:\LBY\Recording data\',PSTH.monkey,'\1D_Tuning\' ss], 'emf');

%}

% % ------ fig.4 plot mean PSTHs across directions and num_sigmas (without errorbar)------%
% %{
figure(4);
set(gcf,'pos',[60 100 1800 800]);
clf;
[~,h_subplot] = tight_subplot(4,length(aziToHeadingSort)+1,0.04,0.15);

for c = 1:length(unique_condition_num)
    for i = 1:length(unique_azimuth)
        axes(h_subplot(i+c*(length(aziToHeadingSort)+1)));
        plot(PSTH.spk_data_bin_mean_rate{c}(aziToHeadingSort(i),:),'color','k','linewidth',5);
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3}(c) markers{n,3}(c)], [0,max(max(max(PSTH.maxSpkRealBinMean)+max(PSTH.maxSpkRealBinMeanSte),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte))], '--','color',markers{n,4},'linewidth',3);
            hold on;
        end
        set(gca,'ylim',[0 max(max(PSTH.maxSpkRealBinMean)+max(PSTH.maxSpkRealBinMeanSte),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte)],'xlim',[1 nBins(1,1)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
        %         set(gca,'yticklabel',[]);
    end
axes(h_subplot((c+1)*(length(aziToHeadingSort)+1)));
text(0,0.5,['sigma = ',nSigma{c}],'fontsize',15);
axis off;
end

% spontaneous
axes(h_subplot(1));
plot(PSTH.spon_spk_data_bin_mean_rate,'color','k','linewidth',5);
hold on;
set(gca,'ylim',[0 max(PSTH.maxSpkRealBinMean(c)+PSTH.maxSpkRealBinMeanSte(c),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte)],'xlim',[1 nBins(1,1)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);
% text on the figure
axes('unit','pixels','pos',[60 810 1800 80]);
xlim([0,100]);
ylim([0,10]);

text(36,-10,'PSTHs for different sigmas, in horizontal plane','fontsize',20);

text(2,-14,'spontaneous','fontsize',15);
FileNameTemp = num2str(FILE);
FileNameTemp =  FileNameTemp(1:end);
str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan)];
text(70,-15,str1,'fontsize',18);
axis off;

axes('unit','pixels','pos',[60 -40 1800 100]);
xlim([0,100]);
ylim([0,10]);
text(0,7,['Spon max FR(Hz): ',num2str(PSTH.maxSpkSponBinMean), ' (Bin)'],'fontsize',15);
text(0,10,['Spon mean FR(Hz): ',num2str(PSTH.meanSpkSponBinMean), ' (Bin)'],'fontsize',15);
axis off;

% to save the figures
str3 = [str, '_PSTH_1D_vestibular_report'];
set(gcf,'paperpositionmode','auto');
ss = [str3, '_T'];
saveas(4,['Z:\LBY\Recording data\',PSTH.monkey,'\1D_Tuning\' ss], 'emf');

%}

%% 1D models nalysis
model_catg = [];
% %{
model_catg = 'Sync model'; % tau is the same
% model_catg = 'Out-sync model'; % each component has its own tau

models = {'VA','VO','AO'};
models_color = {'k','r',colorDBlue};



spon_flag = 0; % 0 means raw data; 1 means mean(raw)-mean(spon) data

reps = 20;
% reps = 2;

for c = 1:length(unique_condition_num)
    % for k = 1
    %     if PSTH.respon_sigTrue(c) == 1
    
    % fit data with raw PSTH data or - spon data
    switch spon_flag
        case 0 %raw data
            models_fitting_1D_sigmas(model_catg,models,models_color,FILE,SpikeChan, Protocol,c,meanSpon,squeeze(PSTH.spk_data_bin_mean_rate{c}(:,stimOnBin:stimOffBin)),PSTH.spk_data_count_mean_rate_all{c},PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax(c),aMin(c),timeStep,unique_duration,nSigma,sig(c));
        case 1 % - spon data, so meanspon == 0
            PSTH.spk_data_bin_mean_rate{c} = PSTH.spk_data_bin_mean_rate{c} - permute(reshape(repmat(PSTH.spon_spk_data_bin_mean_rate,8,5),[],8,5),[3 2 1]);
            PSTH.spk_data_count_mean_rate_all{c} = PSTH.spk_data_count_mean_rate_all{c} - meanSpkSponMean; % 会出现负值
            %                 PSTH.spon_spk_data_bin_mean_rate = meanSpkSponMean;
            models_fitting_1D_sigmas(model_catg,models,models_color,FILE,SpikeChan, Protocol,c,0,squeeze(PSTH.spk_data_bin_mean_rate{c}(:,stimOnBin:stimOffBin)),PSTH.spk_data_count_mean_rate_all{c},PSTH.spon_spk_data_bin_mean_rate(stimOnBin:stimOffBin),nBins,reps,markers,stimOnBin,stimOffBin,aMax(c),aMin(c),timeStep,unique_duration,nSigma,sig(c));
    end
    
    if sum(ismember(models,'PVAJ')) ~= 0
        
        PSTH1Dmodel{c}.PVAJ_wP = (1-PSTH1Dmodel{c}.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel{c}.modelFitPara_PVAJ(17))*PSTH1Dmodel{c}.modelFitPara_PVAJ(16);
        PSTH1Dmodel{c}.PVAJ_wV = (1-PSTH1Dmodel{c}.modelFitPara_PVAJ(18))*(1-PSTH1Dmodel{c}.modelFitPara_PVAJ(17))*(1-PSTH1Dmodel{c}.modelFitPara_PVAJ(16));
        PSTH1Dmodel{c}.PVAJ_wA = (1-PSTH1Dmodel{c}.modelFitPara_PVAJ(18))*PSTH1Dmodel{c}.modelFitPara_PVAJ(17);
        PSTH1Dmodel{c}.PVAJ_wJ = PSTH1Dmodel{c}.modelFitPara_PVAJ(18);
        [PSTH1Dmodel{c}.PVAJ_preDir_V(1),PSTH1Dmodel{c}.PVAJ_preDir_V(2),PSTH1Dmodel{c}.PVAJ_preDir_V(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_PVAJ.V);
        [PSTH1Dmodel{c}.PVAJ_preDir_A(1),PSTH1Dmodel{c}.PVAJ_preDir_A(2),PSTH1Dmodel{c}.PVAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_PVAJ.A);
        PSTH1Dmodel{c}.PVAJ_angleDiff_VA = angleDiff(PSTH1Dmodel{c}.PVAJ_preDir_V(1),PSTH1Dmodel{c}.PVAJ_preDir_V(2),PSTH1Dmodel{c}.PVAJ_preDir_V(3),PSTH1Dmodel{c}.PVAJ_preDir_A(1),PSTH1Dmodel{c}.PVAJ_preDir_A(2),PSTH1Dmodel{c}.PVAJ_preDir_A(3));
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.PVAJ_Delay_VA = PSTH1Dmodel{c}.modelFitPara_PVAJ(19);
            PSTH1Dmodel{c}.PVAJ_Delay_JA = PSTH1Dmodel{c}.modelFitPara_PVAJ(20);
            PSTH1Dmodel{c}.PVAJ_Delay_PA = PSTH1Dmodel{c}.modelFitPara_PVAJ(21);
        end
        
    elseif sum(ismember(models,'PVAJ')) == 0
        PSTH1Dmodel{c}.PVAJ_wV = nan;
        PSTH1Dmodel{c}.PVAJ_wA = nan;
        PSTH1Dmodel{c}.PVAJ_wJ = nan;
        PSTH1Dmodel{c}.PVAJ_wP = nan;
        PSTH1Dmodel{c}.PVAJ_preDir_V = nan*ones(1,3);
        PSTH1Dmodel{c}.PVAJ_preDir_A = nan*ones(1,3);
        PSTH1Dmodel{c}.PVAJ_angleDiff_VA = nan;
        PSTH1Dmodel{c}.RSquared_PVAJ = nan;
        PSTH1Dmodel{c}.BIC_PVAJ = nan;
        PSTH1Dmodel{c}.modelFitPara_PVAJ = nan*ones(1,22);
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.PVAJ_Delay_VA = nan;
            PSTH1Dmodel{c}.PVAJ_Delay_JA = nan;
            PSTH1Dmodel{c}.PVAJ_Delay_PA = nan;
        end
    end
    
    if sum(ismember(models,'VAJ')) ~= 0
        if sum(ismember(models,'AJ')) ~= 0
            PSTH1Dmodel{c}.VAJ_R2V = ((PSTH1Dmodel{c}.RSquared_VAJ)^2 - (PSTH1Dmodel{c}.RSquared_AJ)^2)/(1-(PSTH1Dmodel{c}.RSquared_AJ)^2);
        else
            PSTH1Dmodel{c}.VAJ_R2V = nan;
        end
        if sum(ismember(models,'VJ')) ~= 0
            PSTH1Dmodel{c}.VAJ_R2A = ((PSTH1Dmodel{c}.RSquared_VAJ)^2 - (PSTH1Dmodel{c}.RSquared_VJ)^2)/(1-(PSTH1Dmodel{c}.RSquared_VJ)^2);
        else
            PSTH1Dmodel{c}.VAJ_R2A = nan;
        end
        if sum(ismember(models,'VA')) ~= 0
            PSTH1Dmodel{c}.VAJ_R2J = ((PSTH1Dmodel{c}.RSquared_VAJ)^2 - (PSTH1Dmodel{c}.RSquared_VA)^2)/(1-(PSTH1Dmodel{c}.RSquared_VA)^2);
        else
            PSTH1Dmodel{c}.VAJ_R2J = nan;
        end
        PSTH1Dmodel{c}.VAJ_wV = PSTH1Dmodel{c}.modelFitPara_VAJ(13)*(1-PSTH1Dmodel{c}.modelFitPara_VAJ(14));
        PSTH1Dmodel{c}.VAJ_wA = (1-PSTH1Dmodel{c}.modelFitPara_VAJ(13))*(1-PSTH1Dmodel{c}.modelFitPara_VAJ(14));
        PSTH1Dmodel{c}.VAJ_wJ = PSTH1Dmodel{c}.modelFitPara_VAJ(14);
        [PSTH1Dmodel{c}.VAJ_preDir_V(1),PSTH1Dmodel{c}.VAJ_preDir_V(2),PSTH1Dmodel{c}.VAJ_preDir_V(3)] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VAJ.V);
        [PSTH1Dmodel{c}.VAJ_preDir_A(1),PSTH1Dmodel{c}.VAJ_preDir_A(2),PSTH1Dmodel{c}.VAJ_preDir_A(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VAJ.A);
        PSTH1Dmodel{c}.VAJ_angleDiff_VA = angleDiff(PSTH1Dmodel{c}.VAJ_preDir_V(1),PSTH1Dmodel{c}.VAJ_preDir_V(2),PSTH1Dmodel{c}.VAJ_preDir_V(3),PSTH1Dmodel{c}.VAJ_preDir_A(1),PSTH1Dmodel{c}.VAJ_preDir_A(2),PSTH1Dmodel{c}.VAJ_preDir_A(3));
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VAJ_Delay_VA = PSTH1Dmodel{c}.modelFitPara_VAJ(15);
            PSTH1Dmodel{c}.VAJ_Delay_JA = PSTH1Dmodel{c}.modelFitPara_VAJ(16);
        end
    elseif sum(ismember(models,'VAJ')) == 0
        PSTH1Dmodel{c}.VAJ_wV = nan;
        PSTH1Dmodel{c}.VAJ_wA = nan;
        PSTH1Dmodel{c}.VAJ_wJ = nan;
        PSTH1Dmodel{c}.VAJ_preDir_V = nan*ones(1,3);
        PSTH1Dmodel{c}.VAJ_preDir_A = nan*ones(1,3);
        PSTH1Dmodel{c}.VAJ_angleDiff_VA = nan;
        PSTH1Dmodel{c}.RSquared_VAJ = nan;
        PSTH1Dmodel{c}.BIC_VAJ = nan;
        PSTH1Dmodel{c}.modelFitPara_VAJ = nan*ones(1,17);
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VAJ_Delay_VA = nan;
            PSTH1Dmodel{c}.VAJ_Delay_JA = nan;
        end
    end
    
    if sum(ismember(models,'VAP')) ~= 0
        if sum(ismember(models,'AP')) ~= 0
            PSTH1Dmodel{c}.VAP_R2V = ((PSTH1Dmodel{c}.RSquared_VAP)^2 - (PSTH1Dmodel{c}.RSquared_AP)^2)/(1-(PSTH1Dmodel{c}.RSquared_AP)^2);
        else
            PSTH1Dmodel{c}.VAP_R2V = nan;
        end
        if sum(ismember(models,'VP')) ~= 0
            PSTH1Dmodel{c}.VAP_R2A = ((PSTH1Dmodel{c}.RSquared_VAP)^2 - (PSTH1Dmodel{c}.RSquared_VP)^2)/(1-(PSTH1Dmodel{c}.RSquared_VP)^2);
        else
            PSTH1Dmodel{c}.VAP_R2A = nan;
        end
        if sum(ismember(models,'VA')) ~= 0
            PSTH1Dmodel{c}.VAP_R2P = ((PSTH1Dmodel{c}.RSquared_VAP)^2 - (PSTH1Dmodel{c}.RSquared_VA)^2)/(1-(PSTH1Dmodel{c}.RSquared_VA)^2);
        else
            PSTH1Dmodel{c}.VAP_R2P = nan;
        end
        PSTH1Dmodel{c}.VAP_wV = PSTH1Dmodel{c}.modelFitPara_VAP(13)*(1-PSTH1Dmodel{c}.modelFitPara_VAP(14));
        PSTH1Dmodel{c}.VAP_wA = (1-PSTH1Dmodel{c}.modelFitPara_VAP(13))*(1-PSTH1Dmodel{c}.modelFitPara_VAP(14));
        PSTH1Dmodel{c}.VAP_wP = PSTH1Dmodel{c}.modelFitPara_VAP(14);
        [PSTH1Dmodel{c}.VAP_preDir_V(1),PSTH1Dmodel{c}.VAP_preDir_V(2),PSTH1Dmodel{c}.VAP_preDir_V(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VAP.V);
        [PSTH1Dmodel{c}.VAP_preDir_A(1),PSTH1Dmodel{c}.VAP_preDir_A(2), PSTH1Dmodel{c}.VAP_preDir_A(3)] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VAP.A);
        PSTH1Dmodel{c}.VAP_angleDiff_VA = angleDiff(PSTH1Dmodel{c}.VAP_preDir_V(1),PSTH1Dmodel{c}.VAP_preDir_V(2),PSTH1Dmodel{c}.VAP_preDir_V(3),PSTH1Dmodel{c}.VAP_preDir_A(1),PSTH1Dmodel{c}.VAP_preDir_A(2),PSTH1Dmodel{c}.VAP_preDir_A(3));
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VAP_Delay_VA = PSTH1Dmodel{c}.modelFitPara_VAP(15);
            PSTH1Dmodel{c}.VAP_Delay_PA = PSTH1Dmodel{c}.modelFitPara_VAP(16);
        end
    elseif sum(ismember(models,'VAP')) == 0
        PSTH1Dmodel{c}.VAP_wV = nan;
        PSTH1Dmodel{c}.VAP_wA = nan;
        PSTH1Dmodel{c}.VAP_wP = nan;
        PSTH1Dmodel{c}.VAP_preDir_V = nan*ones(1,3);
        PSTH1Dmodel{c}.VAP_preDir_A = nan*ones(1,3);
        PSTH1Dmodel{c}.VAP_angleDiff_VA = nan;
        PSTH1Dmodel{c}.RSquared_VAP = nan;
        PSTH1Dmodel{c}.BIC_VAP = nan;
        PSTH1Dmodel{c}.modelFitPara_VAP = nan*ones(1,17);
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VAP_Delay_VA = nan;
            PSTH1Dmodel{c}.VAP_Delay_PA = nan;
        end
    end
    
    if sum(ismember(models,'VA')) ~= 0
        PSTH1Dmodel{c}.VA_wV = PSTH1Dmodel{c}.modelFitPara_VA(10);
        PSTH1Dmodel{c}.VA_wA = 1-PSTH1Dmodel{c}.modelFitPara_VA(10);
        [PSTH1Dmodel{c}.VA_preDir_V(1),PSTH1Dmodel{c}.VA_preDir_V(2),PSTH1Dmodel{c}.VA_preDir_V(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VA.V);
        [PSTH1Dmodel{c}.VA_preDir_A(1),PSTH1Dmodel{c}.VA_preDir_A(2),PSTH1Dmodel{c}.VA_preDir_A(3) ] = vectorsum(PSTH1Dmodel{c}.modelFitTrans_spatial_VA.A);
        PSTH1Dmodel{c}.VA_angleDiff_VA = angleDiff(PSTH1Dmodel{c}.VA_preDir_V(1),PSTH1Dmodel{c}.VA_preDir_V(2),PSTH1Dmodel{c}.VA_preDir_V(3),PSTH1Dmodel{c}.VA_preDir_A(1),PSTH1Dmodel{c}.VA_preDir_A(2),PSTH1Dmodel{c}.VA_preDir_A(3));
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VA_Delay_VA = PSTH1Dmodel{c}.modelFitPara_VA(11);
        end
        if sum(ismember(models,'AO')) ~= 0
            PSTH1Dmodel{c}.VA_R2V = ((PSTH1Dmodel{c}.RSquared_VA)^2 - (PSTH1Dmodel{c}.RSquared_AO)^2)/(1-(PSTH1Dmodel{c}.RSquared_AO)^2);
        else
            PSTH1Dmodel{c}.VA_R2A = nan;
        end
        if sum(ismember(models,'VO')) ~= 0
            PSTH1Dmodel{c}.VA_R2A = ((PSTH1Dmodel{c}.RSquared_VA)^2 - (PSTH1Dmodel{c}.RSquared_VO)^2)/(1-(PSTH1Dmodel{c}.RSquared_VO)^2);
        else
            PSTH1Dmodel{c}.VA_R2V = nan;
        end
    elseif sum(ismember(models,'VA')) == 0
        PSTH1Dmodel{c}.VA_wV = nan;
        PSTH1Dmodel{c}.VA_wA = nan;
        PSTH1Dmodel{c}.VA_preDir_V = nan*ones(1,3);
        PSTH1Dmodel{c}.VA_preDir_A = nan*ones(1,3);
        PSTH1Dmodel{c}.VA_angleDiff_VA = nan;
        PSTH1Dmodel{c}.RSquared_VA = nan;
        PSTH1Dmodel{c}.BIC_VA = nan;
        PSTH1Dmodel{c}.modelFitPara_VA = nan*ones(1,12);
        if strcmp(model_catg,'Out-sync model') == 1
            PSTH1Dmodel{c}.VA_Delay_VA = nan;
        end
    end
    if sum(ismember(models,'VO')) == 0
        PSTH1Dmodel{c}.RSquared_VO = nan;
        PSTH1Dmodel{c}.BIC_VO = nan;
    end
    if sum(ismember(models,'AO')) == 0
        PSTH1Dmodel{c}.RSquared_AO = nan;
        PSTH1Dmodel{c}.BIC_AO = nan;
    end
    if sum(ismember(models,'VJ')) == 0
        PSTH1Dmodel{c}.RSquared_VJ = nan;
        PSTH1Dmodel{c}.BIC_VJ = nan;
    end
    if sum(ismember(models,'AJ')) == 0
        PSTH1Dmodel{c}.RSquared_AJ = nan;
        PSTH1Dmodel{c}.BIC_AJ = nan;
    end
    if sum(ismember(models,'VP')) == 0
        PSTH1Dmodel{c}.RSquared_VP = nan;
        PSTH1Dmodel{c}.BIC_VP = nan;
    end
    if sum(ismember(models,'AP')) == 0
        PSTH1Dmodel{c}.RSquared_AP = nan;
        PSTH1Dmodel{c}.BIC_AP = nan;
    end
    %     else
    %         PSTH1Dmodel{c} = nan;
end
% end

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

result = PackResult(FILE, PATH, SpikeChan, unique_stimType,Protocol, ... % Obligatory!!
    unique_azimuth, unique_amplitude, unique_duration,...   % paras' info of trial
    markers,...
    timeWin, timeStep, tOffset1, tOffset2,nBins,Bin,PCAStep,PCAWin,nBinsPCA, ... % PSTH slide window info
    meanSpon, p_anova_dire, DDI,preferDire,PSTH, ... % PSTH and mean FR info
    PSTH1Dmodel); % model info


config.suffix = 'PSTH_T_1D';


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
%}
% toc;
return;
end


