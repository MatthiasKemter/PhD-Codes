%% compute mean and max distance of each event cluster
val=val(:,end-24:end);  %remove first column which only contains zeros
distmax=zeros(size(val));
distmean=zeros(size(val));
num=zeros(size(val));
for k=1:size(val,1)      %number of years
    for i=1:size(val,2)  %number of clusters
        
        clear stations
        d=datenum(datetime(start+k-1,11,1))+idx(k,i)+7-datenum(datetime(start,11,1));
        %find datenum value of event window
        for j=1:size(dis_ts,1)
            stations(j)=sum(dis_ts(j,d-7:d+7))>0; % find stations with a flood
            % in the window
        end
        if sum(stations)<2   %exclude clusters with one element
            continue
        end
        tempLon=Lon(stations);  %Lon of all stations in the cluster
        tempLat=Lat(stations);  %Lat of all stations in the cluster
        templatitude1=[];
        templongitude1=[];
        templatitude2=[];
        templongitude2=[];
        % repeat Lat and Lon to allow comparison in following steps:
        for l=1:numel(tempLat)
            templatitude1=[templatitude1 ; repmat(tempLat(l),numel(tempLat)-l,1)];
            templongitude1=[templongitude1 ; repmat(tempLon(l),numel(tempLat)-l,1)];
            templatitude2=[templatitude2 ; tempLat(l+1:end)];
            templongitude2=[templongitude2 ; tempLon(l+1:end)];
        end
        
        distmax(k,i)=max(distance(templatitude1,templongitude1,templatitude2,templongitude2));
            % maximum distance in each cluster
        distmean(k,i)=mean(distance(templatitude1,templongitude1,templatitude2,templongitude2));
            % mean distance in each cluster
        num(k,i)=sum(stations>0);
            % number of stations in each cluster
    end
end