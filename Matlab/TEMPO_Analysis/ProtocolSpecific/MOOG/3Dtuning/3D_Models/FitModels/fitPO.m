% fit poseleration-only model for 3D tuning
% time (unit: s)
% spon: spontaneous firing rate
% PSTH_data: PSTH data with sliding windows
% spatial_data: 9*5 data posording to spatial
% reps: the repetition number to perform for fiiting models
% 20180618LBY

function [modelFitRespon_PO, modelFit_PO, modelFit_PO_spatial,modelFitPara_PO, BIC_PO, RSquared_PO, rss_PO, time] = fitPO(spon,PSTH_data,spatial_data, nBins,reps,stimOnBin,stimOffBin,aMax,aMin,duration)

sprintf('Fitting PO model...')

%-- initialize global using parameters

% spatial parameters
u_Pzi = [0 45 90 135 180 225 270 315]'*pi/180;
u_ele = [-90 -45 0 45 90]'*pi/180;
s_data = [u_ele;u_Pzi]; % transform to this form for fitting
% time parameters
time = (1: (stimOffBin - stimOnBin +1))' /(stimOffBin - stimOnBin +1)*duration/1000;
st_data = [u_ele;u_Pzi;time]; % transform to this form for fitting

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

% check if the response is excitory or inhibitory
d_gauss_time = pos_func([mu sig],time);
corrcoeff_vel = xcorr(d_gauss_time, temporal_data, 'coeff');
[~,max_val] = max(abs(corrcoeff_vel));
if corrcoeff_vel(max_val) < 0,
    temporal_data = -temporal_data;
    spatial_data = -spatial_data;
end

% normalise time and spatial profile
t_P = max(temporal_data) - min(temporal_data);
s_DC = (max(spatial_data(:)) + min(spatial_data(:)))/2;
s_P = (max(spatial_data(:)) - min(spatial_data(:)))/2;
temporal_data = temporal_data/t_P;
spatial_data = (spatial_data - s_DC)/s_P;

%optimisation parameters for profile fits
options = optimset('Display', 'off', 'MaxIter', 5000);

%% initial fitting before fitting model
%-- 1st, fit time profile
mu_t = mu;
sig_t = sig;

LB = [pos_max 0.5*sig];
UB = [pos_min 2*sig];
recon_t = lsqcurvefit('pos_func', [mu_t sig_t], ...
    time, temporal_data, LB, UB, options);
obj.mu_t = recon_t(1);
obj.sig_t = recon_t(2);

%-- 2nd, fit spatial profile1

LB = [0.001 0 -pi/2];
UB = [10 2*pi pi/2];

[~, max_idx] = max(spatial_data(:));
[max_idx_P, max_idx_e] = ind2sub(size(spatial_data), max_idx);

param = [0.01 u_Pzi(max_idx_P) u_ele(max_idx_e)];
recon_v = lsqcurvefit('cos_tuning', param,  s_data, ...
    spatial_data(:), LB, UB, options);
n = recon_v(1);
a_0 = recon_v(2);
e_0 = recon_v(3);

%Initialise spatial tuning function error
ele_Pzi = cos_tuning(recon_v, s_data);
ele_Pzi = reshape(ele_Pzi, length(u_Pzi), length(u_ele));
spatial_data2 = spatial_data - ele_Pzi;

% normalise time and spatial profile
s_DC2 = (max(spatial_data2(:)) + min(spatial_data2(:)))/2;
s_P2 = (max(spatial_data2(:)) - min(spatial_data2(:)))/2;
spatial_data2 = (spatial_data2 - s_DC2)/s_P2;


%-- 3rd, fit spatial profile2
[~, max_idx] = max(spatial_data2(:));
[max_idx_P, max_idx_e] = ind2sub(size(spatial_data2), max_idx);
param = [0.01 u_Pzi(max_idx_P) u_ele(max_idx_e)];
recon_v = lsqcurvefit('cos_tuning', param,  s_data, ...
    spatial_data2(:), LB, UB, options);
