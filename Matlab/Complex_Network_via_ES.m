clear all

pkg load netcdf
Temp=ncread("gistemp1200_ERSSTv5.nc","tempanomaly");
ROI=rot90(Temp(1:180,1:90,1400:end)); %sample Lat, Lon and timeframe
clear Temp


tic 
perc95=prctile(ROI,95,3); 
D95=ROI>=perc95;  %calculate binary matrix containing ones for events (95%ile)

x=size(D95)(1);
y=size(D95)(2);
z=size(D95)(3);
N=x*y;

D95M=reshape(D95,N,z);  %reshape 3D data into convinient 2D matrix

clear ROI
clear D95

ES=zeros(N,N,'uint8');


for i=1:N
  
   ES(i,:)=sum(repmat(D95M(i,:),N,1)+D95M==2,2);  %check for coinciding events (ones) between each time series
   
end



A=ES; %create Adjecency Matrix

A=A.*(1+diag(-1*uint8(ones(1,N)))); %make A symmetric and substitute zeros for i=j
T=prctile(A(:),95); %define threshold of synchronization as 95 percentile
A=A>=T; %binarize Adjecency Matrix

toc
