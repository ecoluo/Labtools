% Velocity-only model for 3D tuning 20170321LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = VA_V_Com_O(a,st_data)

u_ele = st_data(1:5);
u_azi = st_data(6:13);
t = st_data(14:end);


%time profile
vel_time = vel_func(a(3)+a(9), t);

%spatial profiles
ele_azi = cos_tuning(a(4:7), [u_ele; u_azi]);
ele_azi = reshape(ele_azi, length(u_azi), length(u_ele));

%compute results
r = zeros(size(ele_azi,1), size(ele_azi,2), length(vel_time));
for i=1:size(r,1),
    for j=1:size(r,2),
        rr = a(8)*a(1)*ele_azi(i,j)*vel_time + a(2);
        rr(find(rr<0))  = 0;
        r(i,j,:) = rr;
    end
end

end
