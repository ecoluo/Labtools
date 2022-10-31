% analyze functional Ultrasound imaging without staring at the fixation point
% @LBY, Gu lab, 202112



function fUS_LBY_passive(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, ~, StopOffset, PATH, FILE, batch_flag)

% tic;

global PSTH1Dmodel PSTH;
PSTH = []; PSTH1Dmodel = [];

% contains protocol etc. specific keywords
TEMPO_Defs;
Path_Defs;
ProtocolDefs;

stimType{1}='Vestibular';
stimType{2}='Visual';
stimType{3}='Combined';
stimType{5}='Sound';
stimType{4}='null';

PSTH.monkey_inx = FILE(strfind(FILE,'m')+1:strfind(FILE,'c')-1);

switch PSTH.monkey_inx
    case '23'
        PSTH.monkey = 'Shuangshuang';
    case '21'
        PSTH.monkey = 'Jannabi';
    case '4'
        PSTH.monkey = 'WhiteFang';
end
%% get data
% stimulus type,azi,ele,amp and duration

% temporarily, for htb missing cells
if data.one_time_params(NULL_VALUE) == 0
    data.one_time_params(NULL_VALUE) = -9999;
end

trials = 1:size(data.moog_params,2); % the No. of all trials
% find the trials for analysis
temp_trials = trials( (data.moog_params(AZIMUTH,trials,MOOG) ~= data.one_time_params(NULL_VALUE)) ); % numOfDir*rept trials
temp_stimType = data.moog_params(STIM_TYPE,temp_trials,MOOG);
unique_stimType = munique(temp_stimType');
trials = 1:size(data.moog_params,2); % a vector of trial indices

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
%         keyboard;
spon_trials = select_trials & (data.moog_params(AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE));
real_trials = select_trials & (~(data.moog_params(AZIMUTH,trials,MOOG) == data.one_time_params(NULL_VALUE)));

temp_azimuth = data.moog_params(AZIMUTH,real_trials,MOOG);
temp_elevation = data.moog_params(ELEVATION,real_trials,MOOG);
temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms
temp_start_time = data.moog_params(TRIAL_START_TIME,real_trials,MOOG); % in ms
temp_start_time = (temp_start_time-temp_start_time(1))/1000; % in s

unique_duration = munique(temp_duration')/1000; % in sunique_azimuth = munique(temp_azimuth');
unique_azimuth = munique(temp_azimuth');
unique_elevation = munique(temp_elevation');
unique_stimType = munique(temp_stimType');

%% pack data

for k = 1:length(unique_stimType)
    for i = 1:length(unique_azimuth)
        % find specified conditions with repetitions -> pack the data
        select = find( (temp_azimuth == unique_azimuth(i)) & (temp_stimType == unique_stimType(k))) ;
        if sum(select)>0
            start_time{k,i} = temp_start_time(select);
            
        end
    end
end


%% deal with the image

temp = strfind(PATH,'raw');
datapath = [PATH(1:temp-1),'Ultrasound'];
cd(datapath);
fileN = FILE;

% read the image
head = spm_vol([fileN,'.nii']); %change the name of the image
img = spm_read_vols(head); % img: [x,y,z,t]
img4d = permute(img,[1 3 2 4]); % permute the dimension of y and z; img4d: [x,z,y,t]

% change some parameters here
totalT = 340; % the duration of whole exp time, unit in s, shown in the fUS machine
outT = 349; % true stim time outside fUS
timeIdx = 334/349;

reps = length(start_time{1,1}); % repitition
duration=unique_duration*timeIdx; % the duration of each stim, unit in s
% onset=0:(totalT/reps):totalT-1; %stim onset time

scannum = 1;
nFr = length(head); % number of image frames
TR=0.4;

%% Filter and averages N scans of the same session.
% the file names in this example are scan1, scan2 .. scan6
% put read images into for loop if scan for many times

averagedata=0;
rejThre = 0.1;
for i=1:scannum
    [h,ratioRejected,outliers]=MydataStability(img4d);
    saveas(h,['Z:\LBY\Recording data\fUS\rejection_', num2str(round(ratioRejected*100)),'_',fileN,'_',num2str(scannum)], 'jpg');
    % option 1: ask if the data worth to be analysed
    %{
    acc=input('accepted? [y/n] ','s');
    if acc=='y'
        scanfusRejdata=MyimageRejection(img4d,outliers);
        averagedata=averagedata+scanfusRejdata;
    end
    %}
    
    % option 2: use 10% as the threshold for criteria that the data is stable
    %     %{
    if ratioRejected <= rejThre
        disp(['The rejection rate is ',num2str(ratioRejected),', ']);
        disp('indicating the image data is stable, thus the analysis will continue...');
        scanfusRejdata=MyimageRejection(img4d,outliers);
        averagedata=averagedata+scanfusRejdata;
    else
        disp(['The rejection rate of', fileN,' is ',num2str(ratioRejected),', ']);
        disp(['which is great than the threshold of ',rejThre,'indicating the image data is UNSTABLE, thus the analysis will stop here.']);
        return;
    end
    %}
end

% % Change the data in the structure scanfus and save it.
% scanfus.Data= average;
%save( 'scanAverage', 'averagedata','-v6');
%% plot correlation map superimposed on anatomy images

% analysis

stimFr = round(duration/TR);
stimu=zeros(length(unique_stimType),length(unique_azimuth),nFr);        
for k = 1:length(unique_stimType)
    for i = 1:length(unique_azimuth)
         % initialize stim with 0
        onset = start_time{k,i}*timeIdx;
        onsetframe=fix(onset*nFr/totalT)+1; % +1 for first image is 1 but not 0
        % % upsample stim to sampling rate of images
        % onsetiter=1;
        % for iter=1:length(stimu)
        %     if(onsetiter<=length(onsetframe)&&iter==onsetframe(onsetiter))
        %         stimu(iter:iter+stimFr-1) = ones(1,stimFr);
        %         onsetiter=onsetiter+1;
        %     end
        % end
        
        % upsample stim to sampling rate of images
        
        for iter=1:length(onsetframe)
            stimu(k,i,onsetframe(iter):onsetframe(iter)+stimFr-1) = ones(1,stimFr);
        end
        
        % plot the stim pattern
%         figure('pos',[50,100,1800,250],'color','w');plot(squeeze(stimu(k,i,:)),'k-','linewidth',1.5);xlabel('image frame');title('stimulus pattern');
%         yticks([0 1]);SetFigure(15);
        
        % calculate correlation and plot figures
        fUScorr2(squeeze(stimu(k,i,:)),fileN,head,averagedata,start_time{k,i},stimType{unique_stimType(k)},unique_azimuth(i),TR,onsetframe);close all;
        
        % spm-GLM
        fUSglm1(squeeze(stimu(k,i,:)),fileN,head,averagedata,start_time{k,i},stimType{unique_stimType(k)},unique_azimuth(i),TR,datapath);close all;
        
        % only plot correlation map superimposed on the mean image
        %{
% parater note: 1. mean image (background) 2. correlation map 3. positive threshold 4.negative threshold
%               5.cluster size 6. colorbar range  7.number of figures on the row  8. number of figures on the columns
[handle_1 ,handle_2]=My_image_series_plot_Fus(['.\mean_',fileN,'.nii'],['.\corr_',fileN,'.nii'],0.1,-0.1,...
                                              5,[-0.1 0.1],1,1);
        %}
        
        
    end
end

% perform GLM 
% fUSglm(stimu,fileN,head,averagedata,start_time,unique_stimType,unique_azimuth,TR,datapath);close all;

disp('All done!');

%% plot figures


end