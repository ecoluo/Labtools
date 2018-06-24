function BATCH_GUI_Tempo_Analysis(batchfiledir, batch_filename, close_flag, print_flag, protocol_filter, analysis_filter, config)

if nargin < 7
    config = nan;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Decide number of workers on the cluster based on "fileToRun" HH20180621
% fileToRun Syntax: -[thisNode, node1, nCPU1, node2, nCPU2, node3, nCPU3, ...]

if any(config < 0) % SGE control (submitted by qsub)
    SGE = 1;
    thisNode = - config(1); % Which node is this node?
    nodeCPUPairs = - config(2:end);
    numWorkers = nodeCPUPairs(thisNode*2); % Number of CPU of this node
else
    SGE = 0; % config is nan or is all positive
    numWorkers = 20; % Default
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd /home/byliu

% hostname = char( getHostName( java.net.InetAddress.getLocalHost)); % Get host name

% For parallel processing
% %{
if ~verLessThan('matlab','R2014a')
    if isempty(gcp('nocreate'))
        parpool('local',numWorkers,'IdleTimeout',inf);
    end
else
    if matlabpool('size') == 0
        try
            matlabpool;
        catch
        end
    end
end
%}

TEMPO_Defs;
Path_Defs;

ori_filename = batch_filename;
batch_filename = [batchfiledir batch_filename];

% Reopen the file
% fclose(fid);
fid = fopen(batch_filename);
line = fgetl(fid);

% % Clear persistent variable "XlsData" in SaveResult.m in case I have changed xls file between calls of BATCH_GUI. HH20150724
% clear SaveResult;
%
% % Preparation for speed-up version of "xlswrite1.m"
% global Excel;
%
% File = '/ion/gu_lab/byliu/Z/Data/MOOG/Results/Result_LBY.xlsm';
% % File = '/ion/gu_lab/byliu/Z/Data/MOOG/Results/Result_MST.xlsm';
%
%
% try
%     Excel = actxGetRunningServer('Excel.Application');  % Use the current server
% catch
%     Excel = actxserver('Excel.Application');  % Start a new server
% end
%
% isopen = xls_check_if_open(File,'');
% if ~isopen  % Open file
%
% winopen('/ion/gu_lab/byliu/Z/Data/MOOG/Results/Result_LBY.xlsm');
% % winopen('/ion/gu_lab/byliu/Z/Data/MOOG/Results/Result_MST.xlsm');
%
% end

% invoke(Excel.Workbooks,'Open',File); % There is not need for this because "isopen" has ensured that it has been opened.

% Error tolerance is important in batch process! HH20140510
errors = 0;

