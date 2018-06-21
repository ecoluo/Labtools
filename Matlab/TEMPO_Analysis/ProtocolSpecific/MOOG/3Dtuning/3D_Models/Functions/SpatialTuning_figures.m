% figures of spatial tuning
% LBY 20180514



% n = 0.1;
n = [0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 ];
coord = [-90 -45 0 45 90 270 225 180 135 90 45 0 315];
u_ele = coord(1:5);
u_azi = coord(6:13);
[ele, azi] = meshgrid(u_ele, u_azi);
AziPre = 90;
ElePre = 0;
x =  degtorad(Angle3D_paired(azi,AziPre, ele,ElePre));

figure(111);
set(gcf,'pos',[30 50 1800 600]);
clf;
[~,h_subplot] = tight_subplot(2,length(n)/2,0.05,0.1);

for ii = 1:length(n)
    
    axes(h_subplot(ii));
    F = (exp(n(ii).*x(:))-1)./n(ii);
    plot(F);
end

%}
%% Spatial tuning from YLH
%{
figure;
Azi1 = 0:45:360;
Ele1 = 0;
Azi2 = 80;
Ele2 = 45;
y1 = Angle3D_paired(Azi1,Azi2, Ele1,Ele2);

for ii = 1:length(Azi1)
    y2(ii) = angleDiff(Azi1(ii),Ele1,1,Azi2,Ele2,1);
end

plot(y1);
%}