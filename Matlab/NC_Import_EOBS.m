input=single(ncread(['C:\Users\kemter\Documents\Data\E_OBS\rr_0.50deg_reg_v17.0.nc'],'rr'));
lon=single(ncread(['C:\Users\kemter\Documents\Data\E_OBS\rr_0.50deg_reg_v17.0.nc'],'longitude'));
lat=single(ncread(['C:\Users\kemter\Documents\Data\E_OBS\rr_0.50deg_reg_v17.0.nc'],'latitude'));
time=datetime(712223+(1:size(input,3)),'ConvertFrom','datenum');

lat=repmat(lat',232,1);
lon=repmat(lon,1,101);

input(:,:,end+1)=lat;
input(:,:,end+1)=lon;
N=size(input,1)*size(input,2);
PrecData=reshape(input,N,[]);

PrecData(nansum(input(:,:,1:end-2),3)<=0,:) = [];

subset=PrecData(PrecData(:,end-1)>=36 & PrecData(:,end-1)<=72 & PrecData(:,end)>=-11 & PrecData(:,end)<=40,:);

