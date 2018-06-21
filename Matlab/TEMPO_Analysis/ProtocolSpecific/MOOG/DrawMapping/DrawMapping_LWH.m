function DrawMapping(monkey_hemi)
% DrawMapping.m
% First version by HH @ Gu Lab 2013
% Modified by Lwh 20161219

monkey_hemis = {'Ringbell_L','Ringbell_R'};%L=1,R=2

if nargin == 0
    monkey_hemi = 1; %默认hemi？
end;


%% Parameters
clc; clear global
global maxX maxY maxZ movDis GMTypes data;
global hemisphere monkey; global gridRange;
global MRI_path MRI_offset AP0;
global linWid start_end_markers overlapping Ringbell_right_AP0;% linWid??

linWid = 1.3;
overlapping = [0 0; 0 0]; start_end_markers = 1; % First row for area annotation; second for unit annotation

maxX = 30; % Grid size
maxY = 30;
maxZ = 300;   % Drawing range (in 100 um)
movDis = 150; % Maximum travel distance of the microdriver (in 100 um)

V = ones(30,30,maxZ + 30,3);  % Matrix to be rendered. The z-resolution = 100 um.
Ringbell_right_AP0 = 19.5; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918
%AP0 changed by Lwh 20161219

%% Define our area types here
GMTypes = { % 'Type', ColorCode (RGB);
    'GM',[0.7 0.7 0.7];    % Gray matter without visual modulation
    'VM',[1 0 1];          % Visual modulation but not sure to which area it belongs
    'LIP',[0 1 0];
    'VIP',[0.8 0.7 0];
    'MST',[0.8 0 0];
    'MT',[0 0 1];
    'MIP',[0.6 0.6 0.6];  % [0 0.6 0]
    %'AUD',[0.7 0 0.7]; % auditory
    };
for i = 1:length(GMTypes)
    eval([GMTypes{i,1} '= -' num2str(i) ';']);  % This is a trick. %将上面7个GM分别赋值为-1到-7
end

%% Input our mapping data here

switch monkey_hemis{monkey_hemi}
    
    case 'Ringbell_L'
        
        % Header
%         toPlotTypes3D = [ MST VIP MT LIP AUD];    % Which area types do we want to plot in 3D plot?
%         toPlotTypes_zview = [MST VIP MT LIP AUD];    % Which area types do we want to plot ?
        toPlotTypes3D = [GM VM MST VIP MT LIP];    % Which area types do we want to plot in 3D plot? 除了这些area外，其他不会plot出来
        toPlotTypes_zview = [GM VM MST VIP MT LIP];    % Which area types do we want to plot ?

        gridRange = [10 23; 1 25];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        
        monkey = 7;
        hemisphere = 1;
        AP0 = 20 ;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            % Example: {8,[11,10],[1.9 0.0],[GM 8 17; GM 58 72; VIP 95 118]}
