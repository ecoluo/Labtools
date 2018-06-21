% LBY 20180105



clc;
theta = -1*pi:0.1:pi;

x = cos(theta);
figure;
pc = 0;
for n = 0.1:0.2:1

pc = pc+1;
a(pc,:) = (exp(n.*x)-1)./n;


end

plot(theta,a,'linewidth',1.5);

SetFigure(25);
