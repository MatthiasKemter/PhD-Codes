Prec=ncread('C:/Users/kemter/Downloads/precip.1979.nc','precip');
PrecRot=rot90(flipud(Prec(:,:,:)),3);
PrecShift=[PrecRot(:,361:720,:) PrecRot(:,1:360,:)];
PrecEuro=PrecShift(35:110,335:440,:);
PrecEuro(PrecEuro==min(PrecEuro))=NaN;


PrecMat=reshape(PrecEuro,numel(PrecEuro(:,:,1)),size(PrecEuro,3));

x=repmat((1:size(PrecEuro,1))',size(PrecEuro,2),1);
y=[];
for i=1:size(PrecEuro,2)
    y=[y;i*ones(size(PrecEuro,1),1)];
end

PrecData=[PrecMat x y];

%PrecData=[PrecMat (1:size(PrecMat,1))'];

PrecData(any(isnan(PrecData),2),:) = [];

scatter(PrecData(:,366),PrecData(:,367))
%%

A=CN_Generation(PrecData(:,1:365),0.95,0.95);