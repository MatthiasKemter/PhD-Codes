%% import nc data variables

input=single(ncread(['C:\Users\kemter\Documents\Data\Precipitation\E_OBS\rr_0.50deg_reg_v17.0.nc'],'rr'));
%precipitation
lon=single(ncread(['C:\Users\kemter\Documents\Data\Precipitation\E_OBS\rr_0.50deg_reg_v17.0.nc'],'longitude'));
lat=single(ncread(['C:\Users\kemter\Documents\Data\Precipitation\E_OBS\rr_0.50deg_reg_v17.0.nc'],'latitude'));
time=datetime(712223+(1:size(input,3)),'ConvertFrom','datenum');

lat=repmat(lat',232,1);
lon=repmat(lon,1,101);

input(:,:,end+1)=lat;   %attach latitude to the end of each time series
input(:,:,end+1)=lon;   %attach longitude to the end of each time series

%% transform data

N=size(input,1)*size(input,2);
PrecData=reshape(input,N,[]);   %reshape tensor to matrix

PrecData(nansum(input(:,:,1:end-2),3)<=0,:) = [];   %remove pixels that only contain NaNs

subset=PrecData(PrecData(:,end-1)>=36 & PrecData(:,end-1)<=72 & PrecData(:,end)>=-11 & PrecData(:,end)<=40,:);
%remove pixels outside of the region of interest
%subset=PrecData(PrecData(:,end-1)>=42 & PrecData(:,end-1)<=72 & PrecData(:,end)>=-5 & PrecData(:,end)<=32,:);
start='01.01.1952'; %define timeframe of interest
stop='31.12.2011';  %define timeframe of interest
diff=datenum(stop,'dd.mm.yyyy')-datenum(start,'dd.mm.yyyy');    %length of timeframe
first=1+datenum(start,'dd.mm.yyyy')-datenum('01.01.1950','dd.mm.yyyy');
%index of first measurement day in the timeframe

subset_time=subset(:,[first:first+diff end-1:end]); %create a subset for that timeframe