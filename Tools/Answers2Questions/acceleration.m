% acceleration 
% LBY 20180515



x1 = 0:0.1:2*pi;
y1 = sin(x1);

figure;
plot(x1,y1); hold on;

%%%%%%%%%%%%% tranform according to specific angle

angle = pi/6; % change the rotation angle here

[theta,rho] = cart2pol(x1,y1);
theta_trans = theta + angle;
[x2,y2] = pol2cart(theta_trans,rho);

% figure;
plot(x2,y2,'r--');hold on;

%%%%%%%%%%%%% calculate the projection of transformed results to x axis

plot(x1,y2,'g.');





a;