% Authors:  G. MONTALDO, E. MACE
% Review & test: binshibo
% 01 2022
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

%%
 % Ƥ��ѷ����Լ���
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
%����ͼ��
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

%����ƽ��ͼ��
meanimghead=corrhead;
meanimghead.fname=['mean_' head(1).fname];
spm_write_vol(meanimghead,meanimage);
%%
%��ʾ���
% parater note: 1. ����ͼ�� 2. ����Խ��ͼ�� 3. ��ʾ������������ֵ 4.��ʾ����������ֵ
%               5.cluster size 6. colorbar��ʾ��Χ  7.�����ʾͼ����������
%               8. �����ʾͼ���������� 
[handle_1 ,handle_2]=My_image_series_plot_Fus('.\mean_light1.nii','.\corr_light1.nii',0.10,-0.25,50,[-0.4 0.4],1,1);  %�˴���Ҫ�޸�
%������ͼƬ
print(handle_1,'.\Corrmap_colorbar','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
print(handle_2,'.\Corrmap','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
clear handle_1;
clear handle_2;
close all;










