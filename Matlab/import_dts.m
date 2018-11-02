[a,b]=textread("C:/Users/kemter/Desktop/time_series/ACHLEITEN_10094006.dts", "%s %f");
time = datenum(char(a), 'dd-mm-yyyy');

clear all
files = glob('C:/Users/kemter/Desktop/time_series/*.dts');
%b=zeros(62500,1);
%Q=zeros(62500,numel(files));
%time=zeros(62500,numel(files));
for i=1:numel(files)
  [~, name] = fileparts (files{i});
  [a,b]=textread(["C:/Users/kemter/Desktop/time_series/" name ".dts"], "%s %f");
  c{i}=datenum(char(a), 'dd-mm-yyyy');
  c{i+1}=b;
  %time(i,:) = datenum(char(a), 'dd-mm-yyyy');
  %Q(i,:) = b;
  %plot(time(i,:),Q(i,:))
end
