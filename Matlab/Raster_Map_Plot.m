G=graph(A);
Deg=degree(G);

figure(2)
%G.Nodes.Name = c(:,3);
h = plot(G);
h.XData=PrecData(:,366);
h.YData=PrecData(:,367);
%h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;
colorbar

%%
x=max(PrecData(:,366));
y=max(PrecData(:,367));

DegMap=zeros(x,y);
k=1;
for i=1:x;
    for j=1:y
        if ~isempty(find(PrecData(:,366)==i & PrecData(:,367)==j))
            DegMap(i,j)=Deg(k);
            k=k+1;
        end
    end
end


imagesc('XData',PrecData(:,366),'YData',PrecData(:,367),'CData',Deg)


