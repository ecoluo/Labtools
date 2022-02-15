function [dest fname]=Bruker2nifti(path)

% FUNCTION Bruker2nifti.m
% Extracts scanner parameters and builds the Nifti volume


pars            =   get_pars(path);
total_dims      =   pars.dims;
if total_dims(4)>3 
    [Img]           =   read_seq(path,pars);
    frames          =   pars.dims(4);
    for p=1:frames
        filename    =   ['Image_'];
        if p<=999   filename    =   [filename '0']; end
        if p<=99    filename    =   [filename '0'];  end
        if p<=9     filename    =   [filename '0'];   end             
        filename    =   [filename int2str(p) '.nii'];   
        fprintf('       Image:   %s\n',filename);           
        path        =   fullfile(fileparts(path),filename); 
        pars.dims   =   pars.dims(1:3);
        im          =   Img(:,:,:,p);
        [dest fname]    =   create_nifti_vol(im,path,pars);
    end
    pars.dims       =   [pars.dims;frames];
else
    pars.dims       =   pars.dims(1:3);
    [Img]           =   read_vol(path,pars);
    [dest fname]    =   create_nifti_vol(Img,path,pars);
end


end