% GLM process FUS data modify by bobinshi
% modified by LBY, 202201
function fUSglm(stimu,fileN,head,averagedata,start_time,stimType,azi,TR,datapath)

% % Change the data in the structure scanfus and save it.
% scanfus.Data= average;
%save( 'scanAverage', 'averagedata','-v6');
cd(datapath);
% for data visualization
[nx,nz,np,nt]=size(averagedata); % data dimensions
for i = 1:np
    meanimage=mean(averagedata(:,:,i,:),4).^0.25; % to make the image more visible
end

%% Perform Generalized Linear Model (GLM) on dataset
% load('scanAverage.mat');
% Create the GLM regressors
% hrf = hemodynamicResponse(TR,[2 16 0.5 1 20 0 16]); % hemodynamic response function (hrf), ref: NP,2021
hrf = hemodynamicResponse(TR,[4 4 1 1 6 0 32]); % hemodynamic response function (hrf), spm
for k = 1:length(stimType)
    for i = length(azi)
        stim(k,i,:)=filter(hrf,1,stimu(k,i,:));                % filter the activity by the hrf
        stimDM(((k-1)*length(azi)+i),:) = stim(k,i,:);
    end
end

X=[stimDM', ones(size(averagedata,4),1)];     % the model is the filter activity and a constant vector
DesignMatrix = X;
img_reshape=reshape(averagedata,[],size(averagedata,4)); % change to 1-dimensional
imgdata=img_reshape';   % row: time point; column: data point

%%%%%%%%%%%%%%%% set contrast matrix %%%%%%%%%%%%%%%%%%%%%%
% Contrast1=[1,0];
numConditions = length(stimType)*length(azi);
Contrast1 = diag(ones(1,numConditions),0);
Contrast1 = [Contrast1,zeros(numConditions,1)];

% GLM analysis
dim=size(averagedata);
DOF=size(imgdata, 1)-size(DesignMatrix, 2); % degree of freedom
progressbar('GLM modeling...');
for cc = 1:numConditions
    [beta_metric{cc}, t_metric{cc}, TF4Contrast_matric{cc}, r_OLS_metric1{cc}] =gretna_GroupAnalysis(imgdata, DesignMatrix, Contrast1(cc,:), 'T');
    betadata_4d{cc}=reshape(beta_metric{cc},[dim(1),dim(2),dim(3),size(DesignMatrix, 2)]); % change data to 4-dimension, the 4th one corrrespond to each variable
    spmTdata_3d{cc}=reshape(TF4Contrast_matric{cc},[dim(1),dim(2),dim(3)]); % change data to 3-dimension
    progressbar(cc/numConditions)
end
% % for comparison with multiple subjects
% condata=beta_metric*Contrast1';  % correspond to contrast image by spm
% condata_3d=reshape(condata,[dim(1),dim(2),dim(3)]); % change data into 3-dimension
%%
output_path = [datapath,'\Results\'];
mkdir (output_path);
% save mean image
meanimghead=head(1);
meanimghead.fname=['MeanImage_',fileN,'.nii'];
meanimghead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
meanimghead.mat(1,1)=head(1).mat(1,1);
meanimghead.mat(2,2)=head(1).mat(3,3);
meanimghead.mat(3,3)=head(1).mat(2,2);
meanimghead.mat(1,4)=head(1).mat(1,4);
meanimghead.mat(2,4)=head(1).mat(3,4);
meanimghead.mat(3,4)=head(1).mat(2,4);
spm_write_vol(meanimghead,meanimage);
movefile(['.\MeanImage_',fileN,'.nii'],output_path);

%save T value image
Tmaphead=head(1);
Tmaphead.dim=[head(1).dim(1),head(1).dim(3),head(1).dim(2)];
Tmaphead.mat(1,1)=head(1).mat(1,1);
Tmaphead.mat(2,2)=head(1).mat(3,3);
Tmaphead.mat(3,3)=head(1).mat(2,2);
Tmaphead.mat(1,4)=head(1).mat(1,4);
Tmaphead.mat(2,4)=head(1).mat(3,4);
Tmaphead.mat(3,4)=head(1).mat(2,4);
Tmaphead.descrip=['SPM{T_[' num2str(DOF) ']}'];
for cc = 1:numConditions
    [xx,yy] = ind2sub([length(stimType),length(azi)],cc);
    Tmaphead.fname=['Tmap_',fileN,'_stimType_',num2str(stimType(xx)),'_azi',num2str(azi(yy)),'.nii'];
    spm_write_vol(Tmaphead,spmTdata_3d{cc});
    movefile(['.\Tmap_',fileN,'_stimType_',num2str(stimType(xx)),'_azi',num2str(azi(yy)),'.nii'],output_path);
end

% save betamap image

for cc = 1:numConditions
    [xx,yy] = ind2sub([length(stimType),length(azi)],cc);
    for k=1:size(DesignMatrix, 2)
        betadata3d=squeeze(betadata_4d{cc}(:,:,:,k));
        bataimghead=meanimghead;
        bataimghead.fname=[fileN,'_stimType_',num2str(stimType(xx)),'_azi',num2str(azi(yy)),'beta_' num2str(k,'%.4d') '.nii'];
        spm_write_vol(bataimghead,betadata3d);
        movefile([fileN,'_stimType_',num2str(stimType(xx)),'_azi',num2str(azi(yy)),'beta_' num2str(k,'%.4d') '.nii'],output_path);
    end
end

% % save contrast image
% contrastimghead=meanimghead;
% contrastimghead.fname=['con_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'];
% spm_write_vol(contrastimghead,condata_3d);
% movefile(['.\con_',fileN,'_',stimType,'_azi',num2str(azi),'.nii'],output_path);
% %TTest1_P1=2*(1-tcdf(abs(TTest1_T1), DOF));

%%
% show the result
% parater note: 1. background image 2. spmT_0001.nii image 3. correlation: FDR, FWE or NO (no correction) 4.p value
%               5.cluster size 6. colorbar range 7.result start section 8.result end section 9.rows 10. columns
cd(output_path);
for cc = 1:numConditions
    [xx,yy] = ind2sub([length(stimType),length(azi)],cc);
    [handle_1 ,handle_2]=My_image_series_plot_network(stimType,azi,['.\MeanImage_',fileN,'.nii'],['.\Tmap_',fileN,'_stimType_',num2str(stimType(xx)),'_azi',num2str(azi(yy)),'.nii'],'fdr',0.001,...
        100,[-10 10],1,1,1,1);
    print(handle_1,'.\Tmap_FDRcolorbar','-dtiff','-r600');% handle, save path, save name, format, resolution
    print(handle_2,'.\Tmap_FDR','-dtiff','-r600');% handle, save path, save name, format, resolution
    clear handle_1;
    clear handle_2;
    close all;
end

end
