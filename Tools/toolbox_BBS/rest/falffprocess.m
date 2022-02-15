%calculate parameter falff
function falffprocess(Mouse_on,Mouse_end, mouse_path,mouse_EPI_folder,Templatemask,Gaussian_kernel)
for number = Mouse_on:Mouse_end
    path = [mouse_path{number} '\'];
    EPI_folder = spm_cat(mouse_EPI_folder{number});
    
    %% smooth_space // prefix "s": nrsmImage.nii -> snrsmImage.nii
    file_name = 'nrsmImage';
    cd([path 'Results\' num2str(EPI_folder(1))]);
    all_func = MY_find_images_in_all_scans(path,'Results',{EPI_folder(:)},['^',file_name],'.nii',1:numel(spm_vol([file_name,'.nii'])),'all_mixed');
    Smooth_mlb = MY_get_default_smooth_batch_struct(all_func,Gaussian_kernel);
    disp('Start to process Smooth!');
    spm_jobman('run',Smooth_mlb);
    clear Smooth_mlb;
    %% Detrending  // prefix "D": snrsmImage.nii -> DsnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process Detrending!');
        outputpath = [path 'falff\' num2str(EPI_folder(kk))];
        mkdir(outputpath);
        dest=[path  'Results\' num2str(EPI_folder(kk)) ];
        cd (dest)
        header = spm_vol('snrsmImage.nii');
        Image_4d = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        flat_Image_4d = fmask(Image_4d,mask);
        
        for voxelNum = 1 : size(flat_Image_4d,1)
            intercept = mean(flat_Image_4d(voxelNum,:));
            flat_Image_4d(voxelNum,:) = detrend(flat_Image_4d(voxelNum,:));
            flat_Image_4d(voxelNum,:) = flat_Image_4d(voxelNum,:) + intercept;
        end
        Detrend_Image_4d = funmask(flat_Image_4d,mask);
        
        for i = 1:numel(header)
            header(i).fname = ['D' header(i).fname];
        end
        spm_write_vol_4D(header,Detrend_Image_4d);
        movefile(header(1).fname,outputpath);
        clear Detrend_Image_4d
    end
    %% regression // prefix "R": DsnrsmImage.nii -> RDsnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process regression!');
        dest=[path 'falff\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('DsnrsmImage.nii');
        Image_4d = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        flat_Image_4d = fmask(Image_4d,mask);
        regress_Image = zeros(size(flat_Image_4d,1),size(flat_Image_4d,2));
        % non-brain PCA
        %                 fMRI_data = spm_read_vols(spm_vol([dest '\2dseq.nii']));
        %                 lmask = spm_read_vols(spm_vol([path  'Results\' 'EPI_mask.nii']));
        %                 PC = MY_get_principle_component_out_of_brian(fMRI_data,lmask,10);
        %                 cd(dest);
        %                 save('PCs.mat','PC');
        %GS
        GS_mask = templatmask;
        GS=fmask(Image_4d,GS_mask);
        GS=permute(GS,[2 1]);
        GS=mean(GS,2);
        
        save('GS.mat','GS');
        %head motion
        dest2=[path  'Results\' num2str(EPI_folder(kk)) ];
        cd(dest2);
        rp_raw = load('rp_smImage.txt');
        cd(dest);
        rp_dev = rp_raw - [zeros(1,6);rp_raw(1:end-1,:)];
        %rp2 = [rp_raw rp_dev].^2;
        %                 %%%%%%WM
        %                 WM_mask=spm_read_vols(spm_vol([path  'Results\' 'WM_mask.nii']));
        %                 WM=fmask(Image_4d,WM_mask);
        %                 WM=permute(WM,[2 1]);
        %                 WM=mean(WM,2);
        %                 %%%%%CSF
        %                 CSF_mask=spm_read_vols(spm_vol([path  'Results\' 'CSF_mask.nii']));
        %                 CSF=fmask(Image_4d,CSF_mask);
        %                 CSF=permute(CSF,[2 1]);
        %                 CSF=mean(CSF,2);
        %%%%%%regressor
        Multi_Reg = [rp_raw rp_dev GS];% WM CSF PC GS
        for p = 1:size(Multi_Reg,2)
            RAM =  Multi_Reg(:,p);
            Multi_Reg(:,p) = (RAM-mean(RAM))/std(RAM);
        end
        save 'rest_Regessor.txt' 'Multi_Reg' '-ascii'
        Multi_Regessor = [ones(size(Multi_Reg,1),1),Multi_Reg];
        for voxelNum = 1 : size(flat_Image_4d,1)
            [b,bint,r] = regress(flat_Image_4d(voxelNum,:)', Multi_Regessor);
            regress_Image(voxelNum,:) = r'+b(1);
        end
        regress_Image_4d = funmask(regress_Image,mask);
        
        for i = 1:numel(header)
            header(i).fname = ['R' header(i).fname];
        end
        spm_write_vol_4D(header,regress_Image_4d);
        clear regress_Image
    end
    
    
    %% falff  // prefix "falff": RDsnrsmImage.nii -> falffRDsnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data        
        dest=[path 'falff\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('RDsnrsmImage.nii'); %smooth detrend 回归之后的数据
        Image_4d = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        Segments = MY_search_bruker_method('Segments',num2str(EPI_folder(kk)),path);
        EPI_TR = MY_search_bruker_method('EPI_TR',num2str(EPI_folder(kk)),path)/1000*Segments;
        % alff falff
        cd (dest)
        [ALFFBrain,FalffBrain]=MY_falff(Image_4d,mask,EPI_TR);
         %save
        headalff=header(1);
        headalff.fname = ['alff' header(1).fname];
        headalff.dt=[16,0];
        headalff.descrip='alff';
        spm_write_vol(headalff,ALFFBrain);        
        %save
        headfalff=header(1);
        headfalff.fname = ['falff' header(1).fname];
        headfalff.dt=[16,0];
        headfalff.descrip='falff';
        spm_write_vol(headfalff,FalffBrain);
        clear Image_4d
    end
    
    %% zscore  // prefix "z":falffRDsnrsmImage.nii -> zfalffRDsnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process zscore!');
        dest=[path 'falff\' num2str(EPI_folder(kk))];
        cd (dest)
        headeralff = spm_vol('alffRDsnrsmImage.nii'); %alff数据
        Image_alff = spm_read_vols(headeralff);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        Image_alffmask=Image_alff.*mask;
        %z变换
        alffonedim=reshape(Image_alffmask,1,[]);
        meanalff=mean(alffonedim(:));
        stdalff=std(alffonedim(:));
        maskonedim=reshape(mask,1,[]);
        pos=find(maskonedim);
        %alffonedim(pos) =0.5 * log((1 +alffonedim(pos))./(1- alffonedim(pos)));
        alffonedim(pos) =(alffonedim(pos)-meanalff)./stdalff;
        % Get the 3D brain back
        nDim1=size(Image_alff,1);
        nDim2=size(Image_alff,2);
        nDim3=size(Image_alff,3);
        z_alff=reshape(alffonedim,nDim1,nDim2,nDim3); 
        %save
        Zz1=headeralff;
        Zz1.fname=['z' headeralff.fname];
        spm_write_vol(Zz1,z_alff); 
       
        header = spm_vol('falffRDsnrsmImage.nii'); %falff数据
        Image_falff = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        Image_falffmask=Image_falff.*mask;
        %z变换
        falffonedim=reshape(Image_falffmask,1,[]);
        meanfalff=mean(falffonedim(:));
        stdfalff=std(falffonedim(:));        
        maskonedim=reshape(mask,1,[]);
        pos=find(maskonedim);
       % falffonedim(pos) =0.5 * log((1 +falffonedim(pos))./(1- falffonedim(pos)));
        falffonedim(pos) =(falffonedim(pos)-meanfalff)./stdfalff;
        % Get the 3D brain back
        nDim1=size(Image_falff,1);
        nDim2=size(Image_falff,2);
        nDim3=size(Image_falff,3);
        z_falff=reshape(falffonedim,nDim1,nDim2,nDim3); 
        %save
        Zz2=header;
        Zz2.fname=['z' header.fname];
        spm_write_vol(Zz2,z_falff);
    end
     %% mean all run  // prefix "m": zfalffRDsnrsmImage.nii -> mzfalffRDsnrsmImage.nii
    outputpath = [path 'falff\all'];
    mkdir(outputpath);
    disp('Start to process mean all run!');
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        dest=[path  'falff\' num2str(EPI_folder(kk)) ];
        cd (dest)
        headerzalff = spm_vol('zalffRDsnrsmImage.nii');
        Imagezalff_4d(:,:,:,kk) = spm_read_vols(headerzalff);
        header = spm_vol('zfalffRDsnrsmImage.nii');
        Image_4d(:,:,:,kk) = spm_read_vols(header);
    end
    cd(outputpath)
    meanImagezalff=squeeze(mean(Imagezalff_4d,4));
    meanzalffhead=headerzalff;
    meanzalffhead.fname = ['m' headerzalff.fname];
    spm_write_vol(meanzalffhead,meanImagezalff);
    
    meanImage=squeeze(mean(Image_4d,4));
    meanhead=header;
    meanhead.fname = ['m' header.fname];
    spm_write_vol(meanhead,meanImage);
    clear Image_4d
    clear Imagezalff_4d
end
end    