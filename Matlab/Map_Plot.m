h=worldmap([47 55],[5 16]);
load coastlines

%%
GER = shaperead('C:/Users/kemter/Desktop/gauges/TM_WORLD_BORDERS-0.3.shp');
[~,index] = sortrows({GER.NAME}.'); GER = GER(index); clear index
GER=GER(82);

figure(1)
j=1;

for i=1:5:size(G,2)
Deg=degree(G{i});
s(j)=subplot(2,2,j);
j=j+1;
mapshow(GER, 'FaceColor', [0.9 0.9 0.7]);
hold;
G{i}.Nodes.Name = c(:,3);
h = plot(G{i});
h.XData=cell2mat(c(:,4));
h.YData=cell2mat(c(:,5));
h.NodeCData=Deg;
h.MarkerSize=10;
colorbar
firstYear=datestr(c{1,7}(10+(i-1)*offset),'yyyy');
lastYear=datestr(c{1,7}(10+windowSize+(i-1)*offset),'yyyy');
title([firstYear '-' lastYear])
hold off;
end

s(1).Position=[0.0 0.53 0.5 0.43];
s(2).Position=[0.5 0.53 0.5 0.43];
s(3).Position=[0.0 0.03 0.5 0.43];
s(4).Position=[0.5 0.03 0.5 0.43];

%%
%hold
%h2=worldmap([47 55],[5 16]);

GER = shaperead('C:/Users/kemter/Desktop/gauges/TM_WORLD_BORDERS-0.3.shp');
[~,index] = sortrows({GER.NAME}.'); GER = GER(index); clear index
GER=GER(82);

mapshow(GER, 'FaceColor', [0.9 0.9 0.7]);

land = shaperead('landareas')%, 'UseGeoCoords', true);
mapshow(land, 'FaceColor', [0.9 0.9 0.7]);
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])

rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue','LineWidth',2)
hold



cities = shaperead('worldcities', 'UseGeoCoords', true);
h3=geoshow(cities, 'Marker', 'o','MarkerSize',7,'MarkerFaceColor','red');

