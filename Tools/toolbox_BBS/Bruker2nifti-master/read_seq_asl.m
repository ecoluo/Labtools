function [Img]=read_seq(path,pars)

% FUNCTION read_seq.m
% Reads and Reorients 4D Bruker volume series

        fid     =   fopen(deblank(path),'r');
        Img     =   fread(fid,pars.tp,pars.endian);
        fclose(fid);
       
        dims    =   pars.dims(1:3);
        dims    =   [dims(pars.vect); pars.dims(4)];
        dims2=dims;
        dims2(4)=dims(4)*2;
%         Img     =   reshape(Img,dims');   
         Img     =   reshape(Img,dims2');          
end
