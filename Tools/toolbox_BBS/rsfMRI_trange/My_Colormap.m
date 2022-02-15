function [Img_RGB,Img_RGB_nothre]= My_Colormap(varargin)
% Colormap.m is used for generating the RGB.tif from the statistic map
% spmT_file,corrected_p,template,slice,bar_value,dest,mapname,cluster,False_positive
% the input file must be the struct mat
%       varargin.statfile        :  spmT_000X.nii(tsfMRI) or CCmap (rfMRI)
%                                                 absolute URL file,'string'
%       varargin.bgmfile         :  the background of RGB colormap (xxx.nii)
%                                                 absolute URL file,'string'
%       varargin.cluster         :  the cluster size of voxels
%       varargin.adjust_method   :  the corrected method to control the
%                                    false positive rate:
%                                               'no(default)','FDR','FWE'
%       varargin.corrected_p     :  the corrected p value
%       varargin.slice           :  the slice to display (default all)
%       varargin.bar_value       :  the colorbar [-max,min,min,max]
%                                               '[-10, -1,  1,  10](default)'
%       varargin.dest&mapname    :  the output dest and the name of RGB.tif


args_x = varargin(1,1:2:end);
args_y = varargin(1,2:2:end);
for ind = 1:numel(args_x)
%     args = struct(args_x{ind},args_y(ind));
    eval(['args.',args_x{ind},'=args_y{ind};']);
end

try
    statistic_file = args.statfile;
catch
    error('Requires the statistic and template files !');
end

try
    template = args.bgmfile;
catch
    template = 'no#$';
    warning('the background was not identified. Stop it expect no thresholding display');
end

try
    cluster = args.cluster;
catch
    cluster = 1;
    warning('cluster size was not identified, (default) 1 voxel');
end
try
    method = args.adjust_method;
    q = args.corrected_p;
catch
    method = 'no#$';
%     warning('p value was not defined');
end

try
    slice = args.slice;
catch
    slice = 1:min(size(spm_read_vols(spm_vol(statistic_file))));
    warning('slices to display were not identified, (default) all');
end

try
    bar_value = args.bar_value;
catch
    bar_value = [-10,-1,1,10];
    warning('the colorbar was not identified, (default) [-10, -1,  1,  10]');
end
try
    dest = args.dest;
    mapname = args.mapname;
catch
%     error('Requires the output destination and the name of RBG.tif !');
end
% load statistic file
if contains(statistic_file,'nii')
    Func_Img_3D_raw = spm_read_vols(spm_vol(statistic_file));
else
    error('the statistic file must be absolute URL files (string).')
end

