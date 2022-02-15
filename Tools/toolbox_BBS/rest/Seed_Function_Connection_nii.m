function [ seed_FC_conn ] = Seed_Function_Connection_nii(alldata,seed )
%seed to voxel
v=spm_vol(seed);
mask=spm_read_vols(v);
mask(mask~=0)=1;

data=alldata;
for iter=1:size(alldata,4)
    temp=data(:,:,:,iter).*mask;
    temp=temp(temp~=0);
    roi_timecourse(iter)=mean(temp(:));
end
seed_FC_conn=zeros(size(data(:,:,:,1)));
for ZZ=1:size(data,3)
    for XX=1:size(data,1)
        for YY=1:size(data,2)            
            if data(XX,YY,ZZ,1)==0
                continue;
            else
                seed_FC_conn(XX,YY,ZZ)=corr(roi_timecourse',squeeze(data(XX,YY,ZZ,:)));
            end
        end
    end
end
end
