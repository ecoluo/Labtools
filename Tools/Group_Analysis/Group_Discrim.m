% Population anlysis for Heading/Rotation Discrimination/Fixation tasks
% LBY 20190624

function function_handles = Group_Discrim(XlsData,if_tolerance)

%% Get data

num = XlsData.num;
txt = XlsData.txt;
raw = XlsData.raw;
header = XlsData.header;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BATCH address
mat_address = {
    % name of folder; tag; Protocol
    
    'Z:\Data\TEMPO\BATCH\20190130_Discrim_PCC_m5','PSTH_Discrim','HD';
    
    
    %--------------------MSTd
    
    };


% %{
mask_all = {
    strcmp(txt(:,header.Protocol),'HD') ...
    & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
%     strcmp(txt(:,header.Protocol),'RD') ...
%     & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
    
    }; % Now no constraint on monkeys
%}

% PCCl
%{
mask_all = {
    strcmp(txt(:,header.Protocol),'HD') & ~strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'RD');
    strcmp(txt(:,header.Protocol),'3DR') & ~strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    strcmp(txt(:,header.Protocol),'HD') & strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    strcmp(txt(:,header.Protocol),'RD') & strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCl');
    
    }; % Now no constraint on monkeys
%}

% PCCu
%{
mask_all = {
    strcmp(txt(:,header.Protocol),'HD') & ~strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'RD') & ~strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'HD') & strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    strcmp(txt(:,header.Protocol),'RD') & strcmp(txt(:,header.Dark),'1')...
    & strcmp(txt(:,header.Area),'PCCu');
    
    }; % Now no constraint on monkeys
%}



