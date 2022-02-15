%%
clear;clc;
% calculate a mean figure as the background
cd C:\Users\pc-1\Desktop\ZMJ\spmtest\res7   % output path
head=spm_vol('E:\FUScode\spmtest\data\Results\1\Image.nii');     % output data path
imagedata=spm_read_vols(head);
meanimage=mean(imagedata(:,:,1,:),4).^0.25;
meanimghead=head(1);
meanimghead.fname='meanImage.nii';
spm_write_vol(meanimghead,meanimage);

Templateimage='.\meanImage.nii';
% parater note: 1. background image 2. spmT_0001.nii image 3. correlation: FDR, FWE or NO (no correction) 4.p value
%               5.cluster size 6. colorbar range 7.result start section 8.result end section 9.rows 10. columns
[handle_1 ,handle_2]=My_image_series_plot_network(Templateimage,['.\spmT_0001.nii'],'FDR',0.05,...
                                                    100,[-10 10],1,1,1,1);
print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');% handle, save path, save name, format, resolution
print(handle_2,'.\Tmap_FDR','-dtiff','-r600');% handle, save path, save name, format, resolution
clear handle_1;
clear handle_2;
close all





