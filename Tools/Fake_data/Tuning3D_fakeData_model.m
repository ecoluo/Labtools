% fake data for 3D tuning model
% LBY 202011


function Tuning3D_fakeData_model(a)
clc;
colorDefsLBY;

if nargin == 0
    a = 7;
end


duration = 1.5;
bin = 60;
step = duration/bin;
t = 0:step:duration;
coord = [-90 -45 0 45 90 270 225 180 135 90 45 0 315];

maxSPK = 80; % the max value of spike
mu = duration/2;
sig = sqrt(sqrt(2))/6;

%%% change here
progressbar('fake data & model fitting');
nCell = 300;

for cell_inx = 1:nCell
    
progressbar(cell_inx/nCell);
    
raw(cell_inx).meanSpon = 30*rand(1);
    
% preDir [azimuth, elevation]
raw(cell_inx).PDV = [rand(1)*360 rand(1)*180-90]; % [azimuth, elevation]
raw(cell_inx).PDA = [rand(1)*360 rand(1)*180-90]; % [azimuth, elevation]
raw(cell_inx).PDJ = [rand(1)*360 rand(1)*180-90]; % [azimuth, elevation]
raw(cell_inx).PDP = [rand(1)*360 rand(1)*180-90]; % [azimuth, elevation]

% weight
w_range = rand(1,4);temp = sum(w_range);w_range = w_range/temp;
raw(cell_inx).wV = w_range(1);
raw(cell_inx).wA = w_range(2);
raw(cell_inx).wJ = w_range(3);
raw(cell_inx).wP = w_range(4);

% delay(cell_inx)
raw(cell_inx).delayV = rand(1)/3.3; % A+0~0.3
raw(cell_inx).delayA = rand(1)/5; % u+0~0.2
raw(cell_inx).delayJ = rand(1)/3.3; % A+0~0.3
raw(cell_inx).delayP = rand(1)/3.3; % A+0~0.3


% V&A&J&P, all direction tuned, with respective weight(cell_inx)

%----- velocity
Rv = exp((-(t-(mu+raw(cell_inx).delayA+raw(cell_inx).delayV)).^2)./(2*sig.^2));
spatialTuningV = abs(cosTuning(raw(cell_inx).PDV, coord))+0.1; % +0.1 for value==0
ResponV = repmat(Rv,length(spatialTuningV),1) .* (repmat(spatialTuningV,length(Rv),1))';
ResponV = reshape(ResponV,[8 5 length(Rv)])*(maxSPK/max(max(max(ResponV))));

%----- acceleration
Ra = -(t-(mu+raw(cell_inx).delayA))./sig.^2.*exp((-(t-(mu+raw(cell_inx).delayA)).^2)./(2*sig.^2));
Ra = Ra + max(Ra);
ResponA = repmat(Ra,40,1);
spatialTuningA = cosTuning(raw(cell_inx).PDA, coord);
signS = sign(spatialTuningA);

% Ampilutde tuning
spatialTuningA = abs(cosTuning(raw(cell_inx).PDA, coord))+0.1; % +0.1 for value==0
ResponA = ResponA .* (repmat(spatialTuningA,length(Ra),1))'; %

% sign tuning
for nn = 1:size(ResponA,1)
    if signS(nn)<0
        ResponA(nn,:) = fliplr(ResponA(nn,:));
    end
end
ResponA = reshape(ResponA,[8 5 length(Ra)])*(maxSPK/max(max(max(ResponA))));

%----- Jerk
Rj = ((t-(mu+raw(cell_inx).delayA+raw(cell_inx).delayJ)).^2-sig.^2)./sig.^4.*exp((-(t-(mu+raw(cell_inx).delayA+raw(cell_inx).delayJ)).^2)./(2*sig.^2));
%         spatialTuningJ = abs(cosTuning(raw(cell_inx).PDJ, coord))+0.1; % +0.1 for value==0
spatialTuningJ = cosTuning(raw(cell_inx).PDJ, coord);
signS = repmat(sign(spatialTuningJ),length(Rj),1)';
ResponJ = repmat(Rj,40,1);

