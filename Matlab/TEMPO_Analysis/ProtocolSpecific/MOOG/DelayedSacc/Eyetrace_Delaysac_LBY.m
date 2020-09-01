% protocol: Delayed saccade
% plot eyetrace for Delayed saccade
% LBY 20161221

%-----------------------------------------------------------------------------------------------------------------------
function Eyetrace_Delaysac_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag)

TEMPO_Defs;
Path_Defs;
ProtocolDefs;

%% get data
trials = 1:size(data.moog_params,2);
select_trials = find( (trials >= BegTrial) & (trials <= EndTrial) );
real_trials = select_trials(data.moog_params(HEADING,select_trials,MOOG) ~= data.one_time_params(NULL_VALUE));
%
temp_heading = data.moog_params(HEADING,select_trials,MOOG);
unique_heading = munique(temp_heading');

% time information
eye_timeWin = 1000/(data.htb_header{EYE_DB}.speed_units/data.htb_header{EYE_DB}.speed/(data.htb_header{EYE_DB}.skip+1)); % in ms
event_timeWin = 1000/(data.htb_header{EVENT_DB}.speed_units/data.htb_header{EVENT_DB}.speed/(data.htb_header{EVENT_DB}.skip+1)); % in ms

event_in_bin = squeeze(data.event_data(:,:,trials));
stimOnT = find(event_in_bin == VSTIM_ON_CD);
stimOffT = find(event_in_bin == VSTIM_OFF_CD);
FPOnT = find(event_in_bin == FP_ON_CD);
fixInT = find(event_in_bin == IN_FIX_WIN_CD);
sacOnT = find(event_in_bin == SACCADE_BEGIN_CD);
sacOffT=find(event_in_bin == IN_T1_WIN_CD);
FPOnBin=ceil(FPOnT*event_timeWin/eye_timeWin);
stimOffBin=ceil(stimOffT*event_timeWin/eye_timeWin);
fixInBin = ceil(fixInT*event_timeWin/eye_timeWin);
stimOnBin = ceil(stimOnT*event_timeWin/eye_timeWin);
sacOnBin = ceil(sacOnT*event_timeWin/eye_timeWin);
sacOffBin = ceil(sacOffT*event_timeWin/eye_timeWin);

% eye data
real_eye_data_LH = squeeze(data.eye_data(1,:,real_trials));
real_eye_data_LV = squeeze(data.eye_data(2,:,real_trials));
real_eye_data_RH = squeeze(data.eye_data(3,:,real_trials));
real_eye_data_RV = squeeze(data.eye_data(4,:,real_trials));

% for drawing pictures
eye_data_LH = real_eye_data_LH;
eye_data_LV = real_eye_data_LV;
eye_data_RH = real_eye_data_RH;
eye_data_RV = real_eye_data_RV;

%% plot figures

% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;
% the lines markers
markers = {
    % markerName % markerTime % marker bin time % color
    'FPOn',FPOnT(1),FPOnBin(1),colorLGray;
    'fixOnT',fixInT(1),fixInBin(1),colorDGray;

    };

% aligh heading with directions
positions = [6,3,2,1,4,7,8,9];


figure(111);
clf;
set(gcf,'Position', [0 0 1900 1060], 'Name', 'Eye Trace for delaySac_H&V');

% plot eyetraces of horizontal against time of 8 directions
for h = 1:length(unique_heading)
    select = find(temp_heading == unique_heading(h));
    axes('unit','pixels','pos',[mod(positions(h)-1,3)*620+50 (3-ceil(positions(h)/3))*310+10+150 580 140]);
    for r = 1: length(select)
        color = ['color',num2str(r)];
                plot(gca,FPOnBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),eye_data_LH(FPOnBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),'-.','color',eval(color));
        hold on;
        for n = 1:size(markers,1)
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1.5);
            hold on;
            box off;
        end
        set(gca,'xlim',[1 700],'ylim',[-1.5 1.5]); % for 2 degree window
        set(gca,'xtick',[],'ytick',[-1 0 1]);% for 2 degree window
        box off;
%         title(gca,'Eye trace');
    end
end

% plot eyetraces of vertical against time of 8 directions
for h = 1:length(unique_heading)
    select = find(temp_heading == unique_heading(h));
    axes('unit','pixels','pos',[mod(positions(h)-1,3)*620+50 (3-ceil(positions(h)/3))*310+10 580 140]);
    for r = 1: length(select)
        color = ['color',num2str(r)];
                plot(gca,FPOnBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),eye_data_LV(FPOnBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),'-.','color',eval(color));
        hold on;
        for n = 1:size(markers,1)
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1.5);
            hold on;
            box off;
        end
        set(gca,'xlim',[1 700],'ylim',[-1.5 1.5]); % for 2 degree window
        set(gca,'xtick',[],'ytick',[-1 0 1]);% for 2 degree window
        box off;
%         title(gca,'Eye trace');
    end
end

% text to indicate the markers
axes('unit','pixels','pos',[660 560 600 40]);
set(gca,'xlim',[1 700],'ylim',[0 10]); % to align with h2 & h3
text(FPOnBin(1)-20,2,'FP on','fontsize',16);
text(fixInBin(1)-30,10,'fix in','fontsize',16);
text(500,10,'sac off','fontsize',16);
axis off;

% text on the figure
axes('unit','pixels','pos',[700 400 600 80]);
xlim([0,100]);
ylim([0,10]);
FileName_Temp = num2str(FILE);
FileName_Temp =  FileName_Temp(1:end);
str1 = [FileName_Temp,'\_Ch' num2str(SpikeChan)];
text(0,2,str1,'fontsize',20);
text(0,10,'Delay Saccade - Eye Trace','fontsize',20);
axis off;

