%% calculate correlation between signals and stimulus
% from BBS 20211231
% modified by LBY 20211231

% clear;clc;

% fileN = 'm4c242r5';cd('Z:\Data\MOOG\baiya\Ultrasound');
fileN = 'm21c2r1';cd('Z:\Data\MOOG\Jannabi\Ultrasound');
unique_duration = 1.5;

%read the image
head = spm_vol([fileN,'.nii']); %change the name of the image
img= spm_read_vols(head);
img4d=permute(img,[1 3 2 4]); % permute the dimension of y and z

% change some parameters here
% totalT = 255; % the duration of whole exp time, unit in s
% reps = 20; % repitition
% outT = 300; % true stim time outside fUS
% duration=1.5/outT*totalT; % the duration of each stim, unit in s

totalT = 290; % the duration of whole exp time, unit in s
reps = 20; % repitition
outT = 300; % true stim time outside fUS

duration=unique_duration/outT*totalT; % the duration of each stim, unit in s
onset=0:(totalT/reps):totalT-1; %stim onset time
scannum = 1;
nFr = length(head); % number of image frames
stimu=zeros(nFr,1); % initialize stim with 0
sampleT = totalT/nFr; % time for each image
TR=0.4;

% upsample stim to sampling rate of images
onsetframe=fix(onset*nFr/totalT)+1; % +1 for first image is 1 but not 0
onsetiter=1;
stimFr = round(duration/sampleT);
for iter=1:length(stimu)
    if(onsetiter<=length(onsetframe)&&iter==onsetframe(onsetiter))
        stimu(iter:iter+stimFr-1) = ones(1,stimFr);
        onsetiter=onsetiter+1;
    end
end
% plot the stim pattern
figure('pos',[50,100,1800,250],'color','w');plot(stimu,'k-','linewidth',1.5);xlabel('image frame');title('stimulus pattern');
yticks([0 1]);SetFigure(15);

% hrf convolution
% [hrf,p] = spm_hrf(TR);
% expectedbold=conv(stimu,hrf);
% expectedbold=expectedbold(1:length(stimu));
% figure,plot(expectedbold)
% hold on;
% plot(stimu/2)

% calculate the correlation map
img4d_reshape=reshape(img4d,[],size(img4d,4)); % change to one-dimensional
corrimg=zeros(size(img4d_reshape,1),1);
for iter=1:size(img4d_reshape,1)
    s=img4d_reshape(iter,:);
    s=s-mean(s);
    s=s/sqrt(sum(s.^2));
    [cc,p]=corr(stimu,s');
    corrimg(iter)=cc;
end

dim=size(img4d);
corrmap=reshape(corrimg,[dim(1),dim(2),dim(3)]); % change back to three dimensional
% mean
imgmean=mean(img4d,4);

% save the correlation map
corrhead=head(1);
corrhead.fname=['corr_' head(1).fname];
corrhead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
corrhead.mat(1,1)=head(1).mat(1,1);
corrhead.mat(2,2)=head(1).mat(3,3);
corrhead.mat(3,3)=head(1).mat(2,2);
corrhead.mat(1,4)=head(1).mat(1,4);
corrhead.mat(2,4)=head(1).mat(3,4);
corrhead.mat(3,4)=head(1).mat(2,4);
spm_write_vol(corrhead,corrmap);

% save the mean figure
meanimghead=corrhead;
meanimghead.fname=['mean_' head(1).fname];
spm_write_vol(meanimghead,imgmean);
%% plot correlation map superimposed on the mean image
% parater note: 1. mean image (background) 2. correlation map 3. positive threshold 4.negative threshold
%               5.cluster size 6. colorbar range  7.number of figures on the row  8. number of figures on the columns
[handle_1 ,handle_2]=My_image_series_plot_Fus(['.\mean_',fileN,'.nii'],['.\corr_',fileN,'.nii'],0.05,-0.05,...
                                              5,[-0.1 0.1],1,1); 


