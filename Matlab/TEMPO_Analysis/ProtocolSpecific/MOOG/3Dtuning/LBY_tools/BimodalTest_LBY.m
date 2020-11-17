% Bimodal test for general
% adapted from GY
% LBY 20171218

function [h,p] = BimodalTest_LBY(data,nbins,num_perm)

if nargin == 1
    nbins = 10;
    num_perm = 2000;
elseif nargin == 2
    num_perm = 2000;
end

dim = size(data);

% for bimodal data
r=0.5;
mu1=0.2;
sigma1=0.3;
mu2=0.8;
sigma2=0.3;
bimodal_data=zeros(1,dim(1));

hist_raw = hist(data,nbins);
R = sum( (hist_raw - mean(hist_raw)).^2 );

% do permutation now, bin first, and then permute the bin
for nn = 1 : num_perm
    for i=1:dim(1)
        r1=rand;
        bimodal_data(i)=(mu2+sigma2*randn)*heaviside(r1-r)+(mu1+sigma1*randn)*heaviside(r-r1);
    end
    hist_bi = hist(bimodal_data);
    R_perm(nn) = sum( (hist_bi - mean(hist_raw)).^2 );
    %     plot(hist_raw_perm,'b-');
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