function Data = GRDC_import(pathgrdc,startyear,endyear,varargin)
%GRDC_IMPORT imports GRDC txt data with spatial information and generalized
%timeframe
%

files = dir([pathgrdc '*.txt']); %'C:\Users\kemter\Documents\Data\GRDC_DAY\'
F=numel(files);

threshold=0.02;

if nargin>=4
    threshold=varargin{1};  %threshold for fraction of missing data
end

ROI='AL AD BY BE BA BG DK DE EE FO FI FR GI GR IE IT XK HR LV LI LT LU MT MK MD MC ME NL NO AT PL PT RO RU SM SE CH RS SK SI ES CZ UA HU GB';

if nargin==5
    ROI=varargin{2};
end

j=1;

for i=1:F
    fid=fopen([files(i).folder '\' files(i).name]);
    country=textscan(fid, '%[^\n]', 1, 'HeaderLines', 11);
    country=cell2mat(country{:});
    country=country(end-1:end);
    fclose(fid);
    fid=fopen([files(i).folder '\' files(i).name]);
    Latcell=textscan(fid,'%s %s %s %s %s %s %s %s %s %f %*[^\n]', 1, 'HeaderLines', 12,'Delimiter',' ');
    Lat=Latcell{10};
    fclose(fid);
    fid=fopen([files(i).folder '\' files(i).name]);
    Loncell=textscan(fid,'%s %s %s %s %s %s %s %s %f %*[^\n]', 1, 'HeaderLines', 13,'Delimiter',' ');
    Lon=Loncell{9};
    fclose(fid);
    warning off;
    if contains(ROI,country)
        data=readtable([files(i).folder '\' files(i).name],'HeaderLines',35);
        Data{j,1}=data{:,1};
        Data{j,2}=data{:,3};
        Data{j,3}=Lat;
        Data{j,4}=Lon;
        j=j+1;
    end
    warning on;
end

%%
Data(cell2mat(Data(:,3))>74,:)=[];
Data(cell2mat(Data(:,3))<35,:)=[];
Data(cell2mat(Data(:,4))<-20,:)=[];
Data(cell2mat(Data(:,4))>65,:)=[];

for i=1:size(Data,1)
    Data{i,5}=year(min(Data{i,1}));
    Data{i,6}=year(max(Data{i,1}));
end

Data(cell2mat(Data(:,5))>startyear,:)=[];
Data(cell2mat(Data(:,6))<endyear,:)=[];
%% delete stations with too much missing data and set missing data to NaN

for i=1:size(Data,1)
    Data{i,7}=sum(cell2mat(Data(i,2))==-999)/size(cell2mat(Data(1,2)),1);
end

Data(cell2mat(Data(:,7))>threshold,:)=[];

for i=1:size(Data,1)
  Data{i,2}(Data{i,2}==-999)=NaN;
end

end