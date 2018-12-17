%%
opts = spreadsheetImportOptions("NumVariables", 20);

% Specify sheet and range
opts.Sheet = "EventList";
opts.DataRange = "A2:T1565";

% Specify column names and types
opts.VariableNames = ["No", "Code", "Year", "Countryname", "Startdate", "Enddate", "Type", "Floodsource", "Regionsaffected", "Areafloodedkm2", "Fatalities", "Personsaffected", "Lossesnominalvalue", "Lossesoriginalcurrency", "LossesmlnEUR2011", "Cause", "Notes", "Sources", "VarName19", "VarName20"];
opts.VariableTypes = ["double", "categorical", "double", "categorical", "datetime", "datetime", "categorical", "string", "string", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "categorical", "string", "string"];
opts = setvaropts(opts, [8, 9, 17, 19, 20], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 4, 7, 8, 9, 14, 16, 17, 18, 19, 20], "EmptyFieldRule", "auto");

% Import the data
Eventsfloods = readtable("C:\Users\kemter\Downloads\Events_floods.xlsx", opts, "UseExcel", false);
clear opts

%%
date=datetime(Eventsfloods.VarName19);
loss=Eventsfloods.LossesmlnEUR2011;
date(isnan(loss))=[];
loss(isnan(loss))=[];
[date,idx]=sort(date);
loss=loss(idx);

%% 1 year bins
start=year(min(date));
stop=year(max(date));
j=start:stop;
for i=1:1:numel(j)
    yearloss(i)=sum(loss(year(date)==j(i)));
end
    
%%
h=bar(j,yearloss,1);
xticks(1870:20:2010);
xticklabels(1870:20:2010);
a=gca;
a.FontSize=20;
yticks(3000:3000:21000);
yticklabels(3000:3000:21000);
ylim([0 21000]);
h.LineWidth=1;
a.TickDir = 'out';
set(a, 'box', 'off');
txt = sprintf('Damage caused by extreme floods in Europe\n1870-2016, Paprotny et al. 2017');
text(1873,19000,txt,'FontSize',28)
xlabel('Year','FontSize',24)
ylabel('Millions of €','FontSize',24)
a.LineWidth=1.5;

%% 5 year bins
clear yearloss
start=year(min(date));
stop=year(max(date));
j=start:stop;

for i=1:5:numel(j)-5
    yearloss(i)=sum(loss(year(date)>=j(i) & year(date)<j(i+5)));
end
yearloss(142:146)=0;

%%
h=bar(j+2.5,yearloss,5);
xticks(1870:20:2010);
xticklabels(1870:20:2010);
a=gca;
a.FontSize=20;
yticks(5000:5000:35000);
yticklabels(5000:5000:35000);
ylim([0 35000]);
h.LineWidth=1;
a.TickDir = 'out';
set(a, 'box', 'off');
txt = sprintf('Damage caused by extreme floods in Europe\n1870-2016, Paprotny et al. 2017');
text(1873,32000,txt,'FontSize',28)
xlabel('Year','FontSize',24)
ylabel('Million €','FontSize',24)
a.LineWidth=1.5;

%% Germany
clear all
opts = spreadsheetImportOptions("NumVariables", 20);

% Specify sheet and range
opts.Sheet = "EventList";
opts.DataRange = "A2:T1565";

% Specify column names and types
opts.VariableNames = ["No", "Code", "Year", "Countryname", "Startdate", "Enddate", "Type", "Floodsource", "Regionsaffected", "Areafloodedkm2", "Fatalities", "Personsaffected", "Lossesnominalvalue", "Lossesoriginalcurrency", "LossesmlnEUR2011", "Cause", "Notes", "Sources", "VarName19", "VarName20"];
opts.VariableTypes = ["double", "categorical", "double", "categorical", "datetime", "datetime", "categorical", "string", "string", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "categorical", "string", "string"];
opts = setvaropts(opts, [8, 9, 17, 19, 20], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 4, 7, 8, 9, 14, 16, 17, 18, 19, 20], "EmptyFieldRule", "auto");

% Import the data
Eventsfloods = readtable("C:\Users\kemter\Downloads\Events_floods.xlsx", opts, "UseExcel", false);
clear opts

