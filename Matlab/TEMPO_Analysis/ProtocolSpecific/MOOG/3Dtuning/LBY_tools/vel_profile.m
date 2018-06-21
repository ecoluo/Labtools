% velocity profile -> Gaussian function
% LBY 201806

function respon = vel_profile(a,t)

mu = a(1);
sig = a(2);

respon = exp((-(t-mu).^2)./(2*sig.^2));

end