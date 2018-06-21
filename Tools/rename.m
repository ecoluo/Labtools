

Dir=dir('…\*.jpg');%某个路径下所有的jpg
for i =1:length(Dir)    
    eval(['!rename ','...\',Dir(i).name,' ',int2str(i),'.jpg'])
    %这边的空格键不能少，将路径下的某文件替换成你想要的名字
end
