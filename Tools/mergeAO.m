% Catenate *.mat files converted from alpha-omega *.mpx files (limited by 1G) together
% converted by Mapfile
% LBY 20191122

function fig = mergeAO(action)

global ori_data output;
chName = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016',...
    '017','018','019','020','021','022','023','024','025','026','027','028','029','030','031','032'};

PathHandle = findobj(gcbf, 'Tag', 'Pathname');pathname = get(PathHandle,'string');
SaveHandle = findobj(gcbf, 'Tag', 'SavePath');savepath = get(SaveHandle,'string');
FileHandle = findobj(gcbf, 'Tag', 'Filename');cellname = pathname(end-8:end);
ChHandle = findobj(gcbf, 'Tag', 'channel number');chN = str2num(get(ChHandle,'string')); % the number of channels
infoHandle = findall(gcbf,'tag','InfoShowPanel');

cd(pathname);
% cellname = get(FileHandle,'string');
filename = dir([pathname,'\*-*.mat']);

switch (action)
    case 'load data'
        showlist = [];set(infoHandle,'string',showlist);
        showlist{1} = ['Loading spike data of ', cellname, '...'];
        showlist{2} = ['There are ', num2str(length(filename)), 'files in total.'];
        showlist{3} = 'All data have been loaded!';
        
        ori_data  =[];
        for fs = 1:length(filename)
            % load spike data
            ori_data{fs} = load([pathname '\' filename(fs).name]);
        end
        
        set(infoHandle,'string',showlist);
        
    case 'merge files'
        output = [];
        disp('Merging files...');showlist = [];set(infoHandle,'string',showlist);
        for ch = 1:chN
            tempSPK = [];
            for fs = 1:length(filename)
                
                eval(['tempSPK = [tempSPK, ori_data{',num2str(fs),'}.CSPK_',chName{ch},'.Samples];']);
                % tempSPK = [tempSPK, ori_data{1}.CSPK_001.Samples];
                
            end
            
            eval(['tempSR = ori_data{1}.CSPK_',chName{ch},'.KHz * 1000;']);
            % tempSR = ori_data{1}.CSPK_001.KHz * 1000;
            eval(['tempT = ori_data{1}.CSPK_',chName{ch},'.TimeEnd - ori_data{1}.CSPK_',chName{ch},'.TimeBegin;']);
            
            % save all infos into output
            output.spk{ch} = tempSPK; data = tempSPK; % spike data (voltage)
            output.sr{ch} = tempSR; sr = tempSR; % Sample rate, Hz
            output.time{ch} = tempT;  % Total time, ms
            
            % save files (for wave_clus)
            save([savepath,'\',cellname, '_ch', chName{ch}, '.mat'],'data','sr');
            % m5c1665r1_ch001.mat
            
        end
        %         showlist = ['All ',num2str(chN),' channels have been saved!'];
        %         set(infoHandle,'string',showlist); 不知道为什么这一句会报错？？？
        disp(['All ',num2str(chN),' channels have been saved!']);
        
    case 'show info'
        % show basic informations about the data
        infoshowlist{1} = ['Session: ',cellname, ' ', num2str(length(filename)), ' files in total.'];
        infoshowlist{2} = ['Sampling rate: Hz ', num2str(cell2mat(output.sr))];
        infoshowlist{3} = ['Total time: ',num2str(output.time{1}), ' ms'];
        %         infoshowlist{4} = nan;
        set(infoHandle,'string',infoshowlist);
        
    case 'save files'
        % save as different format
end

end