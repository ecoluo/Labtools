% fit Velocity-acceleration-pos model for 3D tuning
% time (unit: s)
% spon: spontaneous firing rate
% PSTH_data: PSTH data with sliding windows
% spatial_data: 9*5 data according to spatial
% reps: the repetition number to perform for fiiting models
% 20170603LBY

function [modelFitRespon_AP,modelFit_AP, modelFit_AP_spatial, modelFitPara_AP, BIC_AP, RSquared_AP, rss_AP, time] = fitAP(spon,PSTH_data,spatial_data, nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration)

% sprintf('Fitting AP model...')

%-- initialize global using parameters

% spatial parameters
u_azi = [0 45 90 135 180 225 270 315]';
u_ele = [-90 -45 0 45 90]';
s_data = [u_ele;u_azi]; % transform to this form for fitting

% time parameters
time = (1: (stimOffBin - stimOnBin +1))' /(stimOffBin - stimOnBin +1)*duration/1000;
st_data = [u_ele;u_azi;time]; % transform to this form for fitting
% fitting initial parameters
sig = 1.5/2/4.5; % sig =  duration/2/num_of_sigma
baseline = spon;
acc_max = aMax/1000; % transfer unit from ms to s
acc_min = aMin/1000; % transfer unit from ms to s
mu = (acc_max+acc_min)/2;

% PSTH data
temporal_data = squeeze(mean(mean(PSTH_data(:,:,:),1),2)); % PSTH data according to time bin
spatial_data = permute(spatial_data,[2 1]);
y_data = permute(PSTH_data, [2 1 3]); % transform to azi*ele*timebin

% normalise temporal profile
t_A = max(temporal_data) - min(temporal_data);
% temporal_data = temporal_data/t_A;
temporal_data = (temporal_data - min(temporal_data))/t_A;

% normalise spatial profile(range[-1,1])
s_DC = (max(spatial_data(:)) + min(spatial_data(:)))/2;
s_A = (max(spatial_data(:)) - min(spatial_data(:)))/2;
spatial_data = (spatial_data - s_DC)/s_A;

%optimisation parameters for profile fits
options = optimset('Display', 'off', 'MaxIter', 5000);


%% fit VA model

R_0 = baseline;
A = t_A*s_A;
mu_0 = mu;
a_n = 1;
p_n = 1;
[~, max_idx] = max(spatial_data(:));
[max_idx_a, max_idx_e] = ind2sub(size(spatial_data), max_idx);
a_e_0 = u_ele(max_idx_e);
p_e_0 = u_ele(max_idx_e);
a_a_0 = u_azi(max_idx_a);
p_a_0 = u_azi(max_idx_a);
a_DC = 0.5;
p_DC = 0.5;
w = 0.5;
delay = 0.2;
advance = 0;

%Inital fits
param = [A, ...       %1
    R_0, ...     %2
    mu_0, ...    %3
    a_n, ...       %4
    a_a_0, ...     %5
    a_e_0, ...     %6
    a_DC,... %7
    p_n, ...           %8
    p_a_0, ...         %9
    p_e_0, ...         %10
    p_DC, ...%11
    w];                %12

init_param = zeros(reps+1, length(param));
init_param(1,:) = param;

LB = [0.25*A, ...`  %1  A
    0, ...          %2  R_0
    mu+advance, ...       %3  mu_t
    0.001, ...      %4  n
    0, ...          %5  a_0
    -90, ...      %6  e_0
    0,...          %7 v_DC
    0.001, ...      %8 a_n
    0, ...          %9 a_a_0
    -90, ...      %10 a_e_0
    0, ...         %11 a_DC
    0];             %12 wA

UB = [4*A, ...      %1  A
    300, ...        %2  R_0
    mu+delay, ...      %3  mu_t
    10, ...         %4  n
    360, ...       %5  a_0
    90, ...       %6  e_0
    1,...          %7 v_DC
    10, ...        %8 a_n
    360, ...      %9 a_a_0
    90, ...      %10 a_e_0
    1 ...         %11 a_DC
    1];            %12 wA

rand_rss = zeros(reps+1,1);
rand_param = zeros(reps+1, length(param));
rand_jac = zeros(reps+1, length(param), length(param));

[rand_param(1,:),rand_rss(1),~,~,~,~,temp_jac] = lsqcurvefit('AP_Model', ...
    init_param(1,:), st_data, y_data, LB, UB, options);
rand_jac(1,:,:) = full(temp_jac)'*full(temp_jac);
min_param = rand_param(1,:);
min_rss = rand_rss(1);
err_range =  0.1*(UB - LB);

% fitting the models
for ii = 2:(reps + 1)
    
    init_param(ii,:) = min_param;
    UB_param = min_param+err_range;
    LB_param = min_param-err_range;
    UB_param(UB < UB_param) = UB(UB < UB_param);
    LB_param(LB > LB_param) = LB(LB > LB_param);
    seed_param  = unifrnd(LB_param, UB_param);
    
    [rand_param(ii,:),rand_rss(ii),~,~,~,~,temp_jac] = lsqcurvefit('AP_Model', ...
        seed_param, st_data, y_data, LB, UB, options);
    rand_jac(ii,:,:) = full(temp_jac)'*full(temp_jac);
    
    if rand_rss(ii) < min_rss
        min_rss = rand_rss(ii);
        min_param = rand_param(ii,:);
    end
    
    
end

% find the best fit parameters according to rss
[~,min_inx] = min(rand_rss);
modelFitPara_AP = rand_param(min_inx,:);
rss_AP = rand_rss(min_inx);
jac_AP = rand_jac(min_inx,:,:);

% calculate the final model fitting values
respon = AP_Model(modelFitPara_AP,st_data);
modelFitRespon_AP = respon;

modelFit_AP.A = AP_A_Com(modelFitPara_AP([1:7,12]),st_data);
modelFit_AP.P = AP_P_Com(modelFitPara_AP([1:3,8:12]),st_data);

% model fit spatial tuning
modelFit_AP_spatial.A = cos_tuning(modelFitPara_AP(4:7),st_data(1:13));
modelFit_AP_spatial.P = cos_tuning(modelFitPara_AP(8:11),st_data(1:13));
%% analysis
data_num = 26*nBins;
para_num = 12;
BIC_AP = BIC_fit(data_num,rss_AP,para_num);
TSS = sum((PSTH_data(:) - mean(PSTH_data(:))).^2);
RSquared_AP = 1 - rss_AP/TSS;

end
