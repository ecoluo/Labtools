% position profile -> integration of Gaussian function
% LBY 20210113

function respon = pos_profile(a,t)

mu = a(1);
sig = a(2);

respon = cumsum(exp((-(t-mu).^2)./(2*sig.^2)));

end