% plot eyetraces in all trials
figure(112);
clf;
set(gcf,'Position', [0 0 1000 1000], 'Name', 'Eye Trace');
axes('unit','pixels','pos',[100 100 800 800]);
for h = 1:length(unique_heading)
    select = find(temp_heading == unique_heading(h));
    for r = 1: length(select)
        color = ['color',num2str(r)];
        try
%         plot(gca,eye_data_LH(fixInBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),eye_data_LV(fixInBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),'linestyle','-','marker','.','color',eval(color));
        plot(gca,eye_data_LH(fixInBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),eye_data_LV(fixInBin(1,1):sacOffBin(select(r),1)-1000*(select(r)-1),select(r)),'linestyle','-','marker','.');
        catch
            keyboard;
        end
        hold on;
    end
end
set(gca,'xlim',[-10 10],'ylim',[-10 10]); % for 2 degree window
set(gca,'xtick',[-10 0 10],'ytick',[-10 0 10]);% for 2 degree window
box off;
str2 = [str1 '  Eye trace for delay saccade'];
title(gca,str2);



% save the figure
str3 = [FileName_Temp,'_Ch' num2str(SpikeChan), '_delaySac_eyetrace'];
str4 = [FileName_Temp,'_Ch' num2str(SpikeChan), '_delaySac_eyetrace_raw'];
saveas(111,['Z:\LBY\Recording data\Qiaoqiao\Delay_saccade\' str3], 'emf');
saveas(112,['Z:\LBY\Recording data\Qiaoqiao\Delay_saccade\' str4], 'emf')


% % %% Data Saving
% %
% % % Reorganized. HH20141124
% % config.batch_flag = batch_flag;
% %
% % % Output information for test. HH20160415
% % if isempty(batch_flag)
% %     config.batch_flag = 'test.m';
% %     disp('Saving results to \batch\test\ ');
% % end
% %
% % %%%%%%%%%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % if exist('CP','var')  % Full version
% %     result = PackResult(FILE, SpikeChan, repetitionN, unique_stim_type, ... % Obligatory!!
% %                     stim_type_per_trial, heading_per_trial, choice_per_trial,... % Trial info
% %                     align_markers, align_offsets_others, sort_info, smoothFactor ,...
% %                     PREF, PREF_CP_obsolete, PREF_target_location, outcome_mask_enable, ...
% %                     binSize_rate, stepSize_rate, rate_ts, binSize_CP, stepSize_CP, CP_ts ,...
% %                     spike_aligned, spike_hist, CP, PSTH,...
% %                     ChoiceDivergence_ALL, ChoiceDivergence_Difficult, ChoiceDivergence_Easy,ChoicePreference,ChoicePreference_pvalue,...
% %                     ModalityDivergence, ModalityPreference, ModalityPreference_pvalue);
% %     % Figures to save
% %     config.save_figures = [60 + (1:length(sort_info)) ,161, 1899, 1999, 2000, 59];
% %
% % else
% %     result = PackResult(FILE, SpikeChan, repetitionN, unique_stim_type, ... % Obligatory!!
% %                         stim_type_per_trial, heading_per_trial, choice_per_trial,... % Trial info
% %                         align_markers, align_offsets_others, sort_info, smoothFactor ,...
% %                         PREF, PREF_target_location, outcome_mask_enable, ...
% %                         binSize_rate, stepSize_rate, rate_ts,...
% %                         spike_aligned, spike_hist, PSTH,...
% %                         ChoiceDivergence_ALL, ChoiceDivergence_Difficult, ChoiceDivergence_Easy,ChoicePreference,ChoicePreference_pvalue,...
% %                         ModalityDivergence, ModalityPreference, ModalityPreference_pvalue);
% %
% % %     result = PackResult(FILE, SpikeChan, repetitionN, unique_stim_type, ... % Obligatory!!
% % %                         PREF_target_location);
% %
% %     % Figures to save
% %     config.save_figures = [];
% %
% % end
% %
% % config.suffix = 'PSTH';
% % config.xls_column_begin = 'HD_rep';
% % % config.xls_column_end = 'HD_comb_p';
% % config.xls_column_end = 'HD_comb_ChoicePref_p';
% %
% % % Only once
% % config.sprint_once_marker = 'gs';
% % config.sprint_once_contents = 'result.repetitionN,num2str(result.PSTH{2,1,1}.ts)';
% % % Loop across each stim_type
% % % config.sprint_loop_marker = {'gg';
% % %                            'gg';
% % %                            'sss'};
% % % config.sprint_loop_contents = {'result.CP{2,k}.Psy_para(2), result.CP{2,k}.Psy_para(1)';
% % %                         'result.CP{2,k}.CP_grand_center, result.CP{2,k}.CP_grand_sac';
% % %                         'num2str(result.PSTH{2,1,1}.ys((k-1)*2+1,:)), num2str(result.PSTH{2,1,1}.ys((k-1)*2+2,:)), num2str(result.PSTH{2,1,1}.ps(k,:))'};
% %
% % % Replace the meaningless CPs with ChoicePreference (surprisingly, they have the same abbreviation!). HH20160419
% % config.sprint_loop_marker = {'gg';
% %                            'gg';
% %                            'gg'};
% % config.sprint_loop_contents = {'result.CP{2,k}.Psy_para(2), result.CP{2,k}.Psy_para(1)';
% %                         'result.CP{2,k}.CP_grand_center, result.CP{2,k}.CP_grand_sac';
% %                         'result.ChoicePreference(1,k), result.ChoicePreference_pvalue(1,k)'};
% %
% % config.append = 1; % Overwrite or append
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % SaveResult(config, result);
% %
return;