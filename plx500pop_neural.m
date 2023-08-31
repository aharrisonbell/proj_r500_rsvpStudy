function plx500pop_neural(monkeyname,sheetname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500pop_neural(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Nov2007
% Generates population spike density functions and scatter plots
% for neurons in the RSVP500-series tasks.
% Automatically imports list from Excel Spreadsheet with file/sheet name
% listed in generate_hmi_configplex
% monkeyname = name used for figure output
% sheetname (optional) = name of the sheet within the default excel file
% that contains the list of neurons to be analyzed.  note that it MUST have
% the same structure (i.e., column headers) as the default sheet (DMS
% Cells)

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=[500]; % list of paradigm numbers 
if nargin==0, 
    monkeyname = 'Stewie';
    sheetname='RSVP Cells_S';
elseif nargin==1,
    sheetname='RSVP Cells_S';
end
hmiconfig.monkeyname=monkeyname;
filter.quality=0; % must be at least this number to be included
filter.APant=[15 21]; % boundary to be considered AIT
filter.APmid=[10 14]; % boundary to be considered CIT
filter.APpos=[3 9]; % boundary to be considered PIT
ranges.cue=[40 490]; % range over which cue magnitude is calculated
normalize=1; % 0=don't normalize, 1=normalize
yscale=[0 1];

junk=find(hmiconfig.excelfile==filesep);
excelname=hmiconfig.excelfile(junk(end)+1:end);
disp('plx500pop_neural.m')
disp('******************')
disp(['Loading units from ',excelname,'(',sheetname,')'])

%%%  LOAD FILEINFO
unitstemp=loadfileinfo(hmiconfig,sheetname);
numunits=size(unitstemp,2);
disp('Done.')
disp(' ')
disp('Creating new unit names...')
for un=1:numunits,
    junk=char(unitstemp(un).PlxFile);
    unitstemp(un).NewUnitName=[junk(1:end-4),'-',char(unitstemp(un).UnitName)];
end
disp(' ')
disp('Removing duplicates...')
%units=filterunits(unitstemp);
units=unitstemp;
numunits=size(units,2);
disp('Done.')
disp(' ')

%%% SPECIFY FILTER
disp('Current Filter Settings')
disp(['1 Quality: =>',num2str(filter.quality)]);
disp(['2 A/P Indices for AIT: ',num2str(filter.APant(1)),'-',num2str(filter.APant(2))])
disp(['3 A/P Indices for CIT: ',num2str(filter.APmid(1)),'-',num2str(filter.APmid(2))])
disp(['4 A/P Indices for PIT: ',num2str(filter.APpos(1)),'-',num2str(filter.APpos(2))])
disp(' ')
%choice=input('Would you like to use the default filter (1/0)?')
%if choice~=1,
%    error('Specify new defaults in the code.')
%end
%%% FINALIZE INDIVIDUAL LISTS
disp('Sorting neurons according to filter criteria...')
aitlist=[]; citlist=[]; pitlist=[]; alllist=[]; grids={}; apindices={};
%%% determine unique grid locations
for un=1:size(units,2),
    grids(un)=units(un).GridLoc;
    apindices(un)=units(un).APIndex;
end
uniquegrids=unique(grids); uniqueap=unique(apindices);

for un=1:numunits,
    junk=char(units(un).APIndex);
    APindex=str2num(junk(2:end)); % converts string to number
    %if units(un).Quality>=filter.quality & strcmp(units(un).Sensory,'Yes')==1, % select only 'quality sensory' neurons
    if units(un).Quality>=filter.quality==1, % select only 'quality sensory' neurons
        %%% Add unit to AIT list
        if APindex>=filter.APant(1) & APindex<=filter.APant(2), % APindex falls within range
            %disp([units(un).NewUnitName,' being added to AIT list'])
            aitlist=[aitlist;units(un).NewUnitName];
        end
        %%% Add unit to CIT list
        if APindex>=filter.APmid(1) & APindex<=filter.APmid(2), % APindex falls within range
            %disp([units(un).NewUnitName,' being added to CIT list'])
            citlist=[citlist;units(un).NewUnitName];
        end
        %%% Add unit to PIT list
        if APindex>=filter.APpos(1) & APindex<=filter.APpos(2), % APindex falls within range
            %disp([units(un).NewUnitName,' being added to PIT list'])
            pitlist=[pitlist;units(un).NewUnitName];
        end
        %%% Add unit to ALL list
        alllist=[alllist;units(un).NewUnitName];
    end
end

%%% DISPLAY LISTS FOR USER
disp('Neurons included in Anterior IT analysis')
aitlist
disp('Neurons included in Middle IT analysis')
citlist
disp('Neurons included in Posterior IT analysis')
pitlist

%%% GENERATE FIGURES
% neuron distributions
allpie=calcdist(alllist,units);
aitpie=calcdist(aitlist,units);
citpie=calcdist(citlist,units);
pitpie=calcdist(pitlist,units);

figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.05 0.1 0.9 0.8])
set(gca,'FontName','Arial')
subplot(1,4,1) % all neurons
pie(allpie(1:end-1))
title({hmiconfig.monkeyname,['All Neurons (n=',num2str(size(alllist,1)),')']})
legend('Faces','BodyP','Fruit','Objct','Place','Inhib','Location','SouthEast')
subplot(1,4,2) % ait neurons
pie(aitpie(1:end-1))
title({['Anterior IT Neurons (n=',num2str(size(aitlist,1)),')'],'A15-A21mm'})
subplot(1,4,3) % cit neurons
pie(citpie(1:end-1))
title({['Middle IT Neurons (n=',num2str(size(citlist,1)),')'],'A10-A14mm'})
subplot(1,4,4) % pit neurons
pie(pitpie(1:end-1))
title({['Posterior IT Neurons (n=',num2str(size(pitlist,1)),')'],'A3-A9mm'})
matfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpdist.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpdist.jpg'];
illfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpdist.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end


