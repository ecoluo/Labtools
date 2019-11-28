% Catenate *.mat files converted from alpha-omega *.mpx files (limited by 1G) together
% These .mat files were converted by Mapfile
% LBY 20191122

function mergeAO(action)

global ori_data output;
chName = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016',...
    '017','018','019','020','021','022','023','024','025','026','027','028','029','030','031','032',...
    '033','034','035','036','037','038','039','040','041','042','043','044','045','046','047','048',...
    '049','050','051','052','053','054','055','056','057','058','059','060','061','062','063','064'};

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
        for fs = 1:length(filename)
            ori_data{fs} = load([pathname '\' filename(fs).name]);
        end
        
        % Change file & path name
        set(FileHandle,'string',cellname); % Refresh the file name
        f = fopen('Z:\Labtools\Tools\MergeAO_LastFileName.txt','w'); % Save the file name to disk.
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
        
        output = [];
        delete('detection.txt','cluster.txt'); % if there're exsited before, delete them.
        disp('Merging files...');
        
        % Merge files
        for ch = 1:chN
            tempSPK = [];
            for fs = 1:length(filename)
                eval(['tempSPK = [tempSPK, ori_data{',num2str(fs),'}.CSPK_',chName{ch},'.Samples];']);
                % tempSPK = [tempSPK, ori_data{1}.CSPK_001.Samples];
            end
            
            eval(['tempSR = ori_data{1}.CSPK_',chName{ch},'.KHz * 1000;']);
            % tempSR = ori_data{1}.CSPK_001.KHz * 1000;
%             eval(['tempT = ori_data{1}.CSPK_',chName{ch},'.TimeEnd - ori_data{1}.CSPK_',chName{ch},'.TimeBegin;']);
            
            % save all infos into output ( for Wave_clus)
            output.spk{ch} = tempSPK; data = tempSPK; % spike data (voltage)
            output.sr{ch} = tempSR; sr = tempSR; % Sample rate, Hz
%             output.time{ch} = tempT;  % Total time, ms
            
            % save files (for wave_clus)
            save([savepath,'\',cellname, '_ch', chName{ch}, '.mat'],'data','sr');
            % m5c1665r1_ch001.mat
            
            % write filenames for spike detection and clustering
            fid = fopen('detection.txt','a');
            ss1 = [cellname, '_ch', chName{ch}, '.mat'];
            fprintf(fid,'%s\n',ss1);
            fclose(fid);

            fid = fopen('cluster.txt','a');
            ss2 = [cellname, '_ch', chName{ch}, '_spikes.mat'];
            fprintf(fid,'%s\n',ss2);
            fclose(fid);
            
        end
        %         showlist = ['All ',num2str(chN),' channels have been saved!'];
        %         set(infoHandle,'string',showlist); 不知道为什么这一句会报错？？？
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
        
    case 'save files'
        % save as different format for different spike sorting algorithms
        % 先挖個坑
end

end