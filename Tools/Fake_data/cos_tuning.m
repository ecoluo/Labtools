

function r = cos_tuning(preDir, coord)
u_ele = coord(1:5);
u_azi = coord(6:13);

n1 = 0.1; % nonlinearty
azi1 = preDir(1); % preferred azi
ele1 = preDir(2); % preferred ele

%Squeezing Nonlinearity
F = @(x,n)((exp(n.*x)-1)./n);

%Surface grid
[ele, azi] = meshgrid(u_ele, u_azi);
[x, y, z] = sph2cart(azi, ele, ones(size(azi)));

%Cosine tuning
[x1, y1, z1] = sph2cart(azi1, ele1, 1);
if n1 == 0
    r = [x(:) y(:) z(:)]*[x1 y1 z1]' ;
else
    r = F([x(:) y(:) z(:)]*[x1 y1 z1]', n1);
end
ma = F(1, n1);mi = F(-1, n1);
r = r - (ma + mi)/2;
r = 2*r/(ma - mi);
%     disp([n1]);disp([mi ma]);disp(r(1))
end