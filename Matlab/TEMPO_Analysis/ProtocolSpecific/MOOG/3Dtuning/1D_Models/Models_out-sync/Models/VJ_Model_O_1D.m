% Velocity-jerk model for 3D tuning 20170602LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = VJ_Model_O_1D(a,st_data)

u_azi = st_data(1:8);
t = st_data(9:end);


% velocity model
% time profile
vel_time = vel_func(a(3), t);
% spatial profiles
azi_v = cos_tuning_1D(a(4:6), u_azi);


% jerk model
%time profile
jerk_time = jerk_func(a(11), t);
%spatial profiles
azi_j = cos_tuning_1D(a(4:6), u_azi);

%compute results
r = zeros(length(azi_v), length(vel_time));
for i=1:size(r,1),
        rr =a(1)*(a(10)*azi_v(i)*vel_time + (1-a(10))*azi_j(i)*jerk_time)+ a(2);
        rr(find(rr<0))  = 0;
        r(i,:) = rr;
end

end
