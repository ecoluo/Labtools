function [dest fname]=Bruker2nifti_multislice(path,EXvoxel)

% FUNCTION Bruker2nifti.m
% Extracts scanner parameters and builds the Nifti volume


pars            =   get_pars(path);
total_dims      =   pars.dims;
[Img]           =   read_seq(path,pars);
cd(path(1:end-5));
nii = make_nii(squeeze(Img),pars.resol*EXvoxel,abs(pars.pos0./pars.resol), 4);

if total_dims(4)>3 
    save_nii(nii, 'Image.nii');
else
    save_nii(nii, '2dseq.nii');
end