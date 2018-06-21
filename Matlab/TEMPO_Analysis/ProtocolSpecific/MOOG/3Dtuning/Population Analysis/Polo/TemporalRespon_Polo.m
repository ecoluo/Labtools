% Temporal response
% LBY 20171123

TotalNoTranVest = nansum(logical(cat(1,Polo_3DTuning_T.stimType) == 1));
TotalNoTranVis = nansum(logical(cat(1,Polo_3DTuning_T.stimType) == 2));
ResponTranVest = nansum(cat(1,T.vestiResponSig));
ResponTranVis = nansum(cat(1,T.visResponSig));

TotalNoRotVest = nansum(logical(cat(1,Polo_3DTuning_R.stimType) == 1));
TotalNoRotVis = nansum(logical(cat(1,Polo_3DTuning_R.stimType) == 2));
ResponRotVest = nansum(cat(1,R.vestiResponSig));
ResponRotVis = nansum(cat(1,R.visResponSig));



disp(' ');
disp([Monkey,':']);
disp('Total cells for Translation: ');
disp(['[ vestibular: ',num2str(TotalNoTranVest),' ]   [  visual: ',num2str(TotalNoTranVis),' ]']);
disp('Temporal Tuning - Translation');
disp(['[ vestibular: ',num2str(TResponSigVestiNo),'(',num2str(TResponSigVestiNo/TotalNoTranVest),') ]   [  visual: ',num2str(TResponSigVisNo),'(',num2str(TResponSigVisNo/TotalNoTranVis),')  ]']);
disp('Spatial Tuning - Translation');
disp(['[ vestibular: ',num2str(TANOVASigVestiNo),'(',num2str(TANOVASigVestiNo/ResponTranVest),') ]   [  visual: ',num2str(TANOVASigVisNo),'(',num2str(TANOVASigVisNo/ResponTranVis),')  ]']);
disp(' ');
disp('Total cells for Rotation: ');
disp(['[ vestibular: ',num2str(TotalNoRotVest),' ]   [  visual: ',num2str(TotalNoRotVis),' ]']);
disp('Temporal Tuning - Rotation');
disp(['[ vestibular: ',num2str(RResponSigVestiNo),'(',num2str(RResponSigVestiNo/TotalNoRotVest),') ]   [  visual: ',num2str(RResponSigVisNo),'(',num2str(RResponSigVisNo/TotalNoRotVis),')  ]']);
disp('Spatial Tuning - Rotation');
disp(['[ vestibular: ',num2str(RANOVASigVestiNo),'(',num2str(RANOVASigVestiNo/ResponRotVest),') ]   [  visual: ',num2str(RANOVASigVisNo),'(',num2str(RANOVASigVisNo/ResponRotVis),')  ]']);


figure(1001);set(gcf,'pos',[60 70 1700 400]);clf;
% barh([RANOVASigVisNo,ResponRotVis-RANOVASigVisNo,TotalNoRotVis-ResponRotVis-RANOVASigVisNo;...
%     RANOVASigVestiNo,ResponRotVest-RANOVASigVestiNo,TotalNoRotVest-ResponRotVest-RANOVASigVestiNo;...
%     TANOVASigVisNo,ResponTranVis-TANOVASigVisNo,TotalNoTranVis-ResponTranVis-TANOVASigVisNo;...
%     TANOVASigVestiNo,ResponTranVest-TANOVASigVestiNo,TotalNoTranVest-ResponTranVest-TANOVASigVestiNo],'stacked');

h = barh([RANOVASigVisNo,ResponRotVis,TotalNoRotVis;...
    RANOVASigVestiNo,ResponRotVest,TotalNoRotVest;...
    TANOVASigVisNo,ResponTranVis,TotalNoTranVis;...
    TANOVASigVestiNo,ResponTranVest,TotalNoTranVest],'grouped');
set(h,'edgecolor','w')
set(gca,'yticklabel',{'Rotation Visual','Vestibular','Translation Visual','Vestibular'});
hl = legend('Direction tuning cell number','Responded cell number','Total cell number','location','southeast');
set(hl,'Box','off');



