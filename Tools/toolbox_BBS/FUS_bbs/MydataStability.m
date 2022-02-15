% Test the data stability and suggest a threshold(3-SD) to eliminate outliers
%
%   outliers=dataStability(scanfus)
%       scanfus, fus-structure of type fusvolume.
%
%%
function [h,ratioRejected,outliers]=MydataStability(imgdata)

[~,~,ny,nt]=size(imgdata); 

% average the image and normalize by the median of all frames
% this value must be "stable" during all the acquisition.
s=squeeze(mean(mean(imgdata))); % s is a vector with dimension of time
s=s./median(s(:)); 

N=ny*nt;

% Important: the movement noise is always > 0 
% i.e outliers are in the positive part of the distribution. 
% We compute the sigma with the low part of the distribution that is not affected by the outliers
sNoNoise=s(s<1); 
sigma=sqrt(mean((sNoNoise(:)-1).^2));
% suggest a threshold of 3 sigma
threshold=1+sigma*3;
% compute percent of rejencted images
outliers=s>threshold;
outliers=outliers';
Nrejected=sum(outliers(:));
ratioRejected = Nrejected/N;
% display results
h = figure;

% histogram 
subplot(2,1,1)
hold on
[ha,hb]=hist(s(:),100);
bar(hb,ha);  
plot(hb, exp(-0.5*((hb-1)/sigma).^2)*(N-Nrejected)*(hb(2)-hb(1))/(sigma*sqrt(2*pi)) )
plot([threshold threshold],[0 max(ha)/2],'r');
txt=sprintf(' Threshold: %.1f\n Rejection: %.1f%%',threshold,ratioRejected*100);
text(double(threshold),max(ha)/2.3,txt)
title('Intensity distribution');
xlabel('Normalized intensity');
ylabel('Number of images')
hold off

% outliers position
subplot(2,1,2)
bar(outliers);
%axis([0,length(outliers),0,1]);
set(gca,'YTick',[0:1:1]);
%imagesc(1-outliers); colormap(gray);
title('Rejected images');
xlabel('Time (s)');
ylabel('Planes')
SetFigure(15);
end
