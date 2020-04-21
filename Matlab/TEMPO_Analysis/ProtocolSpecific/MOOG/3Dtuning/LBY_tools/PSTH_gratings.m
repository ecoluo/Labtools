%% plot figures - PSTH
%
global PSTH;

% % ------ fig.20 plot PSTH for each trial and raster plot across directions ------%
%{
for k = 1:length(unique_stimType)
    figure(20+k);
    set(gcf,'pos',[0 0 1900 1000]);
    clf;
    for j = 2:length(unique_elevation)-1
        for i = 1:length(unique_azimuth)
            h1 = axes('unit','pixels','pos',[30+200*(i-1) 20+180*(5-j) 180 80]);
            for n = 1:size(markers,1)
                plot(h1,[markers{n,3} markers{n,3}], [0,max(PSTH.maxSpkRealBinMean(k),PSTH.maxSpkSponBinMean)], '--','color',markers{n,4},'linewidth',0.5);
                hold on;
            end
            for r = 1:size((PSTH.spk_data_bin_rate{k,j,iAzi(i)}),2)
                color = ['color',num2str(r)];
                plot(h1,PSTH.spk_data_bin_rate{k,j,iAzi(i)}(:,r)','color',eval(color));
                axis off;
                hold on;
                h2 = axes('unit','pixels','pos',[30+200*(i-1) 20+90+180*(5-j)+8*(r-1) 180 8]);
                %                 tt = stimOnT(1)-tOffset1:stimOffT(1)+tOffset2; yy = ones(tOffset1+tOffset2+unique_duration(1,1));
                %                 tt = tt(logical(spk_data{k,j,iAzi(i)}(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r)));
                %                 yy = yy(logical(spk_data{k,j,iAzi(i)}(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r)));
                %                 yy = repmat(yy,1,2);
                %                 plot(h2,tt,yy,'.k');
                stem(h2, stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,spk_data{k,j,iAzi(i)}(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r),'k-','marker','none');
                hold on;
                for n = 1:size(markers,1)
                    plot(h2,[markers{n,2} markers{n,2}], [0,1], '-','color',markers{n,4},'linewidth',0.5);
                    hold on;
                end
                axis off;
                set(h2,'xlim',[stimOnT(1)-tOffset1 stimOffT(1)+tOffset2]);
            end
            %             set(h1,'ylim',[0 max(maxSpkRealAll(k),maxSpkSponAll)],'xlim',[1 nBins(1,1)]);
            set(h1,'xlim',[1 nBins(1,1)]);
        end
    end



    % extra 2 conditons
    h1 = axes('unit','pixels','pos',[30+200*(5-1) 20+180*(5-1) 180 80]);
    for n = 1:size(markers,1)
        plot(h1,[markers{n,3} markers{n,3}], [0,max(PSTH.maxSpkRealBinMean(k),PSTH.maxSpkSponBinMean)], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    for r = 1:size((PSTH.spk_data_bin_rate{k,1,5}),2)
        color = ['color',num2str(r)];
        plot(h1,PSTH.spk_data_bin_rate{k,1,5}(:,r)','color',eval(color));
        axis off;
        hold on;
        h2 = axes('unit','pixels','pos',[30+200*(5-1) 20+90+180*(5-1)+8*(r-1) 180 8]);
        stem(h2,stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,spk_data{k,1,5}(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r),'k-','marker','none');
        hold on;
        for n = 1:size(markers,1)
            plot(h2,[markers{n,2} markers{n,2}], [0,1], '-','color',markers{n,4},'linewidth',0.5);
            hold on;
        end

        axis off;
        set(h2,'xlim',[stimOnT(1)-tOffset1 stimOffT(1)+tOffset2]);
    end
    set(h1,'xlim',[1 nBins(1,1)]);

    h1 = axes('unit','pixels','pos',[30+200*(5-1) 20+180*(5-5) 180 80]);
    for n = 1:size(markers,1)
        plot(h1,[markers{n,3} markers{n,3}], [0,max(PSTH.maxSpkRealBinMean(k),PSTH.maxSpkSponBinMean)], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    for r = 1:size((PSTH.spk_data_bin_rate{k,5,5}),2)
        color = ['color',num2str(r)];
        plot(h1,PSTH.spk_data_bin_rate{k,5,5}(:,r)','color',eval(color));
        axis off;
        hold on;
        h2 = axes('unit','pixels','pos',[30+200*(5-1) 20+90+180*(5-5)+8*(r-1) 180 8]);
        stem(h2,stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,spk_data{k,5,5}(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r),'k-','marker','none');
        hold on;
        for n = 1:size(markers,1)
            plot(h2,[markers{n,2} markers{n,2}], [0,1], '-','color',markers{n,4},'linewidth',0.5);
            hold on;
        end

        axis off;
        set(h2,'xlim',[stimOnT(1)-tOffset1 stimOffT(1)+tOffset2]);
    end
    set(h1,'xlim',[1 nBins(1,1)]);


    % spontaneous response
    h1 = axes('unit','pixels','pos',[30+200*(1-1) 20+180*(5-1) 180 80]);
    for n = 1:size(markers,1)
        plot(h1,[markers{n,3} markers{n,3}], [0,max(PSTH.maxSpkRealBinMean(k),PSTH.maxSpkSponBinMean)], '--','color',markers{n,4},'linewidth',0.5);
        hold on;
    end
    for r = 1:size(PSTH.spon_spk_data_bin_rate,2)
        color = ['color',num2str(r)];
        plot(h1,PSTH.spon_spk_data_bin_rate(:,r)','color',eval(color));
        axis off;
        hold on;
        h2 = axes('unit','pixels','pos',[30+200*(1-1) 20+90+180*(5-1)+8*(r-1) 180 8]);
        stem(h2,stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,spon_spk_data(stimOnT(1)-tOffset1:stimOffT(1)+tOffset2,r),'k-','marker','none');
        hold on;
        for n = 1:size(markers,1)
            plot(h2,[markers{n,2} markers{n,2}], [0,1], '-','color',markers{n,4},'linewidth',0.5);
            hold on;
        end
        axis off;
        set(h2,'xlim',[stimOnT(1)-tOffset1 stimOffT(1)+tOffset2]);
    end
    set(h1,'xlim',[1 nBins(1,1)]);

    %text on the figure
    axes('unit','pixels','pos',[60 850 1800 80]);
    xlim([0,100]);
    ylim([0,10]);
    if Protocol == DIRECTION_TUNING_3D
        text(30,10,'PSTHs and raster plot for each direction across trials(T)','fontsize',20);
    elseif Protocol == ROTATION_TUNING_3D
        text(30,10,'PSTHs and raster plot for each direction across trials(R)','fontsize',20);
    end
    text(-1,10,'spontaneous','fontsize',15);
    FileNameTemp = num2str(FILE);
    FileNameTemp =  FileNameTemp(1:end);
    str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
    str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan),'    ',stimType{k}];
    text(70,0,str1,'fontsize',18);
    axis off;

    axes('unit','pixels','pos',[60 50 1800 180]);
    xlim([0,100]);
    ylim([0,10]);
    text(0,0,['Max spk FR(Hz): ',num2str(PSTH.maxSpkRealBinAll(k)),' (Bin)'],'fontsize',15);
    text(0,3,['Spon max FR(Hz): ',num2str(maxSpkSponAll), ' (Bin)'],'fontsize',15);

    axis off;

    % save the figure
    str2 = [str,'_PSTHs_raster_trial_',stimType{k}];
    set(gcf,'paperpositionmode','auto');
    switch Protocol
        case DIRECTION_TUNING_3D
            ss = [str2, '_T'];
            saveas(20+k,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning\Translation\' ss], 'emf');
        case ROTATION_TUNING_3D
            ss = [str2, '_R'];
            saveas(20+k,['Z:\LBY\Recording data\',PSTH.monkey,'\3D_Tuning\Rotation\' ss], 'emf');
    end
end
%}

% % ------ fig.30 plot mean PSTHs across directions (with errorbar)------%
%{
figure(30);
set(gcf,'pos',[30 100 1800 800]);
clf;
[~,h_subplot] = tight_subplot(2+(length(unique_spatFre)*length(unique_tempFre)),9,0.04,0.15);

%%%%% optic flow
for i = 1:length(unique_orient)
    axes(h_subplot(i+9));
    errorbar(PSTH.opt_bin_mean_rate(iAzi(i),:),PSTH.opt_bin_mean_rate_ste(iAzi(i),:),'color','k');
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(PSTH.opt_maxSpkRealBinMean,PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
        hold on;
    end
    set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
    %     axis on;
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
    %     set(gca,'yticklabel',[]);
    
end

axes(h_subplot(18));
text(0,0.5,'Optic flow');

%%%%% gratings

for ss = 1:length(unique_spatFre)
    for tt = 1:length(unique_tempFre)
        for i = 1:length(unique_orient)
            axes(h_subplot(i+(tt-1)*9*length(unique_spatFre)+(ss-1)*9*length(unique_tempFre)+18));
            errorbar(squeeze(PSTH.bin_mean_rate(ss,tt,iAzi(i),:)),squeeze(PSTH.bin_mean_rate_ste(ss,tt,iAzi(i),:)),'color','k');
            hold on;
            for n = 1:size(markers,1)
                plot([markers{n,3} markers{n,3}], [0,max(max(PSTH.maxSpkRealbin_mean),PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
                hold on;
            end
            set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
            %             axis off;
            SetFigure(15);
            set(gca,'xtick',[],'xticklabel',[]);
            %             set(gca,'yticklabel',[]);
        end
    end
    axes(h_subplot(18+9*ss)); % 暂时这么写
    text(0,0.5,'Grating');
end

% spontaneous
axes(h_subplot(1));
errorbar(PSTH.spon_spk_data_bin_mean_rate,PSTH.spon_spk_data_bin_mean_rate_ste,'color','k');
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(max(PSTH.maxSpkRealbin_mean),PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
    hold on;
end
set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

% text on the figure
axes('unit','pixels','pos',[60 710 1800 80]);
xlim([0,100]);
ylim([0,10]);
text(30,3,'PSTHs (optic flow vs. gratings, fronto-parellel plane)','fontsize',20);
text(2,0,'Spontaneous','fontsize',15);
FileNameTemp = num2str(FILE);
FileNameTemp =  FileNameTemp(1:end);
str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan)];
text(70,0,str1,'fontsize',18);
axis off;

axes('unit','pixels','pos',[60 -20 1800 100]);
xlim([0,100]);
ylim([0,10]);
text(0,7,['Spon max FR(Hz): ',num2str(PSTH.maxSpkSponbin_mean), ' (Bin)'],'fontsize',15);
text(0,10,['Spon mean FR(Hz): ',num2str(PSTH.meanSpkSponbin_mean), ' (Bin)'],'fontsize',15);


%     %--- this is for annotation - the direction ----%
%     text(4,0,'\downarrow ','fontsize',30);
%     text(24,0,'\leftarrow ','fontsize',30);
%     text(46,0,'\uparrow ','fontsize',30);
%     text(67,0,'\rightarrow ','fontsize',30);
%     text(88,0,'\downarrow ','fontsize',30);
%     text(52,65,'\uparrow ','fontsize',30);
%     text(52,10,'\downarrow ','fontsize',30);
%     %--- this is for annotation - the direction ----%
axis off;

% to save the figures
str3 = [str, '_grating_opt'];
set(gcf,'paperpositionmode','auto');

saveas(30,['Z:\LBY\Recording data\',PSTH.monkey,'\Grating\' str3], 'emf');

%}

% % ------ fig.40 plot mean PSTHs across directions (with errorbar)------%
% %{

figure(40);
set(gcf,'pos',[30 100 1800 800]);
clf;
[~,h_subplot] = tight_subplot(2+(length(unique_spatFre)*length(unique_tempFre)),9,0.04,0.15);

%%%%% optic flow
for i = 1:length(unique_orient)
    axes(h_subplot(i+9));
    plot(PSTH.opt_bin_mean_rate(iAzi(i),:),'color','k','linewidth',5);
    hold on;
    for n = 1:size(markers,1)
        plot([markers{n,3} markers{n,3}], [0,max(PSTH.opt_maxSpkRealBinMean,PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
        hold on;
    end
    set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
    SetFigure(15);
    set(gca,'xtick',[],'xticklabel',[]);
    %     set(gca,'yticklabel',[]);
    
end

axes(h_subplot(18));
text(0,0.5,'Optic flow');

%%%%% gratings

for ss = 1:length(unique_spatFre)
    for tt = 1:length(unique_tempFre)
        for i = 1:length(unique_orient)
            axes(h_subplot(i+(tt-1)*9*length(unique_spatFre)+(ss-1)*9*length(unique_tempFre)+18));
            plot(squeeze(PSTH.bin_mean_rate(ss,tt,iAzi(i),:)),'color','k','linewidth',5);
            hold on;
            for n = 1:size(markers,1)
                plot([markers{n,3} markers{n,3}], [0,max(max(PSTH.maxSpkRealbin_mean),PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
                hold on;
            end
            set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
            SetFigure(15);
            set(gca,'xtick',[],'xticklabel',[]);
            %             set(gca,'yticklabel',[]);
        end
    end
    axes(h_subplot(18+9*ss)); % 暂时这么写
    text(0,0.5,'Grating');
end

% spontaneous
axes(h_subplot(1));
plot(PSTH.spon_spk_data_bin_mean_rate,'color','k','linewidth',5);
hold on;
for n = 1:size(markers,1)
    plot([markers{n,3} markers{n,3}], [0,max(max(PSTH.maxSpkRealbin_mean),PSTH.maxSpkSponbin_mean)], '--','color',markers{n,4},'linewidth',3);
    hold on;
end
set(gca,'ylim',[0 max([PSTH.opt_maxSpkRealBinMean+PSTH.opt_maxSpkRealBinMeanSte,PSTH.maxSpkSponbin_mean+PSTH.maxSpkSponbin_meanSte, max(PSTH.maxSpkRealbin_mean+PSTH.maxSpkRealbin_meanSte)])],'xlim',[1 nBins(1,1)]);
SetFigure(15);
set(gca,'xtick',[],'xticklabel',[]);

% text on the figure
axes('unit','pixels','pos',[60 710 1800 80]);
xlim([0,100]);
ylim([0,10]);
text(30,3,'PSTHs (optic flow vs. gratings, fronto-parellel plane)','fontsize',20);
text(2,0,'Spontaneous','fontsize',15);
FileNameTemp = num2str(FILE);
FileNameTemp =  FileNameTemp(1:end);
str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan)];
text(70,0,str1,'fontsize',18);
axis off;

axes('unit','pixels','pos',[60 -20 1800 100]);
xlim([0,100]);
ylim([0,10]);
text(0,7,['Spon max FR(Hz): ',num2str(PSTH.maxSpkSponbin_mean), ' (Bin)'],'fontsize',15);
text(0,10,['Spon mean FR(Hz): ',num2str(PSTH.meanSpkSponbin_mean), ' (Bin)'],'fontsize',15);


%     %--- this is for annotation - the direction ----%
%     text(4,0,'\downarrow ','fontsize',30);
%     text(24,0,'\leftarrow ','fontsize',30);
%     text(46,0,'\uparrow ','fontsize',30);
%     text(67,0,'\rightarrow ','fontsize',30);
%     text(88,0,'\downarrow ','fontsize',30);
%     text(52,65,'\uparrow ','fontsize',30);
%     text(52,10,'\downarrow ','fontsize',30);
%     %--- this is for annotation - the direction ----%
axis off;

% to save the figures
str3 = [str, '_grating_opt_report'];
set(gcf,'paperpositionmode','auto');

saveas(40,['Z:\LBY\Recording data\',PSTH.monkey,'\Grating\' str3], 'emf');

%}