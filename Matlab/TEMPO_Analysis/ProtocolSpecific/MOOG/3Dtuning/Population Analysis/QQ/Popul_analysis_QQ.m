% Population analysis
% 101# DDI distribution
% 102# preferred direction & diff between vesit&vis distribution
% 103# spontaneous FR distribution
% 104# peak time distribution 
% 105# FR according to peak time 
% 106# DDI distribution (in 1 figure)
% LBY 20171123

%% load data & pack data
clear all;
load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Sync model\PSTH_OriData.mat');
% load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\Out-sync model\PSTH_OriData.mat');
Monkey = 'QQ';


%%%%%%%%%%%%%%%%%%%%%%%%%% for Translation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cell_inx = 1:length(QQ_3DTuning_T)
    T(cell_inx).name = QQ_3DTuning_T(cell_inx).name;
    T(cell_inx).ch = QQ_3DTuning_T(cell_inx).ch;
    T(cell_inx).nBins = QQ_3DTuning_T(cell_inx).nBins;
    if ~isempty(find(QQ_3DTuning_T(cell_inx).stimType == 1))
        T(cell_inx).vestiANOVA = QQ_3DTuning_T(cell_inx).ANOVA(find(QQ_3DTuning_T(cell_inx).stimType == 1));
        T(cell_inx).vestiDDI = QQ_3DTuning_T(cell_inx).DDI(find(QQ_3DTuning_T(cell_inx).stimType == 1));
        T(cell_inx).vestiResponSig = QQ_3DTuning_T(cell_inx).responSig(find(QQ_3DTuning_T(cell_inx).stimType == 1));
        T(cell_inx).vestiPreDir = QQ_3DTuning_T(cell_inx).preDir{find(QQ_3DTuning_T(cell_inx).stimType == 1)};
        T(cell_inx).vestiPeak = QQ_3DTuning_T(cell_inx).localPeak{find(QQ_3DTuning_T(cell_inx).stimType == 1)};
        T(cell_inx).vestiTrough = QQ_3DTuning_T(cell_inx).localTrough{find(QQ_3DTuning_T(cell_inx).stimType == 1)};
        T(cell_inx).vestiPSTH = nanmean(QQ_3DTuning_T(cell_inx).PSTH{find(QQ_3DTuning_T(cell_inx).stimType == 1)},1);
        T(cell_inx).vestipeakDS = QQ_3DTuning_T(cell_inx).peakDS{find(QQ_3DTuning_T(cell_inx).stimType == 1)};
        T(cell_inx).vestiNoDSPeaks = QQ_3DTuning_T(cell_inx).NoDSPeaks(find(QQ_3DTuning_T(cell_inx).stimType == 1));
    else
        T(cell_inx).vestiANOVA = nan;
        T(cell_inx).vestiDDI = nan;
        T(cell_inx).vestiResponSig = nan;
        T(cell_inx).vestiPreDir = nan*ones(1,3);
        T(cell_inx).vestiPeak = nan;
        T(cell_inx).vestiTrough = nan;
        T(cell_inx).vestiPSTH = nan*ones(1,T(cell_inx).nBins);
        T(cell_inx).vestipeakDS = nan;
        T(cell_inx).vestiNoDSPeaks = nan;
    end
    if ~isempty(find(QQ_3DTuning_T(cell_inx).stimType == 2))
        T(cell_inx).visANOVA = QQ_3DTuning_T(cell_inx).ANOVA(find(QQ_3DTuning_T(cell_inx).stimType == 2));
        T(cell_inx).visDDI = QQ_3DTuning_T(cell_inx).DDI(find(QQ_3DTuning_T(cell_inx).stimType == 2));
        T(cell_inx).visResponSig = QQ_3DTuning_T(cell_inx).responSig(find(QQ_3DTuning_T(cell_inx).stimType == 2));
        T(cell_inx).visPreDir = QQ_3DTuning_T(cell_inx).preDir{find(QQ_3DTuning_T(cell_inx).stimType == 2)};
        T(cell_inx).visPeak = QQ_3DTuning_T(cell_inx).localPeak{find(QQ_3DTuning_T(cell_inx).stimType == 2)};
        T(cell_inx).visTrough = QQ_3DTuning_T(cell_inx).localTrough{find(QQ_3DTuning_T(cell_inx).stimType == 2)};
        T(cell_inx).visPSTH = nanmean(QQ_3DTuning_T(cell_inx).PSTH{find(QQ_3DTuning_T(cell_inx).stimType == 2)},1);
        T(cell_inx).vispeakDS = QQ_3DTuning_T(cell_inx).peakDS{find(QQ_3DTuning_T(cell_inx).stimType == 2)};
        T(cell_inx).visNoDSPeaks = QQ_3DTuning_T(cell_inx).NoDSPeaks(find(QQ_3DTuning_T(cell_inx).stimType == 2));
    else
        T(cell_inx).visANOVA = nan;
        T(cell_inx).visDDI = nan;
        T(cell_inx).visResponSig = nan;
        T(cell_inx).visPreDir = nan*ones(1,3);
        T(cell_inx).visPeak = nan;
        T(cell_inx).visTrough = nan;
        T(cell_inx).visPSTH = nan*ones(1,T(cell_inx).nBins);
        T(cell_inx).vispeakDS = nan;
        T(cell_inx).visNoDSPeaks =  nan;
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for Rotation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cell_inx = 1:length(QQ_3DTuning_R)
    R(cell_inx).name = QQ_3DTuning_R(cell_inx).name;
    R(cell_inx).ch = QQ_3DTuning_R(cell_inx).ch;
    R(cell_inx).nBins = QQ_3DTuning_R(cell_inx).nBins;
    if ~isempty(find(QQ_3DTuning_R(cell_inx).stimType == 1))
        R(cell_inx).vestiANOVA = QQ_3DTuning_R(cell_inx).ANOVA(find(QQ_3DTuning_R(cell_inx).stimType == 1));
        R(cell_inx).vestiDDI = QQ_3DTuning_R(cell_inx).DDI(find(QQ_3DTuning_R(cell_inx).stimType == 1));
        R(cell_inx).vestiResponSig = QQ_3DTuning_R(cell_inx).responSig(find(QQ_3DTuning_R(cell_inx).stimType == 1));
        R(cell_inx).vestiPreDir = QQ_3DTuning_R(cell_inx).preDir{find(QQ_3DTuning_R(cell_inx).stimType == 1)};
        R(cell_inx).vestiPeak = QQ_3DTuning_R(cell_inx).localPeak{find(QQ_3DTuning_R(cell_inx).stimType == 1)};
        R(cell_inx).vestiTrough = QQ_3DTuning_R(cell_inx).localTrough{find(QQ_3DTuning_R(cell_inx).stimType == 1)};
        R(cell_inx).vestiPSTH = nanmean(QQ_3DTuning_R(cell_inx).PSTH{find(QQ_3DTuning_R(cell_inx).stimType == 1)},1);
        R(cell_inx).vestipeakDS = QQ_3DTuning_R(cell_inx).peakDS{find(QQ_3DTuning_R(cell_inx).stimType == 1)};
        R(cell_inx).vestiNoDSPeaks = QQ_3DTuning_R(cell_inx).NoDSPeaks(find(QQ_3DTuning_R(cell_inx).stimType == 1));
    else
        R(cell_inx).vestiANOVA = nan;
        R(cell_inx).vestiDDI = nan;
        R(cell_inx).vestiResponSig = nan;
        R(cell_inx).vestiPreDir = nan*ones(1,3);
        R(cell_inx).vestiPeak = nan;
        R(cell_inx).vestiTrough = nan;
        R(cell_inx).vestiPSTH = nan*ones(1,R(cell_inx).nBins);
        R(cell_inx).vestipeakDS = nan;
        R(cell_inx).vestiNoDSPeaks = nan;
    end
    if ~isempty(find(QQ_3DTuning_R(cell_inx).stimType == 2))
        R(cell_inx).visANOVA = QQ_3DTuning_R(cell_inx).ANOVA(find(QQ_3DTuning_R(cell_inx).stimType == 2));
        R(cell_inx).visDDI = QQ_3DTuning_R(cell_inx).DDI(find(QQ_3DTuning_R(cell_inx).stimType == 2));
        R(cell_inx).visResponSig = QQ_3DTuning_R(cell_inx).responSig(find(QQ_3DTuning_R(cell_inx).stimType == 2));
        R(cell_inx).visPreDir = QQ_3DTuning_R(cell_inx).preDir{find(QQ_3DTuning_R(cell_inx).stimType == 2)};
        R(cell_inx).visPeak = QQ_3DTuning_R(cell_inx).localPeak{find(QQ_3DTuning_R(cell_inx).stimType == 2)};
        R(cell_inx).visTrough = QQ_3DTuning_R(cell_inx).localTrough{find(QQ_3DTuning_R(cell_inx).stimType == 2)};
        R(cell_inx).visPSTH = nanmean(QQ_3DTuning_R(cell_inx).PSTH{find(QQ_3DTuning_R(cell_inx).stimType == 2)},1);
        R(cell_inx).vispeakDS = QQ_3DTuning_R(cell_inx).peakDS{find(QQ_3DTuning_R(cell_inx).stimType == 2)};
        R(cell_inx).visNoDSPeaks = QQ_3DTuning_R(cell_inx).NoDSPeaks(find(QQ_3DTuning_R(cell_inx).stimType == 2));
    else
        R(cell_inx).visANOVA = nan;
        R(cell_inx).visDDI = nan;
        R(cell_inx).visResponSig = nan;
        R(cell_inx).visPreDir = nan*ones(1,3);
        R(cell_inx).visPeak = nan;
        R(cell_inx).visTrough = nan;
        R(cell_inx).visPSTH = nan*ones(1,R(cell_inx).nBins);
        R(cell_inx).vispeakDS = nan;
        R(cell_inx).visNoDSPeaks =  nan;
    end
    
    