%              {1,[20,18],[2.3,0],[GM 42 49; MST 49 51]};
%              {2,[20,20],[2.3,0],[GM 57 88; MST 89 118; MST 125 133]};
%              {3,[20,16],[2.15,0],[MST 95 107; GM 119 128]};
%              {4,[20,19],[2.3,0],[GM 38 53; MST 71 90; GM 149 150]};
%             {5,[17,15],[2.15,0],[GM 41 53; GM 82 84; VM 84 90]};
%             {6,[17,13],[2.05,0],[GM 40 67; GM 92 105; VM 145 164]};
%             {7,[17,14],[2.05,0],[GM 46 63; VM 103 109]};
%              {8,[20,14],[2.05,0],[GM 88 107; GM 133 135; MST 136 155]};
%              {9,[20,12],[2.05,0],[GM 47 87; GM 110 112; MST 113 117; GM 117 120]};
%              {9,[20,10],[1.85,0],[GM 72 91; VM 105 109; GM 109 119]};
%              {10,[20,15],[2.05,0],[GM 58 62; GM 72 91; MST 114 120; GM 120 140]};
%              {11,[20,13],[2.05,0],[GM 52 79; GM 99 114]};
%              {12,[20,9],[1.8,0],[GM 34 53; GM 77 99; GM 119 123; VM 123 127; GM 127 136]};
%              {13,[20,7],[1.7,0],[GM 31 54; GM 70 100; GM 118 134]};
% %             {14,[19,9],[1.9,0],[GM 95 110; GM 132 147]};%ELECTRODE WAS BENT
%             {15,[19,7],[1.7,0],[GM 59 79; GM 101 119; VIP 132 143; GM 143 147]};
%             {16,[19,8],[1.7,0],[GM 50 61; GM 115 121; GM 151 159]};
%             {17,[19,6],[1.7,0],[GM 78 99; GM 112 114; GM 125 133]};
%             {17,[19,10],[1.7,0],[GM 36 47; GM 90 106; GM 125 128; VM 128 134; GM 134 141]};
%             {18,[18,7],[1.7,0],[GM 43 56; GM 71 82; GM 92 103; GM 129 148]};
%             {19,[15,10],[2.0,0],[GM 112 122; GM 130 131; VIP 132 133; GM 133 138]};
%             {20,[18,8],[2.2,0],[GM 100 105; VIP 105 106; GM 106 113; GM 123 126]};
%             {21,[18,10],[2.0,0],[GM 86 104; GM 122 133]};
%             {22,[17,9],[2.0,0],[GM 33 39; GM 93 106; GM 130 137]};
%              {23,[20,21],[2.8,0],[GM 75 89; GM 121 138]};
%              {23,[20,23],[2.8,0],[MST 72 87; VM 122 145]};
%              {23,[20,24],[2.8,0],[GM 108 117; VM 117 131]};%NOT END
%             {24,[19,11],[2.0,0],[GM 102 119; VM 144 145]};%NOT END
%             {25,[19,12],[2.0,0],[VM 93 101; GM 101 112]};
%             {25,[19,14],[2.2,0],[GM 66 82]};
%             {26,[19,16],[2.4,0],[GM 28 40; MST 77 93; GM 93 96]};%NOT END
%             {26,[18,6],[1.65,0],[GM 99 105; GM 130 148]};
%             {27,[18,5],[2.0,0],[GM 21 29; GM 46 57; GM 71 82; GM 111 130]};
%             {28,[18,4],[2.0,0],[GM 10 14; GM 31 43; GM 58 68; GM 86 100]};
%             {28,[17,6],[2.2,0],[GM 93 109; VIP 123 125; GM 125 129]};
%             {29,[17,5],[2.0,0],[GM 92 100; GM 117 119; GM 135 136]};
%             {29,[17,4],[2.0,0],[GM 33 40; GM 70 77; GM 104 110]};
%             {30,[17,7],[2.0,0],[GM 62 72; GM 107 115; VIP 135 140]};
%             {30,[17,8],[2.0,0],[GM 16 27; GM 45 51; GM 75 82; GM 113 119; VIP 119 122; GM 122 131]};
%             {31,[16,4],[2.0,0],[GM 27 35; GM 57 67; GM 86 95]};
%             {31,[16,6],[2.0,0],[GM 18 36; GM 57 67; GM 76 83; GM 113 129]};
%             {32,[16,5],[2.0,0],[GM 25 31; GM 58 72; GM 90 97]};
%             {32,[16,7],[2.0,0],[GM 26 50; GM 72 84; GM 130 137]};
%             {32,[16,5],[2.0,0],[GM 25 31; GM 58 72; GM 90 97]};
%             {32,[16,7],[2.0,0],[GM 26 50; GM 72 84; GM 130 137]};
%             {34,[15,4],[2.1,0],[GM 14 34; GM 67 85; GM 98 108]};
%             {34,[15,5],[2.2,0],[GM 17 30; GM 56 72; GM 82 92]};
%             {34,[15,6],[2.2,0],[GM 13 38; GM 57 72; GM 83 88]};
%             {35,[15,7],[2.1,0],[GM 71 83]};
%             {35,[15,8],[2.1,0],[GM 89 93]};
%             {35,[15,9],[2.1,0],[GM 36 44; GM 98 114; VIP 125 131]};
%             {36,[15,11],[2.2,0],[GM 15 30; GM 96 107; VIP 108 110]};
%             {37,[16,8],[2.0,0],[GM 15 51; GM 118 123; VIP 123 128; GM 128 133]};
%             {38,[16,6],[2.0,0],[GM 29 51; GM 76 88; GM 98 104; GM 137 145]};
%             {38,[16,7],[2.0,0],[GM 14 40; GM 65 75]};
%             {38,[16,9],[2.0,0],[GM 102 128; VIP 128 130]};%NOT END
%             {39,[15,8],[2.0,0],[GM 8 14; GM 81 90]};
%             {39,[15,9],[2.0,0],[GM 22 47; GM 113 122; VIP 122 134]};
%             {40,[18,4],[2.0,0],[GM 8 21; GM 50 66; GM 82 90]};
%             {40,[18,5],[2.0,0],[GM 15 27; GM 46 59; GM 116 130]};
%             {40,[18,6],[2.0,0],[GM 37 46; GM 65 88; GM 116 145]}; 
%             {41,[14,7],[2.0,0],[GM 11 27; GM 76 92]};
%             {41,[14,8],[2.0,0],[GM 11 19]};
%             {41,[14,9],[2.0,0],[GM 8 16; GM 102 107]};
%             {41,[14,10],[2.1,0],[GM 0 1]};%ALL WHITE MATTER; ELECTORDE  MAY BE BENT
%             {42,[14,11],[2.1,0],[GM 13 31]};
%             {42,[14,12],[2.1,0],[GM 25 34]};
%              {43,[20,3],[1.85,0],[GM 17 31; GM 49 64; GM 145 147]};%END BUT STILL IN GM
%              {43,[20,4],[1.85,0],[GM 6 24; GM 43 62; GM 74 85]};
%              {43,[20,5],[2.0,0],[GM 33 46; GM 58 74; GM 104 107; VIP 107 123; GM 123 125]}; %NOT END
%             {44,[19,4],[2.0,0],[GM 15 28; GM 45 60]};
%             {44,[19,5],[2.0,0],[GM 10 32; GM 51 59; GM 74 77; GM 103 109; VIP 109 121; GM 135 143]};
%             {45,[17,6],[2.1,0],[GM 14 36; GM 56 81; VIP 112 136]};%NOT END
%             {46,[19,5],[1.8,0],[GM 33 42; GM 69 93; GM 124 143]};
%             {46,[19,6],[1.8,0],[GM 15 21; GM 35 50; GM 89 100; VIP 130 138]}; %VIP may be LIP?
            
            %20170704 Grid及Grid下牙科水泥重新涂过
            {47,[20,18],[2.75,0],[MST 23 69; MT 85 97]}; %NOT END
            {48,[20,12],[2.2 0],[GM 14 51; VM 68 73; GM 73 77]};
            {49,[20,10],[2.2 0],[GM 19 32; GM 44 75; VM 89 105]};
            {50,[20,14],[2.4 0],[GM 49 59; MST 86 128]};
            {51,[20,16],[2.7 0],[MST 33 74; MT 89 126]};
            {52,[20,16],[2.6 0],[MST 44 82; MT 102 125]};
            {53,[20,17],[2.6 0],[MST 58 105; MT 116 142]}; %微操出现问题，最好重新mapping
            {53,[20,19],[2.7 0],[MST 35 79; MT 103 129]}; %GM，WM分得不清楚，需要重新mapping
            {54,[20,13],[2.6 0],[GM 38 56; MST 89 102]};
            {54,[20,15],[2.6 0],[MST 56 74; MT 97 118]};
            {55,[19,8],[2.2 0],[GM 6 27; VM 42 63]};
            {56,[19,10],[2.2 0],[GM 20 41; VM 70 82; VM 111 122]};
            {57,[19,12],[2.3 0],[GM 16 53; VM 68 86]};
            {58,[19,14],[2.4 0],[GM 25 52; VM 52 55; GM 55 64; MST 100 129]};
            {59,[19,16],[2.8 0],[MST 34 62; MT 79 91]};%NOT END, STILL IN GM2
            {60,[19,18],[2.8 0],[GM 14 23; VM 23 26; GM 26 50; MT 79 105]};
            {61,[19,9],[2.3 0],[VM 58 77; VM 124 139]};
            {61,[19,11],[2.3 0],[GM 10 29; VM 55 70]};
            {61,[19,13],[2.3 0],[GM 31 59; GM 59 65; MST 116 133; MT 145 149]}; %NOT END, STILL IN MT
            {62,[19,15],[2.7 0],[MST 41 63; MT 108 116]};
            {63,[19,17],[2.7 0],[MT 87 109;VM 138 147]};%NOT END, STILL IN GM2
            {64,[18,11],[2.2 0],[GM 14 60; VM 73 88]};
            {64,[18,12],[2.2 0],[GM 30 63; VM 85 94]};
            {65,[18,14],[2.4 0],[GM 30 44; VM 44 53; GM 53 64; MST 97 117; MT 133 146]};
            {66,[18,16],[2.6 0],[MST 55 71; MT 101 112]};
            {67,[18,18],[2.65 0],[MST 68 95]};%NOT END
            {68,[18,15],[2.5 0],[MST 80 99; MT 117 125]};
            {69,[18,17],[2.6 0],[GM 25 39; MST 76 113; MT 130 147]};
            {70,[18,19],[2.75 0],[GM 9 24; MST 77 98; GM 128 140]};
            {71,[18,13],[2.3 0],[GM 23 57; VM 66 84]};
            {71,[18,16],[2.6 0],[MST 75 86; MT 113 123]};
            {72,[19,15],[2.65 0],[MST 52 78; MT 110 120]};
            {73,[19,16],[2.7 0],[MST 44 67; MT 91 100]};
            {74,[19,13],[2.3 0],[GM 41 64; MST 99 113; MT 132 147]};
            {75,[19,14],[2.4 0],[MST 93 131]};
            {76,[19,17],[2.5 0],[MST 57 83; MT 96 118]};
            {77,[18,14],[2.4 0],[MST 90 103; MT 127 139]};
            {78,[20,17],[2.6 0],[MST 61 83; MT 108 123]};
            {79,[20,18],[2.7 0],[GM 14 23; MST 42 63; MT 105 128]};
            {79,[20,15],[2.6 0],[GM 39 58; VM 72 85; GM 141 147]}; %STILL IN GM3 , ELECTRODE NOT GOOD, SHOULD BE MAPPING AGAIN.
            {80,[20,16],[2.6 0],[MT 103 115]};
            {80,[17,14],[2.3 0],[VM 52 77; MST 121 135]};%STILL IN GM2