% ================ First get all lines, then do parallel computing on the cluster. HH20180607 ============
nn = 0; % Use to count files that needed to be batched.
tic
while (line ~= -1)
    
    %pause;
    % format for batch files
    % PATH  FILE
    %     line(1) ~= '%'
    if (line(1) ~= '%')
        
        % first remove any comment text at the end of a line (following a %), GCD, added 9/25/01
        comment_start = find(line == '%');
        if ~isempty(comment_start)
            line = line(1:(comment_start(1)-1));
        end
        
        spaces = isspace(line);
        space_index = find(spaces);
        
        %get path / file
        PATH = line(1:space_index(1) - 1);
        FILE = line(space_index(1) + 1:space_index(2) - 1);
        mat_PATH = [PATH(1:end-4) 'Analysis/SortedSpikes2/']; %copied from HH 20180622
        
        % I use this to indicate that we only need to export the files (for data sharing). HH20141103
        if print_flag == -999
            
            
            outpath = [batchfiledir ori_filename(1:strfind(ori_filename,'.')-1) '_Exported/'];
            if ~exist(exportPath,'dir')
                mkdir(exportPath);
            end
            
            htbOK =copyfile([PATH FILE '.htb'],[exportPath FILE '.htb']);
            logOK=copyfile([PATH FILE '.log'],[exportPath FILE '.log']);
            matOK=copyfile([mat_PATH FILE '.mat'],[exportPath FILE '.mat']); %copied from HH 20180622
            
            if ~(htbOK && logOK)
                errors = errors + 1;
                errorFiles(errors).fileName = [PATH FILE];
                errorFiles(errors).line = lineNum;
            end
            
            line = fgetl(fid);
            continue; % Jump to next file directly
        end
        
        if protocol_filter ~= -1
            
            l = length(FILE);
            if (FILE(l-3:l) == '.htb')	% .htb extension already there
                %                 data_filename = [PATH FILE];   %the HTB data file
                logfile = [PATH FILE(1:l-4) '.log'];   %the TEMPO log file
            else	%no extension in FILE, add extensions
                %                 data_filename = [PATH FILE '.htb'];   %the HTB data file
                logfile = [PATH FILE '.log'];   %the TEMPO log file
            end
            
            % ------ Read in protocol type and add to cell array ------
            
            % Add protocol names manually to files that have been rescued from CED. HH20150723
            switch logfile
                case { '/ion/gu_lab/byliu/Z/Data/MOOG/Qiaoqiao/raw/m6c605r1.log'
                        }   % 3DT tasks rescued from CED
                    beep;
                    protocol_name = 100;
                case {'/ion/gu_lab/byliu/Z/Data/MOOG/Qiaoqiao/raw/m6c617r2.log'}   % 3DR tasks rescued from CED
                    beep;
                    protocol_name = 112;
                otherwise
                    % Read the log file normally
                    protocol_info = textread(logfile, '%s', 3);
                    protocol_name = str2num(protocol_info{2});
            end
            
            do_file = protocol_name == protocol_filter; % good stuff!(copied from HH)
            
        else
            do_file = 1;
        end % if protocol_filter ~= 1 ...
        
        if do_file == 1
            
            
            %get analysis type
            if analysis_filter ~= -1
                TempAnalysis1 = analysis_strings{protocol_filter + 1}(analysis_filter);
                TempAnalysis = TempAnalysis1{1};
                i = 2;
                while(line(space_index(i)-1) ~= '''')
                    i = i+1;
                end
            else
                %special commands for analysis read
                i = 2;
                TempAnalysis = '';
                while(line(space_index(i)-1) ~= '''')
                    i = i+1;
                end
                
                TempAnalysis = strcat(TempAnalysis, line(space_index(2) + 2:space_index(i)-2));
            end
            
            Analysis = {};
            Analysis{1} = TempAnalysis;
            
            %get beginning trial
            BegTrial = line(space_index(i) + 1:space_index(i+1) - 1);
            BegTrial = str2num(BegTrial);
            
            %get ending trial
            EndTrial = line(space_index(i+1) + 1:space_index(i+2) - 1);
            EndTrial = str2num(EndTrial);
            
            %get startcode
            StartCode = line(space_index(i+2) + 1:space_index(i+3) - 1);
            StartCode = str2num(StartCode);
            
            %get startoffset
            StartOffset = line(space_index(i+3) + 1:space_index(i+4) - 1);
            StartOffset = str2num(StartOffset);
            
            %get stopcode
            StopCode = line(space_index(i+4) + 1:space_index(i+5) - 1);
            StopCode = str2num(StopCode);
            
            %get stopoffset
            StopOffset = line(space_index(i+5) + 1:space_index(i+6) - 1);
            StopOffset = str2num(StopOffset);
            
            %get select_data - good trials or bad trials
            good_flag = line(space_index(i+6) + 1:space_index(i+7) - 1);
            good_flag = str2num(good_flag);
            
            %get spikechannels & sync code flags
            
            if (i + 9 - 1 < length(space_index) )
                %if there are sync pulse value
                SpikeChan = line(space_index(i+7) + 1:space_index(i+8) - 1);
                SpikeChan = str2num(SpikeChan);
                SpikeChan2 = line(space_index(i+8) + 1:space_index(i+9) - 1);
                SpikeChan2 = str2num(SpikeChan2);
                UseSyncPulses = line(space_index(i+9) +  1:length(line) );
                UseSyncPulses = str2num(UseSyncPulses);
            else
                SpikeChan = line(space_index(i+7) + 1:length(line));
                SpikeChan = str2num(SpikeChan);
                SpikeChan2 = SpikeChan;
                %if sync pulses flag not set, assume we want to use TEMPO START_CD & STOP_CD
                UseSyncPulses = 0;
            end
            
            % ==== Cache files ==== % copied from HH
            
            nn = nn + 1;
            para_batch_all{nn} = {Analysis, SpikeChan , SpikeChan2, StartCode, StopCode,...
                BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, UseSyncPulses, good_flag};
            
        end
        
    end
    
    line = fgetl(fid);
end


N = nn; % Total number of files
fprintf('Total number of files in the Batch file: %g\n', N);

% --- Decide which part of batch file should be run by this node
if isnan(config)
%     config = 1:N; 
toRunIndex = 1:N;
nBegin = 1;
nEnd = N;
elseif SGE % SGE control
    nCPUs = nodeCPUPairs(2:2:end);
    nNode = length(nCPUs);
    
    nEnd = 0;
    
    for nn = 1 : thisNode  % Make sure all the nodes get the correct range
        nBegin = nEnd + 1;
        nEnd = nBegin + ceil(nCPUs(nn) / sum(nCPUs) * N) - 1; % Use ceil to ensure all the files will be run
    end
    
    toRunIndex = nBegin : nEnd;  % Could be larger than N because we have intersect below.
    
    % averN = ceil(N/totalNodeN);
    % config = (thisNode - 1) * averN + 1 : thisNode * averN; % Could be larger than N because we have intersect below.
else     % Regular manual control
    ;    % Do nothing
end

para_batch_to_run = para_batch_all(intersect(1:N, toRunIndex));

N = length(para_batch_to_run); % New N
fprintf('To run: [%g ~ %g], %g in total\n', nBegin, nEnd, N);

errorFiles(N).fileName = [];


% ======================== Do parallel processing ===================

if ~SGE, parfor_progress(N); end   % Because there could be conflict of parfor_progress.m

PROTOCOLForParWorkers = PROTOCOL;
parfor nn = 1:N
    try   % Error tolerance is important in batch process! HH20140510
        
        %                       1         2          3           4         5
        % para_batch{nn} = {Analysis, SpikeChan, SpikeChan2, StartCode, StopCode,...
        %                  6         7           8          9         10    11        12            13
        %               BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, UseSyncPulses, good_flag};
        
        %load data file
        
        [return_val, g_data, b_data] = LoadTEMPOData(para_batch_to_run{nn}{10},para_batch_to_run{nn}{11});
        
        if return_val == -1
            fprintf('*** HTB not found: %s ***\n',[para_batch_to_run{nn}{10},para_batch_to_run{nn}{11}]);
        end
        
        if return_val == -999 && para_batch_to_run{nn}{2} >= 5
            % I throw an error message only when we are in batch mode and we DO use the offline spike2 data.
            error('Htb & spike2 files not matched ...\n');
        end
        
        if (para_batch_to_run{nn}{13})
            select_data = g_data;
        else
            select_data = b_data;
        end
        
        if para_batch_to_run{nn}{6} == -1
            para_batch_to_run{nn}{6} = 1;
        end
        
        
        if para_batch_to_run{nn}{7} == -1
            para_batch_to_run{nn}{7} = size(g_data.event_data,3);
        end
        
        %get protocol type
        Protocol = g_data.one_time_params(PROTOCOLForParWorkers);		%get the protocol string descriptio
        
        %analyze data
        batch_flag = ori_filename;
        
        % --------- Do analysis finally ---------
        %                       1         2          3           4         5
        % para_batch{nn} = {Analysis, SpikeChan, SpikeChan2, StartCode, StopCode,...
        %                  6         7           8          9         10    11        12            13
        %               BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE, UseSyncPulses, good_flag};
        
        Analysis_Switchyard(select_data, Protocol, para_batch_to_run{nn}{1}, para_batch_to_run{nn}{2}, para_batch_to_run{nn}{3}, para_batch_to_run{nn}{4}, para_batch_to_run{nn}{5}, ...
            para_batch_to_run{nn}{6}, para_batch_to_run{nn}{7}, para_batch_to_run{nn}{8}, para_batch_to_run{nn}{9}, para_batch_to_run{nn}{10}, para_batch_to_run{nn}{11}, batch_flag, para_batch_to_run{nn}{12});
        
    catch exception
        errorFiles(nn).fileName = [para_batch_to_run{nn}{11}];
        errorFiles(nn).info = exception;
        fprintf('*** Got error at %s ***\n',para_batch_to_run{nn}{11});
        fprintf('\t%s\n\tLine%g\n\t%s\n', exception.message, exception.stack(1).line, exception.stack(1).file)
    end
    
    if ~ SGE, parfor_progress; end
end
if ~ SGE, parfor_progress(0); end

fclose(fid);

% % Close xls server. See "xlswrite1.m" for details
% invoke(Excel.ActiveWorkbook,'Save');
% % Excel.Quit
% Excel.delete
% clear global Excel


if print_flag == -999
    
    copyfile(batch_filename,[exportPath ori_filename]);
    
else

    outpath = ['/ion/gu_lab/byliu/Z/Data/TEMPO/BATCH/' ori_filename(1:end-2) '/'];
    
    if ~exist(outpath,'dir')
        mkdir(outpath);
    end
    
    copyfile(batch_filename,[outpath ori_filename]);
end



% home;
realError = [];
if ~isempty([errorFiles(:).fileName])
    
    fprintf('\nOops, the following file(s) have error:\n\n');
    for i = 1:N
        if ~isempty(errorFiles(i).fileName)
            disp([num2str(i) ':  ' errorFiles(i).fileName]);
            realError = [realError, errorFiles(i)];
        end
    end
    
    assignin('base','BatchErrorInfo',realError);
    
    save([outpath 'BatchError.mat'], 'realError');
else
    fprintf('All success!\n');
end

toc

% audio = audioplayer(audioread('/home/byliu/Z/Labtools/Matlab/TEMPO_Analysis/type.wav'),20000);
% playblocking(audio);
%
% % Window vibration, HaHa. HH20130829
% figure(1001);
% set(1001,'Unit','pixel');
% currPos = get(1001,'Position');
%
% for ii = 1:6
%     set(1001,'Position',[currPos(1) + 10*mod(ii,2) currPos(2) currPos(3) currPos(4)]);
%     drawnow;
%     pause(0.02);
% end
end
