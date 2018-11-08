function [A] = Moving_Window_CN(Data,varargin)
%MOVING_WINDOW_CN generates multiple complex networks in a moving window.
%
%   

percentileES=0.95;
percentileLink=0.95;

if nargin>=2
    percentileES=varargin{1};
end

if nargin>=3
    percentileLink=varargin{2};
end

windowsize=ceil(size(Data,2)/10);

if nargin>=4
    windowsize=varargin{3};
end

offset=ceil(windowsize/2);

if nargin==5
    offset=varargin{4};
end

Nwindows=ceil(size(Data,2)/offset);

begin=(0:Nwindows-1)*offset+1;
stop=(1:Nwindows)*offset;
stop(end)=size(Data,2);

for i=1:Nwindows
    Datasplit{i}=Data(:,begin(i):stop(i));    
end

A=cell(Nwindows,1);

pool=parpool(3);    %parallel processing for higher performance

parfor i=1:Nwindows
    A{i}=CN_Generation(Datasplit{i},percentileES,percentileLink);
end

delete(pool);

end