
% =====================================pre process==========================================================
function preprocess(Mouse_on,Mouse_end, mouse_path,mouse_EPI_folder,stepnum,Templateimage,reference_number)
spm('Defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch
for number = Mouse_on:Mouse_end
    path = [mouse_path{number} '\'];
    EPI_folder = spm_cat(mouse_EPI_folder{number});
    for restflag_stage = stepnum        
        if restflag_stage == 1
            %% mask all EPI and RARE
            cd([path 'Results']);
            EPI_mask = spm_read_vols(spm_vol('EPI_mask.nii'));
            T2_mask = spm_read_vols(spm_vol('T2_mask.nii'));
            %% epi   // prefix "m" for Mask: Image.nii -> mImage.nii
            for k = 1:numel(EPI_folder)
                file_path = [path,'Results\',num2str(EPI_folder(k))];
                MY_mask_images(file_path,'Image.nii',EPI_mask,'mImage.nii','epi')
            end
            %% T2
            MY_mask_images([path,'Results\T2\'],'2dseq.nii',T2_mask,'T2_m.nii','T2')
        end
        if restflag_stage == 2
            %% Slicetiming  // prefix "s" for Slicetiming: mImage.nii -> smImage.nii
            for kk = 1:length(EPI_folder)
                segments = MY_search_bruker_method('Segments',EPI_folder(kk),path);
                EPI_TR = MY_search_bruker_method('EPI_TR',EPI_folder(kk),path)/1000*segments;
                cd([path 'Results\' num2str(EPI_folder(kk))]);
                head = spm_vol('mImage.nii');
                slice_number = head(1).dim(3);
                all_func = MY_find_images_in_all_scans(path,'Results',{EPI_folder(kk)},'^mImage','.nii',1:numel(head),'separate_cells');
                slicetiming_mlb = MY_get_default_slicetiming_batch_struct(all_func,slice_number,EPI_TR,reference_number);
                disp('Start to process Slicetiming!')
                spm_jobman('run',slicetiming_mlb);
            end
        end
        if restflag_stage == 3
            %% Realignment  // prefix "r" for Realignment: smImage.nii -> rsmImage.nii
            for kk = 1:length(EPI_folder)
                cd([path 'Results\' num2str(EPI_folder(kk))]);
                all_func = MY_find_images_in_all_scans(path,'Results',{EPI_folder(kk)},'^smImage','.nii',1:numel(spm_vol('smImage.nii')),'separate_cells');
                realign_mlb = MY_get_default_realign_batch_struct(all_func);
                F = spm_figure('GetWin');
                disp('Start to process realignment !')
                spm_jobman('run',realign_mlb);
                hgexport(figure(F), fullfile([path,'Results\',num2str(EPI_folder(kk))],strcat('realign')), hgexport('factorystyle'), 'Format', 'tiff');
            end
            clear realign_mlb all_func;
        end
        if restflag_stage == 4
            %% T2 2 Func Coregistration   // prefix "c": T2_m.nii -> cT2_m.nii
            ref{1,1} = [path 'Results\' num2str(EPI_folder(1)) '\meansmImage.nii,1'];
            source{1,1} = [path 'Results\T2\T2_m.nii,1'];
            Func2T2W_mlb = MY_get_default_coreg_batch_struct(ref, source, {''});
            disp('Start to process T2 2 Func coregistration!');
            F = spm_figure('GetWin');
            spm_jobman('run',Func2T2W_mlb);
            %           hgexport(figure(F), fullfile([path 'Results\'], 'coreg'), hgexport('factorystyle'), 'Format', 'tiff');
            clear Func2T2W_mlb other ref source;
            
        end
        %% T22Template coregistration//oldnormalization  // prefix "n": rsmImage.nii -> nrsmImage.nii
        if restflag_stage == 5
            ref{1,1} =[Templateimage ',1'];
            source{1,1} = [path 'Results\T2\cT2_m.nii,1'];
            all_func = MY_find_images_in_all_scans(path,'Results',{EPI_folder(:)},'^rsmImage','.nii',[1 Inf],'all_mixed');
            OldNormalize_mlb = MY_get_default_oldnormalize_batch_struct(ref, source, all_func);
            disp('Start to process OldNormalize!');
            F = spm_figure('GetWin');
            spm_jobman('run',OldNormalize_mlb);
            hgexport(figure(F), fullfile([path 'Results\'], strcat('oldnormalize')), hgexport('factorystyle'), 'Format', 'tiff');
            clear OldNormalize_mlb other ref source;
        end
        
    end
end
end