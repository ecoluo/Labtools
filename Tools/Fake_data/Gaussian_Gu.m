%original code
clear;
duration = 1.5;
step=0.005;
t = 0:step:duration;

ampl = 0.13;
num_sigs = 4.5;

figure;
pos = ampl*0.5*(erf(2*num_sigs/3*(t-1)) + 1);
%pos = ampl*normcdf(t,duration / 2,1/num_sigs); 
subplot(2,2,1);
plot(t,pos);
title('position (m)')

veloc = diff(pos)/step;
subplot(2,2,2);
plot(t(1:length(t)-1),veloc,'r-');
title('velocity (m/s)')
max(veloc) 
xlabel('time');

accel = diff(veloc)/step;
subplot(2,2,3);
plot(t(1:length(t)-2),accel,'g-');
title('accel (m/s2)')
max(accel)
xlabel('time');

subplot(2,2,4);
axis('off')
buff = sprintf('ampl = %6.2f, num sigs = %6.2f', ampl, num_sigs);
text(.1,.8,buff);



am = 0.04:0.01:0.32;
sig = 3:1:8;
bb(:,1) = am';
for i = 1:length(am)    
    for j = 1:length(sig)
        t = 0:.01:2;

        ampl = am(i);
        num_sigs = sig(j);

        pos = ampl*0.5*(erf(2*num_sigs/3*(t-1)) + 1);
        veloc = diff(pos)/0.01;
        accel = diff(veloc)/0.01;
           
        aa(i,j) = max(accel);
        bb(i,j+1) = max(accel);
    end
end
figure(3);
contourf(sig,am,aa);
bb
colorbar;
xlabel('sigma');
ylabel('amol(m)');


