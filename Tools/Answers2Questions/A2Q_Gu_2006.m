% to answer questions for Gu,Y 2006
% why the differences between randomly distributed angle have a
% distribution that have a peak at 90

% LBY 20171120

clear all;
close all;

n = 2000;



%{
azi1 = rand(1,n)*360*pi/180;
azi2 = rand(1,n)*360*pi/180;
ele1 = (rand(1,n)*180-90)*pi/180;
ele2 = (rand(1,n)*180-90)*pi/180;
amp1 = ones(1,n);
amp2 = ones(1,n);
diff = arrayfun(@(a,b,c,d,e,f) angleDiff(a,b,c,d,e,f),azi1*180/pi,ele1*180/pi,amp1,azi2*180/pi,ele2*180/pi,amp2);
figure;
hist(diff);
% figure;
% hist(sin(diff));

% what happened during tranformation from sph2cart?
% 是因为在这种情况下有大量的点集中于ele = +-90，越往赤道走，点的密集程度越弱，造成这种实际上并不真正均匀的现象
% 但是在我们的刺激中，确实是真正均匀分布的
% angle1 = arrayfun(@(a,b,c) sph2cart(a,b,c),azi1,ele1,amp1);
[aa,bb,cc] = arrayfun(@(a,b,c) sph2cart(a,b,c),azi1,ele1,amp1);
figure;
plot3(aa,bb,cc,'.');
%}
%% 如何真正地从球面上取随机点？

azi3 = rand(1,n)*360*pi/180;
ele3_1 = asin(rand(1,n/2));
ele3_2 = -asin(rand(1,n/2));
ele3 = [ele3_1,ele3_2];
ele3 = ele3(randperm(numel(ele3)));
amp = ones(1,n);

azi4 = rand(1,n)*360*pi/180;
ele4_1 = asin(rand(1,n/2));
ele4_2 = -asin(rand(1,n/2));
ele4 = [ele4_1,ele4_2];
ele4 = ele4(randperm(numel(ele4)));

[aa,bb,cc] = arrayfun(@(a,b,c) sph2cart(a,b,c),azi3,ele3,amp);
figure;
plot3(aa,bb,cc,'.');
[aa,bb,cc] = arrayfun(@(a,b,c) sph2cart(a,b,c),azi4,ele4,amp);
figure;
plot3(aa,bb,cc,'.');

% the difference is now randomly distributed
diff = arrayfun(@(a,b,c,d,e,f) angleDiff(a,b,c,d,e,f),azi3*180/pi,ele3*180/pi,amp,azi4*180/pi,ele4*180/pi,amp);
% transform sinusoidally to make it flat
diff = abs(cosd(diff));
figure;
hist(diff);


%% 检验ele的分布
%{
ele_1 = asind(rand(1,n/2));
ele_2 = -asind(rand(1,n/2));
ele = [ele_1,ele_2];
ele = ele(randperm(numel(ele)));
figure;
hist(ele);
%}