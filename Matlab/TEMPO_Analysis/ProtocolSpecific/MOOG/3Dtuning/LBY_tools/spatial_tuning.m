% spatial_tuning
% LBY 20180706

%{
figure;
set(gcf,'pos',[60 100 1800 900]);
clf;
for k = 1:length(unique_stimType)
    
    epo = 5;
    for nn = 1:epo
        spk_spatial_fr(:,:,nn) =mean(PSTH.spk_data_bin_mean_rate{k}(:,:,stimOnBin*nn:stimOnBin*nn+(stimOffBin-stimOnBin+1)/epo-1),3);
        spk_spatial_trans(:,nn) = reshape(spk_spatial_fr(:,:,nn),[],1);
    end
    data_plot = [pre_diff{k}',spk_spatial_trans];
    data_plot = sortrows(data_plot);
    subplot(1,length(unique_stimType),k);
    plot(data_plot(:,1),data_plot(:,2:epo+1),'linewidth',3);
    
end

%}

% %{

for k = 1:length(unique_stimType)
% for k = 2
    figure(101+k);
set(gcf,'pos',[60 100 1800 900]);
clf;
    spk_spatial_fr(:,:) = mean(PSTH.spk_data_bin_mean_rate{k}(:,:,:),3);
    uni_azi = [0 45 90 135 180 225 270 315];
    uni_ele = [-90 -45 0 45 90];
    [~,pre_azi_inx] = min(abs(uni_azi-preferDire{k}(1)));
    [~,pre_ele_inx] = min(abs(uni_ele-preferDire{k}(2)));
    pre_azi = uni_azi(pre_azi_inx);
    pre_ele = uni_ele(pre_ele_inx);
    
    diff_hori = pre_azi - [0 45 90 135 180 225 270 315]; % left < 0
    
    if pre_azi>180
    diff_hori(abs(diff_hori)>180) = diff_hori(abs(diff_hori)>180) - 360;
    else
    diff_hori(abs(diff_hori)>=180) = diff_hori(abs(diff_hori)>=180) + 360; 
    end
    diff_hori = [diff_hori -180];
    inx = find(diff_hori==180);
    data_plot_hori = spk_spatial_fr(pre_ele_inx,:)';
    data_plot_hori = [data_plot_hori;data_plot_hori(inx)];
    data_plot_hori = [diff_hori',data_plot_hori];
    data_plot_hori = sortrows(data_plot_hori);
    

    diff_vert = [-90 -45 0 45 90 135 -180 -135] - pre_ele;
    if pre_ele<0 
        diff_vert(diff_vert>180) = 360-diff_vert(diff_vert>180);
    else
        diff_vert(diff_vert<=-180) = 360+diff_vert(diff_vert<=-180);
    end   
    diff_vert = [diff_vert -180];
    pre_azi_inx_invert = (-4)^(pre_azi_inx>4)+pre_azi_inx;
    data_plot_vert = [spk_spatial_fr(:,pre_azi_inx);spk_spatial_fr(4:-1:2,pre_azi_inx_invert)];
    inx = find(diff_vert==180);
    data_plot_vert = [data_plot_vert;data_plot_vert(inx)];
    data_plot_vert = [diff_vert',data_plot_vert];
    data_plot_vert = sortrows(data_plot_vert);
    
    plot(data_plot_hori(:,1),data_plot_hori(:,2),'r-','linewidth',3);hold on;
    plot(data_plot_vert(:,1),data_plot_vert(:,2),'linewidth',3);hold on;
    xlim([-180,180]);
    box off;
    legend('horizontal','vertical','Location','NorthWest');
    
    % text on the figure
    axes('unit','pixels','pos',[60 810 1500 80]);
    xlim([0,100]);
    ylim([0,10]);
    switch Protocol
        case DIRECTION_TUNING_3D
            text(36,3,'PSTHs for each direction(T)','fontsize',20);
        case ROTATION_TUNING_3D
            text(36,3,'PSTHs for each direction(R)','fontsize',20);
    end
     FileNameTemp = num2str(FILE);
    FileNameTemp =  FileNameTemp(1:end);
    str = [FileNameTemp,'_Ch' num2str(SpikeChan)];
    str1 = [FileNameTemp,'\_Ch' num2str(SpikeChan),'    ',stimType{k}];
    text(70,0,str1,'fontsize',18);
    axis off;
    % to save the figures
    str3 = [str, '_spatialKernel_',stimType{k}];
    set(gcf,'paperpositionmode','auto');
    
    if Protocol == DIRECTION_TUNING_3D
        ss = [str3, '_T'];
         saveas(gcf,['Z:\LBY\Recording data\Skernel\' ss], 'emf');
    elseif Protocol == ROTATION_TUNING_3D
        ss = [str3, '_R'];
         saveas(gcf,['Z:\LBY\Recording data\Skernel\' ss], 'emf');
    end
    
end

%}