% calculate DDI at each timebin
% LBY 20200817
% data, (directions*nBins*repetation)

function [DDI, DDI_p] = DDI_cal(data)

if isempty(data)
    DDI = nan;
    DDI_p = nan;
    return;
end


for ii = 1:size(data,2) % on each time bin
% for ii = 36 % on each time bin
    for dd = 1:size(data,1) % each direction
        temp = [];
        resp_sse(dd) = sum((data(dd,ii,:) - mean(data(dd,ii,:))).^2);
        resp_trialnum(dd) = size(data(dd,ii,:),3);
        
    end
%     maxData = max(max(data(:,ii,:)));
%     minData = min(min(data(:,ii,:)));
maxData = max(nanmean(data(:,ii,:),3));
    minData = min(nanmean(data(:,ii,:),3));
    
    resp_std = sum(resp_sse)/(sum(resp_trialnum)-26);
    DDI(ii) = (maxData-minData)/(maxData-minData+2*sqrt(resp_std));
    
%     % DDI permutation
%     num_perm = 1000;
%     for nn = 1 : num_perm
%         temp = squeeze(data(:,ii,:));
%         temp = temp(:);
%         temp = temp(randperm(26*size(data,3)));
%         temp = reshape(temp,26,[]);
%         temp = nanmean(temp,2);
%         maxSpkRealMean_perm_t(nn) = max(temp);
%         minSpkRealMean_perm_t(nn) = min(temp);
%         DDI_perm_t(nn) = (maxSpkRealMean_perm_t(nn)-minSpkRealMean_perm_t(nn))/(maxSpkRealMean_perm_t(nn)-minSpkRealMean_perm_t(nn)+2*sqrt(resp_std));
%         
%     end
%     DDI_p(ii) = sum(DDI_perm_t(nn)>DDI(ii))/num_perm;
DDI_p = nan;
end

end