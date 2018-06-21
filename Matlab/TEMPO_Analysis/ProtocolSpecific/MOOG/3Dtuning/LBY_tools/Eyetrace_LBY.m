% protocol: 3D tuning
% plot eyetrace for 3D tuning
% LBY 20161221

%-----------------------------------------------------------------------------------------------------------------------
function Eyetrace_LBY(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag)

TEMPO_Defs;
Path_Defs;
ProtocolDefs;

stimType{1}='Vestibular';
stimType{2}='Visual';
stimType{3}='Combined';
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
        BegTr = ceil((BegTrial-1)/((length(unique_stimType)*26+1)))*(length(unique_stimType)*26+1)+1;
        EndTr =  floor(EndTrial/((length(unique_stimType)*26+1)))*(length(unique_stimType)*26+1);
        select_trials = find( (trials >= BegTr) & (trials <= EndTr) );
        spon_trials = select_trials(data.moog_params(AZIMUTH,select_trials,MOOG) == data.one_time_params(NULL_VALUE));
        real_trials = select_trials(data.moog_params(AZIMUTH,select_trials,MOOG) ~= data.one_time_params(NULL_VALUE));
        
        temp_azimuth = data.moog_params(AZIMUTH,real_trials,MOOG);
        temp_elevation = data.moog_params(ELEVATION,real_trials,MOOG);
        temp_amplitude = data.moog_params(AMPLITUDE,real_trials,MOOG);
        
        
    case ROTATION_TUNING_3D % for rotation
        trials = 1:size(data.moog_params,2);
        % find the trials for analysis
        temp_trials = trials(find( (data.moog_params(ROT_AZIMUTH,trials,MOOG) ~= data.one_time_params(NULL_VALUE)) )); % 26*rept trials
        temp_stimType = data.moog_params(STIM_TYPE,temp_trials,MOOG);
        unique_stimType = munique(temp_stimType');
        BegTr = ceil((BegTrial-1)/((length(unique_stimType)*26+1)))*(length(unique_stimType)*26+1)+1;
        EndTr =  floor(EndTrial/((length(unique_stimType)*26+1)))*(length(unique_stimType)*26+1);
        select_trials = find( (trials >= BegTr) & (trials <= EndTr) );
        spon_trials = select_trials(data.moog_params(ROT_AZIMUTH,select_trials,MOOG) == data.one_time_params(NULL_VALUE));
        real_trials = select_trials(data.moog_params(ROT_AZIMUTH,select_trials,MOOG) ~= data.one_time_params(NULL_VALUE));
        
        temp_azimuth = data.moog_params(ROT_AZIMUTH,real_trials,MOOG);
        temp_elevation = data.moog_params(ROT_ELEVATION,real_trials,MOOG);
        temp_amplitude = data.moog_params(ROT_AMPLITUDE,real_trials,MOOG);
        
end

temp_duration = data.moog_params(DURATION,real_trials,MOOG); % in ms
temp_stimType = data.moog_params(STIM_TYPE,real_trials,MOOG);

unique_azimuth = munique(temp_azimuth');
unique_elevation = munique(temp_elevation');
unique_amplitude = munique(temp_amplitude');
unique_duration = munique(temp_duration');
unique_stimType = munique(temp_stimType');

% the least repitition numbers
repNums = (EndTr - BegTr +1)/(length(unique_stimType)*26+1);

% time information
eye_timeWin = 1000/(data.htb_header{EYE_DB}.speed_units/data.htb_header{EYE_DB}.speed/(data.htb_header{EYE_DB}.skip+1)); % in ms
event_timeWin = 1000/(data.htb_header{EVENT_DB}.speed_units/data.htb_header{EVENT_DB}.speed/(data.htb_header{EVENT_DB}.skip+1)); % in ms

event_in_bin = squeeze(data.event_data(:,:,trials));
stimOnT = find(event_in_bin == VSTIM_ON_CD);
stimOffT = find(event_in_bin == VSTIM_OFF_CD);
FPOnT = find(event_in_bin == FP_ON_CD);
fixInT = find(event_in_bin == IN_FIX_WIN_CD);
FPOnBin=ceil(FPOnT*event_timeWin/eye_timeWin);
stimOffBin=ceil(stimOffT*event_timeWin/eye_timeWin);
stimOnBin = ceil(stimOnT*event_timeWin/eye_timeWin);
fixInBin = ceil(fixInT*event_timeWin/eye_timeWin);

%% pack data

% eye data
real_eye_data_LH = squeeze(data.eye_data(1,:,real_trials));
real_eye_data_LV = squeeze(data.eye_data(2,:,real_trials));
real_eye_data_RH = squeeze(data.eye_data(3,:,real_trials));
real_eye_data_RV = squeeze(data.eye_data(4,:,real_trials));

% initialize
real_eye_data = [];

for k = 1:length(unique_stimType)
    
    for j = 1:length(unique_elevation)
        for i = 1:length(unique_azimuth)
            % find specified conditions with repetitions -> pack the data
            select = find( (temp_azimuth == unique_azimuth(i)) & (temp_elevation == unique_elevation(j)) & (temp_stimType == unique_stimType(k))) ;
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
        end
    end
end

% spon eye data
spon_eye_data_LH = squeeze(data.eye_data(1,:,spon_trials));
spon_eye_data_LV = squeeze(data.eye_data(2,:,spon_trials));
spon_eye_data_RH = squeeze(data.eye_data(3,:,spon_trials));
spon_eye_data_RV = squeeze(data.eye_data(4,:,spon_trials));

% %% calculate data for drawing
% % eye data of real trials (no spon)
% for k = 1:length(unique_stimType)
%     pc = 0;
%     eye_data_LH_bin{k} = [];% for PSTH ANOVA
%     for j = 1:length(unique_elevation)
%         for i = 1:length(unique_azimuth)
%             eye_data_LH_bin{k,j,i} = [];
%             eye_data_LV_bin{k,j,i} = [];
%             eye_data_RH_bin{k,j,i} = [];
%             eye_data_RV_bin{k,j,i} = [];
%             select = find( (temp_azimuth == unique_azimuth(i)) & (temp_elevation == unique_elevation(j)) & (temp_stimType == unique_stimType(k))) ;
%             if sum(select)>0
%                 eye_data_LH_bin{k,j,i} = real_eye_data_LH(eyeBegBin(1,1):eyeEndBin(1,1),select);
%                 eye_data_LV_bin{k,j,i} = real_eye_data_LV(eyeBegBin(1,1):eyeEndBin(1,1),select);
%                 eye_data_RH_bin{k,j,i} = real_eye_data_RH(eyeBegBin(1,1):eyeEndBin(1,1),select);
%                 eye_data_RV_bin{k,j,i} = real_eye_data_RV(eyeBegBin(1,1):eyeEndBin(1,1),select);
%             end
%         end
%     end
% end


%% plot figures


% initialize default properties
set(0,'defaultaxesfontsize',24);
colorDefsLBY;
% the lines markers
markers = {
    % markerName % markerTime % marker bin time % color
    'fix_in',fixInT(1),fixInBin(1),colorLGray;
    'stim_on',stimOnT(1),stimOnBin(1),colorDRed;
    'stim_off',stimOffT(1),stimOffBin(1),colorDRed;
    };

% Eyetrace for spontaneous trial

figure(111);
clf;
set(gcf,'Position', [0 0 1500 800], 'Name', 'Eye Trace for spontaneous');
h1 = axes('unit','pixels','pos',[100 120 600 600]);
for r = 1:size(spon_eye_data_LH,2)
    color = ['color',num2str(r)];
    plot(h1,spon_eye_data_LH(1:fixInBin(1,1),r),spon_eye_data_LV(1:fixInBin(1,1),r),'linestyle','--','color',eval(color));
    hold on;
    plot(h1,spon_eye_data_LH(fixInBin(1,1):stimOnBin(1,1),r),spon_eye_data_LV(fixInBin(1,1):stimOnBin(1,1),r),'linestyle',':','color',eval(color));
    hold on;
    plot(h1,spon_eye_data_LH(stimOnBin(1,1):stimOffBin(1,1),r),spon_eye_data_LV(stimOnBin(1,1):stimOffBin(1,1),r),'linestyle','-','color',eval(color));
    hold on;
    plot(h1,spon_eye_data_LH(stimOffBin(1,1),r),spon_eye_data_LV(stimOffBin(1,1),r),'linestyle','none','markersize',5,'color','k');
    hold on;
end
set(h1,'xlim',[-1.5 1.5],'ylim',[-1.5 1.5]); % for 2 degree window
set(h1,'xtick',[-1 0 1],'ytick',[-1 0 1]);% for 2 degree window
box off;
title(h1,'Eye trace for spontaneous trials');

% plot h & v as a func of time
h3 = axes('unit','pixels','pos',[800 120 600 200]);
for r = 1:size(spon_eye_data_LH,2)
    color = ['color',num2str(r)];
    plot(h3,1:fixInBin(1,1),spon_eye_data_LV(1:fixInBin(1,1),r),'linestyle','--','color',eval(color));
    hold on;
    plot(h3,fixInBin(1,1):stimOnBin(1,1),spon_eye_data_LV(fixInBin(1,1):stimOnBin(1,1),r),'linestyle',':','color',eval(color));
    hold on;
    plot(h3,stimOnBin(1,1):stimOffBin(1,1),spon_eye_data_LV(stimOnBin(1,1):stimOffBin(1,1),r),'linestyle','-','color',eval(color));
    hold on;
end
box off;
title(h3,'Vetical');
set(h3,'xlim',[1 stimOffBin(1)+10],'ylim',[-1.5 1.5]); % for 2 degree window
set(h3,'ytick',[-1 0 1]);% for 2 degree window
set(h3,'xtick',[]);

h2 = axes('unit','pixels','pos',[800 440 600 200]);
for r = 1:size(spon_eye_data_LH,2)
    color = ['color',num2str(r)];
    plot(h2,1:fixInBin(1,1),spon_eye_data_LH(1:fixInBin(1,1),r),'linestyle','--','color',eval(color));
    hold on;
    plot(h2,fixInBin(1,1):stimOnBin(1,1),spon_eye_data_LH(fixInBin(1,1):stimOnBin(1,1),r),'linestyle',':','color',eval(color));
    hold on;
    plot(h2,stimOnBin(1,1):stimOffBin(1,1),spon_eye_data_LH(stimOnBin(1,1):stimOffBin(1,1),r),'linestyle','-','color',eval(color));
    hold on;
end
box off;
title(h2,'Horizontal');
set(h2,'xlim',[1 stimOffBin(1)+10],'ylim',[-1.5 1.5]); % for 2 degree window
set(h2,'ytick',[-1 0 1]);% for 2 degree window
set(h2,'xtick',[]);

for n = 1:size(markers,1)
    plot(h2,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1.5);
    hold on;
    box off;
    plot(h3,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1.5);
    hold on;
    box off;
end

axes('unit','pixels','pos',[800 60 600 40]);
set(gca,'xlim',[1 stimOffBin(1)+10],'ylim',[0 10]); % to align with h2 & h3
text(fixInBin(1)-30,10,'fix in','fontsize',16);
text(stimOnBin(1)-30,2,'stim on','fontsize',16);
text(stimOffBin(1)-30,2,'stim off','fontsize',16);
axis off;

% text on the figure
axes('unit','pixels','pos',[800 745 700 80]);
xlim([0,100]);
ylim([0,10]);
FileName_Temp = num2str(FILE);
FileName_Temp =  FileName_Temp(1:end-4);
str1 = [FileName_Temp,'\_Ch' num2str(SpikeChan)];
text(0,2,str1,'fontsize',20);
axis off;

% save the figure
str2 = [FileName_Temp,'_Ch' num2str(SpikeChan), '_eyetrace_spon'];
%  str3 = [str1, '_eyetrace'];
% saveas(gcf,['Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_eyetrace\' str2], 'emf')
%  saveas(3,['Z:\LBY\Recording Data\Qiaoqiao\3D_Tuning_eyetrace\' str3], 'emf');

% Eyetrace for 26 directions

for k = 1:length(unique_stimType)
    figure(120+k);
    set(gcf,'pos',[30 50 1800 900]);
    clf;
    [~,h_subplot] = tight_subplot(10,8,0.01,0.05);
    
    for j = 2:length(unique_elevation)-1
        for i = 1:length(unique_azimuth)
            for hv = 1:2
                axes(h_subplot(i+(2*(j-1)+(hv-1))*8));
                %                 plot(real_eye_data{k,j,i}(:,:,hv),'color','k','linewidth',1);
                plot(1:stimOffBin(1,1),real_eye_data{k,j,i}(1:stimOffBin(1,1),:,hv),'k');hold on;
                
                
                for n = 1:size(markers,1)
                    plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
                    hold on;
                    box off;
                    plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
                    hold on;
                    box off;
                end
                SetFigure(15);
                set(gca,'xlim',[1 stimOffBin(1)+10],'ylim',[-1.5 1.5]);
                set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
            end
        end
    end
    
    % 2 extra conditions
    for hv = 1:2
        axes(h_subplot(5+(2*(1-1)+(hv-1))*8));
        %         plot(real_eye_data{k,1,5}(:,:,hv),'color','k','linewidth',1);
        plot(1:stimOffBin(1,1),real_eye_data{k,1,5}(1:stimOffBin(1,1),:,hv),'k');hold on;
        set(gca,'xlim',[1 stimOffBin(1)+10],'ylim',[-1.5 1.5]);
        set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
        for n = 1:size(markers,1)
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
            hold on;
            box off;
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
            hold on;
            box off;
        end
        
        
        axes(h_subplot(5+(2*(5-1)+(hv-1))*8));
        %         plot(real_eye_data{k,5,5}(:,:,hv),'color','k','linewidth',1);
        plot(1:stimOffBin(1,1),real_eye_data{k,5,5}(1:stimOffBin(1,1),:,hv),'k');hold on;
        set(gca,'xlim',[1 stimOffBin(1)+10],'ylim',[-1.5 1.5]);
        for n = 1:size(markers,1)
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
            hold on;
            box off;
            plot(gca,[markers{n,3} markers{n,3}], [-1.5,1.5], ':','color',markers{n,4},'linewidth',1);
            hold on;
            box off;
        end
        set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);hold on;
        SetFigure(15);
        
        
        % spontaneous
        axes(h_subplot(1+(2*(1-1)+(hv-1))*8));
        
    end
    %
    % %     %--- this is for annotation - the direction ----%
    % %     text(4,0,'\downarrow ','fontsize',30);
    % %     text(24,0,'\leftarrow ','fontsize',30);
    % %     text(46,0,'\uparrow ','fontsize',30);
    % %     text(67,0,'\rightarrow ','fontsize',30);
    % %     text(88,0,'\downarrow ','fontsize',30);
    % %     text(52,65,'\uparrow ','fontsize',30);
    % %     text(52,10,'\downarrow ','fontsize',30);
    % %     %--- this is for annotation - the direction ----%
    %     axis off;
    
        %text on the figure
        axes('unit','pixels','pos',[60 820 500 80]);
        xlim([0,100]);
        ylim([0,10]);
        if Protocol == DIRECTION_TUNING_3D
            text(40,0,'Eyetrace(T)','fontsize',20);
        elseif Protocol == ROTATION_TUNING_3D
            text(40,0,'Eyetrace(R)','fontsize',20);
        end
%         text(-1,10,'spontaneous','fontsize',15);
        FileNameTemp = num2str(FILE);
        FileNameTemp =  FileNameTemp(1:end);
        str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
        str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan),'    ',stimType{k}];
        text(90,0,str1,'fontsize',18);
        axis off;
    
        axes('unit','pixels','pos',[60 150 500 80]);
        xlim([0,100]);
        ylim([0,10]);
        text(0,4,'Fix in','fontsize',15);
        text(12,0,'StimOn    StimOff ','fontsize',15);
        axis off;
    %
    %     % save the figure
    %     str2 = [str,'_3DTuning_Eyetrace_',stimType{k}];
    %     set(gcf,'paperpositionmode','auto');
    %     switch Protocol
    %         case DIRECTION_TUNING_3D
    %             ss = [str2, '_T'];
    %             saveas(20+k,['Z:\LBY\Recording data\Qiaoqiao\3D_Tuning\Translation\' ss], 'emf');
    %         case ROTATION_TUNING_3D
    %             ss = [str2, '_R'];
    %             saveas(20+k,['Z:\LBY\Recording data\Qiaoqiao\3D_Tuning\Rotation\' ss], 'emf');
    %     end
end



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