%% import ECA precipitation station data

table=readtable('C:\Users\kemter\Documents\Data\Precipitation\ECA_blend_rr\stations.txt','Format','%u %s %s %s %s %u');

%% transformation of latitude and longitude into decimal format

DLat=zeros(size(table,1),1);    %degree
MLat=zeros(size(table,1),1);    %minute
SLat=zeros(size(table,1),1);    %second
Latstation=zeros(size(table,1),1);  %decimal latitude
DLon=zeros(size(table,1),1);    %degree
MLon=zeros(size(table,1),1);    %minute
SLon=zeros(size(table,1),1);    %second
Lonstation=zeros(size(table,1),1);  %decimal longitude

for i=1:size(table,1)
    DLat(i)=str2num(table.LAT{i}(1:3));
    MLat(i)=str2num(table.LAT{i}(5:6));
    SLat(i)=str2num(table.LAT{i}(8:9));
    DLon(i)=str2num(table.LON{i}(1:4));
    MLon(i)=str2num(table.LON{i}(6:7));
    SLon(i)=str2num(table.LON{i}(9:10));   
end

Latstation=dms2degrees([DLat,MLat,SLat]);
Lonstation=dms2degrees([DLon,MLon,SLon]);  

ECA=[double(table.STAID),Latstation,Lonstation];

%% import precipitation data for each ECA station
files = dir(['C:\Users\kemter\Documents\Data\Precipitation\ECA_blend_rr\RR' '*.txt']);
F=numel(files);

raw=cell(F,7);
tic
for i=1:F
    input=readtable(['C:\Users\kemter\Documents\Data\Precipitation\ECA_blend_rr\' files(i).name]);
    raw{i,1}=input.RR;  %precipitation time series
    raw{i,2}=datenum(num2str(input.DATE(1)),'yyyymmdd'); %date of first measurement
    raw{i,3}=datenum(num2str(input.DATE(end)),'yyyymmdd');  %date of last measurement
    raw{i,4}=ECA(ECA(:,1)==input.STAID(1),2);   %station latitude
    raw{i,5}=ECA(ECA(:,1)==input.STAID(1),3);   %station longitude
end
toc

%% station selection

start=datenum('01.01.1952','DD.MM.YYYY');   %define start date of investigated timeframe
raw(cell2mat(raw(:,2))>start,:)=[]; %remove all stations that start after start date
stop=raw{1,3};  %define end date of investigated timeframe
diff=ceil(stop-start);

for i=1:size(raw,1)
    raw{i,6}=raw{i,1}(end-diff:end-2100);   %precipitation time series for timeframe
    raw{i,7}=sum(cell2mat(raw(i,6))==-9999)/(diff+1);   %fraction of missing values
end

raw(cell2mat(raw(:,7))>0.02,:)=[];  %remove stations with too many missing values (>0.02)
    
%% plot stations

geoshow('landareas.shp', 'FaceColor', [0.9 0.9 0.7])
hold;

xlim([-10 32]); %Europe
ylim([36 72]);  %Europe

scatter(cell2mat(raw(:,5)),cell2mat(raw(:,4)))
