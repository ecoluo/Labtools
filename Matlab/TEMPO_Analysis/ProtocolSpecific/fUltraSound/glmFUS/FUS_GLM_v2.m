%GLM process FUS data modify by bobinshi 
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
datapath='E:\FUScode\GLMtest\1';
cd(datapath);
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
meanimage=mean(averagedata(:,:,i,:),4).^0.25;

%% Perform Generalized Linear Model (GLM) on dataset 
%load('scanAverage.mat'); 
% Create the GLM regressors
hrf = hemodynamicResponse(TR,[2 16 0.5 1 20 0 16]); % hemodynamic response function (hrf) 
stim=filter(hrf,1,stimuinterp);                % filter the activity by the hrf
X=[stim, ones(size(averagedata,4),1)];     % model is the filter activity and a constant vector

DesignMatrix = X;
img_reshape=reshape(averagedata,[],size(averagedata,4)); %将数据变为一维
imgdata=img_reshape';   %行是时间，列是所有的数据点
%设置对比矩阵
Contrast1=[1,0];
%[b_OLS_metric1, t_OLS_metric1, TTest1_T1, r_OLS_metric1] =gretna_GroupAnalysis(imgdata, DesignMatrix, Contrast1, 'T');
[beta_metric, t_metric, TF4Contrast_matric, r_OLS_metric1] =gretna_GroupAnalysis(imgdata, DesignMatrix, Contrast1, 'T');
DOF=size(imgdata, 1)-size(DesignMatrix, 2);
dim=size(averagedata);
betadata_4d=reshape(beta_metric,[dim(1),dim(2),dim(3),size(DesignMatrix, 2)]); %将数据变为四维，第四维对应各变量
spmTdata_3d=reshape(TF4Contrast_matric,[dim(1),dim(2),dim(3)]); %将数据变为三维
condata=beta_metric*Contrast1';  %对应于spm生成的contrast图像
condata_3d=reshape(condata,[dim(1),dim(2),dim(3)]); %将数据变为三维
%%
output_path = [datapath,'\Results\'];
mkdir (output_path);
%保存T值图像
Tmaphead=head(1);
Tmaphead.fname='Tmap_0001.nii';
Tmaphead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
Tmaphead.mat(1,1)=head(1).mat(1,1);
Tmaphead.mat(2,2)=head(1).mat(3,3);
Tmaphead.mat(3,3)=head(1).mat(2,2);
Tmaphead.mat(1,4)=head(1).mat(1,4);
Tmaphead.mat(2,4)=head(1).mat(3,4);
Tmaphead.mat(3,4)=head(1).mat(2,4);
Tmaphead.descrip=['SPM{T_[' num2str(DOF) ']}'];
spm_write_vol(Tmaphead,spmTdata_3d);
movefile('.\Tmap_0001.nii',output_path);
 
%保存平均图像
meanimghead=head(1);
meanimghead.fname='MeanImage.nii';
meanimghead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
meanimghead.mat(1,1)=head(1).mat(1,1);
meanimghead.mat(2,2)=head(1).mat(3,3);
meanimghead.mat(3,3)=head(1).mat(2,2);
meanimghead.mat(1,4)=head(1).mat(1,4);
meanimghead.mat(2,4)=head(1).mat(3,4);
meanimghead.mat(3,4)=head(1).mat(2,4);
spm_write_vol(meanimghead,meanimage);
movefile('.\MeanImage.nii',output_path);
%保存betamap图像
for k=1:size(DesignMatrix, 2)
    betadata3d=squeeze(betadata_4d(:,:,:,k));
    bataimghead=meanimghead;
    bataimghead.fname=['beta_' num2str(k,'%.4d') '.nii'];
    spm_write_vol(bataimghead,betadata3d);
    movefile(['.\beta_' num2str(k,'%.4d') '.nii'],output_path);   
end
%保存con图像
contrastimghead=meanimghead;
contrastimghead.fname='con_0001.nii';
spm_write_vol(contrastimghead,condata_3d);
movefile('.\con_0001.nii',output_path);
%TTest1_P1=2*(1-tcdf(abs(TTest1_T1), DOF));

%%
%显示结果
% parater note: 1. 模板图像 2. spmT_0001.nii 图像 3. 矫正方法 FDR, FWE，NO，不区分大小写 4.p值
%               5.cluster size 6. colorbar显示范围 7.结果展示开始层 8.结果展示结束层 9.结果显示图像排列行数
%               10. 结果显示图像排列列数 
cd(output_path);
[handle_1 ,handle_2]=My_image_series_plot_network('.\meanImage.nii','.\Tmap_0001.nii','fdr',0.05,100,[-10 10],1,1,1,1); 

print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
print(handle_2,'.\Tmap_FDR','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
clear handle_1;
clear handle_2;
close all;
