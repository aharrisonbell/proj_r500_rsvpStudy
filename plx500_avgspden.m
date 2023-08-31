function plx500_avgspden(monkeyname,sheetname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_avgspden(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, June 2008
% Generates population spike density functions and scatter plots for
% neurons in the RSVP500-series tasks.  Automatically imports list from
% Excel Spreadsheet with file/sheet name listed in the generate_hmi_configplex.m
% monkeyname = name used for figure output
% sheetname (optional) = name of the sheet within the default excel file
% that contains the list of neurons to be analyzed.  note that it MUST have
% the same structure (i.e., column headers) as the default sheet

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0,
    monkeyname = 'Stewie';
    sheetname='RSVP Cells_S';
elseif nargin==1,
    sheetname='RSVP Cells_S';
end
hmiconfig.monkeyname=monkeyname;
filter.quality=0; % must be at least this number to be included
normalize=0; % 0=don't normalize, 1=normalize
yscale=[0 1];
xscale=[-300 400];
xrange=(1000+xscale(1)):(1000+xscale(end));
reload=0;

disp('plx500_avgspden.m')
disp('*****************')
%%% LOAD FILEINFO
disp('Loading file info from excel spreadsheet...')
[units,unitsx,apindex]=loadfileinfo(hmiconfig,sheetname);
numunits=size(units,2);
disp('Done.')
disp(' ')

%%% Average Spike Density functions per A/P index
if reload==1,
    load('avg_graphs');
    apindices=unique(apindex); % unique Ap indices
else
    apindices=unique(apindex); % unique Ap indices
    avg_graphs=struct('faces',zeros(1,5000),'fruit',zeros(1,5000),...
        'places',zeros(1,5000),'bparts',zeros(1,5000),'objects',zeros(1,5000));
    for ap=1:length(apindices),
        apunits1=find(unitsx.APdistance==apindices(ap));
        %%% APPLY ADDITIONAL FILTERS
        apunits=find(strcmp(unitsx.Sensory(apunits1),'Sensory')==1); % units must be sensory
        if isempty(apunits)~=1,
            for un=1:length(apunits),
                junk=char(units(apunits(un)).PlxFile);
                load([hmiconfig.output_dir,junk(1:end-4),'-500graphdata.mat']); % loads structure called GRAPHSTRUCT
                for ch=1:size(graphstruct,2), % scroll through each unit in graphstruct to find match
                    if strcmp({[units(apunits(un)).NewUnitName,'.mat']},graphstruct(ch).label)==1,
                        avg_graphs(ap).faces(un,:)= graphstruct(ch).faces_avg;
                        avg_graphs(ap).fruit(un,:)= graphstruct(ch).fruit_avg;
                        avg_graphs(ap).places(un,:)=graphstruct(ch).places_avg;
                        avg_graphs(ap).bparts(un,:)=graphstruct(ch).bodyp_avg;
                        avg_graphs(ap).objects(un,:)=graphstruct(ch).objct_avg;
                        clear graphstruct
                        break
                    end
                end
            end
        end
    end
    save('avg_graphs','avg_graphs')
end

figure
for sp=1:size(avg_graphs,2),
    subplot(4,4,sp)
    [spdata,numunits]=prep_avg_graph(avg_graphs(sp),normalize);
    if numunits==0, continue; end;
    hold on
    plot(xscale(1):xscale(2),spdata(1,xrange),'r-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(2,xrange),'m-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(3,xrange),'b-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(4,xrange),'y-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(5,xrange),'g-','LineWidth',1.5)
    xlim(xscale); xlabel('Time from stimulus onset (ms)','FontSize',7)
    if normalize==1, ylabel('Normalized Activity','FontSize',7); else ylabel('sp/s','FontSize',7); end
    title(['AP Index: ',num2str(apindices(sp)),'mm (n=',num2str(numunits),')'],'FontSize',10,'FontWeight','Bold')
    set(gca,'FontSize',7);
end



%%% Average LFP per grid location
if reload==1,
    load('grid_traces');
    load('grid_data');
else
    gdindices=unique(unitsx.GridLoc); % unique Ap indices
    gd_traces=struct('faces',zeros(1,601),'fruit',zeros(1,601),...
        'places',zeros(1,601),'bparts',zeros(1,601),'objects',zeros(1,601));
    for gd=1:length(gdindices),
        disp(['...loading sites from grid location ',char(gdindices(gd))])
        %%% APPLY FILTERS
        gd_filt=find(strcmp(unitsx.GridLoc,gdindices(gd))==1);
        gridunits=intersect(gd_filt,filterlist);
        if isempty(gridunits)~=1, % does it exist?
            for un=1:length(gridunits),
                junk=char(units(gridunits(un)).PlxFile);
                load([hmiconfig.output_dir,junk(1:end-4),'-500graphdata.mat']); % loads structure called GRAPHSTRUCT
%                 for ch=1:size(graphstruct,2), % scroll through each unit in graphstruct to find match
%                     if strcmp({[units(apunits(un)).NewUnitName,'.mat']},graphstruct(ch).label)==1,
%                         avg_graphs(ap).faces(un,:)= graphstruct(ch).faces_avg;
%                         avg_graphs(ap).fruit(un,:)= graphstruct(ch).fruit_avg;
%                         avg_graphs(ap).places(un,:)=graphstruct(ch).places_avg;
%                         avg_graphs(ap).bparts(un,:)=graphstruct(ch).bodyp_avg;
%                         avg_graphs(ap).objects(un,:)=graphstruct(ch).objct_avg;
%                         clear graphstruct
%                         break
%                     end
%                 end
%                 % Load average traces
%                 grid_traces(gd).faces(un,:)  =lfpstruct_single.lfp_average(1,:);
%                 grid_traces(gd).fruit(un,:)  =lfpstruct_single.lfp_average(2,:);
%                 grid_traces(gd).places(un,:) =lfpstruct_single.lfp_average(3,:);
%                 grid_traces(gd).bparts(un,:) =lfpstruct_single.lfp_average(4,:);
%                 grid_traces(gd).objects(un,:)=lfpstruct_single.lfp_average(5,:);
%                 % Load average data
%                 grid_data(gd).min_epoch1(un,1:5)=lfpstruct_single.min_avg(:,1);
%                 grid_data(gd).min_epoch2(un,1:5)=lfpstruct_single.min_avg(:,3);
%                 grid_data(gd).max_epoch1(un,1:5)=lfpstruct_single.max_avg(:,1);
%             end
%             clear lfpstruct_single
        end
    end
    save('grid_traces','grid_traces')
    save('grid_data','grid_data')
end

figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.8 0.8])
set(gca,'FontName','Arial')
for sp=1:size(grid_traces,2),
    subplot(4,4,sp)
    [spdata,numunits]=prep_avg_graph(grid_traces(sp),normalize);
    if numunits==0, continue; end;
    hold on
    plot(xscale(1):xscale(2),spdata(1,:),'r-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(2,:),'m-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(3,:),'b-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(4,:),'y-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(5,:),'g-','LineWidth',1.5)
    plot(xscale,[0 0],'k-','LineWidth',0.5)
    xlim(xscale); xlabel('Time from stimulus onset (ms)','FontSize',7)
    if normalize==1, ylabel('Normalized Activity','FontSize',7); else ylabel('sp/s','FontSize',7); end
    set(gca,'YDir','reverse'); h=axis; plot([0 0],[h(3) h(4)],'k:');
    title([char(gdindices(sp)),' (n=',num2str(numunits),')'],'FontSize',10,'FontWeight','Bold')
    set(gca,'FontSize',7);
