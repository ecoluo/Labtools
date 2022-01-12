% Authors:  G. MONTALDO, E. MACE
% Review & test: binshibo
% 01 2022
%%
clear;clc;
onset=11:13:140; %此处需要修改
duration=3;      %此处需要修改
stimu=zeros(140,1); %此处需要修改
TR=0.4;
scannum=1;

%制作刺激范式
onsetiter=1;
for iter=1:length(stimu)
    if(onsetiter<=length(onset)&&iter==onset(onsetiter)&&iter+1<=length(stimu))
        stimu(iter)=1;
        stimu(iter+1)=1;
        stimu(iter+2)=1;
        onsetiter=onsetiter+1;
    end
end
%上采样刺激范式和图像个数一致
stimuinterp=interp1(1:1:numel(stimu),stimu,0.4:0.4:numel(stimu),'spline'); %计算用的刺激范式
stimuinterp(stimuinterp<0.1)=0;
stimuinterp(stimuinterp>0.1)=1;
stimuinterp=stimuinterp';

%% Filter and averages N scans of the same session.
% the file names in this example are scan1, scan2 .. scan6
%读取图像数据
head = spm_vol('light1.nii');   %此处需要修改，多次scan的情况需要把读取图像放在循环里面
img= spm_read_vols(head);
img4d=permute(img,[1 3 2 4]);
averagedata=0; 
for i=1:scannum    
    outliers=MydataStability(img4d);
    acc=input('accepted? [y/n] ','s');
    if acc=='y'
     scanfusRejdata=MyimageRejection(img4d,outliers);
     averagedata=averagedata+scanfusRejdata;
    end
end

% % Change the data in the structure scanfus and save it.
% scanfus.Data= average;
 %save( 'scanAverage', 'averagedata','-v6');

%%
 % 皮尔逊相关性计算
mapOriginal=MymapCorrelation(averagedata, TR,stimuinterp);

%% Data visualization of 20 Doppler planes (not registered)
figure;
[nz,nx,np,nt]=size(averagedata); % data dimensions
for i=1:np
  
    meanimage=mean(averagedata(:,:,i,:),4).^0.25;
    meanimage2=rot90(meanimage,-1);
    imagesc(meanimage2); 
    TITLE = sprintf('Plane %d', i);
    title (TITLE);
    axis off;
    caxis([1 3]);
end
colormap gray;
suptitle('Individual uDoppler images of the scan');
%% Data visualization of 20 correlation planes (not registered)
figure;
for i=1:np
    mapcor=rot90(mapOriginal(:,:,i),-1);
    imagesc(mapcor); 
    TITLE = sprintf('Plane %d', i);
    title (TITLE);
    axis off;
    caxis([-0.4 0.4]);
end
colormap (jet);
suptitle('Correlation maps of each individual plane');
%%
%保存图像
corrhead=head(1);
corrhead.fname=['corr_' head(1).fname];
corrhead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
corrhead.mat(1,1)=head(1).mat(1,1);
corrhead.mat(2,2)=head(1).mat(3,3);
corrhead.mat(3,3)=head(1).mat(2,2);
corrhead.mat(1,4)=head(1).mat(1,4);
corrhead.mat(2,4)=head(1).mat(3,4);
corrhead.mat(3,4)=head(1).mat(2,4);
spm_write_vol(corrhead,mapOriginal);

%保存平均图像
meanimghead=corrhead;
meanimghead.fname=['mean_' head(1).fname];
spm_write_vol(meanimghead,meanimage);
%%
%显示结果
% parater note: 1. 背景图像 2. 相关性结果图像 3. 显示结果的正相关阈值 4.显示结果负相关阈值
%               5.cluster size 6. colorbar显示范围  7.结果显示图像排列行数
%               8. 结果显示图像排列列数 
[handle_1 ,handle_2]=My_image_series_plot_Fus('.\mean_light1.nii','.\corr_light1.nii',0.10,-0.25,50,[-0.4 0.4],1,1);  %此处需要修改
%保存结果图片
print(handle_1,'.\Corrmap_colorbar','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
print(handle_2,'.\Corrmap','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
clear handle_1;
clear handle_2;
close all;










