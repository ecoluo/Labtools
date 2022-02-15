function [Img]=read_seq(path,pars)

% FUNCTION read_seq.m
% Reads and Reorients 4D Bruker volume series

        fid     =   fopen(deblank(path),'r');
        Img     =   fread(fid,pars.tp,pars.endian);
        fclose(fid);
       
        dims    =   pars.dims(1:3);
        dims    =   [dims(pars.vect); pars.dims(4)];
        Img     =   reshape(Img,dims');   
        
end