%             {81,[17,15],[2.4 0],[]};  %  NO GM
            {81,[17,16],[2.5 0],[MST 91 115; MT 127 136]};
            {81,[18,15],[2.5 0],[MST 94 102]}; %NOT END, STILL IN VM
            {82,[18,16],[2.6 0],[MST 64 78; MT 104 120]};
            {82,[18,17],[2.6 0],[MST 81 86]}; %NOT END, STILL IN VM
            {83,[18,18],[2.7 0],[MST 65 90; MT 112 121]};
            {83,[18,19],[2.7 0],[GM 10 14; MST 73 79]}; %NOT END, STILL IN VM
            {84,[20,13],[2.6 0],[GM 58 76; MST 108 121]};
            {85,[20,14],[2.6 0],[GM 24 37; MST 66 98]};
            {86,[20,19],[2.75 0],[MST 45 85; MT 98 117]}; %NOT END, STILL IN GM2
            {87,[19,13],[2.4 0],[GM 31 61; MST 94 111; MT 126 132]}; %NOT END , STILL IN GM3
            {89,[19,15],[2.5 0],[MST 44 63]}; %NOT END
            {90,[19,17],[2.7 0],[MST 38 62]};%NOT END
            {91,[19,16],[2.65 0],[MST 57 82; MT 98 106]}; %NOT END , STILL IN GM2
            {91,[19,15],[2.7 0],[MST 35 46]}; %NOT END, STILL IN GM
            {92,[19,14],[2.4 0],[GM 25 56; MST 91 98]}; %NOT END, STILL IN MST
            {93,[19,14],[2.4 0],[GM 35 52; MST 97 131]};
            {94,[19,13],[2.4 0],[GM 35 50; MST 86 127]};
            {95,[18,14],[2.4 0],[MST 89 107; MT 116 129]};
            {96,[18,16],[2.6 0],[MST 77 87; MT 111 122]};
            {97,[18,18],[2.7 0],[MST 75 96]};
            {98,[18,18],[2.7 0],[MST 77 98]};
            {99,[18,15],[2.6 0],[GM 23 34; MST 77 106]}; %NOT END, STILL IN GM2
            {100,[18,15],[2.6 0],[MST 71 97]};%NOT END, STILL IN GM2
            {101,[18,17],[2.6 0],[MST 92 109; MT 115 129]};
            {102,[18,19],[2.75 0],[MST 86 92]}; %NOT END, STILL IN GM1
            {103,[18,19],[2.75 0],[MST 82 91]}; %NOT END, STILL IN GM1
            {104,[18,19],[2.75 0],[MST 81 100; MT 110 128]};
            {105,[20,19],[2.75 0],[MST 43 78; MT 101 118]};
            {105,[20,17],[2.75 0],[MST 70 92]};%NOT END, STILL IN GM1
            {106,[20,17],[2.75 0],[GM 17 19; MST 64 92]};
            {107,[20,15],[2.7 0],[GM 38 56; MST 70 85]};
            {107,[20,17],[2.7 0],[MST 72 79]};%NOT END, STILL IN GM1
            {108,[20,18],[2.7 0],[GM 31 39; MST 57 93; MT 110 116]};%NOT END, STILL IN mt
            {108,[20,16],[2.7 0],[GM 72 96]};
            {109,[20,16],[2.7 0],[MST 42 78]};
            {110,[20,16],[2.7 0],[MST 68 90; MT 103 115]};
            {111,[20,14],[2.6 0],[MST 65 99]};
            {111,[20,16],[2.7 0],[MST 75 112]};% NOT CLEAR
            {112,[20,13],[2.6 0],[GM 21 48; MST 85 99]};%NOT END, STILL IN GM2
            {113,[20,13],[2.6 0],[GM 23 45; MST 82 94]};
            {113,[17,15],[2.7 0],[GM 20 42; MST 96 106; MT 111 128]}; %GM1 IS LIP?
            {114,[17,16],[2.9 0],[MST 62 64]};
            {115,[17,16],[2.9 0],[MST 62 80; MT 90 98]};
            {116,[17,17],[2.9 0],[MST 68 83]};%Still in GM1
            {117,[17,17],[2.9 0],[MST 56 60]};%STILL IN GM1
            {118,[17,17],[2.9 0],[MST 61 68]}; %STILL IN GM1
            {119,[17,17],[2.9 0],[MST 57 87; MT 136 147]};%STILL IN GM2
            {120,[17,18],[2.9 0],[MST 53 61]};%STILL IN GM1
            {121,[17,18],[2.9 0],[MST 67 76]};%STILL IN GM1
            {122,[17,18],[2.8 0],[MST 77 92; MT 108 123]};
            {123,[17,18],[2.8 0],[MST 79 95]};%NOT END
            {124,[17,19],[2.8 0],[MST 68 93; MT 100 116]};
            {125,[17,19],[2.8 0],[GM 87 111]};
            {126,[17,20],[2.9 0],[GM 11 23; GM 68 82]}; %STILL IN GM2
            {127,[17,20],[2.9 0],[GM 73 97; GM 110 136]};
            {128,[17,21],[2.9 0],[GM 30 53; GM 79 90]};
            {129,[17,17],[2.9 0],[GM 85 89]};%STILL IN GM1
            {130,[17,17],[2.9 0],[GM 75 97]};%STILL IN GM1
            {131,[17,17],[2.8 0],[GM 90 94]};%STILL IN GM1
            {132,[17,17],[2.8 0],[GM 87 99; GM 105 108]};%STILL IN GM2
            {133,[18,19],[2.8 0],[GM 27 34; GM 80 89]};%STILL IN GM2
            {134,[18,19],[2.8 0],[GM 29 36; GM 81 96]};
            {135,[18,19],[2.8 0],[GM 83 103; GM 130 139]};
            {135,[18,18],[2.8 0],[GM 84 101]};
            {136,[18,18],[2.8 0],[GM 82 98]};
            {136,[18,15],[2.7 0],[GM 36 42; GM 90 95]};
            
       
            
            
            
