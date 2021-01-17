% calculate directions between each pair of the 26 directions
% LBY 20210114

function diffAngle = diff26(temp1,temp2)
azi = 0:45:315;
ele = -45:45:45;

a = repmat(azi,length(ele),1)';
e = repmat(ele,length(azi),1);
angle = [];
angle(1,:) = [0,-90];angle(26,:) = [0,90];
pc = 1;

for jj = 1:size(e,2)
    for ii = 1:size(a,1)
        pc = pc+1;
        angle(pc,:) = [a(ii,jj),e(ii,jj)];
        
    end
end

diffAngle = angleDiff(angle(temp1,1),angle(temp1,2),1,angle(temp2,1),angle(temp2,2),1);


end