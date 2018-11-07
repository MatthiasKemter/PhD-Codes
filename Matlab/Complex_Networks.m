
clear all
files = glob('C:/Users/kemter/Desktop/time_series/*.dts');

tic
for i=1:numel(files)
  [~, name] = fileparts (files{i});
  [a,b]=importdata(["C:/Users/kemter/Desktop/time_series/" name ".dts"], "%s %f");
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
  c{i,6}=c{i,2}(c{i,1}>=710398 & c{i,1}<732871);  %only values between 1945 and 2004
end

for i=1:size(c,1)
    if size(c{i,6},1)~=22473
        c(i,:)=[];  %only values between 1945 and 2004
    end
end


ROI=reshape(cell2mat(c(:,6)),22473,size(c,1));
ROI=ROI';

N=size(ROI,1);
ESynchro=zeros(N,N);


ROI10=ROI(:,end-3650:end);
tx=1:size(ROI,2);
ty=1:size(ROI,2);

parpool(3)
tic
for i=1:N
    parfor j=i:N
        [ESynchro(i,j),~]=eventsynchro(tx,ROI(i,:),ty,ROI(j,:),0,0.95); %eventsynchro was modified in lines 46+47 to only include high events
    end
    i
end
toc

AESy=ESynchro; %create Adjecency Matrix

AESy=(AESy+AESy').*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(AESy(:),95); %define threshold of synchronization as 98 percentile
AESy=AESy>T; %binarize Adjecency Matrix

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
h2.NodeLabel=[];%c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;

figure(9)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=[];%c(idx,3);
Betw=centrality(GC,'betweenness');
h2.NodeCData=Betw;
h2.MarkerSize=10;
