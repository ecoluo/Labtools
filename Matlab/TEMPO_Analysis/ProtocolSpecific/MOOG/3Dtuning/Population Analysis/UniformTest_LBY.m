% Uniform test for general 
% adapted from GY
% LBY 20171218
% matlab function-> chi2gof is effective

function [h,p] = UniformTest_LBY(data,nbins,num_perm)

if nargin == 1
    nbins = 10;
    num_perm = 2000;
elseif nargin == 2
    num_perm = 2000;
end

dim = size(data);

hist_raw = hist(data,nbins);
R = sum( (hist_raw - mean(hist_raw)).^2 );

% do permutation now, bin first, and then permute the bin
for nn = 1 : num_perm

    uniform_data = rand(1,dim(1));
    hist_uniform = hist(uniform_data);
    R_perm(nn) = sum( (hist_uniform - mean(hist_raw)).^2 );
%     plot(hist_raw_perm,'b-');
    hold on;
end


% return p value
p =length(find(R_perm<R)) / num_perm;
if p < 0.05
    h = 1;
else
    h = 0;
end

end

