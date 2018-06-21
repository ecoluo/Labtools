% to calculate the angle between two directions in 3D space
% azi -> azimuth
% ele -> elevation
% amp -> amplitude
% 20170324 LBY

function angleDiff = angleDiff(azi1,ele1,amp1,azi2,ele2,amp2)

angleDiff = nan*ones(1,length(azi1));

for ii = 1:length(azi1)
    if ~isnan(azi1(ii)) && ~isnan(ele1(ii)) && ~isnan(amp1(ii)) && ~isnan(azi2(ii)) && ~isnan(ele2(ii)) && ~isnan(amp2(ii))
        
        % transform spherical coordinates to cartesian
        [x1,y1,z1] = sph2cart(azi1(ii)*pi/180,ele1(ii)*pi/180,amp1(ii));
        [x2,y2,z2] = sph2cart(azi2(ii)*pi/180,ele2(ii)*pi/180,amp2(ii));
        
        % calculate the angles between the two vectors
        mod1 = sqrt((x1.^2+y1.^2+z1.^2));
        mod2 = sqrt((x2.^2+y2.^2+z2.^2));
        angleDiff(ii) = acos((x1.*x2+y1.*y2+z1.*z2)/(mod1*mod2))*180/pi;
        
    end
end
end

