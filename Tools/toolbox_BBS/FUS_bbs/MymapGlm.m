% Urban Lab - NERF empowered by imec, KU Leuven and VIB
% Mace Lab  - Max Planck institute of Neurobiology
% Authors:  G. MONTALDO, E. MACE
% Review & test: C.BRUNNER, M. GRILLET
% September 2020
%
% Computes activity map using a generalized lineal model
%
% [estimator,tscore]=mapGlm(X,scanfus)
%   X is a matrix X(time, regressor) of the regressors 
%   scanfus is a fus-structure of type fusvolume.
%   estimator is a 4D matrix estimator(x,y,z,regressor) with the coeficient of each regressor.
%   tscore is a 4D matrix tscore(x,y,z,regressor) with the tscore of each regressor. 
%
% example: example04_glm.m
%%
function [estimator,tscore,dfe]=MymapGlm(X,scanfus)

warning('off','stats:glmfit:IterationLimit');

[nx,ny,nz,~]=size(scanfus);

nreg=size(X,2);

estimator=zeros(nx,ny,nz,nreg);
tscore=zeros(nx,ny,nz,nreg);
for ix=1:nx
    if mod(ix,10)==1, fprintf('.'); end
    for iy=1:ny
        for iz=1:nz
            s=squeeze(scanfus(ix,iy,iz,:));
            [B,~,stats]=glmfit(X,s','normal','constant','off'); % uses matlab glmfit function
            estimator(ix,iy,iz,:)=B;
            tscore(ix,iy,iz,:)=stats.t;  %other statistics can be recuperated from structure stats
        end
    end
end
dfe=stats.dfe;
fprintf('\n');
warning('on','stats:glmfit:IterationLimit');
end


