h=worldmap([47 55],[5 16]);
load coastlines
%plotm(coastlat,coastlon);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [0.5 0.7 0.5])

rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue')

h2=plotm(cell2mat(c(:,5)),cell2mat(c(:,4)),'o');
h2.MarkerSize=7;
h2.MarkerFaceColor='w';
h2.MarkerEdgeColor='k';


cities = shaperead('worldcities', 'UseGeoCoords', true);
h3=geoshow(cities, 'Marker', 'o','MarkerSize',7,'MarkerFaceColor','red');