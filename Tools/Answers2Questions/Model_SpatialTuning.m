% LBY 20180105

% %{
% close all;
clear all;
theta =-pi:0.1:pi;
nn = 0.1:0.2:1;
x = cos(theta);
pc = 0;

for n = nn
    
    pc = pc+1;
    
    y(pc,:) = (exp(n.*x)-1)./n;
    %     y(pc,:) = (exp(2*n.*x)-1)./n;
    
end
% Normalize the range to [-1,1]
ma = max(y(:));mi = min(y(:));
y = y - (ma + mi)/2;
y = 2*y/(ma - mi);

figure;
set(gcf,'pos',[200 200 1500 700]);
subplot(1,2,1);
plot(theta,y,'linewidth',3);
xlabel('\theta');
ylabel('y(x)');
text(2,1,['n = 0.1:0.2:1']);
subplot(1,2,2);
plot(cos(theta),y,'linewidth',1.5);
xlabel('cos(\theta)');

% suptitle('Spatial tuning');
SetFigure(25);
%}

% %{

clear all;
theta =0:0.1:pi;
oo = -2:0.2:2;
x = cos(theta);
pc = 0;

for o = oo
    
    pc = pc+1;
    y(pc,:) = o+(1-abs(o)).*x;
    
    
end

figure;
set(gcf,'pos',[200 200 1200 500]);
subplot(1,2,1);
plot(theta,y,'linewidth',1.5);
xlabel('\theta');
ylabel('y(x)');
text(2,1,['o = -1:0.2:1']);
subplot(1,2,2);
plot(cos(theta),y,'linewidth',1.5);
xlabel('cos(\theta)');

% suptitle('Spatial tuning');
SetFigure(25);

%}