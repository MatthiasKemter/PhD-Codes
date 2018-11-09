
GER = shaperead('C:/Users/kemter/Desktop/gauges/TM_WORLD_BORDERS-0.3.shp');
[~,index] = sortrows({GER.NAME}.'); GER = GER(index); clear index
GER=GER(82);

Rivers = shaperead('C:/Users/kemter/Desktop/gauges/Europe_Hydrography.shp');
[~,index] = sortrows({Rivers.NAME}.'); Rivers = Rivers(index); clear index
Rivers=Rivers([46 70 99 149 185 225 226 227]);

figure(1)
j=1;

for i=1:1:size(G,2)-1
Deg=degree(G{i});
s(j)=subplot(2,3,j);
j=j+1;
mapshow(GER, 'FaceColor', [0.9 0.9 0.7]);
hold;
G{i}.Nodes.Name = c(:,3);
h = plot(G{i});
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeCData=Deg;
h.MarkerSize=8;
h.LineWidth=0.2;
h.EdgeColor='k';
mapshow(Rivers,'LineWidth',2);
%colorbar
xlim([5 15]);
ylim([47 55]);
firstYear=datestr(c{1,7}(10+(i-1)*offset),'yyyy');
lastYear=datestr(c{1,7}(10+windowSize+(i-1)*offset),'yyyy');
title([firstYear '-' lastYear],'FontSize',14);
hold off;
axis off;
end

s(1).Position=[-0.02 0.53 0.3 0.43];
s(2).Position=[0.33 0.53 0.3 0.43];
s(3).Position=[0.67 0.53 0.3 0.43];
s(4).Position=[-0.02 0.03 0.3 0.43];
s(5).Position=[0.33 0.03 0.3 0.43];
s(6).Position=[0.67 0.03 0.3 0.43];

%s(1).Position=[0.0 0.53 0.5 0.43];
%s(2).Position=[0.5 0.53 0.5 0.43];
%s(3).Position=[0.0 0.03 0.5 0.43];
%s(4).Position=[0.5 0.03 0.5 0.43];

%sgtitle('Degree');

