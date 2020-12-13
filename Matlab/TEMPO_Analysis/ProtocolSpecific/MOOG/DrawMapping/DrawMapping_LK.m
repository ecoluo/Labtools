function DrawMapping(monkey_hemi)
% DrawMapping.m
% First version by HH @ Gu Lab 2013
% Modified by LBY 2016-


monkey_hemis = {'WhiteFang_L_QY','WhiteFang_R_QY','WhiteFang_L','WhiteFang_R'};
colorDefsLBY; % added by LBY 20161216

if nargin == 0
    monkey_hemi = 3;
end


%% Parameters
clc; clear global
global maxX maxY maxZ movDis GMTypes data;
global hemisphere monkey; global gridRange;
global MRI_path MRI_offset AP0 MRI_path_saggital MRI_offset_saggital;
global linWid start_end_markers overlapping Qiaoqiao_right_AP0 Polo_right_AP0 WF_right_AP0;

linWid = 1.3; % linewidth for rectangles indicating mapping area
% following: area & unit overlapping in coronal planes
overlapping = [0 0; -20 20]; start_end_markers = false; % First row for area annotation; second for unit annotation
% overlapping = [0 0; 0 0]; start_end_markers = 1; % First row for area annotation; second for unit annotation, no overlapping
% overlapping = [0 0; -1 1]; start_end_markers = false; % First row for area annotation; second for unit annotation

maxX = 30; % Grid size
maxY = 30;
maxZ = 250;   % Drawing range (in 100 um)
movDis = 150; % Maximum travel distance of the microdriver (in 100 um)

V = ones(30,25,maxZ + 30,3);  % Matrix to be rendered. The z-resolution = 100 um.
Qiaoqiao_right_AP0 = 14; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918
Polo_right_AP0 = 18; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918
WF_right_AP0 = 13; % For MRI alignment. This controls MRI-AP alignment so will affect all monkeys, whereas "AP0" of each monkey below only affects AP-Grid alignment.  HH20150918

%% Define our area types here
GMTypes = { % 'Type', ColorCode (RGB);
    'GM',[0.3 0.3 0.3];    % Gray matter without visual modulation
    'WM',[1 1 1];
    'PCC',[0.2 0.8 0.2];
    'LOP',[1 0.6 0];
    'RSC',[0.8 0.2 0.2];
    'LIP',[0 1 0];
    'VIP',[1 1 0];
    'MIP',[0.6 0.6 0.6];  % [0 0.6 0]
    'V3A',[1 0 1];
    'A23',[1 0.38 0];
    'PCCu',[0.2 0.8 0.2];
    'PCCl',[0.2 0.8 0.2];
    'A7a',[0.2 0.8 0.2];
    };
for i = 1:length(GMTypes)
    eval([GMTypes{i,1} '= -' num2str(i) ';']);  % This is a trick.
end

%% Input our mapping data here

switch monkey_hemis{monkey_hemi}
    %%%%%%%%%%%%%%%%%%%% LBY 20161215 for Qiaoqiao %%%%%%%%%%%%%%%%%%%%%%%%
    case 'WhiteFang_L'
        
        %  WhiteFang_left
