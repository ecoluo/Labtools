% fit Position-Velocity-acceleration-jerk model for 3D tuning
% time (unit: s)
% spon: spontaneous firing rate
% PSTH_data: PSTH data with sliding windows
% spatial_data: 9*5 data according to spatial
% reps: the repetition number to perform for fiiting models
% 20170603LBY

function [modelFitRespon_PVAJ, modelFit_PVAJ, modelFit_PVAJ_spatial, modelFitPara_PVAJ, BIC_PVAJ, RSquared_PVAJ, rss_PVAJ, time] = fitPVAJ_O_1D(spon,PSTH_data,spatial_data, nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration)

sprintf('Fitting PVAJ 1D model...')

%-- initialize global using parameters

% spatial parameters
u_azi = [0 45 90 135 180 225 270 315]';
s_data = [u_azi]; % transform to this form for fitting

% time parameters
time = (1: (stimOffBin - stimOnBin +1))' /(stimOffBin - stimOnBin +1)*duration/1000; % unit in s
st_data = [u_azi;time]; % spatial_time data, transform to this form for fitting

% fitting initial parameters
sig = 1.5/2/4.5; % sig =  duration/2/num_of_sigma
baseline = spon;
acc_max = aMax/1000; % transfer unit from ms to s
acc_min = aMin/1000; % transfer unit from ms to s
mu = (acc_max+acc_min)/2;

% PSTH data
temporal_data = mean(PSTH_data(:,:),1); % PSTH data according to time bin, squeeze the spatial dimension
y_data = PSTH_data; % transform to azi*timebin


% normalise temporal profile
t_A = max(temporal_data) - min(temporal_data);
temporal_data = temporal_data/t_A;

% normalise spatial profile(range[-1,1])
s_DC = (max(spatial_data) + min(spatial_data))/2;
s_A = (max(spatial_data) - min(spatial_data))/2;
spatial_data = (spatial_data - s_DC)/s_A;


%optimisation parameters for profile fits
options = optimset('Display', 'off', 'MaxIter', 5000);
%% fit PVAJ model

R_0 = baseline;
A = t_A*s_A;
mu_0 = mu;
v_n = 1;
a_n = 1;
j_n = 1;
p_n = 1;
[~, max_idx] = max(spatial_data(:));
v_a_0 = u_azi(max_idx);
a_a_0 = u_azi(max_idx);
j_a_0 = u_azi(max_idx);
p_a_0 = u_azi(max_idx);
v_DC = 0.5;
a_DC = 0.5;
j_DC = 0.5;
p_DC = 0.5;
wv = 0.25;
wj = 0.25;
wp = 0.25;
wv = 0.25;
wj = 0.25;
wp = 0.25;

v_laten = 0.1;
j_laten = 0.1;
p_laten = 0.2;

%Inital fits
param = [A, ...       %1
    R_0, ...     %2
    mu_0, ...    %3
    v_n, ...       %4
    v_a_0, ...     %5
    v_DC,... %7
    a_n, ...           %8
    a_a_0, ...         %9
    a_DC, ...%11
    j_n, ...       %12
    j_a_0, ...     %13
    j_DC,... %15
    p_n, ...       %16
    p_a_0, ...     %17
    p_DC,... %19
    wv,... %20
    wj,... %21
    wp,... %22
    v_laten, ... %23
    j_laten,... %24
    p_laten];                %25

init_param = zeros(reps+1, length(param));
init_param(1,:) = param;

LB = [0.25*A, ...`  %1  A
    0, ...          %2  R_0
    mu, ...       %3  mu_t
    0.001, ...      %4  n
    0, ...          %5  a_0
    0,...          %7 v_DC
    0.001, ...      %8 a_n
    0, ...          %9 a_a_0
    0, ...         %11 a_DC
    0.001, ...      %12  j_n
    0, ...          %13  j_a_0
    0,...          %15 j_DC
    0.001, ...      %16  j_n
    0, ...          %17  j_a_0
    0,...          %19 j_DC
    0,...           %20 wV
    0,...           %21 wJ
    0,...           %22 wP
    0,...          %23 v_laten
    0,...          %24 j_laten
    0];             %25 p_laten

UB = [4*A, ...      %1  A
    300, ...        %2  R_0
    mu+0.2, ...      %3  mu_t
    10, ...         %4  n
    360, ...       %5  a_0
    1,...          %7 v_DC
    10, ...        %8 a_n
    360, ...      %9 a_a_0
    1, ...         %11 a_DC
    10, ...        %12 a_n
    360, ...      %13 a_a_0
    1, ...         %15 a_DC
    10, ...        %16 a_n
    360, ...      %17 a_a_0
    1, ...         %19 a_DC
    1, ...         %20 wV
    1, ...         %21 wJ
    1,...           %22 wP
    0.5,...          %23 v_laten
    0.5,...          %24 j_laten
    0.5];             %25 p_laten

rand_rss = zeros(reps+1,1);
rand_param = zeros(reps+1, length(param));
rand_jac = zeros(reps+1, length(param), length(param));

[rand_param(1,:),rand_rss(1),~,~,~,~,temp_jac] = lsqcurvefit('PVAJ_Model_O_1D', ...
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
    
    [rand_param(ii,:),rand_rss(ii),~,~,~,~,temp_jac] = lsqcurvefit('PVAJ_Model_O_1D', ...
        seed_param, st_data, y_data, LB, UB, options);
    rand_jac(ii,:,:) = full(temp_jac)'*full(temp_jac);
    
    if rand_rss(ii) < min_rss
        min_rss = rand_rss(ii);
        min_param = rand_param(ii,:);
    end
    
    
end

% find the best fit parameters according to rss
[~,min_inx] = min(rand_rss);
modelFitPara_PVAJ = rand_param(min_inx,:);
rss_PVAJ = rand_rss(min_inx);
jac_PVAJ = rand_jac(min_inx,:,:);

% calculate the final model fitting values
respon = PVAJ_Model_O_1D(modelFitPara_PVAJ,st_data);
modelFitRespon_PVAJ = respon;

modelFit_PVAJ.V = PVAJ_V_Com_O_1D(modelFitPara_PVAJ([1:6,16:18,19]),st_data);
modelFit_PVAJ.A = PVAJ_A_Com_O_1D(modelFitPara_PVAJ([1:3,7:9,16:18]),st_data);
modelFit_PVAJ.J = PVAJ_J_Com_O_1D(modelFitPara_PVAJ([1:3,10:12,16:18,20]),st_data);
modelFit_PVAJ.P = PVAJ_P_Com_O_1D(modelFitPara_PVAJ([1:3,13:15,16:18,21]),st_data);

% model fit spatial tuning
modelFit_PVAJ_spatial.V = cos_tuning_1D(modelFitPara_PVAJ(4:6),st_data(1:8));
modelFit_PVAJ_spatial.A = cos_tuning_1D(modelFitPara_PVAJ(7:9),st_data(1:8));
modelFit_PVAJ_spatial.J = cos_tuning_1D(modelFitPara_PVAJ(10:12),st_data(1:8));
modelFit_PVAJ_spatial.P = cos_tuning_1D(modelFitPara_PVAJ(13:15),st_data(1:8));
%% analysis
data_num = 26*nBins;
para_num = 21;
BIC_PVAJ = BIC_fit(data_num,rss_PVAJ,para_num);
TSS = sum((PSTH_data(:) - mean(PSTH_data(:))).^2);
RSquared_PVAJ = 1 - rss_PVAJ/TSS;


end
