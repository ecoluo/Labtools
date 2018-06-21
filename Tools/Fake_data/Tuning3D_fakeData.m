% fake data for 3D tuning model
% LBY 201805
% a = 1 -> % velocity dominated, directionally tuned
% a = 2 -> % velocity dominated, no direction tuning
% a = 3 -> % acceleration dominated,directionally tuned
% a = 4 -> % acceleration dominated, no direction tuning

function Tuning3D_fakeData(a)
clc;
colorDefsLBY;

if nargin == 0
    a = 6;
end;

meanSpon = 10;
duration = 1.5;
bin = 60;
step = duration/bin;
t = 0:step:duration;
coord = [-90 -45 0 45 90 270 225 180 135 90 45 0 315];

maxSPK = 30; % the max value of spike
mu = duration/2;
sig = sqrt(sqrt(2))/6;
preDir = [45 30]; % [azimuth, elevation]
preDir_V = [45 30]; % [azimuth, elevation]
preDir_A = [30 60]; % [azimuth, elevation]

switch a
    case 1 % velocity dominated, directionally tuned
        
        R = exp((-(t-mu).^2)./(2*sig.^2));
        spatialTuning = abs(cosTuning(preDir, coord))+0.1; % +0.1 for value==0
        Respon = repmat(R,length(spatialTuning),1) .* (repmat(spatialTuning,length(R),1))';
        Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));
        % Respon = repmat(Respon,[1 1 1 5]); % five repetitions
        
    case 2 % velocity dominated, no direction tuning
        
        R = exp((-(t-mu).^2)./(2*sig.^2));
        Respon = repmat(R,40,1);
        Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));
        
    case 3 % acceleration dominated,directionally tuned
        
        R = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2));
        R = R + max(R);
        Respon = repmat(R,40,1);
        spatialTuning = cosTuning(preDir, coord);
        signS = sign(spatialTuning);
        
        % Ampilutde tuning
        spatialTuning = abs(cosTuning(preDir, coord))+0.1; % +0.1 for value==0
        Respon = Respon .* (repmat(spatialTuning,length(R),1))'; %
        
        % sign tuning
        for nn = 1:size(Respon,1)
            if signS(nn)<0
                Respon(nn,:) = fliplr(Respon(nn,:));
            end
        end
        %         Respon = Respon .*signS;
        Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));
        
        
        
    case 4 % acceleration dominated, no direction tuning
        
        R = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2));
        R = R + max(R);
        Respon = repmat(R,40,1);
        Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));
        
    case 5 % acceleration dominated,directionally tuned(with mu changed)
        spatialTuning = cosTuning(preDir, coord);
        signS = sign(spatialTuning);
        %                 mu = mu*abs(spatialTuning);
        
        % to shrunk the range of mu
        mu = mu*((abs(spatialTuning)-0.5)/(0.5/(1-0.85))+0.85); % 0.75 is the lower boundary preferred, 0.5 is the min of spatialTuning
        
        for ii = 1:length(mu)
            R(ii,:) = (-(t-mu(ii))./sig.^2.*exp((-(t-mu(ii)).^2)./(2*sig.^2))).*signS(ii);
        end
        Respon = R + max(R(:));
        Respon = reshape(Respon,[8 5 length(R)])*(maxSPK/max(max(max(Respon))));
        
    case 6 % V&A, both direction tuned(V&A with different spatial tuning,i.e. case1+3 with respective weight)
        
        % velocity
                Rv = exp((-(t-mu).^2)./(2*sig.^2));
        spatialTuningV = abs(cosTuning(preDir_V, coord))+0.1; % +0.1 for value==0
        ResponV = repmat(Rv,length(spatialTuningV),1) .* (repmat(spatialTuningV,length(Rv),1))';
        ResponV = reshape(ResponV,[8 5 length(Rv)])*(maxSPK/max(max(max(ResponV))));
        
        % acceleration
        Ra = -(t-mu)./sig.^2.*exp((-(t-mu).^2)./(2*sig.^2));
        Ra = Ra + max(Ra);
        ResponA = repmat(Ra,40,1);
        spatialTuningA = cosTuning(preDir_A, coord);
        signS = sign(spatialTuningA);
        
        % Ampilutde tuning
        spatialTuningA = abs(cosTuning(preDir_A, coord))+0.1; % +0.1 for value==0
        ResponA = ResponA .* (repmat(spatialTuningA,length(Ra),1))'; %

        % sign tuning
        for nn = 1:size(ResponA,1)
            if signS(nn)<0
                ResponA(nn,:) = fliplr(ResponA(nn,:));
            end
        end
        %         Respon = Respon .*signS;
        ResponA = reshape(ResponA,[8 5 length(Ra)])*(maxSPK/max(max(max(ResponA))));
        
        % V&A (weight)
        wV = 0.9;
        wA = 0.1;
        Respon = ResponV.*wV+ResponA.*wA+meanSpon;
end