%%% grid figures
%%% determine unique grid locations
grids={}; apindices={};
for un=1:size(units,2),
    grids(un)=units(un).GridLoc;
    apindices(un)=units(un).APIndex;
end
uniquegrids=unique(grids);
uniqueap=unique(apindices);

figure % 1 pie chart per grid location
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.05 0.1 0.9 0.8])
set(gca,'FontName','Arial')
numrows=ceil(length(uniquegrids)/4);
for p=1:length(uniquegrids),
    subplot(numrows,4,p)
    %%% create list
    templist=[];
    for un=1:numunits,
        if units(un).Quality>=filter.quality==1, % select only 'quality sensory' neurons
            %%% Add unit to  list
            if strcmp(units(un).GridLoc,uniquegrids(p))==1,
                templist=[templist;units(un).NewUnitName];
            end
        end
    end
    templist
    temppie=calcdist(templist,units);
    pie(temppie)
    title(strcat(char(uniquegrids(p)),' (n=',num2str(sum(temppie)),')'))
    legend('Faces','BodyP','Fruit','Objct','Place','Inhib','Non-R','Location','SouthEast')
end
matfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniquegrids.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniquegrids.jpg'];
illfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniquegrids.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end

figure % 1 pie chart per APindex
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.05 0.1 0.9 0.8])
set(gca,'FontName','Arial')
numrows=ceil(length(uniqueap)/4);
for p=1:length(uniqueap),
    subplot(numrows,4,p)
    %%% create list
    templist=[];
    for un=1:numunits,
        if units(un).Quality>=filter.quality==1, % select only 'quality sensory' neurons
            %%% Add unit to  list
            if strcmp(units(un).APIndex,uniqueap(p))==1,
                templist=[templist;units(un).NewUnitName];
            end
        end
    end
    temppie=calcdist(templist,units);
    pie(temppie)
    title(strcat(char(uniqueap(p)),' (n=',num2str(sum(temppie)),')'))
    legend('Faces','BodyP','Fruit','Objct','Place','Inhib','Non-R','Location','SouthEast')
