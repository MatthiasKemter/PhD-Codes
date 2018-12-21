function [discharge,raw] = GRDC_import(pathgrdc,startdate,enddate,varargin)
%GRDC_IMPORT imports GRDC txt data with spatial information and generalized
%timeframe
%   Import all river gauge station data in the specified folder (pathgrdc).
%   Only stations with a record in a given timeframe (startdate to enddate)
%   are considered. Stations for which the fraction of missing data exceeds
%   the threshold (varargin{1}, standard value 2%) are removed. Only
%   stations within European countries (-Iceland and Greenland) are
%   considered unless otherwise specified (varargin{2}). Country codes
%   follow the ISO-3166 alpha-2 norm. Only stations within a bounding box
%   (35N 74N; 20W 65E) around europe are considered. The function returns
%   the discharge data as a #stations x #days matrix (discharge) and a
%   cell array containing additional information like complete time series,
%   station coordinates and fraction of missing values.
%
%   EXAMPLE:
%       [discharge,raw]=GRDC_import('C:\Users\kemter\Documents\Data\Discharge\GRDC_DAY\','01.01.1958','31.12.2010',0.02,'DE');

files = dir([pathgrdc '*.txt']); %'C:\Users\kemter\Documents\Data\GRDC_DAY\'
F=numel(files);

threshold=0.02; %maximum allowed fraction of missing values in the time series

if nargin>=4
    threshold=varargin{1};
end

ROI='AL AD BY BE BA BG DK DE EE FO FI FR GI GR IE IT XK HR LV LI LT LU MT MK MD MC ME NL NO AT PL PT RO RU SM SE CH RS SK SI ES CZ UA HU GB';
    %ISO-3166 alpha-2 country codes of considered countries

if nargin==5
    ROI=varargin{2};
end

j=1;

for i=1:F
    fid=fopen([files(i).folder '\' files(i).name]);
    country=textscan(fid, '%[^\n]', 1, 'HeaderLines', 11);  %find station country
    country=cell2mat(country{:});
    country=country(end-1:end);
    fclose(fid);
    fid=fopen([files(i).folder '\' files(i).name]);
    Latcell=textscan(fid,'%s %s %s %s %s %s %s %s %s %f %*[^\n]', 1, 'HeaderLines', 12,'Delimiter',' ');
    %find station latitude
    Lat=Latcell{10};
    fclose(fid);
    fid=fopen([files(i).folder '\' files(i).name]);
    Loncell=textscan(fid,'%s %s %s %s %s %s %s %s %f %*[^\n]', 1, 'HeaderLines', 13,'Delimiter',' ');
    %find station longitude
    Lon=Loncell{9};
    fclose(fid);
    warning off;
    %if contains(ROI,country)    %only consider stations in countries of interest
        data=readtable([files(i).folder '\' files(i).name],'HeaderLines',35);
        raw{j,1}=data{:,1}; %measurement time
        raw{j,2}=data{:,3}; %measured discharge
        raw{j,3}=Lat;   %station latitude
        raw{j,4}=Lon;   %station longitude
        raw{j,7}=country;
        j=j+1;
    %end
    warning on;
end

% ignore stations outside the bounding box
raw(cell2mat(raw(:,3))>74,:)=[];
raw(cell2mat(raw(:,3))<35,:)=[];
raw(cell2mat(raw(:,4))<-20,:)=[];
raw(cell2mat(raw(:,4))>65,:)=[];

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

%transform timeseries cell to matrix for easier use
%discharge=reshape(cell2mat(raw(:,6)),size(raw{1,6},1),size(raw,1));
%discharge=discharge';
discharge=1;
end