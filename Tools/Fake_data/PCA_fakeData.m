% to examine PCA code
% LBY 20190529


function PCA_fakeData(data_PCA)

clc;
colorDefsLBY;

if nargin == 0
    
%     pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V';
%     pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V1'; % continuously
%     pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons A';
%     pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V5A5';
%     pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V25A25J25P25';
pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V_jitter';
% pathname = 'Z:\Labtools\Tools\Fake_data\Faked neurons V_noDS';

    
    filename = dir([pathname,'\*.mat']);
    temp1 = [];
    for ii = 1:length(filename)
        % load PSTH data
        temp{ii} = load([pathname '\' filename(ii).name]);
        temp{ii} = reshape(temp{ii}.Respon,[],size(temp{ii}.Respon,3));
        temp1 = [temp1;temp{ii}];
    end
    
end;

denoised_dim = 2; % how many PCs you want to plot


%%%%%%%%%%%%%%%0 将每一个方向全部打乱
dataPCA_raw = temp1';
dataPCA = (dataPCA_raw - repmat(mean(dataPCA_raw,1),size(dataPCA_raw,1),1))./repmat(std(dataPCA_raw,1,1),size(dataPCA_raw,1),1); % z-score Normalize
[weights_PCA_PC, score, latent, ~, PCA_explained] = pca(dataPCA');

% latent: eigenvalues
for ii = 1:denoised_dim
    projPC{ii} = dataPCA_raw' * weights_PCA_PC(:,ii);
end

% ============   1-D Trajectory of Eigen-neurons ===========
colorsPCA = {'b', 'r', 'g', 'k', 'm','c'};

ds = 1:denoised_dim;

%%%%%%%%%%%%%%%0
%         for pp = 1:2

PCA_times = 1:size(dataPCA,1);
figure(10);set(gcf,'name','Population Dynamics','unit','pixels','pos',[-1070 1050-450*2 950 350]); clf;
for ii = 1:denoised_dim
    plot(PCA_times,weights_PCA_PC(:,ii),'k-','color',colorsPCA{ii},'linewidth',4);hold on;
    xlim([0 length(PCA_times)])
    ylim([min(weights_PCA_PC(:)) max(weights_PCA_PC(:))]);
    xlabel('time (s)'); ylabel('Weight (a.u.)'); set(gca,'xtick',0:length(PCA_times)/2:length(PCA_times),'xticklabel',{'0','1000','2000'});title(['Eigen-time PC' num2str(ii)]); axis on;
end
title('Population Dynamics, All directions');
SetFigure(12);
legend('PC1','PC2','PC3','PC4','PC5','PC6');

% ============   Variance explained =================

%%%%%%%%%%%%%%%%%0
figure(15);set(figure(15),'name','Variance explained, All directions','unit','pixels','pos',[-1070 300 1050 600]); clf;

axes;hold on;
plot((1:length(PCA_explained))', cumsum(PCA_explained),'o-','markersize',8,'linew',1.5);
plot((1:denoised_dim)',cumsum(PCA_explained(1:denoised_dim)),'ro-','markersize',8,'linew',1.5,'markerfacecol','r');
plot([0 1],[0 PCA_explained(1)],'r-','linew',1.5);
plot(xlim,[1 1]*sum(PCA_explained(1:denoised_dim)),'r--');
text(denoised_dim,sum(PCA_explained(1:denoised_dim))*0.9,[num2str(sum(PCA_explained(1:denoised_dim))) '%'],'color','r');
xlabel('Num of principal components'); ylabel('Explained variability (%)'); ylim([0 100]);axis on;

axes('unit','pixels','pos',[20 20 900 20]);hold on;
text(0.25,0,'Translation');text(0.8,0,'Rotation');
axis off;
SetFigure(12);

end