% Ampilutde tuning
spatialTuningJ = abs(cosTuning(raw(cell_inx).PDJ, coord))+0.1; % +0.1 for value==0
ResponJ = ResponJ .* (repmat(spatialTuningJ,length(Rj),1))'; %

% sign tuning
ResponJ = ResponJ.*signS;
ResponJ = reshape(ResponJ,[8 5 length(Rj)])*(maxSPK/max(max(max(ResponJ))));
ResponJ(ResponJ<0) = 0;

%----- Position
Rp = cumsum(exp((-(t-(mu+raw(cell_inx).delayA+raw(cell_inx).delayV+raw(cell_inx).delayP)).^2)./(2*sig.^2)));
spatialTuningP = cosTuning(raw(cell_inx).PDP, coord);
signS = repmat(sign(spatialTuningP),length(Rp),1)';
ResponP = repmat(Rp,40,1);

% Ampilutde tuning
spatialTuningP = abs(cosTuning(raw(cell_inx).PDP, coord))+0.1; % +0.1 for value==0
ResponP = ResponP .* (repmat(spatialTuningP,length(Rp),1))'; %

% sign tuning
for nn = 1:size(ResponP,1)
    if signS(nn)<0
        ResponP(nn,:) = fliplr(ResponP(nn,:));
    end
end

ResponP = reshape(ResponP,[8 5 length(Rp)])*(maxSPK/max(max(max(ResponP))));

% calculate response
raw(cell_inx).respon = ResponV.*raw(cell_inx).wV+ResponA.*raw(cell_inx).wA+ResponJ.*raw(cell_inx).wJ+ResponP.*raw(cell_inx).wP+raw(cell_inx).meanSpon;

% Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));

% add Gaussian noise


