


% srcPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Sync model\Translation';
srcPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Out-sync model\Rotation';
% srcPath = 'Z:\LBY\Recording data\MSTd\3D_Tuning_models\Sync model_raw\Translation';

% tarPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Sync model\PVAJ model\T_vesti';
tarPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Out-sync model\VA model\R_vesti';
% tarPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\Sync model\Translation-contour';
% tarPath = 'Z:\LBY\Recording data\MSTd\3D_Tuning_models\Sync model_raw\Vestibular_VAJ model';

cd(srcPath);
filename = dir([srcPath,'\*_VA_model_Vestibular_R.tif']);

for ii = 1:length(filename)
    
    copyfile(filename(ii).name,tarPath);
    
end
