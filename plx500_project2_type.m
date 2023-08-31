function plx500_project2_type(monkinitial,type);
%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_project2_type %
%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Feb2009,
% based on plx500_sortgrid - adapted to follow RSVP500_Outline, and to be
% compatible with both Monkeys
% MONKINITIAL (required) = 'W' or 'S'
% TYPE (required) = 'bs' or 'ns'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin<2, error('You must specify a monkey (''S''/''W'') and neuron type (''ns'' or ''bs'')'); elseif nargin==1, option=[1]; end
if type=='ns', neurtype='Narrow-Spiking'; else neurtype='Broad-Spiking'; end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
    % Grid location groups for comparison
    grp1={'A7L2','A7L1','A7R1'}; % n=87
    grp2={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % n=100
    grp3={'A4L2','A4L1','A4R1'}; % n=87
    grp4={'A2L5','A0L6','A0L2','A0R0','P1L1','P2L3','P3L5','P3L4'}; % n=128
    grp5={'P5L3','P6L3','P6L2','P6L1','P7L2'}; % n=74
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
    % Grid location groups for comparison
    grp1={'A6R2','A5R0','A4R3'}; % n=48
    grp2={'A3R0','A2R1','A2R3','A2R5'}; % n=112
    grp3={'P1R0','P1R3'}; % n=88
    grp4={'P3R0','P3R2','P5R0'}; % n=70
    grp5={'P3R0','P3R2','P5R0'}; % n=70
end
% A/P borders for Anterior/Middle/Posterior
ant=[19 18 17 16 15];
mid=[14 13 12 11 10];
post=[9 8 7 6 5];

stimselectfiles={'Stew051408a1-sig003a' ...
        'Stew052208c1-sig003a' ...   
        'Stew052208d1-sig003a' ...   
        'Stew052308c1-sig003a' ...
        'Stew051408b1-sig003a' ...
        'Stew051408e1-sig001a' ...
        };
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colourmaps
%hmiconfig.printer=1;
disp('************************************************************************')
disp('* plx500_project2_type.m - Generates figures listed under Project 2 in *')
disp('*     RSVP500_Outline.doc for the type of neuron specified.            *')
disp('************************************************************************')
[data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject2data(hmiconfig,sheetname,type);
save([hmiconfig.rootdir,'rsvp500_project2',filesep,'Project2Data_',monkeyname,'-',type,'.mat'],'data','unit_index','unitdata');

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Methods) - create manually
disp('Figure 1 (Methods) - create manually)')
% Figure 2  (Neuron Distribution Figure)
disp('Figure 2  (Neuron Distribution Figure)')
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,4,1); pie(counts_matrix(numgrids+1).data(1:2,1),...
    {['n=',num2str(counts_matrix(numgrids+1).data(1,1)),'(',num2str(counts_matrix(numgrids+1).data(1,1)/sum(counts_matrix(numgrids+1).data(1:2,1))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(2,1)),'(',num2str(counts_matrix(numgrids+1).data(2,1)/sum(counts_matrix(numgrids+1).data(1:2,1))*100,'%1.2g'),'%)']})
