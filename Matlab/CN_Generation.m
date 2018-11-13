function [Adj] = CN_Generation(Data,varargin)
%CN_GENERATION generates a complex network based on event synchronization.
%
%   Events are those entries of the timeseries (Data) that exceed the 
%   percentile given as the second input variable (percentileES). The
%   standard value is 0.95. Edges are placed between stations with an
%   ES value within the percentile given as the third input variable
%   (percentileLink). The standard value is 0.95. The function returns a
%   binarized, symmetric adjacency matrix (Adj).

percentileES=0.95;
percentileLink=0.95;

if nargin>=2
    percentileES=varargin{1};
end
if nargin==3
    percentileLink=varargin{2};
end

N=size(Data,1);
ES=zeros(N,N);  %event synchronization matrix

tx=1:size(Data,2);  %timesteps
ty=1:size(Data,2);

%pool=parpool(4);    %parallel processing for higher performance
tic
for i=1:N
    %tic
    for j=i+1:N
        [ES(i,j),~]=eventsynchro(tx,Data(i,:),ty,Data(j,:),0,percentileES); %eventsynchro was modified in lines 46+47 to only include high events
    end
    %toc
end
toc
%delete(pool);

Adj=ES; %create Adjecency Matrix
N=size(Adj,1);

Adj=(Adj+Adj').*(1+diag(-1*ones(1,N))); %make A symmetric and substitute zeros for i=j
T=prctile(Adj(:),percentileLink*100); %define threshold of synchronization
Adj=Adj>T; %binarize Adjecency Matrix

end
