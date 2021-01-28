% velocity function -> Gaussian function
% LBY 20170326

function respon = vel_func(a,t)

mu = a(1);
% sig = a(2);
sig = 1.5/2/4.5; % sig =  duration/2/num_of_sigma

respon = exp((-(t-mu).^2)./(2*sig.^2));
% respon = respon./(max(respon)-min(respon));
respon = (respon-min(respon))./(max(respon)-min(respon));

end