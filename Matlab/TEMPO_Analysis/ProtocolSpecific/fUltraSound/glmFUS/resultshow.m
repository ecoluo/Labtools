%%
clear;clc;
%制作一个平均图作为显示的底板
cd C:\Users\pc-1\Desktop\ZMJ\spmtest\res7   %统计结果存放的路径
head=spm_vol('E:\FUScode\spmtest\data\Results\1\Image.nii');     %格式调整后数据的路径
imagedata=spm_read_vols(head);
meanimage=mean(imagedata(:,:,1,:),4).^0.25;
meanimghead=head(1);
meanimghead.fname='meanImage.nii';
spm_write_vol(meanimghead,meanimage);

Templateimage='.\meanImage.nii';
% parater note: 1. 模板图像 2. spmT_0001.nii 图像 3. 矫正方法 FDR, FWE，NO，不区分大小写 4.p值
%               5.cluster size 6. colorbar显示范围 7.结果展示开始层 8.结果展示结束层 9.结果显示图像排列行数
%               10. 结果显示图像排列列数
[handle_1 ,handle_2]=My_image_series_plot_network(Templateimage,...
    ['.\spmT_0001.nii'],'FDR',0.05,100,[-10 10],1,1,1,1);
print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
print(handle_2,'.\Tmap_FDR','-dtiff','-r600');%依次表示的是，图片句柄、图片保存路径和名字，图片格式，分辨率
clear handle_1;
clear handle_2;
close all





