Prec=ncread('C:/Users/kemter/Downloads/precip.1979.nc','precip');
PrecRot=fliplr(Prec(:,:,:));
PrecShift=[PrecRot(361:720,:,:);PrecRot(1:360,:,:)];
PrecEuro=PrecShift(335:440,250:320,:);
PrecEuro(PrecEuro==min(PrecEuro))=NaN;
PrecCell=mat2cell(PrecEuro,ones(1,106),ones(1,71),365);

for i=1:size(PrecEuro,1)
    for j=1:size(PrecEuro,2)
        x(i,j)=j;
        y(i,j)=i;
    end
end

PrecMat=reshape(PrecEuro,numel(PrecEuro(:,:,1)),size(PrecEuro,3));



PrecData=[PrecMat x y];

%PrecData=[PrecMat (1:size(PrecMat,1))'];

PrecData(any(isnan(PrecData),2),:) = [];

scatter(PrecData(:,366),PrecData(:,367))
%%

A=CN_Generation(PrecData(:,1:365),0.95,0.95);