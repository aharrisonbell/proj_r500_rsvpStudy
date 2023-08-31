 function plx500_project2(monkinitial);
%%%%%%%%%%%%%%%%%%%
% plx500_project2 %
%%%%%%%%%%%%%%%%%%%
% written by AHB, Jan2009,
% based on plx500_sortgrid - adapted to follow RSVP500_Outline, and to be
% compatible with both Monkeys
% MONKINITIAL (required) = 'W' or 'S'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify a monkey (''S''/''W'')'); elseif nargin==1, option=[1]; end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
end
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colourmaps

disp('*******************************************************************')
disp('* plx500_project2.m - Generates figures listed under Project 2 in *')
disp('*     RSVP500_Outline.docx.                                       *')
disp('*******************************************************************')

[dataNS,numgridsNS,countsNS,allunitsNS,unit_indexNS,unitdataNS]=plx500_prepproject2data(hmiconfig,sheetname,'ns');
[dataBS,numgridsBS,countsBS,allunitsBS,unit_indexBS,unitdataBS]=plx500_prepproject2data(hmiconfig,sheetname,'bs');

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Methods) - create manually
disp('Figure 1 (Methods) - create manually)')

% Figure 2  (Neuron Distribution Figure)
disp('Figure 2  (Neuron Distribution Figure)')
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,4,1); pie(countsNS(numgridsNS+1).data(1:2,1),...
    {['n=',num2str(countsNS(numgridsNS+1).data(1,1)),'(',num2str(countsNS(numgridsNS+1).data(1,1)/sum(countsNS(numgridsNS+1).data(1:2,1))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(2,1)),'(',num2str(countsNS(numgridsNS+1).data(2,1)/sum(countsNS(numgridsNS+1).data(1:2,1))*100,'%1.2g'),'%)']})
