% Position-Velocity-acceleration-jerk model for 3D tuning 20170603LBY
% a is aeter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = PVAJ_Model_O_1D(a,st_data)

u_azi = st_data(1:8);
t = st_data(9:end);


%position model
% time profile
pos_time = pos_func(a(3)+a(21), t);
% spatial profiles
azi_p = cos_tuning_1D(a(13:15), u_azi);

% velocity model
% time profile
vel_time = vel_func(a(3)+a(19), t);
% spatial profiles
azi_v = cos_tuning_1D(a(4:6), u_azi);

% acceleration model
%time profile
acc_time = acc_func(a(3), t);
%spatial profiles
azi_a = cos_tuning_1D(a(7:9), u_azi);

% jerk model
%time profile
jerk_time = jerk_func(a(3)+a(20), t);
%spatial profiles
azi_j = cos_tuning_1D(a(10:12), u_azi);


%compute results
r = zeros(length(azi_a), length(acc_time));
for i=1:size(r,1),
        rr =a(1)*( ...
            (1-a(18))*( ...
            (1-a(17))*( ...
            a(16)*azi_p(i)*pos_time + ...
            (1-a(16))*azi_v(i)*vel_time) + ...
            a(17)*azi_a(i)*acc_time) + ...
            a(18)*azi_j(i)*jerk_time) + ...
            a(2);
        rr(find(rr<0))  = 0;
        r(i,:) = rr;
end
end
