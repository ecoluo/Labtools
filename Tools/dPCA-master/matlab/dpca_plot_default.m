function dpca_plot_default(data, time, yspan, explVar, compNum, events, signif, marg,stimInd)

% Modify this function to adjust how components are plotted.
%
% Parameters are as follows:
%   data      - data matrix, size(data,1)=1 because it's only one component
%   time      - time axis
%   yspan     - y-axis spab
%   explVar   - variance of this component
%   compNum   - component number
%   events    - time events to be marked on the time axis
%   signif    - marks time-point where component is significant
%   marg      - marginalization number


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displaying legend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(data, 'legend')
    
    % if there is only time and no other parameter - do nothing
    if length(time) == 2
        return
        
        % if there is one parameter
    elseif length(time) == 3
        numOfStimuli = time(2); % time is used to pass size(data) for legend
        colors = lines(numOfStimuli);
        hold on
        
        for f = 1:numOfStimuli
            plot([0.5 1], [f f], 'color', colors(f,:), 'LineWidth', 2)
            text(1.2, f, ['Stimulus ' num2str(f)])
        end
        axis([0 3 -1 1.5+numOfStimuli])
        set(gca, 'XTick', [])
        set(gca, 'YTick', [])
        set(gca,'Visible','off')
        return
        
        % two parameters: stimulus and decision (decision can only have two
        % values)
    elseif length(time) == 4 && time(3) == 2
        numOfStimuli = time(2); % time is used to pass size(data) for legend
        colors = lines(numOfStimuli);
        hold on
        
        for f = 1:numOfStimuli
            plot([0.5 1], [f f], 'color', colors(f,:), 'LineWidth', 2)
            text(1.2, f, ['Stimulus ' num2str(f)])
        end
        plot([0.5 1], [-2 -2], 'k', 'LineWidth', 2)
        plot([0.5 1], [-3 -3], 'k--', 'LineWidth', 2)
        text(1.2, -2, 'Decision 1')
        text(1.2, -3, 'Decision 2')
        
        axis([0 3 -4.5 1.5+numOfStimuli])
        set(gca, 'XTick', [])
        set(gca, 'YTick', [])
        set(gca,'Visible','off')
        return
        
        % other cases - do nothing
    else
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting up the subplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(time)
    time = 1:size(data, ndims(data));
end
axis([time(1) time(end) yspan])
hold on

if ~isempty(explVar)
    title(['Component #' num2str(compNum) ' [' num2str(explVar,'%.1f') '%]'])
else
    title(['Component #' num2str(compNum)])
end

if ~isempty(events)
    plot([events; events], yspan, 'Color', [0.6 0.6 0.6])
end

if ~isempty(signif)
    signif(signif==0) = nan;
    plot(time, signif + yspan(1) + (yspan(2)-yspan(1))*0.05, 'k', 'LineWidth', 3)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting the component
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ndims(data) == 2
    % only time - plot it
    plot(time, squeeze(data(1, :)), 'k', 'LineWidth', 2)
    
elseif ndims(data) == 3
    % different stimuli in different colours
    numOfStimuli = size(data, 2);
    %     plot(time, squeeze(data(1,:,:)), 'LineWidth', 2)
    colors = lines(numOfStimuli);
    colorDefsLBY;
    colors(:,:) = repmat(colorLGray,[size(colors,1),1]);
    
    switch stimInd
        case 1
            
            colors(14,:) = colorDBlue; colors(10,:) = colorDRed; % left,right
            colors([5:7,13,15,21:23],:) = repmat(colorLBlue,[8,1]);colors([2,3,9,11,17,18,19,25],:) = repmat(colorLRed,[8,1]);% left-right

        case 2
            
            colors(1,:) = colorDBlue; colors(26,:) = colorDRed; % up,down
            colors(2:9,:) = repmat(colorLBlue,[8,1]);colors(18:25,:) = repmat(colorLRed,[8,1]);% up-down
            
        case 3
            
            colors(12,:) = colorDBlue; colors(16,:) = colorDRed; % for,back
            colors([3:5,11,13,19:21],:) = repmat(colorLBlue,[8,1]);colors([7:9,15,17,23:25],:) = repmat(colorLRed,[8,1]);% for-back

    end
    
    
    for f=1:numOfStimuli
        plot(time, squeeze(data(1, f, :)), 'color', colors(f,:), 'LineWidth', 1)
    end
    
elseif ndims(data) == 4 && size(data,3)==2
    % different stimuli in different colours and binary condition as
    % solid/dashed
    numOfStimuli = size(data, 2);
    colors = lines(numOfStimuli);
    colorDefsLBY;
    colors(:,:) = repmat(colorLGray,[size(colors,1),1]);
    
    colors(14,:) = colorDRed; colors(10,:) = colorDBlue; % left,right
    colors([2,3,9,10,11,17,18,19,25],:) = repmat(colorLBlue,[9,1]);colors([5:7,13:15,21:23],:) = repmat(colorLRed,[9,1]);% left-right
    
    
    %         colors(1,:) = colorDRed; colors(26,:) = colorDBlue; % up,down
    %     colors(2:9,:) = repmat(colorLBlue,[8,1]);colors(18:25,:) = repmat(colorLRed,[8,1]);% up-down
    
    %     colors(12,:) = colorDRed; colors(16,:) = colorDBlue; % for,back
    %     colors([3:5,11:13,19:21],:) = repmat(colorLBlue,[9,1]);colors([7:9,15:17,23:25],:) = repmat(colorLRed,[9,1]);% for-back
    
    
    
    
    for f=1:numOfStimuli
        plot(time, squeeze(data(1, f, 1, :)), 'color', colors(f,:), 'LineWidth', 1)
        plot(time, squeeze(data(1, f, 2, :)), '--', 'color', colors(f,:), 'LineWidth', 1)
    end
    
else
    % in all other cases pool all conditions and plot them in different
    % colours
    data = squeeze(data);
    dims = size(data);
    data = permute(data, [numel(dims) 1:numel(dims)-1]);
    data = reshape(data, size(data,1), []);
    data = data';
    
    colorDefsLBY;
    colors(:,:) = repmat(colorLGray,[size(colors,1),1]);
    
    colors(14,:) = colorDRed; colors(10,:) = colorDBlue; % left,right
    colors([2,3,9,10,11,17,18,19,25],:) = repmat(colorLBlue,[9,1]);colors([5:7,13:15,21:23],:) = repmat(colorLRed,[9,1]);% left-right
    
    
    %         colors(1,:) = colorDRed; colors(26,:) = colorDBlue; % up,down
    %     colors(2:9,:) = repmat(colorLBlue,[8,1]);colors(18:25,:) = repmat(colorLRed,[8,1]);% up-down
    
    %     colors(12,:) = colorDRed; colors(16,:) = colorDBlue; % for,back
    %     colors([3:5,11:13,19:21],:) = repmat(colorLBlue,[9,1]);colors([7:9,15:17,23:25],:) = repmat(colorLRed,[9,1]);% for-back
    
    
    %     plot(time, data, 'LineWidth', 2)
    for f=1:numOfStimuli
        plot(time, squeeze(data(1, f, 1, :)), 'color', colors(f,:), 'LineWidth', 1)
        plot(time, squeeze(data(1, f, 2, :)), '--', 'color', colors(f,:), 'LineWidth', 1)
    end
    
end
