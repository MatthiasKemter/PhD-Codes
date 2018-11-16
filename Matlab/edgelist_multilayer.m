A_cross=Cross_CN_Generation(discharge,subset_time(:,1:end-4));
[a,b] = find(A_cross);
edges_cross = [a,b];
clear a
clear b

A_prec=CN_Generation(subset_time(:,1:end-4));
[a,b] = find(A_prec);
edges_prec = [a,b];
clear a
clear b

A_dis=CN_Generation(discharge);
[a,b] = find(A_dis);
edges_dis = [a,b];
clear a
clear b

%% 
edges_prec_2=edges_prec+size(A_dis,1);
edges_cross_2=[edges_cross(:,1) edges_cross(:,2)+size(A_dis,1)];
dim_dis=size(edges_dis,1);
dim_cross=size(edges_cross,1);
dim_prec=size(edges_prec,1);

edgelist=[edges_dis(:,1) ones(dim_dis,1) edges_dis(:,2) ones(dim_dis,1);
    edges_prec_2(:,1) 2*ones(dim_prec,1) edges_prec_2(:,2) 2*ones(dim_prec,1);
    edges_cross_2(:,1) ones(dim_cross,1) edges_cross_2(:,2) 2*ones(dim_cross,1)];

csvwrite('C:\Users\kemter\Documents\Data\edgelist.csv',edgelist)

%%

nodes=(1:(size(discharge,1)+size(subset_time,1)))';
Lat=[cell2mat(raw(:,3));subset_time(:,end)];
Lon=[cell2mat(raw(:,4));subset_time(:,end-1)];

layout=array2table([nodes Lat Lon],'VariableNames',{'nodeID','nodeLat','nodeLong'});
writetable(layout,'C:\Users\kemter\Documents\Data\Multilayer_Networks\layer_layout.csv')

