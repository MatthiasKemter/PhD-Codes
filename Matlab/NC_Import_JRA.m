files = dir(['C:\Users\kemter\Documents\Data\Precipitation\JRA_55\' '*.nc']);
F=numel(files);
Prec=single([]);

lon=single(ncread([files(1).folder '\' files(1).name],'g4_lon_2'));
lon(lon>180)=lon(lon>180)-360;
lat=single(ncread([files(1).folder '\' files(1).name],'g4_lat_1'));

lat=repmat(lat',114,1);
lon=repmat(lon,1,69);
pos(:,:,1)=lat;
pos(:,:,2)=lon;
posMat=single(reshape(pos,numel(pos(:,:,1)),size(pos,3)));

for i=1:F
    input=ncread([files(i).folder '\' files(i).name],'TPRAT_GDS4_SFC_ave3h');
    inMat{i}=single(reshape(input,numel(input(:,:,1)),size(input,3)));
end
Prec=horzcat(inMat{:});

PrecDown=reshape(sum(reshape(Prec',4,[]),1),[],size(Prec, 1))'; %downsample to 1/day
clear inMat
clear Prec

PrecData=single([PrecDown posMat]);

subset=PrecData(PrecData(:,end-1)>=46 & PrecData(:,end-1)<=56 & PrecData(:,end)>=5 & PrecData(:,end)<=17,:);

diff=datenum('31.12.2010','dd.mm.yyyy')-datenum('01.01.1958','dd.mm.yyyy');
subset_time=subset(:,[1:diff+1 end-1:end]);