%             {47,[20,18],[2.75,0],[MST 23 69; MT 85 97]}; %NOT END
%             {48,[20,12],[2.2 0],[GM 14 51; LIP 68 73; GM 73 77]};
%             {49,[20,10],[2.2 0],[GM 19 32; GM 44 75; LIP 89 105]};
%             {50,[20,14],[2.4 0],[GM 49 59; MST 86 128]};
%             {51,[20,16],[2.7 0],[MST 33 74; MT 89 126]};
%             {52,[20,16],[2.6 0],[MST 44 82; MT 102 125]};
%             {53,[20,17],[2.6 0],[MST 58 105; MT 116 142]}; %微操出现问题，最好重新mapping
%             {53,[20,19],[2.7 0],[MST 35 79; MT 103 129]}; %GM，WM分得不清楚，需要重新mapping
%             {54,[20,13],[2.6 0],[GM 38 56; MST 89 102]};
%             {54,[20,15],[2.6 0],[MST 56 74; MT 97 118]};
            
            
            
%               % by YXF
%             {143,[19,18],[1.95 0.2],[GM 21 38; MST 61 103;MT 121 148]};
%             {144,[19,20],[2.2 0.0],[GM 27 42;MST 54 100;MST 111 122]}%NOT END;
%             {145,[19,24],[2.4 0.0],[GM 31 51; MST 62 92; MT 108 135;]};%Not End
%             {164,[19,19],[2.2 0.3],[MST 48 75;]}%NOT END
            
            
           % {999,[15,15],[3.0 0.3],[GM 1 2; VM 3 4; LIP 4 5; VIP 6 7; MST 7 8; MT 8 9; MIP 9 10]}; % Just fo test: 每种GM按顺序分别为-1,-2,...-7
            };
        
        % How to mapping MRI？？？
