%% import nc data variables

files = dir(['C:\Users\kemter\Documents\Data\Precipitation\JRA_55\' '*.nc']);
F=numel(files);
Prec=single([]);

lon=single(ncread([files(1).folder '\' files(1).name],'g4_lon_2'));
lon(lon>180)=lon(lon>180)-360;
lat=single(ncread([files(1).folder '\' files(1).name],'g4_lat_1'));

lat=repmat(lat',114,1); %latitude for each pixel (this could likely be simplified)
lon=repmat(lon,1,69);   %longitude for each pixel
pos(:,:,1)=lat;   %attach latitude to the end of each time series
pos(:,:,2)=lon;   %attach longitude to the end of each time series
posMat=single(reshape(pos,numel(pos(:,:,1)),size(pos,3)));

for i=1:F
    input=ncread([files(i).folder '\' files(i).name],'TPRAT_GDS4_SFC_ave3h');
    %load nc files
    inMat{i}=single(reshape(input,numel(input(:,:,1)),size(input,3)));
    %transform tensor to matrix
end
Prec=horzcat(inMat{:}); %combine all files to one matrix

PrecDown=reshape(sum(reshape(Prec',4,[]),1),[],size(Prec, 1))'; %downsample to 1/day
clear inMat
clear Prec

PrecData=single([PrecDown posMat]); %attach coordinates to the end of each time series

subset=PrecData(PrecData(:,end-1)>=36 & PrecData(:,end-1)<=71 & PrecData(:,end)>=-10 & PrecData(:,end)<=40,:);
%remove pixels outside of the region of interest

diff=datenum('31.12.2010','dd.mm.yyyy')-datenum('01.01.1958','dd.mm.yyyy');
%length of timeframe
subset_time=subset(:,[1:diff+1 end-1:end]); %create a subset for that timeframe
