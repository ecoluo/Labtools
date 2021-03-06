% datadir = 'Z:\Data\Tempo\Baskin\Analysis\CuedDirecDiscrim_Unfolded_RT\LongDurCells\'
% datadir = 'Z:\Data\Tempo\Baskin\Analysis\CuedDirecDiscrim_Unfolded_RT\ShortDurCells\'
datadir = 'Z:\Data\Tempo\Baskin\Analysis\CuedDirecDiscrim_Unfolded_RT\ShortDurDelayCells\'
d = ls(datadir);
d = d(3:end,:);
% exclude_cells = [1 4 9 15 17 31 40 43 47 51 52 53 57 60]; %for long dur cells
% exclude_cells = [0]; %for shortdur cells
% exclude_cells = [2 15 18]; %for Baskin shortdur+delay cells
bask_longdur_exclude = {'m4c243r6','m4c250r5','m4c257r6','m4c262r5',...
    'm4c266r5','m4c267r7','m4c276r5','m4c284r5','m4c285r5',...
    'm4c186r5','m4c193r5','m4c204r6','m4c215r7','m4c221r6',... %
    'm4c239r5','m4c252r5','m4c253r5','m4c259r5','m4c267r7','m4c276r5','m4c282r5',...
    'm4c283r5','m4c290r6','m4c293r5'};
bask_shortdur_exclude = {};
bask_shortdur_delay_exclude = {'m4c313r5','m4c356r5','m4c361r5','m4c390r5','m4c401r5','m4c412r5','m4c413r5','m4c414r5','m4c423r5'};
data_exclude = bask_shortdur_delay_exclude; %set this to the monkey and task version whose data you're combining


coher = [-32 -16 -8 -4 0 4 8 16 32];
cum_rt = [];
for i = 1:size(d,1)
    if ~ismember(d(i,4:11), data_exclude)
        c = importdata(sprintf('%s%s',datadir,d(i,:)));
        cum_rt(:,:,end+1) = c(2:6,:); %indices of mean rt at each coherence at each of 4+1(avg) conditions
    end
end
cum_rt = cum_rt(:,:,2:end); %not sure why it's making a matrix of zeros at [:,:,1] 
n_cells = size(cum_rt,3);
plot_colors = {'bs','ro','g>'};
plot_lines = {'b','r','g','k'};
mean_rt = mean(cum_rt,3);
std_rt = std(cum_rt,0,3);
se_rt = std_rt./sqrt(n_cells);

figure; hold on;
inds = [1 2 3 5]; %corresponds to invalid, neutral, valid, and cueonly respectively
for i = 1:3
%     subplot(3,1,i);
    errorbar(coher, mean_rt(inds(i),:), se_rt(inds(i),:), plot_lines{i},'LineWidth',1);
    xlim([(min(coher)-1) (max(coher)+1)]);
end
xlabel('Coherence (%)'); ylabel('Reaction Time (ms)');
title(sprintf('(n=%d)',n_cells));
    
%2-way repeated measures anova, using cue validity and coherence as factors
y = reshape(cum_rt(1:3,:,:),n_cells*9*3,1);
cells = reshape(repmat(1:n_cells,27,1),n_cells*9*3,1);
f1 = repmat([1:3]', n_cells*9,1); %cuedir
f2 = reshape(repmat(1:9,3,n_cells),n_cells*9*3,1);
f1name = 'cue_val'; f2name = 'coher';
p_rt = rm_anova2(y,cells,f1,f2,{f1name, f2name})

% mean_psychdata = mean(cum_psychdata,3);
% std_psychdata = std(cum_psychdata,0,3);
% figure; hold on;
% for i = 1:3
%     fit_data(:,1) = coher';
%     fit_data(:,3) = size(cum_psychdata,3);
%     fit_data(:,2) = mean_psychdata(i,:);
%     [group_alpha(i) group_beta(i)] = logistic_fit(fit_data);
%     fit_x = [0:0.1:max(coher)];
%     fit_y(i,:) = logistic_curve(fit_x,[group_alpha(i) group_beta(i)]);
%     plot(coher,mean_psychdata(i,:),plot_colors{i});
%     plot(fit_x,fit_y(i,:),plot_lines{i});
% end

temp = [coher' mean_rt'; coher' se_rt'];
save('Z:\LabTools\Matlab\TEMPO_Analysis\ProtocolSpecific\CuedDirectionDiscrim\group_unfolded_ rt_shortdurdelay.txt', '-ascii', 'temp')