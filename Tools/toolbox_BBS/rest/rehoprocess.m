%calculate parameter reho
function rehoprocess(Mouse_on,Mouse_end, mouse_path,mouse_EPI_folder,Templatemask,Gaussian_kernel)
for number = Mouse_on:Mouse_end
    path = [mouse_path{number} '\'];
    EPI_folder = spm_cat(mouse_EPI_folder{number});
    
    %% Detrending  // prefix "D": nrsmImage.nii -> DnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process Detrending!')
        outputpath = [path 'reho\' num2str(EPI_folder(kk))];
        mkdir(outputpath);
        dest=[path  'Results\' num2str(EPI_folder(kk)) ];
        cd (dest)
        header = spm_vol('nrsmImage.nii');
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
    
    
    
    %% Filtering  // prefix "F": DnrsmImage.nii -> FDnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process Filtering!')
        dest=[path 'reho\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('DnrsmImage.nii');
        Image_4d = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        %bandpass filter
        Segments = MY_search_bruker_method('Segments',num2str(EPI_folder(kk)),path);
        EPI_TR = MY_search_bruker_method('EPI_TR',num2str(EPI_folder(kk)),path)/1000*Segments;
        Filter_Image_4d = Smooth_temporal_f(Image_4d,mask, EPI_TR);
        %save
        cd (dest)
        for i = 1:numel(header)
            header(i).fname = ['F' header(i).fname];
        end
        spm_write_vol_4D(header,Filter_Image_4d);
        clear Filter_Image_4d
    end
    
    
    
    %% regression // prefix "R": FDnrsmImage.nii -> RFDnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to process regression!')
        dest=[path 'reho\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('FDnrsmImage.nii');
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
        cd (dest)
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
    
    
    
    %% reho  // prefix "reho": RFDnrsmImage.nii -> rehoRFDnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        dest=[path 'reho\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('RFDnrsmImage.nii'); %回归之后的数据
        Image_4d = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;
        %reho
        RehoBrain=reho_cwj(Image_4d,27,mask);
        %save
        headreho=header(1);
        headreho.fname = ['reho' header(1).fname];
        headreho.dt=[16,0];
        headreho.descrip='reho';
        spm_write_vol(headreho,RehoBrain);
        clear Image_4d
    end
    
    %% smooth // prefix "s": rehoRFDnrsmImage.nii -> srehoRFDnrsmImage.nii
    
    file_name = 'rehoRFDnrsmImage';
    cd([path 'reho\' num2str(EPI_folder(1))]);
    all_func = MY_find_images_in_all_scans(path,'reho',{EPI_folder(:)},['^',file_name],'.nii',1:numel(spm_vol([file_name,'.nii'])),'all_mixed');
    Smooth_mlb = MY_get_default_smooth_batch_struct(all_func,Gaussian_kernel);
    disp('Start to process Smooth!');
    spm_jobman('run',Smooth_mlb);
    clear Smooth_mlb;
    
    
    %% zscore  // prefix "z":srehoRFDnrsmImage.nii -> zsrehoRFDnrsmImage.nii
    for kk = 1:numel(EPI_folder)
        %%%load EPI data
        disp('Start to zscore process!')
        dest=[path 'reho\' num2str(EPI_folder(kk))];
        cd (dest)
        header = spm_vol('srehoRFDnrsmImage.nii'); %平滑之后的reho数据
        Image_reho = spm_read_vols(header);
        templatmask= spm_read_vols(spm_vol(Templatemask));
        mask =templatmask;        
        Image_rehomask=Image_reho.*mask;
        %z变换  Z score transformation
        rehoonedim=reshape(Image_rehomask,1,[]);
        meanreho=mean(rehoonedim(:));
        stdreho=std(rehoonedim(:));         
        maskonedim=reshape(mask,1,[]);
        pos=find(maskonedim);        
        %rehoonedim(pos) =0.5 * log((1 +rehoonedim(pos))./(1- rehoonedim(pos)));
        rehoonedim(pos) =(rehoonedim(pos)-meanreho)./stdreho;
        % Get the 3D brain back
        nDim1=size(Image_reho,1);
        nDim2=size(Image_reho,2);
        nDim3=size(Image_reho,3);
        z_reho=reshape(rehoonedim,nDim1,nDim2,nDim3);        
        %save
        Zz1=header;
        Zz1.fname=['z' header.fname];
        spm_write_vol(Zz1,z_reho);
    end
    %% mean all run  // prefix "m": zsrehoRFDnrsmImage.nii -> mzsrehoRFDnrsmImage.nii
    outputpath = [path 'reho\all'];
    mkdir(outputpath);
    disp('Start to mean all run process!')
    for kk = 1:numel(EPI_folder)
        %%%load EPI data        
        dest=[path  'reho\' num2str(EPI_folder(kk)) ];
        cd (dest)
        header = spm_vol('zsrehoRFDnrsmImage.nii');
        Image_4d(:,:,:,kk) = spm_read_vols(header);
    end
    cd(outputpath)
    meanImage=squeeze(mean(Image_4d,4));
    meanhead=header;
    meanhead.fname = ['m' header.fname];
    spm_write_vol(meanhead,meanImage);
    clear Image_4d
    
end
end