end

figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.5 0.8])
set(gca,'FontName','Arial')
for sp=1:size(grid_traces,2),
    subplot(4,4,sp)
    bar(1:3,[mean(grid_data(sp).min_epoch1);mean(grid_data(sp).min_epoch2);mean(grid_data(sp).max_epoch1)],'group')
    h=axis;
    data=reshape(grid_data(sp).min_epoch1,1,size(grid_data(sp).min_epoch1,1)*size(grid_data(sp).min_epoch1,2));
    id=[]; for i=1:(length(data)/5), id=[id,1:5]; end
    p=anova1(data,id,'off'); text(1,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    data=reshape(grid_data(sp).min_epoch2,1,size(grid_data(sp).min_epoch2,1)*size(grid_data(sp).min_epoch2,2));
    p=anova1(data,id,'off'); text(2,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    data=reshape(grid_data(sp).max_epoch1,1,size(grid_data(sp).max_epoch1,1)*size(grid_data(sp).max_epoch1,2));
    p=anova1(data,id,'off'); text(3,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    set(gca,'XTickLabel',{'min1','min2','max1'}); set(gca,'FontSize',7); ylabel('Voltage','FontSize',7);
    title([char(gdindices(sp))],'FontSize',10,'FontWeight','Bold')
end




    for ap=1:length(apindices),
        apunits1=find(unitsx.APdistance==apindices(ap));
        %%% APPLY ADDITIONAL FILTERS
        apunits=find(strcmp(unitsx.Sensory(apunits1),'Sensory')==1); % units must be sensory
        if isempty(apunits)~=1,
            for un=1:length(apunits),
                junk=char(units(apunits(un)).PlxFile);
               
            end
        end
    end
    save('avg_graphs','avg_graphs')
end

figure
for sp=1:size(avg_graphs,2),
    subplot(4,4,sp)
    [spdata,numunits]=prep_avg_graph(avg_graphs(sp),normalize);
    if numunits==0, continue; end;
    hold on
    plot(xscale(1):xscale(2),spdata(1,xrange),'r-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(2,xrange),'m-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(3,xrange),'b-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(4,xrange),'y-','LineWidth',1.5)
    plot(xscale(1):xscale(2),spdata(5,xrange),'g-','LineWidth',1.5)
    xlim(xscale); xlabel('Time from stimulus onset (ms)','FontSize',7)
    if normalize==1, ylabel('Normalized Activity','FontSize',7); else ylabel('sp/s','FontSize',7); end
    title(['AP Index: ',num2str(apindices(sp)),'mm (n=',num2str(numunits),')'],'FontSize',10,'FontWeight','Bold')
    set(gca,'FontSize',7);
end


%%% Average Spike Density functions per category


return



function [units,unitsx,apindices]=loadfileinfo(hmiconfig,sheetname)
%%% Create empty structures
units=struct('PlxFile',[],'UnitName',[],'GridLoc',[],'Depth',[],'APIndex',[],'EstimatedLocation',[],...
    'Sensory',[],'Category',[],'Selective',[],'Quality',[]);
unitsx=struct('PlxFile',[],'UnitName',[],'GridLoc',[],'Depth',[],'APIndex',[],'EstimatedLocation',[],...
    'Sensory',[],'Category',[],'Selective',[],'Quality',[]);
%%% LOAD DATA
[crap,unitsx.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B5:B600'); % alpha, PlexonFilename
[crap,unitsx.UnitName]=xlsread(hmiconfig.excelfile,sheetname,'C5:C600'); % alpha, Unitname
[crap,unitsx.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,'E5:E600'); % alphanumeric, Gridlocation
unitsx.Depth=xlsread(hmiconfig.excelfile,sheetname,'F5:F600'); % numeric, Depth
[crap,unitsx.APIndex]=xlsread(hmiconfig.excelfile,sheetname,'G5:G600'); % alphanumeric, APindex
[crap,unitsx.Sensory]=xlsread(hmiconfig.excelfile,sheetname,'J5:J600'); % alpha, Sensory
[crap,unitsx.Category]=xlsread(hmiconfig.excelfile,sheetname,'L5:L600'); % alpha, Category
[crap,unitsx.Selective]=xlsread(hmiconfig.excelfile,sheetname,'N5:N600'); % alpha, Selective
%unitsx.Quality=xlsread(hmiconfig.excelfile,sheetname,'Q5:Q600'); % numeric, Quality
%%% RESHUFFLE STRUCTURE AND SAVE INDIVIDUAL LOCATION FILES
apindices=[];
for un=1:length(unitsx.PlxFile),
    units(un).PlxFile=unitsx.PlxFile(un);
    units(un).UnitName=unitsx.UnitName(un);
    junk=char(units(un).PlxFile);
    units(un).NewUnitName=[junk(1:end-4),'-',char(units(un).UnitName)];
    unitsx.NewUnitName(un)={units(un).NewUnitName};
    units(un).GridLoc=unitsx.GridLoc(un);
    units(un).Depth=unitsx.Depth(un);
    units(un).APIndex=unitsx.APIndex(un);
    junk=char(units(un).APIndex);
    units(un).APdistance=str2num(junk(2:end));
    unitsx.APdistance(un)=str2num(junk(2:end));
    units(un).Sensory=unitsx.Sensory(un);
    units(un).Category=unitsx.Category(un);
    units(un).Selective=unitsx.Selective(un);
    %units(un).Quality=unitsx.Quality(un);
    apindices=[apindices;units(un).APdistance];
end
return

function [output,numunits]=prep_avg_graph(data,normalize)
numunits=size(data.faces,1);

if numunits>0,
    if normalize==0,
        if numunits>1,
            [output(1,:),output(6,:)]=mean_sem(data.faces);
            [output(2,:),output(7,:)]=mean_sem(data.fruit);
            [output(3,:),output(8,:)]=mean_sem(data.places);
            [output(4,:),output(9,:)]=mean_sem(data.bparts);
            [output(5,:),output(10,:)]=mean_sem(data.objects);
        else
            output(1,:)=data.faces;
            output(2,:)=data.fruit;
            output(3,:)=data.places;
            output(4,:)=data.bparts;
            output(5,:)=data.objects;
        end
    else
        if numunits>1,
            for un=1:numunits,
                maxes=[max(data.faces(un,:)) ...
                    max(data.fruit(un,:))...
                    max(data.places(un,:))...
                    max(data.bparts(un,:))...
                    max(data.objects(un,:))];
                normalizer=max(maxes);
                newdata_f(un,:)=data.faces(un,:)/normalizer;
                newdata_t(un,:)=data.fruit(un,:)/normalizer;
                newdata_p(un,:)=data.places(un,:)/normalizer;
                newdata_b(un,:)=data.bparts(un,:)/normalizer;
                newdata_o(un,:)=data.objects(un,:)/normalizer;
            end
            [output(1,:),output(6,:)]=mean_sem(newdata_f);
            [output(2,:),output(7,:)]=mean_sem(newdata_t);
            [output(3,:),output(8,:)]=mean_sem(newdata_p);
            [output(4,:),output(9,:)]=mean_sem(newdata_b);
            [output(5,:),output(10,:)]=mean_sem(newdata_o);
        else
            maxes=[max(data.faces) ...
                max(data.fruit)...
                max(data.places)...
                max(data.bparts)...
                max(data.objects)];
            normalizer=max(maxes);
            output(1,:)=data.faces/normalizer;
            output(2,:)=data.fruit/normalizer;
            output(3,:)=data.places/normalizer;
            output(4,:)=data.bparts/normalizer;
            output(5,:)=data.objects/normalizer;
        end
    end
else
    output=[];
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