%% fit models
reps = 50;
stimOnBin = 1;
stimOffBin = bin+1;
aMax = duration/4*1000;
aMin = duration*3/4*1000;
fitData = permute(Respon,[2 1 3]);
spatialData = squeeze(sum(fitData,3));
% models = {'VA','AO'};
% models_color = {'k','g'};
models = {'VA'};
models_color = {'k'};
% models = {'AO'};
% models_color = {'g'};
% [PSTH3Dmodel.modelFitRespon_VA,PSTH3Dmodel.modelFit_VA,PSTH3Dmodel.modelFit_spatial,PSTH3Dmodel.modelFitPara_VA,PSTH3Dmodel.BIC_VA,PSTH3Dmodel.RSquared_VA,PSTH3Dmodel.rss_VA,PSTH3Dmodel.time]=fitVA(meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin);
for m_inx = 1:length(models)
    eval(['[PSTH3Dmodel.modelFitRespon_',models{m_inx},',PSTH3Dmodel.modelFit_',models{m_inx},',PSTH3Dmodel.modelFit_spatial_',models{m_inx},',PSTH3Dmodel.modelFitPara_',models{m_inx},',PSTH3Dmodel.BIC_',models{m_inx},...
        ',PSTH3Dmodel.RSquared_',models{m_inx},',PSTH3Dmodel.rss_',models{m_inx},',PSTH3Dmodel.time]=fit',models{m_inx},...
        '(meanSpon,fitData,spatialData,bin+1,reps,stimOnBin,stimOffBin,aMax,aMin);']);
end


%% figures;

markers = {
    % markerName % markerTime % marker bin time % color
    'aMax',duration/4,bin/4,colorDBlue;
    'aMin',duration/4*3,bin/4*3,colorDBlue;
    'v',duration/2,bin/2,colorLRed;
    };

%% Original data

figure(101);
set(gcf,'pos',[30 50 1800 900]);
clf;
[~,h_subplot] = tight_subplot(5,8,0.04,0.15);

for j = 2:4
    for i = 1:8
        axes(h_subplot(i+(j-1)*8));
        plot(squeeze(Respon(i,j,:)),'k','linewidth',1.5);
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
plot(squeeze(Respon(5,1,:)),'k','linewidth',1.5);
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
plot(squeeze(Respon(5,5,:)),'k','linewidth',1.5);
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

% spontaneous
%     axes(h_subplot(1+(1-1)*9));

% keyboard;
%% model figures

for m_inx = 1:length(models)
    figure(102+m_inx);
    set(gcf,'pos',[30 50 1800 900]);
    clf;
    [~,h_subplot] = tight_subplot(5,8,0.04,0.15);
    
    for j = 2:4
        for i = 1:8
            axes(h_subplot(i+(j-1)*8));
            bar(squeeze(Respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
            eval(['h = plot(squeeze(PSTH3Dmodel.modelFitRespon_',models{m_inx},'(',num2str(i),',',num2str(j),',:)));']);
            set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
            %         plot(squeeze(PSTH3Dmodel.modelFitRespon_VA(i,j,:)),'k','linewidth',1.5);
            hold on;
            for n = 1:size(markers,1)
                plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
                hold on;
            end
            set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
            %             axis off;
            SetFigure(15);
            set(gca,'xtick',[],'xticklabel',[]);
        end
    end
    
    % 2 extra conditions
    axes(h_subplot(5+(1-1)*8));
    bar(squeeze(Respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
    eval(['h = plot(squeeze(PSTH3Dmodel.modelFitRespon_',models{m_inx},'(5,1,:)));']);
    set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
    % plot(squeeze(PSTH3Dmodel.modelFitRespon_VA(5,1,:)),'k','linewidth',1.5);
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
    
    axes(h_subplot(5+(5-1)*8));
    bar(squeeze(Respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
    eval(['h = plot(squeeze(PSTH3Dmodel.modelFitRespon_',models{m_inx},'(5,5,:)));']);
    set(h,'linestyle','-','linewidth',2,'color',models_color{m_inx});
    % plot(squeeze(PSTH3Dmodel.modelFitRespon_VA(5,5,:)),'k','linewidth',1.5);
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
end

%% model figures for V & A respectively

% VA-V
figure(110);
set(gcf,'pos',[30 50 1800 900]);
clf;
[~,h_subplot] = tight_subplot(5,8,0.04,0.15);

for j = 2:4
    for i = 1:8
        axes(h_subplot(i+(j-1)*8));
        bar(squeeze(Respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
        h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(i,j,:)));
        set(h,'linestyle','-','linewidth',2,'color','r');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
bar(squeeze(Respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(5,1,:)));
set(h,'linestyle','-','linewidth',2,'color','r');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
bar(squeeze(Respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.V(5,5,:)));
set(h,'linestyle','-','linewidth',2,'color','r');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
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
        bar(squeeze(Respon(i,j,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
        h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(i,j,:)));
        set(h,'linestyle','-','linewidth',2,'color','b');
        hold on;
        for n = 1:size(markers,1)
            plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
        %             axis off;
        SetFigure(15);
        set(gca,'xtick',[],'xticklabel',[]);
    end
end

% 2 extra conditions
axes(h_subplot(5+(1-1)*8));
bar(squeeze(Respon(5,1,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(5,1,:)));
set(h,'linestyle','-','linewidth',2,'color','b');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

axes(h_subplot(5+(5-1)*8));
bar(squeeze(Respon(5,5,:)),'facecolor',colorLGray,'edgecolor',colorLGray);hold on;
h = plot(squeeze(PSTH3Dmodel.modelFit_VA.A(5,5,:)));
set(h,'linestyle','-','linewidth',2,'color','b');

hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(Respon(:))], '--','color',markers{n,4},'linewidth',0.5);
    hold on;
end
set(gca,'ylim',[0 max(Respon(:))],'xlim',[1 size(Respon,3)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

keyboard;
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




