end
matfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniqueAP.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniqueAP.jpg'];
illfigname=[hmiconfig.figure_dir,'rsvp500',filesep,hmiconfig.monkeyname,'_rsvpuniqueAP.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return





%%% NESTED FUNCTIONS %%%
function units=loadfileinfo(hmiconfig,sheetname)
%%% Create empty structures
units=struct('PlxFile',[],'UnitName',[],'GridLoc',[],'Depth',[],'APIndex',[],'EstimatedLocation',[],...
    'Sensory',[],'Category',[],'Selective',[],'Quality',[]);
unitsx=struct('PlxFile',[],'UnitName',[],'GridLoc',[],'Depth',[],'APIndex',[],'EstimatedLocation',[],...
    'Sensory',[],'Category',[],'Selective',[],'Quality',[]);

%%% LOAD DATA
[crap,unitsx.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B5:B600'); % alpha, PlexonFilename
[crap,unitsx.UnitName]=xlsread(hmiconfig.excelfile,sheetname,'C5:C600'); % alpha, Unitname
%[crap,unitsx.UnitMatch]=xlsread(hmiconfig.excelfile,sheetname,'D5:D600'); % alpha, Unitmatch
[crap,unitsx.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,'E5:E600'); % alphanumeric
unitsx.Depth=xlsread(hmiconfig.excelfile,sheetname,'F5:F600'); % numeric
[crap,unitsx.APIndex]=xlsread(hmiconfig.excelfile,sheetname,'G5:G600'); % alphanumeric
[crap,unitsx.EstimatedLocation]=xlsread(hmiconfig.excelfile,sheetname,'H5:H600'); % alphanumeric
[crap,unitsx.Sensory]=xlsread(hmiconfig.excelfile,sheetname,'J5:J600'); % alpha
[crap,unitsx.Category]=xlsread(hmiconfig.excelfile,sheetname,'L5:L600'); % alpha
[crap,unitsx.Selective]=xlsread(hmiconfig.excelfile,sheetname,'N5:N600'); % alpha
unitsx.Quality=xlsread(hmiconfig.excelfile,sheetname,'O5:O600'); % numeric

%%% RESHUFFLE STRUCTURE AND SAVE INDIVIDUAL LOCATION FILES
for un=1:length(unitsx.PlxFile),
    units(un).PlxFile=unitsx.PlxFile(un);
    units(un).UnitName=unitsx.UnitName(un);
    units(un).UnitMatch=unitsx.UnitMatch(un);
    units(un).GridLoc=unitsx.GridLoc(un);
    units(un).Depth=unitsx.Depth(un);
    units(un).APIndex=unitsx.APIndex(un);
    units(un).EstimatedLocation=unitsx.EstimatedLocation(un);
    units(un).Sensory=unitsx.Sensory(un);
    units(un).Category=unitsx.Category(un);
    units(un).Selective=unitsx.Selective(un);
    units(un).Quality=unitsx.Quality(un);
end
return

function units=filterunits(data) % removes duplicates
numunits=size(data,2);
units=[]; unitnames={};
for un=1:numunits,
    %%% identify unique unitnames
    unitnames(un)={data(un).NewUnitName};
end
uniqueunits=unique(unitnames');

return

function output=calcdist(list,units)
%% function to calculate distribution of neuron selectivity
numunits=size(list,1);
face=0; fruit=0; place=0; object=0; bodypart=0; inhibitory=0; non=0; sensory=0;
for un=1:numunits,
    %%% find matching unit reference
    ref=find(strcmp({units.NewUnitName},{list(un,:)})==1);
    unitstuff=units(ref(1)); % defaults to the first duplicate
    if strcmp(unitstuff.Sensory,'Yes')==1,
        sensory=sensory+1;
        switch char(unitstuff.Category)
            case 'Faces'
                face=face+1;
            case 'Fruit'
                fruit=fruit+1;
            case 'Places'
                place=place+1;
            case 'Objects'
                object=object+1;
            case 'Bodyparts'
                bodypart=bodypart+1;
        end
    end
    if strcmp(unitstuff.Sensory,'No')==1, non=non+1; end
    if strcmp(unitstuff.Sensory,'Inhibitory')==1, inhibitory=inhibitory+1; end
end
output=[face bodypart fruit object place inhibitory non];
return