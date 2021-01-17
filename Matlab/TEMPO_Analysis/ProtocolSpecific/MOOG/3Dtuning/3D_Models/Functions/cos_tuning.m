function r1 = cos_tuning(param, coord)

        u_ele = coord(1:5);
        u_azi = coord(6:13);
    
    n1 = param(1); % nonlinearty
    azi1 = param(2); % preferred azi
    ele1 = param(3); % preferred ele
    

    %Squeezing Nonlinearity
%     F = @(x,n)((exp(n.*x)-1)./n);
F = @(x,n)((1-abs(n)).*x); % Laurens, elife, 2017
    
    %Surface grid
    [ele, azi] = meshgrid(u_ele, u_azi);  
    [x, y, z] = sph2cartd(azi, ele, ones(size(azi)));
    
    %Cosine tuning
    [x1, y1, z1] = sph2cartd(azi1, ele1, 1);
    if n1 == 0
        r1 = [x(:) y(:) z(:)]*[x1 y1 z1]' ;
    else
        r1 = F([x(:) y(:) z(:)]*[x1 y1 z1]', n1);
    end
    ma = F(1, n1);mi = F(-1, n1);
    % Normalize the range to [-1,1]
    r1 = r1 - (ma + mi)/2;
    r1 = 2*r1/(ma - mi);
    
    %{
    DC = param(4);
    r1 = r1+DC; 
    %}
    
%         %{
    
    r1 = r1+n1; % Laurens, elife, 2017
    %}
    
%     disp([n1]);disp([mi ma]);
%     disp(r1(1))
end