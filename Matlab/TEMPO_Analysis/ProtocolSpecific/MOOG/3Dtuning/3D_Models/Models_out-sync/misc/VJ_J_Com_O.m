% Acceleration-only model for 3D tuning 20180618LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = VJ_J_Com_O(a,st_data)

u_ele = st_data(1:5);
u_azi = st_data(6:13);
t = st_data(14:end);

%time profile
jerk_time = jerk_func(a(9), t);
% jerk_time = jerk_func([a(3) a(4) a(end)], t);

%spatial profiles
ele_azi = cos_tuning(a(4:7), [u_ele; u_azi]);
ele_azi = reshape(ele_azi, length(u_azi), length(u_ele));

%compute results
r = zeros(size(ele_azi,1), size(ele_azi,2), length(jerk_time));
for i=1:size(r,1),
    for j=1:size(r,2),
        rr = (1-a(8))*a(1)*ele_azi(i,j)*jerk_time + a(2);
        rr(find(rr<0))  = 0;
        r(i,j,:) = rr;
    end
end

end
