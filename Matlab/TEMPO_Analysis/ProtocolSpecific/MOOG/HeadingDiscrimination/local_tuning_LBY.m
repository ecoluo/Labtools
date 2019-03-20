% modified by LBY
% 20181214

function local_tuning_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, ~, StopOffset, PATH, FILE, batch_flag)

TEMPO_Defs;
Path_Defs;
ProtocolDefs; %contains protocol specific keywords - 1/4/01 BJP

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

switch Protocol
    case HEADING_DISCRIM_FIXONLY % for heading discrimination task
        %get the column of values for azimuth and elevation and stim_type
        temp_stim_type = data.moog_params(STIM_TYPE,:,MOOG);
        temp_heading   = data.moog_params(HEADING, :, MOOG);
        temp_amplitude = data.moog_params(AMPLITUDE,:,MOOG);
        temp_motion_coherence = data.moog_params(COHERENCE,:,MOOG);
        
    case ROTATION_DISCRIM_FIXONLY % for rotation discrimination task
        %get the column of values for azimuth and elevation and stim_type
        temp_stim_type = data.moog_params(STIM_TYPE,:,MOOG);
        temp_elevation = data.moog_params(ROT_ELEVATION,:,MOOG);
        temp_amplitude = data.moog_params(ROT_AMPLITUDE,:,CAMERAS);
        temp_motion_coherence = data.moog_params(COHERENCE,:,MOOG);
        temp_heading = temp_amplitude.*sign(temp_elevation);
end

temp_duration = data.moog_params(DURATION,:,MOOG); % in ms
trials = 1:length(temp_heading);		% a vector of trial indices

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


