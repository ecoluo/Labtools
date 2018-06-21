% plot 3D directions (n = 26)
% LBY 20180515

u_azi = (0:45:315)/180*pi;
u_ele = (-45:45:45)/180*pi;


azi = repmat(u_azi,length(u_ele),1);
ele = repmat(u_ele,length(u_azi),1)';
amp = ones(length(u_ele),length(u_azi));
[x,y,z] = sph2cart(azi,ele,amp);


figure;
plot3([zeros(26,1) [x(:);0;0]]',[zeros(26,1) [y(:);0;0]]',[zeros(26,1) [z(:);1;1]]','k.','markersize',15);hold on;
plot3([zeros(26,1) [x(:);0;0]]',[zeros(26,1) [y(:);0;0]]',[zeros(26,1) [z(:);1;1]]','k-','linewidth',1.5);

xlabel('x');
ylabel('y');
zlabel('z');
