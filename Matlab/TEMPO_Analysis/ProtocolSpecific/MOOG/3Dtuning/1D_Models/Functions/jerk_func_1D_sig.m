% jerk function -> the Diff of Diff of Gaussian function
% LBY 20170326,20200408

function respon = jerk_func_1D_sig(a,t)

mu = a(1);
sig = a(end);
% sig = 1.5/2/4.5; % sig =  duration/2/num_of_sigma

respon = ((t-mu).^2-sig.^2)./sig.^4.*exp((-(t-mu).^2)./(2*sig.^2));
respon = respon./(max(respon)-min(respon));
% respon = mapminmax(respon',0,1)';

end