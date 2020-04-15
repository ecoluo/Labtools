% position function -> the integration of Gaussian function
% LBY 20170326,20200408

function respon = pos_func_1D(a,t)

mu = a(1);
sig = a(end);
% sig = sqrt(sqrt(2))/6;

respon = cumsum(exp((-(t-mu).^2)./(2*sig.^2)));
respon = respon./(max(respon)-min(respon));


end