%          MRI_path = 'Z:\Data\MOOG\Polo\Mapping\MRI\PoloOutput\forDrawMapping\';
%          MRI_offset = {[-68 79]*1.1-9.5 ,[-240 500]*1.1+23 , [0 -2.5]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}

    case 'Ringbell_R'

        
        % Header
        toPlotTypes3D = [GM MST VIP MT LIP];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [GM MST VIP MT LIP];    % Which area types do we want to plot ?

        gridRange = [0 20; 0 21];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        
        monkey = 7;
        hemisphere = 2;
        AP0 = 20;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            % Example: {1,[15,15],[2.2 0.0],[GM 4 37; GM 56 74; MST 88 117]}
           {33,[16,8],[2.2,0],[GM 77 82; GM 109 112; VIP 112 112+11; GM 112+11 112+14]} % NOT END
           {33,[15,8],[2.2,0],[GM 72 75; GM 90 104; VM 113 123]} % NOT END
            }';
        
        %MRI_path = 'Z:\Data\MOOG\Polo\Mapping\MRI\PoloOutput\forDrawMapping\';
        %MRI_offset = {[-68 79]*1.1-12  ,[-240 500]*1.1+45 , [0 -2.5]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}

end



%% ========== 3-D Visualization ========== %%

% toPlotTypes3D = [GM MST VIP MT LIP];    % Which area types do we want to plot in 3D plot?

