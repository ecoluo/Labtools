%-----------------------------------------------------------------------------------------------------------------------
% PSTH for choice-related activity
% Last modified HH20140526
%-----------------------------------------------------------------------------------------------------------------------

function HeadingDis_cum_PSTH_HH(data, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, StartEventBin, StopEventBin, PATH, FILE, Protocol, batch_flag);

TEMPO_Defs;
Path_Defs;

%% Commented by HH20140523
%{
tic

temp_azimuth = data.moog_params(AZIMUTH,:,MOOG);
temp_elevation = data.moog_params(ELEVATION,:,MOOG);
temp_stim_type = data.moog_params(STIM_TYPE,:,MOOG);
temp_heading   = data.moog_params(HEADING, :, MOOG);
temp_amplitude = data.moog_params(AMPLITUDE,:,MOOG);
temp_num_sigmas = data.moog_params(NUM_SIGMAS,:,MOOG);
temp_total_trials = data.misc_params(OUTCOME, :);
temp_spike_data = data.spike_data(SpikeChan,:);
temp_spike_rates = data.spike_rates(SpikeChan, :);
%now, remove trials from direction and spike_rates that do not fall between BegTrial and EndTrial
trials = 1:length(temp_azimuth);		% a vector of trial indices
select_trials = ( (trials >= BegTrial) & (trials <= EndTrial) );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manually omit trials, i.e. due to bumps, lost isolation, etc. (CRF 8-2009)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% omit_trials = [537:563];
% select_trials(omit_trials) = 0;
%
% sumSpikeRates_equalzero = sum(temp_spike_rates<0.1)
% sumSpikeRates_lessthantwo = sum(temp_spike_rates<2)
% maxSpikeRate = max(temp_spike_rates)
% edges = [0 1 2 4 8 16 100];
% histc(temp_spike_rates,edges)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


stim_type = temp_stim_type( select_trials );
heading = temp_heading( select_trials );
amplitude= temp_amplitude( select_trials );
num_sigmas= temp_num_sigmas( select_trials );
total_trials = temp_total_trials( select_trials);
spike_rates = temp_spike_rates( select_trials);
unique_stim_type = munique(stim_type');
unique_heading = munique(heading');
unique_amplitude = munique(amplitude');
unique_num_sigmas = munique(num_sigmas');

h_title{1}='Vestibular';
h_title{2}='Visual';
h_title{3}='Combined';

% timebin for plot PSTH
timebin=50;
% sample frequency depends on test duration
frequency=length(temp_spike_data)/length(select_trials);
% length of x-axis
x_length = frequency/timebin;
% x-axis for plot PSTH
x_time=1:(frequency/timebin);

% remove null trials, bad trials, and trials outside Begtrial~Engtrial
stim_duration = length(temp_spike_data)/length(temp_azimuth);
Discard_trials = find(trials <BegTrial | trials >EndTrial);
for i = 1 : length(Discard_trials)
    temp_spike_data( 1, ((Discard_trials(i)-1)*stim_duration+1) :  Discard_trials(i)*stim_duration ) = 9999;
end
spike_data = temp_spike_data( temp_spike_data~=9999 );
spike_data( find(spike_data>100) ) = 1; % something is absolutely wrong

% monkey's choice
LEFT = 1;
RIGHT = 2;
for i= 1 : length(spike_rates)
    temp = data.event_data(1,:,i + BegTrial-1);
    events = temp(temp>0);  % all non-zero entries
    if (sum(events == IN_T1_WIN_CD) > 0)
        choice(i) = RIGHT;
    elseif (sum(events == IN_T2_WIN_CD) > 0)
        choice(i) = LEFT;
    else
        disp('Neither T1 or T2 chosen.  This should not happen!.  File must be bogus.');
    end
end
% if FILE=='m2c384r2.htb'
%    choice(889) =2; % for cell m2c384r2 % for some reason the choice is 0 for
% end

% count spikes from raster data (spike_data)
max_count = 1;
time_step=1;
time_step_left=1;
time_step_right=1;
for k=1: length(unique_stim_type)
    lefttemp =find( (heading == unique_heading(5)) & (stim_type == unique_stim_type(k)) & choice==1 ) ;
    righttemp =find( (heading == unique_heading(5)) & (stim_type == unique_stim_type(k)) & choice==2 ) ;
    for i=1:length(unique_heading)
        select = logical( (heading==unique_heading(i)) & (stim_type==unique_stim_type(k)) );
        act_found = find( select==1 );
        % count spikes per timebin on every same condition trials
        for repeat=1:length(act_found)
            for n=1:(x_length)
                temp_count(repeat,n)=sum(spike_data(1,(frequency*(act_found(repeat)-1)+time_step):(frequency*(act_found(repeat)-1)+n*timebin)));
                time_step=time_step+timebin;
            end
            time_step=1;
        end
        count_y_trial{i,k}(:,:) = temp_count;  % each trial's PSTH
     
        % get the average of the total same conditions if repetion is > 1
        dim=size(temp_count);
        count_y{i,k} = mean(temp_count);
        max_count_y(i,k) = max(count_y{i,k});
    end
    
%     for repeat_left=1:length(lefttemp)
%         for n=1:(x_length)
%             temp_count_left(repeat_left,n)=sum(spike_data(1,(frequency*(lefttemp(repeat)-1)+time_step):(frequency*(lefttemp(repeat)-1)+n*timebin)));
%             time_step_left=time_step_left+timebin;
%         end
%         time_step_left=1;
%     end
%     count_y_left(k,:) = mean(temp_count_left);
%
%     for repeat_right=1:length(righttemp)
%         for n=1:(x_length)
%             temp_count_right(repeat_right,n)=sum(spike_data(1,(frequency*(righttemp(repeat)-1)+time_step):(frequency*(righttemp(repeat)-1)+n*timebin)));
%             time_step_right=time_step_right+timebin;
%         end
%         time_step_right=1;
%     end
%     count_y_right(k,:) = mean(temp_count_right);
    % normalize PSTH to 1 for each stimulus condition
%     for i=1:length(unique_heading)
%         count_y{i,k} = count_y{i,k} / max(max_count_y(:,k));
%     end
end

% this part find which heading is the maximum response or minimum response
for k=1: length(unique_stim_type)
    for i = 1 : length(unique_heading)
        ss(i) = sum(count_y{i,k}(x_length*3/10:x_length*5.5/10)); % only use 2 middle second data
    end
    mm=find( ss==max(ss));
    nn=find( ss==min(ss));
    max_index(k) = mm(1);
    min_index(k) = nn(1);
end

% plot PSTH now
% get the largest count_y so that make the scale in each figures equal
% plot two lines as stimulus start and stop marker
x_start = [StartEventBin(1,1)/timebin, StartEventBin(1,1)/timebin];
x_stop =  [StopEventBin(1,1)/timebin,  StopEventBin(1,1)/timebin];
y_marker=[0,max(max(max_count_y))];
% define figure
figure(2);
set(2,'Position', [5,5 1000,680], 'Name', 'Tuning');
orient portrait; %changed from landscape by asb (30 july 2007)
axis off;

xoffset=0;
yoffset=0;

% now plot
for k=1: length(unique_stim_type)
    
    axes('position',[0 0 1 1]);
    xlim([-50,50]);
    ylim([-50,50]);
    % here starts the column identification
    text(-25,45, 'vestibular');
    text(0,45, 'visual');
    text(25,45, 'combined');
    text(-45, 45, [FILE ', SpChan ' num2str(SpikeChan)]);
    if k == 1
        for j = 1:length(unique_heading)
            text(-48, 45-j*8, num2str(unique_heading(j)) );
        end
    end
    axis off;
    hold on;
    
    for i=1:length(unique_heading)
        axes('position',[0.31*(k-1)+0.1 (0.92-0.08*i) 0.25 0.05]); %this changes the size and location of each row of figures.
         
        plot( x_time,count_y{i,k}(1,:) );
        hold on;
        plot( x_start, y_marker, 'r-');
        plot( x_stop,  y_marker, 'r-');
        set( gca, 'xticklabel', ' ' );
        % set the same scale for all plot
        xlim([0,x_length]);
        ylim([max(max(max_count_y))*0,max(max(max_count_y))]);
    end
end

toc;

%}

%% Added by HH20140523
%%{

%% Get data

tic;

% -- Trial information

trials = 1:size(data.moog_params,2);		% a vector of trial indices
select_trials = ( (trials >= BegTrial) & (trials <= EndTrial) );

stim_type_per_trial = data.moog_params(STIM_TYPE,select_trials,MOOG);
heading_per_trial   = data.moog_params(HEADING, select_trials, MOOG);

unique_stim_type = munique(stim_type_per_trial');
unique_heading = munique(heading_per_trial');

repetitionN = floor(length(select_trials) / length(unique_heading) / length(unique_stim_type)) ;

% -- Time information
eye_timeWin = 1000/(data.htb_header{EYE_DB}.speed_units/data.htb_header{EYE_DB}.speed/(data.htb_header{EYE_DB}.skip+1)); % in ms
spike_timeWin = 1000/(data.htb_header{SPIKE_DB}.speed_units/data.htb_header{SPIKE_DB}.speed/(data.htb_header{SPIKE_DB}.skip+1)); % in ms
event_timeWin = 1000/(data.htb_header{EVENT_DB}.speed_units/data.htb_header{EVENT_DB}.speed/(data.htb_header{EVENT_DB}.skip+1)); % in ms

% -- Spike data
spike_in_bin = squeeze(data.spike_data(SpikeChan,:,select_trials))';   % TrialNum * 5000
spike_in_bin( spike_in_bin > 100 ) = 1; % something is absolutely wrong

% -- Event data
event_in_bin = squeeze(data.event_data(:,:,select_trials))';  % TrialNum * 5000

% Monkey's choice
LEFT = 1;
RIGHT = 2;

% The previous one was awful. HH20140522
choice = LEFT * squeeze(sum(event_in_bin == IN_T2_WIN_CD,2)) + RIGHT * squeeze(sum(event_in_bin == IN_T1_WIN_CD,2));
if length(unique(choice)) > 2  % This is safer
    disp('Neither T1 or T2 chosen / More than one target chosen.  This should not happen! File must be bogus.');
    keyboard;
end

%% 1. Align data

% Define align markers and offsets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
align_markers = {
    % Marker    Before(ms)    After(ms)    Notes
    VSTIM_ON_CD,  -300, 300, 'Visual On' ;
    SACCADE_BEGIN_CD,  -1500, 700, 'Saccade On';
    };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:size(align_markers,1)    % For each desired marker
    align_offsets(:,j) = mod(find(event_in_bin' == align_markers{j,1}),size(event_in_bin,2));  % Fast way to find offsets for each trial
    
    spike_aligned{j} = zeros(length(select_trials), ceil((align_markers{j,3} - align_markers{j,2}) / spike_timeWin) + 1); % Preallocation
    for i = 1:length(select_trials)
        winBeg = align_offsets(i,j) + ceil(align_markers{j,2} / spike_timeWin);
        winEnd = align_offsets(i,j) + ceil(align_markers{j,3} / spike_timeWin);
        spike_aligned{j}(i,:) = spike_in_bin (i, winBeg : winEnd);   % Align each trial
    end
end

%% 2. Calculate PSTH using sliding windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time windows
binSize = 80;  % in ms
stepSize = 20; % in ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:size(align_markers,1)    % For each desired marker
    
    t_centers{j} = align_markers{j,2} + binSize/2 : stepSize : align_markers{j,3} - binSize/2; % Centers of PSTH time windows
    
    spike_hist{j} = zeros(length(select_trials),length(t_centers{j})); % Preallocation
    for k = 1:length(t_centers{j})
        winBeg = ceil(((k-1) * stepSize) / spike_timeWin) + 1;
        winEnd = ceil(((k-1) * stepSize + binSize) / spike_timeWin) + 1;
        spike_hist{j}(:,k) = sum(spike_aligned{j}(: , winBeg:winEnd),2) / binSize*1000 ;  % in Hz
    end
    
end


%% 3. Sort trials into different categories

% Define "Preferred direction"
left_all = sum(sum(spike_aligned{2}(choice == LEFT, 1: round(abs(align_markers{j,2})/(align_markers{j,3} - align_markers{j,2})*end)))); % Roughly pre-saccade time widow
right_all = sum(sum(spike_aligned{2}(choice == RIGHT, 1: round(abs(align_markers{j,2})/(align_markers{j,3} - align_markers{j,2})*end)))); % Roughly pre-saccade time widow
if left_all >= right_all
    PREF = LEFT;
    NULL = RIGHT;
    choose_names = {'Choose PREF(L)' ;'Choose NULL(R)'};
else
    PREF = RIGHT;
    NULL = LEFT;
    choose_names = {'Choose PREF(R)' ;'Choose NULL(L)'};
end

% Define colormap for headings
colors = colormap(cool); % This is really cool.
color_for_headings = colors(end-round(linspace(1,64,sum(unique_heading<0)))+1,:);
if sum(unique_heading ==0)
    color_for_headings = [color_for_headings; 0 0 0; flipud(color_for_headings)]; % Zero heading: black
else
    color_for_headings = [color_for_headings; flipud(color_for_headings)];
end

style_for_headings = vertcat(repmat({'-'},sum(unique_heading<=0),1), repmat({'--'},sum(unique_heading>0),1)); % Preferred LEFT by default
if PREF == RIGHT
    style_for_headings = flipud(style_for_headings);
end

stim_type_names = {'All','Vest','Vis','Comb'}; % stim_type = 0, 1, 2, 3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define sort information (The syntax is a little bit intricate, but when you understand it, you'll love it.)

sort_info = {
    % Each cell for differnt bases of classification (generate separated figures)
    
%     % Fig.1: Rows: stim types; Sort according to: Choose Right and Coose Left, all headings
%     {
%         % Rows in subplot (stim types)
%         {   % stim_types (0 = all)   % Notes
%             unique_stim_type, {'Vest','Vis','Comb'}
%         };
% 
%         % In each subplot (max nested level: 2)
%         %  Variable(s) ,  Values  , Colors,  LineStyles,    Notes,   Errorbar?
%         {
%             'choice', [PREF NULL], [1 0 0; 0 0 0], {'-'; '-'}, choose_names, 1;
%         }
%     };

    % Fig.2: Rows: none; Sort according to: stim type & Choice
    {
        % Rows in subplot (stim types)
        {   % stim_types (0 = all)   % Notes
             0, stim_type_names(0+1)
        };

        % In each subplot (max nested level: 2)
        {    %  Variable(s) ,  Values  , Colors,  LineStyles,    Notes,   Errorbar?
            'stim_type_per_trial''', unique_stim_type, [0 0 0; 1 0 0; 0 1 0.2],{},stim_type_names(unique_stim_type+1), 1;
            'choice', [PREF NULL], [], {'-'; '--'}, choose_names, 1;
        }
    }
    
    % Fig.3: Rows: stim types; Sort according to: Heading angles
    {
        % Rows in subplot (stim types)
        {   % stim_types (0 = all)   % Notes
            unique_stim_type, stim_type_names(unique_stim_type+1)
        };

        % In each subplot (max nested level: 2)
        {    %  Variable(s) ,  Values  , Colors,  LineStyles,    Notes,   Errorbar?
            'heading_per_trial''', unique_heading, color_for_headings, style_for_headings, cellstr(num2str(unique_heading)) , 0;
        }
    };
    
    
    % Fig.4: Rows: stim types; Sort according to: Abs(Heading angles) && choices
    {
        % Rows in subplot (stim types)
        {   % stim_types (0 = all)   % Notes
            unique_stim_type, stim_type_names(unique_stim_type+1)
        };

        % In each subplot (max nested level: 2)
        {    %  Variable(s) ,  Values  , Colors,  LineStyles,    Notes,   Errorbar?
            'abs(heading_per_trial)''', unique(abs(unique_heading)), color_for_headings(ceil(end/2):end,:), {}, cellstr(num2str(unique(abs(unique_heading)))) , 0;
            'choice', [PREF NULL], [], {'-'; '--'}, choose_names, 1;
        }
    }

    
    };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Calculate temporal duration ratio for each align_marker
temp_duration_ratio = zeros(1,size(align_markers,1));
for j = 1:size(align_markers,1)
    temp_duration_ratio(j) = align_markers{j,3} - align_markers{j,2};
end

% Plot

for sortInd = 1:length(sort_info) % For each figure
    figure(10+sortInd); clf;
    
    stim_type_to_plot = sort_info{sortInd}{1}{1}; % [unique_stim_type 4]
    h_subplot = tight_subplot(length(stim_type_to_plot),size(align_markers,1),[0.01 0.02],[0.05 0.1],[0.1 0.05],[],temp_duration_ratio);
    
    nest_levels = size(sort_info{sortInd}{2},1);
        
    % Preallocation of legend
    if nest_levels > 2 ; 
        disp('Too many nest levels...'); keyboard; 
        return; 
    elseif nest_levels == 1
        catsOut = sort_info{sortInd}{2}{1,2};
        h_legend = zeros(length(catsOut),1);
        txt_legend = cell(size(h_legend));
    elseif nest_levels == 2
        catsOut = sort_info{sortInd}{2}{1,2};
        catsIn = sort_info{sortInd}{2}{2,2};
        
        h_legend = zeros(length(catsOut)*length(catsIn),1);
        txt_legend = cell(size(h_legend));
    end
    
    for k = 1:length(stim_type_to_plot)  % The last one: all conditions
        for j = 1:size(align_markers,1)
            
            l = sub2ind([length(stim_type_to_plot) size(align_markers,1)],k,j);
            axes(h_subplot(l));
            
            if nest_levels == 1 % 1 nested condition
                
                for catNum_Out = 1:length(catsOut)
                    selected_condition = eval(sprintf('%s == %s',sort_info{sortInd}{2}{1,1},num2str(catsOut(catNum_Out))));
                    
                    if sort_info{sortInd}{1}{1}(k) > 0  % Not all conditions
                        selected_condition = selected_condition & (stim_type_per_trial' == unique_stim_type(k));
                    end
                    
                    lineColor = sort_info{sortInd}{2}{1,3}(catNum_Out,:);
                    lineStyle = sort_info{sortInd}{2}{1,4}{catNum_Out,:};
                    
                    if sort_info{sortInd}{2}{1,6}
                        h=shadedErrorBar(t_centers{j},spike_hist{j}(selected_condition,:),{@(x) mean(x), @(x) std(x)/sqrt(size(x,1))*1.96},...
                            {'Color',lineColor,'LineStyle',lineStyle},1);
                        set(h.mainLine,'LineWidth',2);  hold on;
                        
                    else
                        h.mainLine=plot(t_centers{j},mean(spike_hist{j}(selected_condition,:)),'Color',lineColor,'LineStyle',lineStyle);
                        set(h.mainLine,'LineWidth',2);  hold on;
                    end
                    
                    h_legend(catNum_Out) = h.mainLine;
                    txt_legend{catNum_Out} = sort_info{sortInd}{2}{1,5}{catNum_Out};
                    axis tight
                    
                end % sort_conditions
                
            elseif nest_levels == 2 % 2 nested conditions
            
                for catNum_Out = 1:length(catsOut)
                    for catNum_In = 1:length(catsIn)

                        selected_condition = eval(sprintf('%s == %s & %s == %s',...
                            sort_info{sortInd}{2}{1,1},num2str(catsOut(catNum_Out)),...
                            sort_info{sortInd}{2}{2,1},num2str(catsIn(catNum_In))));
                        
                        if sort_info{sortInd}{1}{1}(k) > 0  % Not all conditions
                            selected_condition = selected_condition & (stim_type_per_trial' == unique_stim_type(k));
                        end
                        
                        lineColor = sort_info{sortInd}{2}{1,3}(catNum_Out,:);
                        lineStyle = sort_info{sortInd}{2}{2,4}{catNum_In,:};
                        
                        if sort_info{sortInd}{2}{1,6}
                            h=shadedErrorBar(t_centers{j},spike_hist{j}(selected_condition,:),{@mean, @(x) std(x)/sqrt(size(x,1))*1.96},...
                                {'Color',lineColor,'LineStyle',lineStyle},1);
                            set(h.mainLine,'LineWidth',2);  hold on;
                            
                        else
                            h.mainLine=plot(t_centers{j},smooth(mean(spike_hist{j}(selected_condition,:)),1),'Color',lineColor,'LineStyle',lineStyle);
                            set(h.mainLine,'LineWidth',2);  hold on;
                        end
                        
                        h_legend((catNum_Out-1)*length(catsIn)+catNum_In) = h.mainLine;
                        txt_legend{(catNum_Out-1)*length(catsIn)+catNum_In} = [sort_info{sortInd}{2}{1,5}{catNum_Out} ',' sort_info{sortInd}{2}{2,5}{catNum_In}];

                        axis tight
                        
                    end % In sort_conditions
                end % Out sort_conditions
            end
            
            % Post-plot stuffs
            if k < length(stim_type_to_plot) ;set(gca,'xticklabel',''); end
            if k ==1 ; title(align_markers{j,4}); end
            
            if j > 1
                set(gca,'yticklabel','');
            else
                ylabel(sort_info{sortInd}{1}{2}{k});
            end
            
            ylims(l,:) = ylim;
            
        end % align_markers
        
    end  % stim_type
    
    % Post-plot stuffs
    for l = 1: k*j
        axes(h_subplot(l));
        ylim([0 max(ylims(:,2))*1.05]);
        plot([0 0],[0 max(ylims(:,2))*1.05],'k','linewidth',2);
        grid on;
    end
    legend(h_legend,txt_legend);
    
    SetFigure(15);
    
end % sort_bases


toc

return;