% AZIMUTH_TUNING_1D.m -- Plots response as a function of azimuth for
% heading task
%--	GY, 07/12/04
%Plot the eyetrace as a function of time by YXF 
%Unfinished!
%-----------------------------------------------------------------------------------------------------------------------
function Delayed_Saccade_Analysis_eyetrace_YXF(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, batch_flag)
TEMPO_Defs;
Path_Defs;
ProtocolDefs; %contains protocol specific keywords - 1/4/01 BJP

% save(['K:\Eyetrace\','m7c-888r11'],'-struct','data')

%get the column of values for azimuth and elevation and stim_type
temp_heading  = data.moog_params(HEADING,:,MOOG);
temp_stim_type = data.moog_params(STIM_TYPE,:,MOOG);
temp_amplitude = data.moog_params(AMPLITUDE,:,MOOG);
temp_total_trials = data.misc_params(OUTCOME,:);
                                                                                                                         
%get indices of any NULL conditions (for measuring spontaneous activity
trials = 1:length(temp_heading);
select_trials= trials( (trials >= BegTrial) & (trials <= EndTrial) ); 
heading = temp_heading(select_trials);
stim_type = temp_stim_type(select_trials);
amplitude = temp_amplitude(select_trials);
unique_amplitude = munique(amplitude');
unique_heading=munique(heading');
% accel = reshape(temp_accel, 1000, length(temp_total_trials));
% diode = reshape(temp_diode, 1000, length(temp_total_trials));

repetition = floor( length(select_trials) /length(unique_heading)); % take minimum repetition

% Time information  
h = data.htb_header{EYE_DB};	
eye_bin_width = 1000 * (h.skip + 1) / (h.speed_units / h.speed); % in ms % added by YXF from HH's memory guided saccade protocol;20140905

h2 = data.htb_header{EVENT_DB};	
event_bin_width = 1000 * (h2.skip + 1) / (h2.speed_units / h2.speed);  % in ms % added by YXF from HH's memory guided saccade protocol;20140905

% Event data
events_in_bin = squeeze(data.event_data(1,:,:));
%Eye data
Leye_x_in_bin = squeeze(data.eye_data(1,:,:));
Leye_y_in_bin = squeeze(data.eye_data(2,:,:));
Reye_x_in_bin = squeeze(data.eye_data(3,:,:));
Reye_y_in_bin = squeeze(data.eye_data(4,:,:));
Beg_bin_event=find(events_in_bin==IN_FIX_WIN_CD);
End_bin_event=find(events_in_bin==IN_T1_WIN_CD);
Beg_bin_eye=ceil(Beg_bin_event*event_bin_width/eye_bin_width);
End_bin_eye=ceil(End_bin_event*event_bin_width/eye_bin_width);


% descide whether loop is stim_type or disparity (when there is vary of
% disparity, it's the visual only condition
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for k = 1 : length(unique_stim_type)
%     for i = 1 : length(unique_azimuth)
%         select = find( (stim_type==unique_stim_type(k)) & (azimuth==unique_azimuth(i)) );
%         select2 = find( (stim_type==unique_stim_type(1)) & (azimuth==unique_azimuth(1)) );
for nn = 1 : length(select_trials)
%         for n = 1 : length(select)  
%             DC_begin = mean( (data.eye_data(1,201:300,select(n))-data.eye_data(3,201:300,select(n))) );
%             DC_end = mean( (data.eye_data(1,501:600,select(n))-data.eye_data(3,501:600,select(n))) );
%             DC = mean([DC_begin, DC_end]);
%             verg_azi(n) = mean( (data.eye_data(1,301:500,select(n))-data.eye_data(3,301:500,select(n))) );
%             verg_azi(n) = verg_azi(n) - DC; % subtract DC offset
%             verg_trace_trial(n,:) = data.eye_data(1,201:600,select(n))-data.eye_data(3,201:600,select(n));
%             verg_trace_trial(n,:) = verg_trace_trial(n,:) - DC;            
%         end
           bin=[Beg_bin_eye(select_trials(nn)):End_bin_eye(select_trials(nn)),select_trials(nn)];
           bin=squeeze(bin);
           bin=bin';
            Left_x =Leye_x_in_bin(bin);% - mean(data.eye_data(1,8:400,select_trials(nn)));
            Left_y= Leye_y_in_bin(bin);  %- mean(data.eye_data(2,8:400,select_trials(nn)));
            Right_x =Reye_x_in_bin(bin);% - mean(data.eye_data(3,8:400,select_trials(nn)));
            Right_y= Reye_y_in_bin(bin);% - mean(data.eye_data(4,8:400,select_trials(nn)));
figure(2);
set(2,'Position', [5,1 1000,740], 'Name', 'Delayed Saccade');
axes('position',[0.1,0.3, 0.45,0.5] );
orient portrait;
subplot(5,1,1);
plot(Left_x','-b');
hold on
%ylim([-1,1]);
ylabel('Left X');
title(FILE);
subplot(5,1,2);
plot(Left_y','-b');
hold on
%ylim([-1,1]);
% ylabel('Left Y');
% subplot(5,1,3);
% hold on
% plot(Right_x','-b');
%ylim([-1,1]);
% ylabel('R X');
% subplot(5,1,4);
% plot(Right_y','-b');
% %ylim([-1,1]);
% ylabel('R Y');
%ylim([-5,0]);
hold on
figure(3);
plot(Left_x',Left_y','.-b')
hold on
ylim([-10,10]);
% figure(4);
% plot(Right_x',Right_y','.-b')
% hold on
           
%         % devide data into left, right, forward and backward sections
%         verg_mean{k}(i) = median(verg_azi);
%         verg_trace{k}(i,:) = median( verg_trace_trial(:,:) ) 
end
FileName_Temp = num2str(FILE);
 FileName_Temp =  FileName_Temp(1:end-4);%%To get rid of the '.htb', or the formate of pictures can not be manipulated. 
 str1 = [FileName_Temp,' _Ch' num2str(SpikeChan)];
 str2 = [str1, '_eyetrace_raw'];
 str3 = [str1, '_eyetrace'];
%  saveas(2,['Z:\LBY\Recording Data\Qiaoqiao\Delay_saccade\' str2], 'pdf');
%  saveas(3,['Z:\LBY\Recording Data\Qiaoqiao\Delay_saccade\' str3], 'pdf');
close(2);
close(3);

%     if length(unique_azimuth)==10 % plus 67.5 and 112.5 directions
%         verg_trace_exp{k}(1,:) = median(verg_trace{k}(3:5,:));
%         verg_trace_con{k}(1,:) = verg_trace{k}(9,:);
%         verg_trace_0{k}(1,:) = verg_trace{k}(1,:);
%         verg_trace_180{k}(1,:) = verg_trace{k}(7,:);
%     else
%         verg_trace_exp{k}(1,:) = verg_trace{k}(3,:);
%         verg_trace_con{k}(1,:) = verg_trace{k}(7,:);
%         verg_trace_0{k}(1,:) = verg_trace{k}(1,:);
%         verg_trace_180{k}(1,:) = verg_trace{k}(5,:);
%     end
% figure(2);
% set(2,'Position', [5,1 1000,740], 'Name', 'Heading Discrimination-Vestibular');
% axes('position',[0.1,0.3, 0.45,0.5] );
% orient portrait;
% subplot(4,1,1);
% plot(Left_x','b-');
% ylim([-1,1]);
% ylabel('Left X');
% title(FILE);
% subplot(4,1,2);
% plot(Left_y','b-');
% ylim([-1,1]);
% ylabel('Left Y');
% subplot(4,1,3);
% plot(Right_x','b-');
% ylim([-1,1]);
% ylabel('R X');
% subplot(4,1,4);
% plot(Right_y','b-');
% ylim([-1,1]);
% ylabel('R Y');

% %---------------------------------------------------------------------------------------
% %Also, write out some summary data to a cumulative summary file
% sprint_txt = ['%s'];
% for i = 1 : 1300
%      sprint_txt = [sprint_txt, ' %1.2f'];    
% end
% buff = sprintf(sprint_txt, FILE, verg_trace_exp{1}, verg_trace_con{1}, verg_trace_0{1}, verg_trace_180{1}   );
% outfile = [BASE_PATH 'ProtocolSpecific\MOOG\HeadingDiscrimination\DirectionTuning1D_eyetrace.dat'];
% printflag = 0;
% if (exist(outfile, 'file') == 0)    %file does not yet exist
%     printflag = 1;
% end
% fid = fopen(outfile, 'a');
% if (printflag)
%     fprintf(fid, 'FILE\t');
%     fprintf(fid, '\r\n');
% end
% fprintf(fid, '%s', buff);
% fprintf(fid, '\r\n');
% fclose(fid);
% %---------------------------------------------------------------------------------------
%--------------------------------------------------------------------------
return;