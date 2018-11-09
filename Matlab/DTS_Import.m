function [Data,c] = DTS_Import(pathdts,pathshape,startdate,enddate)
%DTS_IMPORT imports dts data, adds spatial information and generalizes
%timeframe
%
%   

gauges=shaperead(pathshape);

files = dir([pathdts '*.dts']);
F=numel(files);

for i=1:F;
    filename = dir([pathdts gauges(i).name '*.dts']);
    a=textscan(fopen([pathdts filename(1).name]), "%s %f");
    c{i,1}=datenum(a{:,1}, 'dd-mm-yyyy');
    c{i,2}=a{:,2};
    c{i,3}=gauges(i).name;
    c{i,4}=gauges(i).X;
    c{i,5}=gauges(i).Y;
    fclose('all');
end

for i=1:size(c,1)
  c{i,2}(isnan(c{i,2}))=0;
end

for i=1:size(c,1)
  c{i,2}(c{i,2}==-9999)=0;
end

start=datenum(startdate,'dd.mm.yyyy');
stop=datenum(enddate,'dd.mm.yyyy');

for i=1:size(c,1)
  c{i,6}=c{i,2}(c{i,1}>=start & c{i,1}<=stop);  %only values between startdate and enddate
end

for i=1:size(c,1)
  c{i,7}=(start:stop)';  %timesteps
end

q=cell2mat(cellfun(@size,c(:,6),'UniformOutput',false));
c=c(q(:,1)==stop-start+1,:); %only stations with records between startdate and enddate

Data=reshape(cell2mat(c(:,6)),size(c{1,6},1),size(c,1));
Data=Data';

end