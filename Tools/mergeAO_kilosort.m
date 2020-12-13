% Catenate *.mat files converted from alpha-omega *.mpx files (limited by 1G) together
% (These .mat files were converted by Mapfile)
% Then convert them into a binary file with size of [nChannels*nTimepoints], in int16
% Change the order for different arrays
% LBY 20191223-20200306

function mergeAO_kilosort(action)

global ori_data;
chName = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016',...
    '017','018','019','020','021','022','023','024','025','026','027','028','029','030','031','032',...
    '033','034','035','036','037','038','039','040','041','042','043','044','045','046','047','048',...
    '049','050','051','052','053','054','055','056','057','058','059','060','061','062','063','064'};

%%%%%%%%%%%%%%%% CHANGE HERE !!!! %%%%%%%%%%%%%%%%%%%%%%
chOrder = [9,10,11,12,13,14,15,16,8,7,6,5,4,3,2,1]; % True order of your electrodes corresponding to AO configs, This is for v-probe
% This means, from the top to the dip of the linear array, the channel numbers displayed in AO configs
%%%%%%%%%%%%%%%% CHANGE HERE !!!! %%%%%%%%%%%%%%%%%%%%%%

PathHandle = findobj(gcbf, 'Tag', 'Pathname');pathname = get(PathHandle,'string');
SaveHandle = findobj(gcbf, 'Tag', 'SavePath');savepath = get(SaveHandle,'string');
FileHandle = findobj(gcbf, 'Tag', 'Filename');cellname = pathname(end-8:end);
ChHandle = findobj(gcbf, 'Tag', 'channel number');chN = str2num(get(ChHandle,'string')); % the number of channels
infoHandle = findall(gcbf,'tag','InfoShowPanel');

cd(pathname);
% cellname = get(FileHandle,'string');

filename = dir([pathname,'\*-*.mat']);

if isempty(filename)
    set(infoHandle,'string',[]);
    %     set(infoHandle,'string','There''re no files in this directory!!!');
    disp('There''re no files in this directory!!!');
    return;
end
showlist = [];set(infoHandle,'string',showlist);

