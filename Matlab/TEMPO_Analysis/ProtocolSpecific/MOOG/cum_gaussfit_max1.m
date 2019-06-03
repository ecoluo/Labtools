% function [bias, threshold] = cum_gaussfit_max1(data_cum,{method},{tolerance%})

% Originally modified by GY from GCD (cum_gaussfit_max.m)
% Gaussian fits a accumulative Gaussian function to data using maximum likelihood maximization under binomial assumptions.  
% It uses Gaussian_Fun for error calculation.  Data must be in 3 columns: x, %-correct, Nobs（number of observations)
% usage: [bias, threshold] = cum_gaussfit_max1(data_cum,method,tolerance)
%		   bias and threshold are the mu and standard deviation parameters.

% HH20150427 I put the original cost function "cum_gaussfit_max1.m" at the end of this mfile for clarity, 
% and I also add two parameters:
%    'method', 0 = Maximum likelihood (default), 1 = Square error
%    'tolerance', 0 = No tolerance (default), others = % error tolerance of the max abs(heading)

function [bias, threshold] = cum_gaussfit_max1(data_cum,method,tolerance)


if nargin < 2 || isempty(method)
    tolerance = 0; % Default: no tolerance
    method = 0; % Default: Maximum likelihood
elseif nargin < 3
    tolerance = 0; % Default: no tolerance
end

data_cum(isnan(data_cum(:,2)),:) = [];
data_cum = sort(data_cum);

% Tolerance method. % HH20150427
% Tolerance： 当最大角度的正确率在一定范围内时，将其正确率设为100%
% eg. tolerance == 10， 最大角度的正确率在90%以上时设为100%
if tolerance > 0
     if data_cum(1,2) <= tolerance / 100  % Tolerance for min heading
         data_cum(1,2) = 0;
     end
     if data_cum(end,2) >= 1-tolerance/100 % Tolerance for max heading
         data_cum(end,2) = 1;
     end
end

% generate guess
q0 = ones(2,1);

% get a starting threshold estimate by testing a bunch of values
% bias range from [-100,-10,-1,0,1,10,100]
% threshold ranges from [0.1,1,10,100]
bias_e = [-100,-10,-1,0,1,10,100];
threshold_e = [0.1,1,10,100];
errors=[];

% Original value is very important
% So we first find estimate values for bias and threshold
for i=1:length(bias_e)
    for j=1:length(threshold_e)
        q0(1,1) = bias_e(i);
        q0(2,1) = threshold_e(j);
        errors(i,j) = cost_function(q0,data_cum,method);
    end
end
[min_indx1,min_indx2] = find(errors==min(min(errors)));
q0(1,1) = bias_e(min_indx1(1));
q0(2,1) = threshold_e(min_indx2(1));

% Begin optimization
OPTIONS = optimset('MaxIter', 5000);
quick = fminsearch(@(q)cost_function(q,data_cum,method),q0);
% fminsearch: unconstrained nonlinear optimization; method: derivative-free
% X = fminsearch(fun(x),x0) 从x0开始，找到函数fun中的局部最小值x,返回x的值到X

% Output
bias = quick(1,1);
threshold = quick(2,1);


function err = cost_function(q,data_cum,method)
%   Cummaltive Function
%	returns the error between the data and the
%	values computed by the current function of weibul params.
%	assumes a function of the form
%
%	  y = normcdf(x,q(1),q(2));
%
%	thus q(1) is u, and q(2) is sigma.
%	The data is in columns such that Data(:,1) is abscissa
%	Data(:,2) is observed percent correct (0..1)
%	Data(:,3) is number of observations.
%	The value of err is the -log likelihood of obtaining Data
%	given the parameters q.
%

TINY = 1e-10;
x = data_cum(:,1); % angle 
y = data_cum(:,2); % %correct

try
    n = data_cum(:,3); % number of total trials for this angle
catch
    n = ones(size(x));
end

z = normcdf(x,q(1),q(2)); % p = normcdf(x,mu,sig)
z = z - (z > .999999)*TINY + (z < .0000001)*TINY; % 为什么要这样减？好像没什么影响？

if method == 0
    llik = n .* y .* log(z) +  n .* (1-y) .* log(1-z);
    err = -sum(llik);
    % https://math.stackexchange.com/questions/886555/deriving-cost-function-using-mle-why-use-log-function
elseif method == 1
    err = norm(z-y); % 2-norm: sqrt(x1+x2+x3+...+xn)
end


