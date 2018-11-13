files = dir(['C:\Users\kemter\Desktop\JRA_55\' '*.nc']);
F=numel(files);
Prec=single([]);

for i=1:F
    input=ncread([files(i).folder '\' files(i).name],'TPRAT_GDS4_SFC_ave3h');
    inMat=single(reshape(input,numel(input(:,:,1)),size(input,3)));
    Prec=[Prec inMat];
    i
end

PrecDown=reshape(sum(reshape(Prec',4,[]),1),[],size(Prec, 1))';

x=single(repmat((1:size(input,1))',size(input,2),1));
y=single([]);
for i=1:size(input,2)
    y=[y;i*ones(size(input,1),1)];
end

PrecData=single([PrecDown x y]);

subset=PrecData(PrecData(:,end-1)>=34 & PrecData(:,end-1)<=52 & PrecData(:,end)>=30 & PrecData(:,end)<=46,:);

for i=1:size(subset,1)
    subset(i,22099)=(subset(i,22097)-1)*0.562-13;
    subset(i,22100)=72-(subset(i,22098)-1)*0.562;
end
%%

A=CN_Generation(subset(:,1:end-2),0.95,0.98);

scatter(PrecData(:,end-1),PrecData(:,end))
 
figure(2)
imagesc(sum(reshape(PrecDown,114,69,[]),3)')
colorbar

%%

test2=sum(reshape(PrecDown,114,69,[]),3)';
imagesc(test2(30:50,30:50))

test=PrecDown(PrecData(:,end-1)>=30 & PrecData(:,end-1)<=50 & PrecData(:,end)>=22 & PrecData(:,end)<=42,:);
testsum=sum(reshape(test,21,21,[]),3)';

%%




