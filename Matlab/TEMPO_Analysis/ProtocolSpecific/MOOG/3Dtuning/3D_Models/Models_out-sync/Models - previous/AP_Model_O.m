% Acceleration-pos model for 3D tuning 20180618LBY
% a is parameter set
% u_azi is unique azimuth ( 0,45,90,135,180,225,270,315 )
% u_ele is unique elevation ( 0, -+45, -+90 )
% t is PSTH time points

function r = AP_Model_O(a,st_data)

u_ele = st_data(1:5);
u_azi = st_data(6:13);
t = st_data(14:end);



% acceleration model
%time profile
acc_time = acc_func(a(3), t);
%spatial profiles
ele_azi_a = cos_tuning(a(4:7), [u_ele; u_azi]);
ele_azi_a = reshape(ele_azi_a, length(u_azi), length(u_ele));

% pos model
%time profile
pos_time = pos_func(a(3)+a(13), t);
%spatial profiles
ele_azi_j = cos_tuning(a(8:11), [u_ele; u_azi]);
ele_azi_j = reshape(ele_azi_j, length(u_azi), length(u_ele));


%compute results
r = zeros(size(ele_azi_a,1), size(ele_azi_a,2), length(acc_time));
for i=1:size(r,1),
    for j=1:size(r,2),
        rr =a(1)*(a(12)*ele_azi_a(i,j)*acc_time + (1-a(12))*ele_azi_j(i,j)*pos_time)+ a(2);
        rr(find(rr<0))  = 0;
        r(i,j,:) = rr;
    end
end

% %compute results
% r = zeros(size(ele_azi_a,1), size(ele_azi_a,2), length(acc_time));
% for i=1:size(r,1)
%     for j=1:size(r,2)
%         rr = a(12)*ele_azi_a(i,j)*acc_time + (1-a(12))*ele_azi_j(i,j)*pos_time;
%         r(i,j,:) = rr;
%     end
% end
% r = (r - min(r(:)))./max(r(:)) - min(r(:));
%         r = r * a(1) + a(2);
%         r(find(r<0))  = 0;

end