% % Add flexible monkey mask here (but I've still decided to choose monkey for analysis below). HH20150723
monkey_included_for_loading = [5];
Monkeys{5} = 'Polo';

% MSTd
%{
mask_all = {
    strcmp(txt(:,header.Protocol),'HD') & (strcmp(txt(:,header.Area),'MSTd'));
    
    }; % Now no constraint on monkeys


monkey_included_for_loading = [3 1];
Monkeys{3} = 'Que';
Monkeys{1} = 'Zebulon';

%}

monkey_mask_for_loading = false(size(num,1),1);
for mm = 1:length(monkey_included_for_loading)
    monkey_mask_for_loading = monkey_mask_for_loading | (num(:,header.Monkey) == monkey_included_for_loading(mm));
end

% Now apply monkey mask
for mm = 1:length(mask_all)
    mask_all{mm} = mask_all{mm} & monkey_mask_for_loading;
end

%{
% if monkey == 1 % Qiaoqiao
%     mat_address = 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m6\';
%     mask_all = (strcmp(txt(:,header.Protocol),'3DT')| strcmp(txt(:,header.Protocol),'3DR') ) & (num(:,header.Monkey) == 6) & ~strcmp(txt(:,header.Dark),'1') & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
% elseif monkey == 2 % Polo
%     mat_address = 'Z:\Data\TEMPO\BATCH\20181008_3DTuning_PCC_m5\';
%     mask_all = (strcmp(txt(:,header.Protocol),'3DT')| strcmp(txt(:,header.Protocol),'3DR') ) & (num(:,header.Monkey) == 5) &  ~strcmp(txt(:,header.Dark),'1') & (strcmp(txt(:,header.Area),'PCCl')| strcmp(txt(:,header.Area),'PCCu') );
% end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cell_true = [];

for pp = 1:size(mat_address,1)
    % Xls Data
    xls_num{pp} = num(mask_all{pp},:);
    xls_txt{pp} = txt(mask_all{pp},:);
    xls_raw{pp} = raw(mask_all{pp},:);
    
    % Basic information : E.g.  '20140721m05s034h2x04y12d08478u6m5c67r2'
    % date,monkey,session,hemi,xloc,yloc,depth,unit
    cell_info_tmp = xls_num{pp}(:,[header.Date:header.Yloc header.Depth header.Chan1]);
    
    % Override MU with SU. HH20150422
    cell_info_tmp(xls_num{pp}(:,header.Units_RealSU)==1 & xls_num{pp}(:,header.Chan1)==1,end) = 5;
    
    cell_info{pp} = strsplit(sprintf('%8dm%02ds%03dh%01dx%02dy%02dd%05du%02d\n',cell_info_tmp'),'\n')';
    cell_info{pp} = strcat(cell_info{pp}(1:end-1),xls_txt{pp}(:,header.FileNo));
    cell_true = cat(1,cell_true,cell_info{pp});
end
cd(mat_address{1,1});

% to find exactly how many cells
cell_true = cellfun(@(x) x(1:end-2),cell_true,'UniformOutput',false);
cell_true = unique(cell_true);

%% Establish mat-to-xls relationship and load data into group_result.mat

global group_result; % This lets me reload the whole m.file without loading group_result, which speeds up my debugging.

%
if isempty(group_result)
    group_result(size(cell_true,1)).cellID = [];  % The unique cellID
    load_group_result();
end

    function load_group_result()
        %
        % Load .mat files and put the data into a large structure array "group_result(i).mat_raw"
        
        tic;
        progressbar('Load .mat files');
        not_match(size(mat_address,1)) = 0;
        
        for major_i = 1:length(group_result) % Major protocol loop
            group_result(major_i).monkeyID = str2double(cell_true{major_i}(34));
            for pp = 1:size(mat_address,1) % pp is the index of cells
                
                %%%% Get basic information for cellID
                
                %1 Search for corresponding files in .mat
                match_i = find(strncmp(cell_true{major_i},cell_info{pp},38));
                
                if ~isempty(match_i) % have >1 match
                    file_i = match_i;
                else % no this protocol for this cell
                    %                     fprintf('No exact matched files for %s, ID = %s\n', mat_address{pp,3},cell_true{major_i}(30:end));
                    not_match(pp) = not_match(pp) + 1;
                    file_i = NaN;
                end
                
                %2 Load .mat
                if ~isnan(file_i)
                    try
                        for ii = 1:length(file_i)
                            mat_file_name = sprintf('%s_%g',xls_txt{pp}{file_i(ii),header.FileNo},xls_num{pp}(file_i(ii),header.Chan1));
                            mat_file_fullname = [mat_address{pp,1} '\' mat_file_name '_' mat_address{pp,2}];
                            
                            raw = load(mat_file_fullname);
                            group_result(major_i).cellID{pp}{ii} = cell_info{pp}{file_i(ii)};
                            
                            
                            group_result(major_i).('mat_raw'){pp}{ii} = raw.result;  % Dynamic structure
                            
                        end
                    catch
                        fprintf('Error Loading %s\n',[mat_file_name '_' mat_address{pp,3}]);
                        keyboard;
                    end
                    
                else
                    group_result(major_i).cellID{pp} = [];
                    group_result(major_i).('mat_raw'){pp} = [];
                end
            end
            progressbar(major_i/length(group_result));
        end
        toc
        fprintf('\nLoaded %g cells\n\n ',length(group_result));
        for pp = 1:size(mat_address,1)
            fprintf('%s, %g cells\n ',mat_address{pp,3},length(group_result)-not_match(pp));
        end
        
    end

%% Get some values from group_result(i).mat_raw_xxx our to group_result(i) for easier access

stimType = {'vestibular';'visual'};

for i = 1:length(group_result)
    for pp = 1:size(mat_address,1)
        if isempty(group_result(i).mat_raw{pp}) % no this protocol for this cell
            group_result(i).uStimType{pp} = [];
            group_result(i).responSig{pp} = [];
            group_result(i).data_PCA{pp} = [];
        else
            for ii = 1:length(group_result(i).mat_raw{pp}) % >= one files for this protocol                
                group_result(i).uStimType{pp}{ii} = group_result(i).mat_raw{pp}{ii}.unique_stimType;
                group_result(i).data_PCA{pp}{ii} = group_result(i).mat_raw{pp}{ii}.tuning_PCA;
                group_result(i).responSig{pp}{ii} = group_result(i).mat_raw{pp}{ii}.respon_sigTrue;
            end
        end
    end
    
end


% ------ Load Gaussian velocity -----
% Measured by accelerometer at System building room 212 (TEMPO 1).
% 20161220&20180731, measured 2 times, results are similar, LBY
temp = load('Z:\Data\TEMPO\BATCH\TEMPO1_Acceleration_sigma4_5p_11');
% [time_vel,veloc_value,time_acc,accel_value] = Real_acc_vel;

%% Reorganize data into matrices which are easier to plot and compare


nBins = group_result(1).mat_raw{1}{1}.nBins;
PCAStep = group_result(1).mat_raw{1}{1}.stepSize_CP;
nBinsPCA = group_result(1).mat_raw{1}{1}.nBinsPCA;
duration = group_result(1).mat_raw{1}{1}.duration; % unit in ms
% totalBinT = group_result(1).mat_raw{1}{1}.duration + group_result(1).mat_raw{1}{1}.tOffset1{1} + group_result(1).mat_raw{1}{1}.tOffset2{1};
stimOnBin = group_result(1).mat_raw{1}{1}.stimOnBin;
stimOffBin = group_result(1).mat_raw{1}{1}.stimOffBin;
% initialize with NaN

for pp = 1:size(mat_address,1)
    % independent on stim types
    uStimType{pp} = zeros(size(cell_true,1),3);
    responSig{pp} = NaN(size(cell_true,1),length(stimType));
end
% re-organize data according to stim types
for pp = 1:size(mat_address,1)
    for i = 1:length(group_result)
        if ~isempty(group_result(i).uStimType{pp})
            for ii = 1:length(group_result(i).uStimType{pp})
                for jj = (group_result(i).uStimType{pp}{ii})'
                    % dependent on stim types
                    uStimType{pp}(i,jj) = 1;
                    responSig{pp}(i,jj) = group_result(i).responSig{pp}{ii}(find(group_result(i).uStimType{pp}{ii} == jj));
                    data_PCA{pp}{jj}{i} = group_result(i).data_PCA{pp}{ii}{find(group_result(i).uStimType{pp}{ii} == jj)}(:,:,2)';
                end
            end
        end
    end
    uStimType{pp}(:,3) = (uStimType{pp}(:,1)) & (uStimType{pp}(:,2));
end

% Classify cells
% %{
for pp = 1:size(mat_address,1)
    
    
    % cells classified according to temporal response
    temporalSig_i{pp}(:,1) = responSig{pp}(:,1) == 1;
    temporalSig_i{pp}(:,2) = responSig{pp}(:,2) == 1;
    temporalSig_i{pp}(:,3) = temporalSig_i{pp}(:,1) & temporalSig_i{pp}(:,2);
    
end
%}
PSTH_PCA = [];
cell_nums = [];
monkey_included_for_analysis = [];
select_all = [];select_temporalSig = [];select_spatialSig = [];
cell_selection();

%% Cell Selection and Cell Counter

    function cell_selection(t_cell_selection_num)  % Cell Selection and Cell Counter
        
        if nargin < 1
            t_cell_selection_num = 2; % Default
        end
        
        t_cell_selection_criteria = ...
            {  %  Logic     Notes
            % all
            'All cells',    uStimType;
            
            % temporally based
            'Cells are temporally tuned',temporalSig_i;
            };
        
        
        select_tcells_all_monkey = t_cell_selection_criteria{t_cell_selection_num,2};
        
        % -------- Update actual dataset for analysis. --------
        monkey_included_for_analysis = monkey_included_for_loading(logical(get(findall(gcbf,'tag','Polo_data'),'value')));
        monkey_mask_for_analysis = false(length(group_result),1);
        for mm = 1:length(monkey_included_for_analysis)
            monkey_mask_for_analysis = monkey_mask_for_analysis | (cat(1,group_result.monkeyID) == monkey_included_for_analysis(mm));
        end
        
        % -------- Count cell numbers for each monkey.  --------
        cell_nums_toPrint = nan(4,1);
        
        n_monkey = length(monkey_included_for_loading);
        for pp = 1:size(mat_address,1)
            cell_nums{pp} = zeros(length(stimType),n_monkey+1); % Vestibulat/visual
            for mm = 1:n_monkey
                for jj = 1: 2
                    select_monkey{mm} = cat(1,group_result.monkeyID) == monkey_included_for_loading(mm);
                    cell_nums{pp}(jj,mm) = sum(select_tcells_all_monkey{pp}(:,jj) & select_monkey{mm});
                    cell_nums{pp}(jj,n_monkey+1) = sum(select_tcells_all_monkey{pp}(:,jj) & monkey_mask_for_analysis); % cell in use
                end
            end
            cell_nums_toPrint(:,pp) = cell_nums{pp}(:);
        end
        
        
        
        % -------- Affect all analysis below --------
        for pp = 1:size(mat_address,1)
            for jj = 1:3
                select_all{pp}(:,jj) = uStimType{pp}(:,jj) & monkey_mask_for_analysis;
                select_temporalSig{pp}(:,jj) = temporalSig_i{pp}(:,jj) & monkey_mask_for_analysis;
%                 select_spatialSig{pp}(:,jj) = spatialSig_i{pp}(:,jj) & monkey_mask_for_analysis;
                
            end
        end
        % -------- Update cell counter ---------
        
        h_all = findall(gcbf,'tag','num_all_units');
        set(h_all,'string',sprintf('%3d%6d%9d%6d\n',cell_nums_toPrint'),'fontsize',12.5);
        
        
        h_t_criterion = findall(gcbf,'tag','t_criterion');
        set(h_t_criterion,'string',{t_cell_selection_criteria{:,1}});
        set(h_t_criterion,'value',t_cell_selection_num);
        
    end
%% Load DrawMapping data to get the cell location. HH20161024


%% Final Preparation

% =========== Data for common use ============
function_handles = [];

% to prepare for which monkey is in use to print to figures
monkey_to_print = [];
for ii = 1:length(monkey_included_for_analysis)
    monkey_to_print = [monkey_to_print,Monkeys{monkey_included_for_analysis(ii)},'   '];
end

% ================ Miscellaneous ===================
set(0,'defaultaxesfontsize',12);
% colorDefsLBY;
% Condition = {'Translation','Rotation','T_dark','R_dark'};
%
% set(0,'defaultAxesColorOrder',[0 0 1; 1 0 0; 0 0.8 0.4;]);
colors = {'b','r'};
markers = {'o','^'};
lines = {'-',':'};
transparent = .5;
figN = 2499;
nHist = 11;
%
% marker_for_time_markers{1} = {'-','-','--'};
% marker_for_time_markers{2} = {'--','--','-'};

% time markers
% time_markers = group_result(1).mat_raw{1}{1}.markers;
% markerName % markerTime % marker bin time % color

%% ====================================== Function Handles =============================================%

function_handles = {
    'behaviour', {
    'Psychometric function', @f1p1;
    '    Mean PSTH', @f1p1p1;
    '    Peak distribution', @f1p1p2;
    };
    
    'Neural data', {
    'PCA',@f2p1
    '    ''Eigen-Time''',@f2p1p1;
    '    ''Eigen-Neuron''',@f2p1p2;
    };
    
    'Others',{
    'Cell Counter',@f3p1;
    'Test',@f3p2;
    };
    
    'NoShow',{@cell_selection};
    
    };

% %{
responNo = [];

a = 3;
b = 3;
c = 3;
%}

%{
%% Sigma time course
set(figure(3),'position',[19 85 1388 535]); clf
for k = 1:3
    plot(sigmas(:,k),[colors{k} 'o'],'markerfacecol',colors{k},'markersize',10); hold on;
    plot(smooth(sigmas(:,k),30,'rloess'),['-' colors{k}],'linewid',2);
end
plot(sigma_pred,'go','markersize',10,'linewidt',1.5);
% plot(coh);
xlabel('Session');
ylabel('Threshold');

ylim([1 20]); xlim([0 n+2]);
set(gca,'YScale','log','Ytick',[1:10 20]);

Annotation(date,tf,glass);

SetFigure();

%% u time course
set(figure(4),'position',[19 85 1388 535]); clf
plot([0 n],[0 0],'k--','linew',2);
hold on

for k = 1:3
    plot(us(:,k),[colors{k} 'o'],'markerfacecol',colors{k},'markersize',10);
    plot(smooth(us(:,k),30,'rloess'),['-' colors{k}],'linewid',2);
end
% plot(u_pred,'go','markersize',13,'linewidt',1.5);
xlabel('Session');
ylabel('Bias');
ylim([-5 5]); xlim([0 n+2]);

Annotation(date,tf,glass);


SetFigure();

%% Prediction ratio time course
sigma_pred_ratio = sigmas(:,3)./sigma_pred;

set(figure(5),'position',[19 85 1388 535]);
clf;
plot([0 n],[1 1],'k--','linew',2); hold on;

failureBegin = 72;

% Min threshold
% plot(min(sigmas(:,1:2),[],2)./sigma_pred,'v','color',[0.5 0.5 0.5],'markerfacecol',[0.5 0.5 0.5]);
plot(smooth(min(sigmas(:,1:2),[],2)./sigma_pred,20,'rloess'),['-.k'],'linewid',2);
% plot(max(sigmas(:,1:2),[],2)./sigma_pred,'k^','markerfacecol','k');
plot(smooth(max(sigmas(:,1:2),[],2)./sigma_pred,20,'rloess'),['-.k'],'linewid',2);


% plot(1:failureBegin-1,sigma_pred_ratio(1:failureBegin-1),'ks','markerfacecol','k','markersize',9);
% plot(failureBegin:n, sigma_pred_ratio(failureBegin:end),'ks','markersize',9);

if ~showPlatform
    scatter(1:n,sigma_pred_ratio,150,linspace(0,1,n),'fill','s');
else
    for pp = 1:length(platforms)
        ind = find(platform == platforms(pp));
        plot(ind,sigma_pred_ratio(ind),'s','color',platformColor{pp},'markerfacecol',platformColor{pp},'markersize',9);
    end
end


plot(smooth(sigma_pred_ratio,30,'rloess'),['-k'],'linewid',2);


ylim([0.3 3]); xlim([0 n+2]);
set(gca,'YScale','log','Ytick',[0.5 1 2:3]);

xlabel('Session');
ylabel('Prediction ratio');
% ylabel('Prediction ratio = actual / predicted threshold');

Annotation(date,tf,glass);

SetFigure();


% %{
%% Correlations

h = LinCorr(6,sigmas(:,1)./sigmas(:,2),sigma_pred_ratio,1,1,failureBegin);
xlabel('Log ( vesibular / visual threshold)');
ylabel('Log ( prediction ratio )');
SetFigure()

h = LinCorr(16,max(sigmas(:,1:2),[],2)./min(sigmas(:,1:2),[],2),sigma_pred_ratio,1,1,failureBegin);
xlabel('Mismatching = log ( max / min threshold)');
ylabel('Log ( prediction ratio )');
SetFigure()




%%
% figure(7); clf

LinCorr(7,sigma_pred,sigmas(:,3),0,0,failureBegin);

% plot(sigma_pred(1:failureBegin-1),sigmas(1:failureBegin-1,3),'ko','markersize',10,'markerfacecol','k');
% plot(sigma_pred(failureBegin:end),sigmas(failureBegin:end,3),'ko','markersize',10,'linew',2);

xlabel('Predicted threshold)');
ylabel('Actual threshold');
plot([1 6],[1 6],'--k');

axis([1.1 6 1.1 6]);
axis square;
SetFigure();

%%
LinCorr(17,sigma_pred,sigma_pred_ratio,1,1,failureBegin);

% plot(sigma_pred(1:failureBegin-1),sigmas(1:failureBegin-1,3),'ko','markersize',10,'markerfacecol','k');
% plot(sigma_pred(failureBegin:end),sigmas(failureBegin:end,3),'ko','markersize',10,'linew',2);

xlabel('Log (predicted threshold)');
ylabel('Log (prediction ratio)');
SetFigure();

%%
LinCorr(8,sigmas(:,1),sigma_pred_ratio,1,1,failureBegin);

% figure(8); clf
% plot(sigmas(:,1),sigma_pred_ratio,'ok');
xlabel('Log (vestibular threshold)');
ylabel('Log (prediction ratio)');

SetFigure();

%%
LinCorr(9,sigmas(:,2),sigma_pred_ratio,1,1,failureBegin);

% figure(9); clf
% plot(sigmas(:,2),sigma_pred_ratio,'ok');
xlabel('Log (visual threshold)');
ylabel('Log (prediction ratio)');

SetFigure();

%%
LinCorr(10,min(sigmas(:,1:2),[],2),sigma_pred_ratio,1,1,failureBegin);

% plot(min(sigmas(:,1:2),[],2),sigma_pred_ratio,'ok');
xlabel('Log (Min threshold)');
ylabel('Log (prediction ratio)');

SetFigure();

%%
LinCorr(11,max(sigmas(:,1:2),[],2),sigma_pred_ratio,1,1,failureBegin);

% plot(max(sigmas(:,1:2),[],2),sigma_pred_ratio,'ok');
xlabel('Log (Max threshold)');
ylabel('Log (prediction ratio)');

SetFigure();

%%
keyboard;

%%}


    function Annotation(date,tf,glass)
        
        % Same day
        diff0 = find(diff(date)== 0);
        diff0_begs = [diff0(1); diff0(1+find(diff(diff0)>1))];
        diff0_ends = [diff0(diff(diff0)>1) ;diff0(end)]+1;
        ylims = ylim;
        xlims = xlim;
        
        for j = 1:length(diff0_begs);
            plot([diff0_begs(j)-0.2 diff0_ends(j)+0.2],[ylims(1) ylims(1)],'k-','linewid',10);
        end
        
        % Not working
        plot([70 70],ylims,'--k','linewi',2);
        plot([74 74],ylims,'--k','linewi',2);
        
        
        % Target first v.s. 3D glass
        a1 = gca;
        pos = get(gca,'Position');
        a2 = axes('position',[pos(1) pos(2)+pos(4) pos(3) 0.03]);
        
        [xx, yy]=meshgrid(1:length(date),0);
        plot(xx(logical(tf)),yy(logical(tf)),'cs','markerfacecolor','c'); hold on;
        
        [xx, yy]=meshgrid(1:length(date),1);
        plot(xx(logical(glass)),yy(logical(glass)),'ms','markerfacecolor','m');
        
        axis off;
        xlim(xlims); ylim([0 1])
        linkprop([a1 a2],'xlim');
        
        
        function h = LinCorr(figN,x,y,logx,logy,seperate)
            set(figure(figN),'position',[180 93 818 679]); clf;
            
            nanInd = or(isnan(x),isnan(y));
            x(nanInd) = [];
            y(nanInd) = [];
            
            if logx
                xx = log(x);
            else
                xx = x;
            end
            
            if logy
                yy = log(y);
            else
                yy = y;
            end
            
            ind = [1 seperate length(x)];
            markerfacecolors = {'k','none',[0.8 0.8 0.8]};
            linestyles = {'b-','r-','k-'};
            
            % All fitting
            [r,p] = corr(xx,yy,'type','spearman');
            [para,S]=polyfit(xx,yy,1);
            
            xxx = min(xx):0.1:max(xx);
            Y = polyval(para,xxx);
            h(10+length(ind)) = plot(xxx,Y,'k','linewidth',2);  hold on;
            
            text(xxx(end),Y(end),sprintf('r = %3.3f \n p = %3.3f',r,p),'color','k');
            scatter(xx,yy,70,linspace(0,1,length(xx)),'fill');
            
            
            % Seperate draw points and fitting
            
            for i = 1:(length(ind)-1)
                thisX = xx(ind(i):ind(i+1));
                thisY = yy(ind(i):ind(i+1));
                
                %     h(i) =  scatter(thisX,thisY,100,linspace(0,1,length(thisX)),'fill');
                
                %     h(i) = plot(thisX,thisY,'ko','markersize',7,'markerfacecol',markerfacecolors{i}); hold on;
                
                [r,p] = corr(thisX,thisY,'type','spearman');
                [para,S]=polyfit(thisX,thisY,1);
                
                xxx = min(thisX):0.1:max(thisX);
                Y = polyval(para,xxx);
                h(i+10) = plot(xxx,Y,[linestyles{i}],'linewidth',2);
                
                text(xxx(end),Y(end),sprintf('r = %3.3f \n p = %3.3f',r,p),'color',linestyles{i}(1));
            end
        end
    end
%}

function f2p1p1(debug)      % PCA,'Eigen-Time'
        if debug  ; dbstack;   keyboard;      end
        
        denoised_dim = 4; % how many PCs you want to plot
        
%                 for pp = 1:2
        for pp = 1
            for jj = 1:2
%                 temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                temp = data_PCA{pp}{jj}; % do not select neurons with temporal tuning
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),9,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},1),size(dataPCA_raw{pp}{jj},1),1))./repmat(std(dataPCA_raw{pp}{jj},1,1),size(dataPCA_raw{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj}' * weights_PCA_PC{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                                %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},1),size(dataPCA_raw1{pp}{jj},1),1))./repmat(std(dataPCA_raw1{pp}{jj},1,1),size(dataPCA_raw1{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj}' * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                %{
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},1),size(dataPCA_raw2{pp}{jj},1),1))./repmat(std(dataPCA_raw2{pp}{jj},1,1),size(dataPCA_raw2{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj}' * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                %}
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                %{
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(9,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},1),size(dataPCA_raw3{pp}{jj},1),1))./repmat(std(dataPCA_raw3{pp}{jj},1,1),size(dataPCA_raw3{pp}{jj},1),1); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj}');
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj}' * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                %}
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %{
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}, projPC{pp}{jj}{3}], 3,'start','uniform','emptyaction','drop');
                figure;
                col = {'b', 'r', 'g', 'k', 'm'};
                
                % Add colors according to the sorting result.
                for i=1: length(unique(Index{pp}{jj}))
                    plot(1:75,dataPCA_raw{pp}{jj}(:,Index{pp}{jj}==i),col{i}); hold on;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %}
                
            end
        end
        
        
        
        % ============   Weight distribution of PCs ===========
        %         %{
        %         colorsPCA{1} = {[8 32 51]/255,[23 70 107]/255,[15 139 184]/255,[138 188 209]/255,[204 207 226]/255,[239 239 247]/255};
        %         colorsPCA{2} = {[90 19 27]/255,[192 44 38]/255,[221 82 96]/255,[240 161 168]/255,[230 210 213]/255,[249 244 245]/255};
        colorsPCA{1} = {'b', 'r', 'g', 'k', 'm','c'};
        colorsPCA{2} = {'b', 'r', 'g', 'k', 'm','c'};
        labels = {{'T, vesti','T, vis'},{'R, vesti','R, vis'}};
        ds = 1:denoised_dim;
        
        %%%%%%%%%%%%%%%0
        figure(10);set(figure(10),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
%                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA{pp}{jj},1);
                for ii = 1:denoised_dim
                    %                     
%                     plot(PCA_times,weights_PCA_PC{pp}{jj}(:,ii),'k-','color',colorsPCA{jj}{ii},'linewidth',4);hold on;
axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});

                    
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC{pp}{jj}(:)) max(weights_PCA_PC{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All directions');
                SetFigure(12);
        
        %%%%%%%%%%%%%%%1
        %{
figure(20);set(figure(20),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA1{pp}{jj},1);
               
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC1{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC1{pp}{jj}(:)) max(weights_PCA_PC1{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(with all directions)');
                SetFigure(12);
        %}
        %%%%%%%%%%%%%%%2
        %{
        figure(20);set(figure(20),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
                for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA2{pp}{jj},1);
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC2{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC2{pp}{jj}(:)) max(weights_PCA_PC2{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(Preferred direction)');
                SetFigure(12);
        %}
        %%%%%%%%%%%%%%%3
        %{
figure(30);set(figure(30),'name','Eigen-time','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                PCA_times = 1:size(dataPCA3{pp}{jj},1);
                
                for ii = 1:denoised_dim
                   axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(PCA_times,weights_PCA_PC3{pp}{jj}(:,ii),'k-','linewidth',3,'color',colorsPCA{jj}{ii});
                end
                xlim([0 length(PCA_times)])
                    ylim([min(weights_PCA_PC3{pp}{jj}(:)) max(weights_PCA_PC3{pp}{jj}(:))]);
                                        xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'}); axis on;
%                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
                title(labels{pp}{jj});
                legend('PC1','PC2','PC3','PC4','PC5','PC6');
            end
                end
                
        suptitle('Eigen-time, All neurons(max & min direction)');
                SetFigure(12);
        %}
        %}
        
        % ============   clusters of neurons of different directions ===========
        %{
        %%%%%%%%%%%%%%%0 将每一个方向全部打乱
%         %{
        figure(17);set(figure(17),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC{pp}{jj}{1},projPC{pp}{jj}{2},projPC{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(18);set(figure(18),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC{pp}{jj}{1}(Index{pp}{jj}==i),projPC{pp}{jj}{2}(Index{pp}{jj}==i),projPC{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
        %{
        figure(27);set(figure(27),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
        for pp = 1:2
            for jj = 1:2
               
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC1{pp}{jj}{1},projPC1{pp}{jj}{2},projPC1{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(28);set(figure(28),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
        for pp = 1:2
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC1{pp}{jj}{1}, projPC1{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC1{pp}{jj}{1}(Index{pp}{jj}==i),projPC1{pp}{jj}{2}(Index{pp}{jj}==i),projPC1{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
        %{
        %---------------- raw data
        figure(37);set(figure(37),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
%         for pp = 1:2
            for pp = 1
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC2{pp}{jj}{1},projPC2{pp}{jj}{2},projPC2{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        %---------------- kmeans cluster
        figure(38);set(figure(38),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
%         for pp = 1:2
for pp = 1
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC2{pp}{jj}{1}, projPC2{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC2{pp}{jj}{1}(Index{pp}{jj}==i),projPC2{pp}{jj}{2}(Index{pp}{jj}==i),projPC2{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        
        %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
        %{
        figure(47);set(figure(47),'name','Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        numClassics = 3;
        
        for pp = 1:2
            for jj = 1:2
                
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot3(projPC3{pp}{jj}{1},projPC3{pp}{jj}{2},projPC3{pp}{jj}{3},'k.','color',colors{jj});
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        
        figure(48);set(figure(48),'name','Kmeans Cluster: PC1 - PC2 - PC3','unit','pixels','pos',[-1000 -400 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        figure;
        col = {'b', 'r', 'g', 'k', 'm'};
        
        for pp = 1:2
            for jj = 1:2
                [Index{pp}{jj},~] = kmeans([projPC3{pp}{jj}{1}, projPC3{pp}{jj}{2}], numClassics,'start','uniform','emptyaction','drop');
                axes(h_subplot((jj-1)*2+pp));hold on;
                for i=1: length(unique(Index{pp}{jj}))
                    plot3(projPC3{pp}{jj}{1}(Index{pp}{jj}==i),projPC3{pp}{jj}{2}(Index{pp}{jj}==i),projPC3{pp}{jj}{3}(Index{pp}{jj}==i),[col{i} '.']);
                end
                xlabel('PC1');ylabel('PC2');zlabel('PC3');
                view(3);axis on;
            end
        end
        SetFigure(12);
        %}
        %}
        
        % ============   Variance explained =================
%                 %{
        %%%%%%%%%%%%%%%%%0
        figure(15);set(figure(15),'name','Variance explained, All directions','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
%                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained{pp}{jj}))', cumsum(PCA_explained{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        axes('unit','pixels','pos',[20 20 900 20]);hold on;
        text(0.25,0,'Translation');text(0.8,0,'Rotation');
        axis off;
        SetFigure(12);
        
        %%%%%%%%%%%%%%%%%1
        %{
        figure(25);set(figure(25),'name','Variance explained, All neurons (with all directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained1{pp}{jj}))', cumsum(PCA_explained1{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained1{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained1{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained1{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained1{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained1{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%2
        %{
        figure(35);set(figure(35),'name','Variance explained, All neurons (Preferred directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
                for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained2{pp}{jj}))', cumsum(PCA_explained2{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained2{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained2{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained2{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained2{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained2{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%3
        %{
        figure(45);set(figure(45),'name','Variance explained, All neurons (Preferred + Null directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained3{pp}{jj}))', cumsum(PCA_explained3{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained3{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained3{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained3{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained3{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained3{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        
        % ============  3. 2-D Trajectory  ===========
        %{
        figure(16);set(figure(16),'name','Population Dynamics','unit','pixels','pos',[-1000 -300 900 400]); clf;hold on;
        %         [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        for pp = 1:2
            for jj = 1:2
                plot(weights_PCA_PC{pp}{jj}(1,1),weights_PCA_PC{pp}{jj}(1,2),'k.','color',colors{jj},'markersize',20);
                plot(weights_PCA_PC{pp}{jj}(:,1),weights_PCA_PC{pp}{jj}(:,2),'k-','color',colors{jj},'linewidth',2,'linestyle',lines{pp});
                axis square;
            end
        end
        xlabel('PC1'); ylabel('PC2'); axis on;
        SetFigure(12);
        %}
        
        %}
        
    end

function f2p1p2(debug)      % PCA,'Eigen-Neuron'
        if debug  ; dbstack;   keyboard;      end
        
        denoised_dim = 4; % how many PCs you want to plot
        
%         for pp = 1:2
                    for pp = 1
            for jj = 1:2
                temp = data_PCA{pp}{jj}(select_temporalSig{pp}(:,jj));
                
                %%%%%%%%%%%%%%%0 将每一个方向全部打乱
                dataPCA_raw{pp}{jj} = reshape(permute(reshape(cell2mat(temp),9,nBinsPCA,[]),[2 1 3]),nBinsPCA,[]);
                dataPCA{pp}{jj} = (dataPCA_raw{pp}{jj} - repmat(mean(dataPCA_raw{pp}{jj},2),1,size(dataPCA_raw{pp}{jj},2)))./repmat(std(dataPCA_raw{pp}{jj},1,2),1,size(dataPCA_raw{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC{pp}{jj}, score{pp}{jj}, latent{pp}{jj}, ~, PCA_explained{pp}{jj}] = pca(dataPCA{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC{pp}{jj}{ii} = dataPCA_raw{pp}{jj} * weights_PCA_PC{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%1 对每个神经元按照最大反应方向排序
                %{
                dataPCA_raw1{pp}{jj} = cell2mat(cellfun(@(x) x(:),temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA1{pp}{jj} = (dataPCA_raw1{pp}{jj} - repmat(mean(dataPCA_raw1{pp}{jj},2),1,size(dataPCA_raw1{pp}{jj},2)))./repmat(std(dataPCA_raw1{pp}{jj},1,2),1,size(dataPCA_raw1{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC1{pp}{jj}, score1{pp}{jj}, latent1{pp}{jj}, ~, PCA_explained1{pp}{jj}] = pca(dataPCA1{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC1{pp}{jj}{ii} = dataPCA_raw1{pp}{jj} * weights_PCA_PC1{pp}{jj}(:,ii);
                end
                %}
                
                %%%%%%%%%%%%%%%2 只要最大反应方向（Preferred direction）
                dataPCA_raw2{pp}{jj} = cell2mat(cellfun(@(x) x(1,:)',temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                % dataPCA{pp}{jj}(sum(isnan(dataPCA{pp}{jj}),2)>0,:) = [];
                dataPCA2{pp}{jj} = (dataPCA_raw2{pp}{jj} - repmat(mean(dataPCA_raw2{pp}{jj},2),1,size(dataPCA_raw2{pp}{jj},2)))./repmat(std(dataPCA_raw2{pp}{jj},1,2),1,size(dataPCA_raw2{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC2{pp}{jj}, score2{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained2{pp}{jj}] = pca(dataPCA2{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC2{pp}{jj}{ii} = dataPCA_raw2{pp}{jj} * weights_PCA_PC2{pp}{jj}(:,ii);
                end
                
                %%%%%%%%%%%%%%%3 最大反应方向+最小反应方向（Preferred direction+Null condition）
                %{
                dataPCA_raw3{pp}{jj} = cell2mat(cellfun(@(x) [x(1,:)'; x(9,:)'],temp,'UniformOutput',false)); % (nBins*directions)*cells, the first direction is the max at the first peak time
                dataPCA3{pp}{jj} = (dataPCA_raw3{pp}{jj} - repmat(mean(dataPCA_raw3{pp}{jj},2),1,size(dataPCA_raw3{pp}{jj},2)))./repmat(std(dataPCA_raw3{pp}{jj},1,2),1,size(dataPCA_raw3{pp}{jj},2)); % z-score Normalize
                [weights_PCA_PC3{pp}{jj}, score3{pp}{jj}, latent2{pp}{jj}, ~, PCA_explained3{pp}{jj}] = pca(dataPCA3{pp}{jj});
                
                % latent: eigenvalues
                for ii = 1:denoised_dim
                    projPC3{pp}{jj}{ii} = dataPCA_raw3{pp}{jj} * weights_PCA_PC3{pp}{jj}(:,ii);
                end
                %}
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %{
                [Index{pp}{jj},~] = kmeans([projPC{pp}{jj}{1}, projPC{pp}{jj}{2}, projPC{pp}{jj}{3}], 3,'start','uniform','emptyaction','drop');
                figure;
                col = {'b', 'r', 'g', 'k', 'm'};
                
                % Add colors according to the sorting result.
                for i=1: length(unique(Index{pp}{jj}))
                    plot(1:75,dataPCA_raw{pp}{jj}(:,Index{pp}{jj}==i),col{i}); hold on;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %}
                
            end
        end
        
        
        %%%%%%%%%%%%%%%%%figures
        colors = {'b', 'r', 'g', 'k', 'm'};
        labels = {{'T, vesti','T, vis'},{'R, vesti','R, vis'}};
        % ============   1-D Trajectory of Eigen-neurons ===========
        %         %{
        %%%%%%%%%%%%%%%0 将每一个方向全部打乱
        %         %{
        figure(16);set(figure(16),'name','Eigen-neurons','unit','pixels','pos',[-1000 300 900 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        PCA_times = 1:size(dataPCA{pp}{jj},1);
%         for pp = 1:2
            for pp = 1
            for jj = 1:2
                for ii = 1:denoised_dim
                    axes(h_subplot((jj-1)*2+pp));hold on;
                    plot(1:length(projPC{pp}{jj}{ii}),projPC{pp}{jj}{ii},'k-','linewidth',3,'color',colors{ii});
                end
                axis on;legend('PC1','PC2','PC3','PC4');
                    xlim([0 length(PCA_times)])
%                     ylim([min(projPC{pp}{jj}{ii}(:)) max(projPC{pp}{jj}{ii}(:))]);
                    %                     xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/3:length(PCA_times),'xticklabel',{'0','500','1000','1500'});title(['Eigen-time PC' num2str(ii)]); axis on;
                    xlabel('time (s)'); ylabel('Firing rate (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','1500'});
                title(labels{pp}{jj});
            end
        end
        suptitle('Eigen-neurons, firing rate');
        SetFigure(12);
        %}
        
        % ============   Variance explained =================
%         %{
        %%%%%%%%%%%%%%%%%0
        figure(15);set(figure(15),'name','Variance explained, All directions','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
%                 for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained{pp}{jj}))', cumsum(PCA_explained{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        axes('unit','pixels','pos',[20 20 900 20]);hold on;
        text(0.25,0,'Translation');text(0.8,0,'Rotation');
        axis off;
        SetFigure(12);
        
        %%%%%%%%%%%%%%%%%1
        %{
        figure(25);set(figure(25),'name','Variance explained, All neurons (with all directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained1{pp}{jj}))', cumsum(PCA_explained1{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained1{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained1{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained1{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained1{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained1{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%2
        %{
        figure(35);set(figure(35),'name','Variance explained, All neurons (Preferred directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        %         for pp = 1:2
        for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained2{pp}{jj}))', cumsum(PCA_explained2{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained2{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained2{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained2{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained2{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained2{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %%%%%%%%%%%%%%%%%3
        %{
        figure(45);set(figure(45),'name','Variance explained, All neurons (Preferred + Null directions)','unit','pixels','pos',[-1070 300 1050 600]); clf;
        [~,h_subplot] = tight_subplot(2,2,0.1,0.15,[0.1 0.1]);
        
        for pp = 1:2
%         for pp = 1
            for jj = 1:2
                axes(h_subplot((jj-1)*2+pp));hold on;
                plot((1:length(PCA_explained3{pp}{jj}))', cumsum(PCA_explained3{pp}{jj}),'o-','markersize',8,'linew',1.5);
                plot((1:denoised_dim)',cumsum(PCA_explained3{pp}{jj}(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
                plot([0 1],[0 PCA_explained3{pp}{jj}(1)],'r-','linew',1.5);
                plot(xlim,[1 1]*sum(PCA_explained3{pp}{jj}(1:denoised_dim)),'r--');
                text(denoised_dim,sum(PCA_explained3{pp}{jj}(1:denoised_dim))*0.9,[num2str(sum(PCA_explained3{pp}{jj}(1:denoised_dim))) '%'],'color','r');
                xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;
            end
        end
        SetFigure(12);
        %}
        %}
        
    end


end





