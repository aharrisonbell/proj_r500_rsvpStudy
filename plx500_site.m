function plx500_site(files);
%%%%%%%%%%%%%%%%%%%%%%%
% plx500_site(files); %
%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept2007, based on plx500 & plx500_LFPs
% Produces figure comparing LFPs and Cell data for RSVP500
% (rsvp500f.tim, rsvp500s.tim)
% Incoming files must be run through plex_readnexfile and plex_makespikemat
% before analysis is possible
% files = optional argument, list files as strings.  Otherwise, program
% will load files listed in default analyze500.txt

%%% SETUP DEFAULTS
warning off;
close all
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=[500]; % list of paradigm numbers
xscale=-200:400; % default time window
channels={'LFP1','LFP2','LFP3','LFP4'};

anova=1; % 1=perform anovas, ~1=skip anova analysis
minsplatency=50; % minimum spike latencies

%%% CURRENT METRICS (used to define "response")
%% to add more epochs, make changes to RESPSTRUCT
spkepoch.baseline=[-200 50]; % window over which baseline response is calculated
spkepoch.epoch1=[50 300]; % early cue response window

%%%  LOAD FILE LIST
if nargin==0,
    include=xlsread(hmiconfig.plxlist,hmiconfig.sheet500,'A2:A800'); % alphanumeric, Gridlocation
    [crap,files]=xlsread(hmiconfig.plxlist,hmiconfig.sheet500,'B2:B800'); % numeric, Depth
    files=files(find(include==1));
    clear include
end

%%% ANALYZE INDIVIDUAL FILES
disp('**************************************************************************')
disp('* plx500_site.m - Analysis program for cells and LFPs data for RSVP500   *')
disp('*   datafiles.  This program will scan and analyze all the files flagged *')
disp('*   in the default filelist (specified in generate_hmi_configplex.m)     *')
disp('* N.B. plx500 & plx500_LFPs must be run prior to running this program    *')
disp('**************************************************************************')
for f=1:length(files), % perform following operations on each nex file listed
    close all
    filename=char(files(f));
    disp(['Loading channels from ',filename])
    load([hmiconfig.rsvp500spks,filename,'-500graphdata.mat']);
    load([hmiconfig.rsvp500spks,filename,'-500responsedata.mat']);
    foundunits=size(graphstruct,2);
    disp(['..found ',num2str(foundunits),' units...'])
    chancount=0;
    for ch=1:length(channels),
        lfpname=[hmiconfig.rsvp500lfps,filename,'-500-',char(channels(ch)),'.mat'];
        if exist(char(lfpname))==2,
            chancount=chancount+1;
        end
    end
    disp(['..found ',num2str(chancount),' LFP channels...'])
    %%% paste site number into each spikeset
    for un=1:foundunits,
        tempname=char(graphstruct(un).label);
        graphstruct(un).channo=str2num(tempname(19));
        channo(un)=str2num(tempname(19));
    end

    %%% generate basic figures (quantitative only)
    for ec=1:4, % scroll through each possible electrode position (4)
        neurons=0; lfp=0;
        disp(['Analyzing electrode channel ',num2str(ec),'...'])
        % does spike channel/LFP exist?
        units=find(channo==ec);
        if isempty(units)==0, neurons=1; end
        lfpname=[hmiconfig.rsvp500lfps,filename,'-500-',char(channels(ec)),'.mat'];
        if exist(char(lfpname))==2, lfp=1; end
        if neurons==1 & lfp==1,
            disp('..found both LFP and spike channels')
        else
            disp('..file does not contain both LFP and spike channels.  Skipping this channel...')
            continue
        end
        % graph spikes/LFPs
        load(lfpname)
        plotSpksLFPs(graphstruct(units),respstruct(units),lfpstruct_single,xscale,hmiconfig);
        plotCrrSpkLFP(respstruct(units),lfpstruct_single,xscale,hmiconfig);
    end
end
return

