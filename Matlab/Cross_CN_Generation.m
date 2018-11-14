function [Adj] = Cross_CN_Generation(Layer1,Layer2,varargin)
%CROSS_CN_GENERATION generates a complex network between two layers.
%
%   Events are those entries of the timeseries (Data) that exceed the 
%   percentile given as the second input variable (percentileES). The
%   standard value is 0.95. Edges are placed between stations with an
%   ES value within the percentile given as the third input variable
%   (percentileLink). The standard value is 0.95. The function returns a
%   binarized, symmetric adjacency matrix (Adj).

percentileES=0.95;
percentileLink=0.95;

if nargin>=3
    percentileES=varargin{1};
end
if nargin==4
    percentileLink=varargin{2};
end

N1=size(Layer1,1);
N2=size(Layer2,1);
ES=zeros(N1,N2);  %event synchronization matrix

t1=1:size(Layer1,2);  %timesteps
t2=1:size(Layer2,2);

pool=parpool(4);    %parallel processing for higher performance
tic
for i=1:N1
    tic
    parfor j=1:N2
        [ES(i,j),~]=eventsynchro(t1,Layer1(i,:),t2,Layer2(j,:),0,percentileES); %eventsynchro was modified in lines 46+47 to only include high events
    end
    toc
end
toc
delete(pool);

Adj=ES; %create Adjecency Matrix

T=prctile(Adj(:),percentileLink*100); %define threshold of synchronization
Adj=Adj>T; %binarize Adjecency Matrix

end
