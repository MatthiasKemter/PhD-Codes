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