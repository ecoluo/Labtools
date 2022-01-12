%GLM process FUS data modify by bobinshi 
%%
clear;clc;
onset=11:13:140; %�˴���Ҫ�޸�
duration=3;      %�˴���Ҫ�޸�
stimu=zeros(140,1); %�˴���Ҫ�޸�
TR=0.4;
scannum=1;

%�����̼���ʽ
onsetiter=1;
for iter=1:length(stimu)
    if(onsetiter<=length(onset)&&iter==onset(onsetiter)&&iter+1<=length(stimu))
        stimu(iter)=1;
        stimu(iter+1)=1;
        stimu(iter+2)=1;
        onsetiter=onsetiter+1;
    end
end
%�ϲ����̼���ʽ��ͼ�����һ��
stimuinterp=interp1(1:1:numel(stimu),stimu,0.4:0.4:numel(stimu),'spline'); %�����õĴ̼���ʽ
stimuinterp(stimuinterp<0.1)=0;
stimuinterp(stimuinterp>0.1)=1;
stimuinterp=stimuinterp';

%% Filter and averages N scans of the same session.
% the file names in this example are scan1, scan2 .. scan6
%��ȡͼ������
datapath='E:\FUScode\GLMtest\1';
cd(datapath);
head = spm_vol('light1.nii');   %�˴���Ҫ�޸ģ����scan�������Ҫ�Ѷ�ȡͼ�����ѭ������
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
img_reshape=reshape(averagedata,[],size(averagedata,4)); %�����ݱ�Ϊһά
imgdata=img_reshape';   %����ʱ�䣬�������е����ݵ�
%���öԱȾ���
Contrast1=[1,0];
%[b_OLS_metric1, t_OLS_metric1, TTest1_T1, r_OLS_metric1] =gretna_GroupAnalysis(imgdata, DesignMatrix, Contrast1, 'T');
[beta_metric, t_metric, TF4Contrast_matric, r_OLS_metric1] =gretna_GroupAnalysis(imgdata, DesignMatrix, Contrast1, 'T');
DOF=size(imgdata, 1)-size(DesignMatrix, 2);
dim=size(averagedata);
betadata_4d=reshape(beta_metric,[dim(1),dim(2),dim(3),size(DesignMatrix, 2)]); %�����ݱ�Ϊ��ά������ά��Ӧ������
spmTdata_3d=reshape(TF4Contrast_matric,[dim(1),dim(2),dim(3)]); %�����ݱ�Ϊ��ά
condata=beta_metric*Contrast1';  %��Ӧ��spm���ɵ�contrastͼ��
condata_3d=reshape(condata,[dim(1),dim(2),dim(3)]); %�����ݱ�Ϊ��ά
%%
output_path = [datapath,'\Results\'];
mkdir (output_path);
%����Tֵͼ��
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
 
%����ƽ��ͼ��
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
%����betamapͼ��
for k=1:size(DesignMatrix, 2)
    betadata3d=squeeze(betadata_4d(:,:,:,k));
    bataimghead=meanimghead;
    bataimghead.fname=['beta_' num2str(k,'%.4d') '.nii'];
    spm_write_vol(bataimghead,betadata3d);
    movefile(['.\beta_' num2str(k,'%.4d') '.nii'],output_path);   
end
%����conͼ��
contrastimghead=meanimghead;
contrastimghead.fname='con_0001.nii';
spm_write_vol(contrastimghead,condata_3d);
movefile('.\con_0001.nii',output_path);
%TTest1_P1=2*(1-tcdf(abs(TTest1_T1), DOF));

%%
%��ʾ���
% parater note: 1. ģ��ͼ�� 2. spmT_0001.nii ͼ�� 3. �������� FDR, FWE��NO�������ִ�Сд 4.pֵ
%               5.cluster size 6. colorbar��ʾ��Χ 7.���չʾ��ʼ�� 8.���չʾ������ 9.�����ʾͼ����������
%               10. �����ʾͼ���������� 
cd(output_path);
[handle_1 ,handle_2]=My_image_series_plot_network('.\meanImage.nii','.\Tmap_0001.nii','fdr',0.05,100,[-10 10],1,1,1,1); 

print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
print(handle_2,'.\Tmap_FDR','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
clear handle_1;
clear handle_2;
close all;
