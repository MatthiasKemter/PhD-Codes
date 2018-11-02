%% Import of netcdf-type data, detection of events in the 95%ile, event coincidence based generation of links and calculation of an adjacency matrix


pkg load netcdf
Temp=ncread("C:/Users/kemter/Desktop/gistemp1200_ERSSTv5.nc","tempanomaly");
ROI=rot90(Temp(1:180,20:70,1200:end)); %sample Lat, Lon and timeframe
clear Temp


tic 
perc95=prctile(ROI,95,3); 
D95=ROI>=perc95;  %calculate binary matrix containing ones for events (95%ile)
perc5=prctile(ROI,5,3); 
D5=ROI<=perc5;  %calculate binary matrix containing ones for negative events (lower 95%ile)

x=size(D95)(1);
y=size(D95)(2);
z=size(D95)(3);
N=x*y;

D95M=reshape(D95,N,z);  %reshape 3D data into convinient 2D matrix
D5M=reshape(D5,N,z);  %reshape 3D data into convinient 2D matrix
DM=D95M+D5M;


ES=zeros(N,N,'uint8');
toc
tic

for i=1:N
  
   ES(i,:)=sum(abs(D95M(i,:)+D95M)==2,2);  %check for coinciding events (ones) between each time series
   
end

toc

tic

A=ES; %create Adjecency Matrix

A=A.*(1+diag(-1*uint8(ones(1,N)))); %make A symmetric and substitute zeros for i=j
T=prctile(A(:),98); %define threshold of synchronization as 98 percentile
A=A>=T; %binarize Adjecency Matrix

toc

%%
Deg=degrees(A);
imagesc(reshape(mean(ROI,3),x,y))
figure
imagesc(reshape(Deg,x,y))