stim_type = temp_stim_type( select_trials );
heading = temp_heading( select_trials );
unique_stim_type = munique(stim_type');
unique_heading = munique(heading');
motion_coherence = temp_motion_coherence(select_trials);
unique_motion_coherence = munique(motion_coherence');
duration = munique(temp_duration');

temp_spike_rates = data.spike_rates(SpikeChan, :);

temp_total_trials = data.misc_params(OUTCOME, :);
spike_rates = temp_spike_rates( select_trials);
spike_data = squeeze(data.spike_data(SpikeChan,:,select_trials));

one_repetition = length(unique_heading)*length(unique_stim_type);

% time marks for each trial
event_in_bin = squeeze(data.event_data(:,:,trials));
stimOnT = find(event_in_bin == VSTIM_ON_CD);
stimOffT = find(event_in_bin == VSTIM_OFF_CD);
stimOnT = stimOnT(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time windows
binSize = 200;  % in ms
timeStep = 50; % in ms
gau_sig = 100; % parameters for smoothing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(PSTH.monkey ,'MSTd') == 1
    delay = 115; % in ms, MSTd, 1806
    %for MSTd delay is 100 ms
    aMax = 770; % in ms, peak acceleration time, measured time
    aMin = 1250; % in ms, trough acceleration time, measured time
else % for PCC
    %     delay = 200; % in ms, system time delay, LBY added, 180523
    %     aMax = 530; % in ms, peak acceleration time relative to stim on, measured time
    %     aMin = 900; % in ms, trough acceleration time relative to stim on, measured time
    delay = 170; % in ms, system time delay, LBY modified, 181012
    aMax = 550; % in ms, peak acceleration time relative to real stim on time, measured time
    aMin = 930; % in ms, trough acceleration time relative to real stim on time, measured time
end

stimOnT = stimOnT + delay;
stimOffT = stimOffT + delay;
tOffset1 = 0;
tOffset2 = 0;
PSTH_onT = stimOnT(1) - floor(tOffset1/timeStep)*timeStep; % the exact PSTH-ontime point
stimOnBin = floor(tOffset1/timeStep)+1;
stimOffBin = floor(tOffset1/timeStep)+floor(temp_duration(1)/timeStep);

% creat basic matrix represents each response vector
resp = [];
for c=1:length(unique_motion_coherence)  % motion coherence
    
    resp{c} = nan(length(unique_heading),length(unique_stim_type));
    resp_std{c} = resp{c};
    resp_err{c} = resp{c};
    
    for k=1:length(unique_stim_type)
        
        resp_trial{c,k} = nan(100,length(unique_heading)); % A large enough matrix (if you're not TOO CRAZY). HH20150704
        
        for i=1:length(unique_heading)
            
            select = logical( heading==unique_heading(i) & stim_type==unique_stim_type(k) & motion_coherence==unique_motion_coherence(c) );
            
            % Cope with situations where different angles have different numbers of repetition (unbalanced ANOVA).  HH20150704
            rep_this = sum(select);
            repetitions(c,k,i) = rep_this; % Save it
            
            if (rep_this > 0)  % there are situations where visual/combined has >2 coherence and vestibular only has one coherence
                resp{c}(i, k) = mean(spike_rates(select));
                resp_std{c}(i,k) = std(spike_rates(select));
                resp_err{c}(i,k) = std(spike_rates(select)) / sqrt(rep_this);
                
                spike_temp = spike_rates(select);
                try
                    resp_trial{c,k}(1:rep_this,i) = spike_temp;
                catch
                    keyboard
                end
            else     % actually duplicate vestibular condition
                resp{c}(i, k) = resp{1}(i, k);
                resp_std{c}(i,k) = resp_std{1}(i,k);
                resp_err{c}(i,k) = resp_err{1}(i,k);
                
                resp_trial{c,k}(1:rep_this,i) = resp_trial{1,k}(1:rep_this,i);
            end
            resp_trial{c,k}(all(isnan(resp_trial{c,k}),2),:) = []; % Trim the large matrix by removing unnecessary NaNs. HH20150704
            
            % pack tuning data according to small time window
            nBins = duration/timeStep;
            
            resp_t{c,k}(i, :) = mean(PSTH_smooth( nBins, stimOnT, binSize, timeStep, spike_data(:,select), 2, gau_sig),2);
            resp_std_t{c,k}(i, :) = std(PSTH_smooth( nBins, stimOnT, binSize, timeStep, spike_data(:,select), 2, gau_sig),0,2);
            resp_err_t{c,k}(i, :) = resp_std_t{c,k}(i, :)/sqrt(rep_this);
            resp_fano_t{c,k}(i, :) = resp_std_t{c,k}(i, :)./resp_t{c,k}(i, :);
        end
        maxResp{c,k} = max(resp_t{c,k}(:));
        maxRespErr{c,k} = max(resp_err_t{c,k}(:));
        
    end
    
    
end

unique_rep = unique(repetitions);
unique_rep = unique_rep(unique_rep>0);


% % ------------------------------------------------------------------
% Define figure

% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;

% the lines markers
markers = {
    % markerName % markerTime % marker bin time % color % linestyle
    %     'FPOnT',FPOnT(1),(FPOnT(1)-PSTH_onT+timeStep)/timeStep,colorDGray;
    %     'stim_on',stimOnT,stimOnBin,colorDRed,'.';
    %     'stim_off',stimOffT,stimOffBin,colorDRed,'.';
    'aMax',stimOnT+aMax,(stimOnT+aMax-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'aMin',stimOnT+aMin,(stimOnT+aMin-PSTH_onT+timeStep)/timeStep,colorDBlue,'--';
    'v',stimOnT+aMax+(aMin-aMax)/2,(stimOnT(1)+aMax+(aMin-aMax)/2-PSTH_onT+timeStep)/timeStep,'r','--';
    };

%%%%%%%%%%% local tuning the whole duration of stimulus on %%%%%%%%%%%%%
%{
figure(3); clf;
set(gcf,'color','white');
set(3,'Position', [-1050,500 900,400], 'Name', 'Local direction tuning');
[~,h_subplot] = tight_subplot(1,length(unique_stim_type),0.1,0.25,[0.1 0.1]);
if ~isempty(batch_flag); set(3,'visible','off'); end
orient landscape;

% temporarily hard coded, will be probematic if there are more than 3*3 conditions
% repetitions -GY
f{1,1}='bo-'; f{1,2}='ro-'; f{1,3}='go-';
f{2,1}='bo-'; f{2,2}='ro-'; f{2,3}='go-';
f{3,1}='bo-'; f{3,2}='ro-'; f{3,3}='go-';

for k=1: length(unique_stim_type)
    
    axes(h_subplot(k));hold on;
    
    for c=1:length(unique_motion_coherence)
        set(errorbar(unique_heading, resp{c}(:,k), resp_err{c}(:,k), f{c,unique_stim_type(k)} ),'linewidth',2);
    end
    
    xlim( [min(unique_heading), max(unique_heading)] ); axis on;
    title(sprintf('%s',stimType{k}));
    
end
switch Protocol
    case HEADING_DISCRIM_FIXONLY % for heading discrimination task
        suptitle(['Local tuning (Heading, Fix only)    ',FILE, '     ch\_',num2str(SpikeChan)]);
    case ROTATION_DISCRIM_FIXONLY % for rotation discrimination task
        suptitle(['Local tuning (Rotation, Fix only)    ',FILE, '     ch\_',num2str(SpikeChan)]);
end
SetFigure(10);

%show file name and some values in text

axes('position',[0.1,0, 0.4,0.12] );
xlim( [0,100] );
ylim( [0,length(unique_stim_type)*length(unique_motion_coherence)+2] );
text(0, length(unique_stim_type)*length(unique_motion_coherence)+2, FILE);
text(40, length(unique_stim_type)*length(unique_motion_coherence)+2, 'SpikeChan=');
text(60, length(unique_stim_type)*length(unique_motion_coherence)+2, num2str(SpikeChan));
text(80, length(unique_stim_type)*length(unique_motion_coherence)+2, sprintf('rep = %s',num2str(unique_rep')));
text(0,length(unique_stim_type)*length(unique_motion_coherence)+1.5,['stim     coherence' repmat(' ',1,15) 'prefer', repmat(' ',1,10), 'DDI',repmat(' ',1,10), 'HTI',repmat(' ',1,10),'d''@90',repmat(' ',1,10),'d''@270',repmat(' ',1,10),'p', repmat(' ',1,10),'half-width']);

count=-0.5;
for k=1:length(unique_stim_type)
    for c=1:length(unique_motion_coherence)
        count=count+.7;
        text(0,length(unique_stim_type)*length(unique_motion_coherence)-(count-1),num2str(unique_stim_type(k)));
        text(20,length(unique_stim_type)*length(unique_motion_coherence)-(count-1), num2str(unique_motion_coherence(c)) );
        
        % Transferred from azimuth to heading. HH20140415
        
    end
end
axis off;

str = [FILE,' Ch ',num2str(SpikeChan)];
ss = [str,'_local tuning'];
set(gcf,'paperpositionmode','auto');
saveas(gcf,['/ion/gu_lab/byliu/Z/Polo/HD/' ss], 'emf');
%}

%%%%%%%%%%% local tuning with sliding time window %%%%%%%%%%%%%
%{
aa = 4;
stim_type_colors = [0 0 1; 1 0 0; 0 0.8 0.4];
for k = 1:length(unique_stim_type)   % For each stim type
    real_k = unique_stim_type(k);
    set(figure(1000+k),'position',[0 0 1900 1000]); clf;
    maxY = max(resp_t{1,k}(:));
    selected_condition = stim_type == unique_stim_type(k);
    headings = heading(selected_condition);
    choices = ones(sum(selected_condition),1);
    spike_tt = PSTH_smooth( nBins, stimOnT, binSize, timeStep, spike_data(:,selected_condition), 2, gau_sig);
    for tt = 1:nBins % sliding window
        % calculate the neuronal threshold
        spike_counts = spike_tt(tt,:);
        CP_result = CP_LBY(headings,choices,spike_counts,1000,0);
        CP{k}.Neu_thres(tt) = CP_result.Neu_para_anti(2);
        subplot(aa,round(nBins/aa),tt); hold on;
        errorbar(unique_heading,resp_t{1,k}(:, tt),resp_err_t{1,k}(:, tt),'color',stim_type_colors(real_k,:),'LineWid',2);
        axis tight;
        ylim([0 maxY]);
        set(gca,'xtick',unique_heading,'xticklabel',[]);
        
        %             text neurothreshold
        title(CP{k}.Neu_thres(tt));
        
    end
    SetFigure(10);
    switch Protocol
        case HEADING_DISCRIM_FIXONLY % for heading discrimination task
            suptitle(['Local tuning (Heading, Fix only)    ',FILE, '     ch\_',num2str(SpikeChan)]);
        case ROTATION_DISCRIM_FIXONLY % for rotation discrimination task
            suptitle(['Local tuning (Rotation, Fix only)    ',FILE, '     ch\_',num2str(SpikeChan)]);
    end
    SetFigure(10);
    str = [FILE,' Ch ',num2str(SpikeChan),'_',stimType{k}];
    ss = [str,'_local tuning_T'];
set(gcf,'paperpositionmode','auto');
    saveas(gcf,['/ion/gu_lab/byliu/Z/Polo/HD/' ss], 'tif');
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%% temporal tuning  %%%%%%%%%%%%%%%%%%%%%%%%%

%{
for k = 1:length(unique_stim_type)
    figure(30+k);set(figure(30+k),'name','Temporal tuning(Passive, HD)','unit','normalized','pos',[-0.55 0.3 0.53 0.4]); clf;
    [~,h_subplot] = tight_subplot(2,floor(length(unique_heading)/2)+1,[0.15 0.03],0.25);
    
    % leftward
    for i = 1: floor(length(unique_heading)/2)
        axes(h_subplot(i));
        errorbar(resp_t{1,k}(length(unique_heading)+1-i, :),resp_err_t{1,k}(length(unique_heading)+1-i, :),'color','k');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0 maxResp{1,k}+maxRespErr{1,k}], '--','color',markers{n,4},'linewidth',3);
            hold on;
        end
        set(gca,'ylim',[0 maxResp{1,k}+maxRespErr{1,k}],'xlim',[1 nBins]);
        %             axis off;
        set(gca,'xtick',[],'xticklabel',[]);
        %             set(gca,'yticklabel',[]);
        title(unique_heading(length(unique_heading)+1-i));
    end
    
    % rightward
    for i = 1: floor(length(unique_heading)/2)
        axes(h_subplot(floor(length(unique_heading)/2)+1+i));
        errorbar(resp_t{1,k}(i, :),resp_err_t{1,k}(i, :),'color','k');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0 maxResp{1,k}+maxRespErr{1,k}], '--','color',markers{n,4},'linewidth',3);
            hold on;
        end
        set(gca,'ylim',[0 maxResp{1,k}+maxRespErr{1,k}],'xlim',[1 nBins]);
        %             axis off;
        
        set(gca,'xtick',[],'xticklabel',[]);
        %             set(gca,'yticklabel',[]);
        title(unique_heading(i));
    end
    FileNameTemp = num2str(FILE);
    FileNameTemp =  FileNameTemp(1:end);
    str = ['PSTH(Passive tuning, HD)    ', FileNameTemp,'\_Ch' num2str(SpikeChan),'    ',stimType{k}];
    str1 = ['PSTH_Passive_tuning_HD_',FileNameTemp,'_Ch' num2str(SpikeChan),'_',stimType{k}];
    suptitle(str);
    SetFigure(10);
set(gcf,'paperpositionmode','auto');
    saveas(gcf,['/ion/gu_lab/byliu/Z/Polo/HD/' str1], 'tif');
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%% fano factor  %%%%%%%%%%%%%%%%%%%%%%%%%
% %{
for k = 1:length(unique_stim_type)
    figure(30+k);set(figure(30+k),'name','Fano factor(Passive, HD)','unit','normalized','pos',[-0.55 0.3 0.53 0.3]); clf;
    [~,h_subplot] = tight_subplot(1,floor(length(unique_heading)/2)+1,[0.15 0.03],0.25);
    
    for i = 1: floor(length(unique_heading)/2)
        axes(h_subplot(i));
        plot(resp_fano_t{1,k}(length(unique_heading)+1-i, :),'color','k');
        hold on;
        set(gca,'ylim',[0 1],'xlim',[1 nBins]);
        %             axis off;
        set(gca,'xtick',[],'xticklabel',[]);
        %             set(gca,'yticklabel',[]);
        title(unique_heading(length(unique_heading)+1-i));
    end
    
    FileNameTemp = num2str(FILE);
    FileNameTemp =  FileNameTemp(1:end);
    str = [FileNameTemp,'Fano factor (Passive, HD) \_Ch' num2str(SpikeChan),'    ',stimType{k}];
    str1 = [FileNameTemp,'Fano_Passive_HD_Ch' num2str(SpikeChan),'_',stimType{k}];
    suptitle(str);
    SetFigure(10);
    set(gcf,'paperpositionmode','auto');
    saveas(gcf,['/ion/gu_lab/byliu/Z/Polo/HD/' str1], 'tif');
end
%}
%% Data Saving
%{
% Reorganized. HH20141124
config.batch_flag = batch_flag;

%%%%%%%%%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
result = PackResult(FILE, SpikeChan, mean_repetitionN, unique_stim_type);

config.suffix = 'AzimuthTuning';
config.xls_column_begin = 'Pref_vest';
config.xls_column_end = 'err_comb';

% Figures to save
config.save_figures = gcf;

% Only once
config.sprint_once_marker = '';
config.sprint_once_contents = '';
% Loop across each stim_type
config.sprint_loop_marker = {'ggggggggss'};
config.sprint_loop_contents = {strcat('aziToHeading(result.az(1,k)), result.DDI(1,k), result.HTI_(1,k), result.p_1D(1,k),',...
                        'result.Dprime(1,k), result.Dprime_270(1,k), aziToHeading(result.prefGauss(1,k)),',...
                        'result.widGauss(1,k), num2str(result.resp{1}(:,k)''), num2str(result.resp_err{1}(:,k)'')')};
    
%}
return;
end

function dir = MSTazi2MTdir(x,y,azi)
for i = 1 : length(azi)
    if azi(i) >= 180 && azi(i) <= 360
        dir(i,1) = cart2pol(1/tand(azi(i)-180)-tand(x),-tand(y))/pi*180;
    elseif azi (i) < 180 && azi(i) >= 0
        dir(i,1) = cart2pol(1/tand(azi(i))-tand(x),-tand(y))/pi*180 + 180;
    end
end
end