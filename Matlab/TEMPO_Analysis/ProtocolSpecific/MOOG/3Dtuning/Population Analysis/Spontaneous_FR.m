% Analysis for spontenous spike rate
% LBY 20170410
% LBY 20171123

clear all;
load('Z:\Data\TEMPO\BATCH\QQ_3DTuning\PSTH_OriData.mat');

set(0,'defaultaxesfontsize',50);
figure(101);
set(gcf,'pos',[60 200 1500 1000]);
clf;

h1 = axes('unit','pixels','pos',[120 120 500 400]);hold on;
h2 = axes('unit','pixels','pos',[800 120 500 400]);hold on;

sponFR = cell2mat(sponFR);

sigNum(2) = 0;
nsigNum(2) = 0;

for cell_inx = 1:length(CellName)
    for k = 1: length(StimType{1,cell_inx}(:))
        if sigTrueCell(k,cell_inx) == 1
            if ANOVA{1,cell_inx}(1,k)<=0.05
                sigNum(k) = sigNum(k) +1;
                spon_sig(k,sigNum(k)) = sponFR(1,cell_inx);
            else
                nsigNum(k) = nsigNum(k) +1;
                spon_nsig(k,nsigNum(k)) = sponFR(1,cell_inx);
            end
            
        end
    end
end

spon_sig(find(spon_sig == 0)) = nan;
spon_nsig(find(spon_nsig == 0)) = nan;

meanSponFR(1) = nanmean(spon_sig(1,:))
meanSponFR(2) = nanmean(spon_sig(2,:))

maxvalue(1) = max(max([spon_sig(1,:) spon_nsig(1,:)]));
maxvalue(2) = max(max([spon_sig(2,:) spon_nsig(2,:)]));



xSpon(1,:) = linspace(0,maxvalue(1),10);
xSpon(2,:) = linspace(0,maxvalue(2),10);


[nelements_sig{1}, ncenters_sig{1}] = hist(spon_sig(1,:),xSpon(1,:));
[nelements_nsig{1}, ncenters_nsigR{1}] = hist([spon_sig(1,:) spon_nsig(1,:)],xSpon(1,:));
bar(h1,ncenters_nsigR{1}, nelements_nsig{1}, 0.9,'w','edgecolor','k');hold on;
bar(h1,ncenters_sig{1}, nelements_sig{1}, 0.9,'k','edgecolor','k');
set(h1,'linewidth',4,'xlim',[0-5 maxvalue(1)+5],'ylim',[0 max(nelements_nsig{1})],'xtick',[0 20 40],'ytick',[0 max(nelements_nsig{1})*0.5  max(nelements_nsig{1})],'xticklabel',{'0','20','40'},'yticklabel',{'0', max(nelements_nsig{1})*0.5,max(nelements_nsig{1})});


[nelements_sig{2}, ncenters_sig{2}] = hist(spon_sig(2,:),xSpon(2,:));
[nelements_nsig{2}, ncenters_nsigR{2}] = hist([spon_sig(2,:) spon_nsig(2,:)],xSpon(2,:));
bar(h2,ncenters_nsigR{2}, nelements_nsig{2}, 0.9,'w','edgecolor','k');hold on;
bar(h2,ncenters_sig{2}, nelements_sig{2}, 0.9,'k','edgecolor','k');
set(h2,'linewidth',4,'xlim',[0-5 maxvalue(2)+5],'ylim',[0 max(nelements_nsig{2})],'xtick',[0 20 40],'ytick',[0 max(nelements_nsig{2})*0.5  max(nelements_nsig{2})],'xticklabel',{'0','20','40'},'yticklabel',{'0', max(nelements_nsig{2})*0.5,max(nelements_nsig{2})});

saveas(gcf,['Z:\LBY\Recording data\Qiaoqiao\sponFR_distribution_R'], 'emf');



