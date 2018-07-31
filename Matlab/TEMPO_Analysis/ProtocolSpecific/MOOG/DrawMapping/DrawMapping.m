function DrawMapping(monkey_hemi)
% DrawMapping.m
% First version by HH @ Gu Lab 2013
% Modified by LBY 2016-

monkey_hemis = {'Qiaoqiao_L','Qiaoqiao_R','Polo_L','Polo_R','Polo_L_HH','Polo_R_HH'};
colorDefsLBY; % added by LBY 20161216

if nargin == 0
    monkey_hemi = 2;
end


%% Parameters
clc; clear global
global maxX maxY maxZ movDis GMTypes data;
global hemisphere monkey; global gridRange;
global MRI_path MRI_offset AP0;
global linWid start_end_markers overlapping Qiaoqiao_right_AP0 Polo_right_AP0;

linWid = 1.3; % linewidth for rectangles indicating mapping area
% following: area & unit overlapping in coronal planes
overlapping = [-1 1; -10 10]; start_end_markers = false; % First row for area annotation; second for unit annotation
% overlapping = [0 0; 0 0]; start_end_markers = 1; % First row for area annotation; second for unit annotation

maxX = 30; % Grid size
maxY = 30;
maxZ = 250;   % Drawing range (in 100 um)
movDis = 150; % Maximum travel distance of the microdriver (in 100 um)

V = ones(30,25,maxZ + 30,3);  % Matrix to be rendered. The z-resolution = 100 um.
Qiaoqiao_right_AP0 = 14; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918
Polo_right_AP0 = 14; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918

%% Define our area types here
GMTypes = { % 'Type', ColorCode (RGB);
    'GM',[0.3 0.3 0.3];    % Gray matter without visual modulation
    'WM',[1 1 1];          
    'PCC',[0.2 0.8 0.2];
    'IPS',[1 0.6 0];
    'RSC',[0.8 0.2 0.2];
    'B3a',[0.1 0.4 0.75]; % 3a
    'LIP',[0 1 0];
    'VIP',[1 1 0];
    'MST',[0 0 1];
    'MT',[0.8 0 0];
    'MIP',[0.6 0.6 0.6];  % [0 0.6 0]
    'AUD',[1 0 1];
    };
for i = 1:length(GMTypes)
    eval([GMTypes{i,1} '= -' num2str(i) ';']);  % This is a trick.
end

%% Input our mapping data here

