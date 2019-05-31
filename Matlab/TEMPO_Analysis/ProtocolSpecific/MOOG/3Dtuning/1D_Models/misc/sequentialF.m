% sequential F test
% please check https://en.wikipedia.org/wiki/F-test
% model 2 have more parameters that model 1
% n1: free parameters of model 1      n2: free parameters of model 2
% N: data points
% LBY 20181120

function [F, p] = sequentialF(rss1,n1,rss2,n2,N)
if length(rss1) == length(rss2)
    F = nan(length(rss1),1);
    p = nan(length(rss1),1);
    
    for ii = 1:length(rss1)
        F(ii) = ((rss1(ii)-rss2(ii))/(n2-n1))/(rss2(ii)/(N-n2));
        p(ii) = 1 - fcdf(F(ii),n2 - n1,N - n2 );
    end
else
    disp('length of rss1 & rss 2 is not equal, please check ');
end
end