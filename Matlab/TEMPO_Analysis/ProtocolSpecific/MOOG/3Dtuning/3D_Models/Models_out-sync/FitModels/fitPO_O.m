% fit poseleration-only model for 3D tuning
% time (unit: s)
% spon: spontaneous firing rate
% PSTH_data: PSTH data with sliding windows
% spatial_data: 9*5 data posording to spatial
% reps: the repetition number to perform for fiiting models
% 20180618LBY

function [modelFitRespon_PO, modelFit_PO, modelFit_PO_spatial,modelFitPara_PO, BIC_PO, RSquared_PO, rss_PO, time] = fitPO_O(spon,PSTH_data,spatial_data, nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration)

% sprintf('Fitting PO model...')

%-- initialize global using parameters

% spatial parameters
u_azi = [0 45 90 135 180 225 270 315]';
u_ele = [-90 -45 0 45 90]';
s_data = [u_ele;u_azi]; % transform to this form for fitting

% time parameters
time = (1: (stimOffBin - stimOnBin +1))' /(stimOffBin - stimOnBin +1)*duration/1000;
st_data = [u_ele;u_azi;time]; % transform to this form for fitting

% fitting initial parameters
sig = sqrt(sqrt(2))/6;
baseline = spon;
pos_max = aMax/1000; % transfer unit from ms to s
pos_min = aMin/1000; % transfer unit from ms to s
mu = (pos_max+pos_min)/2;

% PSTH data
temporal_data = squeeze(mean(mean(PSTH_data(:,:,:),1),2)); % PSTH data posording to time bin
spatial_data = permute(spatial_data,[2 1]);
y_data = permute(PSTH_data, [2 1 3]); % transform to azi*ele*timebin

% check if the response is excitory or inhibitory and normalize sign
gauss_time = pos_func([mu sig],time); % theoretical time profile
[corrcoeff_vel,lags] = xcorr(gauss_time, temporal_data,20, 'coeff');
neg_lags_idx = lags < 0;
neg_lags = lags(neg_lags_idx);
[~,max_val] = max(abs(corrcoeff_vel(neg_lags_idx)));
delay_i = neg_lags(max_val);
peak_i = find(time >= mu, 1, 'first')-1;

% find the initial mu
mu_0 = time(peak_i - delay_i);

if corrcoeff_vel(max_val) < 0,
    temporal_data = -temporal_data;
    spatial_data = -spatial_data;
end

% normalise temporal profile
t_A = max(temporal_data) - min(temporal_data);
temporal_data = temporal_data/t_A;

% normalise spatial profile(range[-1,1])
s_DC = (max(spatial_data(:)) + min(spatial_data(:)))/2;
s_A = (max(spatial_data(:)) - min(spatial_data(:)))/2;
spatial_data = (spatial_data - s_DC)/s_A;

%optimisation parameters for profile fits
options = optimset('Display', 'off', 'MaxIter', 5000);

%% fitting model
%-- 1st, fit spatial profile

% %{
LB = [0.001 0 -90 0];
UB = [10 360 90 2];

[~, max_idx] = max(spatial_data(:));
[max_idx_a, max_idx_e] = ind2sub(size(spatial_data), max_idx);

param = [0.01 u_ele(max_idx_e) u_azi(max_idx_a) 0.5];
%}

%{
LB = [0.001 0 -90];
UB = [10 360 90];

[~, max_idx] = max(spatial_data(:));
[max_idx_a, max_idx_e] = ind2sub(size(spatial_data), max_idx);

param = [0.01 u_ele(max_idx_a) u_azi(max_idx_e)];
%}
recon_v = lsqcurvefit('cos_tuning', param,  s_data, ...
    spatial_data(:), LB, UB, options);
n = recon_v(1);
a_0 = recon_v(2);
e_0 = recon_v(3);
DC = recon_v(4);

R_0 = baseline;
A = t_A*s_A;

%-- 2nd, fit PO model

%Inital fits
param = [A, ...  %1
    R_0, ...     %2
    mu_0, ...    %3
    n, ...       %4
    a_0, ...     %5
    e_0, ...     %6
    DC,...       %7
    ];


init_param = zeros(reps+1, length(param));
init_param(1,:) = param;

LB = [0.25*A, ...`  %1  A amplitude
    0, ...          %2  R_0 baseline
    mu, ...         %3  mu_0
    0.001, ...      %4  n
    0, ...          %5  a_0
    -90, ...      %6  e_0
    0,...       %7
    ];
    
UB = [4*A, ...      %1  A
    300, ...        %2  R_0
    mu+0.2, ...     %3  mu_0
    10, ...         %4  n
    360, ...       %5  a_0
    90, ...       %6  e_0
    1,...       %7
    ];

rand_rss = zeros(reps+1,1);
rand_param = zeros(reps+1, length(param));
rand_jac = zeros(reps+1, length(param), length(param));

[rand_param(1,:),rand_rss(1),~,~,~,~,temp_jac] = lsqcurvefit('PO_Model_O', ...
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
    
    [rand_param(ii,:),rand_rss(ii),~,~,~,~,temp_jac] = lsqcurvefit('PO_Model_O', ...
        seed_param, st_data, y_data, LB, UB, options);
    rand_jac(ii,:,:) = full(temp_jac)'*full(temp_jac);
    
    if rand_rss(ii) < min_rss
        min_rss = rand_rss(ii);
        min_param = rand_param(ii,:);
    end
    
    
end

% find the best fit parameters posording to rss
[~,min_inx] = min(rand_rss);
modelFitPara_PO = rand_param(min_inx,:);
rss_PO = rand_rss(min_inx);
jac_PO = rand_jac(min_inx,:,:);

% calculate the final model fitting values
respon = PO_Model_O(modelFitPara_PO,st_data);
modelFitRespon_PO = respon;

modelFit_PO = [];
modelFit_PO_spatial = [];
%% analysis
data_num = 26*nBins;
para_num = 7;
BIC_PO = BIC_fit(data_num,rss_PO,para_num);
TSS = sum((PSTH_data(:) - mean(PSTH_data(:))).^2);
RSquared_PO = 1 - rss_PO/TSS;

end
