% acceleration function -> Diff of Gaussian function
% LBY 20170326,20200408

function respon = acc_func_1D(a,t)

mu = a(1);
sig = a(end);
% sig = sqrt(sqrt(2))/6;
% b = a(end); % add for threshold LBY20180105

% Original
respon = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2));
respon = respon./(max(respon)-min(respon));

%{
respon = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2)); 
respon = (respon-min(respon))./(max(respon)-min(respon));
respon = respon - b;
respon(respon<0) = 0;
respon = respon./(max(respon)-min(respon))-0.5;
%}

%{
respon = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2))-b; 
respon(respon<0) = 0;
respon = respon./(max(respon)-min(respon));% add b for threshold LBY20180105
respon = respon - (max(respon)+min(respon))/2;
%}

end