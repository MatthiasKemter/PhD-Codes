function [Data,c] = DTS_Import(pathdts,pathshape,startdate,enddate)
%DTS_IMPORT imports dts data, adds spatial information and generalizes timeframe
%   Dts data located in the folder (pathdts) is imported if  there is a
%   station with a fitting name in the shapefile (pathshape). Time (1),
%   Discharge (2), station name (3), latitude (4) and longitude (5) are 
%   written to a cell array (c). Stations that do not have a record
%   reaching from the beginning (startdate) to the end (enddate) of the
%   investigation period are removed from the record. The discharge
%   timeseries for the investigation period is returned as a simple matrix
%   (Data) with a row for every station.
%
%   EXAMPLE:
%       [discharge,c]=DTS_Import('C:\Users\kemter\Documents\Data\Discharge\Kai_Germany\time_series\','C:\Users\kemter\Documents\Data\Shapes\gauges_WGS84.shp','01.01.1958','01.01.2008');

gauges=shaperead(pathshape);    %shapefile with station data

files = dir([pathdts '*.dts']); %station time series data
F=numel(files);
c=cell(F,7);

for i=1:F
    filename = dir([pathdts gauges(i).name '*.dts']);
    a=textscan(fopen([pathdts filename(1).name]), "%s %f");
    c{i,1}=datenum(a{:,1}, 'dd-mm-yyyy');   %time
    c{i,2}=a{:,2};                          %discharge
    c{i,3}=gauges(i).name;                  %station name
    c{i,4}=gauges(i).X;                     %latitude
    c{i,5}=gauges(i).Y;                     %longitude
    fclose('all');
end

for i=1:size(c,1)
  c{i,2}(isnan(c{i,2}))=0;  %turn NaN to zero
end

for i=1:size(c,1)
  c{i,2}(c{i,2}==-9999)=0;  %turn missing values to zero
end

start=datenum(startdate,'dd.mm.yyyy');
stop=datenum(enddate,'dd.mm.yyyy');

for i=1:size(c,1)
  c{i,6}=c{i,2}(c{i,1}>=start & c{i,1}<=stop);
  %only values between startdate and enddate
end

for i=1:size(c,1)
  c{i,7}=(start:stop)';  %timesteps for time series subset
end

q=cell2mat(cellfun(@size,c(:,6),'UniformOutput',false));
c=c(q(:,1)==stop-start+1,:); %only stations with records between startdate and enddate

Data=reshape(cell2mat(c(:,6)),size(c{1,6},1),size(c,1));    %transform cell to matrix
Data=Data';

end