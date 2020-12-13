%% This section creates toy data.
%
% It should be replaced by actual experimental data. The data should be
% joined in three arrays of the following sizes (for the Romo-like task):
%
% trialNum: N x S x D
% firingRates: N x S x D x T x maxTrialNum
% firingRatesAverage: N x S x D x T
%
% N is the number of neurons
% S is the number of stimuli conditions (F1 frequencies in Romo's task)
% D is the number of decisions (D=2)
% T is the number of time-points (note that all the trials should have the
% same length in time!)
%
% trialNum -- number of trials for each neuron in each S,D condition (is
% usually different for different conditions and different sessions)
% (N*S*D)
%
% firingRates -- all single-trial data together, massive array. Here
% maxTrialNum is the maximum value in trialNum. E.g. if the number of
% trials per condition varied between 1 and 20, then maxTrialNum = 20. For
% the neurons and conditions with less trials, fill remaining entries in
% firingRates with zeros or nans.
%
% firingRatesAverage -- average of firingRates over trials (5th dimension).
% If the firingRates is filled up with nans, then it's simply
%    firingRatesAverage = nanmean(firingRates,5)
% If it's filled up with zeros (as is convenient if it's stored on hard 
% drive as a sparse matrix), then 
%    firingRatesAverage = bsxfun(@times, mean(firingRates,5), size(firingRates,5)./trialNum)
function dpca_LBY(data,pp)

stimInd = 1:3;
%%%%%%%%%% only stimulus, no decison dimension
% %{
firingRates = data; 


% calculate trial No. for each condition
temp = squeeze(firingRates(:,:,1,:));
temp1 = cumsum(~isnan(temp),3);
trialNum = temp1(:,:,end);

E = 15;     % maximal number of trial repetitions

% computing PSTHs
firingRatesAverage = nanmean(firingRates, 4);

% time define
time = 1:size(firingRates,3);


%}


%%% split in to 2 decisions 前三次重复放到一起
%{
load('Z:\Data\TEMPO\BATCH\Population_data\PCA\PCC_dPCA_new.mat');
firingRatesTemp(:,:,1,:,:) = permute(a,[3 1 2 4]); % add one dimension as D, since I dgon't have decisions in my data
% firingRatesTemp(:,:,1,:,:) = permute(b,[3 1 2 4]); % add one dimension as D, since I dgon't have decisions in my data

% firingRates(:,:,1,:,:) = cat(5,firingRatesTemp(:,:,:,:,[1:2,4]), nan*ones(size(firingRatesTemp,1),size(firingRatesTemp,2),1,size(firingRatesTemp,4),9));
% % firingRates(:,:,2,:,:) = cat(5,nan*ones(size(firingRatesTemp,1),size(firingRatesTemp,2),1,size(firingRatesTemp,4),3), firingRatesTemp(:,:,:,:,[3,5:end]));
% firingRates(:,:,2,:,:) = firingRatesTemp(:,:,:,:,[3,5:end]);

% firingRates(:,:,1,:,:) = cat(5,firingRatesTemp(:,:,:,:,[3]), nan*ones(size(firingRatesTemp,1),size(firingRatesTemp,2),1,size(firingRatesTemp,4),13));
% % firingRates(:,:,2,:,:) = cat(5,nan*ones(size(firingRatesTemp,1),size(firingRatesTemp,2),1,size(firingRatesTemp,4),3), firingRatesTemp(:,:,:,:,[3,5:end]));
% firingRates(:,:,2,:,:) = firingRatesTemp(:,:,:,:,[1:2,4:end]);


temp = squeeze(firingRates(:,:,:,1,:));
temp1 = cumsum(~isnan(temp),4);
trialNum = temp1(:,:,:,end);

E = 12;     % maximal number of trial repetitions

% computing PSTHs
% firingRatesAverage = nanmean(firingRates, 5);

% time define
% time = 1:size(firingRates,4);

%}

N = size(firingRates,1);   % number of neurons
T = size(firingRates,4);     % number of time points
S = size(firingRates,2);      % number of stimuli
D = size(firingRates,3);          % number of decisions


% setting random number of repetitions for each neuron and condition
ifSimultaneousRecording = false;  % change this to simulate simultaneous 
                                 % recordings (they imply the same number 
                                 % of trials for each neuron)
                                 
%% Define parameter grouping

% *** Don't change this if you don't know what you are doing! ***
% firingRates array has [N S D T E] size; herewe ignore the 1st dimension 
% (neurons), i.e. we have the following parameters:
%    1 - stimulus 
%    2 - decision
%    3 - time
% There are three pairwise interactions:
%    [1 3] - stimulus/time interaction
%    [2 3] - decision/time interaction
%    [1 2] - stimulus/decision interaction
% And one three-way interaction:
%    [1 2 3] - rest
% As explained in the eLife paper, we group stimulus with stimulus/time interaction etc.:

%{

% combinedParams = {{1, [1 3]}, {2, [2 3]}, {3}, {[1 2], [1 2 3]}};
% margNames = {'Stimulus', 'Decision', 'Condition-independent', 'S/D Interaction'};
% margColours = [23 100 171; 187 20 25; 150 150 150; 114 97 171]/256;

% check consistency between trialNum and firingRates
for n = 1:size(firingRates,1)
    for s = 1:size(firingRates,2)
        for d = 1:size(firingRates,3)
            try
            assert(isempty(find(isnan(firingRates(n,s,d,:,1:trialNum(n,s,d))), 1)), 'Something is wrong!')
            catch
                keyboard
            end
        end
    end
end

%}