% toPlotTypes3D = VIP ;    % Which area types do we want to plot in 3D plot?


for channel = 1:length(data)  %Data中每一列为一个channel
    gridLoc = data{channel}{2};  %[LocX(Posterior) LoxY(Lateral)]
    GMData = data{channel}{4}; % [AreaType, Begin(100um), End(100um); ...] AreaType: GM:-1;VM:-2;LIP:-3;VIP:-4;MST:-5;MT:-6;MIP:-7
    if isempty(GMData); continue; end;
    
    GuideTubeAndOffset = data{channel}{3}; % [GuideTube(cm) Offset(cm)]
    offSet = round((GuideTubeAndOffset(2) + GuideTubeAndOffset(1) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!! %round取整;  为什么减去2.0cm：figure 803中0的位置对应为guidetube 2.0cm

    
    for GMType = -size(GMTypes,1):-1  % For each area type  %GMType = -7,-6,...,-2,-1
        GMThisType = find(GMData(:,1) == GMType);   % Read out ranges for this type
        if isempty(GMThisType) || isempty(intersect(toPlotTypes3D,GMType)); continue; end       % If absent in this channel or absent in areas we want to plot, next type  %intersect:交集
        
        GMPos = [];    % Clear cache
        for i = 1:length(GMThisType)    % For each appearance
            % Attach each appearance to position cache
            GMPos = [GMPos (maxZ - offSet - GMData(GMThisType(i),3)):(maxZ - offSet - GMData(GMThisType(i),2))];
        end
        
        % Add color to positions in the cache
        try
            if hemisphere == 2
                V(gridLoc(1), maxY - gridLoc(2), GMPos, :) = repmat(GMTypes{-GMType,2},length(GMPos),1);
            else
                V(gridLoc(1), gridLoc(2), GMPos, :) = repmat(GMTypes{-GMType,2},length(GMPos),1);
            end
        catch
            fprintf('Warning: Out of Range (Session %g, Channel [%g,%g], GMType %s)\n', channel, data{channel}{2}(1), data{channel}{2}(2), GMTypes{-GMType,1});
            %keyboard;
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
            V(gridLoc(1), (gridLoc(2)),(maxZ - offSet - movDis - 1):(maxZ - offSet - movDis),:) = repmat([0 0 0],2,1);
        else
            V(gridLoc(1), (gridLoc(2)),(maxZ - offSet - data{channel}{5} - 1):(maxZ - offSet - data{channel}{5}),:) = repmat([0 0 0],2,1);
        end
    end
    
end

% Render the mapping results using "vol3d" function
%close all;
set(figure(801),'Position',[10 100 600 600]);  clf;
set(0, 'DefaultAxesXTickMode', 'auto', 'DefaultAxesYTickMode', 'auto', 'DefaultAxesZTickMode', 'auto');
vol3d('cdata',V);
view(-150,30);

axis tight;
daspect([1,1,10]);
alphamap('rampup');
alphamap(1 .* alphamap);  % Transparency透明度  %changed by Lhw 0.6 to 1

grid on;
grid minor; 
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
set(figure(802),'Position',[10 100 1100 700]); clf
hold on; 
axis equal ij;

x1 = gridRange(1,1); x2 = gridRange(1,2);
y1 = gridRange(2,1); y2 = gridRange(2,2);
xlim([y1-2,y2+2]);

% Quick select monkey_hemi. HH20160122
h_monkey_hemi = uicontrol('style','popupmenu','unit','norm','position',[0.01 0.94 0.131 0.035],...
        'string','Ringbell_L|Ringbell_R','callback',@change_monkey_hemi);
set(h_monkey_hemi,'value',monkey_hemi);

% Frame
interval = 5;
xLoc = intersect(x1:x2,0:interval:100);
yLoc = intersect(y1:y2,0:interval:100);
xLines = line(repmat([y1-1;y2+1],1,length(xLoc)),repmat(xLoc,2,1));  % xLines
yLines = line(repmat(yLoc,2,1), repmat([x1-1;x2+1],1,length(yLoc)));  % yLines
set(xLines,'LineWidth',5,'Color','g');
set(yLines,'LineWidth',5,'Color','g');
set(gca,'xtick', yLoc);
set(gca,'ytick', xLoc);

% Parallel drawing (to speed up)
xOffsets = repmat(x1:x2, y2-y1+1,1);
xOffsets = xOffsets(:)';
yOffsets = repmat([(y1:y2)+0.5*~mod(x1,2) (y1:y2)+0.5*mod(x1,2)], 1, fix((x2-x1 + 1)/2));
if mod(x2-x1+1,2) == 1
    yOffsets = [yOffsets y1:y2];
end
t = linspace(0,2*pi,100)';
xGrid = radius * repmat(sin(t),1,length(xOffsets)) + repmat(xOffsets,length(t),1);
yGrid = radius * repmat(cos(t),1,length(yOffsets)) + repmat(yOffsets,length(t),1);
set(fill(yGrid,xGrid,[1 1 1]),'LineWidth',1.5,'ButtonDownFcn',@SelectChannel);    % White color

% Plot mapping result
for channel = 1:length(data)
    xCenter = data{channel}{2}(1);
    yCenter =  data{channel}{2}(2) + 0.5 * ~mod(data{channel}{2}(1),2);
    
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
        
%         if [0.21 0.72 0.07]*(GMTypes{-haveTypes(1),2})' > 0.5
%             c = 'k';
%         else
%             c = 'y';
%         end
        c='y';
    end
    
    %------ Denotations -----%
    % Session No.
    text(yCenter, xCenter-0.1, num2str(data{channel}{1}),'FontSize',10,'color',c,'HorizontalAlignment','center','ButtonDownFcn',@SelectChannel);
    
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

% Load xls file
global num txt raw xls;
if isempty(num)
    XlsData = ReadXls('Z:\Data\MOOG\Results\Result_Lwh.xlsm',2,3);
    num = XlsData.num;
    xls = XlsData.header;
    txt = XlsData.txt;
    
    disp('Xls Loaded');
end

%% Call back for 2-D Grid View
function SelectChannel(~,~)

global maxX maxY maxZ movDis GMTypes data Ringbell_right_AP0
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
handles(3) = plot(repmat(ySelect + 0.25,1,2),[xSelect - 0.5 + overlapping(1,1) xSelect + 0.5 + overlapping(1,2)],'r','LineWid',1);

% Show corresponding sessions
sessions_match = [];
for channel = 1:length(data)
    if data{channel}{2}(1) == xSelect && data{channel}{2}(2) == ySelect
        sessions_match = [sessions_match data{channel}{1}];
    end
end

title(sprintf('Monkey %g, session(s) for %s [%g,%g]: %s',monkey,hemisphere_text{hemisphere},xSelect,ySelect,num2str(sessions_match)));


figurePosition = [700 100 100 600];
set(figure(803),'Position',figurePosition,'color','w'); clf


% 2-D Visualization (Coronal)
h_coronal = axes('Position',[0.15 0.1 0.8 0.8]);

axis ij; hold on;

%{
% Overlapping MRI data
try
    %     if hemisphere == 1 && monkey == 7
    fileNo = (xSelect - AP0) + Ringbell_right_AP0 ;  % Because I use Ringbell_right MRI as standard images
    %     elseif monkey == 10
    %         fileNo = xSelect + Polo_right_AP0 - AP0;
    %     else
    %         fileNo = xSelect + Polo_right_AP0 - AP0;
    %     end
    
    MRI = imread([MRI_path num2str(fileNo) '.bmp']);
    
    h_MRI = image(MRI_offset{1}+xSelect*MRI_offset{3}(1), MRI_offset{2} + xSelect*MRI_offset{3}(2),MRI);
    
    set(h_MRI,'AlphaData',0.7);
catch
    disp('No MRI data found...');
end

%}

% Frame
xlim([gridRange(2,1) gridRange(2,2)+1]);
ylim([-30 maxZ]);
grid minor; 
set(h_coronal,'XMinorGrid','on','XMinorTick','on'); 
% title(sprintf('Monkey %g, %s [%g, %g]',monkey, hemisphere,xSelect,ySelect));
title(sprintf('Monkey %g, %s[%g], AP ≈ %g',monkey, hemisphere_text{hemisphere},xSelect,(AP0-xSelect)*0.8));

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
        offSet = round((GuideTubeAndOffset(2) + GuideTubeAndOffset(1) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        
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
        
        % Add start and end markers
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
    set(gca,'color',[1 1 1]);
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

drawnow;


% %% Plot Tuning.  HH20140624
% figure(803);
% % % --------------- Tuning Properties
% % % Mask: monkey & hemishpere & xLoc & significant visual tuning
% mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2));
% to_plot_num = num(mask_tuning,:);
% to_plot_txt = txt(mask_tuning,:);
% 
% for i =  1:size(to_plot_num,1)
%     if strcmp(to_plot_txt(i,xls.Area),'MST')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         plot(xx,yy,'r.','linewid',0.4,'markerfacecolor','r','markersize',12);
%         %text(xx,yy,num2str(to_plot_num(i,3)));
%     elseif strcmp(to_plot_txt(i,xls.Area),'MT')
%         offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%         xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%         yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%         plot(xx,yy,'b.','linewid',0.4,'markerfacecolor','b','markersize',12);  
%         %text(xx,yy,num2str(to_plot_num(i,3)));
%     end
% end
% 
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

% --------------- Memsac Properties
% % Mask: monkey & hemishpere & xLoc & significant visual tuning
% % mask_memsac = (num(:,xls.Monkey) == monkey) & (strcmp(txt(:,xls.Hemisphere),hemisphere)) & (num(:,xls.Xloc) == xSelect) ...
% %     & (num(:,xls.p_M) < 0.05);
% mask_memsac = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ...
%     & (1|num(:,xls.p_M) < 0.05) & (strcmp(txt(:,xls.Area),'LIP')) & (num(:,xls.Chan1)>0);
% to_plot = num(mask_memsac,:);
%
% for i =  1:size(to_plot,1)
%     offSet = round((to_plot(i,xls.guidetube)  + to_plot(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%     xx = to_plot(i,xls.Yloc) + ((to_plot(i,xls.pref_M) > 0) * 0.2 + (to_plot(i,xls.pref_M) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%     yy = offSet + round(to_plot(i,xls.Depth)/100);
%     %
%     %     if to_plot(i,xls.pref_M) > 0
%     %         plot(xx,yy,'k>','linewid',1.2);
%     %     else
%     %         plot(xx,yy,'k<','linewid',1.2);
%     %     end
%     if to_plot(i,xls.p_M)<0.05
%         if to_plot(i,xls.pref_M) > 0
%             plot(xx,yy,'k>','linewid',1,'markerfacecol','g','markersize',6);
%         else
%             plot(xx,yy,'k<','linewid',1,'markerfacecol','g','markersize',6);
%             %            plot(xx,yy,'ko','linewid',1,'markerfacecol','k');
%         end
%
%     else
%         plot(to_plot(i,xls.Yloc),yy,'go','markersize',5);
%     end
% end


%{
% --------------- MemSac Properties (MU & SU)
% Mask: monkey & hemishpere & xLoc & significant visual tuning
mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & ...
    (num(:,xls.Xloc) >= xSelect + overlapping(2,1) & num(:,xls.Xloc) <= xSelect + overlapping(2,2)) ;
to_plot_num = num(mask_tuning,:);
to_plot_txt = txt(mask_tuning,:);

for i =  1:size(to_plot_num,1)
    
    if strcmp(to_plot_txt(i,xls.Protocol),'MemSac')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        
        if to_plot_num(i,xls.p_M) < 0.01 %to_plot_num(i,xls.HD_MemSac) >= 0.8  % T site
            plot(xx,yy,'ro','linewid',0.4,'markerfacecol','r','markersize',5);
            pref_M = headingToAzi(to_plot_num(i,xls.pref_M))*pi/180;
            aspect = daspect;
            plot([xx xx+0.5*cos(pref_M)*sign((hemisphere==2)-0.5)],[yy yy+(-1)*0.5*sin(pref_M)*aspect(2)/aspect(1)],'r-','linew',1.5);
        else  % non-T site
            plot(xx,yy,'ro','linewid',0.4,'markerfacecol','none','markersize',5);
        end
    end
    
end

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

%}

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


% function ReadXls()
% 
% %% Read xls for plotting tuning. HH20140624
% global num txt raw xls;
% [num,txt,raw] = xlsread('Z:\Data\MOOG\Results\Result_Lwh.xlsm',2);
% 
% % Get Header infomation
% HEADS_N = 3;
% 
% header_all = txt(HEADS_N-1,:);
% header_all(strcmp(header_all,'')) = txt(HEADS_N-2,strcmp(header_all,''));
% 
% for i = 1:length(header_all)
%     try
%         if i == num(1,i)
%             eval(['xls.' header_all{i} '=' num2str(i) ';']);
%         else
%             disp('Header info error...');
%             keyboard;
%         end
%     catch
%     end
% end
% 
% % Delete headers
% end_line = find(~isnan(num(:,1)),1,'last');
% num = num(HEADS_N+1:end_line,:);
% txt = txt(HEADS_N : end_line - 1,:); % Note here
% raw = raw(HEADS_N+1:end_line,:);

function change_monkey_hemi(~,~)
DrawMapping(get(gcbo,'value'));