title({['(A) Sensory/Non-Responsive (n=',num2str(sum(counts_matrix(numgrids+1).data(1:2,1))),')'],neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,2); pie(counts_matrix(numgrids+1).data(6,5:7),...
    {['n=',num2str(counts_matrix(numgrids+1).data(6,5)),'(',num2str(counts_matrix(numgrids+1).data(6,5)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,6)),'(',num2str(counts_matrix(numgrids+1).data(6,6)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,7)),'(',num2str(counts_matrix(numgrids+1).data(6,7)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)']})
title({['(B) Excite/Inhibit/Both (n=',num2str(sum(counts_matrix(numgrids+1).data(6,5:7))),')'],neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,[5 6]); bar(counts_matrix(numgrids+1).data(1:5,5:7),'stack')
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'})
legend('E','I','B','Location','SouthEast'); ylabel('Number of Neurons'); set(gca,'FontSize',7)
title({'Category Breakdown (Excite/Inhibit/Both)',neurtype},'FontWeight','Bold')
subplot(2,4,3); pie(counts_matrix(numgrids+1).data(6,3:4),...
    {['n=',num2str(counts_matrix(numgrids+1).data(6,3)),'(',num2str(counts_matrix(numgrids+1).data(6,3)/sum(counts_matrix(numgrids+1).data(6,3:4))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,4)),'(',num2str(counts_matrix(numgrids+1).data(6,4)/sum(counts_matrix(numgrids+1).data(6,3:4))*100,'%1.2g'),'%)']})
title({['(C) Selective/Non-Selective (n=',num2str(sum(counts_matrix(numgrids+1).data(6,3:4))),')'],neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,[7 8]); bar(counts_matrix(numgrids+1).data(1:5,3:4),'stack')
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'})
legend('S','NS','Location','SouthEast'); ylabel('Number of Neurons'); set(gca,'FontSize',7)
title({'Category Breakdown (Selective/Non-Selective)',neurtype},'FontWeight','Bold')
subplot(2,4,4); pie(counts_matrix(numgrids+1).data(1:6,2),...
    {['n=',num2str(counts_matrix(numgrids+1).data(1,2)),'(',num2str(counts_matrix(numgrids+1).data(1,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(2,2)),'(',num2str(counts_matrix(numgrids+1).data(2,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(3,2)),'(',num2str(counts_matrix(numgrids+1).data(3,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(4,2)),'(',num2str(counts_matrix(numgrids+1).data(4,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(5,2)),'(',num2str(counts_matrix(numgrids+1).data(5,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,2)),'(',num2str(counts_matrix(numgrids+1).data(6,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)']})
title({['(D) Preferred Categories (n=',num2str(sum(counts_matrix(numgrids+1).data(1:6,2))),')'],neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Ft','P','Bp','O','n/a','Location','Best'); set(gca,'FontSize',7)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig2a_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig2a_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig2a_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,3,1)
set(gca,'FontName','Arial','FontSize',8)
% selectivity only for excitatory/both + sensory neurons
pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
pointer2=find(ismember(unit_index.ExciteConf,{'Excite' 'Both'})==1);
pointer=intersect(pointer1,pointer2);
dd=unitdata.raw_si(pointer);
save([hmiconfig.rootdir,'rsvp500_project2',filesep,'RawSI_',monkeyname,'.m'],'dd');
hist(dd,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel('Raw Selectivity Index','FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(pointer))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
title({'(E) Average Raw SI (for Sensory+Excite/Both Neurons)',neurtype},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(1,3,2) % uninterpolated raw selectivity of all excitatory/both neurons
surfdata=plx_gridmap_uninterp(data,'raw_si_all_corr_mean',numgrids,0.35);
obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
[p,h]=chi2_test(obs,exp);
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
title({'Raw SI across IT for all Excite/Both neurons',[type,' (X2(flawed): p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(1,3,3) % surface plot - raw selectivity
plx_gridmap_interp(data,'raw_si_all_corr_mean',numgrids,0.35)
colormap(mp); colorbar('SouthOutside','FontSize',6);
title({'Raw SI across IT for all Excite/Both neurons',neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; % selectivity index histograms for SELECTIVE NEURONS
set(gcf,'Units','Normalized','Position',[0.05 0.05 0.9 0.9])
set(gca,'FontName','Arial','FontSize',8)
catname={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5,
    subplot(2,5,cc)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_index.ExciteConf,{'Excite' 'Both'})==1);
    pointer=intersect(pointer1,pointer2);
    dd=unitdata.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8)
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8); xlim([-1 1]);
    text(0.6,30,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.6,35,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],['(All Excite/Both Neurons- ',neurtype,')']},'FontWeight','Bold')
end
for cc=1:5,
    subplot(2,5,cc+5)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_index.ExciteConf,{'Excite' 'Both'})==1);
    pointert=intersect(pointer1,pointer2);
    pointer3=find(ismember(unit_index.CategoryConf,catname(cc))==1);
    pointer=intersect(pointert,pointer3);
    dd=unitdata.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8)
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8); xlim([-0.25 1]);
    text(0.5,5,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.5,10,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],['(All Excite/Both/Pref -',neurtype,')']},'FontWeight','Bold')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1c_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1c_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1c_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 3  (Examples) - create manually from output of plx500;
disp('Figure 3  (Examples) - create manually from output of plx500')

% Figure 4  (Stimulus Selectivity Figure)
disp('Figure 4  (Stimulus Selectivity Figure)')
%%% stimulus electivity according to category (preferred)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,3,1) % Within category selectivity
bardata=zeros(5,2);
for g=1:numgrids,
    for c=1:5,
        bardata(c,1)=bardata(c,1)+data(g).counts(c);
        bardata(c,2)=bardata(c,2)+data(g).within_counts(c);
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bar(bardata(:,2:3),'stack')
tmp=sum(bardata); tmpprc=tmp(2)/tmp(1); bardata(:,4)=bardata(:,1)*tmpprc;
[p,h]=chi2_test(bardata(:,2),bardata(:,4));
for c=1:5, text(c,bardata(c,1)+5,[num2str(bardata(c,2)/bardata(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(1,3,2) % uninterpolated stimulus selectivity
surfdata=[]; validgrids=[];
for g=1:numgrids,
    surfdata(g,1:2)=data(g).grid_coords;
    surfdata(g,3)=sum(data(g).within_counts)/sum(data(g).counts);
    surfdata(g,4)=sum(data(g).within_counts);
    surfdata(g,5)=sum(data(g).counts);
end
%%% Need to convert surfdata to a 16*16 matrix
gridmap=plx500_surfdata2gridmap(surfdata);
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
% bar3(gridmap)
axis square; set(gca,'CLim',[0 .75]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from midline (mm)','fontsize',7);
title({'Proportion of Stim-Selective Neurons',[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',9,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(1,3,3) % surface plot - stimulus selectivity
surfdata=[];
for g=1:numgrids,
    surfdata(g,1:2)=data(g).grid_coords;
    surfdata(g,3)=sum(data(g).within_counts)/sum(data(g).counts);
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
end
%%% clip NaNs
ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
[uu,vv]=meshgrid(ulin,vlin);
pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
hold on
plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .75]); colormap(mp);
xlabel('Distance from interaural axis (mm)','fontsize',7);
ylabel('Distance from midline (mm)','fontsize',7);
title({'Proportion of Stimulus Selective Neurons',neurtype},'FontSize',9,'FontWeight','Bold')
%axis off
colorbar('SouthOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig4_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig4_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig4_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 5  (Analysis of Distribution of Category-Preferring Neurons)
disp('Figure 5  (Analysis of Distribution of Category-Preferring Neurons)')
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(2,5,pn) % surface plot - face proportion
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)=data(gridloc).prop(pn);
        if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        tmp=sum(data(gridloc).countsmat);
        surfdata(g,4)=tmp(pn);
        surfdata(g,5)=sum(data(gridloc).counts);
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata);
    exp=prep_chidata(surfdata(:,3),surfdata(:,5));
    [p,h]=chi2_test(surfdata(:,4),exp);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5])
    mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',6);
    xlabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Proportion'],[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
    %axis off
end
% Alternate BAR3 version
% for pn=1:5,
%     subplot(2,5,pn) % surface plot - face proportion
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)  =data(gridloc).prop(pn);
%         if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
%         if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%     end
%     %%% Need to convert surfdata to a 10*10 matrix
%     gridmap=plx500_surfdata2gridmap(surfdata);
%     for x=1:16, for y=1:16, if gridmap(x,y)==-1, gridmap(x,y)=0; end; end; end
%     bar3(gridmap); view([-60,15]);
%  
%     
%     %pcolor(gridmap); shading flat; if strcmp(monkinitial,'S')==1,
%     set(gca,'XDir','reverse'); end
%     %axis square; set(gca,'CLim',[0 .75])
%     %mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%     %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%     ylabel('Distance from interaural axis (mm)','fontsize',7);
%     xlabel('Distance from midline (mm)','fontsize',7);
%     title([char(labels(pn)),' Proportion'],'FontSize',9,'FontWeight','Bold')
%     %axis off
% end
% colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).prop(pn);
        if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% clip NaNs
    ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
    vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
    [uu,vv]=meshgrid(ulin,vlin);
    pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
    h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
    hold on
    plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
    axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5])
    colormap(mp)
    xlabel('Distance from interaural axis (mm)','fontsize',6);
    ylabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Proportion'],neurtype},'FontSize',fontsize_med,'FontWeight','Bold')
    axis off
    colorbar('SouthOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 6  (Actual vs. Predicted)
disp('Figure 6  (Actual vs. Predicted)')

% Figure 7  (Analysis of Selectivity-Indices of Category-Preferring Neurons)
disp('Figure 7  (Analysis of Selectivity-Indices of Category-Preferring Neurons)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(2,5,pn) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).cat_si_corr_mean(pn);
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 16*16 matrix
    obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
    [p,h]=chi2_test(obs,exp);
    gridmap=plx500_surfdata2gridmap(surfdata);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',6);
    xlabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Selectivity (CatPrefNeurons)'],[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
end
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).cat_si_corr_mean(pn);
        if isnan(surfdata(g,3))==1,  surfdata(g,3)=0; end
    end
    %%% clip NaNs
    ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
    vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
    [uu,vv]=meshgrid(ulin,vlin);
    pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
    h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
    hold on
    plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
    axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
    xlabel('Distance from interaural axis (mm)','fontsize',6);
    ylabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Selectivity'],[neurtype,' (CatPrefNeurons)']},'FontSize',fontsize_med,'FontWeight','Bold')
    axis off
    colorbar('SouthOutside','FontSize',6)    
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7a_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7a_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7a_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 7' (Analysis of Selectivity-Indices of ALL SENSORY Neurons)
disp('Figure 7'' (Analysis of Selectivity-Indices of ALL SENSORY Neurons)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(2,5,pn) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).cat_si_all_corr_mean(pn);
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
    [p,h]=chi2_test(obs,exp);
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata,1);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[-.15 .15]); mp=colormap;
    mp(33,:)=[0.75 .75 .75]; colormap(mp);
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',6);
    xlabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Selectivity (All Neurons)'],[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
end
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).cat_si_all_corr_mean(pn);
        if isnan(surfdata(g,3))==1,  surfdata(g,3)=0; end
    end
    %%% clip NaNs
    ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
    vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
    [uu,vv]=meshgrid(ulin,vlin);
    pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
    h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
    hold on
    plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
    axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[-.15 .15]); colormap(mp);
    xlabel('Distance from interaural axis (mm)','fontsize',6);
    ylabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Selectivity'],[neurtype,' (All Neurons)']},'FontSize',7,'FontWeight','Bold')
    axis off
    colorbar('SouthOutside','FontSize',6)    
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7b_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7b_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7b_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 8 (Analysis of Pure Selectivity-Indices for Category-Preferring Neurons)
disp('Figure 8 (Analysis of Pure Selectivity-Indices for Category-Preferring Neurons')
%%%% 5x5 matrix -- contrast each class of cat-pref neuron with each other
for cc=1:5, % one figure per preferred category
    figure; clf; cla;
    set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
    set(gca,'FontName','Arial','FontSize',8)
    labels={'Face','Fruit','Place','Bodypart','Object'};
    for pn=1:5, % once per contrast category
        subplot(2,5,pn) % surface plot
        surfdata=[]; validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
        validgrids=1:numgrids; % do not eliminate grids
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).pure_si_corr_mean(cc,pn);
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
        [p,h]=chi2_test(obs,exp);
        %%% Need to convert surfdata to a 10*10 matrix
        gridmap=plx500_surfdata2gridmap(surfdata,1);
        pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
        axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
        %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
        ylabel('Distance from interaural axis (mm)','fontsize',6);
        xlabel('Distance from midline (mm)','fontsize',6);
        title({[char(labels(pn)),' Selectivity (CatPref Neurons)'],[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
        subplot(2,5,pn+5) % surface plot - face selectivity
        ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
        vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
        [uu,vv]=meshgrid(ulin,vlin);
        pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
        h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
        hold on
        plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
        axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
        axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from midline (mm)','fontsize',7);
        title({[char(labels(pn)),' Selectivity'],[neurtype,' (CatPref Neurons)']},'FontSize',7,'FontWeight','Bold')
        axis off
        colorbar('SouthOutside','FontSize',6)
    end
    jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8_',monkeyname,'-',type,'_',char(labels(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8_',monkeyname,'-',type,'_',char(labels(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8_',monkeyname,'-',type,'.fig'])    
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end


% Figure 9 (Other Possibilities breakdown of neuron type/response type);
disp('Figure 9 (Other Possibilities breakdown of neuron type/response type)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
%%% neuron type (sensory/non-responsive)
subplot(2,5,1) % surface plot
surfdata=[]; validgrids=[];
% Filter out any sites that don't have at least 5 neurons
for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgrids; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=data(gridloc).grid_coords;
    surfdata(g,3)  =data(gridloc).numsensory/data(gridloc).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    surfdata(g,4)=data(gridloc).numsensory;
    surfdata(g,5)=data(gridloc).numunits;
end
%%% Need to convert surfdata to a 10*10 matrix
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',6);
xlabel('Distance from midline (mm)','fontsize',6);
title({'Distribution of neurons','Sensory vs. Non-Responsive',[neurtype,' (X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
subplot(2,5,6) % surface plot - face selectivity
ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
[uu,vv]=meshgrid(ulin,vlin);
pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
hold on
plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 1]); colormap(mp);
xlabel('Distance from interaural axis (mm)','fontsize',6);
ylabel('Distance from midline (mm)','fontsize',6);
title({'Distribution of neurons','Sensory vs. Non-Responsive',neurtype},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)
subplot(2,5,2) % category-selective vs. not-category selective
surfdata=[]; validgrids=[];
% Filter out any sites that don't have at least 5 neurons
for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgrids; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=data(gridloc).grid_coords;
    surfdata(g,3)  =data(gridloc).count_selective(1)/data(g).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
end
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',6);
xlabel('Distance from midline (mm)','fontsize',6);
title({'Distribution','Category Selective vs. Non-Selective',neurtype},'FontSize',7,'FontWeight','Bold')
subplot(2,5,7)
ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
[uu,vv]=meshgrid(ulin,vlin);
pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
hold on
plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 1]); colormap(mp);
xlabel('Distance from interaural axis (mm)','fontsize',6);
ylabel('Distance from midline (mm)','fontsize',6);
title({'Distribution','Category Selective vs. Non-Selective',neurtype},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)        
label={'Pure Excitatory' 'Both Excitatory/Inhibitory' 'Pure Inhibited'};
for pn=1:3
    subplot(2,5,2+pn) % category-selective vs. not-category selective
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
    validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)  =data(gridloc).count_resptype(pn)/data(g).numunits;
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata,1);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',6);
    xlabel('Distance from midline (mm)','fontsize',6);
    title({'Response Type',[neurtype,' (',char(label(pn)),')']},'FontSize',7,'FontWeight','Bold')
    subplot(2,5,7+pn)
    ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
    vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
    [uu,vv]=meshgrid(ulin,vlin);
    pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
    h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
    hold on
    plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
    axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
    xlabel('Distance from interaural axis (mm)','fontsize',6);
    ylabel('Distance from midline (mm)','fontsize',6);
    title({'Response Type',[neurtype, '(',char(label(pn)),')']},'FontSize',7,'FontWeight','Bold')
    colorbar('SouthOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 10 - Raw SI histogram
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,2,1)
dd=extractRawSI(unit_index,unitdata,5:19);
hist(dd,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel('Raw Selectivity Index','FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(dd))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
title({'Average Raw SI (for Sensory+Excite/Both Neurons)',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(1,2,2)
antSI=extractRawSI(unit_index,unitdata,ant);
midSI=extractRawSI(unit_index,unitdata,mid);
postSI=extractRawSI(unit_index,unitdata,post);
hold on
bar([mean(antSI) mean(midSI) mean(postSI)]);
errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)]);
set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
[p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
title({'Raw SI vs AP Location (for Sensory+Excite/Both Neurons)',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig10_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig10_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig10_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 11 - Category SI histogram (for CatPreferring Neurons)
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
faceSI=extractCatSI(unit_index,unitdata,'Faces',1);
fruitSI=extractCatSI(unit_index,unitdata,'Fruit',2);
placeSI=extractCatSI(unit_index,unitdata,'Places',3);
bpartSI=extractCatSI(unit_index,unitdata,'BodyParts',4);
objectSI=extractCatSI(unit_index,unitdata,'Objects',5);
hold on
bar([mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)])
errorbar(1:5,[mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(fruitSI) sem(objectSI) sem(placeSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Face','BPart','Fruit','Object','Place'})
ylabel('Average Category SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(faceSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(bpartSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(fruitSI))],'FontSize',7)
text(4,.48,['n=',num2str(length(objectSI))],'FontSize',7)
text(5,.48,['n=',num2str(length(placeSI))],'FontSize',7)
[p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(bpartSI,fruitSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(fruitSI,objectSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(objectSI,placeSI); text(4.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(faceSI,placeSI); text(3,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
title({'Category Selectivity of Excite/Both Preferring Neurons',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig11_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig11_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig11_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 12 - Stimulus Selectivity Figure
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,2,1)
stimB=extractStimSelect(data,5:19);
bar(stimB(:,2:3),'stack')
tmp=sum(stimB); tmpprc=tmp(2)/tmp(1); stimB(:,4)=stimB(:,1)*tmpprc;
[p,h]=chi2_test(stimB(:,2),stimB(:,4));
for c=1:5, text(c,stimB(c,1)+5,[num2str(stimB(c,2)/stimB(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',[monkeyname,'-',neurtype,': (X2: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
subplot(1,2,2)
antStim=extractStimSelect(data,ant);
midStim=extractStimSelect(data,mid); 
postStim=extractStimSelect(data,post);
hold on
bar([mean(antStim(:,4)) mean(midStim(:,4)) mean(postStim(:,4))])
errorbar(1:3,[mean(antStim(:,4)) mean(midStim(:,4)) mean(postStim(:,4))],[sem(antStim(:,4)) sem(midStim(:,4)) sem(postStim(:,4))])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
ylabel('Average % StimSelective Neurons','FontSize',8); ylim([0 75]); axis square
text(1,58,['n=',num2str(sum(antStim(:,1)))],'FontSize',7)
text(2,58,['n=',num2str(sum(midStim(:,1)))],'FontSize',7)
text(3,58,['n=',num2str(sum(postStim(:,1)))],'FontSize',7)
title({'Proportion of StimSelective Neurons (for given category)',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig12_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig12_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig12_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 13 - Category Proportion and Selectivity for Both Monkeys for each Category
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Face','Fruit','Place','Bodypart','Object'};
for cc=1:5, % once per category
    subplot(3,5,cc)
    [ans,anc,aprop]=extractCatProp(data,ant,cc);
    [mns,mnc,mprop]=extractCatProp(data,mid,cc);
    [pns,pnc,pprop]=extractCatProp(data,post,cc);
    antprop=(anc/ans)*100;
    midprop=(mnc/mns)*100;
    postprop=(pnc/pns)*100;
    bar([antprop midprop postprop]);
    x2=chi2_test([antprop midprop postprop],[33.3 33.3 33.3]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title({[char(catnames(cc)),'-selective Neurons'],neurtype},'FontSize',7,'FontWeight','Bold')
    text(2,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str([ans])],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str([mns])],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str([pns])],'FontSize',7,'HorizontalAlignment','Center')
end
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5, % category selectivity of CategoryPreferringNeurons
    subplot(3,5,cc+5)
    SIant=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,ant);
    SImid=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,mid);
    SIpost=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,post);
    hold on
    bar([mean(SIant) mean(SImid) mean(SIpost)])
    errorbar(1:3,[mean(SIant) mean(SImid) mean(SIpost)],[sem(SIant) sem(SImid) sem(SIpost)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .5]); axis square
    text(1,.38,['n=',num2str(length(SIant))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.38,['n=',num2str(length(SImid))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.38,['n=',num2str(length(SIpost))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (CatPref Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SIant,SImid); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SImid,SIpost); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SIant,SIpost); text(2,0.48,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+10)
    SIant=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,ant);
    SImid=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,mid);
    SIpost=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,post);
    hold on
    bar([mean(SIant) mean(SImid) mean(SIpost)])
    errorbar(1:3,[mean(SIant) mean(SImid) mean(SIpost)],[sem(SIant) sem(SImid) sem(SIpost)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.15 .15]); axis square
    text(1,-.14,['n=',num2str(length(SIant))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SImid))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SIpost))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (All Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);    
    [p,h]=ranksum(SIant,SImid); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    [p,h]=ranksum(SImid,SIpost); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    [p,h]=ranksum(SIant,SIpost); text(2,0.12,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig13_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig13_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig13_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 14 - Raw SI histogram
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,2,1)
grp1SI=extractRawSI_Grid(unit_index,unitdata,grp1);
grp2SI=extractRawSI_Grid(unit_index,unitdata,grp2);
grp3SI=extractRawSI_Grid(unit_index,unitdata,grp3);
grp4SI=extractRawSI_Grid(unit_index,unitdata,grp4);
grp5SI=extractRawSI_Grid(unit_index,unitdata,grp5);
hold on
bar([mean(grp1SI) mean(grp2SI) mean(grp3SI) mean(grp4SI) mean(grp5SI)]);
errorbar(1:5,[mean(grp1SI) mean(grp2SI) mean(grp3SI) mean(grp4SI) mean(grp5SI)],...
    [sem(grp1SI) sem(grp2SI) sem(grp3SI) sem(grp4SI) sem(grp5SI)]);
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(grp1SI))],'FontSize',7)
text(2,.48,['n=',num2str(length(grp2SI))],'FontSize',7)
text(3,.48,['n=',num2str(length(grp3SI))],'FontSize',7)
text(4,.48,['n=',num2str(length(grp4SI))],'FontSize',7)
text(5,.48,['n=',num2str(length(grp5SI))],'FontSize',7)
[p,h]=ranksum(grp1SI,grp2SI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(grp2SI,grp3SI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(grp3SI,grp4SI); text(3.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(grp4SI,grp5SI); text(4.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
title({'Raw SI vs GrpLoc (for Sensory+Excite/Both Neurons)',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;

subplot(1,2,2)
grp1Stim=extractStimSelect_Grid(data,grp1);
grp2Stim=extractStimSelect_Grid(data,grp2);
grp3Stim=extractStimSelect_Grid(data,grp3);
grp4Stim=extractStimSelect_Grid(data,grp4);
grp5Stim=extractStimSelect_Grid(data,grp5);
hold on
bar([mean(grp1Stim(:,4)) mean(grp2Stim(:,4)) mean(grp3Stim(:,4)) mean(grp4Stim(:,4)) mean(grp5Stim(:,4))])
errorbar(1:5,[mean(grp1Stim(:,4)) mean(grp2Stim(:,4)) mean(grp3Stim(:,4)) mean(grp4Stim(:,4)) mean(grp5Stim(:,4))],...
    [sem(grp1Stim(:,4)) sem(grp2Stim(:,4)) sem(grp3Stim(:,4)) sem(grp4Stim(:,4)) sem(grp5Stim(:,4))])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average % StimSelective Neurons','FontSize',8); ylim([0 75]); axis square
text(1,58,['n=',num2str(sum(grp1Stim(:,1)))],'FontSize',7)
text(2,58,['n=',num2str(sum(grp2Stim(:,1)))],'FontSize',7)
text(3,58,['n=',num2str(sum(grp3Stim(:,1)))],'FontSize',7)
text(4,58,['n=',num2str(sum(grp4Stim(:,1)))],'FontSize',7)
text(5,58,['n=',num2str(sum(grp5Stim(:,1)))],'FontSize',7)
title({'Proportion of StimSelective Neurons (for given category)',[monkeyname,' ',neurtype]},'FontWeight','Bold','FontSize',fontsize_med); axis square;
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig14_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig14_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig14_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 15 - Category Proportion and Selectivity for Both Monkeys for each Category
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Face','Fruit','Place','Bodypart','Object'};
for cc=1:5, % once per category
    subplot(3,5,cc)
    [ns1,nc1,prop1]=extractCatProp_Grid(data,grp1,cc);
    [ns2,nc2,prop2]=extractCatProp_Grid(data,grp2,cc);
    [ns3,nc3,prop3]=extractCatProp_Grid(data,grp3,cc);
    [ns4,nc4,prop4]=extractCatProp_Grid(data,grp4,cc);
    [ns5,nc5,prop5]=extractCatProp_Grid(data,grp5,cc);
    p1=(nc1/ns1)*100;
    p2=(nc2/ns2)*100;
    p3=(nc3/ns3)*100;
    p4=(nc4/ns4)*100;    
    p5=(nc5/ns5)*100;
    bar([p1 p2 p3 p4 p5]);
    x2=chi2_test([p1 p2 p3 p4 p5],[20 20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title({[char(catnames(cc)),'-selective Neurons'],[monkeyname,' ',neurtype]},'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str([ns1])],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str([ns2])],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str([ns3])],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str([ns4])],'FontSize',7,'HorizontalAlignment','Center')
    text(5,40,['n=',num2str([ns5])],'FontSize',7,'HorizontalAlignment','Center')
end
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5, % category selectivity of CategoryPreferringNeurons
    subplot(3,5,cc+5)
    SI1=extractCatSI_Grid(unit_index,unitdata,catnames(cc),cc,grp1);
    SI2=extractCatSI_Grid(unit_index,unitdata,catnames(cc),cc,grp2);
    SI3=extractCatSI_Grid(unit_index,unitdata,catnames(cc),cc,grp3);
    SI4=extractCatSI_Grid(unit_index,unitdata,catnames(cc),cc,grp4);
    SI5=extractCatSI_Grid(unit_index,unitdata,catnames(cc),cc,grp5);
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .5]); axis square
    text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (CatPref Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+10)
    SI1=extractCatSI_APall_Grid(unit_index,unitdata,catnames(cc),cc,grp1);
    SI2=extractCatSI_APall_Grid(unit_index,unitdata,catnames(cc),cc,grp2);
    SI3=extractCatSI_APall_Grid(unit_index,unitdata,catnames(cc),cc,grp3);
    SI4=extractCatSI_APall_Grid(unit_index,unitdata,catnames(cc),cc,grp4);
    SI5=extractCatSI_APall_Grid(unit_index,unitdata,catnames(cc),cc,grp5);
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.15 .15]); axis square
    text(1,-.14,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.14,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.14,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (All Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig15_',monkeyname,'-',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig15_',monkeyname,'-',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2Pop_Fig15_',monkeyname,'-',type,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

return

%%% NESTED FUNCTIONS %%%
function output=extractRawSI(uindex,udata,APrange);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointerT=intersect(pointer1,pointer2);
pointer=intersect(pointerT,pointer3);
output=udata.raw_si(pointer);
return

function output=extractCatSI(uindex,udata,catname,catcol);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.CategoryConf,catname)==1);
pointerT=intersect(pointer1,pointer2);
pointer=intersect(pointerT,pointer3);
output=udata.cat_si(pointer,catcol);
return

function bardata=extractStimSelect(data,APrange);
bardata=zeros(5,2); numgrids=size(data,2);
for g=1:numgrids,
    if ismember(data(g).grid_coords(1,1),APrange)==1,
        for c=1:5,
            bardata(c,1)=bardata(c,1)+data(g).counts(c);
            bardata(c,2)=bardata(c,2)+data(g).within_counts(c);
        end
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bardata(:,4)=bardata(:,2) ./ bardata(:,1) * 100;
return

function [numsensory,numcat,output]=extractCatProp(data,APrange,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).counts(catcol);
    end
end
output=numcat/numsensory;
return

function output=extractCatSI_AP(uindex,udata,catname,catcol,APrange)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.CategoryConf,catname)==1);
pointer4=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_APall(uindex,udata,catname,catcol,APrange)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function output=extractRawSI_Grid(uindex,udata,gridlocs);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT=intersect(pointer1,pointer2);
pointer=intersect(pointerT,pointer3);
output=udata.raw_si(pointer);
return

function bardata=extractStimSelect_Grid(data,gridlocs);
bardata=zeros(5,2); numgrids=size(data,2);
for g=1:numgrids,
    if ismember(data(g).gridloc,gridlocs)==1,
        for c=1:5,
            bardata(c,1)=bardata(c,1)+data(g).counts(c);
            bardata(c,2)=bardata(c,2)+data(g).within_counts(c);
        end
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bardata(:,4)=bardata(:,2) ./ bardata(:,1) * 100;
return

function [numsensory,numcat,output]=extractCatProp_Grid(data,gridlocs,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).counts(catcol);
    end
end
output=numcat/numsensory;
return

function output=extractCatSI_Grid(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.CategoryConf,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_APall_Grid(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return
















