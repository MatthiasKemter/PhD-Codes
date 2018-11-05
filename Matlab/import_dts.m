
clear all
files = glob('C:/Users/kemter/Desktop/time_series/*.dts');

tic
for i=1:numel(files)
  [~, name] = fileparts (files{i});
  [a,b]=textread(["C:/Users/kemter/Desktop/time_series/" name ".dts"], "%s %f");
  c{i,1}=datenum(char(a), 'dd-mm-yyyy');
  c{i,2}=b;
  i
end
toc


for i=1:size(c,1)
  c{i,2}(isnan(c{i,2}))=0;
end

for i=1:size(c,1)
  c{i,2}(c{i,2}==-9999)=0;
end

%%
for i=1:size(c,1)
  b{i,1}=c{i,2}(c{i,1}>=710398 & c{i,1}<732871);  %only values between 1945 and 2004
end

x=b(22473==cell2mat(cellfun(@size,b(:),'UniformOutput',false)));  %only stations operating from 1945-2004  
y=reshape(cell2mat(x),22473,133)';

ROI=y;
clear x
clear y

perc95=prctile(ROI,95,2); 
D95=ROI>=perc95;  %calculate binary matrix containing ones for events (95%ile)

N=size(D95)(1);

ES=zeros(N,N,'uint32');

tic
for i=1:N
  
   ES(i,:)=sum(D95(i,:)+D95==2,2);  %check for coinciding events (ones) between each time series
   
end
toc


tic

A=ES; %create Adjecency Matrix

A=A.*(1+diag(-1*uint8(ones(1,N)))); %make A symmetric and substitute zeros for i=j
T=prctile(A(:),95); %define threshold of synchronization as 98 percentile
A=A>=T; %binarize Adjecency Matrix

toc
