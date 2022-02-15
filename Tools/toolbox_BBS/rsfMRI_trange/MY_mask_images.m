function MY_mask_images(file_path,file_name,mask,output_file_name,file_type)

cd (file_path);
head = spm_vol(file_name);
switch file_type
    case 'epi'
        img_RAM = fmask(spm_read_vols(head),mask);
        img = funmask(img_RAM,mask);
    case 'fieldmap'
        img_ram = spm_read_vols(head);
        img = flip(permute(img_ram.*mask,[3 1 2]),3);
    case 'T2'
        img = spm_read_vols(head).*mask;
end
vox_info = head(1).mat(1:3,1:3);
re_voxel = abs(vox_info(vox_info~=0));
re_voxel(re_voxel<0.5) = [];
nii = make_nii(img,re_voxel,abs(head(1).mat(1:3,4))./re_voxel, 4);
save_nii(nii, output_file_name);

end

