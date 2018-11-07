function [Adj] = CN_Generation(Data,varargin)

percentileES=0.95;
percentileLink=0.95;

if nargin>=2
    percentileES=varargin{1};
end
if nargin==3
    percentileLink=varargin{2};
end

N=size(Data,1);
ES=zeros(N,N);

tx=1:size(Data,2);
ty=1:size(Data,2);

pool=parpool(3);
tic
for i=1:N
    parfor j=i+1:N
        [ES(i,j),~]=eventsynchro(tx,Data(i,:),ty,Data(j,:),0,percentileES); %eventsynchro was modified in lines 46+47 to only include high events
    end
end
toc
delete(pool);

Adj=ES; %create Adjecency Matrix
N=size(Adj,1);

Adj=(Adj+Adj').*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(Adj(:),percentileLink*100); %define threshold of synchronization as 95 percentile
Adj=Adj>T; %binarize Adjecency Matrix


end
