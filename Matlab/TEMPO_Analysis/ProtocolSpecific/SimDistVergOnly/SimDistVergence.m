%-----------------------------------------------------------------------------------------------------------------------
% SimDistVergence.m -- Analysis of vergence data for SimDistVergOnly
% paradigm
%-----------------------------------------------------------------------------------------------------------------------

function SimDistVergence(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE);

TEMPO_Defs;

symbols = {'ko' 'r*' 'go' 'mo' 'b*' 'r*' 'g*' 'c*'};
lines = {'k-' 'r--' 'g-' 'm-' 'b--' 'r--' 'g--' 'c--'};

%get the column of values of fixation distances
depth_fix_real = data.dots_params(DEPTH_FIX_REAL,:,PATCH2)

%get indices of any NULL conditions (for measuring spontaneous activity)
null_trials = logical( (depth_fix_real == data.one_time_params(NULL_VALUE)) );

unique_depth_fix_real = munique(depth_fix_real(~null_trials)');

%now, get the firing rates for all the trials
spike_rates = data.spike_rates(SpikeChan, :);

if (data.eye_calib_done)
    eye_positions = data.eye_positions_calibrated;
else
    eye_positions = data.eye_positions;
end
%eye_positions is a 2D-matrix with the rows representing the components for individual
%eyes (e.g., LEYE_H, LEYE_V, REYE_H, REYE_V).  The columns


%now, remove trials from hor_disp and spike_rates that do not fall between BegTrial and EndTrial
trials = 1:length(depth_fix_real);		% a vector of trial indices
select_trials = ( (trials >= BegTrial) & (trials <= EndTrial) );


figure;
set(gcf,'PaperPosition', [.2 .2 8 10.7], 'Position', [250 150 500 473], 'Name', 'Vergence analysis');
subplot(2, 1, 2);

%%%DO ANALYSIS AND PLOTTING HERE
%%the sample file to run this on is Z:\Data\Tempo\Robbins\Raw\m3c1012r10.htb
%% Sort by fixation distances, calculate mean vergence and std. dev. for
%% vergence, and plot.  
keyboard;








%now, print out some useful information in the upper subplot
subplot(2, 1, 1);

PrintGeneralData(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE);

return;

