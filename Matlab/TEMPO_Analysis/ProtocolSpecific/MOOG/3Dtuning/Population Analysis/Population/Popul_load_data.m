% population analysis
% Protocol: 1->translation, 2-> rotation, 3->dark T, 4->dark R
% LBY 20170612
% LBY 20171123

function Popul_load_data(Monkey,FnameCode,Protocol,Model_catg)

%% load data

tic;
% clear all;

global PSTH;

%{
FnameCode = 2;
% Protocol: 1->translation, 2-> rotation, 3->dark T, 4->dark R
Protocol = 2;
% Model_catg: 1-> Sync model 2-> Out-sync model
Model_catg = 2;
%}

switch FnameCode
    case 1 % choose files mannully
        [filename pathname] = uigetfile('Z:\Data\TEMPO\BATCH');
        
    case 2 % load all mat files from interested folder
        pathname = {['Z:\Data\TEMPO\BATCH\',Monkey,'\',Model_catg];['Z:\Data\TEMPO\BATCH\',Monkey,'\',Model_catg];['Z:\Data\TEMPO\BATCH\',Monkey,'_Dark\',Model_catg];['Z:\Data\TEMPO\BATCH\',Monkey,'_Dark\',Model_catg]};
        
        switch Protocol
            case {1 3}
                cd(pathname{Protocol});
                disp('Load PSTH T data...');
                filename = dir([pathname{Protocol},'\*PSTH_T*.mat']);
                for ii = 1:length(filename)
                    % load PSTH data
                    temp = load([pathname{Protocol} '\' filename(ii).name]);
                    Tuning3D_T(ii).name = str2double((filename(ii).name(4:6)));
                    Tuning3D_T(ii).ch = temp.result.SpikeChan;
                    Tuning3D_T(ii).stimType = temp.result.unique_stimType;
                    Tuning3D_T(ii).duration = temp.result.unique_duration;
                    Tuning3D_T(ii).meanSpon = temp.result.meanSpon;
                    Tuning3D_T(ii).DDI = temp.result.DDI;
                    Tuning3D_T(ii).nBins = temp.result.nBins;
                    Tuning3D_T(ii).ANOVA = temp.result.p_anova_dire;
                    Tuning3D_T(ii).preDir = temp.result.preferDire;
                    Tuning3D_T(ii).responSig = temp.result.PSTH.respon_sigTrue;
                    Tuning3D_T(ii).localPeak = temp.result.PSTH.localPeak;
                    Tuning3D_T(ii).localTrough = temp.result.PSTH.localTrough;
                    Tuning3D_T(ii).localTrough = temp.result.PSTH.localTrough;
                    Tuning3D_T(ii).maxFR = temp.result.PSTH.maxSpkRealBinMean;
                    Tuning3D_T(ii).minFR = temp.result.PSTH.minSpkRealBinMean;
                    Tuning3D_T(ii).PSTH = temp.result.PSTH.spk_data_bin_mean_rate_aov; % mean PSTH
                    Tuning3D_T(ii).PSTH3Dmodel = temp.result.PSTH3Dmodel;
                    Tuning3D_T(ii).peakDS = temp.result.PSTH.peak_DS;
                    Tuning3D_T(ii).NoDSPeaks = temp.result.PSTH.NoDSPeaks;
                end
                disp('T DATA LOADED!');
            case {2 4}
                cd(pathname{Protocol});
                disp('Load PSTH R data...');
                filename = dir([pathname{Protocol},'\*PSTH_R*.mat']);
                for ii = 1:length(filename)
                    % load PSTH data
                    temp = load([pathname{Protocol} '\' filename(ii).name]);
                    Tuning3D_R(ii).name = str2double(filename(ii).name(4:6));
                    Tuning3D_R(ii).ch = temp.result.SpikeChan;
                    Tuning3D_R(ii).stimType = temp.result.unique_stimType;
                    Tuning3D_R(ii).duration = temp.result.unique_duration;
                    Tuning3D_R(ii).meanSpon = temp.result.meanSpon;
                    Tuning3D_R(ii).DDI = temp.result.DDI;
                    Tuning3D_R(ii).nBins = temp.result.nBins;
                    Tuning3D_R(ii).ANOVA = temp.result.p_anova_dire;
                    Tuning3D_R(ii).preDir = temp.result.preferDire;
                    Tuning3D_R(ii).responSig = temp.result.PSTH.respon_sigTrue;
                    Tuning3D_R(ii).localPeak = temp.result.PSTH.localPeak;
                    Tuning3D_R(ii).localTrough = temp.result.PSTH.localTrough;
                    Tuning3D_R(ii).localTrough = temp.result.PSTH.localTrough;
                    Tuning3D_R(ii).maxFR = temp.result.PSTH.maxSpkRealBinMean;
                    Tuning3D_R(ii).minFR = temp.result.PSTH.minSpkRealBinMean;
                    Tuning3D_R(ii).PSTH = temp.result.PSTH.spk_data_bin_mean_rate_aov;
                    Tuning3D_R(ii).PSTH3Dmodel = temp.result.PSTH3Dmodel;
                    Tuning3D_R(ii).peakDS = temp.result.PSTH.peak_DS;
                    Tuning3D_R(ii).NoDSPeaks = temp.result.PSTH.NoDSPeaks;
                end
                disp('R DATA LOADED!');
        end
end

% save the data

switch Protocol
    case 1
        save(['Z:\Data\TEMPO\BATCH\',Monkey,'_3DTuning\',Model_catg,'\PSTH_OriData.mat'],'Tuning3D_T');
    case 2
        save(['Z:\Data\TEMPO\BATCH\',Monkey,'_3DTuning\',Model_catg,'\PSTH_OriData.mat'],'Tuning3D_R','-append');
    case 3
        save(['Z:\Data\TEMPO\BATCH\',Monkey,'_3DTuning\',Model_catg,'_Dark\PSTH_OriData_Dark.mat'],'Tuning3D_T');
    case 4
        save(['Z:\Data\TEMPO\BATCH\',Monkey,'_3DTuning\',Model_catg,'_Dark\PSTH_OriData_Dark.mat'],'Tuning3D_R','-append');
end

disp('DATA SAVED!');

toc;
end
