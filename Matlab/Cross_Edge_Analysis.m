%% import edgelist and define nodes
edgelist=csvread('C:\Users\kemter\Documents\Data\Multilayer_Networks\edgelist.csv');
cross=edgelist(edgelist(:,2)~=edgelist(:,4),:);
innode=cross(:,1);
outnode=cross(:,3);

%% import layout and assign coordinates to nodes
layout=csvread('C:\Users\kemter\Documents\Data\Multilayer_Networks\layer_layout.csv',1);

for i=1:size(cross,1)
    inlat(i)=layout(innode(i),2);
    inlon(i)=layout(innode(i),3);
    outlat(i)=layout(outnode(i),2);
    outlon(i)=layout(outnode(i),3);
end

%% plots
[arclen,az] = distance(inlon,inlat,outlon,outlat);
histogram(arclen*111,20,'Normalization','probability');

figure
polarhistogram(az/180*pi,'Normalization','probability')

figure
scatter(az,arclen*111)

%% comparison to a complete network for these nodes (link from each node to each other)