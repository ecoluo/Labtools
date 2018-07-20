


srcPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\3D_Tuning_models\Rotation';

tarPath = 'Z:\LBY\Recording data\Qiaoqiao\3D_Tuning_models\3D_Tuning_models\VA model\R_vis';

cd(srcPath);
filename = dir([srcPath,'\*_VA_model_Visual*.tif']);

for ii = 1:length(filename)
    
    copyfile(filename(ii).name,tarPath);
    
end