%%%%%%%%%% For two parameters (e.g. stimulus and time, but no decision), we would have
% firingRates array of [N S T E] size (one dimension less, and only the following
% possible marginalizations:
%    1 - stimulus
%    2 - time
%    [1 2] - stimulus/time interaction

% %{

% They could be grouped as follows: 
combinedParams = {{1, [1 2]}, {2}};
   margNames = {'Stimulus', 'Condition-independent'};
   margColours = [23 100 171; 150 150 150; 114 97 171]/256;


% check consistency between trialNum and firingRates
for n = 1:size(firingRates,1)
    for s = 1:size(firingRates,2)
            try
            assert(isempty(find(isnan(firingRates(n,s,:,1:trialNum(n,s))), 1)), 'Something is wrong!')
            catch
                keyboard
            end
    end
end

%}

% Time events of interest (e.g. stimulus onset/offset, cues etc.)
% They are marked on the plots with vertical lines
timeEvents = time(round(length(time)/2));

%% Step 1: PCA of the dataset
%{
X = firingRatesAverage(:,:);
X = bsxfun(@minus, X, mean(X,2));

[W,~,~] = svd(X, 'econ');
% [W,~,~] = svd(X);
W = W(:,1:20);

% minimal plotting
dpca_plot(pp,firingRatesAverage, W, W, @dpca_plot_default);

% computing explained variance
explVar = dpca_explainedVariance(firingRatesAverage, W, W, ...
    'combinedParams', combinedParams);

% a bit more informative plotting
dpca_plot(pp,firingRatesAverage, W, W, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours);

%}
%% Step 2: PCA in each marginalization separately
%{
dpca_perMarginalization(stimInd,firingRatesAverage, @dpca_plot_default, ...
   'combinedParams', combinedParams);
%}
%% Step 3: dPCA without regularization and ignoring noise covariance
%{
% This is the core function.
% W is the decoder, V is the encoder (ordered by explained variance),
% whichMarg is an array that tells you which component comes from which
% marginalization

tic
[W,V,whichMarg] = dpca(firingRatesAverage, 20, ...
    'combinedParams', combinedParams);
toc

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams);

dpca_plot(pp,firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3, ...
    'legendSubplot', 16);

%}
%% Step 4: dPCA with regularization
% %{
% This function takes some minutes to run. It will save the computations 
% in a .mat file with a given name. Once computed, you can simply load 
% lambdas out of this file:
%   load('tmp_optimalLambdas.mat', 'optimalLambda')

% Please note that this now includes noise covariance matrix Cnoise which
% tends to provide substantial regularization by itself (even with lambda set
% to zero).

optimalLambda = dpca_optimizeLambda(firingRatesAverage, firingRates, trialNum, ...
    'combinedParams', combinedParams, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', 2, ...  % increase this number to ~10 for better accuracy
    'filename', 'tmp_optimalLambdas.mat');

Cnoise = dpca_getNoiseCovariance(firingRatesAverage, ...
    firingRates, trialNum, 'simultaneous', ifSimultaneousRecording);

[W,V,whichMarg] = dpca(firingRatesAverage, 20, ...
    'combinedParams', combinedParams, ...
    'lambda', optimalLambda, ...
    'Cnoise', Cnoise);

% plot weight distribution of each PC
figure;
hist(W(:,1:20));
SetFigure(15);



explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams);

dpca_plot(pp,firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16);
%}
%% Optional: estimating "signal variance"

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams, ...
    'Cnoise', Cnoise, 'numOfTrials', trialNum);

% Note how the pie chart changes relative to the previous figure.
% That is because it is displaying percentages of (estimated) signal PSTH
% variances, not total PSTH variances. See paper for more details.

dpca_plot(pp,firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16);

%% Optional: decoding

decodingClasses = {[(1:S)' (1:S)'], repmat([1:2], [S 1]), [], [(1:S)' (S+(1:S))']};

accuracy = dpca_classificationAccuracy(firingRatesAverage, firingRates, trialNum, ...
    'lambda', optimalLambda, ...
    'combinedParams', combinedParams, ...
    'decodingClasses', decodingClasses, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', 5, ...        % increase to 100
    'filename', 'tmp_classification_accuracy.mat');

dpca_classificationPlot(accuracy, [], [], [], decodingClasses)

accuracyShuffle = dpca_classificationShuffled(firingRates, trialNum, ...
    'lambda', optimalLambda, ...
    'combinedParams', combinedParams, ...
    'decodingClasses', decodingClasses, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', 5, ...        % increase to 100
    'numShuffles', 20, ...  % increase to 100 (takes a lot of time)
    'filename', 'tmp_classification_accuracy.mat');

dpca_classificationPlot(accuracy, [], accuracyShuffle, [], decodingClasses)

componentsSignif = dpca_signifComponents(accuracy, accuracyShuffle, whichMarg);

dpca_plot(pp,firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16,                ...
    'componentsSignif', componentsSignif);

end
