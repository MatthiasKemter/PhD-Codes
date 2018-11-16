function A = Moving_Window_CN(Data,varargin)
%MOVING_WINDOW_CN generates multiple complex networks in a moving window.
%   Returns a cell array of adjacency matrices (A) with one matrix for
%   every window of a given size (varargin{3}, standard=10% of complete
%   timeframe) that are moving by a given value (varargin{4}, standard=50% of
%   windowsize). Adjacency matrices are generated using the CN_Generation
%   function with a given threshold for event synchronization
%   (varargin{1}, standard=0.95) and link generation (varargin{1},
%   standard=0.95).
%
%   EXAMPLE:
%       A=Moving_Window_CN(discharge,0.95,0.95,365*7,365*3);

percentileES=0.95;  %event threshold
percentileLink=0.95;    %network link threshold

if nargin>=2
    percentileES=varargin{1};
end

if nargin>=3
    percentileLink=varargin{2};
end

windowsize=ceil(size(Data,2)/10);   %size of the moving window

if nargin>=4
    windowsize=ceil(varargin{3});
end

offset=ceil(windowsize/2);  %movement of the window per step

if nargin==5
    offset=ceil(varargin{4});
end

Nwindows=ceil((size(Data,2)-windowsize)/offset);    %total number of windows

begin=1:offset:size(Data,2)-windowsize; %start of current window
stop=begin+windowsize;  %end of current window
stop(end)=size(Data,2); %end of final window

for i=1:Nwindows
    Datasplit{i}=Data(:,begin(i):stop(i));    %time series subset for current window
end

A=cell(Nwindows,1);

pool=parpool(4);    %parallel processing for higher performance

parfor i=1:Nwindows
    A{i}=CN_Generation(Datasplit{i},percentileES,percentileLink);
end

delete(pool);

end