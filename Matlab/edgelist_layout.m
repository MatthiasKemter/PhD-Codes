%% create a layout file that contains the coordinates of each network node

nodes=(1:(size(discharge,1)+size(subset_time,1)))'; %Node IDs
Lat=[cell2mat(raw(:,3));subset_time(:,end)];
Lon=[cell2mat(raw(:,4));subset_time(:,end-1)];

layout=array2table([nodes Lat Lon],'VariableNames',{'nodeID','nodeLat','nodeLong'});
writetable(layout,'C:\Users\kemter\Documents\Data\Multilayer_Networks\layer_layout.csv')