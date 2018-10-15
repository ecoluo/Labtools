




function PopAnalysis_choose_model(Mon_inx,Model_inx,FnameCode)

Monkey{5} = 'Polo';
Monkey{6} = 'QQ';
Model = {'Sync model','Out-sync model','noModel'};
% Protocol = {'','',''};
% % Protocol: 1->translation, 2-> rotation, 3->dark T, 4->dark R
% % Model_inx: 1-> Sync model 2-> Out-sync model 3-> no model

% models = {'VO','AO','VA','VJ','AJ','VAJ','PVAJ'};
% models = {'VO','AO','VA','VJ','AJ','VAJ'};
models = {'VO','AO','VA','VJ','AJ','VP','AP','VAP','VAJ','PVAJ'};
% models = {'VO','AO','VA','VAJ'};
% models = {'VA','VAJ'};

% Popul_load_data(Monkey{Mon_inx},FnameCode,1,Model{Model_inx});
% Popul_load_data(Monkey{Mon_inx},FnameCode,2,Model{Model_inx});

% Popul_analysis(Monkey{Mon_inx},2,Model{Model_inx});
PackData_model(Monkey{Mon_inx},Model{Model_inx},models);
Popul_Analysis_3Dmodel(Monkey{Mon_inx},Model{Model_inx},models);

end