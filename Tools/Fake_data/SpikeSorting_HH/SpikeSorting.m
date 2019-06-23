% ASN Matlab Tutorial 2013
% Spike sorting using Principal Component Analysis (PCA) method
% Data from monkey HeTao
% by HH, 2013/12/22

%% Loading
clear; clc; close all;
load Spikes;

spikeRaw = data.values;
t = (1:size(spikeRaw,2)) * data.interval * 1000;  % in ms

% Plotting raw waveforms
figure(1); set(1,'color','w','position', [200 100 650 550]);
subplot(2,2,1); 
plot(t,spikeRaw','k'); xlim([t(1) t(end)]);

%% Principal component analysis (PCA)

%%{
%  Step-by-step calulation for understanding the underlying math

% Remove mean of EACH DIMENSION (NOT each spike) from the raw data
spikeMeanRemoved = spikeRaw - repmat(mean(spikeRaw,1),size(spikeRaw,1),1);
% Calculate covariance matrix
covarianceMatrix = spikeMeanRemoved'*spikeMeanRemoved;
% Eigenvalues/vectors of covariance matrix
[eigVectors, eigValues] = eig(covarianceMatrix);
% Sort eigenvalues in descending order (it is ascend by default)
[~,sortRank] = sort(diag(eigValues),'descend');
% Sort eigenvectors according to eigenvalues
sortedEigVectors  = eigVectors(:,sortRank);

%}

%{
% Directly use function "princomp" (before Matlab 2013) or "pca" (after
% Matlab 2013) to calculate the sorted eigenvectors.
[sortedEigVectors, ~] = princomp(spikeRaw);
%}

% The first three eigenvectors that have the first three largest
% eigenvalues.
PC1 = sortedEigVectors(:,1);
PC2 = sortedEigVectors(:,2);
PC3 = sortedEigVectors(:,3);

% Projecting the raw data onto the first three eigenvectors
projPC1 = spikeRaw * PC1;
projPC2 = spikeRaw * PC2;
projPC3 = spikeRaw * PC3;

% Replotting the raw data in new 3-D Prinpal Component space 
subplot(2,2,3); 
plot3(projPC1, projPC2, projPC3,'k.'); grid on;
xlabel('PC1'); ylabel('PC2'); zlabel('PC3');

% plot PC (EigVectors) added by LBY 20190529
figure;
axes;hold on;
plot(t,PC1,'b');
plot(t,PC2,'g');
plot(t,PC3,'k');

%% Spike sorting using k-means method in PC space
numNeurons = 3; 
[Index,~] = kmeans([projPC1, projPC2, projPC3], numNeurons,'start','uniform','emptyaction','drop');
col = {'b', 'r', 'g', 'k', 'm'};

% Add colors according to the sorting result.
subplot(2,2,2); 
for i=1: length(unique(Index))
    plot(t,spikeRaw(Index==i,:)',col{i}); hold on;
end
xlim([t(1) t(end)]);

subplot(2,2,4);
xlabel('PC1'); ylabel('PC2'); zlabel('PC3'); 
for i=1: length(unique(Index))
    plot3(projPC1(Index==i),projPC2(Index==i),projPC3(Index==i), [col{i} '.']); hold on;
end
grid on;


