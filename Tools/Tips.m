

% 程序自动停在出错的地方
dbstop if error
% 跳到上层workspace
dbup
% 返回上层workspace
dbdown

% link axes

ax(1) = subplot(1,2,1);
plot(x,y1);
ax(2) = subplot(1,2,2);
plot(x,y2);
linkaxes(ax,'x');


% 用右边的axis展示 (适用于2016a）
plot(x,y1);
yyaxis right;
plot(a,y2);

% 把图放到跟屏幕一样大
fig = figure;
set(fig,'position',get(0,'screensize'));

% 去除数据中的NaN/inf
a(isnan(a)) = [];

% 清除除特定变量之外的所有变量
% clearvars -except ax, h

% 程序简单化

function r = fmat2(x)
if x>0
    r = x.^2;
else
    r = 1./x;
end

fmat3 = @(x)x.^2.*(x>0)+1./x.*(x<=0);

% 判断完全也可以这样用

a = 1*(b>0)+2*(b == 0)+3*(b<0);

% 显示进度条
waitbar 