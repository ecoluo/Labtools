function vbmprocess(Mouse_on,Mouse_end, mouse_path,TPMmodelpath,Gaussian_kernel)
spm('Defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch
for number = Mouse_on:Mouse_end
    path = [mouse_path{number} '\'];
    T2path=[path,'Results\T2\'];
    cd(T2path);
    rawimage{1,1} =[T2path 'T2_m.nii,1'];    
    T2segment_mlb=MY_get_default_oldsegment_batch_struct(rawimage, TPMmodelpath);
    disp('Start to process OldSegment!');
    spm_jobman('run',T2segment_mlb);
    clear T2segment_mlb rawimage;
    
    %% smooth_space // prefix "s": nmrsImage.nii -> snmrsImage.nii
    filename = dir('mwc*.nii');
    for fileIter=1:length(filename)
        imagedata{fileIter,1} = [pwd,'\',filename(fileIter,1).name,',1'];
    end
    Smooth_mlb = MY_get_default_smooth_batch_struct(imagedata,Gaussian_kernel);
    disp('Start to process Smooth!');
    spm_jobman('run',Smooth_mlb);
    clear Smooth_mlb;
end
end