%%
GER=Eventsfloods(Eventsfloods.Countryname=='Germany',:);
date=datetime(GER.VarName19);
loss=GER.LossesmlnEUR2011;
date(isnan(loss))=[];
loss(isnan(loss))=[];
[date,idx]=sort(date);
loss=loss(idx);

%% 1 year bins
start=year(min(date));
stop=year(max(date));
j=start:stop;
for i=1:1:numel(j)
    yearloss(i)=sum(loss(year(date)==j(i)));
end
    
%%
h=bar(j,yearloss,1);
xticks(1870:20:2010);
xticklabels(1870:20:2010);
a=gca;
a.FontSize=20;
yticks(2000:2000:10000);
yticklabels(2000:2000:10000);
ylim([0 11000]);
xlim([1890 2020]);
h.LineWidth=1;
a.TickDir = 'out';
set(a, 'box', 'off');
txt = sprintf('Damage caused by extreme floods in Germany\n1890-2016, Paprotny et al. 2017');
text(1892,10000,txt,'FontSize',28)
xlabel('Year','FontSize',24)
ylabel('Millions of €','FontSize',24)
a.LineWidth=1.5;

%% 5 year bins
clear yearloss
start=year(min(date));
stop=year(max(date));
j=start:stop;

for i=1:5:numel(j)-5
    yearloss(i)=sum(loss(year(date)>=j(i) & year(date)<j(i+5)));
end
yearloss(132:136)=0;

%%
h=bar(j+2.5,yearloss,5);
xticks(1890:20:2010);
xticklabels(1890:20:2010);
a=gca;
a.FontSize=20;
yticks(2000:2000:10000);
yticklabels(2000:2000:10000);
ylim([0 11000]);
xlim([1890 2020]);
h.LineWidth=1;
a.TickDir = 'out';
set(a, 'box', 'off');
txt = sprintf('Damage caused by extreme floods in Germany\n1870-2016, Paprotny et al. 2017');
text(1892,10000,txt,'FontSize',28)
xlabel('Year','FontSize',24)
ylabel('Million €','FontSize',24)
a.LineWidth=1.5;

%% Map
clear all
gx=geoaxes('Basemap','landcover');
geoplot(gx,[33 34],[-20 -21]);
geolimits(gx,[36.000 58],[-11 31]);
gx.Basemap = 'colorterrain';
gx.FontSize=18;
txt1 = sprintf('Arno 1966\n12 Billion €');
a1=annotation('textbox',[.48 .28 .05 .05],'String',txt1,'FontSize',14,'FitBoxToText','on');
a1.BackgroundColor='w';
a1.FaceAlpha=0.75;
txt2 = sprintf('Nervión 1983\n12 Billion €');
a2=annotation('textbox',[.34 .285 .05 .05],'String',txt2,'FontSize',14,'FitBoxToText','on');
a2.BackgroundColor='w';
a2.FaceAlpha=0.75;
txt3 = sprintf('Elbe 2002\n10 Billion €');
a3=annotation('textbox',[.57 .58 .05 .05],'String',txt3,'FontSize',14,'FitBoxToText','on');
a3.BackgroundColor='w';
a3.FaceAlpha=0.75;
txt4 = sprintf('Italy 1973\n8 Billion €');
a4=annotation('textbox',[.58 .25 .05 .05],'String',txt4,'FontSize',14,'FitBoxToText','on');
a4.BackgroundColor='w';
a4.FaceAlpha=0.75;
txt5 = sprintf('Po 1951\n8 Billion €');
a5=annotation('textbox',[.53 .36 .05 .05],'String',txt5,'FontSize',14,'FitBoxToText','on');
a5.BackgroundColor='w';
a5.FaceAlpha=0.75;
txt6 = sprintf('Danube 2013\n6 Billion €');
a6=annotation('textbox',[.54 .505 .05 .05],'String',txt6,'FontSize',14,'FitBoxToText','on');
a6.BackgroundColor='w';
a6.FaceAlpha=0.75;
txt7 = sprintf('Oder 1997\n5 Billion €');
a7=annotation('textbox',[.578 .653 .05 .05],'String',txt7,'FontSize',14,'FitBoxToText','on');
a7.BackgroundColor='w';
a7.FaceAlpha=0.75;