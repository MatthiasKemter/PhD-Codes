
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

Correlation=corr(ROI',ROI');  
  
tic

A=ES; %create Adjecency Matrix

A=A.*(1+diag(-1*uint8(ones(1,N)))); %make A symmetric and substitute zeros for i=j
T=prctile(A(:),95); %define threshold of synchronization as 98 percentile
A=A>=T; %binarize Adjecency Matrix

toc
<<<<<<< HEAD
<<<<<<< HEAD

tic

AC=Correlation; %create Adjecency Matrix

AC=AC.*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(AC(:),95); %define threshold of synchronization as 98 percentile
AC=AC>=T; %binarize Adjecency Matrix

toc

ESync=zeros(N,N);

ROIES=ROI+0.1;

tic
for i=1:N
    for j=1:N
        ESync(i,j)=Event_Sync(ROIES(i,:),ROIES(j,:));
    end
end
toc

AES=ESync; %create Adjecency Matrix

AES=AES.*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(AES(:),95); %define threshold of synchronization as 98 percentile
AES=AES>=T; %binarize Adjecency Matrix

ESynchro=zeros(N,N);


ROI10=ROI(:,end-3650:end);
tx=1:size(ROI,2);
ty=1:size(ROI,2);

parpool(4)
tic
for i=1:N
    parfor j=i:N
        [ESynchro(i,j),~]=eventsynchro(tx,ROI(i,:),ty,ROI(j,:),0,0.95); %eventsynchro was modified in lines 46+47 to only include high events
    end
end
toc

AESy=ESynchro; %create Adjecency Matrix

AESy=(AESy+AESy').*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(AESy(:),95); %define threshold of synchronization as 98 percentile
AESy=AESy>=T; %binarize Adjecency Matrix
%%

G=graph(A);
Deg=degree(G);

figure(1)
h = plot(G);
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;

[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
GC = subgraph(G, idx);
figure(3)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;

%%

G=graph(AC);
Deg=degree(G);

figure(4)
h = plot(G);
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;

[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
GC = subgraph(G, idx);
figure(2)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;

%%

G=graph(AES);
Deg=degree(G);

figure(5)
h = plot(G);
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;

[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
GC = subgraph(G, idx);
figure(6)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;

%%

G=graph(AESy);
Deg=degree(G);

figure(7)
h = plot(G);
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;

[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
GC = subgraph(G, idx);
figure(8)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;
=======
>>>>>>> parent of 8667acc... Station coordinates and names are associated to time series, network plot based on coordinates added
=======
>>>>>>> parent of 8667acc... Station coordinates and names are associated to time series, network plot based on coordinates added
