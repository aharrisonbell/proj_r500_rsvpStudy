function plx500pop_paper(monkeyname,sheetname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500pop_paper(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Aug 2008
% Performs population analysis on RSVP500-series data
% Automatically imports list from Excel Spreadsheet with file/sheet name
% listed in generate_hmi_configplex
% monkeyname (optional) = name used for figure output (default: Stewie)
% sheetname (optional) = name of the sheet within the default excel file
% that contains the list of neurons to be analyzed.  note that it MUST have
% the same structure (i.e., column headers) as the default sheet (DMS
% Cells)

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=[500]; % list of paradigm numbers 
if nargin==0, monkeyname = 'Stewie'; sheetname='RSVP Cells_S';
elseif nargin==1, sheetname='RSVP Cells_S'; end
hmiconfig.monkeyname=monkeyname;

%%% FILTER DEFAULTS
filter.quality=1; % select only neurons with this value or above
filter.sensory={'Sensory','Inhibited'}; % {'Sensory','Non-Responsive','Inhibited'}; % select only neurons confirmed with this value


disp('************************************************************************')
disp('* plx500pop_paper.m - Analysis program for neuronal data from RSVP500  *')
disp('*   datafiles.  This program scans the Excel spreadsheet and loads the *')
disp('*   individual file data.  It then constructs population figures.      *')
disp('* N.B. plx500 & plx500_LFPs must be run prior to running this program  *')
disp('************************************************************************')

%%% LOAD FILES
junk=find(hmiconfig.excelfile==filesep);
excelname=hmiconfig.excelfile(junk(end)+1:end);
disp(['Scanning ',excelname,'(',sheetname,')'])
[allunits,unit_index]=loadfileinfo(hmiconfig,sheetname);
numunits=size(allunits,2);
disp(['..found ',num2str(numunits),' units'])
disp('..creating new unit names...')
for un=1:numunits,
    junk=char(allunits(un).PlxFile);
    allunits(un).NewUnitName=[junk(1:end-4),'-',char(allunits(un).UnitName)];
end
disp('Done.')
disp(' ')

%%% FILTER UNITS
% This is where one can enter criteria to select subpopulations of neurons
% for future analysis
quality_filter=find(unit_index.Quality>=filter.quality);
sensory_filter=find(ismember(unit_index.SensoryConf,filter.sensory)==1);
allfilters=intersect(quality_filter,sensory_filter);
units=allunits(allfilters);
numunits=size(units,2);

%%% FIGURES
disp('*** Figure 1 - Population responses for all neurons ***')
figure; clf; cla;
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
set(gcf,'Units','Normalized'); set(gcf,'Position',[0.3 0.1 0.3 0.8]); set(gca,'FontName','Arial');

% load units and prepare plotdata matrices
for un=1:numunits,
    load([hmiconfig.rsvp500spks,units(un).NewUnitName(1:20),'-500responsedata.mat']);
    fig1Adata(un,2:101)=respstructsingle.m_epoch1;
    fig1Bdata(un,2:101)=respstructsingle.m_epoch1_nobase;
    fig1Cdata(un,2:7)=respstructsingle.cat_si(:,2)'; % category SI, for mean metric
    % paste AP index
    tempind=char(respstructsingle.APIndex);
    fig1Adata(un,1)=str2num(tempind(2:end));
    fig1Bdata(un,1)=str2num(tempind(2:end));
    fig1Cdata(un,1)=str2num(tempind(2:end));
    clear respstructsingle tempind
end

% sort units according to A/P index
temp1Adata=sortrows(fig1Adata,1); 
temp1Bdata=sortrows(fig1Bdata,1); 
temp1Cdata=sortrows(fig1Cdata,1); 
indices=temp1Adata(:,1); 
plot1Adata=temp1Adata(:,2:end);
plot1Bdata=temp1Bdata(:,2:end);
plot1Cdata=temp1Cdata(:,2:end);

% normalize data
for un=1:size(plot1Adata,1),
    plot1Adata(un,:)=plot1Adata(un,:)/max(plot1Adata(un,:));
    plot1Bdata(un,:)=plot1Bdata(un,:)/max(plot1Bdata(un,:));
end
%% try normalizing to baseline.


% find AP levels
[ind,lvls,ids]=unique(indices); ind(end+1)=NaN;

subplot(3,2,[1 3])
hold on
pcolor(1:100,1:size(plot1Adata,1),plot1Adata)
shading flat; % colorbar('SouthOutside');
for ap=1:length(lvls),
    plot([1 100],[lvls(ap) lvls(ap)],'k-','LineWidth',1)
    text(102,lvls(ap),num2str(ind(ap+1)),'FontSize',fontsize_sml)
end
plot([20 20],[0 size(plot1Adata,1)],'k-','LineWidth',1)
plot([40 40],[0 size(plot1Adata,1)],'k-','LineWidth',1)
plot([60 60],[0 size(plot1Adata,1)],'k-','LineWidth',1)
plot([80 80],[0 size(plot1Adata,1)],'k-','LineWidth',1)
set(gca,'FontSize',7); box off; axis ij; ylim([0 size(plot1Adata,1)]);
xlim([1 100]); set(gca,'XTick',[10 30 50 70 90],'XTickLabel',{'Faces','Fruit','Places','Bodyparts','Objects'})
set(gca,'YTick',[1 size(plot1Adata,1)])
ylabel('Neuron Number (sorted according to A/P distance)','FontSize',fontsize_med)
xlabel('Stimulus Identity','FontSize',fontsize_med)
title({['Population: ',sheetname],'(Normalized Mean Spden 50-300ms)'},'Interpreter','none','FontSize',fontsize_lrg,'FontWeight','Bold')

subplot(3,2,[2 4])
hold on
pcolor(1:100,1:size(plot1Bdata,1),plot1Bdata)
shading flat; % colorbar('SouthOutside');
for ap=1:length(lvls),
    plot([1 100],[lvls(ap) lvls(ap)],'k-','LineWidth',1)
    text(102,lvls(ap),num2str(ind(ap+1)),'FontSize',fontsize_sml)
end
plot([20 20],[0 size(plot1Bdata,1)],'k-','LineWidth',1)
plot([40 40],[0 size(plot1Bdata,1)],'k-','LineWidth',1)
plot([60 60],[0 size(plot1Bdata,1)],'k-','LineWidth',1)
plot([80 80],[0 size(plot1Bdata,1)],'k-','LineWidth',1)
set(gca,'FontSize',7); box off; axis ij; ylim([0 size(plot1Bdata,1)]);
xlim([1 100]); set(gca,'XTick',[10 30 50 70 90],'XTickLabel',{'Faces','Fruit','Places','Bodyparts','Objects'})
set(gca,'YTick',[1 size(plot1Bdata,1)])
ylabel('Neuron Number (sorted according to A/P distance)','FontSize',fontsize_med)
xlabel('Stimulus Identity','FontSize',fontsize_med)
title('(Normalized Mean Spden 50-300ms, baseline removed)','FontSize',fontsize_lrg,'FontWeight','Bold')

subplot(3,1,3)
for i=1:length(ind)-1,
    pointer=find(ids==i);
    [data(i,1),datasem(i,1)]=mean_sem(plot1Cdata(pointer,1));
    [data(i,2),datasem(i,2)]=mean_sem(plot1Cdata(pointer,2));
    [data(i,3),datasem(i,3)]=mean_sem(plot1Cdata(pointer,3));
    [data(i,4),datasem(i,4)]=mean_sem(plot1Cdata(pointer,4));
    [data(i,5),datasem(i,5)]=mean_sem(plot1Cdata(pointer,5));
    [data(i,6),datasem(i,6)]=mean_sem(plot1Cdata(pointer,6));
end
hold on
errorbar(ind(1:end-1),data(:,1),datasem(:,1),'r-')
errorbar(ind(1:end-1),data(:,2),datasem(:,2),'m-')
errorbar(ind(1:end-1),data(:,3),datasem(:,3),'b-')
errorbar(ind(1:end-1),data(:,4),datasem(:,4),'y-')
errorbar(ind(1:end-1),data(:,5),datasem(:,5),'g-')
errorbar(ind(1:end-1),data(:,6),datasem(:,6),'k-')
%title('Category Selectivity','FontSize',fontsize_lrg,'FontSize','Bold')
set(gca,'FontSize',7); ylabel('Selectivity Index','FontSize',fontsize_med)
xlabel('Distance from interaural axis (mm)','FontSize',fontsize_med)
jpgfigname=[hmiconfig.rsvpanal,'RSVP_allneurons.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_allneurons.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)




%%% NESTED FUNCTIONS %%%
function [units,unitsx]=loadfileinfo(hmiconfig,sheetname)
%%% LOAD DATA
[crap,unitsx.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B5:B800'); % alpha, PlexonFilename
[crap,unitsx.UnitName]=xlsread(hmiconfig.excelfile,sheetname,'C5:C800'); % alpha, Unitname
%[crap,unitsx.UnitMatch]=xlsread(hmiconfig.excelfile,sheetname,'D5:D800'); % alpha, Unitmatch
[crap,unitsx.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,'E5:E800'); % alphanumeric, GridLocation
unitsx.Depth=xlsread(hmiconfig.excelfile,sheetname,'F5:F800'); % numeric, Depth
[crap,unitsx.APIndex]=xlsread(hmiconfig.excelfile,sheetname,'G5:G800'); % alphanumeric, APIndex
[crap,unitsx.EstimatedLocation]=xlsread(hmiconfig.excelfile,sheetname,'H5:H800'); % alphanumeric, Estimated Location
[crap,unitsx.SensoryAuto]=xlsread(hmiconfig.excelfile,sheetname,'I5:I800'); % alpha, Sensory, automated
[crap,unitsx.SensoryConf]=xlsread(hmiconfig.excelfile,sheetname,'J5:J800'); % alpha, Sensory, confirmed
[crap,unitsx.CategoryAuto]=xlsread(hmiconfig.excelfile,sheetname,'K5:K800'); % alpha, Sensory, automated
[crap,unitsx.CategoryConf]=xlsread(hmiconfig.excelfile,sheetname,'L5:L800'); % alpha, Sensory, confirmed
[crap,unitsx.SelectiveAuto]=xlsread(hmiconfig.excelfile,sheetname,'M5:M800'); % alpha, Selective, automated
[crap,unitsx.SelectiveConf]=xlsread(hmiconfig.excelfile,sheetname,'N5:N800'); % alpha, Selective, confirmed
[crap,unitsx.ExciteAuto]=xlsread(hmiconfig.excelfile,sheetname,'O5:O800'); % alpha, Excite/Inhibit, automated
[crap,unitsx.ExciteConf]=xlsread(hmiconfig.excelfile,sheetname,'P5:P800'); % alpha, Excite/Inhibit, confirmed
unitsx.Quality=xlsread(hmiconfig.excelfile,sheetname,'Q5:Q800'); % numeric

%%% RESHUFFLE STRUCTURE AND SAVE INDIVIDUAL LOCATION FILES
for un=1:length(unitsx.PlxFile),
    units(un).PlxFile=unitsx.PlxFile(un);
    units(un).UnitName=unitsx.UnitName(un);
    units(un).GridLoc=unitsx.GridLoc(un);
    units(un).Depth=unitsx.Depth(un);
    units(un).APIndex=unitsx.APIndex(un);
    units(un).EstimatedLocation=unitsx.EstimatedLocation(un);
    units(un).SensoryAuto=unitsx.SensoryAuto(un);
    units(un).SensoryConf=unitsx.SensoryConf(un);
    units(un).CategoryAuto=unitsx.CategoryAuto(un);
    units(un).CategoryConf=unitsx.CategoryConf(un);
    units(un).SelectiveAuto=unitsx.SelectiveAuto(un);
    units(un).SelectiveConf=unitsx.SelectiveConf(un);
    units(un).ExciteAuto=unitsx.ExciteAuto(un);
    units(un).ExciteConf=unitsx.ExciteConf(un);
    units(un).Quality=unitsx.Quality(un);
end
return