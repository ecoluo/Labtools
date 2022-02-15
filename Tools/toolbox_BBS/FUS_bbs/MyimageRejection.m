% Urban Lab - NERF empowered by imec, KU Leuven and VIB
% Mace Lab  - Max Planck institute of Neurobiology
% Authors:  G. MONTALDO, E. MACE
% Review & test: C.BRUNNER, M. GRILLET
% September 2020
%
% Rejet images with averge intensity above a defined threshold
%
%   scanfusRej=imageRejection(scanfus,Threshold)
%       scanfus, fus-structure of type fusvolume.
%       Threshold, rejection threshold in % (use 10%).
%       scanfusRej, fus structure of type fusvolume with the filtered data.
%
% example: example02_filter_average.m
%%
function scanfusRejdata=MyimageRejection(data,outliers,method)

if nargin==2
    method='linear';
end
[~,~,ny,nt]=size(data);

accepted=1-outliers;


time=[1:nt];
for iy=1:ny
    timeAccepted=find(accepted(iy,:));
    DataAccepted= squeeze(data(:,:,iy,timeAccepted));
    DataAccepted= permute(DataAccepted,[3,1,2]);
    DataInterp= interp1(timeAccepted,DataAccepted,time,method,'extrap');
    DataInterp = permute(DataInterp,[2,3,1]);
    scanfusRejdata(:,:,iy,:)=DataInterp;  
end

end