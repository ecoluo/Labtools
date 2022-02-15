function [Img]=read_vol(path,pars)

% FUNCTION read_vol.m
% Reads and Reorients 3D Bruker volumes

        dims    =   pars.dims(1:3);
        fid     =   fopen(deblank(path), 'r');
        Img     =   fread(fid,pars.tp,pars.endian);
        fclose(fid);
        
        Img     =   reshape(Img,dims(pars.vect)');             
        
end