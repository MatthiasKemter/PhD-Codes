files = dir(['C:\Users\kemter\Desktop\JRA_55\' '*.nc']);
F=numel(files);
Prec=single([]);

for i=1:F
    input=ncread([files(i).folder '\' files(i).name],'TPRAT_GDS4_SFC_ave3h');
    inMat=single(reshape(input,numel(input(:,:,1)),size(input,3)));
    Prec=[Prec inMat];
    i
end

PrecDown=reshape(sum(reshape(Prec',8,[]),1),[],size(Prec, 1))';

x=single(repmat((1:size(input,1))',size(input,2),1));
y=single([]);
for i=1:size(input,2)
    y=[y;i*ones(size(input,1),1)];
end

PrecData=single([PrecDown x y]);


scatter(PrecData(:,end-1),PrecData(:,end))
 
figure(2)
imagesc(sum(reshape(PrecDown,114,69,[]),3)')
colorbar

%%

test=sum(reshape(PrecDown,114,69,[]),3)';

imagesc(test)
