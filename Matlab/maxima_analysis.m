time=datetime('01.01.1960'):datetime('31.12.2009');

test=timeseries(discharge6010,time);

tsmax(test)

%%
[Y,~] = datevec([time(1) time(end)]);

discharge_max=zeros(size(discharge6010,1),Y(end)-Y(1)+1);
pos=zeros(size(discharge6010,1),Y(end)-Y(1)+1);
i=0;
for yr=Y(1):Y(end)
    i=i+1;
    [discharge_max(:,i),pos(:,i)]=max(discharge6010(:,time<datetime(['01.01.' num2str(yr+1)])&time>=datetime(['01.01.' num2str(yr)])),[],2);
    pos(:,i)=pos(:,i)+datenum(['01.01.' num2str(yr)],'dd.mm.yyyy');
end

pos=pos-datenum(['01.01.' num2str(Y(1))],'dd.mm.yyyy');

%%

bar(time(pos(200,:)),discharge_max(200,:));


%%

map = [0 0.4 0
    0.2 0.4 0
    0.4 0.4 0
    0.6 0.4 0
    0.8 0.4 0
    1 0.4 0
    1 0.6 0
    1 0.8 0
    1 1 0
    0.8 0.8 0
    0.6 0.6 0
    0.4 0.4 0];


%% decadel modal extreme flood week
Lon=cell2mat(raw6010(:,4));
Lat=cell2mat(raw6010(:,3));

c=mode(week(time(pos(:,1:10))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(1,5,1)
scatter(Lon,Lat,[],c)
colorbar('north','Ticks',[1 13 26 39 50],'TickLabels',{'Jul','Oct','Jan','Apr','Jun'})
title('1960-69')
xlim([-10 32]);
ylim([42 73]);

c=mode(week(time(pos(:,11:20))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(1,5,2)
scatter(Lon,Lat,[],c)
colorbar('north','Ticks',[1 13 26 39 50],'TickLabels',{'Jul','Oct','Jan','Apr','Jun'})
title('1970-79')
xlim([-10 32]);
ylim([42 73]);

c=mode(week(time(pos(:,21:30))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(1,5,3)
scatter(Lon,Lat,[],c)
colorbar('north','Ticks',[1 13 26 39 50],'TickLabels',{'Jul','Oct','Jan','Apr','Jun'})
title('1980-89')
xlim([-10 32]);
ylim([42 73]);

c=mode(week(time(pos(:,31:40))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(1,5,4)
scatter(Lon,Lat,[],c)
colorbar('north','Ticks',[1 13 26 39 50],'TickLabels',{'Jul','Oct','Jan','Apr','Jun'})
title('1990-99')
xlim([-10 32]);
ylim([42 73]);

c=mean(week(time(pos(:,41:50))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

%subplot(1,5,5)
scatter(Lon,Lat,[],c)
colorbar('north','Ticks',[1 13 26 39 50],'TickLabels',{'Jul','Oct','Jan','Apr','Jun'})
title('2000-09')
xlim([-10 32]);
ylim([42 73]);

sgtitle('Modal week of extreme flood')
%% largest annual component
for i=1:size(discharge_max,2)
    [a(i),f(i)]=mode(week(time(pos(:,i))),2);
end

plot(cumsum(f))
hold
plot(1:50,linspace(f(1),sum(f),50))

%%
geoshow('landareas.shp', 'FaceColor', [0.9 0.9 0.7])
hold;
x=Lon(week(time(pos(:,21)))==a(21));
y=Lat(week(time(pos(:,21)))==a(21));
scatter(x,y)
xlim([-10 32]);
ylim([42 73]);

%%


c=mean(week(time(pos(:,1:10))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(2,2,3)
scatter(Lon,Lat,[],c)
colorbar
xlim([-10 32]);
ylim([36 72]);

c=mean(week(time(pos(:,41:50))),2);
c=c-26;
c(c<=0)=c(c<=0)+52;

subplot(2,2,4)
scatter(Lon,Lat,[],c)
colorbar
xlim([-10 32]);
ylim([36 72]);