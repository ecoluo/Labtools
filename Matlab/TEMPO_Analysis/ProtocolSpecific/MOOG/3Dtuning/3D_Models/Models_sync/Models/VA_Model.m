% Velocity-acceleration model for 3D tuning 20170321LBY 20180716
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = VA_Model(a,st_data)

u_ele = st_data(1:5);
u_azi = st_data(6:13);
t = st_data(14:end);


% velocity model
% time profile
vel_time = vel_func(a(3), t);
% spatial profiles
ele_azi_v = cos_tuning(a(4:7), [u_ele; u_azi]);
ele_azi_v = reshape(ele_azi_v, length(u_azi), length(u_ele));

% acceleration model
%time profile
acc_time = acc_func(a(3), t);
%spatial profiles
ele_azi_a = cos_tuning(a(8:11), [u_ele; u_azi]);
ele_azi_a = reshape(ele_azi_a, length(u_azi), length(u_ele));



%compute results
r = zeros(size(ele_azi_v,1), size(ele_azi_v,2), length(vel_time));
for i=1:size(r,1)
    for j=1:size(r,2)
        rr =a(1)*(a(12)*ele_azi_v(i,j)*vel_time + (1-a(12))*ele_azi_a(i,j)*acc_time)+ a(2);
        rr(find(rr<0))  = 0;
        r(i,j,:) = rr;
    end
end


end