if ~ strcmp(template,'no#$')
    
    if contains(template,'.nii')
        Template_Img_3D = spm_read_vols(spm_vol(template));
        Template_Img_3D = Template_Img_3D/max(Template_Img_3D(:))*255*100;
    else
        error('the statistic file must be absolute URL files (string).')
    end
    % false postive correction
    switch upper(method)
        case {'FDR','FWE','NO'}
            Mask_3D = MY_False_Postive_Correction(statistic_file,method,q);
            Func_Img_3D = Func_Img_3D_raw.*double(Mask_3D);
        otherwise
            Func_Img_3D = Func_Img_3D_raw;
    end
    
    % clustering
    Func_Img_3D = MY_clustering_function_map(Func_Img_3D,cluster,bar_value(2:3));
    
    % colormap display
    Img_RGB = MY_display_function_map_3D(Func_Img_3D,bar_value,slice,Template_Img_3D);
    Img_RGB = MY_reshape_RGB_Img_multi_row(Img_RGB,slice,ceil(numel(slice)/2));
    Img_RGB = MY_add_colorbar_RGB(Img_RGB,bar_value);
    imwrite(uint8(Img_RGB), strcat(dest,'\',strcat(mapname,'.tif')), 'tif');
end


% no threshold & no correction display
Img_RGB_nothre = MY_display_function_map_3D_nothreshold(Func_Img_3D_raw,bar_value,slice);
Img_RGB = MY_reshape_RGB_Img_multi_row(Img_RGB_nothre,slice,ceil(numel(slice)/2));
imwrite(uint8(Img_RGB), strcat(dest,'\',strcat(mapname,'_nothres.tif')), 'tif');


end


function Mask_3D = MY_False_Postive_Correction(statistic_file,method,q)

VspmSv = spm_vol(statistic_file);
VspmData = spm_read_vols(VspmSv);

handles.left_brace   = strfind(VspmSv.descrip,'{');
handles.right_brace  = strfind(VspmSv.descrip,'}');
handles.left_square  = strfind(VspmSv.descrip,'[');
handles.right_square = strfind(VspmSv.descrip,']');
handles.underline    = strfind(VspmSv.descrip,'_');

global TF df
TF = char      (VspmSv.descrip(handles.left_brace+1 :handles.underline-1   ));
df = str2double(VspmSv.descrip(handles.left_square+1:handles.right_square-1));

switch upper(method)
    case 'FDR'
        for pos_neg_ind = 1:2
            positive = -pos_neg_ind*2+3;
            Ts = VspmData;
            Ts(Ts==0) = [];
            Ts(isnan(Ts)) = [];
            Ts = positive*Ts;
            Ts = sort(Ts(:),'descend');
            if TF == 'T'
                ps = t2p(Ts, df, TF);
                intensity(pos_neg_ind)  = spm_uc_FDR(q, [1 df],TF,1,ps,0)*positive;
%                 pvalue(pos_neg_ind) = t2p(intensity, df, handles.TF{1});
            end
            if TF == 'F'
                ps = t2p(Ts, [df(1), df(2)], TF);
                intensity(pos_neg_ind)  = spm_uc_FDR(q, [df(1), df(2)],TF,1,ps,0)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, [df(1), df(2)], TF);
            end
        end
    case 'FWE'
        for pos_neg_ind = 1:2
            positive = -pos_neg_ind*2+3;
            xSPM_ind = strfind(statistic_file(1:end-3),'\');
            try
                load([statistic_file(1:xSPM_ind(end)),'\SPM.mat']);
            catch
                error('Do find the corresponding SPM.mat')
            end
            S    = SPM.xVol.S;                  %-search Volume {voxels}
            R    = SPM.xVol.R;                  %-search Volume {resels}
            if TF == 'T'
                intensity(pos_neg_ind) = spm_uc(q,[1, df],TF,R,1,S)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, df, handles.TF{1});
            end
            if TF == 'F'
                intensity(pos_neg_ind) = spm_uc(q,[df(1), df{1}(2)],TF,R,1,S)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, [df(1), df(2)], TF);
            end
        end
    case 'NO'
        for pos_neg_ind = 1:2
            positive = -pos_neg_ind*2+3;
            Ts = VspmData;
            Ts(Ts==0) = [];
            Ts(isnan(Ts)) = [];
            Ts = positive*Ts;
            Ts = sort(Ts(:),'descend');
            intensity(pos_neg_ind)  = Ts(ceil(numel(Ts)*(1-q)));
        end
    otherwise
        intensity = [-0.000000001,0.00000001];
end
Mask_3D = or(VspmData>intensity(1),VspmData<intensity(2));



end

function Img_RGB = MY_display_function_map_3D(Func_Img_3D,bar_value,slice,Template_Img_3D)

Func_Img_3D = flip(Func_Img_3D,1);
Template_Img_3D = flip(Template_Img_3D,1);

Func_Img_3D(Func_Img_3D>bar_value(4)) = bar_value(4);
Func_Img_3D(Func_Img_3D<bar_value(1)) = bar_value(1);
% slice selection
map3D_reslice = Func_Img_3D(:,:,slice);
img_reslice = Template_Img_3D(:,:,slice);
% 3D to 2D ,[1 3 2]
img_reshape = reshape(permute(flip(img_reslice,1),[2 1 3]),[size(img_reslice,2) size(img_reslice,1)*numel(slice)]);
img_reshape = img_reshape/max(img_reshape(:))*255;
map3D_reshape = reshape(permute(flip(map3D_reslice,1),[2 1 3]),[size(img_reslice,2) size(img_reslice,1)*numel(slice)]);
% find positive and negative pixels
positive_pixel = (map3D_reshape >= bar_value(3));
negative_pixel = (map3D_reshape <= bar_value(2));
tmap = repmat(img_reshape,[1,1,3]);
% r map or t map normalization
if bar_value(3)== Inf;bar_value(3)=bar_value(4);end
if bar_value(2)== -Inf;bar_value(2)=bar_value(1);end
map3D_reshape(map3D_reshape<0)=map3D_reshape(map3D_reshape<0)/bar_value(1);
map3D_reshape(map3D_reshape>0)=map3D_reshape(map3D_reshape>0)/bar_value(4);
bar_value_normalize = [-1,-bar_value(2)/bar_value(1),bar_value(3)/bar_value(4),1];
% positive pixels painting
map3D_reshape_positive = double((map3D_reshape(positive_pixel)-bar_value_normalize(3))./abs(bar_value_normalize(4)-bar_value_normalize(3)));
positive_index = find(double(positive_pixel)==1);
tmap(positive_index+numel(map3D_reshape)*0) = 255.0;
tmap(positive_index+numel(map3D_reshape)*1) = map3D_reshape_positive*255;
tmap(positive_index+numel(map3D_reshape)*2) = 0;

% negative pixels painting
map3D_reshape_negative = double((map3D_reshape(negative_pixel)-bar_value_normalize(3))./abs(bar_value_normalize(4)-bar_value_normalize(3)));

negative_index = find(double(negative_pixel)==1);
tmap(negative_index+numel(map3D_reshape)*0) = 0;
tmap(negative_index+numel(map3D_reshape)*1) = abs(map3D_reshape_negative*255);
tmap(negative_index+numel(map3D_reshape)*2) = 255-abs(map3D_reshape_negative*255);
%     tmap(:,:,1)=flipud(tmap(:,:,1));
%     tmap(:,:,2)=flipud(tmap(:,:,2));
%     tmap(:,:,3)=flipud(tmap(:,:,3));
Img_RGB = tmap;
end

function Img_RGB = MY_display_function_map_3D_nothreshold(Func_Img_3D,bar_value,slice)

map_nothre_reshape = reshape(permute(flip(Func_Img_3D(:,:,slice),1),[2 1 3]),[size(Func_Img_3D,2) size(Func_Img_3D,1)*numel(slice)]);
fig = ancestor(gcf,'figure');
defaultMap = get(fig,'defaultfigureColormap');
close(fig);
nothrebar = [min(bar_value(:)) max(bar_value(:))];
ram = ones([size(map_nothre_reshape),3]);
map_normalize = (map_nothre_reshape-nothrebar(1))/(nothrebar(2)-nothrebar(1));
map_normalize(map_normalize<=0) = 0.000000001;
map_normalize(map_normalize>=1) = 1;
ram(:,:,1) = reshape(defaultMap(ceil(map_normalize*64),1)*255,size(map_normalize));
ram(:,:,2) = reshape(defaultMap(ceil(map_normalize*64),2)*255,size(map_normalize));
ram(:,:,3) = reshape(defaultMap(ceil(map_normalize*64),3)*255,size(map_normalize));

Img_RGB = ram;
end

function Img_3D = MY_clustering_function_map(Img_3D,cluster_size,binar_thres)

min_thres = binar_thres(1);
max_thres = binar_thres(2);
map_sec = Img_3D;
map_sec(map_sec > max_thres) = 1;
map_sec(map_sec < min_thres) = 1;
map_sec(map_sec ~=1) = 0;
CC = bwconncomp(map_sec,4);      % find connected component
area = cellfun(@numel, CC.PixelIdxList);  % find concrete pixel index
idxToKeep = CC.PixelIdxList(area >= cluster_size);  % get the indexs of cluster pixels
idxToKeep = vertcat(idxToKeep{:});  % house these indexs
map_sec2 = false(size(map_sec));
map_sec2(idxToKeep) = true;   % mask the cluster
Img_3D = Img_3D.*map_sec2;

end

function Img_RGB = MY_add_colorbar_RGB(Img_RGB,bar_value)

overlay = Img_RGB;
tall = size(overlay,1);
leng = ceil(size(overlay,1)*0.5);
colorbar = zeros([tall,leng,3]);
upper_bound = ceil(tall*0.15);    lower_bound = ceil(tall*0.85);
% positive bar
left = ceil(leng*0.1);    right = ceil(leng*0.3);
colorbar(upper_bound:lower_bound,left:right,1) = 1*255;
colorbar(upper_bound:lower_bound,left:right,2) = repmat((lower_bound-(upper_bound:lower_bound))/(lower_bound-upper_bound),right-left+1,1)'*255;
colorbar(upper_bound:lower_bound,left:right,3) = 0;
% negtive bar
left = ceil(leng*0.4);    right = ceil(leng*0.6);
colorbar(upper_bound:lower_bound,left:right,1) = 0;
colorbar(upper_bound:lower_bound,left:right,2) = repmat((lower_bound-(upper_bound:lower_bound))/(lower_bound-upper_bound),right-left+1,1)'*255;
colorbar(upper_bound:lower_bound,left:right,3) = 255-repmat((lower_bound-(upper_bound:lower_bound))/(lower_bound-upper_bound),right-left+1,1)'*255;


% bar value
if bar_value(3)== bar_value(4);bar_value(3)=0;end
if bar_value(2)== bar_value(1);bar_value(2)=0;end

global TF pump
ti = insertText(colorbar,[ceil(leng*0.75)/2,ceil(tall*0.075)],['¡À',num2str(abs(round(bar_value(4),2)))],'FontSize', 12*pump,'TextColor',[255 255 255],'BoxColor',[0 0 0],'BoxOpacity',0,'AnchorPoint','Center');
ti = insertText(ti,[ceil(leng*0.55)/2,ceil(tall*0.925)],['+',num2str(abs(round(bar_value(3),2)))],'FontSize', 8*pump,'TextColor',[255 255 255],'BoxColor',[0 0 0],'BoxOpacity',0,'AnchorPoint','Center');
%     ti = insertText(ti,[ceil(leng*0.35)/2*3,ceil(tall*0.075)],['-',num2str(abs(round(bar_value(1),2)))],'FontSize', 8*pump,'TextColor',[255 255 255],'BoxColor',[0 0 0],'BoxOpacity',0,'AnchorPoint','Center');
ti = insertText(ti,[ceil(leng*0.55)/2*2.5,ceil(tall*0.925)],['-',num2str(abs(round(bar_value(2),2)))],'FontSize', 8*pump,'TextColor',[255 255 255],'BoxColor',[0 0 0],'BoxOpacity',0,'AnchorPoint','Center');
ti = insertText(ti,[ceil(leng*0.85),tall/2],TF,'FontSize',30*pump,'TextColor',[255 255 255],'BoxColor',[0 0 0],'BoxOpacity',0,'AnchorPoint','Center');

ti(ti>0&ti<=1)=255;
overlay1 = zeros(size(overlay,1),size(overlay,2)+size(ti,2),size(overlay,3));
overlay1(:,1:size(overlay,2),:) = overlay;
overlay1(:,((size(overlay,2)+1):(size(overlay,2)+size(ti,2))),:) = ti;
Img_RGB = overlay1;
end

function Img_RGB = MY_reshape_RGB_Img_multi_row(Img_RGB,slice_display,slice_per_row)

overlay = Img_RGB;
slice = slice_display;
[SizeX,SizeY,~] = size(overlay);
global pump
pump = ceil(length(slice)/slice_per_row);
blank = pump*slice_per_row-length(slice);
overlay(:,SizeY+1:SizeY+SizeY/length(slice)*blank,:) = zeros([SizeX,SizeY/length(slice)*blank 3]);
for j =1:pump
    overlay2((j-1)*SizeX+1:j*SizeX,:,:) = overlay(:,(j-1)*(size(overlay,2)/pump)+1:j*(size(overlay,2)/pump),:);
end
Img_RGB = overlay2;

end

function p = t2p(t, df, TF)
if ~iscell(t)
    if or( upper(TF)=='T' , upper(TF)=='S' )
        p = 1-spm_Tcdf(t,df);
    elseif upper(TF) == 'F'
        p = 1-spm_Fcdf(t,df);
    end
else
    for ii=1:length(t)
        p{ii} = t2p(t{ii},df{ii},TF{ii});
    end
end
end
