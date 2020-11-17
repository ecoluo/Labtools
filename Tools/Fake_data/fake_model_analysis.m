clear all;
cd('Z:\Labtools\Tools\Fake_data');
load('fake_raw_3D_out-sync_model.mat');
mu = 0.75;
for ii = 1:length(PSTH3Dmodel)
    try
        % 3D model
        model_PSTH_VA(ii,:,:,:) = PSTH3Dmodel{ii}.modelFitraw(ii).respon_VA;
        model_PSTH_PVAJ(ii,:,:,:) = PSTH3Dmodel{ii}.modelFitraw(ii).respon_PVAJ;
        r2_VA(ii) = PSTH3Dmodel{ii}.RSquared_VA;
        r2_PVAJ(ii) = PSTH3Dmodel{ii}.RSquared_PVAJ;
        wV_VA(ii) = PSTH3Dmodel{ii}.modelFitPara_VA(12);
        wA_VA(ii) = 1-PSTH3Dmodel{ii}.modelFitPara_VA(12);
        wV_PVAJ(ii) = (1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(21))*(1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(20));
        wP_PVAJ(ii) = (1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(22))*(1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(21))*PSTH3Dmodel{ii}.modelFitPara_PVAJ(20);
        wA_PVAJ(ii) = (1-PSTH3Dmodel{ii}.modelFitPara_PVAJ(22))*PSTH3Dmodel{ii}.modelFitPara_PVAJ(21);
        wJ_PVAJ(ii) = PSTH3Dmodel{ii}.modelFitPara_PVAJ(22);
        delayV_VA(ii) = PSTH3Dmodel{ii}.modelFitPara_VA(13);
        delayA_VA(ii) = PSTH3Dmodel{ii}.modelFitPara_VA(3) - mu;
        delayV_PVAJ(ii) = PSTH3Dmodel{ii}.modelFitPara_PVAJ(23);
        delayP_PVAJ(ii) = PSTH3Dmodel{ii}.modelFitPara_PVAJ(25);
        delayA_PVAJ(ii) = PSTH3Dmodel{ii}.modelFitPara_PVAJ(3) - mu;
        delayJ_PVAJ(ii) = PSTH3Dmodel{ii}.modelFitPara_PVAJ(24);
        
        % raw
        raw_PSTH(ii,:,:,:) = raw(ii).respon;
        
    catch
        keyboard;
    end
    
    [r,p] = corrcoef(raw_PSTH(ii,:),model_PSTH_VA(ii,:));
    r_VA(ii) = r(1,2);p_VA(ii) = p(1,2);
    
    [r,p] = corrcoef(raw_PSTH(ii,:),model_PSTH_PVAJ(ii,:));
    r_PVAJ(ii) = r(1,2);p_PVAJ(ii) = p(1,2);
    
    
    
end

raw_wV = cell2mat({raw.wV});
raw_wA = cell2mat({raw.wA});
raw_wJ = cell2mat({raw.wJ});
raw_wP = cell2mat({raw.wP});

[r,p] = corrcoef(raw_wV,wV_VA);
r_wV_VA = r(1,2);p_wV_VA = p(1,2);

[r,p] = corrcoef(raw_wV,wV_PVAJ);
r_wV_PVAJ = r(1,2);p_wV_PVAJ = p(1,2);

[r,p] = corrcoef(raw_wA,wA_VA);
r_wA_VA = r(1,2);p_wA_VA = p(1,2);

[r,p] = corrcoef(raw_wA,wA_PVAJ);
r_wA_PVAJ = r(1,2);p_wA_PVAJ = p(1,2);

[r,p] = corrcoef(raw_wJ,wJ_PVAJ);
r_wJ_PVAJ = r(1,2);p_wJ_PVAJ = p(1,2);

[r,p] = corrcoef(raw_wP,wP_PVAJ);
r_wP_PVAJ = r(1,2);p_wP_PVAJ = p(1,2);


raw_delayV = cell2mat({raw.delayV});
raw_delayA = cell2mat({raw.delayA});
raw_delayJ = cell2mat({raw.delayJ});
raw_delayP = cell2mat({raw.delayP});



