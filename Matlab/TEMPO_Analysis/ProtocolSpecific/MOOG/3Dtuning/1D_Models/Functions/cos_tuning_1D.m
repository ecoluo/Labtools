function r1 = cos_tuning(param, coord)

        u_azi = coord(1:8);
    
    n1 = param(1); % nonlinearty
    azi1 = param(2); % preferred azi
    

    %Squeezing Nonlinearity
    F = @(x,n)((exp(n.*x)-1)./n);
    
    %Surface grid
    [x, y] = pol2cart(deg2rad(u_azi), ones(size(u_azi)));
    
    %Cosine tuning
    [x1, y1] = pol2cart(deg2rad(azi1), 1);
    if n1 == 0
        r1 = [x(:) y(:) ]*[x1 y1]' ;
    else
        r1 = F([x(:) y(:) ]*[x1 y1]', n1);
    end
    ma = F(1, n1);mi = F(-1, n1);
    % Normalize the range to [-1,1]
    r1 = r1 - (ma + mi)/2;
    r1 = 2*r1/(ma - mi);
    
%     %{
    DC = param(3);
    r1 = r1+DC;
    %}
    
%     disp([n1]);disp([mi ma]);
%     disp(r1(1))
end