%%%%%%%%%% NESTED FUNCTIONS %%%%%%%%%%
function plotSpksLFPs(spikedata,unitdata,lfpdata,xscale,hmiconfig);
fontsize_sml=7;
fontsize_med=8;
fontsize_lrg=9;
figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.8 0.8])
set(gca,'FontName','Arial')
numunits=size(spikedata,2);
for pl=1:numunits,
    subplot(3,numunits+1,[pl numunits+1+pl])
    graphstruct=spikedata(pl); respstruct=unitdata(pl);
    xrange=(1000+xscale(1)):(1000+xscale(end));
    pcolor(xscale,1:100,graphstruct.allconds_avg(:,xrange))
    shading flat
    %caxis([10 90])
    hold on
    plot([xscale(1) xscale(end)],[21 21],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[41 41],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[61 61],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[81 81],'w-','LineWidth',1)
    plot([0 0],[0 100],'w:','LineWidth',1)
    colorbar('SouthOutside')
    text(401,graphstruct.bestconds(1)+0.5,['\leftarrow',num2str(graphstruct.bestconds(1))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstruct.bestconds(2)+20.5,['\leftarrow',num2str(graphstruct.bestconds(2))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstruct.bestconds(3)+40.5,['\leftarrow',num2str(graphstruct.bestconds(3))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstruct.bestconds(4)+60.5,['\leftarrow',num2str(graphstruct.bestconds(4))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstruct.bestconds(5)+80.5,['\leftarrow',num2str(graphstruct.bestconds(5))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(0,101.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
    text(xscale(1),101.5,num2str(xscale(1)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
    text(xscale(end),101.5,num2str(xscale(end)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
    set(gca,'FontSize',7); xlim([xscale(1) xscale(end)]); box off; axis off; axis ij; ylim([0 100]);
    signame=char(graphstruct.label);
    if pl==1,
        title({[signame(1:end-12),' - ',char(unitdata(1).gridlocation),' (',num2str(unitdata(1).depth),' um)'],signame(end-10:end-4)},...
            'FontSize',10,'FontWeight','Bold');
        text(xscale(1)-(abs(xscale(1))*.5),10,'Faces','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
        text(xscale(1)-(abs(xscale(1))*.5),30,'Fruit','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
        text(xscale(1)-(abs(xscale(1))*.5),50,'Places','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
        text(xscale(1)-(abs(xscale(1))*.5),70,'Bodyparts','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
        text(xscale(1)-(abs(xscale(1))*.5),90,'Objects','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    else
        title(signame(end-10:end-4),'FontSize',fontsize_lrg,'FontWeight','Bold');
    end
    subplot(3,numunits+1,pl+2*(numunits+1))
    hold on
    plot(xscale,spikedata(pl).faces_avg(xrange),'r-','LineWidth',2)
    plot(xscale,spikedata(pl).fruit_avg(xrange),'m-','LineWidth',2)
    plot(xscale,spikedata(pl).places_avg(xrange),'b-','LineWidth',2)
    plot(xscale,spikedata(pl).bodyp_avg(xrange),'y-','LineWidth',2)
    plot(xscale,spikedata(pl).objct_avg(xrange),'g-','LineWidth',2)
    h=axis;
    plot([0 0],[0 h(4)],'k:','LineWidth',0.5)
    plot([xscale(1) xscale(end)],[0 0],'k-')
    xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
    ylabel('sp/s','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); xlim([xscale(1) xscale(end)]); box off;
end
subplot(3,numunits+1,[numunits+1 2*(numunits+1)]) % plot LFP channel
pcolor(xscale,1:100,lfpdata.lfp_average*-1)
shading flat
caxis([-3 3])
hold on
plot([xscale(1) xscale(end)],[21 21],'w-','LineWidth',1)
plot([xscale(1) xscale(end)],[41 41],'w-','LineWidth',1)
plot([xscale(1) xscale(end)],[61 61],'w-','LineWidth',1)
plot([xscale(1) xscale(end)],[81 81],'w-','LineWidth',1)
plot([0 0],[0 100],'w:','LineWidth',1)
colorbar('SouthOutside')
text(0,101.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
text(xscale(1),101.5,num2str(xscale(1)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
text(xscale(end),101.5,num2str(xscale(end)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
set(gca,'FontSize',7); xlim([xscale(1) xscale(end)]); box off; axis off; axis ij; ylim([0 100]); set(gca,'ZDir','reverse');
title(lfpdata.label,'FontSize',fontsize_lrg,'FontWeight','Bold')

subplot(3,numunits+1,3*(numunits+1))
hold on
plot(xscale,lfpdata.cat_avg(1,:),'r-','LineWidth',2)
plot(xscale,lfpdata.cat_avg(2,:),'m-','LineWidth',2)
plot(xscale,lfpdata.cat_avg(3,:),'b-','LineWidth',2)
plot(xscale,lfpdata.cat_avg(4,:),'y-','LineWidth',2)
plot(xscale,lfpdata.cat_avg(5,:),'g-','LineWidth',2)
set(gca,'YDir','reverse'); h=axis; xlim([-200 400]); plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;

%matfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpsite.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpsite.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpsite.ai']
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return

function plotCrrSpkLFP(unitdata,lfpdata,xscale,hmiconfig);
fontsize_sml=7;
fontsize_med=8;
fontsize_lrg=9;
figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.5 0.8])
set(gca,'FontName','Arial')
numunits=size(unitdata,2);
for un=1:numunits,
    subplot(2,numunits,un)
    hold on
    polywin(1)=floor(min(unitdata(un).m_epoch1')); polywin(2)=ceil(max(unitdata(un).m_epoch1')); 
    polywin(3)=floor(min(lfpdata.trialepoch(:,1))); polywin(4)=ceil(max(lfpdata.trialepoch(:,1))); 
    [plotdata,rval1,p1,linefit]=corrSpkLFP(unitdata(un).m_epoch1',lfpdata.trialepoch(:,1),polywin);
    plot(plotdata(:,1),plotdata(:,2),'rs','MarkerFaceColor','r','MarkerSize',4)
    plot(polywin,linefit,'r-','LineWidth',1.5);
    h=get(gca); xadj=((h.XLim(2)-h.XLim(1))*.1)+h.XLim(1);
    polywin(1)=floor(min(unitdata(un).m_epoch1')); polywin(2)=ceil(max(unitdata(un).m_epoch1')); 
    polywin(3)=floor(min(lfpdata.trialepoch(:,2))); polywin(4)=ceil(max(lfpdata.trialepoch(:,2))); 
    [plotdata,rval2,p2,linefit]=corrSpkLFP(unitdata(un).m_epoch1',lfpdata.trialepoch(:,2),polywin);
    plot(plotdata(:,1),plotdata(:,2),'bs','MarkerFaceColor','b','MarkerSize',4)
    plot(polywin,linefit,'b-','LineWidth',1.5);
    h=get(gca); xadj=((h.XLim(2)-h.XLim(1))*.1)+h.XLim(1);
    polywin(1)=floor(min(unitdata(un).m_epoch1')); polywin(2)=ceil(max(unitdata(un).m_epoch1')); 
    polywin(3)=floor(min(lfpdata.trialepoch(:,3))); polywin(4)=ceil(max(lfpdata.trialepoch(:,3))); 
    [plotdata,rval3,p3,linefit]=corrSpkLFP(unitdata(un).m_epoch1',lfpdata.trialepoch(:,3),polywin);
    plot(plotdata(:,1),plotdata(:,2),'gs','MarkerFaceColor','g','MarkerSize',4)
    plot(polywin,linefit,'g-','LineWidth',1.5);
    h=get(gca); xadj=((h.XLim(2)-h.XLim(1))*.1)+min(h.XLim);
    xlabel('Spike Activity (sp/s)','FontSize',fontsize_med); ylabel('LFP Response','FontSize',fontsize_med);
    text(xadj,h.YLim(2)*.95,['r(min1)=',num2str(rval1,'%1.2g'),' (p=',num2str(p1,'%1.2g'),')'],'FontSize',fontsize_sml)
    text(xadj,h.YLim(2)*.85,['r(min2)=',num2str(rval2,'%1.2g'),' (p=',num2str(p2,'%1.2g'),')'],'FontSize',fontsize_sml)
    text(xadj,h.YLim(2)*.75,['r(max1)=',num2str(rval3,'%1.2g'),' (p=',num2str(p3,'%1.2g'),')'],'FontSize',fontsize_sml)
    set(gca,'FontSize',7); box off; axis square;
    signame=char(unitdata(un).label);
    if un==1,
        title({[signame(1:end-12),' - ',char(unitdata(1).gridlocation),' (',num2str(unitdata(1).depth),' um)'],signame(end-10:end-4)},...
            'FontSize',fontsize_lrg,'FontWeight','Bold');
    else
        title(signame(end-10:end-4),'FontSize',fontsize_lrg,'FontWeight','Bold');
    end
    subplot(2,numunits,numunits+un) % bargraph comparing
    u=unitdata(un).cat_si(2,1:5); l=lfpdata.cat_si';
    bar(1:5,[u;l]','grouped')
    set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','Pl','Bp','Ob'})
    legend('Spks','Min1','Min2','Max1')
    set(gca,'FontSize',7); axis square;
    ylabel('Selectivity Index','FontSize',fontsize_med)
end
%matfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpcorr.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpcorr.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500site',filesep,signame(1:end-13),'_rsvpcorr.ai']
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return

function [plotdata,rval,p,linefit]=corrSpkLFP(spkdata,lfpdata,polywin);
[rval,p,z]=pearson(spkdata,lfpdata);
plotdata(:,1)=spkdata; plotdata(:,2)=lfpdata;
polypar=polyfit(plotdata(:,1),plotdata(:,2),1);
linefit=polyval(polypar,polywin);
return