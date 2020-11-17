% draw optic flow
% LBY 20200806


% generate unformly distributed x and y
xx = -2:0.3:2;
yy = -2:0.3:2;
[x,y] = meshgrid(xx,yy);

% calculate the angle between each vector and x axis
[theta,~] = cart2pol(x,y);
theta = theta*180/pi;

r = sqrt(x.^2+y.^2); % change the length of arrows

% rotation, CCW
figure;
u = r.*sind(360-theta);
v = r.*cosd(theta);
quiver(x,y,u,v);

% rotation, CW
figure;
u = -r.*sind(360-theta);
v = -r.*cosd(theta);
quiver(x,y,u,v);

% expansion
figure;
u = r.*cosd(theta);
v = r.*sind(theta);
quiver(x,y,u,v);

% contraction
figure;
u = -r.*cosd(theta);
v = -r.*sind(theta);
quiver(x,y,u,v);

% spiral expansion
figure;
u = r.*(cosd(theta)+sind(360-theta));
v = r.*(sind(theta)+cosd(theta));
quiver(x,y,u,v);

% spiral contraction
figure;
u = r.*(-cosd(theta)+sind(360-theta));
v = r.*(-sind(theta)+cosd(theta));
quiver(x,y,u,v);



