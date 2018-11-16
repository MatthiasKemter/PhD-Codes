function edgelist = Adj2list(filename_list,A1,varargin)
%ADJ2LIST creates an edglist for single- or multilayer complex networks.
%   Transforms one or multiple adjacency matrices (A1,varargin)) into 
%   edgelists (edgelist) that are compatible with e.g. muxViz. The edgelist
%   is written to a csv file (filename_list) in the "Data" folder. The
%   edgelist consists of 2 columns for singlelayer networks (first connected
%   node, second connected node) and 4 columns for multilayer networks (first
%   node, layer of first node, second node, layer of second node).
%
%   EXAMPLE:
%       edgelist=Adj2list('test.csv',A_dis,A_prec,A_cross);

if nargin~=2 && nargin~=4 && nargin~=7
    error('Incorrect number of input variables')
end

if nargin>=2
    [a,b] = find(A1);   %find position of links within adjacency matrix
    edges1 = [a,b];
    clear a;
    clear b;
    dim1=size(edges1,1);
end

if nargin==2
    edgelist=[edges1(:,1) edges1(:,2)];
end

if nargin>=4
    A2=varargin{1}; %layer 2 adjacency matrix
    Across12=varargin{2};   %cross layer adjacency matrix between layers 1 and 2
    
    [a,b] = find(A2);
    edges2 = [a,b];
    clear a;
    clear b;
    dim2=size(edges2,1);
    
    [a,b] = find(Across12);
    edges12 = [a,b];
    clear a;
    clear b;
    dim12=size(edges12,1);
    
    edges2=edges2+size(A1,1);   %nodeID of nodes in the second layer is
    %where the IDs of the first layer end.
    edges12=[edges12(:,1) edges12(:,2)+size(A1,1)]; %same as above
end

if nargin==4
    edgelist=[edges1(:,1) ones(dim1,1) edges1(:,2) ones(dim1,1);
    edges2(:,1) 2*ones(dim2,1) edges2(:,2) 2*ones(dim2,1);
    edges12(:,1) ones(dim12,1) edges12(:,2) 2*ones(dim12,1)]; %layerIDs are
    %added in the 2nd and 4th column
end

if nargin>=7
    A3=varargin{3}; %layer 3 adjacency matrix
    Across13=varargin{4}; %cross layer adjacency matrix between layers 1 and 3
    Across23=varargin{5}; %cross layer adjacency matrix between layers 2 and 3
    
    [a,b] = find(A3);
    edges3 = [a,b];
    clear a;
    clear b;
    dim3=size(edges3,1);
    
    [a,b] = find(Across13);
    edges13 = [a,b];
    clear a;
    clear b;
    dim13=size(edges13,1);
    
    [a,b] = find(Across23);
    edges23 = [a,b];
    clear a;
    clear b;
    dim23=size(edges23,1);
    
    edges3=edges3+size(A1,1)+size(A2,1);
    edges13=[edges13(:,1) edges13(:,2)+size(A1,1)+size(A2,1)];
    edges23=[edges23(:,1)+size(A1,1) edges23(:,2)+size(A1,1)+size(A2,1)];
end

if nargin==7
    edgelist=[edges1(:,1) ones(dim1,1) edges1(:,2) ones(dim,1);
    edges2(:,1) 2*ones(dim2,1) edges2(:,2) 2*ones(dim2,1);
    edges3(:,1) 3*ones(dim3,1) edges3(:,2) 3*ones(dim3,1);
    edges12(:,1) ones(dim12,1) edges12(:,2) 2*ones(dim12,1);
    edges13(:,1) ones(dim13,1) edges13(:,2) 3*ones(dim13,1);
    edges23(:,1) 2*ones(dim23,1) edges23(:,2) 3*ones(dim23,1)];
end

csvwrite(['C:\Users\kemter\Documents\Data\Multilayer_Networks\' filename_list],edgelist)

end
