


srcPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Sync model\Translation';

tarPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Sync model\PVAJ model\T_vesti';

cd(srcPath);
filename = dir([srcPath,'\*_PVAJ_model_Vestibular*.tif']);

for ii = 1:length(filename)
    
    copyfile(filename(ii).name,tarPath);
    
end
