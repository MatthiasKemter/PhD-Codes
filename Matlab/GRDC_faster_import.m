%% USA + CA
load('C:\Users\kemter\Documents\Data\GRDC_global.mat');
startdate='25.10.1926';enddate='07.11.2016';
threshold=0.02; %maximum allowed fraction of missing values in each time series
time=datetime(startdate):datetime(enddate);
% Spatial boundaries:
raw(cell2mat(raw(:,3))>57,:)=[];    
raw(cell2mat(raw(:,3))<26,:)=[];
raw(cell2mat(raw(:,4))<-130,:)=[];
raw(cell2mat(raw(:,4))>-60.97,:)=[];

%% Europe
load('C:\Users\kemter\Documents\Data\GRDC_europe.mat');
startdate='25.10.1934';enddate='07.11.2011';
threshold=0.02; %maximum allowed fraction of missing values in each time series
time=datetime(startdate):datetime(enddate);

%%
% ignore stations that don't have data at startdate or enddate
raw(cellfun(@min,raw(:,1))>datetime(startdate),:)=[];
raw(cellfun(@max,raw(:,1))<datetime(enddate),:)=[];

for i=1:size(raw,1)
    raw{i,5}=sum(cell2mat(raw(i,2))==-999)/size(cell2mat(raw(1,2)),1);
    %calculate fraction of missing values
end

raw(cell2mat(raw(:,5))>threshold,:)=[]; %ignore stations with too much
%missing data

for i=1:size(raw,1)
  raw{i,2}(raw{i,2}==-999)=NaN; %turn missing values to NaN
end

for i=1:size(raw,1)
  raw{i,6}=raw{i,2}(raw{i,1}>=datetime(startdate) & raw{i,1}<=datetime(enddate));
  %timeseries between startdate and enddate
end
%% only larger rivers
raw(cellfun(@nanmedian,raw(:,6))<=5,:)=[];

%% Germany

%raw(cell2mat(raw(:,3))>54,:)=[];
%raw(cell2mat(raw(:,3))<47,:)=[];
%raw(cell2mat(raw(:,4))<6,:)=[];
%raw(cell2mat(raw(:,4))>15,:)=[];
%%
%transform timeseries cell to matrix for easier use
discharge=reshape(cell2mat(raw(:,6)),size(raw{1,6},1),size(raw,1));
discharge5210=discharge';
