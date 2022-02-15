%% change the dimensions (exchange x and y) of the images

clear;clc;
datapath='Z:\Data\MOOG\baiya\Ultrasound';
cd(datapath);
filename=dir('m4c2*.nii');
for k = 1:numel(filename)
    head = spm_vol(filename(k).name);
    voxelchangenum = 20;   % magnification power for voxels, 20x to make each voxel to mm
    img= spm_read_vols(head);
    img4d=permute(img,[1 3 2 4]);
    %save fmri
    fseq=0;
    for p=1:size(img4d,4)
        fseq=fseq+1;
        im = img4d(:,:,:,p);
        pars= head(1);
        dims=[pars.dim(1),pars.dim(3),pars.dim(2)];
        mat=pars.mat;
        mat(1,1)=voxelchangenum*pars.mat(1,1);
        mat(2,2)=voxelchangenum*pars.mat(3,3);
        mat(3,3)=voxelchangenum*pars.mat(2,2);
        mat(1,4)=voxelchangenum*pars.mat(1,4);
        mat(2,4)=voxelchangenum*pars.mat(3,4);
        mat(3,4)=voxelchangenum*pars.mat(2,4);
        dt=pars.dt;
        image_name=['c' head(1).fname];
        Vol = struct('fname',image_name,'dim',double(dims),'mat',mat,'pinfo',[1 0 0]','descrip','fmri image','dt',dt);
        Vol.n = [fseq 1];
        spm_write_vol(Vol,im);
    end
    output_path = [datapath,'\cdata\'];
    mkdir (output_path);
    movefile(['.\c' head(1).fname],output_path);
end

%% save figures with masks ( eliminate dura etc.)

clear;clc;
datapath='Z:\Data\MOOG\baiya\Ultrasound\cdata';
cd(datapath);
temp = {'£¿'};
for ii = 1:length(temp)
    mask= spm_read_vols(spm_vol(['mask',temp{ii},'.nii']));
    filename=dir(['cm4c',temp{ii},'*.nii']);
    for k = 1:numel(filename)
        header = spm_vol(filename(k).name);
        Image_4d = spm_read_vols(header);
        fseq=0;
        for itertimepoint=1:size(Image_4d,4)
            fseq=fseq+1;
            mImage_3d=Image_4d(:,:,:,itertimepoint).*mask;
            pars= header(1);
            dims=pars.dim;
            mat=pars.mat;
            dt=pars.dt;
            image_name=['m' header(1).fname];
            Vol = struct('fname',image_name,'dim',double(dims),'mat',mat,'pinfo',[1 0 0]','descrip','fmri image','dt',dt);
            Vol.n = [fseq 1];
            spm_write_vol(Vol,mImage_3d);
        end
    end
end









