function [ handle_1, handle_2] = My_image_series_plot_Fus(anatomical_file,network_mask_file,threshold,neg_threshold,cluster,mask_scaling,rows,columns,spacing)
% IMAGE_SERIES_PLOT_NETWORK
% Plots a network against an anatomical image, as a filmstrip of images.
% Q.v. plot_network.m and image_series.m
%
% = image_series_plot_network(
%               anatomical,         Anatomical image
%               network_mask,       Mask for network
%              adjust_method        statistics result adjust method, FDR,
%                                   FWE, NO
%               Pvalue              statistics result threshold p
%               mask_scaling        Scaling for the jet colormap of the
%                                   network mask or colorbar
%               sliceon             result show begain slice number
%               sliceend            result show end slice number
%               rows,               How many rows of images
%               columns,            How many columns of images
%               spacing,            Number of pixels between images.  If a
%                                   scalar, uses that for x and y, if a 2
%                                   element vector, is [x spacing y spacing].
% modify by bobinshi 20210203

if ~exist('mask_scaling','var')
    mask_scaling = [];
end
if ~exist('rows','var')
    rows = [];
end
if ~exist('columns','var')
    columns = [];
end
if ~exist('spacing','var')
    spacing = [];
end

% read background image
Temhead=spm_vol(anatomical_file);
Temimg=spm_read_vols(Temhead);
%Temimg=Temimg(:,:,sliceon:sliceend);
Temimg=fliplr(rot90(Temimg,-1));
% read spm image
spmThead=spm_vol(network_mask_file);
spmTimg=spm_read_vols(spmThead);
%spmTimg=spmTimg(:,:,sliceon:sliceend);
spmTimg=fliplr(rot90(spmTimg,-1));

%计算矫正的T值
%[T_Threshold,Mask_3D ]=MY_FDR_Correction(network_mask_file,adjust_method,Pvalue);
Mask_3D = or(spmTimg>threshold,spmTimg<neg_threshold);
%Mask_3D = permute(Mask_3D,[2 1 3]);
%Mask_3D=Mask_3D(:,:,sliceon:sliceend);
Func_Img_3D = spmTimg.*double(Mask_3D);
% clustering
spmTimg_cluster = MY_clustering_function_map_Fus(Func_Img_3D,cluster);

% Create tiled background image
anatomical=Temimg;
anatomical_image_series = image_series(anatomical,rows,columns,spacing);
% Create tiled images
network_mask=spmTimg_cluster;
network_image_series = image_series(network_mask,rows,columns,spacing);
% Plot tiled images on tiled background
network_image_series(network_image_series == min(network_image_series(:))) = 0;
network_image_series(network_image_series == min(network_image_series(:))) = 0;
[~, ~, handle_1, handle_2] = plot_network_fus(anatomical_image_series,network_image_series,threshold,neg_threshold,mask_scaling);