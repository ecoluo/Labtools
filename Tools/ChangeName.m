file = dir('*.mat')
len = length(file)
for i = 1 : len
   oldname = file(i).name;
   temp = strfind(oldname,'.htb');
   newname = [oldname(1:temp-1),oldname(temp+4:end)];
   eval(['!rename' 32 oldname 32 newname]);
end