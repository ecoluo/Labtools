%Change FUS image dimension order fit spm process
function  MY_FUSserialimage2mri4d(imagename,voxelchangenum)
head = spm_vol(imagename);   %此处可能需要修改
img= spm_read_vols(head);
img4d=permute(img,[1 3 2 4]);
%save fmri
fseq=0;
for p=1:size(img4d,4)
    fseq=fseq+1;
    im          =   img4d(:,:,:,p);
    pars= head(1);
    dims=[pars.dim(1),pars.dim(3),1];
    mat=pars.mat;
    mat(1,1)=voxelchangenum*pars.mat(1,1);
    mat(2,2)=voxelchangenum*pars.mat(3,3);
    mat(3,3)=voxelchangenum*pars.mat(2,2);
    mat(1,4)=voxelchangenum*pars.mat(1,4);
    mat(2,4)=voxelchangenum*pars.mat(3,4);
    mat(3,4)=voxelchangenum*pars.mat(2,4);
    dt=pars.dt;
    %image_name=['c' head(1).fname(1:end-4) '.nii'];
    image_name=['Image.nii'];
    Vol = struct('fname',image_name,'dim',double(dims),'mat',mat,'pinfo',[1 0 0]','descrip','fmri image','dt',dt);
    Vol.n = [fseq 1];
    spm_write_vol(Vol,im);
end
end