function ChangeDataPath(h_fileName)

% PathHandle = findobj(gcbf, 'Tag', 'Filename');
fileNametemp = get((h_fileName),'string');
% set(h_pathName,'string',['Z:\Data\MOOG\',monkeys{get(hMonkey,'value')},'\raw\LA\',fileNametemp,'\']);
set(h_pathName,'string',['Z:\Data\MOOG\\raw\LA\',fileNametemp,'\']);
end