%% fit models
% %{
reps = 20;
stimOnBin = 1;
stimOffBin = bin+1;
aMax = duration/4*1000;
aMin = duration*3/4*1000;
fitData = permute(raw(cell_inx).respon,[2 1 3]);
spatialData = squeeze(sum(fitData,3));
% models = {'VA','AO'};
% models_color = {'k','g'};
models = {'VA','PVAJ'};
models_color = {'k','k'};
% models = {'AO'};
% models_color = {'g'};
model_catg = 'Out-sync model'; % each component has its own tau

% [PSTH3Dmodel.modelFitraw(cell_inx).respon_VA,PSTH3Dmodel.modelFit_VA,PSTH3Dmodel.modelFit_spatial,PSTH3Dmodel.modelFitPara_VA,PSTH3Dmodel.BIC_VA,PSTH3Dmodel.RSquared_VA,PSTH3Dmodel.rss_VA,PSTH3Dmodel.time]=fitVA(raw(cell_inx).meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin);
% for m_inx = 1:length(models)
%     eval(['[PSTH3Dmodel.modelFitraw(cell_inx).respon_',models{m_inx},',PSTH3Dmodel.modelFit_',models{m_inx},',PSTH3Dmodel.modelFit_spatial_',models{m_inx},',PSTH3Dmodel.modelFitPara_',models{m_inx},',PSTH3Dmodel.BIC_',models{m_inx},...
%         ',PSTH3Dmodel.RSquared_',models{m_inx},',PSTH3Dmodel.rss_',models{m_inx},',PSTH3Dmodel.time]=fit',models{m_inx},...
%         '(raw(cell_inx).meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin);']);
% end

switch model_catg
    
    case 'Sync model'
        for m_inx = 1:length(models)
            eval(['[PSTH3Dmodel{',num2str(cell_inx),'}.modelFitraw.respon_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFit_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFit_spatial',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFitPara_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.BIC_',models{m_inx},...
                ',PSTH3Dmodel{',num2str(cell_inx),'}.RSquared_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.rss_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.time]=fit',models{m_inx},...
                '(raw(cell_inx).meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin,duration);']);
            % [PSTH3Dmodel{1}.modelFitraw(cell_inx).respon_VO,PSTH3Dmodel{1}.modelFitPara_VO,PSTH3Dmodel{1}.BIC_VO,PSTH3Dmodel{1}.RSquared_VO,PSTH3Dmodel{1}.rss_VO,PSTH3Dmodel{1}.time]=fitVO(raw(cell_inx).meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
    case 'Out-sync model'
%         keyboard;
        for m_inx = 1:length(models)
            eval(['[PSTH3Dmodel{',num2str(cell_inx),'}.modelFitraw(cell_inx).respon_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFit_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFit_spatial',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.modelFitPara_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.BIC_',models{m_inx},...
                ',PSTH3Dmodel{',num2str(cell_inx),'}.RSquared_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.rss_',models{m_inx},',PSTH3Dmodel{',num2str(cell_inx),'}.time]=fit',models{m_inx},'_O',...
                '(raw(cell_inx).meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin,duration);']);
            % [PSTH3Dmodel{1}.modelFitraw(cell_inx).respon_VO,PSTH3Dmodel{1}.modelFitPara_VO,PSTH3Dmodel{1}.BIC_VO,PSTH3Dmodel{1}.RSquared_VO,PSTH3Dmodel{1}.rss_VO,PSTH3Dmodel{1}.time]=fitVO(raw(cell_inx).meanSpon,PSTH_data,spatial_data,nBins,reps,stimOnBin,stimOffBin,aMax,aMin);
        end
end


%}

%% figures;

markers = {
    % markerName % markerTime % marker bin time % color
    'aMax',duration/4,bin/4,colorDBlue;
    'aMin',duration/4*3,bin/4*3,colorDBlue;
    'v',duration/2,bin/2,colorLRed;
    };

%% Original data
%
% figure(103);
% set(gcf,'pos',[30 50 1000 500]);
% clf;
% axes;hold on;
% % for ii = 1:size(raw(cell_inx).respon,1)
% plot(raw(cell_inx).respon(:,:)','k','linewidth',1.5);
% set(gca,'xlim',[0 length(R)]);
% % for n = 1:size(markers,1)
% %             plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
% %             hold on;
% %         end


figure(101);
set(gcf,'pos',[30 50 1800 900]);
clf;
[~,h_subplot] = tight_subplot(5,8,0.04,0.15);

for j = 2:4
    for i = 1:8
        axes(h_subplot(i+(j-1)*8));
        plot(squeeze(raw(cell_inx).respon(i,j,:)),'k','linewidth',1.5);
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
plot(squeeze(raw(cell_inx).respon(5,1,:)),'k','linewidth',1.5);
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
plot(squeeze(raw(cell_inx).respon(5,5,:)),'k','linewidth',1.5);
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

% spontaneous
%     axes(h_subplot(1+(1-1)*9));

saveas(gca,['Z:\LBY\Recording data\fakeData\3DTuning_', num2str(cell_inx)], 'emf');

% keyboard;
%% model figures
%{
for m_inx = 1:length(models)
    figure(102+m_inx);
    set(gcf,'pos',[30 50 1800 900]);
    clf;
    [~,h_subplot] = tight_subplot(5,8,0.04,0.15);
    
    for j = 2:4
        for i = 1:8
            axes(h_subplot(i+(j-1)*8));
            bar(squeeze(raw(cell_inx).respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
            eval(['h = plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_',models{m_inx},'(',num2str(i),',',num2str(j),',:)));']);
            set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
            %         plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_VA(i,j,:)),'k','linewidth',1.5);
            hold on;
            for n = 1:size(markers,1)
                plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
                hold on;
            end
            set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
            %             axis off;
            SetFigure(15);
            set(gca,'xtick',[],'xticklabel',[]);
        end
    end
    
    % 2 extra conditions
    axes(h_subplot(5+(1-1)*8));
    bar(squeeze(raw(cell_inx).respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
    eval(['h = plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_',models{m_inx},'(5,1,:)));']);
    set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
    % plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_VA(5,1,:)),'k','linewidth',1.5);
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
    
    axes(h_subplot(5+(5-1)*8));
    bar(squeeze(raw(cell_inx).respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
    eval(['h = plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_',models{m_inx},'(5,5,:)));']);
    set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
    % plot(squeeze(PSTH3Dmodel.modelFitraw(cell_inx).respon_VA(5,5,:)),'k','linewidth',1.5);
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
end
%}
%% model figures for V & A respectively
%{
% VA-V
figure(110);
set(gcf,'pos',[30 50 1800 900]);
clf;
[~,h_subplot] = tight_subplot(5,8,0.04,0.15);

for j = 2:4
    for i = 1:8
        axes(h_subplot(i+(j-1)*8));
        bar(squeeze(raw(cell_inx).respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
        h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(i,j,:)));
        set(h,'linestyle','-','linewidth',2,'color','r');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
bar(squeeze(raw(cell_inx).respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(5,1,:)));
set(h,'linestyle','-','linewidth',2,'color','r');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
bar(squeeze(raw(cell_inx).respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(5,5,:)));
set(h,'linestyle','-','linewidth',2,'color','r');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

% VA-A
figure(111);
set(gcf,'pos',[30 50 1800 900]);
clf;
[~,h_subplot] = tight_subplot(5,8,0.04,0.15);

for j = 2:4
    for i = 1:8
        axes(h_subplot(i+(j-1)*8));
        bar(squeeze(raw(cell_inx).respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
        h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(i,j,:)));
        set(h,'linestyle','-','linewidth',2,'color','b');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
bar(squeeze(raw(cell_inx).respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(5,1,:)));
set(h,'linestyle','-','linewidth',2,'color','b');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
bar(squeeze(raw(cell_inx).respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(5,5,:)));
set(h,'linestyle','-','linewidth',2,'color','b');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(raw(cell_inx).respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(raw(cell_inx).respon(:))],'xlim',[1 size(raw(cell_inx).respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

%}

end


% save('Z:\Labtools\Tools\Fake_data\fake_raw.mat','raw');
save('Z:\Labtools\Tools\Fake_data\fake_raw_3D_out-sync_model.mat','raw','PSTH3Dmodel');

end

% cosine tuning

function r = cosTuning(preDir, coord)

u_ele = coord(1:5);
u_azi = coord(6:13);

ele = repmat(u_ele,length(u_azi),1)';
azi = repmat(u_azi,length(u_ele),1);
amp = ones(length(u_ele),length(u_azi));

c = 0;
for jj = 1:5
    for ii = 1:8
        c = c+1;
        r(c) = angle_Diff(azi(jj,ii),ele(jj,ii),1,preDir(1),preDir(2),1);
        %                 r = cos(r);
    end
end

end


function angleDiff = angle_Diff(azi1,ele1,amp1,azi2,ele2,amp2)

% transform spherical coordinates to cartesian
[x1,y1,z1] = sph2cart(azi1*pi/180,ele1*pi/180,amp1);
[x2,y2,z2] = sph2cart(azi2*pi/180,ele2*pi/180,amp2);

% calculate the angles between the two vectors
mod1 = sqrt((x1.^2+y1.^2+z1.^2));
mod2 = sqrt((x2.^2+y2.^2+z2.^2));
angleDiff = (x1.*x2+y1.*y2+z1.*z2)/(mod1*mod2); % cosine of angle differences
%         angleDiff = acos((x1.*x2+y1.*y2+z1.*z2)/(mod1*mod2))*180/pi; % angle differences
end




















