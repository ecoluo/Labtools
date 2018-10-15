% to transform 5*8 directions to 26 direction

function data1D =  inversePackSpatial(sData)


% data1D = [sData(1,1), sData(2,:),sData(3,:),sData(4,:), sData(5,1)];

% data1D = cellfun(@(x) [x(1,1), x(2,:),x(3,:),x(4,:), x(5,1)],sData);

for ii = 1:length(sData)
    if isnan(sData{ii})
        data1D(ii,:) = nan*ones(1,26);
    else
        data1D(ii,:) = [sData{ii}(1,1), sData{ii}(2,:),sData{ii}(3,:),sData{ii}(4,:), sData{ii}(5,1)];
    end
end


end