switch (action)
    
    case 'load data'
        
        
        % load spike data
        ori_data  = [];
        progressbar('Load AO .mat files');
        for fs = 1:length(filename)
            ori_data{fs} = load([pathname '\' filename(fs).name]);
            progressbar(fs/length(filename));
        end
        
        % Change file & path name
        set(FileHandle,'string',cellname); % Refresh the file name
        f = fopen('Z:\Labtools\Tools\MergeAO_k_LastFileName.txt','w'); % Save the file name to disk.
        fprintf(f, cellname);
        fclose(f);
        set(SaveHandle,'string',pathname); % Refresh the save path
        
        % Window vibration, HaHa. From HH20130829
        set(gcf,'Unit','pixel');
        currPos = get(gcf,'Position');
        
        for ii = 1:6
            set(gcf,'Position',[currPos(1) + 10*mod(ii,2) currPos(2) currPos(3) currPos(4)]);
            drawnow;
            pause(0.02);
        end
        
        % Show infomation
        showlist{1} = ['Loading spike data of ', cellname, '...'];
        showlist{2} = ['There are ', num2str(length(filename)), ' files in total.'];
        showlist{3} = 'All data have been loaded!';
        set(infoHandle,'string',showlist);
        
    case 'merge files'
        
        % preallocate memory for data
        SPKLength = 0;
        for fs = 1:length(filename)
            eval(['SPKLength = SPKLength + length(ori_data{',num2str(fs),'}.CSPK_001.Samples);']);
            % SPKLength = SPKLength + length(ori_data{1}.CSPK_001.Samples);
        end
        
        data = ones(chN,SPKLength)*nan;
        
        disp('Merging files...');
        progressbar('Merging files');
        % Merge files for spike data
        for ch = 1:chN
            chTure = chOrder(ch);
            tempSPK = [];
            
            for fs = 1:length(filename)
                eval(['tempSPK = [tempSPK, ori_data{',num2str(fs),'}.CSPK_',chName{chTure},'.Samples];']);
                % tempSPK = [tempSPK, ori_data{1}.CSPK_001.Samples];
            end
            
            eval(['tempSR = ori_data{1}.CSPK_',chName{chTure},'.KHz * 1000;']);
            % tempSR = ori_data{1}.CSPK_001.KHz * 1000;
            
            data(ch,:) = tempSPK;
            progressbar(ch/chN);
            
        end
        
        % save 'data' into a .mat file, for combining files of different tasks into one
        save([savepath(1:strfind(savepath, 'LA')+1),'\',cellname, '.mat'],'data','-v7.3'); % this will take time, I didn't find good ways to solve it.
        
        % write data into a .bin file for kilosort
        data = int16(data);
        %         fid =  fopen([savepath,'\',cellname, '.bin'], 'w'); % e.g.Z:\Data\MOOG\Qiaoqiao\raw\LA\m5c1665r1\m5c1665r1.bin
        fid =  fopen([savepath(1:strfind(savepath, 'LA')+1),'\',cellname, '.bin'], 'w'); % e.g.Z:\Data\MOOG\Qiaoqiao\raw\LA\m5c1665r1.bin
        fwrite(fid, data, 'int16'); % spike data with size of [nChannels*nTimepoints], in int16
        fclose(fid);
        
        % Save the sampling rate
        SPK_fs = ori_data{1}.CSPK_001.KHz*1000;
        save([cellname,'_fs'],'SPK_fs');
        
        % Save the time info, in s
        SPKtBegin = ori_data{1}.CSPK_001.TimeBegin;
        SPKtEnd = ori_data{end}.CSPK_001.TimeEnd;
        SPK_dur = SPKtEnd - SPKtBegin + 1;
        save([cellname,'_TimeDuration'],'SPK_dur');
        
        % Merge digital marker files
        DM_fs = ori_data{1}.CInPort_001.KHz*1000;
        tempDM = [];
        for fs = 1:length(filename)
            eval(['tempDM = [tempDM, ori_data{',num2str(fs),'}.CInPort_001.Samples];']);
        end
        spkTimeBegin = ori_data{1}.CSPK_001.TimeBegin*DM_fs; % the start time of the first SPK, in Hz of Digital Marker
        tempDM(1,:) = tempDM(1,:) - spkTimeBegin;
        markers = tempDM;
        save([cellname,'_DM'],'markers','DM_fs');
        
        % clear the memory
        %         clear global ori_data;
        disp(['All ',num2str(chN),' channels have been saved!']);
        
    case 'show info'
        % show basic informations about the data
        for ch = 1:chN
            eval(['tempSR = ori_data{1}.CSPK_',chName{ch},'.KHz * 1000;']);
            % tempSR = ori_data{1}.CSPK_001.KHz * 1000;
            eval(['tempT = ori_data{1}.CSPK_',chName{ch},'.TimeEnd - ori_data{1}.CSPK_',chName{ch},'.TimeBegin;']);
            
            % save all infos into output
            infoSr{ch} = tempSR; % Sample rate, Hz
            infoT{ch} = tempT; % Total time, ms
            
        end
        
        infoshowlist{1} = ['Session: ',cellname, '. ', num2str(length(filename)), ' files in total.'];
        infoshowlist{2} = ['Sampling rate: Hz ', num2str(cell2mat(infoSr))];
        infoshowlist{3} = ['Total time: ',num2str(infoT{1}), ' ms'];
        %         infoshowlist{4} = nan;
        set(infoHandle,'string',infoshowlist);
        
    case 'load DM'
        % Merge digital marker files
        DM_fs = ori_data{1}.CInPort_001.KHz*1000;
        
        tempDM = [];
        for fs = 1:length(filename)
            eval(['tempDM = [tempDM, ori_data{',num2str(fs),'}.CInPort_001.Samples];']);
        end
        spkTimeBegin = ori_data{1}.CSPK_001.TimeBegin*DM_fs; % the start time of the first SPK, in Hz of Digital Marker
        tempDM(1,:) = tempDM(1,:) - spkTimeBegin;
        markers = tempDM;
        save([cellname,'_DM'],'markers','DM_fs');
        
    case 'save files'
        % save as different format for different spike sorting algorithms
        % ÏÈÍÚ‚€¿Ó
        
    case 'combine tasks'
        
        clear ori_data; % Or "out of memory"
        
        % first, find how many files you have for this neuron, and print the information
        filenameCom = dir([savepath(1:strfind(savepath, 'LA')+1),'\',cellname(1:strfind(cellname, 'r')),'*.mat']);
        cd([savepath(1:strfind(savepath, 'LA')+1),'\']);
        disp(['There are ',num2str(length(filenameCom)),' files: ']);
        for ii = 1:length(filenameCom)
            disp(filenameCom(ii).name);
        end
        
        % Now, write the data into a new .bin file for kilosort, This really take time 'cause the .mat file is too big
        fid = fopen([savepath(1:strfind(savepath, 'LA')+1),'\',cellname(1:strfind(cellname, 'r')-1),'.bin'], 'a'); % e.g.m5c1665.bin
        for ii = 1:length(filenameCom)
            load(filenameCom(ii).name); % e.g.m5c1665r1.mat, spike data with size of [nChannels*nTimepoints]
            data = int16(data);
            fwrite(fid, data, 'int16'); % spike data with size of [nChannels*nTimepoints], in int16
            clear data;
        end
        fclose(fid);
  
    case 'splitting' % splitting the results of the spike sorting. The time points are important
        
        % first, find how many files you have for this neuron, and print the information
        filenameCom = dir([savepath(1:strfind(savepath, 'LA')+1),'\',cellname(1:strfind(cellname, 'r')),'*.mat']);
%         cd([savepath(1:strfind(savepath, 'LA')+1),'\']);
        disp(['There are ',num2str(length(filenameCom)),' files: ']);
        for ii = 1:length(filenameCom)
            disp(filenameCom(ii).name);
        end
        
        % read cluster and time information from .npy files (kilosort)
        filenameSplit = cellname(1:strfind(cellname, 'r')-1);
        clustersCom = readNPY(['C:\data\',filenameSplit,'\spike_clusters.npy']); clustersCom = double(clustersCom);
        timeCom = readNPY(['C:\data\',filenameSplit,'\spike_times.npy']); timeCom = double(timeCom);
        templatesCom = readNPY(['C:\data\',filenameSplit,'\templates.npy']); templatesCom = double(templatesCom);
        templatesInxCom = readNPY(['C:\data\',filenameSplit,'\spike_templates.npy']); templatesInxCom = double(templatesInxCom);
        templates = templatesCom;
        
        tBegin = 0;
        for ii = 1:length(filenameCom)
            cd([savepath(1:strfind(savepath, 'LA')+1),'\',cellname(1:strfind(cellname, 'r')),num2str(ii),'\']);
            % find the time range of every task
            load([cellname(1:strfind(cellname, 'r')),num2str(ii),'_fs.mat']); % 'SPK_fs', unit in Hz
            load([cellname(1:strfind(cellname, 'r')),num2str(ii),'_TimeDuration.mat']); % 'SPK_dur', unit in s
            SPK_dur = SPK_dur*SPK_fs;
            tEnd = tBegin+SPK_dur;
            tBeginInx = find(timeCom>tBegin); tBeginInx = tBeginInx(1);
            tEndInx = find(timeCom<tEnd); tEndInx = tEndInx(end);
            clusters = clustersCom(tBeginInx:tEndInx);
            time = timeCom(tBeginInx:tEndInx) - tBegin;
            templatesInx = templatesInxCom(tBeginInx:tEndInx);
            save([cellname(1:strfind(cellname, 'r')),num2str(ii),'_clusters.mat'],'clusters','time','templates','templatesInx');
            tBegin = tEnd;
        end
        
        disp(['Cluster files have splitted into ', num2str(length(filenameCom)), ' files, and saved in .mat in respective folder!']);
        
end

end