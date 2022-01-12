% analyze functional Ultrasound imaging
% @LBY, Gu lab, 202112



function fUS_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, ~, StopOffset, PATH, FILE, batch_flag)

% tic;

global PSTH1Dmodel PSTH;
PSTH = []; PSTH1Dmodel = [];

% contains protocol etc. specific keywords
TEMPO_Defs;
Path_Defs;
ProtocolDefs;

PSTH.monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch PSTH.monkey_inx
    case '21'
        PSTH.monkey = 'Jannabi';
    case '4'
        PSTH.monkey = 'WhiteFang';
end

%% plot correlation map superimposed on anatomy images
temp = strfind(PATH,'raw');
cd([PATH(1:temp-1),'Ultrasound']);

fileN = FILE;
% only plot correlation map superimposed on the mean image
% parater note: 1. mean image (background) 2. correlation map 3. positive threshold 4.negative threshold
%               5.cluster size 6. colorbar range  7.number of figures on the row  8. number of figures on the columns
[handle_1 ,handle_2]=My_image_series_plot_Fus(['.\mean_',fileN,'.nii'],['.\corr_',fileN,'.nii'],0.1,-0.1,...
                                              5,[-0.1 0.1],1,1); 
% calculate correlation and plot figures
% fUScorr;close all;
%% get data
% stimulus type,azi,ele,amp and duration
%{
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
temp_visOnT = data.moog_params(TRIAL_START_TIME,real_trials,MOOG);
temp_visOnT = temp_visOnT - temp_visOnT(1); % get the time relative to the 1st one

temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms

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

max_reps = ceil(sum(real_trials)/((length(unique_spatFre)*length(unique_tempFre)+length(unique_stimType)-1)*length(unique_orient))); % fake max repetations
%}


%% plot figures


end