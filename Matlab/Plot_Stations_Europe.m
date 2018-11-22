%%

borders=shaperead('C:\Users\kemter\Documents\Data\Shapes\TM_WORLD_BORDERS-0.3.shp');
tborders=struct2table(borders);
europe=borders([tborders{:,12}==150]);

Rivers = shaperead('C:\Users\kemter\Documents\Data\Shapes\Europe_Hydrography.shp');
[~,index] = sortrows({Rivers.NAME}.'); Rivers = Rivers(index); clear index

mapshow(europe, 'FaceColor', [0.9 0.9 0.7]);
hold;
mapshow(Rivers,'LineWidth',1);
h=scatter(cell2mat(discharge(:,4)),cell2mat(discharge(:,3)),50,'r','filled','MarkerEdgeColor','k');
xlim([-11 40]);
ylim([36 72]);
hold off