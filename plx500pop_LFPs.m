function plx500pop_LFPs(monkeyname,sheetname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500pop_LFPs(monkeyname,sheetname); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, July 2008, based on plex_analyze500_avgspden
% Generates population LFP traces and scatter plots for
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
    sheetname='RSVP_LFP_S';
elseif nargin==1,
    sheetname='RSVP_LFP_S';
end
hmiconfig.monkeyname=monkeyname;
filter.quality=2; % must be at least this number to be included
normalize=0; % 0=don't normalize, 1=normalize
yscale=[0 1];
xscale=[-200 400];
xrange=(1000+xscale(1)):(1000+xscale(end));
reload=0;

disp('plx500pop_LFPs.m')
disp('****************')
%%% LOAD FILEINFO
disp('Loading file info from excel spreadsheet...')
[units,unitsx,apindex]=loadfileinfo(hmiconfig,sheetname,filter);
disp('Done.')
disp(' ')
numunits=size(units,2);
in_filt=find(unitsx.Include==1); 
qu_filt=find(unitsx.Quality>=filter.quality);
filterlist=intersect(in_filt,qu_filt); % list of units to consider      

%%% Average LFP per A/P index
if reload==1,
    load('ap_traces');
    load('ap_data');
    apindices=unique(apindex); % unique Ap indices
else
    apindices=unique(apindex); % unique Ap indices
    ap_traces=struct('faces',zeros(1,601),'fruit',zeros(1,601),...
        'places',zeros(1,601),'bparts',zeros(1,601),'objects',zeros(1,601));
    for ap=1:length(apindices),
        disp(['...loading sites from A',num2str(apindices(ap)),'mm'])
        %%% APPLY FILTERS
        ap_filt=find(unitsx.APdistance==apindices(ap));
        apunits=intersect(ap_filt,filterlist);
        if isempty(apunits)~=1, % does it exist?
            for un=1:length(apunits),
                junk=char(units(apunits(un)).PlxFile);
                load([hmiconfig.rsvp500lfps,junk,'-500-',char(units(apunits(un)).ChanName),'.mat']); % loads structure called lfpstruct_single
                % Load average traces
                ap_traces(ap).faces(un,:)  =lfpstruct_single.lfp_average(1,:);
                ap_traces(ap).fruit(un,:)  =lfpstruct_single.lfp_average(2,:);
                ap_traces(ap).places(un,:) =lfpstruct_single.lfp_average(3,:);
                ap_traces(ap).bparts(un,:) =lfpstruct_single.lfp_average(4,:);
                ap_traces(ap).objects(un,:)=lfpstruct_single.lfp_average(5,:);
                % Load average data
                ap_data(ap).min_epoch1(un,1:5)=lfpstruct_single.min_avg(:,1);
                ap_data(ap).min_epoch2(un,1:5)=lfpstruct_single.min_avg(:,3);
                ap_data(ap).max_epoch1(un,1:5)=lfpstruct_single.max_avg(:,1);
            end
            clear lfpstruct_single
        end
    end
    save('ap_traces','ap_traces')
    save('ap_data','ap_data')
end

figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.5 0.8])
set(gca,'FontName','Arial')
for sp=1:size(ap_traces,2),
    subplot(4,4,sp)
    [spdata,numunits]=prep_avg_graph(ap_traces(sp),normalize);
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
    title(['AP Index: ',num2str(apindices(sp)),'mm (n=',num2str(numunits),')'],'FontSize',10,'FontWeight','Bold')
    set(gca,'FontSize',7);
    
    subplot(4,4,sp+8)
    bar(1:3,[mean(ap_data(sp).min_epoch1);mean(ap_data(sp).min_epoch2);mean(ap_data(sp).max_epoch1)],'group')
    h=axis;
    data=reshape(ap_data(sp).min_epoch1,1,size(ap_data(sp).min_epoch1,1)*size(ap_data(sp).min_epoch1,2));
    id=[]; for i=1:(length(data)/5), id=[id,1:5]; end
    p=anova1(data,id,'off'); text(1,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    data=reshape(ap_data(sp).min_epoch2,1,size(ap_data(sp).min_epoch2,1)*size(ap_data(sp).min_epoch2,2));
    p=anova1(data,id,'off'); text(2,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    data=reshape(ap_data(sp).max_epoch1,1,size(ap_data(sp).max_epoch1,1)*size(ap_data(sp).max_epoch1,2));
    p=anova1(data,id,'off'); text(3,h(4)*0.9,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    set(gca,'XTickLabel',{'min1','min2','max1'}); set(gca,'FontSize',7); ylabel('Voltage','FontSize',7);
    title(['AP Index: ',num2str(apindices(sp)),'mm (n=',num2str(numunits),')'],'FontSize',10,'FontWeight','Bold')
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
                load([hmiconfig.rsvp500lfps,junk,'-500-',char(units(gridunits(un)).ChanName),'.mat']); % loads structure called lfpstruct_single
                % Load average traces
                grid_traces(gd).faces(un,:)  =lfpstruct_single.lfp_average(1,:);
                grid_traces(gd).fruit(un,:)  =lfpstruct_single.lfp_average(2,:);
                grid_traces(gd).places(un,:) =lfpstruct_single.lfp_average(3,:);
                grid_traces(gd).bparts(un,:) =lfpstruct_single.lfp_average(4,:);
                grid_traces(gd).objects(un,:)=lfpstruct_single.lfp_average(5,:);
                % Load average data
                grid_data(gd).min_epoch1(un,1:5)=lfpstruct_single.min_avg(:,1);
                grid_data(gd).min_epoch2(un,1:5)=lfpstruct_single.min_avg(:,3);
                grid_data(gd).max_epoch1(un,1:5)=lfpstruct_single.max_avg(:,1);
            end
            clear lfpstruct_single
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
%%% Average Spike Density functions per category
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                NESTED FUNCTIONS                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [units,unitsx,apindices]=loadfileinfo(hmiconfig,sheetname,filter)
%%% Create empty structures
units=struct('PlxFile',[],'ChanName',[],'Include',[],'GridLoc',[],'Depth',[],'APIndex',[],'Quality',[]);
unitsx=struct('PlxFile',[],'ChanName',[],'Include',[],'GridLoc',[],'Depth',[],'APIndex',[],'Quality',[]);
%%% LOAD DATA
[crap,unitsx.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B4:B800'); % alpha, PlexonFilename
[crap,unitsx.ChanName]=xlsread(hmiconfig.excelfile,sheetname,'C4:C800'); % alpha, ChanName
unitsx.Include=xlsread(hmiconfig.excelfile,sheetname,'D4:D800'); % numeric, Include
[crap,unitsx.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,'E4:E800'); % alphanumeric, Gridlocation
unitsx.Depth=xlsread(hmiconfig.excelfile,sheetname,'F4:F800'); % numeric, Depth
[crap,unitsx.APIndex]=xlsread(hmiconfig.excelfile,sheetname,'G4:G800'); % alphanumeric, APindex
unitsx.Quality=xlsread(hmiconfig.excelfile,sheetname,'H4:H800'); % numeric, Quality
%%% RESHUFFLE STRUCTURE AND SAVE INDIVIDUAL LOCATION FILES
apindices=[];
for un=1:length(unitsx.PlxFile),
    units(un).PlxFile=unitsx.PlxFile(un);
    units(un).ChanName=unitsx.ChanName(un);
    junk=char(units(un).PlxFile);
    units(un).UnitName=[junk(1:end-4),'-',char(units(un).ChanName)];
    unitsx.UnitName(un)={units(un).UnitName};
    units(un).GridLoc=unitsx.GridLoc(un);
    units(un).Depth=unitsx.Depth(un);
    units(un).APIndex=unitsx.APIndex(un);
    junk=char(units(un).APIndex);
    units(un).APdistance=str2num(junk(2:end));
    unitsx.APdistance(un)=str2num(junk(2:end));
    units(un).Quality=unitsx.Quality(un);
    apindices=[apindices;units(un).APdistance];
    %disp(['...adding file ',units(un).UnitName])
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