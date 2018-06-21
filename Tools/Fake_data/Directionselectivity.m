% compute preferred direction, strength of direction selectivity and assess
% significance of direction tuning, GY

clear all;

% construct data first
% raw data format
% column: stimulus direction, assume 0:45:315 deg but could be anything from 0 to 360 with regular interval; 
% row: number of trials at each direction, assume 5 repetitions here
% raw_data = [1.2, 2.1, 5.6, 15.6, 22.1, 16.3, 4.2, 3.5;
%             1.1, 2.6, 4.9, 16.7, 25.4, 18.6, 5.6, 3.7;
%             0.8, 2.9, 6.8, 22.0, 21.9, 20.0, 8.6, 5.4;
%             2.1, 3.2, 5.1, 18.9, 20.8, 17.6, 3.5, 6.2;
%             3.6, 4.5, 2.8, 11.1, 18.1, 12.9, 8.8, 2.9];
raw_data = dlmread('raw_data.txt'); 

dim = size(raw_data);
number_direction = dim(2);
azimuth = 0: 360/ dim(2) : (360-360/dim(2));
number_repetition = dim(1);
number_totaltrial = number_direction*number_repetition;
spike_rates = reshape(raw_data, 1, number_totaltrial); % construct a vector for later useage of permutation

resp = mean(raw_data); % mean response across trials at each direction
resp_err = std(raw_data)/sqrt(number_repetition);

%--------------------------------------------------------------------------
% compute preferred direction through vector sum
[vector_azi, vector_ele, vector_amp] = vectorsum(resp);
preferred_direction = vector_azi;

% compute strength of direction selectivity using DDI
resp_sse = sum(sum( (raw_data-repmat(resp,[number_repetition 1])).^2 ));
resp_std = resp_sse / (number_totaltrial-number_direction);
DDI = ( max(resp)-min(resp) ) / ( max(resp)-min(resp)+2*sqrt(resp_std) );

% compute significance of direction selectivity using two methods
% method 1: one-way anova
p_anova = anova1( raw_data(:,:),'','off' );

% method 2: permutation test with 1000 loops
perm_number = 1000;
for i = 1:perm_number
    spike_rates_perm = randsample(spike_rates, number_totaltrial); % resample data without replacement
    raw_data_perm = reshape(spike_rates_perm, number_repetition, number_direction);
    resp_perm = mean(raw_data_perm);
    
    % now recompute DDI 
    resp_sse_perm = sum(sum( (raw_data_perm-repmat(resp_perm,[number_repetition 1])).^2 ));
    resp_std_perm = resp_sse_perm / (number_totaltrial-number_direction);
    DDI_perm(i) = ( max(resp_perm)-min(resp_perm) ) / ( max(resp_perm)-min(resp_perm)+2*sqrt(resp_std_perm) );
end

% now compute p value
p_DDI = length( find(DDI_perm>=DDI) ) / perm_number;

%-------------------------------------------------------------------------
% output variables
preferred_direction
DDI
p_anova
p_DDI

errorbar(azimuth, resp, resp_err, 'o-'); 
hold on;
plot([preferred_direction preferred_direction], [min(resp) max(resp)], 'r--');
xlabel('direction');
ylabel('response');