% Jerk-only model for 3D tuning 20190414LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = JO_Model_1D(a,st_data)

u_azi = st_data(1:8);
t = st_data(9:end);


%time profile
jerk_time = jerk_func(a(3), t);

%spatial profiles
azi = cos_tuning_1D(a(4:6), u_azi);

%compute results
r = zeros(length(azi), length(jerk_time));
for i=1:length(azi)
        rr = a(1)*azi(i)*jerk_time + a(2);
        rr(find(rr<0))  = 0;
        r(i,:) = rr;
end

end
