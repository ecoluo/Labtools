% jerk profile -> Diff of diff of Gaussian function
% LBY 20210113

function respon = jerk_profile(a,t)

mu = a(1);
sig = a(2);


respon = ((t-mu).^2-sig.^2)./sig.^4.*exp((-(t-mu).^2)./(2*sig.^2));

end