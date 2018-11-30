for i=1:size(A)
    G{i}=graph(A{i});   %create graph for each adjacency matrix
end

GER = shaperead('C:/Users/kemter/Desktop/gauges/TM_WORLD_BORDERS-0.3.shp');
[~,index] = sortrows({GER.NAME}.'); GER = GER(index); clear index
GER=GER(82);    %borders of Germany

Rivers = shaperead('C:/Users/kemter/Desktop/gauges/Europe_Hydrography.shp');
[~,index] = sortrows({Rivers.NAME}.'); Rivers = Rivers(index); clear index
Rivers=Rivers([46 70 78 99 149 168 185 225 226 227 231 269 352 353]);
%important German rivers

%% for station data

figure(2)
j=1;
windows=[1 3 5 7 9 11];    %define 6 time windows of interest here

for i=windows
Deg=degree(G{i});   %calculate degree centrality of all nodes
s(j)=subplot(2,3,j);
j=j+1;
%mapshow(GER, 'FaceColor', [0.9 0.9 0.7]);  %plot German boundaries
geoshow('landareas.shp', 'FaceColor', [0.9 0.9 0.7])
hold;
mapshow(Rivers,'LineWidth',1.5);
%G{i}.Nodes.Name = raw(:,3);    %associate names to nodes if applicable
h = plot(G{i});
h.XData=cell2mat(raw5212(:,4)); %set node longitude
h.YData=cell2mat(raw5212(:,3)); %set node latitude
h.NodeCData=Deg;    %scale node color by degree
Betw=centrality(G{i},'betweenness'); %calculate node betweenness
h.NodeCData=Betw/max(Betw); %scale node color by betweenness
h.NodeLabel=[]; %remove node labels
h.MarkerSize=6;
h.LineWidth=0.2;
h.EdgeColor='r';
%colorbar
%xlim([5 15]);  %Limit to Germany
%ylim([47 55]); %Limit to Germany
xlim([-10 32]); %Limit to Europe
ylim([36 72]);  %Limit to Europe
firstYear=datestr(raw5212{1,7}(1+(i-1)*offset),'yyyy');
lastYear=datestr(raw5212{1,7}(1+windowSize+(i-1)*offset),'yyyy');
title([firstYear '-' lastYear],'FontSize',14);
hold off;
axis off;
end

s(1).Position=[-0.0 0.53 0.3 0.43];
s(2).Position=[0.33 0.53 0.3 0.43];
s(3).Position=[0.67 0.53 0.3 0.43];
s(4).Position=[-0.0 0.03 0.3 0.43];
s(5).Position=[0.33 0.03 0.3 0.43];
s(6).Position=[0.67 0.03 0.3 0.43];

%s(1).Position=[0.0 0.53 0.5 0.43];
%s(2).Position=[0.5 0.53 0.5 0.43];
%s(3).Position=[0.0 0.03 0.5 0.43];
%s(4).Position=[0.5 0.03 0.5 0.43];

%sgtitle('Degree');

%% for Raster Map

windowSize=7*365;
offset=3*365;

figure(3)
j=1;

for i=1:3:17%size(G,2)
Deg=degree(G{i});
s(j)=subplot(2,3,j);
j=j+1;
mapshow(GER, 'FaceColor', [0.9 0.9 0.7]);
hold;
%mapshow(Rivers,'LineWidth',2);
%G{i}.Nodes.Name = c(:,3);
h = plot(G{i});
h.XData=subset(:,end-1);
h.YData=subset(:,end);
h.NodeCData=Deg;
%Betw=centrality(G{i},'betweenness');
%h.NodeCData=Betw/max(Betw);
h.NodeLabel=[];
h.MarkerSize=8;
h.LineWidth=0.2;
h.EdgeColor='k';
%colorbar
xlim([5 15.5]);
ylim([47 55.5]);
firstYear=datestr(715146+(i-1)*offset,'yyyy');
lastYear=datestr(715146+windowSize+(i-1)*offset,'yyyy');
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

%% Topology measure average plot
for i=1:size(A)
    Between{i}=centrality(G{i},'betweenness');
end

Deg=mean(cell2mat(Between),2);

h = plot(G{1});
h.XData=subset(:,end-1);
h.YData=subset(:,end);
%h.NodeLabel=c(:,3);
h.NodeCData=Deg;
h.MarkerSize=10;
h.EdgeColor='none';
colorbar