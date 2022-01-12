%%
clear;clc;
%����һ��ƽ��ͼ��Ϊ��ʾ�ĵװ�
cd C:\Users\pc-1\Desktop\ZMJ\spmtest\res7   %ͳ�ƽ����ŵ�·��
head=spm_vol('E:\FUScode\spmtest\data\Results\1\Image.nii');     %��ʽ���������ݵ�·��
imagedata=spm_read_vols(head);
meanimage=mean(imagedata(:,:,1,:),4).^0.25;
meanimghead=head(1);
meanimghead.fname='meanImage.nii';
spm_write_vol(meanimghead,meanimage);

Templateimage='.\meanImage.nii';
% parater note: 1. ģ��ͼ�� 2. spmT_0001.nii ͼ�� 3. �������� FDR, FWE��NO�������ִ�Сд 4.pֵ
%               5.cluster size 6. colorbar��ʾ��Χ 7.���չʾ��ʼ�� 8.���չʾ������ 9.�����ʾͼ����������
%               10. �����ʾͼ����������
[handle_1 ,handle_2]=My_image_series_plot_network(Templateimage,...
    ['.\spmT_0001.nii'],'FDR',0.05,100,[-10 10],1,1,1,1);
print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
print(handle_2,'.\Tmap_FDR','-dtiff','-r600');%���α�ʾ���ǣ�ͼƬ�����ͼƬ����·�������֣�ͼƬ��ʽ���ֱ���
clear handle_1;
clear handle_2;
close all





