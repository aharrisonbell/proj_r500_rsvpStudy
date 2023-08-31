function plx500(files);
%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_figure(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept2007,
% This program is a streamlined version of plx500 that loads previously
% saved structures and skips ahead to the Figure stage.  It is suitable for
% faster production of figures following changes to the figure layout.
% Note: This program requires that the data already be analyzed using
% plx500 and synced with the most recent version of the Excel spreadsheet.
% files = optional argument, list files as strings.  Otherwise, program
% will load files listed in default analyze500.txt

%%% SETUP DEFAULTS
warning off;
close all
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=[500]; % list of paradigm numbers
xscale=-200:400; % default time window
metric_col=2; % column metric (1=spk counts, 2=mean spden, 3=peak spden, 4=mean peak, 5=area under curve)

%%%  LOAD FILE LIST
if nargin==0,
    include=xlsread(hmiconfig.plxlist,hmiconfig.sheet500,'A2:A800'); % alphanumeric, Gridlocation
    [crap,files]=xlsread(hmiconfig.plxlist,hmiconfig.sheet500,'B2:B800'); % numeric, Depth
    files=files(find(include==1));
    clear include
end

%%% ANALYZE INDIVIDUAL FILES
disp('***********************************************************************************')
disp('plx500_figure.m - Figure generating program for RSVP500-series datafiles (Nov 2008)')
disp('***********************************************************************************')
for f=1:length(files), % perform following operations on each nex file listed
    close all
    filename=char(files(f));
    %%% identify sheet name
    if filename(1)=='S', sheetname='RSVP Cells_S';
    elseif filename(1)=='W', sheetname='RSVP Cells_W';
    end
    disp(['Loading structures for ',filename])
    tempstruct=load([hmiconfig.spikedir,filename,'_spkmat.mat']);
    tempspike=tempstruct.spikesig;
    clear tempstruct
    foundunits=size(tempspike,2);
    %%%%%%%%%%%%%%%%%
    %%% Unit loop %%%
    %%%%%%%%%%%%%%%%%
    for un=1:foundunits, % performed for each unit
        disp('Graphing individual units...')
        unitname=tempspike(un).labels;
        load([hmiconfig.rsvp500spks,unitname(1:end-4),'-500responsedata.mat']); % respstructsingle
        load([hmiconfig.rsvp500spks,unitname(1:end-4),'-500graphdata.mat']); % graphstructsingle
        plotneuron(hmiconfig,xscale,graphstruct(un),respstruct(un),char(files(f)),metric_col)
    end
end % ends file loop
return

function plotneuron(hmiconfig,xscale,graphstruct,respstruct,fname,metric_col)
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
%%% determining baseline %%%
switch metric_col
    case 1, avg_baseline=mean(respstruct.spk_baseline); avg_baseline1=mean(respstruct.spk_baseline);
    case 2, avg_baseline=mean(respstruct.m_baseline); avg_baseline1=mean(respstruct.m_baseline);
    case 3, avg_baseline=mean(respstruct.p_baseline); avg_baseline1=mean(respstruct.p_baseline);
    case 4, avg_baseline=mean(respstruct.mp_baseline); avg_baseline1=mean(respstruct.mp_baseline);
    case 5, avg_baseline=mean(respstruct.mp_baseline); avg_baseline1=mean(respstruct.area_baseline);
end
metric_col_list={'SpikeCounts','Mean Spden','Peak Spden','MeanPeak','Area'};
figure
clf; cla; set(gcf,'Units','Normalized'); set(gcf,'Position',[0.1 0.1 0.8 0.8]); set(gca,'FontName','Arial')
xrange=(1000+xscale(1)):(1000+xscale(end));
subplot(4,4,[1 5 9 13]) % colour plot
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
text(xscale(1)-(abs(xscale(1))*.5),10,['Faces (n=',num2str(length(find(respstruct.trial_id(:,2)==1))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(xscale(1)-(abs(xscale(1))*.5),30,['Fruit (n=',num2str(length(find(respstruct.trial_id(:,2)==2))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(xscale(1)-(abs(xscale(1))*.5),50,['Places (n=',num2str(length(find(respstruct.trial_id(:,2)==3))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(xscale(1)-(abs(xscale(1))*.5),70,['Bodyparts (n=',num2str(length(find(respstruct.trial_id(:,2)==4))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(xscale(1)-(abs(xscale(1))*.5),90,['Objects (n=',num2str(length(find(respstruct.trial_id(:,2)==5))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
set(gca,'FontSize',7); xlim([xscale(1) xscale(end)]); box off; axis off; axis ij; ylim([0 100]);
signame=char(graphstruct.label);
title([signame(1:end-4),': RSVP500 Task (',char(metric_col_list(metric_col)),') ',...
    char(respstruct.gridlocation),' (',char(respstruct.APIndex),') - ',num2str(respstruct.depth),'um'],'FontSize',10,'FontWeight','Bold');

subplot(4,4,[2]) % average spike density functions
hold on
plot(xscale,graphstruct.faces_avg(xrange),'r-','LineWidth',2)
plot(xscale,graphstruct.fruit_avg(xrange),'m-','LineWidth',2)
plot(xscale,graphstruct.places_avg(xrange),'b-','LineWidth',2)
plot(xscale,graphstruct.bodyp_avg(xrange),'y-','LineWidth',2)
plot(xscale,graphstruct.objct_avg(xrange),'g-','LineWidth',2)
plot([xscale(1) xscale(end)],[avg_baseline avg_baseline],'k--','LineWidth',0.25)
h=axis;
plot([respstruct.cat_latency(1) respstruct.cat_latency(1)],[0 h(4)],'r-','LineWidth',0.25)
plot([respstruct.cat_latency(2) respstruct.cat_latency(2)],[0 h(4)],'m-','LineWidth',0.25)
plot([respstruct.cat_latency(3) respstruct.cat_latency(3)],[0 h(4)],'b-','LineWidth',0.25)
plot([respstruct.cat_latency(4) respstruct.cat_latency(4)],[0 h(4)],'y-','LineWidth',0.25)
plot([respstruct.cat_latency(5) respstruct.cat_latency(5)],[0 h(4)],'g-','LineWidth',0.25)
plot([0 0],[0 h(4)],'k:','LineWidth',0.5)
plot([xscale(1) xscale(end)],[0 0],'k-')
title('Average Spike Density Functions','FontSize',fontsize_lrg);
ylabel('sp/s','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); xlim([xscale(1) xscale(end)]); box off;

subplot(4,4,6) % average responses
hold on
errorbar(1:5,respstruct.cat_avg(:,metric_col),respstruct.cat_sem(:,metric_col));
bar(1:5,respstruct.cat_avg(:,metric_col))
plot([0.25 5.75],[avg_baseline1 avg_baseline1],'k--','LineWidth',0.25)
ylabel('sp/s','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
set(gca,'XTick',1:5); set(gca,'XTickLabels',{'F','Ft','Pl','Bp','Ob'})
title('Average Category Response','FontSize',fontsize_lrg)
h=axis; ylim([0 h(4)]);
text(0.4,h(4)*0.9,['anova: p=',num2str(respstruct.anova_epoch(1,metric_col),'%1.2g')],'FontSize',fontsize_med)

subplot(4,4,7) % mean latencies
hold on
errorbar(1:5,respstruct.cat_latency(:,1),respstruct.cat_latency(:,2));
bar(1:5,respstruct.cat_latency(:,1))
ylabel('ms','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
set(gca,'XTick',1:5); set(gca,'XTickLabels',{'F','Ft','Pl','Bp','Ob'}); ylim([0 200]);
title('Average Response Latency','FontSize',fontsize_lrg)
h=axis;
text(0.4,h(4)*0.9,['anova: p=',num2str(respstruct.anova_latency,'%1.2g')],'FontSize',fontsize_med)

subplot(4,4,[10 11]) % selectivity
hold on
bar(1:7,[[respstruct.cat_si(:,metric_col);respstruct.raw_si(metric_col)],[respstruct.cat_si_nobase(:,metric_col);respstruct.raw_si_nobase(metric_col)]],'group')
plot([0.5 7.5],[0.1 0.1],'b:','LineWidth',0.25)
plot([0.5 7.5],[-0.1 -0.1],'b:','LineWidth',0.25)
plot([0.5 7.5],[0.33 0.33],'r:','LineWidth',0.25)
plot([0.5 7.5],[-0.33 -0.33],'r:','LineWidth',0.25)
ylabel('SI','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
set(gca,'XTick',1:7); set(gca,'XTickLabels',{'Face','Fruit','Place','Bodyp','Object','FnoFt','RAW'}); ylim([-0.7 0.7]);
if respstruct.face_trad==1, text(0.4,0.4,'Face-Selective (2x)','FontSize',fontsize_lrg,'FontWeight','Bold','Color','r'); end
title('Selectivity Indices (vs. average of all other categories)','FontSize',fontsize_lrg)

subplot(4,4,[14 15]) % pure selectivity
hold on
bar(1:5,respstruct.pure_si,'group')
ylabel('SI','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
set(gca,'XTick',1:5); set(gca,'XTickLabels',{'Face','Fruit','Place','Bodyp','Object'}); ylim([-0.7 0.7]);
legend('vs.F','vs.Ft','vs.Pl','vs.Bp','vs.Ob','Orientation','Horizontal','Location','SouthOutside')
title('Pure Selectivity Indices (vs. Single Categories)','FontSize',fontsize_lrg)

%subplot(3,3,3) % pairwise matrix
%matrix=respstruct.pairwise;
%matrix(:,6)=0; matrix(6,:)=0;
%pcolor(0.5:1:5.5,0.5:1:5.5,matrix)
%caxis([0 0.11]); colorbar; axis square; set(gca,'Ydir','reverse')
%set(gca,'YTick',1:5); set(gca,'XTick',1:5)
%set(gca,'YTickLabel',{'F','Ft','Pl','Bp','Ob'});
%set(gca,'XTickLabel',{'F','Ft','Pl','Bp','Ob'});
%set(gca,'FontSize',fontsize_med)
%title('Pairwise Statistical Comparisons','FontSize',fontsize_lrg)

%New panel - shows Spikes
subplot(3,4,4)
wavedata=load([hmiconfig.wave_raw,signame(1:20),'_raw.mat']);
hold on
try plot(-200:25:575,wavedata.waverawdata(:,1:end)','-','Color',[0.5 0.5 0.5],'LineWidth',0.01); end
plot([(respstruct.wf_params(2)*25)-200 (respstruct.wf_params(2)*25)-200],[0 2],'g-')
plot([(respstruct.wf_params(4)*25)-200 (respstruct.wf_params(4)*25)-200],[0 2],'g-')
text(200,-1.6,['Duration: ',num2str(respstruct.wf_params(5)),' us'],'FontSize',7)
plot([-200 600],[0 0],'k:'); xlim([-200 600]);
plot(-200:25:575,mean(wavedata.waverawdata'),'r-','LineWidth',2); ylim([-2 2]);
xlabel('Time (us)'); ylabel('Amplitude (mV)'); set(gca,'FontSize',fontsize_med)
title('Unit Waveforms','FontSize',fontsize_lrg)

%%% text details
%%% Within Category Anovas(determines within group selectivity)
text(-200,-3.5,'Within Category ANOVAs','FontSize',fontsize_lrg,'FontWeight','Bold')
if respstruct.anova_within_group(1,1,2)<0.051,
    text(-200,-3.9,['Faces:   ',num2str(respstruct.anova_within_group(1,1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-3.9,['Faces:   ',num2str(respstruct.anova_within_group(1,1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.anova_within_group(2,1,2)<0.051,
    text(-200,-4.3,['Fruit:   ',num2str(respstruct.anova_within_group(2,1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-4.3,['Fruit:   ',num2str(respstruct.anova_within_group(2,1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.anova_within_group(3,1,2)<0.051,
    text(-200,-4.7,['Places:  ',num2str(respstruct.anova_within_group(3,1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-4.7,['Places:  ',num2str(respstruct.anova_within_group(3,1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.anova_within_group(4,1,2)<0.051,
    text(-200,-5.1,['BodyP:   ',num2str(respstruct.anova_within_group(4,1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-5.1,['BodyP:   ',num2str(respstruct.anova_within_group(4,1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.anova_within_group(5,1,2)<0.051,
    text(-200,-5.5,['Objects: ',num2str(respstruct.anova_within_group(5,1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-5.5,['Objects: ',num2str(respstruct.anova_within_group(5,1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
%%% Valid Responses
text(-200,-6.0,'Valid responses according to category?','FontSize',fontsize_lrg,'FontWeight','Bold')
if respstruct.cat_sensory(1,metric_col)<=0.05,
    text(-200,-6.4,['Faces:   ',num2str(respstruct.cat_sensory(1,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-6.4,['Faces:   ',num2str(respstruct.cat_sensory(1,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.cat_sensory(2,metric_col)<=0.05,
    text(-200,-6.8,['Fruit:   ',num2str(respstruct.cat_sensory(2,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-6.8,['Fruit:   ',num2str(respstruct.cat_sensory(2,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.cat_sensory(3,metric_col)<=0.05,
    text(-200,-7.2,['Places:  ',num2str(respstruct.cat_sensory(3,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-7.2,['Places:  ',num2str(respstruct.cat_sensory(3,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.cat_sensory(4,metric_col)<=0.05,
    text(-200,-7.6,['BodyP:   ',num2str(respstruct.cat_sensory(4,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-7.6,['BodyP:   ',num2str(respstruct.cat_sensory(4,metric_col),'%1.2g')],'FontSize',fontsize_med); end
if respstruct.cat_sensory(5,metric_col)<=0.05,
    text(-200,-8.0,['Objects: ',num2str(respstruct.cat_sensory(5,metric_col),'%1.2g')],'FontSize',fontsize_med,'Color','r')
else text(-200,-8.0,['Objects: ',num2str(respstruct.cat_sensory(5,metric_col),'%1.2g')],'FontSize',fontsize_med); end
%%% Summary
text(-200,-8.5,'Summary (Automated)','FontSize',10,'FontWeight','Bold')
if isempty(find(respstruct.cat_sensory(:,metric_col)<=0.05))~=1, % sensory or not
    if max(respstruct.cat_avg_nobase(:,metric_col))<=0 & respstruct.anova_epoch(1,metric_col)<=0.05,
        text(-200,-8.9,'Inhibited (category-selective)','FontSize',fontsize_lrg,'Color','r','FontWeight','Bold');
    elseif max(respstruct.cat_avg_nobase(:,metric_col))<=0 & respstruct.anova_epoch(1,metric_col)>0.05,
        text(-200,-8.9,'Inhibited (not selective)','FontSize',fontsize_lrg,'Color','r','FontWeight','Bold');
    elseif max(respstruct.cat_avg_nobase(:,metric_col))>0 & respstruct.anova_epoch(1,metric_col)<=0.05, % selective or not
        text(-200,-8.9,'Sensory (category-selective)','FontSize',fontsize_lrg,'Color','g','FontWeight','Bold');
    elseif max(respstruct.cat_avg_nobase(:,metric_col))>0 & respstruct.anova_epoch(1,metric_col)>0.05,
        text(-200,-8.9,'Sensory (not selective)','FontSize',fontsize_lrg,'Color','g','FontWeight','Bold');
    end
else
    text(-200,-8.9,'Non-responsive','FontSize',9,'Color','r');
end
text(-200,-9.5,['Preferred category:     ',respstruct.preferred_category],'FontSize',fontsize_med,'FontWeight','Bold')
text(-200,-9.9,['Sel pref:  ',num2str(respstruct.raw_si(metric_col),'%1.2g')],'FontSize',fontsize_med)
text(200,-9.9,['(no baseline):  ',num2str(respstruct.raw_si_nobase(metric_col),'%1.2g')],'FontSize',fontsize_med)
text(-200,-10.4,['Type: ',char(respstruct.excitetype),],'FontSize',fontsize_med,'FontWeight','Bold')
text(-200,-10.8,['Faces: ',num2str(respstruct.excite_inhibit(1)),],'FontSize',fontsize_med)
text(100,-10.8,['Fruit: ',num2str(respstruct.excite_inhibit(2)),],'FontSize',fontsize_med)
text(400,-10.8,['Places: ',num2str(respstruct.excite_inhibit(3)),],'FontSize',fontsize_med)
text(-200,-11.2,['Bodyparts: ',num2str(respstruct.excite_inhibit(4)),],'FontSize',fontsize_med)
text(400,-11.2,['Objects: ',num2str(respstruct.excite_inhibit(5)),],'FontSize',fontsize_med)
try
    text(-200,-11.8,'Summary (Confirmed)','FontSize',10,'FontWeight','Bold')
    if strcmp(respstruct.conf_neurtype,'Sensory')==1, % sensory or not
        if strcmp(respstruct.conf_excite,'Inhibit')~=1 & strcmp(respstruct.conf_selective,'Selective')==1,
            text(-200,-12.4,'Sensory (category-selective)','FontSize',fontsize_lrg,'Color','g','FontWeight','Bold');
        elseif strcmp(respstruct.conf_excite,'Inhibit')~=1 & strcmp(respstruct.conf_selective,'Not Selective')==1,
            text(-200,-12.4,'Sensory (not selective)','FontSize',fontsize_lrg,'Color','g','FontWeight','Bold');
        elseif strcmp(respstruct.conf_excite,'Inhibit')==1 & strcmp(respstruct.conf_selective,'Selective')==1,
            text(-200,-12.4,'Inhibited (category-selective)','FontSize',fontsize_lrg,'Color','r','FontWeight','Bold');
        elseif strcmp(respstruct.conf_excite,'Inhibit')==1 & strcmp(respstruct.conf_selective,'Not Selective')==1,
            text(-200,-12.4,'Inhibited (not selective)','FontSize',fontsize_lrg,'Color','r','FontWeight','Bold');
        end
    else
        text(-200,-12.4,'Non-responsive','FontSize',9,'Color','r');
    end
    text(-200,-12.8,['Preferred category:     ',char(respstruct.conf_preferred_cat)],'FontSize',fontsize_med,'FontWeight','Bold')
    text(-200,-13.2,['Type:     ',char(respstruct.conf_excite)],'FontSize',fontsize_med,'FontWeight','Bold')
    text(-200,-13.6,['Quality:     ',num2str(respstruct.Quality)],'FontSize',fontsize_med,'FontWeight','Bold')
end

%matfigname=[hmiconfig.figure_dir,'rsvp500',filesep,signame(1:end-4),'_rsvp500_',char(metric_col_list(metric_col)),'.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500',filesep,signame(1:end-4),'_rsvp500_',char(metric_col_list(metric_col)),'.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500',filesep,signame(1:end-4),'_rsvp500_',char(metric_col_list(metric_col)),'.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return