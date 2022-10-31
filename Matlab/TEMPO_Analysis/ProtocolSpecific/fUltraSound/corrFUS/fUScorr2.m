% Authors:  G. MONTALDO, E. MACE
% Review & test: binshibo
% 01 2022
% modified by LBY 202201
function fUScorr2(stimu,fileN,head,averagedata,start_time,stimType,azi,TR,onsetframe)
%% Pearson correlation
mapOriginal=MymapCorrelation(averagedata, TR,stimu);

%% Data visualization of 20 Doppler planes (not registered)
[nx,nz,np,nt]=size(averagedata); % data dimensions
for i=1:np
    figure;
    meanimage=mean(averagedata(:,:,i,:),4).^0.25; % to make the image more visible
%     meanimage2=rot90(meanimage,-1);
%     imagesc(meanimage2);
%     TITLE = sprintf('Plane %d', i);
%     title (TITLE);
%     axis off;
%     caxis([1 3]);
%     title('Individual uDoppler images of the scan');
end
colormap gray;

%% Data visualization of 20 correlation planes (not registered)
% %{
[nx,nz,np,nt]=size(averagedata); % data dimensions
for i=1:np
    figure;
    mapcor=rot90(mapOriginal(:,:,i),-1);
    imagesc(mapcor);
    TITLE = sprintf('Plane %d', i);
    title (TITLE);
    axis off;
    caxis([-0.4 0.4]);colorbar;colormap (jet);
    title('Correlation maps of each individual plane');
end
%}
%%
% %{
% show the doppler signals
averagedatarot=rot90(averagedata,-1);
figure,imagesc(mapcor);colormap (jet);axis off;caxis([-0.1 0.6]);
% option 1: draw polygonal region of roi 
disp('Please draw ROI after pressing the space key...');
pause;
bw_temp=roipoly;
mask1=double(bw_temp);
% % option 2: draw rectangular roi 
%{
% disp('Please draw a rectangular ROI...');
% bw_temp = drawrectangle('color','r');
% mask1 = createMask(bw_temp);
%}
% % option 3: draw circular roi 
%{
% disp('Please draw a rectangular ROI...');
% bw_temp = drawcircle;
% mask1 = createMask(bw_temp);
%}
% calculate mean
signalmean=zeros(nt,1);
for intert=1:nt
    alpha_temp=mask1.*averagedatarot(:,:,:,intert);
    alpha_roi1=0;
    roi_num=0;
    for i=1:size(alpha_temp,1)
        for j=1:size(alpha_temp,2)
            if(alpha_temp(i,j))~=0
                alpha_roi1=alpha_roi1+alpha_temp(i,j);
                roi_num=roi_num+1;
            end
        end
    end
    alpha_roi1=alpha_roi1/roi_num;
    signalmean(intert)=alpha_roi1;
end
%calculate signal percentage change relative  points in the baseline.
% plot the signals
stiposition=find(stimu==1);
reps = length(onsetframe);
nonStim = find(stimu==0);

% option 1: set 6s before stim on as baseline
%{
% baselineFr = zeros(1,length(stimu));
% for ii = 1:reps-1
%     baselineFr(onsetframe(ii+1)-round(6/TR):onsetframe(ii+1)) = 1; 
% end
% nbaseline = find(baselineFr==1);
%}

% option 2: set all without stim as baseline
nbaseline=find(stimu==0);  %  points position of baseline
meanbaseline=mean(signalmean(nbaseline)); % calculate baseline power doppler signals
signalmeanpercent=100*((signalmean-meanbaseline)./meanbaseline); % calculate signals relative to baseline
scale2=max(signalmeanpercent)+2;
scale1=min(signalmeanpercent)-2;
stimulus_paradigm(nonStim)=NaN;
stimulus_paradigm(stiposition)=scale1;

% plot all signals
F=figure;set(F,'Position',[10,200,1700,300]);
plot(signalmeanpercent); % plot raw signals 
axis([0 length(signalmeanpercent) scale1 scale2]);
hold on
plot(stimulus_paradigm,'linewidth',5,'color','r');
title('Power doppler signal');ylabel('%signal change');xlabel('time (s)');
% xlabel('time (image frame)');
xstep = 20;% set the step of x axis as 20s
set(gca,'xtick',0:1/TR*xstep:length(stimulus_paradigm));set(gca,'xticklabel',(0:1/TR*xstep:length(stimulus_paradigm))*TR); 
set (F,'Position',[50,500,1500,250]);
SetFigure(15);
saveas(F,['Z:\LBY\Recording data\fUS\',fileN,'ROI_1'],'jpg');

% plot mean signals with error bars
stimPS = [];
for ii = 1:reps
    stimPS(ii,:) = signalmeanpercent(onsetframe(ii):onsetframe(ii)+round(10/TR));
end
meanstimPS = mean(stimPS,1);
ste = std(stimPS,0,1)/sqrt(reps);
F2 = figure;set(F2,'Position',[100,100,1200,800]);
shadedErrorBar(0:size(stimPS,2)-1,meanstimPS,ste,'lineprops','k-','transparent',1);
title(['Mean power doppler signal: ', num2str(reps), ' reps']);ylabel('% signal change');xlabel('Time from stim on (s)');
xstep = 2;% set the step of x axis as 2s
set(gca,'xtick',0:1/TR*xstep:size(stimPS,2));set(gca,'xticklabel',(0:1/TR*xstep:size(stimPS,2))*TR); 
SetFigure(15);
saveas(F2,['Z:\LBY\Recording data\fUS\',fileN,'ROI_1_mean'],'jpg');
% close all;
%}
%%
% save images
corrhead=head(1);
corrhead.fname=['corr_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'];
corrhead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
corrhead.mat(1,1)=head(1).mat(1,1);
corrhead.mat(2,2)=head(1).mat(3,3);
corrhead.mat(3,3)=head(1).mat(2,2);
corrhead.mat(1,4)=head(1).mat(1,4);
corrhead.mat(2,4)=head(1).mat(3,4);
corrhead.mat(3,4)=head(1).mat(2,4);
spm_write_vol(corrhead,mapOriginal);

% show results
meanimghead=corrhead;
meanimghead.fname=['mean_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'];
spm_write_vol(meanimghead,meanimage);
%%
% parater note: 1. mean image (background) 2. correlation map 3. positive threshold 4.negative threshold
%               5.cluster size 6. colorbar range  7.number of figures on the row  8. number of figures on the columns
[handle_1 ,handle_2]=My_image_series_plot_Fus(stimType,azi,['.\mean_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'],['.\corr_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'],0.1,-0.2,...
    10,[-0.1 0.6],1,1);
% save results
print(handle_1,'.\Corrmap_colorbar','-dtiff','-r600');% handle, save path, save name, format, resolution
print(handle_2,'.\Corrmap','-dtiff','-r600');% handle, save path, save name, format, resolution
clear handle_1;
clear handle_2;
% close all;

end








