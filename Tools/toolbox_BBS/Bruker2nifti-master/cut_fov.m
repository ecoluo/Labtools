clear all
a=spm_vol('2dseq.nii');
img=spm_read_vols(a)./100;
img2=img(15:65,20:80,15:75);
a.dim=size(img2);
a.fname='2dseq2_cut.nii';
a.dt=[16,0];
spm_write_vol(a,img2);
