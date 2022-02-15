function [whole_image, black_color, white_color] = image_series(threed_image,comp_rows,comp_columns,spacing,threshold,labels,mask,font_name,font_size)
% IMAGE_SERIES
%
% Plot a 3D image as a filmstrip
% [
% composite_image                   Optional, the data that is displayed
% black_color                       Optional, the numerical value of the
%                                   black color shown
% white_color                       Optional, the numerical value of the
%                                   white color shown
% ] =
% image_series(threed_image,
%               rows,               How many rows of images
%               columns,            How many columns of images
%               spacing (optional)  Number of pixels between images.  If a
%                                   scalar, uses that for x and y, if a 2
%                                   element vector, is [x spacing y spacing].
%               threhsold(optional) 2 element vector with upper and lower
%                                   limit
%               labels (optional)   How to label each subimage.  Can be
%                                   either a numerical vector or a cell
%                                   vector of strings
%               mask (optional)     Mask of part of image to show
%               font_name (opt.)    String name of font
%               font_size (opt.)    Integer size of font
%               )

% Convert to double
if ~isa(threed_image,'double')
    threed_image = double(threed_image);
end

% if min(threed_image(:)) >= 0
%     threed_image(isnan(threed_image)) = 0;
% else
%     threed_image(isnan(threed_image)) = min(threed_image(:)) - ((max(threed_image(:)) - min(threed_image(:)))/63);
% end

if length(unique(threed_image(:))) == 2
    threed_image = threed_image+ eps;
end

if exist('threshold','var')
    if isempty(threshold)
        clear('threshold');
    end
end

% Create a custom colormap with the first 2 colors at the extrema
image_series_colormap = ...
    [1         1    1
    0         0    0
    0         0    0.6250
    0         0    0.6875
    0         0    0.7500
    0         0    0.8125
    0         0    0.8750
    0         0    0.9375
    0         0    1.0000
    0    0.0625    1.0000
    0    0.1250    1.0000
    0    0.1875    1.0000
    0    0.2500    1.0000
    0    0.3125    1.0000
    0    0.3750    1.0000
    0    0.4375    1.0000
    0    0.5000    1.0000
    0    0.5625    1.0000
    0    0.6250    1.0000
    0    0.6875    1.0000
    0    0.7500    1.0000
    0    0.8125    1.0000
    0    0.8750    1.0000
    0    0.9375    1.0000
    0    1.0000    1.0000
    0.0625    1.0000    0.9375
    0.1250    1.0000    0.8750
    0.1875    1.0000    0.8125
    0.2500    1.0000    0.7500
    0.3125    1.0000    0.6875
    0.3750    1.0000    0.6250
    0.4375    1.0000    0.5625
    0.5000    1.0000    0.5000
    0.5625    1.0000    0.4375
    0.6250    1.0000    0.3750
    0.6875    1.0000    0.3125
    0.7500    1.0000    0.2500
    0.8125    1.0000    0.1875
    0.8750    1.0000    0.1250
    0.9375    1.0000    0.0625
    1.0000    1.0000         0
    1.0000    0.9375         0
    1.0000    0.8750         0
    1.0000    0.8125         0
    1.0000    0.7500         0
    1.0000    0.6875         0
    1.0000    0.6250         0
    1.0000    0.5625         0
    1.0000    0.5000         0
    1.0000    0.4375         0
    1.0000    0.3750         0
    1.0000    0.3125         0
    1.0000    0.2500         0
    1.0000    0.1875         0
    1.0000    0.1250         0
    1.0000    0.0625         0
    1.0000         0         0
    0.9375         0         0
    0.8750         0         0
    0.8125         0         0
    0.7500         0         0
    0.6875         0         0
    0.6250         0         0
    0.5625         0         0];

if ~exist('font_size','var') || isempty(font_size)
    font_size = 8;
end
if ~exist('font_name','var') || isempty(font_name)
    font_name = 'Arial';
end

if exist('labels','var')
    if isempty(labels)
        clear labels
    end
end

threed_image = squeeze(threed_image);

if ~exist('mask','var')
    mask = [];
end
if isempty(mask)
    mask = double(threed_image ~= 0);
end

if ~exist('spacing','var') || isempty(spacing)
    spacing = 0;
end

if ~exist('comp_rows','var') && ~exist('comp_columns','var')
    comp_rows = [];
    comp_columns = [];
end
if isempty(comp_rows) && isempty(comp_columns)
    % Find an X and Y size that gives aspect ratio of at least 2:1
    len_slices_plot = size(threed_image,3);
    fact_len_slices_plot = sort(factor(len_slices_plot),'descend');
    comp_columns = prod(fact_len_slices_plot(1:2:end));
    comp_rows = prod(fact_len_slices_plot(2:2:end));
    while (comp_columns / comp_rows) > 3
        len_slices_plot = len_slices_plot + 1;
        fact_len_slices_plot = sort(factor(len_slices_plot),'descend');
        comp_columns = prod(fact_len_slices_plot(1:2:end));
        comp_rows = prod(fact_len_slices_plot(2:2:end));
    end
end

% Determine the number to increment from the number of labels
if exist('labels','var')
    num_inc = round(size(threed_image,3) / length(labels));
else
    num_inc = 1;
end