switch monkey_hemis{monkey_hemi}
    %%%%%%%%%%%%%%%%%%%% LBY 20161215 for Qiaoqiao %%%%%%%%%%%%%%%%%%%%%%%%
    case 'Qiaoqiao_R'
        
        %  Qiaoqiao_right
        % %{
        
        % Header
        toPlotTypes3D = [GM PCC RSC IPS B3a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [GM PCC RSC IPS B3a];    % Which area types do we want to plot ?
        gridRange = [15 31; 0 16];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        monkey = 6;
        hemisphere = 2;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            % 0 is the hole without recording
            {0,[20,5],[1.8 0],[B3a 8 40; B3a 42.5 44;]}; %20161130
            {0,[21,6],[1.8 0],[GM 15.24 20;]}; %20161130
            {0,[22,8],[2.0 0],[B3a 19 36; ]}; % 20161208
            {0,[23,8],[2.0 0],[B3a 13.17 42;]}; % 20161209
            {0,[24,8],[2.0 0],[B3a 15.24 20;]};%20161212
            {0,[25,4],[1.9 0],[GM 0 24;GM 26.5 34.5;]};%20161212
            {0,[22,10],[2.0 0],[B3a 24.22 62.86; ]};% 20161219
            {0,[23,10],[2.05 0],[B3a 14 77.5;]};% 20161219
            {0,[23,4],[2.0 0],[B3a 9.28 23.96;]};% 20161222
            {0,[26,8],[1.8 0],[GM 0 35.3;]};% 20170113
            %             {0,[23,7],[2 0],[GM 53 80;GM 84 93;GM 116 140;]};% 20170117
            %             {0,[21,7],[1.9 0],[GM 15 49;GM 53 90;GM 110 122;]};% 20170118
            {0,[21,4],[1.9 0],[GM 0 21;B3a 49 66;PCC 73 87;]};% 20170210
            {0,[21,5],[1.8 0],[GM 3 17;B3a 47 65;PCC 73 88;PCC 106.8 120;]};% 20170210
            {0,[21,6],[1.8 0],[B3a 27 61;PCC 100 109;PCC 126.6 137;]};% 20170213
            {0,[23,4],[1.8 0],[PCC 80 96;RSC 160 167;]};% 20170228
            {0,[23,8],[2 0],[B3a 19 66;PCC 75 146.6;]};% 20170228
            {0,[24,5],[1.8 0],[B3a 33 80;PCC 113 143;]};% 20170228
            {0,[19,5],[1.8 0],[PCC 80 104;PCC 113 131;]};% 20170306
            %             {0,[21,8],[1.8 0],[GM 0 0;]};% 20170307
            %             {0,[19,8],[1.8 0],[GM 0 0;]};% 20170307
            {0,[20,6],[2.0 0],[B3a 16 50;PCC 65 90;]};% 20170615
            {0,[21,5],[2.3 0],[PCC 47 79;PCC 93 111.5;]};% 20170616
            {0,[21,4],[2.3 0],[GM 7 28;PCC 70.5 87;PCC 92 126;]};% 20170616
            {0,[20,4],[2.2 0],[B3a 0 50;]};% 20170619
            {0,[21,7],[2.2 0],[B3a 3 43;PCC 85 110;]};% 20170620
            {0,[22,6],[2.2 0],[PCC 75 92;PCC 98 110;]};% 20170620
            {0,[22,3],[2.2 0],[PCC 47 64;PCC 71 89;]};% 20170703
            %            {0,[23,4],[2.1 0],[PCC 68 110;]};% 20170705
            {0,[24,5],[2.1 0],[B3a 34 67;PCC 67 87;PCC 90 100;]};% 20170708
            {0,[24,6],[2.1 0],[B3a 2 28;PCC 71 100;]};% 20170708
            {0,[24,4],[2.1 0],[PCC 62 75;PCC 82.3 98.8;]};% 20170708
            {0,[20,4],[2.1 0],[PCC 65 78;PCC 85 95;]};% 20170720
            {0,[21,7],[2.15 0],[PCC 63 76;PCC 82 91;]};% 20170721
            {0,[25,6],[2.1 0],[GM 21 51;PCC 90 103;PCC 115 120;]};% 20170801
            
            
            
            % 161130-170313
            %             {1,[21,5],[1.8 0],[GM 34 71.13;]};
            {2,[21,4],[1.75 0],[GM 0 4.5;]};
            %             {3,[22,6],[2.0 0],[GM 7 31; GM 33 40;GM 42 52.57]};
            {4,[21,3],[2.0 0],[B3a 18 35; PCC 65 90;]};
            %             {5,[22,4],[2.0 0],[GM 0 35; GM 43 52;GM 62 86;GM 92.69 109.5;]};
            {6,[23,6],[2.0 0],[B3a 57.88 59.5; PCC 62 64.5;PCC 87 110]};
            {7,[24,6],[2.0 0],[B3a 5.82 56.5; PCC 80 85.6;PCC 89 89.3]};
            {8,[24,8],[2.0 0],[B3a 24.22 62.86;]};
            {8,[25,6],[2.0 0],[GM 8 21.6;]};
            {9,[25,8],[2.0 0],[GM 6 24; GM 46.8 64;]};
            {10,[20,6],[1.9 0],[B3a 0 39.77; B3a 49 53; GM 59 60; PCC 75.8 113;]};
            {11,[20,10],[2.0 0],[B3a 16 54; PCC 90 97;]};
            {12,[26,6],[2.0 0],[GM 15 45;]};
            {13,[26,4],[1.9 0],[GM 0 23;GM 36.22 40;PCC 63.55 72.13;]};
            {14,[20,2],[2.0 0],[GM 19.65 40;PCC 47 52.55;]};
            {15,[19,6],[2.0 0],[B3a 10 21.54;B3a 26.3 39.63;PCC 44 64.31;]};
            {16,[18,6],[2.0 0],[PCC 41.98 65;]};
            {17,[17,6],[2.0 0],[PCC 27.47 39;PCC 50.38 58.69;]};
            {18,[16,6],[2.0 0],[PCC 33.5 36.71;]};
            {19,[19,3],[2.0 0],[B3a 11.65 36;]};
            {20,[18,2],[2.0 0],[GM 16.53 53.79;]};
            {21,[17,2],[1.8 0],[PCC 69.58 74.25;]};
            {22,[25,10],[1.8 0],[GM 65 112.9;]};
            {23,[22,2],[1.75 0],[GM 37.5 97.8;]};
            {24,[20,4],[1.9 0],[B3a 12 48;]};
            {25,[20,3],[1.9 0],[B3a 14 60;PCC 60 130;]};
            {26,[20,7],[1.9 0],[B3a 13 31;PCC 60 79;]};
            {27,[21,7],[1.8 0],[B3a 30 45;PCC 105 127;]};
            {28,[22,3],[1.8 0],[B3a 17.7 41;PCC 72 92;PCC 100 120;RSC 135.4 150;]};
            {29,[22,5],[1.8 0],[B3a 42 63;PCC 100 116.5;]};
            {30,[22,4],[1.9 0],[B3a 15 61;PCC 89 112.6;PCC 121.3 136;]};
            {31,[22,6],[1.8 0],[B3a 25 46;PCC 73 88;PCC 108 137;]};
            {32,[23,5],[1.9 0],[B3a 17 56.5;PCC 86 108;PCC 115 130;]};
            {33,[23,6],[1.8 0],[B3a 20 45;PCC 111 135;]};
            {34,[23,7],[1.9 0],[B3a 47 63.6;PCC 122 147.3;]};
            {35,[24,4],[1.8 0],[PCC 92 115;PCC 124 141;]};
            {35,[24,3],[1.8 0],[PCC 85 100;]};
            {36,[19,4],[1.8 0],[PCC 69 90;]};
            {37,[19,7],[1.75 0],[PCC 84 127;]};
            {38,[21,2],[1.8 0],[PCC 72.7 90;PCC 96 110;RSC 138.5 153;]};
            {39,[24,6],[1.9 0],[B3a 53 65;PCC 100 122;]};
            {39,[22,1],[1.8 0],[GM 15 34;GM 55.5 65;GM 72 75;RSC 115 150; RSC 150 170;]};
            
            % 170615-170801
            {40,[20,1],[2.05 0],[PCC 43 64;PCC 70 87;RSC 110 148;]};
            {45,[21,6],[2.3 0],[PCC 18 50;PCC 82 94;RSC 97 134;]};
            {46,[21,4],[2.3 0],[B3a 7 28;PCC 70.5 87;RSC 92 126;]};
            {47,[20,5],[2.2 0],[B3a 21 50;PCC 82 90;PCC 91.5 95.5;]};
            {48,[22,4],[2.2 0],[PCC 65 76;PCC 82 94;]};
            {49,[22,5],[2.2 0],[B3a 20 40;PCC 73 110;]};
            {50,[22,7],[2.2 0],[B3a 3 20;B3a 29 43;PCC 79 93;PCC 98 103.5;]};
            {51,[23,5],[2.1 0],[B3a 25 36;PCC 73 90;PCC 99 112;]};
            {51,[23,6],[2.1 0],[B3a 12 48;PCC 85 110;]};
            {52,[23,7],[2.1 0],[B3a 3.5 20;B3a 38 48;PCC 91 125.6;]};
            {53,[24,3],[2.1 0],[GM 3.7 21;PCC 66 110;]};
            {54,[19,5],[2.1 0],[PCC 47 68;]};
            {55,[19,6],[2.1 0],[PCC 61 80;]};
            {56,[19,7],[2.1 0],[PCC 62 78;PCC 84 94;]};
            {56,[19,4],[2.1 0],[B3a 16 26;PCC 63 68;]};
            {57,[20,5],[2.1 0],[B3a 6 19;PCC 73 86;PCC 91 102;]};
            {58,[20,6],[2.1 0],[PCC 66.6 76;PCC 86 98;]};
            {59,[20,7],[2.1 0],[B3a 4.5 13;PCC 67 105;]};
            {60,[21,5],[2.1 0],[PCC 65 79;PCC 84 96;]};
            {61,[21,8],[2.15 0],[B3a 13.5 26.5;PCC 65 80;PCC 86 96;]};
            {62,[23,6],[2.1 0],[B3a 9 23;PCC 60 65;]};
            {63,[23,7],[2.1 0],[B3a 41 54;PCC 95 105;PCC 114 119;]};
            {64,[23,4],[2.1 0],[PCC 83 110;]};
            {64,[24,6],[2.1 0],[B3a 9 38;PCC 80 93;PCC 97.7 110;]};
            {65,[24,7],[2.1 0],[B3a 10 25;PCC 76 91;PCC 97 110;]};
            {66,[25,5],[2.1 0],[GM 12 25;PCC 85 99;PCC 108 118;]};
            {67,[25,4],[2.1 0],[GM 9 15;PCC 75 88;PCC 93 108;]};
            
            
            
            %             % the electrode is bend at 3000-5000 um in depth
            %             % the 1st value is the depth electrode bend
            %             {3.6,[22,8],[2 0],[GM 19 36; ]}; %20161208
            %             {3.5,[25,4],[1.9 0],[GM 0 24;GM 26.5 34.5;]}; %20161215
            %             {3.4,[20,6],[1.9 0],[GM 0 39.77; GM 49 53; GM 59 60; GM 75.8 113;]}; %20161215
            %             {1.1,[22,10],[2 0],[GM 24.22 62.86;]}; %20161219
            %             {4.3,[23,10],[2.05 0],[GM 14 77.5;]}; %20161219
            %             {2.5,[23,4],[2 0],[GM 9.28 23.96;]}; %20161222
            %             {4.8,[26,6],[2 0],[GM 15 45;]}; %20161222
            %             {3.6,[19,3],[2.0 0],[GM 11.65 36;]}; %20170109
            %             {3.5,[26,8],[1.8 0],[GM 0 35.3;]}; %20170113
            %             {4.5,[25,10],[1.8 0],[GM 65 112.9;]}; %20170113
            
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\Qiaoqiao\Mapping\MRI\QiaoqiaoOutput\forDrawMapping\';
        MRI_offset = {[-93 93]-0.2,[-455 615], [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        
    case 'Qiaoqiao_L'
        
        %  Qiaoqiao_left
        % %{
        
        % Header
        toPlotTypes3D = [GM PCC RSC IPS B3a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [GM PCC RSC IPS B3a];    % Which area types do we want to plot ?
        gridRange = [10 26; 0 16];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        monkey = 6;
        hemisphere = 1;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            % 0 is the hole without recording
            %             {0,[20,3],[1.8 0],[GM 48 54;PCC 60 106;RSC 115 146.6;]};% 20170316
            %             {0,[20,7],[2.0 0],[GM 12 40;PCC 67 80;PCC 100 121;]};% 20170316
            %             {0,[21,6],[2.0 0],[GM 37 52;PCC 79 97;PCC 100 117;]};% 20170321
            %             {0,[19,5],[2.0 0],[GM 21 45;PCC 70 90;RSC 120 141;]};% 20170322
            {0,[20,6],[2.3 0],[B3a 13 53;PCC 74 87;]};% 20170825
            {0,[19,6],[2.25 0],[B3a 0 12;PCC 58 73;PCC 82 94;]};% 20170828
            {0,[18,8],[2.4 0],[GM 34 50;]};% 20170830
            {0,[19,5],[2.3 0],[B3a 7 20;PCC 56 69;PCC 77 90;]}; % 20170831
            {0,[16,3],[2.4 0],[GM 6 12;PCC 32 47;PCC 55 68;]}; % 20170913
            {0,[17,9],[2.5 0],[GM 10 31;PCC 38 44;PCC 52 65;]}; % 20171025
            {0,[16,11],[2.55 0],[GM 6 33;IPS 76 95;]}; % 20171103
            {0,[14,7],[2.4 0],[PCC 21 37;PCC 48 71;]}; % 20171103
            {0,[17,10],[2.55 0],[GM 12 23;PCC 23 33;]}; % 20171106
            {0,[18,10],[2.55 0],[GM 10 40;]}; % 20171106
            {0,[13,6],[2.55 0],[PCC 5 10;PCC 20 30;]}; % 20171108
            {0,[19,8],[2.65 0],[PCC 24 33;]}; % 20171108
            {0,[22,7],[2.55 0],[B3a 20 46;PCC 70 79;PCC 81 95;]}; % 20171109
            {0,[23,6],[2.55 0],[B3a 15 23;B3a 35 41;PCC 68 90;]}; % 20171109
            
            % 170314-170320
            %             {41,[20,5],[1.8 0],[GM 33 38;GM 47.5 68.4;PCC 98 101.2;]};
            %             {42,[20,4],[2.0 0],[GM 30 36;PCC 54 71.5;PCC 74 88;RSC 107 117;]};
            %             {43,[21,5],[2.05 0],[GM 25 45;PCC 70 88;PCC 93.3 112;RSC 140 149;]};
            %             {44,[21,4],[2.0 0],[GM 13 20;GM 55 69;PCC 75 83.5;RSC 132 149.5;]};
            
            % 170823-
            {68,[15,6],[2.5 0],[PCC 26.4 33;PCC 47 57;]};
            {69,[15,4],[2.25 0],[PCC 48 59;PCC 66 85;]};
            {69,[16,5],[2.5 0],[PCC 26 60;]};
            {70,[21,6],[2.2 0],[PCC 50 61;PCC 86 108;]};
            {71,[18,6],[2.3 0],[PCC 51 61;PCC 72.5 88;]};
            {72,[17,4],[2.3 0],[PCC 50 60;PCC 65 75;]};
            {72,[18,4],[2.3 0],[PCC 48.5 60;PCC 70 82;]};
            {73,[19,4],[2.3 0],[PCC 50 83;]};
            {73,[20,4],[2.3 0],[B3a 11 40;PCC 68 80;PCC 90 100;]};
            {74,[17,5],[2.3 0],[GM 22 30;PCC 61 78;PCC 85 90;]};
            {75,[18,5],[2.4 0],[PCC 56 70;PCC 82 90;]};
            {76,[17,3],[2.3 0],[PCC 48 61;PCC 68.6 76.3;]};
            {77,[18,3],[2.3 0],[GM 10.7 20;PCC 54 65;PCC 72 83;]};
            {78,[16,4],[2.4 0],[PCC 38 48;PCC 62 75;]};
            {79,[18,7],[2.4 0],[PCC 47 54;PCC 68 78;]};
            {80,[15,5],[2.4 0],[GM 11 27;PCC 41 51;PCC 59 68;]};
            {81,[16,7],[2.4 0],[GM 9 28;PCC 40 65;]};
            {82,[15,3],[2.4 0],[GM 10 27;PCC 38 72;]};
            {83,[15,7],[2.4 0],[GM 7.3 23;PCC 38 49;IPS 77 80;]};
            {83,[19,3],[2.4 0],[PCC 40 51;PCC 57 60;]};
            {84,[20,5],[2.3 0],[GM 0 23;B3a 32 43;PCC 73 86;]};
            {84,[17,2],[2.3 0],[PCC 42 53;PCC 63 71;]};
            {85,[20,3],[2.3 0],[PCC 47 68;]};
            {85,[16,2],[2.4 0],[PCC 20 49;PCC 53 61;]};
            {86,[18,2],[2.3 0],[PCC 52 62;PCC 65 73;]};
            {87,[16,8],[2.4 0],[GM 10 25;PCC 36 52;]};
            {88,[22,6],[2.3 0],[B3a 16 50;PCC 74 130;]};
            {89,[23,5],[2.4 0],[B3a 23 54;PCC 80 88;PCC 99 110;]};
            {89,[22,5],[2.4 0],[B3a 26 40;PCC 67.5 73;]};
            {90,[21,4],[2.4 0],[B3a 33 46;PCC 58 72;]};
            {91,[18,5],[2.4 0],[PCC 48 61;PCC 67 79;]};
            {91,[18,7],[2.5 0],[PCC 38 45;]};
            {93,[17,5],[2.4 0],[GM 10 25.5;PCC 33 50;RSC 95 135;]};
            {93,[17,3],[2.3 0],[GM 12.5 25;PCC 54 67;PCC 71.5 83;]};
            {94,[18,4],[2.4 0],[PCC 53 84;]};
            {94,[19,5],[2.4 0],[PCC 56 84;]};
            {95,[16,5],[2.4 0],[PCC 41 85;]};
            {96,[16,3],[2.5 0],[PCC 40 59;GM 63 86;]};
            {96,[17,6],[2.4 0],[PCC 52 53;]};
            {97,[18,8],[2.5 0],[GM 6 26;PCC 44 65;]};
            {97,[18,9],[2.5 0],[GM 8 13;GM 22 27;PCC 38 47;]};
            {98,[17,8],[2.5 0],[GM 15 24;PCC 32 60;]};
            {99,[15,8],[2.55 0],[GM 6 10;PCC 38 45;IPS 63 85;]};
            {99,[15,9],[2.55 0],[PCC 12 25;PCC 32 50;IPS 62 95;]};
            {100,[15,10],[2.55 0],[GM 0 8;IPS 59 68;IPS 76 87;]};
            {101,[16,9],[2.55 0],[GM 5 27;PCC 30 50;]};
            {101,[16,10],[2.55 0],[GM 0 16;PCC 30 35;]};
            {102,[15,11],[2.55 0],[IPS 52 72;IPS 78 85;]};
            {102,[14,6],[2.55 0],[PCC 5 11;PCC 34 51;]};
            {102,[14,8],[2.5 0],[PCC 29 53;]};
            {103,[14,5],[2.4 0],[PCC 12 25;PCC 36 39;]};
            {104,[14,4],[2.4 0],[PCC 20 31;PCC 45 48;PCC 70 80;]};
            {105,[19,5],[2.55 0],[PCC 49 73;]};
            {105,[19,7],[2.55 0],[PCC 55 73;]};
            {106,[19,10],[2.55 0],[GM 15 46;PCC 61 73;]};
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\Qiaoqiao\Mapping\MRI\QiaoqiaoOutput\forDrawMapping\';
        MRI_offset = {[-93 93]+1.5,[-455 615]+20, [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        
    case 'Polo_L_HH'
        
        %  Polo_left
        % %{
        
        % Header
        toPlotTypes3D = [ MST VIP MT LIP AUD];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [MST VIP MT LIP AUD];    % Which area types do we want to plot ?
        gridRange = [0 17; 1 22];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        
        monkey = 5;
        hemisphere = 1;
        AP0 = 7; % 4;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            {62,[6,18],[2.0 0.0],[GM 30 43; LIP 64 72; VIP 72 84; MST 136 150]}
            {63,[6,19],[2.0 0],[GM 4 19; GM 22 39; LIP 56 63],63}
            {64,[6,15],[2.0 0],[GM 15 27; GM 48 69; VIP 81 84],84}
            {65,[6,16],[1.9 0],[GM 52 75; LIP 82 97],97}
            {66,[6,20],[2.1 0],[GM 2 19;LIP 37 60],60}
            {67,[6,21],[2.1 + 0.1 0],[LIP 20 43],43}
            {68,[6,17],[2.0 + 0.1 0],[GM 0 13; GM 25 48; LIP 55 64; LIP 64 75],75}
            {69,[5,19],[2.0  0],[GM 0 41; LIP 53 59],59}
            {70,[5,18],[2.0 0],[GM 0 3; GM 28 53; LIP 62 72],72}
            {71,[5,17],[2.0 0.1],[GM 0 11; GM 27 48; LIP 57 70],70}
            {72,[6,19],[2.1 0],[LIP 46 65]}
            {73,[6,18],[2.1 0],[GM 0 12; GM 26 38; LIP 47 59],59}
            {74,[7,18],[2.0 0],[GM 6 49; LIP 59 70],70}
            {75,[7,17],[2.0 0],[GM 7 54; LIP 62 75],75}
            {76,[7,16],[2.0 0],[GM 2 27; GM 40 61; LIP 73 80; VIP 80 86],86}
            {77,[7,19],[2.1 0],[GM 0 11; LIP 37 53],53}
            {78,[8,17],[2.0 0],[GM 9 50; LIP 66 78],78}
            {79,[8,18],[2.0 0],[GM 0 44; LIP 56 57],57}
            {80,[8,19],[2.1 0],[GM 0 24; LIP 48 60]}
            {81,[7,17],[2.1 0],[GM 0 14; GM 26 46; LIP 59 66]}
            {82,[6,18],[2.1 0],[GM 0 13; GM 27 41; LIP 56 71]}
            {83,[6,12],[2.0 0],[VIP 63 71],71}
            {83,[6,10],[2.0 - 0.1 0],[GM 17 73; VIP 102 123]}
            {84,[6,14],[2.0 0],[GM 5 20; GM 52 81; VIP 92 113]}
            {85,[7,18],[2.1-0.1 0],[GM 8 48; LIP 58 73],73}
            {86,[8,18],[2.1 0],[GM 0 35; LIP 46 65; MST 99 100],100}
            {87,[4,18],[2.0 0],[GM 0 10; GM 31 51; LIP 62 87]}
            {88,[4,17],[2.0 0],[GM 35 58; LIP 71 94 ]}
            {89,[4,19],[2.1-0.1 0],[GM 20 45; LIP 61 87]}
            {90,[3,17],[2.0 0],[GM 35 70; LIP 83 97; VIP 97 110]}
            {91,[3,18],[2.0 0],[GM 0 10; GM 37 60; LIP 73 92; VIP 92 98]}
            {91,[3,19],[2.0 0],[GM 30 45; LIP 63 80]}
            {92,[10,17],[2.0 0],[GM 3 45; LIP 52 69],69}
            {93,[12,15],[2.1 0],[GM 3 27; LIP 37 61]}
            {94,[12,13],[2.0 0],[GM 21 49; LIP 56 72],72}
            {95,[14,12],[1.9 -0.1],[GM 10 25; GM 35 56; LIP 67 89]}
            {96,[16,10],[1.9 -0.1],[GM 9 31; GM 42 70; LIP 100 120; LIP 133 148]}
            {97,[10,14],[2.0 0],[GM 3 10; GM 25 61; LIP 71 81],81}
            {98,[8,15],[2.0 -0.05],[GM 3 22; GM 42 65; LIP 78 89],89}
            {99,[9,15],[2.0 0],[GM 5 62; LIP 73 86],86}
            {100,[11,14],[2.0 0],[GM 3 56; LIP 66 81],81}
            {101,[13,13],[2.0 0],[GM 11 42; LIP 52 54],54}
            {102,[8,11],[2.0 0],[GM 2 17; GM 35 42; VIP 65 89; VIP 95 110]}
            {103,[8,10],[1.9 0],[GM 11 26; GM 36 52; VIP 73 92; VIP 101 119]}
            {104,[8,9],[1.9 0],[GM 14 30; GM 40 59; VIP 82 96 ; VIP 107 115]}
            {105,[8,12],[1.9 0],[VIP 67 91; VIP 103 126]}
            {106,[9,11],[1.8 0-0.1],[GM 30 58; GM 80 102; VIP 117 132],132}
            {107,[9,10],[1.8 0],[GM 16 52; GM 74 91; VIP 107 125]}
            {108,[10,10],[1.8 0],[GM 15 58; GM 68 83; VIP 98 125]}
            {109,[10,9],[1.8 0],[GM 4 25; GM 34 51; GM 72 85; VIP 101 117],117}
            {111,[10,15],[2.1 0+0.1],[GM 0 35; LIP 44 59],59}
            }';
        
        MRI_path = 'Z:\Labtools\DrawMapping\forDrawMapping\';
        MRI_offset = {[-68 79] - 5,[-240 500]+15, [0 -1.5]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
    case 'Polo_R_HH'
        
        %  Polo_right
        % %{
        
        % Header
        toPlotTypes3D = [ MST VIP MT LIP AUD];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [MST VIP MT LIP AUD];    % Which area types do we want to plot ?
        gridRange = [1 16; 0 22];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        monkey = 5;
        hemisphere = 2;  % L = 1, R = 2
        AP0 =  7; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            {1,[5,15],[2.0 0.0],[GM 0 20; LIP 44 69; MST 147 150]}
            {2,[5,17],[2.0 0.0],[GM 0 17; LIP 32 64],64}
            {3,[5,13],[1.9 0.0],[GM 21 37; LIP 71 96]}
            {3,[5,11],[1.9 0.0],[GM 31 58; LIP 74 97; VIP 97 103]}
            {4,[6,7],[1.7 0.0],[GM 0 21; VIP 78 100; VIP 111 129],129}
            {5,[5,16],[1.7 0.0],[GM 21 51; LIP 76 82],82}
            {6,[5,14],[1.8 0.0],[GM 0 15; GM 30 43; LIP 79 98]}
            {7,[5,12],[1.8 0.0],[GM 38 50; LIP 79 107],107}
            {8,[9,10],[1.8 0.0],[GM 43 73; LIP 91 111],111}
            {9,[9,9],[1.9 0.0],[GM 0 12; GM 35 59; LIP 75 94],94}
            {10,[9,11],[1.9 0.0],[GM 28 56; LIP  75 90],90}
            {11,[9,12],[1.9 0.0],[GM 24 49; LIP 68 69], 69}
            {12,[9,13],[1.9 0.0],[GM 17 35; LIP 53 62; MST 101 105 ], 105}
            {13,[7,11],[1.9 0.0],[GM 0 9; GM 25 47; LIP 61 86; MST 127 149]}
            {14,[7,12],[1.9 0.0],[GM 0 11; GM 26 47; LIP 58 76],76}
            {15,[7,13],[1.9 0.0],[GM 0 11; GM 20 41; LIP 50 68],68}
            {16,[2,10],[1.9 0.0],[VIP 65 86],86}
            {17,[2,11],[1.9 0.0],[GM 49 59 ; VIP 59 77; VIP 90 103]}
            {18,[2,12],[1.9 0.0],[GM 47 75; VIP 88 102]}
            {19,[8,11],[1.9 0.0],[GM 25 53; LIP 61 84; MST 118 138]}
            {20,[3,10],[1.9 0.0],[VIP 57 73],73}
            {21,[3,9],[1.9 0.0],[VIP 68 92],92}
            {22,[3,11],[1.9 0.0], [GM 47 73; LIP 92 99; VIP 99 110]}
            {23,[2,9],[1.9 0.0],[VIP 77 105]}
            {25,[4,9],[1.9 0.0],[GM 68 80; VIP 80 85],85}
            {26,[4,10],[1.9 0],[GM 49 81; VIP 95 107],107}
            {27,[6,11],[1.9 0],[GM 36 66; LIP 79 100],100}
            {28,[6,12],[1.9 0],[GM 29 55; LIP 71 90; MST 142 150]}
            {29,[6,13],[2.1 0],[GM 13 36; LIP 44 60],60}
            {30,[8,10],[1.9 0],[GM 9 25; GM 34 54; LIP 63 73],73}
            {31,[8,9],[1.9 0],[GM 11 22; GM 39 63; LIP 77 83],83}
            {32,[7,10],[1.9 0],[GM 2 17; GM 39 64; LIP 74   98],98}
            {33,[8,12],[2.0 0],[GM 4 34; LIP 45 65; MST 108 110],110}
            {34,[4,12],[2.0 0],[GM 24 43; LIP 67 85],85}
            {35,[4,13],[2.0 0],[GM 19 38; LIP 60 82],82}
            {36,[4,14],[2.0 0],[GM 0 38; LIP 55 78],78}
            {37,[3,13],[2.0 0],[GM 22 43; LIP 72 86]}
            {39,[8,10],[2.0 0],[GM 10 47; LIP 57 81],81}
            {40,[7,11],[2.0 0],[GM 24 45; LIP 58 70; VIP 70 80; MST 125 129],129}
            {38,[3,14],[2.0 0],[GM 18 46; LIP 66 84]}
            {41,[7,12],[2.0 0],[GM 14 37; LIP 48 66], 66}
            {42,[6,14],[2.0 0],[GM 5 30; LIP 45 58],58}
            {43,[6,15],[2.0 0],[GM 6 27; LIP 43 70; MST 144 150]}
            {44,[6,16],[2.0 0],[LIP 30 67; MST 106 135]}
            {45,[3,15],[2.0 0],[GM 11 35; LIP 61 63],63}
            {46,[3,16],[2.0 0],[GM 13 35; LIP 52 56],56}
            {47,[3,18],[2.0 0],[GM 10 38; LIP 53 57],57}
            {48,[3,17],[2.1 0],[GM 0 25; LIP 42 56],56}
            {49,[4,15],[2.0 0],[GM 2 35; LIP 55 71],71}
            {50,[2,14],[2.0 0],[GM 0 2; GM 30 55; LIP 69 73; VIP 73 86];}
            {51,[2,15],[2 0],[GM 27 53; LIP 68 73], 73}
            {52,[2,16],[2.1 0],[GM 0 43; LIP 54 65],65}
            {53,[10,10],[1.9 0],[GM 0 46; VIP 60 68],68}
            {54,[10,12],[2.0 0],[GM 6 15; LIP 33 59; MST 85 90],90}
            {55,[10,13],[2.0 0],[LIP 30 47; MST 92 93],93}
            {56,[8,13],[2.0 0],[GM 0 22; LIP 41 60],60}
            {57,[7,14],[2.0 0],[GM 5 28; LIP 36 58; MST 120 144]}
            {58,[6,13],[2.0 0],[GM 19 33; LIP 46 48],48}
            {59,[6,12],[1.9 0],[GM 40 50; LIP 71 86; MST 148 150]}
            {60,[5,13],[2.0 0],[GM 12 27; LIP 57 62],62}
            {61,[5,14],[2.0 0],[LIP 58 65],65}
            }';
        
        MRI_path = 'Z:\Labtools\DrawMapping\forDrawMapping\';
        MRI_offset = {[-68 79] - 10,[-240 500], [0 -1.5]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        case 'Polo_L'
        
        %  Polo_left
        % %{
        
        % Header
        toPlotTypes3D = [GM PCC RSC IPS B3a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [GM PCC RSC IPS B3a];    % Which area types do we want to plot ?
        gridRange = [0 17; 1 22];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        monkey = 5;
        hemisphere = 1;
        AP0 = Polo_right_AP0; % 4;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\Polo\Mapping\MRI\PoloOutput\forDrawMapping\';
        MRI_offset = {[-68 79] - 5,[-240 500]+15, [0 -1.5]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        %}
        
        case 'Polo_R'
        
        %  Polo_right
        % %{
        
        % Header
        toPlotTypes3D = [GM PCC RSC IPS B3a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [GM PCC RSC IPS B3a];    % Which area types do we want to plot ?
        gridRange = [6 31; 0 22];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        monkey = 5;
        hemisphere = 2;  % L = 1, R = 2
%         AP0 =  10; % 6;
        AP0 =  Polo_right_AP0; % 6; % changed by LBY 180416
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            {0,[12,6],[2.25 0],[GM 35 60;PCC 61 76]} % 20180129
            {0,[13,5],[2.25 0],[PCC 57 75;PCC 87 106]} % 20180201
            {0,[20,8],[2.45 0],[GM 42 50;]} % 20180411
            {0,[22,10],[2.45 0],[B3a 27 40;PCC 70 85;PCC 95 110;]} % 20180412
            {0,[22,9],[2.45 0],[B3a 7 31;PCC 63 76;PCC 97 105;]} % 20180413
            {0,[22,6],[2.45 0],[B3a 36 42;PCC 74 93;PCC 104 120;]} % 20180420
            {0,[24,7],[2.45 0],[PCC 64 78;PCC 90 115;]} % 20180420
            {0,[20,7],[2.45 0],[GM 25 40;PCC 63 74;]} % 20180420
            {0,[22,7],[2.45 0],[B3a 16 45;PCC 73 88;]} % 20180419
            {0,[21,7],[2.45 0],[B3a 9 28;PCC 59 69;]} % 20180423
            {0,[22,7],[2.45 0],[B3a 28 40;PCC 70 88;PCC 101 121;]} % 20180423
            {0,[26,6],[2.35 0],[GM 13 27;PCC 77 106;]} % 20180425
%             {0,[28,5],[2.35 0],[GM 18 43;]} % 20180426
            {0,[23,5],[2.45 0],[PCC 47 61;PCC 100 120;]} % 20180426
            {0,[21,8],[2.45 0],[B3a 7 27;PCC 56 72;]} % 20180411
            {0,[20,9],[2.45 0],[GM 49 62;PCC 73 87;]} % 20180413
            {0,[23,8],[2.45 0],[B3a 18 40;PCC 72 87;PCC 95 114;]} % 20180415
            {0,[25,6],[2.55 0],[PCC 43 63;PCC 77 92;]} % 20180419
            {0,[24,6],[2.45 0],[PCC 76 95;PCC 106 127;]} % 20180426
            {0,[23,6],[2.55 0],[GM 10 25;PCC 62 80;PCC 94 110;]} % 20180507
            {0,[21,6],[2.45 0],[B3a 10 27;PCC 64 79;PCC 90 110;]} % 20180507
            {0,[26,7],[2.55 0],[GM 35 55;PCC 65 90;PCC 112 120;]} % 20180508
            {0,[22,4],[2.55 0],[PCC 51 63;]} % 20180514
            {0,[25,9],[2.4 0],[B3a 10 50;]} % 20180514
            {0,[23,10],[2.4 0],[B3a 18 45;GM 73 80;]} % 20180514
            {0,[23,9],[2.4 0],[PCC 83 100;]} % 20180514
            {0,[23,11],[2.4 0],[GM 56 76;GM 79 83;GM 87 112;]} % 20180514F
            {0,[23,12],[2.4 0],[GM 11 38;GM 54 58;]} % 20180514
            {0,[23,13],[2.4 0],[WM 0 151;]} % 20180515
            {0,[23,14],[2.4 0],[IPS 129 140;]} % 20180516
            {0,[23,15],[2.4 0],[IPS 135 164;]} % 20180516
            {0,[23,16],[2.4 0],[IPS 138 151;]} % 20180517
            {0,[23,17],[2.4 0],[IPS 105 129;IPS 138 149;]} % 20180517
            {0,[27,6],[2.4 0],[PCC 88 105;PCC 125 137;]} % 20180517
            {0,[23,18],[2.4 0],[IPS 117 147;]} % 20180518
            {0,[23,19],[2.4 0],[IPS 105 130;IPS 135 150;]} % 20180518
%             {0,[27,7],[2.55 0],[WM 0 150;]} % 20180522
            {0,[25,6],[2.55 0],[PCC 65 79;PCC 91 107;]} % 20180523
            {0,[28,7],[2.55 0],[GM 10 15;]} % 20180524
            {0,[24,4],[2.55 0],[PCC 20 76;PCC 88 110;]} % 20180524
            {0,[28,4],[2.55 0],[RSC 125 134;]} % 20180530
            {0,[24,7],[2.55 0],[PCC 83 96;PCC 115 133;]} % 20180530
            {0,[19,7],[2.55 0],[PCC 45 51;PCC 65 87;]} % 20180608
            {0,[21,10],[2.55 0],[PCC 45 65;PCC 78 95;]} % 20180608
            {0,[21,11],[2.55 0],[PCC 78 95;]} % 20180608
            {0,[21,12],[2.55 0],[PCC 40 71;IPS 105 140;]} % 20180608
            {0,[21,13],[2.55 0],[GM 45 58;GM 67 83;IPS 114 145;]} % 20180612
            {0,[21,14],[2.55 0],[GM 10 24;IPS 83 110;IPS 125 136;]} % 20180612
            {0,[21,15],[2.55 0],[GM 15 20;IPS 100 123.5;IPS 129 140;]} % 20180612
            {0,[21,16],[2.55 0],[GM 20 30;IPS 68 101.5;IPS 111 127;]} % 20180615
            {0,[21,17],[2.55 0],[GM 13 23;IPS 64 80;IPS 100 123;]} % 20180615
            {0,[17,6],[2.65 0],[GM 10 26;PCC 42 60;PCC 90 120;]} % 20180621
            {0,[17,9],[2.65 0],[PCC 29 40;IPS 106 138;]} % 20180621
            {0,[16,6],[2.95 0],[IPS 74 93;]} % 20180621
            {0,[22,4],[2.55 0],[GM 36 57;PCC 69 85;]} % 20180723
            {0,[22,6],[2.55 0],[GM 21 31;PCC 76 85;PCC 100 117;]} % 20180723
            
            
            {107,[8,6],[2.4 0],[PCC 48 67]}
            {108,[9,5],[2.25 0],[GM 33.5 44;PCC 68 80;PCC 115 131]}
            {109,[10,6],[2.25 0],[GM 37 56;PCC 69 75]}
            {110,[11,5],[2.25 0],[GM 3.6 19;GM 36 56;PCC 63 115]}
            {111,[14,6],[2.25 0],[GM 9.5 23;GM 33 48;PCC 72 94;PCC 103 123]}
%             {112,[9,5],[2.25 0],[GM 33.5 44;GM 68 80;GM 11500 13100]}
            {113,[22,8],[2.45 0],[B3a 47 58]}
            {114,[20,6],[2.45 0],[GM 10 30;PCC 61 73;]}
            {115,[23,6],[2.55 0],[B3a 6 12;PCC 50 67;PCC 79 96;]}
            {116,[24,8],[2.55 0],[B3a 9 16;PCC 64 85;PCC 94 108;]}
            {117,[25,8],[2.55 0],[B3a 15 34;PCC 63 82;PCC 101 119;]}
            {118,[27,7],[2.35 0],[PCC 57 77;]}
            {118,[25,7],[2.35 0],[B3a 26 39;PCC 78 81;]} 
            {119,[23,7],[2.45 0],[B3a 37 52;PCC 76 85;PCC 100 118;]} 
            {119,[25,5],[2.45 0],[PCC 22 66;]} 
            {120,[26,8],[2.45 0],[GM 63 78;]} 
            {121,[24,5],[2.45 0],[B3a 0 15;PCC 65 68;]} 
            {122,[26,5],[2.45 0],[GM 9 55;PCC 67 84;PCC 94 110;]} 
            {123,[22,7],[2.45 0],[B3a 12 34;PCC 67 80;PCC 110 120;]} 
            {124,[24,6],[2.4 0],[PCC 69 83;PCC 107 123;]} 
            {125,[25,4],[2.55 0],[PCC 33 73;PCC 82 90;]} 
            {126,[22,3],[2.55 0],[PCC 14 42;PCC 47 65;]} 
            {127,[23,4],[2.55 0],[PCC 33.5 38;]} 
            {128,[26,4],[2.55 0],[PCC 70 90;PCC 103 121;]} 
            {129,[27,8],[2.55 0],[PCC 43 57;PCC 111 134;]} 
            {130,[27,5],[2.55 0],[PCC 78 105;PCC 131 136;]} 
            {131,[27,9],[2.55 0],[GM 17.5 30;PCC 105 129;PCC 139 147;]} 
            {131,[28,6],[2.55 0],[PCC 108 136;]} 
            {132,[28,4],[2.55 0],[GM 15 26;PCC 75 105;]} 
            {133,[28,5],[2.55 0],[PCC 60 81;]} 
            {134,[24,6],[2.55 0],[PCC 75 92;PCC 107 128;]} 
            {135,[23,5],[2.55 0],[B3a 10 26;PCC 68 81;PCC 97 109;PCC 111 122;]} 
            {136,[23,7],[2.55 0],[B3a 11 35;PCC 69 82;PCC 100 115;]} 
            {137,[23,6],[2.55 0],[B3a 9 20;]} 
            {138,[23,4],[2.65 0],[PCC 11 53;PCC 72 81;]} 
            {139,[22,5],[2.55 0],[PCC 105 110;]} 
            {139,[21,5],[2.55 0],[B3a 22 40;PCC 77 92;PCC 103 115;]} 
            {140,[19,8],[2.65 0],[PCC 10 15;PCC 40 54;PCC 75 95;]} 
            {141,[19,5],[2.85 0],[PCC 29 39;PCC 45 68;RSC 130 141;]} 
            {142,[18,5],[2.85 0],[PCC 36 49;PCC 60 82;PCC 99 148;]} 
            {143,[18,7],[2.55 0],[GM 12 46;PCC 63 77.5;IPS 105 132;]} 
            {144,[17,8],[2.65 0],[GM 12 33;PCC 46 58;]} 
            {145,[17,7],[2.65 0],[GM 9 39;PCC 51 71;RSC 140 156;]} 
            {146,[17,5],[2.85 0],[GM 13 26;PCC 39 46;]} 
            {147,[20,5],[2.65 0],[PCC 41 55;PCC 66 81;]} 
            {148,[20,9],[2.65 0],[GM 37 49;PCC 69 86;]} 
            {149,[22,8],[2.55 0],[GM 17 28;PCC 60 76;PCC 90 107;]} 
            {150,[23,4],[2.65 0],[GM 0 8;PCC 20 56;PCC 63 83;GM 110 147;]}
            {151,[23,6],[2.65 0],[GM 45 50;]} 
            {152,[25,5],[2.65 0],[GM 4 54;PCC 66 76;]} 

            }';
        
        MRI_path = 'Z:\Data\MOOG\Polo\Mapping\MRI\PoloOutput\forDrawMapping\';
%         MRI_offset = {[-100 100],[-200 720]-5, [0 -0.1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        MRI_offset = {[-105 103]+3,[-355 715]+40, [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
end



%% ========== 3-D Visualization ========== %%

for channel = 1:length(data)
    gridLoc = data{channel}{2};
    GMData = data{channel}{4};
    if isempty(GMData); continue; end;
    
    GuideTubeAndOffset = data{channel}{3};
    offSet = round((GuideTubeAndOffset(2) + GuideTubeAndOffset(1) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
    
    for GMType = -size(GMTypes,1):-1  % For each area type
        GMThisType = find(GMData(:,1) == GMType);   % Read out ranges for this type
        if isempty(GMThisType) || isempty(intersect(toPlotTypes3D,GMType)); continue; end       % If absent in this channel or absent in areas we want to plot, next type
        
        GMPos = [];    % Clear cache
        for i = 1:length(GMThisType)    % For each appearance
            % Attach each appearance to position cache
            GMPos = [GMPos (maxZ - offSet - GMData(GMThisType(i),3)):(maxZ - offSet - GMData(GMThisType(i),2))];
        end
        
        GMPos = round(GMPos); % added for un-intergral numbers LBY20161228
        
        % Add color to positions in the cache
        try
            if hemisphere == 2
                V(gridLoc(1), maxY - gridLoc(2), GMPos, :) = repmat(GMTypes{-GMType,2},length(GMPos),1);
            else
                V(gridLoc(1), gridLoc(2), GMPos, :) = repmat(GMTypes{-GMType,2},length(GMPos),1);
            end
        catch
            fprintf('Warning: Out of Range (Session %g, Channel [%g,%g], GMType %s)\n', channel, data{channel}{2}(1), data{channel}{2}(2), GMTypes{-GMType,1});
            keyboard;
        end
    end
    
    % Add start and end markers
    if hemisphere == 2
        V(gridLoc(1), (maxY - gridLoc(2)),(maxZ - offSet - 2):(maxZ - offSet - 1),:) = repmat([0 0 0],2,1);
        if length(data{channel}) <5
            V(gridLoc(1), (maxY - gridLoc(2)),(maxZ - offSet - movDis - 1):(maxZ - offSet - movDis),:) = repmat([0 0 0],2,1);
        else
            V(gridLoc(1), (maxY - gridLoc(2)),(maxZ - offSet - data{channel}{5} - 1):(maxZ - offSet - data{channel}{5}),:) = repmat([0 0 0],2,1);
        end
    else
        V(gridLoc(1), (gridLoc(2)),(maxZ - offSet - 2):(maxZ - offSet - 1),:) = repmat([0 0 0],2,1);
        if length(data{channel})<5
            %             try
            V(gridLoc(1), (gridLoc(2)),(maxZ - offSet - movDis - 1):(maxZ - offSet - movDis),:) = repmat([0 0 0],2,1);
            %             catch
            %                 keyboard;
            %             end
        else
            V(gridLoc(1), (gridLoc(2)),(maxZ - offSet - data{channel}{5} - 1):(maxZ - offSet - data{channel}{5}),:) = repmat([0 0 0],2,1);
        end
    end
    
end

% Render the mapping results using "vol3d" function
% close all;
set(figure(801),'Position',[10 100 600 600]);  clf;
set(0, 'DefaultAxesXTickMode', 'auto', 'DefaultAxesYTickMode', 'auto', 'DefaultAxesZTickMode', 'auto');
vol3d('cdata',V);
view(-150,30);

axis tight;
daspect([1,1,10]);
alphamap('rampup');
alphamap(.5 .* alphamap);  % Transparency

grid on;  grid minor;
set(gca,'GridLineStyle','-');

set(gca,'xtick',-0.5:5:maxY-0.5);
if hemisphere == 2
    %     set(gca,'xticklabel','25|20|15|10|5|0');
    set(gca,'xticklabel',25:-5:0);
else
    %     set(gca,'xticklabel','0|5|10|15|20|25');
    set(gca,'xticklabel',0:5:25);
end
xlim([-1 maxY]);

set(gca,'ytick',-0.5:5:maxX-0.5);
% set(gca,'yticklabel','0|5|10|15|20|25|30');
set(gca,'yticklabel',0:5:30);
ylim([-1 maxX]);

set(gca,'ztick',0:50:maxZ);
% set(gca,'zticklabel','-250|-200|-150|-100|-50|0');
set(gca,'zticklabel',-250:50:0);

ylabel('Posterior (X)')
xlabel('Lateral (Y)')

for i = 1:length(toPlotTypes3D)
    text(0, 0, maxZ-i*40, GMTypes{-toPlotTypes3D(i),1},'color',GMTypes{-toPlotTypes3D(i),2},'FontSize',20);
end;

set(gcf,'color','w');
% set(findall(gcf,'fontsize',10),'fontsize',20);
SetFigure(20);

% k=1;
% for i = 1:150
%     view(-170+i*.5,20+i/10);
%     drawnow;
%     mov(k) = getframe(gcf);
%     k=k+1;
% end
%
% for i = 150:-1:1
%     view(-170+i*.5,20+i/10);
%     drawnow;
%     mov(k) = getframe(gcf);
%     k=k+1;
% end
%
% movie2avi(mov,'Test.avi');

%% ============ 2-D Visualization (Grid view from the top) =============== %

radius = 0.42;  % Radius of each hole (interval = 1)

% Plot grid outline
set(figure(802),'Position',[10 100 600 600]); clf
hold on; axis equal ij;
x1 = gridRange(1,1); x2 = gridRange(1,2);
y1 = gridRange(2,1); y2 = gridRange(2,2);
xlim([y1-2,y2+2]);

% Quick select monkey_hemi. HH20160122
h_monkey_hemi = uicontrol('style','popupmenu','unit','norm','position',[0.01 0.94 0.131 0.035],...
    'string','QQ_L|QQ_R|Polo_L|Polo_R|Polo_L_HH|Polo_R_HH','callback',@change_monkey_hemi);
set(h_monkey_hemi,'value',monkey_hemi);

% Frame
% changed sth.for Qiaoqiao  LBY20161216
interval = 5;
xLoc = intersect(x1:x2,1:interval:100);
yLoc = intersect(y1:y2,1:interval:100);
xLines = line(repmat([y1-1;y2+1],1,length(xLoc)),repmat(xLoc,2,1));  % xLines
switch monkey_hemis{monkey_hemi} % changed sth.for Qiaoqiao's new grid(left hemi)  LBY20170927
    case {'Qiaoqiao_R','Polo_R','Polo_R_HH'}
        yLines = line(repmat(yLoc+0.25,2,1), repmat([x1-1;x2+1],1,length(yLoc)));  % yLines
    case {'Qiaoqiao_L','Polo_L','Polo_L_HH'}
        yLines = line(repmat(yLoc-0.25,2,1), repmat([x1-1;x2+1],1,length(yLoc)));  % yLines
end

set(xLines,'LineWidth',5,'Color',colorLGray);
set(yLines,'LineWidth',5,'Color',colorLGray);
set(gca,'xtick', yLoc);
set(gca,'ytick', xLoc);
axis xy; %LBY20161216 for xLoc reverse

% Parallel drawing (to speed up)
xOffsets = repmat(x1:x2, y2-y1+1,1);
xOffsets = xOffsets(:)';
yOffsets = repmat([(y1:y2)+0.5*~mod(x1,2) (y1:y2)+0.5*mod(x1,2)], 1, fix((x2-x1 + 1)/2));
if mod(x2-x1+1,2) == 1
    yOffsets = [yOffsets y1:y2];
end
t = linspace(0,2*pi,100)';

switch monkey_hemis{monkey_hemi} % changed sth.for Qiaoqiao's new grid(left hemi)  LBY20170927
    case {'Qiaoqiao_R','Polo_R','Polo_R_HH'}
        xGrid = radius * repmat(sin(t),1,length(xOffsets)) + repmat(xOffsets,length(t),1);
    case {'Qiaoqiao_L','Polo_L','Polo_L_HH'}
        xGrid = radius * repmat(sin(t),1,length(xOffsets)) + repmat(xOffsets+1,length(t),1);
end
yGrid = radius * repmat(cos(t),1,length(yOffsets)) + repmat(yOffsets,length(t),1);
set(fill(yGrid,xGrid,[1 1 1]),'LineWidth',1.5,'ButtonDownFcn',@SelectChannel);    % White color



% Plot mapping result
for channel = 1:length(data)
    xCenter = data{channel}{2}(1);
    switch monkey_hemis{monkey_hemi} % changed sth.for Qiaoqiao's new grid(left hemi)  LBY20170927
        case {'Qiaoqiao_R','Polo_R','Polo_R_HH'}
            yCenter =  data{channel}{2}(2) + 0.5 * ~mod(data{channel}{2}(1),2);
        case {'Qiaoqiao_L','Polo_L','Polo_L_HH'}
            yCenter =  data{channel}{2}(2) + 0.5 *( ~mod(data{channel}{2}(1),2)-1);
            
    end
    %     yCenter =  data{channel}{2}(2) + 0.5 * ~mod(data{channel}{2}(1),2);
    
    % Paint
    haveTypes = intersect(toPlotTypes_zview,data{channel}{4}(:,1));    % Find which areas this channel has.
    if isempty(haveTypes)    % If there is no types of interest, paint using the color of GM
        t = linspace(0,2*pi,100)';
        xMap = radius * sin(t) + xCenter ;
        yMap = radius * cos(t) + yCenter;
        set(fill(yMap,xMap,GMTypes{-GM,2}),'ButtonDownFcn',@SelectChannel);
        c = 'k';
    else                     % Else, we paint colors for each type
        for iType = 1:length(haveTypes)
            t = linspace(2*pi/length(haveTypes)*(iType-1), 2*pi/length(haveTypes)*iType, 100)';
            xMap = 0.99 * radius * [0; sin(t)] + xCenter;
            yMap = 0.99 * radius * [0; cos(t)] + yCenter;
            set(fill(yMap,xMap,GMTypes{-haveTypes(iType),2}),'LineStyle','none','ButtonDownFcn',@SelectChannel);
        end
        
        if [0.21 0.72 0.07]*(GMTypes{-haveTypes(1),2})' > 0.5
            c = 'k';
        else
            c = 'y';
        end
    end
    
    %------ Denotations -----%
    % Session No.
    text(yCenter, xCenter-0.1, num2str(data{channel}{1}),'FontSize',7,'color',c,'HorizontalAlignment','center','ButtonDownFcn',@SelectChannel);
    %     axis off;
end

% Legend
for i = 1:length(toPlotTypes_zview)
    text(y1+(i-1)*4, x1-2, GMTypes{-toPlotTypes_zview(i),1},'color',GMTypes{-toPlotTypes_zview(i),2},'FontSize',15);
end;

set(gcf,'color','w')
set(gca,'fontsize',15)

if hemisphere == 1
    set(gca,'xdir','rev');
end

%% Load xls file
global num txt raw xls;
if isempty(num)
    % add dor LBY LBY20161212
    XlsData = ReadXls('Z:\Data\MOOG\Results\Result_LBY.xlsm',2,3);
    num = XlsData.num;
    xls = XlsData.header;
    txt = XlsData.txt;
    
    disp('Xls Loaded');
end

%% Call back for 2-D Grid View
function SelectChannel(~,~)

global maxX maxY maxZ movDis GMTypes data Qiaoqiao_right_AP0 Polo_right_AP0
global MRI_path MRI_offset AP0;
global monkey hemisphere ;
global gridRange linWid start_end_markers overlapping;
global handles;
global num txt raw xls;

hemisphere_text = {'Left','Right'};

% Which channel do we select?

pos = get(gca,'CurrentPoint');
pos = pos(1,1:2);
xSelect = round(pos(2));
ySelect = round(pos(1)- 0.5 * ~mod(xSelect,2));

figure(802);

delete(handles);

% handles(100) = rectangle('Position',[gridRange(2,2)+1.4,xSelect-0.1,0.2,0.2],'FaceColor','k');
handles(1) = plot(xlim,repmat(xSelect - 0.5 + overlapping(1,1),1,2),'r--','LineWid',1);
handles(2) = plot(xlim,repmat(xSelect + 0.5 + overlapping(1,2),1,2),'r--','LineWid',1);
% handles(3) = plot(repmat(ySelect + 0.25,1,2),[xSelect - 0.5 + overlapping(1,1) xSelect + 0.5 + overlapping(1,2)],'r','LineWid',1);
handles(3) = plot(repmat(ySelect - 0.5 + overlapping(1,1),1,2),ylim,'r--','LineWid',1);
handles(4) = plot(repmat(ySelect + 0.5 + overlapping(1,2),1,2),ylim,'r--','LineWid',1);

% Show corresponding sessions
sessions_match = [];
for channel = 1:length(data)
    if data{channel}{2}(1) == xSelect && data{channel}{2}(2) == ySelect
        sessions_match = [sessions_match data{channel}{1}];
    end
end

title(sprintf('M%g, session(s) for %s [%g,%g]: %s',monkey,hemisphere_text{hemisphere},xSelect,ySelect,num2str(sessions_match)));

%-------------------   for coronal plane  -----------------------%

figurePosition = [650 100 500 800];
set(figure(803),'Position',figurePosition,'color','w'); clf;

% 2-D Visualization (Coronal)
h_coronal = axes('Position',[0.2 0.1 0.7 0.8]);

axis ij; hold on;


% Overlapping MRI data
try
    if monkey == 6
        fileNo = (xSelect - AP0) + Qiaoqiao_right_AP0 ;  % Because I use Qiaoqiao_right MRI as standard images LBY20170309
    elseif monkey == 5
        fileNo = xSelect + Polo_right_AP0 - AP0;
        %     else
        %         fileNo = xSelect + Qiaoqiao_right_AP0 - AP0;
        %     end
    end
%     MRI = imread([MRI_path num2str(fileNo) '.bmp']);
MRI = imread([MRI_path num2str(fileNo) '.jpg']);
    %     h_MRI = image(MRI_offset{1}+xSelect*MRI_offset{3}(1), MRI_offset{2} + xSelect*MRI_offset{3}(2),MRI);
    % previous MRI figure shows the same for two hemispheres, thus I changed to
    % correct it.
    % LBY 20171110
    
    if hemisphere == 2
        h_MRI = image(MRI_offset{1}+xSelect*MRI_offset{3}(1), MRI_offset{2} + xSelect*MRI_offset{3}(2),MRI);
    elseif hemisphere == 1
        h_MRI = image(MRI_offset{1}+xSelect*MRI_offset{3}(1), MRI_offset{2} + xSelect*MRI_offset{3}(2),flipdim(MRI,2));
    end
    %     set(h_MRI,'AlphaData',0.7);
catch
    disp('No MRI data found...');
end

% Frame
xlim([gridRange(2,1) gridRange(2,2)+1]);
set(gca,'xtick',[gridRange(2,1):5:gridRange(2,2)]);
ylim([-30 maxZ]);
grid minor;
set(h_coronal,'XMinorGrid','on','XMinorTick','on');
% title(sprintf('Monkey %g, %s[%g], AP 「 %g',monkey, hemisphere_text{hemisphere},xSelect,(AP0-xSelect)*0.8));
% add minus for Qiaoqiao LBY20161219
title(sprintf('Coronal M%g, %s[%g,x], AP 「 %g',monkey, hemisphere_text{hemisphere},xSelect,-(AP0-xSelect)*0.8));

% Keep scale
aspectRatio = (range(ylim) * 100) / (range(xlim) * 800);  % grid interval = 0.8 mm
set(figure(803),'Position',[figurePosition(1:2) figurePosition(4)/aspectRatio figurePosition(4)]);


for channel = 1:length(data)
    %     if data{channel}{2}(1) == xSelect  % Only plot the line we select
    if data{channel}{2}(1) >= xSelect + overlapping(1,1) && data{channel}{2}(1) <= xSelect + overlapping(1,2)   % Overlapping neighboring slices
        yLoc = data{channel}{2}(2)-0.5;
        GMData = data{channel}{4};
        if isempty(GMData); continue; end;
        
        GuideTubeAndOffset = data{channel}{3};
        offSet = round((GuideTubeAndOffset(2) + GuideTubeAndOffset(1) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!! unit:100um
        
        for GMType = -size(GMTypes,1):-1  % For each area type
            GMThisType = find(GMData(:,1) == GMType);   % Read out ranges for this type
            if isempty(GMThisType); continue; end       % If absent, next type
            
            for i = 1:length(GMThisType)  % For each appearance
                zBegin = GMData(GMThisType(i),2) + offSet;
                zEnd = GMData(GMThisType(i),3) + offSet;
                
                if overlapping(1,1)~=0 || overlapping(1,2)~=0  % If we overlap neighboring slices
                    p = patch([yLoc yLoc yLoc+1 yLoc+1],[zEnd,zBegin,zBegin,zEnd],GMTypes{-GMType,2},'EdgeColor','none','FaceAlpha',0.4);
                else
                    rectangle('Position',[yLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,...
                        'EdgeColor',GMTypes{-GMType,2});
                end
            end
            
        end
        
        for GMType = -size(GMTypes,1):-1  % For each area type (that we are NOT SURE!!)
            GMThisType = find(GMData(:,1) == GMType - 100);   % Read out ranges for this type (that we are NOT SURE!!)
            if isempty(GMThisType); continue; end       % If absent, next type
            
            for i = 1:length(GMThisType)  % For each appearance
                zBegin = GMData(GMThisType(i),2) + offSet;
                zEnd = GMData(GMThisType(i),3) + offSet;
                
                % Note we use dotted line here to mark areas that we are not sure
                rectangle('Position',[yLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,'EdgeColor',GMTypes{-GMType,2},'LineStyle',':');
            end
            
        end
        
        %         Add start and end markers
        if start_end_markers
            if yLoc+0.5 == ySelect
                col_temp = 'c';
                rectangle('Position',[yLoc,offSet,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                offSet_selected = offSet;
                if length(data{channel})<5
                    rectangle('Position',[yLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                else
                    rectangle('Position',[yLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                end
            else
                rectangle('Position',[yLoc,offSet,1,1],'LineWidth',linWid,'FaceColor','k');
                if length(data{channel})<5
                    rectangle('Position',[yLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor','k');
                else
                    rectangle('Position',[yLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor','k');
                end
            end
            
            
        end
        
    end
end

if exist('h_MRI')
    if exist('offSet_selected')
        set(h_MRI,'ButtonDownFcn',{@ShowDepth,offSet_selected});
    else
        set(h_MRI,'ButtonDownFcn','');
    end
else
    set(gca,'color',[0.5 0.5 0.5]);
    set(803,'color',[0.5 0.5 0.5]);
    %     set(gcf,'foregroundcolor','w');
end

if start_end_markers
    % Channel indicator
    plot([ySelect ySelect],ylim,'r--','LineW',0.5);
end

xlabel('Grid Y No. (x 0.8 mm)');


% Set y scale to mm
ytick_temp = 0:50:200;
set(gca,'ytick',ytick_temp);
set(gca,'yticklabel',ytick_temp/10);
ylabel('Depth (mm)');

% rectangle('Position',[ySelect+0.2,maxZ*0.95,0.6,10],'FaceColor','r','EdgeColor','r');

if hemisphere == 1
    set(gca,'xdir','rev');
end

for oldsize = 5:100
    set(findall(gcf,'fontsize',oldsize),'fontsize',13);
end
set(findall(gcf,'tickdir','i'),'tickdir','o');
% axis off;

% %-------------------   for saggital plane  -----------------------%
%
% set(figure(804),'Position',figurePosition, 'color','w'); clf;
% h_saggital = axes('Position',[0.2 0.1 0.7 0.8]);
% axis ij; hold on;
%
% % Frame
% xlim([gridRange(1,1) gridRange(1,2)+1]);
% set(gca,'xtick',[gridRange(1,1):5:gridRange(1,2)]);
% ylim([-30 maxZ]); %?
% grid minor;
% set(h_coronal,'XMinorGrid','on','XMinorTick','on');
% % title(sprintf('Monkey %g, %s[%g], AP 「 %g',monkey, hemisphere_text{hemisphere},xSelect,(AP0-xSelect)*0.8));
% % add minus for Qiaoqiao LBY20161219
% title(sprintf('Saggital M%g, %s[y,%g], AP 「 %g',monkey, hemisphere_text{hemisphere},ySelect,-(AP0-xSelect)*0.8));
%
% % Keep scale
% aspectRatio = (range(ylim) * 100) / (range(xlim) * 800);  % grid interval = 0.8 mm
% set(figure(804),'Position',[1200 figurePosition(2) figurePosition(4)/aspectRatio figurePosition(4)]);
%
% for channel = 1:length(data)
%     %     if data{channel}{2}(1) == xSelect  % Only plot the line we select
%     if data{channel}{2}(2) >= ySelect + overlapping(1,1) && data{channel}{2}(2) <= ySelect + overlapping(1,2)   % Overlapping neighboring slices
%         xLoc = data{channel}{2}(1)-0.5;
%         GMData = data{channel}{4};
%         if isempty(GMData); continue; end;
%
%         GuideTubeAndOffset = data{channel}{3};
%         offSet = round((GuideTubeAndOffset(2) + GuideTubeAndOffset(1) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%
%         for GMType = -size(GMTypes,1):-1  % For each area type
%             GMThisType = find(GMData(:,1) == GMType);   % Read out ranges for this type
%             if isempty(GMThisType); continue; end       % If absent, next type
%
%             for i = 1:length(GMThisType)  % For each appearance
%                 zBegin = GMData(GMThisType(i),2) + offSet;
%                 zEnd = GMData(GMThisType(i),3) + offSet;
%
%                 if overlapping(1,1)~=0 || overlapping(1,2)~=0  % If we overlap neighboring slices
%                     p = patch([xLoc xLoc xLoc+1 xLoc+1],[zEnd,zBegin,zBegin,zEnd],GMTypes{-GMType,2},'EdgeColor','none','FaceAlpha',0.4);
%                 else
%                     rectangle('Position',[xLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,...
%                         'EdgeColor',GMTypes{-GMType,2});
%                 end
%             end
%
%         end
%
%         for GMType = -size(GMTypes,1):-1  % For each area type (that we are NOT SURE!!)
%             GMThisType = find(GMData(:,1) == GMType - 100);   % Read out ranges for this type (that we are NOT SURE!!)
%             if isempty(GMThisType); continue; end       % If absent, next type
%
%             for i = 1:length(GMThisType)  % For each appearance
%                 zBegin = GMData(GMThisType(i),2) + offSet;
%                 zEnd = GMData(GMThisType(i),3) + offSet;
%
%                 % Note we use dotted line here to mark areas that we are not sure
%                 rectangle('Position',[xLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,'EdgeColor',GMTypes{-GMType,2},'LineStyle',':');
%             end
%
%         end
%
%         % Add start and end markers
%         if start_end_markers
%             if xLoc+0.5 == xSelect
%                 col_temp = 'c';
%                 rectangle('Position',[yLoc,offSet,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
%                 offSet_selected = offSet;
%                 if length(data{channel})<5
%                     rectangle('Position',[xLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
%                 else
%                     rectangle('Position',[xLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
%                 end
%             else
%                 rectangle('Position',[xLoc,offSet,1,1],'LineWidth',linWid,'FaceColor','k');
%                 if length(data{channel})<5
%                     rectangle('Position',[xLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor','k');
%                 else
%                     rectangle('Position',[xLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor','k');
%                 end
%             end
%
%
%         end
%
%     end
% end
%
% if exist('h_MRI')
%     if exist('offSet_selected')
%         set(h_MRI,'ButtonDownFcn',{@ShowDepth,offSet_selected});
%     else
%         set(h_MRI,'ButtonDownFcn','');
%     end
% else
%     set(gca,'color',[0.5 0.5 0.5]);
%     set(804,'color',[0.5 0.5 0.5]);
%     %     set(gcf,'foregroundcolor','w');
% end
%
% if start_end_markers
%     % Channel indicator
%     plot(xlim,[xSelect xSelect],'r--','LineW',0.5);
% end
%
% xlabel('Grid X No. (x 0.8 mm)');
%
% % Set y scale to mm
% ytick_temp = 0:50:200;
% set(gca,'ytick',ytick_temp);
% set(gca,'yticklabel',ytick_temp/10);
% ylabel('Depth (mm)');
%
% % rectangle('Position',[ySelect+0.2,maxZ*0.95,0.6,10],'FaceColor','r','EdgeColor','r');
%
% if hemisphere == 1
%     set(gca,'xdir','rev');
% end
%
% for oldsize = 5:100
%     set(findall(gcf,'fontsize',oldsize),'fontsize',13);
% end
% set(findall(gcf,'tickdir','i'),'tickdir','o');
% % axis off;
drawnow;



%% Plot Tuning.  HH20140624
figure(803);
colorDefsLBY; % added by LBY 20180605
% --------------- Tuning Properties
% Mask: monkey & hemishpere & xLoc & significant visual tuning
% mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ...
%     & (num(:,xls.p_vis) < 0.05);
% to_plot = num(mask_tuning,:);
%
% for i =  1:size(to_plot,1)
%     offSet = round((to_plot(i,xls.guidetube)  + to_plot(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%     xx = to_plot(i,xls.Yloc) + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%     yy = offSet + round(to_plot(i,xls.Depth)/100);
%
%     if to_plot(i,xls.Pref_vis) > 0
%         plot(xx,yy,'r>','linewid',1.2);
%     else
%         plot(xx,yy,'r<','linewid',1.2);
%     end
% %     plot(xx,yy,'ro' );
% end

% added for temporal-spatial analysis, LBY201612
% --------------- temporal-spatial Properties (MU & SU) --------------------------%
% Mask: monkey & hemishpere & xLoc & significant visual tuning
mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & ...
    (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ;
to_plot_num = num(mask_tuning,:);
to_plot_txt = txt(mask_tuning,:);

for i =  1:size(to_plot_num,1)
    
%     if strcmp(to_plot_txt(i,xls.Protocol),'3DT')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         %         if to_plot_num(i,xls.p_M) < 0.01 % the peak/trough is significant
%         %             if to_plot_num(i,xls.tuning) == 1 % excited cell
%         plot(xx,yy,'k.','linewid',0.4,'markerfacecolor','r','markersize',12);
%         %                 pref_Azi = ?;
%         %                 aspect = daspect;
%         %                 plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'r-','linew',1.5); % for preferred azimuth
%         %                 plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'r:','linew',1.5); % for preferred elevation
%         %             else if to_plot_num(i,xls.tuning) == -1 % inhibited cell
%         %                     plot(xx,yy,'r.','linewid',0.4,'markerfacecol','b','markersize',15);
%         %                     pref_Azi = ?;
%         %                 aspect = daspect;
%         %                 plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'b-','linew',1.5); % for preferred azimuth
%         %                 plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'b:','linew',1.5); % for preferred elevation
%         %                 end
%         %             else  % non-T site
%         %                 plot(xx,yy,'ro','linewid',0.4,'markerfacecol','none','markersize',5);
%         %             end
%         %         end
%         
%     end
    
    %     % added temporarily LBY 20161228
%         if strcmp(to_plot_txt(i,xls.Protocol),'3DR')
%             offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%             xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%             yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%             plot(xx,yy,'wo','linewid',1,'markersize',6);
%         end
    %     if strcmp(to_plot_txt(i,xls.Protocol),'DelSac')
    %         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
    %         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
    %         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
    %         plot(xx,yy,'yo','linewid',1,'markersize',8);
%         end
    if strcmp(to_plot_txt(i,xls.Area),'PCCl') || strcmp(to_plot_txt(i,xls.Area),'PCCu')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color','w','markersize',13);
    end
%     if strcmp(to_plot_txt(i,xls.Area),'PCCu')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         plot(xx,yy,'.','color','w','markersize',13);
%     end
%     if strcmp(to_plot_txt(i,xls.Area),'PCCl')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         plot(xx,yy,'.','color','y','markersize',13);
%     end
%     if strcmp(to_plot_txt(i,xls.Area),'RSC')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         plot(xx,yy,'r.','linewid',0.4,'markerfacecolor','r','markersize',12);
%     end
end


%     % --------------- MemSac Properties (MU & SU)
%     % Mask: monkey & hemishpere & xLoc & significant visual tuning
%     mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & ...
%         (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ;
%     to_plot_num = num(mask_tuning,:);
%     to_plot_txt = txt(mask_tuning,:);
%
%     for i =  1:size(to_plot_num,1)
%
%         if strcmp(to_plot_txt(i,xls.Protocol),'MemSac')
%             offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%             xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%             yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%
%             if to_plot_num(i,xls.p_M) < 0.01 %to_plot_num(i,xls.HD_MemSac) >= 0.8  % T site
%                 plot(xx,yy,'ro','linewid',0.4,'markerfacecol','r','markersize',5);
%                 pref_M = headingToAzi(to_plot_num(i,xls.pref_M))*pi/180;
%                 aspect = daspect;
%                 plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'r-','linew',1.5);
%             else  % non-T site
%                 plot(xx,yy,'ro','linewid',0.4,'markerfacecol','none','markersize',5);
%             end
%         end
%
%     end

% --------------- LIP SUs -------
% % Mask: monkey & hemishpere & xLoc & significant visual tuning
% mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ...
%     &  strcmp(txt(:,xls.Protocol),'HD') & (strcmp(txt(:,xls.Area),'LIP')) & (num(:,xls.Chan1)>1)  & (num(:,xls.Chan1)<20);
%
% to_plot = num(mask_tuning,:);
%
% for i =  1:size(to_plot,1)
%     offSet = round((to_plot(i,xls.guidetube)  + to_plot(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%     xx = to_plot(i,xls.Yloc) + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%     yy = offSet + round(to_plot(i,xls.Depth)/100);
%
%     if to_plot(i,xls.HD_MemSac) >= 0.9 % T cell
%         plot(xx,yy,'ro','linewid',0.4,'markerfacecol','r','markersize',5);
%     else % non-T cell
%         plot(xx,yy,'ro','linewid',0.4,'markerfacecol','r','markersize',5);
% %         plot(xx,yy,'ro','linewid',0.4,'markerfacecol','none','markersize',7);
%     end
% end

function ShowDepth(~,~,offset)
persistent depthLine;
pos = get(gca,'CurrentPo');
depth = pos(1,2);

try
    set(depthLine(1),'ydata',[depth depth]);
    set(depthLine(2),'position',[max(xlim)*0.8 depth],'string',sprintf('%0.0f\n',(depth-offset)*100));
catch
    depthLine(1) = plot(xlim,[depth depth],'b--','ButtonDownFcn',{@ShowDepth,offset});
    depthLine(2) = text(max(xlim)*0.8,depth,sprintf('%0.0f\n',(depth-offset)*100),'color','b','fontsize',15);
end


%     function ReadXls()
%
%     %% Read xls for plotting tuning. HH20140624
%     global num txt raw xls;
%     [num,txt,raw] = xlsread('Z:\Data\MOOG\Results\Result.xlsm',2);
%
%     % Get Header infomation
%     HEADS_N = 3;
%
%     header_all = txt(HEADS_N-1,:);
%     header_all(strcmp(header_all,'')) = txt(HEADS_N-2,strcmp(header_all,''));
%
%     for i = 1:length(header_all)
%         try
%             if i == num(1,i)
%                 eval(['xls.' header_all{i} '=' num2str(i) ';']);
%             else
%                 disp('Header info error...');
%                 keyboard;
%             end
%         catch
%         end
%     end
%
%     % Delete headers
%     end_line = find(~isnan(num(:,1)),1,'last');
%     num = num(HEADS_N+1:end_line,:);
%     txt = txt(HEADS_N : end_line - 1,:); % Note here
%     raw = raw(HEADS_N+1:end_line,:);

function change_monkey_hemi(~,~)
DrawMapping(get(gcbo,'value'));