n2 = recon_v(1);

[x0, y0, z0] = sph2cart(a_0, e_0, 1);
[x1, y1, z1] = sph2cart(recon_v(2), recon_v(3), 1);
v1 = [1 0 0] - [x0 y0 z0];
v2 = [x1 y1 z1] - [x0 y0 z0];
ang = acos(v1*v2'/(norm(v1)*norm(v2)));

elim = pi/3;
if ang < elim,
    ang = elim;
end
if ang > 2*pi-elim,
    ang = 2*pi-elim;
end
a2_0 = ang;
e2_0 = recon_v(3)-e_0;





%-- 4th, fit total spatial profile

% initialize fitting
% Inital fits
param = [n, ...   %1
    a_0, ... %2
    e_0, ... %3
    n2, ...  %4
    a2_0, ...%5
    e2_0, ...%6
    s_P2, ...%7
    s_DC2];    %8

LB = [0.001 0 -pi/2 0.001 0 elim 0 -2];
UB = [10 2*pi pi/2  10 pi 2*pi-elim 1 2];

recon_v = lsqcurvefit('d_cos_tuning', param, s_data, ...
    spatial_data(:), LB, UB, options);

n    = recon_v(1);
a_0  = recon_v(2);
e_0  = recon_v(3);
n2   = recon_v(4);
a2_0 = recon_v(5);
e2_0 = recon_v(6);
s_P2 = recon_v(7);
s_DC2  = recon_v(8);

%Fit linear parameters
A = t_P*s_P;
R_0 = baseline;
s_DC = s_DC/s_P;

%% fit PO model

%Inital fits
param = [A, ...       %1
    R_0, ...     %2
    mu_t, ...    %3
    sig_t, ...   %4
    n, ...       %5
    a_0, ...     %6
    e_0, ...     %7
    n2, ...      %8
    a2_0, ...    %9
    e2_0, ...    %10
    s_P2, ...    %11
    s_DC+s_DC2]; %12


init_param = zeros(reps+1, length(param));
init_param(1,:) = param;

LB = [0.25*A, ...`%1  A
    0, ...          %2  R_0
    mu-0.1, ...      %3  mu_t
    0.5*sig, ...%4  sig_t
    0.001, ...      %5  n
    0, ...          %6  a_0
    -pi/2, ...      %7  e_0
    0.001, ...      %8  n2
    0, ...          %9  a2_0
    elim, ...       %10 e2_0
    0, ...          %11 s_P2
    -2]; ...        %12 DC
    
UB = [4*A, ...    %1  A
    300, ...        %2  R_0
    mu+0.1, ...        %3  mu_t
    2*sig, ... %4  sig_t
    10, ...         %5  n
    2*pi, ...       %6  a_0
    pi/2, ...       %7  e_0
    10, ...         %8  n2
    pi, ...         %9  a2_0
    2*pi-elim, ...  %10 e2_0
    1, ...          %11 s_P2
    2];             %12 DC

rand_rss = zeros(reps+1,1);
rand_param = zeros(reps+1, length(param));
rand_jac = zeros(reps+1, length(param), length(param));

[rand_param(1,:),rand_rss(1),~,~,~,~,temp_jac] = lsqcurvefit('PO_Model', ...
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
    
    [rand_param(ii,:),rand_rss(ii),~,~,~,~,temp_jac] = lsqcurvefit('PO_Model', ...
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
respon = PO_Model(modelFitPara_PO,st_data);
modelFitRespon_PO = respon;

modelFit_PO = [];
modelFit_PO_spatial = [];
%% analysis
data_num = 26*nBins;
para_num = 6;
BIC_PO = BIC_fit(data_num,rss_PO,para_num);
TSS = sum((PSTH_data(:) - mean(PSTH_data(:))).^2);
RSquared_PO = 1 - rss_PO/TSS;

end