[r,p] = corrcoef(raw_delayV,delayV_VA);
r_delayV_VA = r(1,2);p_delayV_VA = p(1,2);

[r,p] = corrcoef(raw_delayV,delayV_PVAJ);
r_delayV_PVAJ = r(1,2);p_delayV_PVAJ = p(1,2);

[r,p] = corrcoef(raw_delayA,delayA_VA);
r_delayA_VA = r(1,2);p_delayA_VA = p(1,2);

[r,p] = corrcoef(raw_delayA,delayA_PVAJ);
r_delayA_PVAJ = r(1,2);p_delayA_PVAJ = p(1,2);

[r,p] = corrcoef(raw_delayJ,delayJ_PVAJ);
r_delayJ_PVAJ = r(1,2);p_delayJ_PVAJ = p(1,2);

[r,p] = corrcoef(raw_delayP,delayP_PVAJ);
r_delayP_PVAJ = r(1,2);p_delayP_PVAJ = p(1,2);


% save all data
save('fake_3Dmodel_analysis.mat');
%% figures

% PSTH
figure;
hist(r_VA);
% hist(r_VA(p_VA<0.05));
title('PSTH_VA');

figure;
hist(r_PVAJ);
% hist(r_PVAJ(p_PVAJ<0.05));
title('PSTH_PVAJ');

% weight

%{
figure;
subplot(1,4,1);
hist(r_wV_VA);
% hist(r_wV_VA(p_VA<0.05));
title('V');

subplot(1,4,2);
hist(r_wA_VA);
% hist(r_wA_VA(p_VA<0.05));
title('A');

suptitle('weight VA');

figure;
subplot(1,4,1);
hist(r_wV_PVAJ);
% hist(r_wV_PVAJ(p_PVAJ<0.05));
title('V');

subplot(1,4,2);
hist(r_wA_PVAJ);
% hist(r_wA_PVAJ(p_PVAJ<0.05));
title('A');

subplot(1,4,3);
hist(r_wJ_PVAJ);
% hist(r_wJ_PVAJ(p_PVAJ<0.05));
title('J');

subplot(1,4,4);
hist(r_wP_PVAJ);
% hist(r_wP_PVAJ(p_PVAJ<0.05));
title('P');

suptitle('weight PVAJ');
%}

% %{
figure;
subplot(1,4,1);
plot(wV_PVAJ,raw_wV,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('V');

subplot(1,4,2);
plot(wA_PVAJ,raw_wA,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('A');

subplot(1,4,3);
plot(wJ_PVAJ,raw_wJ,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('J');

subplot(1,4,4);
plot(wP_PVAJ,raw_wP,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('P');

suptitle('weight PVAJ');
%}

% delay

%{
figure;
subplot(1,4,1);
hist(r_delayV_VA);
% hist(r_delayV_VA(p_VA<0.05));
title('V');

subplot(1,4,2);
hist(r_delayA_VA);
% hist(r_delayA_VA(p_VA<0.05));
title('A');

suptitle('delay VA');

figure;
subplot(1,4,1);
hist(r_delayV_PVAJ);
% hist(r_delayV_PVAJ(p_PVAJ<0.05));
title('V');

subplot(1,4,2);
hist(r_delayA_PVAJ);
% hist(r_delayA_PVAJ(p_PVAJ<0.05));
title('A');

subplot(1,4,3);
hist(r_delayJ_PVAJ);
% hist(r_delayJ_PVAJ(p_PVAJ<0.05));
title('J');

subplot(1,4,4);
hist(r_delayP_PVAJ);
% hist(r_delayP_PVAJ(p_PVAJ<0.05));
title('P');

suptitle('delay PVAJ');
%}

% %{
figure;
subplot(1,4,1);
plot(delayV_PVAJ,raw_delayV,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('V');

subplot(1,4,2);
plot(delayA_PVAJ,raw_delayA,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('A');

subplot(1,4,3);
plot(delayJ_PVAJ,raw_delayJ,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('J');

subplot(1,4,4);
plot(delayP_PVAJ,raw_delayP,'ko')
axis square;
set(gca,'xlim',[0 1],'ylim',[0 1]);
title('P');
suptitle('delay PVAJ');
%}
