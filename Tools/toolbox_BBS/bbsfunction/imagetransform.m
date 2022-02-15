% =====================================image 2 nii process==========================================================
function imagetransform(Mouse_on,Mouse_end, mouse_path,mouse_EPI_folder,mouse_T2RARE,EXtendVoxel)
for number = Mouse_on:Mouse_end
    path = [mouse_path{number} '\'];
    EPI_folder = spm_cat(mouse_EPI_folder{number});
    RARE = mouse_T2RARE{number};
    %% Bruker2Nifti // stop running and ITKSNAP, Go......stage 02
    for k = 1:length(EPI_folder)
        input_path = [path,num2str(EPI_folder(k)),'\pdata\1'];
        input_file = [input_path,'\2dseq'];
        Bruker2nifti_multislice(input_file,EXtendVoxel);
        output_path = [path,'Results\',num2str(EPI_folder(k))];
        mkdir (output_path);
        movefile([input_path,'\Image.nii'],output_path);
    end
    %% T2
    T2_path=[path,num2str(RARE),'\pdata\1\2dseq'];
    Bruker2nifti_multislice(T2_path,EXtendVoxel);
    mkdir ([path,'Results\T2\']);
    movefile([path,num2str(RARE),'\pdata\1\2dseq.nii'],[path,'Results\T2\']);
end
end