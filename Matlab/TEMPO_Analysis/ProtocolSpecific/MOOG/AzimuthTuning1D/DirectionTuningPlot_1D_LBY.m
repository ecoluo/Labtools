% % AZIMUTH_TUNING_1D.m -- Plots PSTHs for 1D tuning
% %     LBY, 20200319
% %-----------------------------------------------------------------------------------------------------------------------
function DirectionTuningPlot_1D_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag);

global PSTH;

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

stimType{1}='Vestibular';
stimType{2}='Visual';
stimType{3}='Combined';

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
    aziToHeadingSort = [aziToHeadingSort aziToHeadingSort(1)];
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
sig = [sqrt(sqrt(2))/6*4.5/3,sqrt(sqrt(2))/6,sqrt(sqrt(2))/6*4.5/6];
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
    PSTH.spk_data_bin_rate_aov{c} = nan*ones(26,nBins,max_reps);
    
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
    resp_std(c) = sum(resp_sse(c,:))/(sum(resp_trialnum(c,:))-26);
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
[~,h_subplot] = tight_subplot(4,length(aziToHeadingSort),0.04,0.15);

for c = 1:length(unique_condition_num)
    for i = 1:length(unique_azimuth)
        axes(h_subplot(i+c*9));
        errorbar(PSTH.spk_data_bin_mean_rate{c}(aziToHeadingSort(i),:),PSTH.spk_data_bin_mean_rate_ste{c}(aziToHeadingSort(i),:),'color','k');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3}(c) markers{n,3}(c)], [0,max(PSTH.maxSpkRealBinMean(c),PSTH.maxSpkSponBinMean)], '--','color',markers{n,4},'linewidth',3);
            hold on;
        end
        set(gca,'ylim',[0 max(PSTH.maxSpkRealBinMean(c)+PSTH.maxSpkRealBinMeanSte(c),PSTH.maxSpkSponBinMean+PSTH.maxSpkSponBinMeanSte)],'xlim',[1 nBins(1,1)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
%         set(gca,'yticklabel',[]);
    end
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

axes('unit','pixels','pos',[1600 100 100 500]);
text(0,0.75,'sigma = 3','fontsize',15);
text(0,0.5,'sigma = 4.5','fontsize',15);
text(0,0.15,'sigma = 6','fontsize',15);
axis off;

% to save the figures
str3 = [str, '_PSTH_1D_vestibular'];
set(gcf,'paperpositionmode','auto');
ss = [str3, '_T'];
% saveas(3,['Z:\LBY\Recording data\',monkey,'\1D_Tuning\' ss], 'emf');

%}

%% Data Saving

%{
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
%}
% toc;
return;
end