end

%% Analysis

%%%%%%%%%%%%%%%%%%%%%%%%%   classify cells   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pack data
T_vestiDDI = cat(1,T.vestiDDI);
T_visDDI = cat(1,T.visDDI);
T_vestiANOVA = cat(1,T.vestiANOVA);
T_visANOVA = cat(1,T.visANOVA);
T_vestiResponSig = cat(1,T.vestiResponSig);
T_visResponSig = cat(1,T.visResponSig);
T_vestiPreDir = reshape(cat(2,T.vestiPreDir),3,[])';
T_visPreDir = reshape(cat(2,T.visPreDir),3,[])';
T_vestiPSTH = cat(1,T.vestiPSTH);
T_visPSTH = cat(1,T.visPSTH);
R_vestiDDI = cat(1,R.vestiDDI);
R_visDDI = cat(1,R.visDDI);
R_vestiANOVA = cat(1,R.vestiANOVA);
R_visANOVA = cat(1,R.visANOVA);
R_vestiResponSig = cat(1,R.vestiResponSig);
R_visResponSig = cat(1,R.visResponSig);
R_vestiPreDir = reshape(cat(2,R.vestiPreDir),3,[])';
R_visPreDir = reshape(cat(2,R.visPreDir),3,[])';
R_vestiPSTH = cat(1,R.vestiPSTH);
R_visPSTH = cat(1,R.visPSTH);

