function [sum_image ,network_color, handle_1, handle_2] = plot_network_fus(anatomical_file,anatomical,network_mask,threshold,neg_threshold,mask_scaling,invert_anatomical_colors,anatomical_scaling)
% PLOT_NETWORK  Plots a network over an anatomical image
%
% Requires network_color.mat
% 
% plot_network(anatomical,          Anatomical image
%              network_mask,        Mask for network
%              threshold            Threshold above which to show mask
%                                   (important only if mask has been
%                                   blurred)
%              neg_threshold        Negative threshold below which to show
%                                   mask.
%              mask_scaling         Scaling for the jet colormap of the
%                                   network mask
%              invert_anatomical_colors
%                                   Optional, if true will invert the
%                                   anatomical colormap
%              anatomical_scaling   Scaling for the anatomical image under
%                                   the mask.

if ~exist('threshold','var')
    threshold = [];
end
if isempty(threshold)
    threshold = 0;
end
if ~exist('neg_threshold','var')
    neg_threshold = [];
end
if isempty(neg_threshold)
    neg_threshold = -Inf;
end
if ~exist('mask_scaling','var')
    mask_scaling = [];
end
if isempty(mask_scaling)
    mask_scaling = [min(network_mask(:)) max(network_mask(:))];
end
if ~exist('invert_anatomical_colors','var')
    invert_anatomical_colors = [];
end
if isempty(invert_anatomical_colors)
    invert_anatomical_colors = false;
end

% Define a colormap
%{ 
% % for fMRI
network_color = [...
         0         0         0
    0.0476    0.0476    0.0476
    0.0952    0.0952    0.0952
    0.1429    0.1429    0.1429
    0.1905    0.1905    0.1905
    0.2381    0.2381    0.2381
    0.2857    0.2857    0.2857
    0.3333    0.3333    0.3333
    0.3810    0.3810    0.3810
    0.4286    0.4286    0.4286
    0.4762    0.4762    0.4762
    0.5238    0.5238    0.5238
    0.5714    0.5714    0.5714
    0.6190    0.6190    0.6190
    0.6667    0.6667    0.6667
    0.7143    0.7143    0.7143
    0.7619    0.7619    0.7619
    0.8095    0.8095    0.8095
    0.8571    0.8571    0.8571
    0.9048    0.9048    0.9048
    0.9524    0.9524    0.9524
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0    0.5625
         0         0    0.5625
         0         0    0.5625
         0         0    0.5625
         0         0    0.7500
         0         0    0.9375
         0    0.1250    1.0000
         0    0.3125    1.0000
         0    0.5000    1.0000
         0    0.6875    1.0000
         0    0.8750    1.0000
    0.0625    1.0000    0.9375
    0.2500    1.0000    0.7500
    0.4375    1.0000    0.5625
    0.6250    1.0000    0.3750
    0.8125    1.0000    0.1875
    1.0000    1.0000         0
    1.0000    0.8125         0
    1.0000    0.6250         0
    1.0000    0.4375         0
    1.0000    0.2500         0
    1.0000    0.0625         0
    0.8750         0         0
    0.6875         0         0
    0.5000         0         0];
%}

% %{
% for fUS
network_color = [...
    0         0         0
    0.0476    0.0476    0.0476
    0.0952    0.0952    0.0952
    0.3333    0.3333    0.3333
    0.6190    0.6190    0.6190
    0.8095    0.8095    0.8095
    0.9048    0.9048    0.9048
    0.9524    0.9524    0.9524
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0         0
         0         0    0.5625
         0         0    0.5625
         0         0    0.5625
         0         0    0.5625
         0         0    0.7500
         0         0    0.9375
         0    0.1250    1.0000
         0    0.3125    1.0000
         0    0.5000    1.0000
         0    0.6875    1.0000
         0    0.8750    1.0000
    0.0625    1.0000    0.9375
    0.2500    1.0000    0.7500
    0.4375    1.0000    0.5625
    0.6250    1.0000    0.3750
    0.8125    1.0000    0.1875
    1.0000    1.0000         0
    1.0000    0.8125         0
    1.0000    0.6250         0
    1.0000    0.4375         0
    1.0000    0.2500         0
    1.0000    0.0625         0
    0.8750         0         0
    0.6875         0         0
    0.5000         0         0];

%}

if ~exist('anatomical_scaling','var')
    anatomical_scaling = [];
end
if ~isempty(anatomical_scaling)
    anatomical(anatomical < anatomical_scaling(1)) = anatomical_scaling(1);
    anatomical(anatomical > anatomical_scaling(2)) = anatomical_scaling(2);
end

if invert_anatomical_colors
    % Invert the colors
    network_color(1:21,:) = rot90(rot90(network_color(2:22,:)));
    network_color(22:25,:) = 0;
end

% Scale the anatomical between 0 and 1
anatomical = anatomical - min(anatomical(:));
anatomical = anatomical ./ max(anatomical(:));

% Scale the mask to within its scale
% Account for none over the upper/lower limit
network_mask(network_mask == 0) = NaN;
network_mask = [network_mask zeros(size(network_mask,1),1)];
network_mask(1,size(network_mask,2)) = mask_scaling(1);
network_mask(2,size(network_mask,2)) = mask_scaling(2);
% Account for ones over the upper/lower limit BUT exclude zeros and NaNs
% network_mask(logical((network_mask > mask_scaling(2)) .* (network_mask ~= 0) .* ~isnan(network_mask))) = mask_scaling(2);
network_mask(logical((network_mask > mask_scaling(2)))) = mask_scaling(2);
% network_mask(logical((network_mask < mask_scaling(1)) .* (network_mask ~= 0) .* ~isnan(network_mask))) = mask_scaling(1);
network_mask(logical((network_mask < mask_scaling(1)))) = mask_scaling(1);
% Save the colorbar network mask
network_mask_orig = network_mask;

% Set to NaN areas of the network_mask not outside the thresholds
old_network_mask_max = max(network_mask(:));
old_network_mask_min = min(network_mask(:));
network_mask = double(network_mask);
network_mask(boolean((network_mask >= neg_threshold) .* (network_mask <= threshold))) = NaN;

% Scale network_mask to between 2 and 3 
network_mask = network_mask - old_network_mask_min;
network_mask = network_mask / (old_network_mask_max - old_network_mask_min);
network_mask = network_mask + 2;

% Turn NaNs to zeros
network_mask(isnan(network_mask)) = 0;

% Remove accounting for none over the upper/lower limit
network_mask = network_mask(:,1:end-1);

% Combine the images
anatomical(network_mask ~= 0) = 0;
% if sum(anatomical(:)) == 0
%     error('None of anatomical image to be shown.');
% end
sum_image = network_mask + anatomical;
temp = strfind(anatomical_file,'.nii');
tempN = anatomical_file(8:temp-1);
if (nargout == 0) || (nargout >= 3)
    % Show the scale
    handle_1 = figure;imagesc(network_mask_orig);colorbar;colormap('jet');axis equal;axis off;title(['Correlation map: ',tempN]);
    saveas(handle_1,['Z:\LBY\Recording data\fUS\corr_' tempN], 'jpg');
    % Show the image %modify by bobinshi
    handle_2 = figure;imagesc(sum_image,[0 3]);colormap(network_color);axis equal;axis off;title(['Correlation map with anatomical image: ',tempN]);
    saveas(handle_2,['Z:\LBY\Recording data\fUS\corrAnatomy_' tempN], 'jpg');
    %handle_2 = figure;imshow(sum_image,[0 3]); colormap(network_color);axis equal;axis off;
end