title({['(A) Sensory/Non-Responsive (n=',num2str(sum(countsNS(numgridsNS+1).data(1:2,1))),')'],'Narrow-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,2); pie(countsNS(numgridsNS+1).data(6,5:7),...
    {['n=',num2str(countsNS(numgridsNS+1).data(6,5)),'(',num2str(countsNS(numgridsNS+1).data(6,5)/sum(countsNS(numgridsNS+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(6,6)),'(',num2str(countsNS(numgridsNS+1).data(6,6)/sum(countsNS(numgridsNS+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(6,7)),'(',num2str(countsNS(numgridsNS+1).data(6,7)/sum(countsNS(numgridsNS+1).data(6,5:7))*100,'%1.2g'),'%)']})
title({['(B) Excite/Inhibit/Both (n=',num2str(sum(countsNS(numgridsNS+1).data(6,5:7))),')'],'Narrow-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,3); pie(countsNS(numgridsNS+1).data(6,3:4),...
    {['n=',num2str(countsNS(numgridsNS+1).data(6,3)),'(',num2str(countsNS(numgridsNS+1).data(6,3)/sum(countsNS(numgridsNS+1).data(6,3:4))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(6,4)),'(',num2str(countsNS(numgridsNS+1).data(6,4)/sum(countsNS(numgridsNS+1).data(6,3:4))*100,'%1.2g'),'%)']})
title({['(C) Selective/Non-Selective (n=',num2str(sum(countsNS(numgridsNS+1).data(6,3:4))),')'],'Narrow-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,4); pie(countsNS(numgridsNS+1).data(1:6,2),...
    {['n=',num2str(countsNS(numgridsNS+1).data(1,2)),'(',num2str(countsNS(numgridsNS+1).data(1,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(2,2)),'(',num2str(countsNS(numgridsNS+1).data(2,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(3,2)),'(',num2str(countsNS(numgridsNS+1).data(3,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(4,2)),'(',num2str(countsNS(numgridsNS+1).data(4,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(5,2)),'(',num2str(countsNS(numgridsNS+1).data(5,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsNS(numgridsNS+1).data(6,2)),'(',num2str(countsNS(numgridsNS+1).data(6,2)/sum(countsNS(numgridsNS+1).data(1:6,2))*100,'%1.2g'),'%)']})
title({['(D) Preferred Categories (n=',num2str(sum(countsNS(numgridsNS+1).data(1:6,2))),')'],'Narrow-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Ft','P','Bp','O','n/a','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,5); pie(countsBS(numgridsBS+1).data(1:2,1),...
    {['n=',num2str(countsBS(numgridsBS+1).data(1,1)),'(',num2str(countsBS(numgridsBS+1).data(1,1)/sum(countsBS(numgridsBS+1).data(1:2,1))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(2,1)),'(',num2str(countsBS(numgridsBS+1).data(2,1)/sum(countsBS(numgridsBS+1).data(1:2,1))*100,'%1.2g'),'%)']})
title({['(A) Sensory/Non-Responsive (n=',num2str(sum(countsBS(numgridsBS+1).data(1:2,1))),')'],'Broad-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,6); pie(countsBS(numgridsBS+1).data(6,5:7),...
    {['n=',num2str(countsBS(numgridsBS+1).data(6,5)),'(',num2str(countsBS(numgridsBS+1).data(6,5)/sum(countsBS(numgridsBS+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(6,6)),'(',num2str(countsBS(numgridsBS+1).data(6,6)/sum(countsBS(numgridsBS+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(6,7)),'(',num2str(countsBS(numgridsBS+1).data(6,7)/sum(countsBS(numgridsBS+1).data(6,5:7))*100,'%1.2g'),'%)']})
title({['(B) Excite/Inhibit/Both (n=',num2str(sum(countsBS(numgridsBS+1).data(6,5:7))),')'],'Broad-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,7); pie(countsBS(numgridsBS+1).data(6,3:4),...
    {['n=',num2str(countsBS(numgridsBS+1).data(6,3)),'(',num2str(countsBS(numgridsBS+1).data(6,3)/sum(countsBS(numgridsBS+1).data(6,3:4))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(6,4)),'(',num2str(countsBS(numgridsBS+1).data(6,4)/sum(countsBS(numgridsBS+1).data(6,3:4))*100,'%1.2g'),'%)']})
title({['(C) Selective/Non-Selective (n=',num2str(sum(countsBS(numgridsBS+1).data(6,3:4))),')'],'Broad-Spiking Neurons'},'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,4,8); pie(countsBS(numgridsBS+1).data(1:6,2),...
    {['n=',num2str(countsBS(numgridsBS+1).data(1,2)),'(',num2str(countsBS(numgridsBS+1).data(1,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(2,2)),'(',num2str(countsBS(numgridsBS+1).data(2,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(3,2)),'(',num2str(countsBS(numgridsBS+1).data(3,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(4,2)),'(',num2str(countsBS(numgridsBS+1).data(4,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(5,2)),'(',num2str(countsBS(numgridsBS+1).data(5,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(countsBS(numgridsBS+1).data(6,2)),'(',num2str(countsBS(numgridsBS+1).data(6,2)/sum(countsBS(numgridsBS+1).data(1:6,2))*100,'%1.2g'),'%)']})
title({['(D) Preferred Categories (n=',num2str(sum(countsBS(numgridsBS+1).data(1:6,2))),')'],'Broad-Spiking Neurons'},'FontSize',fontsize_lrg,'FontWeight','Bold')
legend('F','Ft','P','Bp','O','n/a','Location','Best'); set(gca,'FontSize',7)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1a_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1a_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1a_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,3,1)
set(gca,'FontName','Arial','FontSize',8)
% selectivity only for excitatory/both + sensory neurons
pointer1=find(strcmp(unit_indexNS.SensoryConf,'Sensory')==1);
pointer2=find(ismember(unit_indexNS.ExciteConf,{'Excite' 'Both'})==1);
pointer=intersect(pointer1,pointer2);
dd=unitdataNS.raw_si(pointer);
hist(dd,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel('Raw Selectivity Index','FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.5,20,['n=',num2str(length(pointer))],'FontSize',7)
text(0.5,10,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
title({'(E) Average Raw SI (for Sensory+Excite/Both Neurons)','Narrow-Spiking Neurons'},'FontWeight','Bold'); axis square;
subplot(2,3,2) % uninterpolated raw selectivity
surfdata=plx_gridmap_uninterp(dataNS,'raw_si_all_corr_mean',numgridsNS,0.35);
set(gca,'XDir','reverse');
obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
[p,h]=chi2_test(obs,exp);
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
title({'Proportion of Stim-Selective Neurons',['Narrow-Spiking Neurons (X2:p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(2,3,3) % surface plot - raw selectivity
plx_gridmap_interp(dataNS,'raw_si_all_corr_mean',numgridsNS,0.35)
colormap(mp); colorbar('SouthOutside','FontSize',6);
title({'Proportion of Stimulus Selective Neurons','Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
subplot(2,3,4)
set(gca,'FontName','Arial','FontSize',8)
% selectivity only for excitatory/both + sensory neurons
pointer1=find(strcmp(unit_indexBS.SensoryConf,'Sensory')==1);
pointer2=find(ismember(unit_indexBS.ExciteConf,{'Excite' 'Both'})==1);
pointer=intersect(pointer1,pointer2);
dd=unitdataBS.raw_si(pointer);
hist(dd,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel('Raw Selectivity Index','FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.5,20,['n=',num2str(length(pointer))],'FontSize',7)
text(0.5,10,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
title({'(E) Average Raw SI (for Sensory+Excite/Both Neurons)','Broad-Spiking Neurons'},'FontWeight','Bold'); axis square;
subplot(2,3,5) % uninterpolated raw selectivity
surfdata=plx_gridmap_uninterp(dataBS,'raw_si_all_corr_mean',numgridsBS,0.35);
set(gca,'XDir','reverse');
obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
[p,h]=chi2_test(obs,exp);
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
title({'Proportion of Stim-Selective Neurons',['Broad-Spiking Neurons (X2:p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(2,3,6) % surface plot - raw selectivity
plx_gridmap_interp(dataBS,'raw_si_all_corr_mean',numgridsBS,0.35)
colormap(mp); colorbar('SouthOutside','FontSize',6);
title({'Proportion of Stimulus Selective Neurons','Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1b_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.05 0.9 0.7])
set(gca,'FontName','Arial','FontSize',8)
catname={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5,
    subplot(2,5,cc)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_indexNS.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_indexNS.ExciteConf,{'Excite' 'Both'})==1);
    pointer=intersect(pointer1,pointer2);
    dd=unitdataNS.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8); xlim([-1 1])
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8);
    text(0.3,4,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.3,6,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],'(All Narrow-Spiking Neurons)'},'FontWeight','Bold')
end
for cc=1:5,
    subplot(2,5,cc+5)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_indexNS.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_indexNS.ExciteConf,{'Excite' 'Both'})==1);
    pointert=intersect(pointer1,pointer2);
    pointer3=find(ismember(unit_indexNS.CategoryConf,catname(cc))==1);
    pointer=intersect(pointert,pointer3);
    dd=unitdataNS.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8); xlim([-1 1]);
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8);
    text(0.3,3,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.3,2,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],'(CatPrefNeurons NarrowSpike)'},'FontWeight','Bold')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cNS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cNS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cNS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
set(gca,'FontName','Arial','FontSize',8)
catname={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5,
    subplot(2,5,cc)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_indexBS.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_indexBS.ExciteConf,{'Excite' 'Both'})==1);
    pointer=intersect(pointer1,pointer2);
    dd=unitdataBS.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8); xlim([-1 1]);
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8);
    text(0.6,20,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.6,10,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],'(All Broad-Spiking Neurons)'},'FontWeight','Bold')
end
for cc=1:5,
    subplot(2,5,cc+5)
    set(gca,'FontName','Arial','FontSize',8)
    % selectivity only for excitatory/both + sensory neurons
    pointer1=find(strcmp(unit_indexBS.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_indexBS.ExciteConf,{'Excite' 'Both'})==1);
    pointert=intersect(pointer1,pointer2);
    pointer3=find(ismember(unit_indexBS.CategoryConf,catname(cc))==1);
    pointer=intersect(pointert,pointer3);
    dd=unitdataBS.cat_si(pointer,cc);
    hist(dd,-1:0.05:1)
    set(gca,'FontName','Arial','FontSize',8); xlim([-1 1])
    xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8);
    text(0.5,3,['n=',num2str(length(pointer))],'FontSize',7)
    text(0.5,2,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
    axis square
    title({['(F) Average ',char(catname(cc)),' Selectivity'],'(CatPrefNeurons NarrowSpike)'},'FontWeight','Bold')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cBS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cBS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig1cBS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 3  (Examples) - create manually from output of plx500;
disp('Figure 3  (Examples) - create manually from output of plx500')

% Figure 4  (Stimulus Selectivity Figure)
disp('Figure 4  (Stimulus Selectivity Figure)')
%%% stimulus electivity according to category (preferred)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.1 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,3,1) % Within category selectivity
bardata=zeros(5,2);
for g=1:numgridsNS,
    for c=1:5,
        bardata(c,1)=bardata(c,1)+dataNS(g).counts(c);
        bardata(c,2)=bardata(c,2)+dataNS(g).within_counts(c);
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bar(bardata(:,2:3),'stack')
tmp=sum(bardata); tmpprc=tmp(2)/tmp(1); bardata(:,4)=bardata(:,1)*tmpprc;
[p,h]=chi2_test(bardata(:,2),bardata(:,4));
for c=1:5, text(c,bardata(c,1)+5,[num2str(bardata(c,2)/bardata(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',['NarrowSpike (X2: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(2,3,2) % uninterpolated stimulus selectivity
surfdata=[]; validgrids=[];
for g=1:numgridsNS,
    surfdata(g,1:2)=dataNS(g).grid_coords;
    surfdata(g,3)=sum(dataNS(g).within_counts)/sum(dataNS(g).counts);
    surfdata(g,4)=sum(dataNS(g).within_counts);
    surfdata(g,5)=sum(dataNS(g).counts);
end
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata);
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 .75]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Proportion of Stim-Selective Neurons',['(NarrowSpike, X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(2,3,3) % surface plot - stimulus selectivity
surfdata=[];
for g=1:numgridsNS,
    surfdata(g,1:2)=dataNS(g).grid_coords;
    surfdata(g,3)=sum(dataNS(g).within_counts)/sum(dataNS(g).counts);
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
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Proportion of Stimulus Selective Neurons','Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
%axis off
colorbar('SouthOutside','FontSize',6)
subplot(2,3,4) % Within category selectivity
bardata=zeros(5,2);
for g=1:numgridsBS,
    for c=1:5,
        bardata(c,1)=bardata(c,1)+dataBS(g).counts(c);
        bardata(c,2)=bardata(c,2)+dataBS(g).within_counts(c);
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bar(bardata(:,2:3),'stack')
tmp=sum(bardata); tmpprc=tmp(2)/tmp(1); bardata(:,4)=bardata(:,1)*tmpprc;
[p,h]=chi2_test(bardata(:,2),bardata(:,4));
for c=1:5, text(c,bardata(c,1)+5,[num2str(bardata(c,2)/bardata(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',['BroadSpike (X2: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(2,3,5) % uninterpolated stimulus selectivity
surfdata=[]; validgrids=[];
for g=1:numgridsBS,
    surfdata(g,1:2)=dataBS(g).grid_coords;
    surfdata(g,3)=sum(dataBS(g).within_counts)/sum(dataBS(g).counts);
    surfdata(g,4)=sum(dataBS(g).within_counts);
    surfdata(g,5)=sum(dataBS(g).counts);
end
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata);
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 .75]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Proportion of Stim-Selective Neurons',['(BroadSpike, X2: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(2,3,6) % surface plot - stimulus selectivity
surfdata=[];
for g=1:numgridsBS,
    surfdata(g,1:2)=dataBS(g).grid_coords;
    surfdata(g,3)=sum(dataBS(g).within_counts)/sum(dataBS(g).counts);
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
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Proportion of Stimulus Selective Neurons','Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
%axis off
colorbar('SouthOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig3_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig3_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig3_',monkeyname,'.fig']);
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
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).prop(pn);
        if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        tmp=sum(dataNS(gridloc).countsmat,1);
        surfdata(g,4)=tmp(pn);
        surfdata(g,5)=sum(dataNS(gridloc).counts);
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata);
    exp=prep_chidata(surfdata(:,3),surfdata(:,5));
    [p,h]=chi2_test(surfdata(:,4),exp);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .75])
    mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Proportion (NarrowSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')    
    %axis off
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).prop(pn);
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
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .75])
    colormap(mp)
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Proportion'],'Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5NS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5NS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5NS_',monkeyname,'.fig']);
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
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).prop(pn);
        if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        tmp=sum(dataBS(gridloc).countsmat,1);
        surfdata(g,4)=tmp(pn);
        surfdata(g,5)=sum(dataBS(gridloc).counts);        
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata);
    exp=prep_chidata(surfdata(:,3),surfdata(:,5));
    [p,h]=chi2_test(surfdata(:,4),exp);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .75])
    mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Proportion (BroadSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')        
    %axis off
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).prop(pn);
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
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .75])
    colormap(mp)
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Proportion'],'Broad-Spiking'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5BS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5BS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig5BS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 6  (Actual vs. Predicted)

% Figure 7  (Analysis of Selectivity-Indices of Category-Preferring Neurons)
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(2,5,pn) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).cat_si_corr_mean(pn);
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
    [p,h]=chi2_test(obs,exp);
    gridmap=plx500_surfdata2gridmap(surfdata);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity (CatPrefNeurons-NarrowSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).cat_si_corr_mean(pn);
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity'],'Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aNS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aNS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aNS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% Figure 7  (Analysis of Selectivity-Indices of Category-Preferring Neurons)
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(2,5,pn) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).cat_si_corr_mean(pn);
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
    [p,h]=chi2_test(obs,exp);
    gridmap=plx500_surfdata2gridmap(surfdata);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity (CatPrefNeurons-BroadSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).cat_si_corr_mean(pn);
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity'],'Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aBS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aBS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7aBS_',monkeyname,'.fig']);
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
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).cat_si_all_corr_mean(pn);
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
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity (All Neurons,NarrowSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')    
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsNS,
        if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).cat_si_all_corr_mean(pn);
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity'],'Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bNS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bNS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bNS_',monkeyname,'.fig']);
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
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).cat_si_all_corr_mean(pn);
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
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity (All Neurons,BroadSpike)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')    
end
colorbar('EastOutside','FontSize',6)
for pn=1:5,
    subplot(2,5,pn+5) % surface plot - face selectivity
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsBS,
        if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).cat_si_all_corr_mean(pn);
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title({[char(labels(pn)),' Selectivity'],'Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
    axis off
end
colorbar('EastOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bBS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bBS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig7bBS_',monkeyname,'.fig']);
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
        for g=1:numgridsNS, if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
        validgrids=1:numgridsNS; % do not eliminate grids
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=dataNS(gridloc).grid_coords;
            surfdata(g,3)  =dataNS(gridloc).pure_si_corr_mean(cc,pn);
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
        [p,h]=chi2_test(obs,exp);
        %%% Need to convert surfdata to a 10*10 matrix
        gridmap=plx500_surfdata2gridmap(surfdata,1);
        pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
        axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
        %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
        ylabel('Distance from interaural axis (mm)','fontsize',7);
        xlabel('Distance from meridian (mm)','fontsize',7);
        title({[char(labels(pn)),' Selectivity (CatPref Narrow)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
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
        ylabel('Distance from meridian (mm)','fontsize',7);
        title({[char(labels(pn)),' Selectivity'],'Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
        axis off
        colorbar('SouthOutside','FontSize',6)
    end
    jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8NS_',monkeyname,'_',char(labels(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8NS_',monkeyname,'_',char(labels(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8NS_',monkeyname,'_',char(labels(cc)),'.fig']);
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end

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
        for g=1:numgridsBS, if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
        validgrids=1:numgridsBS; % do not eliminate grids
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=dataBS(gridloc).grid_coords;
            surfdata(g,3)  =dataBS(gridloc).pure_si_corr_mean(cc,pn);
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
        [p,h]=chi2_test(obs,exp);
        %%% Need to convert surfdata to a 10*10 matrix
        gridmap=plx500_surfdata2gridmap(surfdata,1);
        pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
        axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
        %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
        ylabel('Distance from interaural axis (mm)','fontsize',7);
        xlabel('Distance from meridian (mm)','fontsize',7);
        title({[char(labels(pn)),' Selectivity (CatPref Broad)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
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
        ylabel('Distance from meridian (mm)','fontsize',7);
        title({[char(labels(pn)),' Selectivity'],'Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
        axis off
        colorbar('SouthOutside','FontSize',6)
    end
    jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8BS_',monkeyname,'_',char(labels(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8BS_',monkeyname,'_',char(labels(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig8BS_',monkeyname,'_',char(labels(cc)),'.fig']);
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
for g=1:numgridsNS, if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgridsNS; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=dataNS(gridloc).grid_coords;
    surfdata(g,3)  =dataNS(gridloc).numsensory/dataNS(g).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    surfdata(g,4)=dataNS(gridloc).numsensory;
    surfdata(g,5)=dataNS(gridloc).numunits;
end
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive',['Narrow (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
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
xlabel('Distance from interaural axis (mm)','fontsize',7);
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive','Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)
subplot(2,5,2) % category-selective vs. not-category selective
surfdata=[]; validgrids=[];
% Filter out any sites that don't have at least 5 neurons
for g=1:numgridsNS, if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgridsNS; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=dataNS(gridloc).grid_coords;
    surfdata(g,3)  =dataNS(gridloc).count_selective(1)/dataNS(g).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
end
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive','Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
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
xlabel('Distance from interaural axis (mm)','fontsize',7);
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Selective vs. Non-Selective','Narrow-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)        
label={'Pure Excitatory' 'Both Excitatory/Inhibitory' 'Pure Inhibited'};
for pn=1:3
    subplot(2,5,2+pn) % category-selective vs. not-category selective
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsNS, if sum(dataNS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
    validgrids=1:numgridsNS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataNS(gridloc).grid_coords;
        surfdata(g,3)  =dataNS(gridloc).count_resptype(pn)/dataNS(g).numunits;
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata,1);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title(label(pn),'FontSize',7,'FontWeight','Bold')
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title(label(pn),'FontSize',7,'FontWeight','Bold')
    colorbar('SouthOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9NS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9NS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9NS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

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
for g=1:numgridsBS, if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgridsBS; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=dataBS(gridloc).grid_coords;
    surfdata(g,3)  =dataBS(gridloc).numsensory/dataBS(g).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    surfdata(g,4)=dataBS(gridloc).numsensory;
    surfdata(g,5)=dataBS(gridloc).numunits;
end
exp=prep_chidata(surfdata(:,3),surfdata(:,5));
[p,h]=chi2_test(surfdata(:,4),exp);
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive',['Broad (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
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
xlabel('Distance from interaural axis (mm)','fontsize',7);
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive','Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)
subplot(2,5,2) % category-selective vs. not-category selective
surfdata=[]; validgrids=[];
% Filter out any sites that don't have at least 5 neurons
for g=1:numgridsBS, if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
validgrids=1:numgridsBS; % do not eliminate grids
for g=1:length(validgrids),
    gridloc=validgrids(g);
    surfdata(g,1:2)=dataBS(gridloc).grid_coords;
    surfdata(g,3)  =dataBS(gridloc).count_selective(1)/dataBS(g).numunits;
    if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
end
%%% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata,1);
pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
title({'Sensory vs. Non-Responsive','Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
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
xlabel('Distance from interaural axis (mm)','fontsize',7);
ylabel('Distance from meridian (mm)','fontsize',7);
title({'Selective vs. Non-Selective','Broad-Spiking Neurons'},'FontSize',7,'FontWeight','Bold')
axis off
colorbar('SouthOutside','FontSize',6)        
label={'Pure Excitatory' 'Both Excitatory/Inhibitory' 'Pure Inhibited'};
for pn=1:3
    subplot(2,5,2+pn) % category-selective vs. not-category selective
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgridsBS, if sum(dataBS(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
    validgrids=1:numgridsBS; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=dataBS(gridloc).grid_coords;
        surfdata(g,3)  =dataBS(gridloc).count_resptype(pn)/dataBS(g).numunits;
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata,1);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',7);
    xlabel('Distance from meridian (mm)','fontsize',7);
    title(label(pn),'FontSize',7,'FontWeight','Bold')
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
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title(label(pn),'FontSize',7,'FontWeight','Bold')
    colorbar('SouthOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9BS_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9BS_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project2',filesep,'RSVP_Project2_Fig9BS_',monkeyname,'.fig']);
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
return


%%% NESTED FUNCTIONS %%%