%         %{
        
        % Header
        toPlotTypes3D = [LOP VIP V3A A7a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [LOP VIP V3A A7a];    % Which area types do we want to plot ?
%         gridRange = [15 26; 1 11];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        gridRange = [0 10; 1 15];
        monkey = 4;
        hemisphere = 1;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0-1; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            {1,[7,8],[2.2 0],[LOP 0 89]}; %20191224

            
            }';
        
        MRI_path = 'Z:\Data\MOOG\baiya\Mapping\MRI\';
        MRI_offset = {[-90 100]-2.7,[-280 700], [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        
        case 'WhiteFang_R'
        
        %  WhiteFang_left
%         %{
        
        % Header
        toPlotTypes3D = [LOP VIP V3A A7a];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [LOP VIP V3A A7a];    % Which area types do we want to plot ?
%         gridRange = [15 26; 1 11];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        gridRange = [0 10; 1 15];
        monkey = 4;
        hemisphere = 2;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0-1; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            {1,[7,8],[2.2 0],[LOP 0 89]}; %20191224
            
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\baiya\Mapping\MRI\';
        MRI_offset = {[-90 100]-5,[-280 700], [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        
    
    case 'WhiteFang_L_QY'
        
        %  WhiteFang_left
%         %{
        
        % Header
        toPlotTypes3D = [PCCu PCCl RSC A23];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [PCCu PCCl RSC A23];    % Which area types do we want to plot ?
%         gridRange = [15 26; 1 11];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        gridRange = [15 20; 1 10];
        monkey = 4;
        hemisphere = 1;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0-1; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            {104,[20,6],[2.2 0],[PCCu 69 89; PCCl 107 111;RSC 130 147]}; %20191224
            {105,[20,5],[2.2 0],[PCCu 71 88; PCCl 107 120;RSC 144 151]}; %20191226
            {107,[18,4],[2.2 0],[PCCu 61 80; PCCl 88 107;A23 123 133;RSC 142 159]}; %20200103
            {108,[18,3],[2.2 0],[PCCu 77 82; PCCl 92 120;RSC 135 150]}; %20200106
            {109,[17,2],[2.2 0.05],[PCCu 81 95; PCCl 105 132;RSC 138 150]}; %20200109
            {110,[17,4],[2.2 0],[PCCu 83 93]}; %20200110
            {111,[17,3],[2.2 0],[PCCu 78 95; PCCl 107 118;RSC 131 146]}; %20200114
            {112,[16,3],[2.2 0],[PCCl 82 100; A23 115 120;RSC 140 150]}; %20200116
            {113,[16,4],[2.2 0],[PCCu 60 72; PCCl 85 105;RSC 140 150]}; %20200117
            {114,[20,3],[2.2 0.2],[PCCl 68 80;A23 94 98;RSC 115 125]}; %20200122
            {128,[19,4],[2.2 0],[PCCu 71 87; PCCl 95 105;RSC 125 143]}; %20200520
            {129,[20,4],[2.2 0],[PCCu 67 82; PCCl 85 105;RSC 125 144]}; %20200521
            {130,[20,3],[2.2 0],[PCCu 62 78; PCCl 85 105;RSC 125 147]}; %20200522
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\baiya\Mapping\MRI\';
        MRI_offset = {[-93 93]+1,[-455 615]+5, [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
        %}
        
    case 'WhiteFang_R_QY'
        
        %  WhiteFang_right
%         %{
        
        % Header
        toPlotTypes3D = [PCCu PCCl RSC A23];    % Which area types do we want to plot in 3D plot?
        toPlotTypes_zview = [PCCu PCCl RSC A23];    % Which area types do we want to plot ?
%         gridRange = [15 26; 1 11];  % Grid plotting ragne = [xLow xHigh; yLow yHigh]
        gridRange = [15 20; 1 10];
        monkey = 4;
        hemisphere = 2;  % L = 1, R = 2
        AP0 =  Qiaoqiao_right_AP0-1; % 6;
        
        data = {
            %{[Session(s)], [LocX(Posterior) LoxY(Lateral)], [GuideTube(cm) Offset(cm)], [AreaType, Begin(100um), End(100um); ...] , electrode retrieval}
            % When you are not sure about one area, use "AreaType-100" instead
            
            {104,[20,6],[2.2 0],[PCCu 69 89; PCCl 107 111;RSC 130 147]}; %20191224
            {105,[20,5],[2.2 0],[PCCu 71 88; PCCl 107 120;RSC 144 151]}; %20191226
            {107,[18,4],[2.2 0],[PCCu 61 80; PCCl 88 107;A23 123 133;RSC 142 159]}; %20200103
            {108,[18,3],[2.2 0],[PCCu 77 82; PCCl 92 120;RSC 135 150]}; %20200106
            {109,[17,2],[2.2 0.05],[PCCu 81 95; PCCl 105 132;RSC 138 150]}; %20200109
            {110,[17,4],[2.2 0],[PCCu 83 93]}; %20200110
            {111,[17,3],[2.2 0],[PCCu 78 95; PCCl 107 118;RSC 131 146]}; %20200114
            {112,[16,3],[2.2 0],[PCCl 82 100; A23 115 120;RSC 140 150]}; %20200116
            {113,[16,4],[2.2 0],[PCCu 60 72; PCCl 85 105;RSC 140 150]}; %20200117
            {114,[20,3],[2.2 0.2],[PCCl 68 80;A23 94 98;RSC 115 125]}; %20200122
            {128,[19,4],[2.2 0],[PCCu 71 87; PCCl 95 105;RSC 125 143]}; %20200520
            {129,[20,4],[2.2 0],[PCCu 67 82; PCCl 85 105;RSC 125 144]}; %20200521
            {130,[20,3],[2.2 0],[PCCu 62 78; PCCl 85 105;RSC 125 147]}; %20200522
            
            }';
        
        MRI_path = 'Z:\Data\MOOG\baiya\Mapping\MRI\';
        MRI_offset = {[-93 93]+1,[-455 615]+5, [0 1]};   % [x1 x2],[y1 y2], [dx/dxSelect slope, dy/dxSelect slope]
        
        
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
    'string','WF_L_QY|WF_R_QY|WF_L|WF_R','callback',@change_monkey_hemi);
set(h_monkey_hemi,'value',monkey_hemi);

% Frame
% changed sth.for Qiaoqiao  LBY20161216
interval = 5;
xLoc = intersect(x1:x2,1:interval:100);
yLoc = intersect(y1:y2,1:interval:100);
xLines = line(repmat([y1-1;y2+1],1,length(xLoc)),repmat(xLoc,2,1));  % xLines
switch monkey_hemis{monkey_hemi} % changed sth.for Qiaoqiao's new grid(left hemi)  LBY20170927
    case {'WhiteFang_R_QY','WhiteFang_R'}
        yLines = line(repmat(yLoc+0.25,2,1), repmat([x1-1;x2+1],1,length(yLoc)));  % yLines
    case {'WhiteFang_L_QY','WhiteFang_L'}
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
    case {'WhiteFang_R_QY','WhiteFang_R'}
        xGrid = radius * repmat(sin(t),1,length(xOffsets)) + repmat(xOffsets,length(t),1);
    case {'WhiteFang_L_QY','WhiteFang_L'}
        xGrid = radius * repmat(sin(t),1,length(xOffsets)) + repmat(xOffsets+1,length(t),1);
end
yGrid = radius * repmat(cos(t),1,length(yOffsets)) + repmat(yOffsets,length(t),1);
set(fill(yGrid,xGrid,[1 1 1]),'LineWidth',1.5,'ButtonDownFcn',@SelectChannel);    % White color



% Plot mapping result
for channel = 1:length(data)
    xCenter = data{channel}{2}(1);
    switch monkey_hemis{monkey_hemi} % changed sth.for Qiaoqiao's new grid(left hemi)  LBY20170927
        case {'WhiteFang_R_QY','WhiteFang_R'}
            yCenter =  data{channel}{2}(2) + 0.5 * ~mod(data{channel}{2}(1),2);
        case {'WhiteFang_L_QY','WhiteFang_L'}
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
        XlsData = ReadXls('Z:\Data\MOOG\Results\Result_LK.xlsm',2,3);
    num = XlsData.num;
    xls = XlsData.header;
    txt = XlsData.txt;
    
    disp('Xls Loaded');
end

%% Call back for 2-D Grid View
function SelectChannel(~,~)

global maxX maxY maxZ movDis GMTypes data Qiaoqiao_right_AP0 Polo_right_AP0 WF_right_AP0
global MRI_path MRI_offset AP0 MRI_path_saggital MRI_offset_saggital;
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
    elseif monkey == 4
%         fileNo = xSelect + WF_right_AP0 - AP0;
fileNo = xSelect;
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
% title(sprintf('Monkey %g, %s[%g], AP ¡Ö %g',monkey, hemisphere_text{hemisphere},xSelect,(AP0-xSelect)*0.8));
% add minus for Qiaoqiao LBY20161219
title(sprintf('Coronal M%g, %s[%g,x], AP ¡Ö %g',monkey, hemisphere_text{hemisphere},xSelect,-(AP0-xSelect)*0.8));

% Keep scale
aspectRatio = (range(ylim) * 100) / (range(xlim) * 800);  % grid interval = 0.8 mm
set(figure(803),'Position',[figurePosition(1:2) figurePosition(4)/aspectRatio figurePosition(4)]);


for channel = 1:length(data)
    %     if data{channel}{2}(1) == xSelect  % Only plot the line we select
    if data{channel}{2}(1) >= xSelect + overlapping(1,1) && data{channel}{2}(1) <= xSelect + overlapping(1,2)   % Overlapping neighboring slices
        yLoc = data{channel}{2}(2)-0.5;
        GMData = data{channel}{4};
        if isempty(GMData); continue; end
        
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

%-------------------   for sagittal plane  -----------------------%
%{
figurePositionSagittal = [-1050 100 1000 400];
set(figure(804),'Position',figurePositionSagittal, 'color','w'); clf;
h_saggital = axes('Position',[0.1 0.1 0.85 0.8]);
axis ij; hold on;

% Overlapping MRI data (sagittal plane)
try
    fileNo = ySelect;
    
    if hemisphere == 2
        MRI_saggital = imread([MRI_path_saggital, '+' ,num2str(fileNo) '.jpg']);
        h_MRI_saggital = image(MRI_offset_saggital{1}+ySelect*MRI_offset_saggital{3}(1), MRI_offset_saggital{2} + ySelect*MRI_offset_saggital{3}(2),MRI_saggital);
    elseif hemisphere == 1
        MRI_saggital = imread([MRI_path_saggital, '-' ,num2str(fileNo) '.jpg']);
        h_MRI_saggital = image(MRI_offset_saggital{1}+ySelect*MRI_offset_saggital{3}(1), MRI_offset_saggital{2} + ySelect*MRI_offset_saggital{3}(2),MRI_saggital);
    end
    %     set(h_MRI,'AlphaData',0.7);
catch
    disp('No MRI data found...');
end

% Frame
xlim([gridRange(1,1)-20 gridRange(1,2)+20]);
set(gca,'xtick',[gridRange(1,1)-20:5:gridRange(1,2)+20]);
ylim([-30 maxZ]); 
grid minor;
set(h_saggital,'XMinorGrid','on','XMinorTick','on');
% add minus for Qiaoqiao LBY20161219
title(sprintf('Sagittal M%g, %s, AP ¡Ö %g, ML = %g ',monkey, hemisphere_text{hemisphere},-(AP0-xSelect)*0.8,ySelect));

% Keep scale
aspectRatio = (range(ylim) * 100) / (range(xlim) * 800);  % grid interval = 0.8 mm
set(figure(804),'Position',[-1000 figurePositionSagittal(2) figurePositionSagittal(4)/aspectRatio figurePositionSagittal(4)]);

for channel = 1:length(data)
    if data{channel}{2}(2) >= ySelect + overlapping(1,1) && data{channel}{2}(2) <= ySelect + overlapping(1,2)   % Overlapping neighboring slices
        xLoc = data{channel}{2}(1)-0.5;
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
                    p = patch([xLoc xLoc xLoc+1 xLoc+1],[zEnd,zBegin,zBegin,zEnd],GMTypes{-GMType,2},'EdgeColor','none','FaceAlpha',0.4);
                else
                    rectangle('Position',[xLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,...
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
                rectangle('Position',[xLoc,zBegin,1,zEnd-zBegin],'LineWidth',linWid,'EdgeColor',GMTypes{-GMType,2},'LineStyle',':');
            end
            
        end
        
        % Add start and end markers
        if start_end_markers
            if xLoc+0.5 == xSelect
                col_temp = 'c';
                rectangle('Position',[yLoc,offSet,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                offSet_selected = offSet;
                if length(data{channel})<5
                    rectangle('Position',[xLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                else
                    rectangle('Position',[xLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor',col_temp,'EdgeColor',col_temp);
                end
            else
                rectangle('Position',[xLoc,offSet,1,1],'LineWidth',linWid,'FaceColor','k');
                if length(data{channel})<5
                    rectangle('Position',[xLoc,offSet + movDis,1,1],'LineWidth',linWid,'FaceColor','k');
                else
                    rectangle('Position',[xLoc,offSet + data{channel}{5},1,1],'LineWidth',linWid,'FaceColor','k');
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
    set(804,'color',[0.5 0.5 0.5]);
    %     set(gcf,'foregroundcolor','w');
end

if start_end_markers
    % Channel indicator
    plot(xlim,[xSelect xSelect],'r--','LineW',0.5);
end

xlabel('Grid X No. (x 0.8 mm)');

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
%}
drawnow;



%% Plot Tuning.  HH20140624
colorDefsLBY; 
%-------------------   for coronal plane  -----------------------%

figure(803);
% added by LBY 20180605
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
%         if strcmp(to_plot_txt(i,xls.Protocol),'DelSac')
%             offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
%             xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
%             yy = offSet + round(to_plot_num(i,xls.Depth)/100);
%             plot(xx,yy,'yo','linewid',1,'markersize',8);
%             end
        if strcmp(to_plot_txt(i,xls.Area),'PCCl') || strcmp(to_plot_txt(i,xls.Area),'PCCu')
            offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
            xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
            yy = offSet + round(to_plot_num(i,xls.Depth)/100);
            plot(xx,yy,'.','color','g','markersize',18);
        end
    if strcmp(to_plot_txt(i,xls.Area),'PCC')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color','g','markersize',18);
    end
    if strcmp(to_plot_txt(i,xls.Area),'A23')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color',[1 0.38 0],'markersize',18);
    end
    if strcmp(to_plot_txt(i,xls.Area),'RSC')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Yloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color','r','markersize',18);
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

%-------------------   for sagittal plane  -----------------------%
%{
figure(804);

% --------------- temporal-spatial Properties (MU & SU) --------------------------%
% Mask: monkey & hemishpere & xLoc & significant visual tuning
mask_tuning = (num(:,xls.Monkey) == monkey) & num(:,xls.Hemisphere)==hemisphere & ...
    (num(:,xls.Yloc) >= ySelect + overlapping(2,1) & num(:,xls.Yloc) <= ySelect + overlapping(2,2)) ;
to_plot_num = num(mask_tuning,:);
to_plot_txt = txt(mask_tuning,:);

for i =  1:size(to_plot_num,1)
if strcmp(to_plot_txt(i,xls.Area),'PCCl') || strcmp(to_plot_txt(i,xls.Area),'PCCu')
            offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
            xx = to_plot_num(i,xls.Xloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
            yy = offSet + round(to_plot_num(i,xls.Depth)/100);
            plot(xx,yy,'.','color','g','markersize',18);
        end
    if strcmp(to_plot_txt(i,xls.Area),'PCC')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Xloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color','g','markersize',18);
    end
    if strcmp(to_plot_txt(i,xls.Area),'A23')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Xloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color',[1 0.38 0],'markersize',18);
    end
    if strcmp(to_plot_txt(i,xls.Area),'RSC')
        offSet = round((to_plot_num(i,xls.guidetube)  + to_plot_num(i,xls.offset) - 2.0) * 100);  % Related to Guide Tube 2.0 cm!!
        xx = to_plot_num(i,xls.Xloc); % + ((to_plot(i,xls.Pref_vis) > 0) * 0.2 + (to_plot(i,xls.Pref_vis) <= 0) * -0.2)*sign((hemisphere==2)-0.5);  % Left and Right Prefer
        yy = offSet + round(to_plot_num(i,xls.Depth)/100);
        plot(xx,yy,'.','color','r','markersize',18);
    end
end
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



