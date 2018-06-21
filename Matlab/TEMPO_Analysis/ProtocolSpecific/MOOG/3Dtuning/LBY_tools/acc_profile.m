% acceleration profile -> Diff of Gaussian function
% LBY 201806

function respon = acc_profile(a,t)

mu = a(1);
sig = a(2);

respon = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2));


end