% cells classified according to temporal response
TResponSigboth = logical(T_vestiResponSig==1)&logical(T_visResponSig==1);
TResponSigVesti = logical(T_vestiResponSig==1);
TResponSigVis = logical(T_visResponSig==1);
RResponSigboth = logical(R_vestiResponSig==1)&logical(R_visResponSig==1);
RResponSigVesti = logical(R_vestiResponSig==1);
RResponSigVis = logical(R_visResponSig==1);

% cells classified according to ANOVA
TANOVASigboth = logical(T_vestiANOVA<0.05)&logical(T_visANOVA<0.05)&TResponSigboth;
TANOVASigVesti = logical(T_vestiANOVA<0.05)&TResponSigVesti;
TANOVASigVis = logical(T_visANOVA<0.05)&TResponSigVis;
RANOVASigboth = logical(R_vestiANOVA<0.05)&logical(R_visANOVA<0.05)&RResponSigboth;
RANOVASigVesti = logical(R_vestiANOVA<0.05)&RResponSigVesti;
RANOVASigVis = logical(R_visANOVA<0.05)&RResponSigVis;

TResponSigbothNo = sum(TResponSigboth);
TResponSigVestiNo = sum(TResponSigVesti);
TResponSigVisNo = sum(TResponSigVis);
RResponSigbothNo = sum(RResponSigboth);
RResponSigVestiNo = sum(RResponSigVesti);
RResponSigVisNo = sum(RResponSigVis);

TANOVASigbothNo = sum(TANOVASigboth);
TANOVASigVestiNo = sum(TANOVASigVesti);
TANOVASigVisNo = sum(TANOVASigVis);
RANOVASigbothNo = sum(RANOVASigboth);
RANOVASigVestiNo = sum(RANOVASigVesti);
RANOVASigVisNo = sum(RANOVASigVis);


colorDefsLBY;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%   now, analysis   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

TemporalRespon_QQ; % show temporal tuning for all cells (T+R)
% meanFR; % show mean FR for all cells
% DDI; % plot DDI distribution figures
% DDI_N; % plot DDI distribution in one figure
% PreferDirec; % plot preferred direction distribution figures
% Peak;  % peak time distributions & PSTH according to peak time
