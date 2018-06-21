% permutation test for two vectors --GY 09/29/06
% decide whether data are circular

circular = 1;

kernel_u_temp = dlmread('ModeTestData.txt');
a1 = kernel_u_temp(:,1);
a2 = kernel_u_temp(:,2);

diff = a1-a2; % always use the first minus the second


kernel_u = diff;   

if circular == 0
    kernel_u = kernel_u * 2;
end

x_sum = 0;
y_sum = 0;
for i = 1:length(kernel_u)
    [x,y] = pol2cart(kernel_u(i)*pi/180, 1);
    x_sum = x_sum + x;
    y_sum = y_sum + y;    
end
[azi, r] =cart2pol(x_sum,y_sum);
amplitude = sqrt(x_sum^2 + y_sum^2)/length(kernel_u);
R = amplitude;
PreferDirection = azi*180/pi;
if PreferDirection< 0
    PreferDirection = PreferDirection + 360;
end

if circular == 0
   PreferDirection = PreferDirection / 2;
end

% do permutation now
num_perm = 1000;

for b = 1 : num_perm   
    b
    order = randperm(length(kernel_u));
    for j =  1: length(kernel_u) 
        % only permute one dataset is enough
        a1_perm(j,1) = a1(order(j),1);            
    end
    diff_perm = a1_perm - a2;
    kernel_u_boot = diff_perm;
    
    if circular == 0
        kernel_u_boot = kernel_u_boot * 2;
    end
    
    x_sum = 0;
    y_sum = 0;
    for i = 1:length(kernel_u)
        [x,y] = pol2cart(kernel_u_boot(i)*pi/180, 1);
        x_sum = x_sum + x;
        y_sum = y_sum + y;    
    end
    amplitude_boot(b) = sqrt(x_sum^2 + y_sum^2)/length(kernel_u);    
end

% now calculate p value or significant test
bin =0.005;
x_bin = 0 : 0.005 : 1;

hist_perm = hist( amplitude_boot, x_bin );  % for permutation
bin_sum = 0;
n = 0;
while ( n < (amplitude/bin) )
      n = n+1;
      bin_sum = bin_sum + hist_perm(n);
      p = (num_perm - bin_sum)/ num_perm;   
end 
p
PreferDirection
R