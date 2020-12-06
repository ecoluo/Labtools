% Velocity-acceleration model for 1D tuning 20190410LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% t is PSTH time points

function r = VA_Model_1D_sig(a,st_data)

u_azi = st_data(1:8);
t = st_data(9:end);


% velocity model
% time profile
vel_time = vel_func_1D_sig([a(3) a(end)], t);
% spatial profiles
azi_v = cos_tuning_1D(a(4:6), u_azi);

% acceleration model
%time profile
acc_time = acc_func_1D_sig([a(3) a(end)], t);
%spatial profiles
azi_a = cos_tuning_1D(a(7:9), u_azi);



%compute results
r = zeros(length(azi_v), length(vel_time));
for i=1:size(r,1)
        rr =a(1)*(a(10)*azi_v(i)*vel_time + (1-a(10))*azi_a(i)*acc_time)+ a(2);
        rr(find(rr<0))  = 0;
        r(i,:) = rr;
end


end
