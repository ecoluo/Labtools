% plot eyetrace for funxtional Ultrasound imaging
% Modified from LBY 20161221
% LBY 20221031

%-----------------------------------------------------------------------------------------------------------------------
function Eyetrace_fUS(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag)

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
block_start_time = data.moog_params(BLOCK_START_TIME,real_trials,MOOG); % in ms
temp_start_time = data.moog_params(TRIAL_START_TIME,real_trials,MOOG); % in ms
temp_start_time = (temp_start_time-block_start_time(1))/1000; % in s

temp_stimType = data.moog_params(STIM_TYPE,real_trials,MOOG);
timeIdx = 0.96;

unique_duration = munique(temp_duration')/1000; % in sunique_azimuth = munique(temp_azimuth');
unique_azimuth = munique(temp_azimuth');
unique_elevation = munique(temp_elevation');
unique_stimType = munique(temp_stimType');
%% pack data for PSTH, modeling and analysis

% time information
eye_timeWin = 1000/(data.htb_header{EYE_DB}.speed_units/data.htb_header{EYE_DB}.speed/(data.htb_header{EYE_DB}.skip+1)); % in ms
event_timeWin = 1000/(data.htb_header{EVENT_DB}.speed_units/data.htb_header{EVENT_DB}.speed/(data.htb_header{EVENT_DB}.skip+1)); % in ms

%% pack data

% eye data
real_eye_data_LH = squeeze(data.eye_data(4,:,real_trials));
real_eye_data_LV = squeeze(data.eye_data(1,:,real_trials));
% real_eye_data_RH = squeeze(data.eye_data(1,:,real_trials));
% real_eye_data_RV = squeeze(data.eye_data(2,:,real_trials));

% initialize
real_eye_data = [];

for k = 1:length(unique_stimType)
    for i = 1:length(unique_azimuth)
        % find specified conditions with repetitions -> pack the data
        select = find( (temp_azimuth == unique_azimuth(i)) & (temp_stimType == unique_stimType(k))) ;
        if sum(select)>0
            real_eye_data{k,j,i}(:,:,1) = real_eye_data_LH(:,select);
            real_eye_data{k,j,i}(:,:,2) = real_eye_data_LV(:,select);
        else
            try
                real_eye_data{k,j,i}(:,:,:) = real_eye_data{k,j,1}(:,:,:);
            catch
                keyboard;
            end
        end
        %         % normalize by the time from fix in to stim on
        %         real_eye_data{k,j,i}(:,:,:) = real_eye_data{k,j,i}(:,:,:)-repmat(nanmean(real_eye_data{k,j,i}(stimOnBin(1)-10:stimOnBin(1),:,:)),[1000,1,1]);
        
    end
end

% % spon eye data
% spon_eye_data_LH = squeeze(data.eye_data(4,:,spon_trials));
% spon_eye_data_LV = squeeze(data.eye_data(1,:,spon_trials));
% spon_eye_data_RH = squeeze(data.eye_data(1,:,spon_trials));
% spon_eye_data_RV = squeeze(data.eye_data(2,:,spon_trials));


%% plot figures

% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% Eyetrace for up & down
% %{

subplot(1,2,2);

plot(stimOnBin(1,1):stimOffBin(1,1),mean(real_eye_data{k,1,5}(stimOnBin(1,1):stimOffBin(1,1),:,2),2),'b');hold on;
hold on;
% down
plot(stimOnBin(1,1):stimOffBin(1,1),mean(real_eye_data{k,5,5}(stimOnBin(1,1):stimOffBin(1,1),:,2),2),'r');hold on;
set(gca,'xlim',[stimOnBin(1,1) stimOffBin(1)+10]);

%         set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
set(gca,'xtick',[stimOnBin(1,1) stimOffBin(1)+10],'xticklabel',{'stim on','stim off'});
axis on;
%     ylabel(hv_lable{hv});
ylabel('Vertical');
legend({'Up','Down'});

% end

SetFigure(15);
% save the figure
FileNameTemp = num2str(FILE);
FileNameTemp =  FileNameTemp(1:end);
str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
str2 = [str,'_eyetrace_',stimType{k}];
set(gcf,'paperpositionmode','auto');

saveas(111,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning\Translation\' ss], 'emf');

%}
end
