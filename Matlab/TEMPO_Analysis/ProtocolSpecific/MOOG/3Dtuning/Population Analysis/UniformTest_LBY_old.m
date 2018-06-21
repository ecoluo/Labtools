% Uniform test for delta preferred direction, base on permutation
% adapted from GY
% LBY 20171127

function [h,p] = UniformTest_LBY(data,nbins,num_perm)

if nargin == 1
    nbins = 10;
    num_perm = 2000;
elseif nargin == 2
    num_perm = 2000;
end

dim = size(data);
index_n = 1:dim(1);
for ii = 1:dim(1)
angle_diff(ii) = angleDiff(data(ii,1),data(ii,2),data(ii,3),data(ii,5),data(ii,5),data(ii,6));
end
hist_raw = hist(angle_diff,nbins);
R = sum( (hist_raw - mean(hist_raw)).^2 );

% do permutation now, bin first, and then permute the bin
for nn = 1 : num_perm
    index_perm = index_n( randperm(length(data)) );
    for i = 1:dim(1)
        angle_diff_perm(i) = angleDiff(data(index_perm(i),1),data(index_perm(i),2),data(index_perm(i),3),data(i,5),data(i,5),data(i,6));
    end
    hist_raw_perm = hist(angle_diff_perm,nbins);
    R_perm(nn) = sum( (hist_raw_perm - mean(hist_raw)).^2 );
    plot(hist_raw_perm,'b-');
    hold on;
end


% return p value
p =length(find(R_perm>R)) / num_perm;
if p < 0.05
    h = 1;
else
    h = 0;
end

end