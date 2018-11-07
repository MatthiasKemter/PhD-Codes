
clear all

gauges=shaperead('C:/Users/kemter/Desktop/gauges/gauges_WGS84.shp');

files = dir('C:/Users/kemter/Desktop/time_series/*.dts');
F=numel(files);

for i=1:F;
    filename = dir(['C:/Users/kemter/Desktop/time_series/' gauges(i).name '*.dts']);
    a=textscan(fopen(['C:/Users/kemter/Desktop/time_series/' filename(1).name]), "%s %f");
    c{i,1}=datenum(a{:,1}, 'dd-mm-yyyy');
    c{i,2}=a{:,2};
    c{i,3}=gauges(i).name;
    c{i,4}=gauges(i).X;
    c{i,5}=gauges(i).Y;
    fclose('all');
    i
end

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


q=cell2mat(cellfun(@size,c(:,6),'UniformOutput',false));
c=c(q(:,1)==22473,:); %only values between 1945 and 2004


ROI=reshape(cell2mat(c(:,6)),22473,size(c,1));
ROI=ROI';

N=size(ROI,1);
ESynchro=zeros(N,N);


ROI=ROI(:,1:7300);
tx=1:size(ROI,2);
ty=1:size(ROI,2);

myCluster = parcluster('local');
myCluster.NumThreads = 2;
parpool(3)
tic
for i=1:N
    parfor j=i+1:N
        [ESynchro(i,j),~]=eventsynchro(tx,ROI(i,:),ty,ROI(j,:),0,0.95); %eventsynchro was modified in lines 46+47 to only include high events
    end
    i
end
toc

Adj=ESynchro; %create Adjecency Matrix
N=size(Adj,1);

Adj=(Adj+Adj').*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(Adj(:),95); %define threshold of synchronization as 95 percentile
Adj=Adj>T; %binarize Adjecency Matrix

%%

G=graph(Adj);
Deg=degree(G);

figure(1)
G.Nodes.Name = c(:,3);
h = plot(G);
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
%h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;
colorbar

[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
GC = subgraph(G, idx);
GC.Nodes.Name = c(idx,3);

figure(2)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=[];%c(idx,3);
h2.NodeCData=Deg(idx);
h2.MarkerSize=10;
%h2.EdgeColor='none';
title('degree');
colorbar;

figure(3)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=[];%c(idx,3);
Betw=centrality(GC,'betweenness');
h2.NodeCData=Betw/max(Betw);
h2.MarkerSize=10;
%h2.EdgeColor='none';
title('betweenness');
colorbar;

Dist=mean(distances(GC));
figure(4)
h2=plot(GC);
h2.XData=cell2mat(c(idx,4));
h2.YData=cell2mat(c(idx,5));
h2.NodeLabel=[];%c(idx,3);
h2.NodeCData=Dist;
h2.MarkerSize=10;
%h2.EdgeColor='none';
title('Avg. Distance');
colorbar;