
clear all
files = glob('C:/Users/kemter/Desktop/time_series/*.dts');

tic
for i=1:numel(files)
  [~, name] = fileparts (files{i});
  [a,b]=textread(["C:/Users/kemter/Desktop/time_series/" name ".dts"], "%s %f");
  c{i,1}=datenum(char(a), 'dd-mm-yyyy');
  c{i,2}=b;
  i
end
toc