% protocol: Delayed saccade
% plot eyetrace for Delayed saccade
% LBY 20161221

%-----------------------------------------------------------------------------------------------------------------------
function Delayed_Saccade_Analysis_eyetrace_YXF(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag)

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
real_eye_data_LV = squeeze(data.eye_data(8,:,real_trials));
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

return;