% Find bottom colors for outline and spacing
if exist('threshold','var')
    upper_limit = max(threshold);
    lower_limit = min(threshold);
    step_size = (upper_limit - lower_limit) / 62;
    % Correct below threshold
    threed_image(threed_image < (lower_limit + (step_size/2))) = lower_limit + (step_size/2);
    threed_image(threed_image > upper_limit) = upper_limit;
else
    upper_limit = max(threed_image(:));
    lower_limit = min(threed_image(:));
    step_size = (upper_limit - lower_limit) / 62;
end
black_color = lower_limit - 1*step_size + (step_size/2);
white_color = lower_limit - 2*step_size + (step_size/2);

% Create an image
% Count which TR are on
TR_index = 0;
% Allocate whole image % height,width
%if exist('mask','var')
%    whole_image = nan((size(threed_image,1)+spacing)*comp_rows,(size(threed_image,2)+spacing)*comp_columns);
%else

% Black background always, even if no spacing
if spacing == 0
    image_series_colormap(1,:) = [0 0 0];
end

switch numel(spacing)
    case 1
        whole_image = ones((size(threed_image,1)+spacing)*comp_rows,(size(threed_image,2)+spacing)*comp_columns).*white_color;
    case 2
        whole_image = ones((size(threed_image,1)+spacing(1))*comp_rows,(size(threed_image,2)+spacing(2))*comp_columns).*white_color;
    otherwise
        error('''spacing'' can only have 1 or 2 elements.');
end
%end

for row_index = 1:comp_rows
    for column_index = 1:comp_columns
        % Increment TR shift
        TR_index = TR_index + num_inc;
        if TR_index <= size(threed_image,3)
            % Get image
            this_img = threed_image(:,:,TR_index);
            % Account for mask
            if ismatrix(mask)
                this_img(mask == 0) = black_color;
            else
                this_img(mask(:,:,TR_index) == 0) = black_color;
            end
            this_img(isnan(this_img)) = black_color;
            % Save the part of the image for electrodes 1 and 2
            switch numel(spacing)
                case 1
                    whole_image(((row_index-1)*(size(threed_image,1)+spacing))+(1:size(threed_image,1)), ...
                        ((column_index-1)*(size(threed_image,2)+spacing))+(1:size(threed_image,2))) = ...
                        this_img;
                case 2
                    whole_image(((row_index-1)*(size(threed_image,1)+spacing(1)))+(1:size(threed_image,1)), ...
                        ((column_index-1)*(size(threed_image,2)+spacing(2)))+(1:size(threed_image,2))) = ...
                        this_img;
                otherwise
                    error('''spacing'' can only have 1 or 2 elements');
            end
        end
    end
end

whole_image(isnan(whole_image)) = white_color;

% Plot the images
if nargout == 0
    figure();
    if exist('threshold','var') && ~isempty(threshold)
        imagesc(whole_image,[white_color max(threshold)]);
        
        %---------------显示单个图片时去掉白边------------------
        %imshow(whole_image,'border','tight','initialmagnification','fit','DisplayRange',[white_color max(threshold)]);
        %'border','tight'的组合功能意思是去掉图像周边空白
        %'InitialMagnification','fit'组合的意思是图像填充整个figure窗口
        %set (gcf,'Position',[0,0,512,512])
       %---------------显示单个图片时去掉白边------------------
        
    else
        imagesc(whole_image);
    end
    axis equal;
    axis off;
    % Custom colormap
    % custom_jet = jet;
    % custom_jet(1,:) = [0,0,0];
    % colormap(custom_jet);
    colormap(image_series_colormap);
    % Add labels
    TR_index = 0;
    for row_index = 1:comp_rows
        for column_index = 1:comp_columns
            % Increment TR shift
            TR_index = TR_index + 1;
            % Add the label
            if exist('labels','var')
                if TR_index <= length(labels)
                    switch numel(spacing)
                        case 1
                            if iscell(labels)
                                text(((column_index-1)*(size(threed_image,2)+spacing))+3, ...
                                    ((row_index-1)*(size(threed_image,1)+spacing))+3, ...
                                    [labels{TR_index} 's'],'BackgroundColor',[1 1 1],'Margin',2,...
                                    'FontName',font_name,'FontSize',font_size);
                            else
                                text(((column_index-1)*(size(threed_image,2)+spacing))+3, ...
                                    ((row_index-1)*(size(threed_image,1)+spacing))+3, ...
                                    [num2str(labels(TR_index)) 's'],'BackgroundColor',[1 1 1],'Margin',2,...
                                    'FontName',font_name,'FontSize',font_size);
                            end
                        case 2
                            if iscell(labels)
                                text(((column_index-1)*(size(threed_image,2)+spacing(1)))+3, ...
                                    ((row_index-1)*(size(threed_image,1)+spacing(2)))+3, ...
                                    [labels{TR_index} 's'],'BackgroundColor',[1 1 1],'Margin',2,...
                                    'FontName',font_name,'FontSize',font_size);
                            else
                                text(((column_index-1)*(size(threed_image,2)+spacing(1)))+3, ...
                                    ((row_index-1)*(size(threed_image,1)+spacing(2)))+3, ...
                                    [num2str(labels(TR_index)) 's'],'BackgroundColor',[1 1 1],'Margin',2,...
                                    'FontName',font_name,'FontSize',font_size);
                            end
                        otherwise
                            error('''spacing'' can only have 1 or 2 elements');
                    end
                end
            end
        end
    end
    clear whole_image;
end