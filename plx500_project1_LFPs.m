function plx500_project1_LFPs(monkinitial,preexist);
%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_project1_LFPs %
%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, May2009,
% based on plx500_project1 - adapted to analyze LFP responses (population).
% Does not compare LFPs to anything else... yet
% MONKINITIAL (required) = 'W' or 'S'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify a monkey (''S''/''W'')'); end
if nargin==1, preexist=1; end
%%%% Grids defined by number of neurons
% if monkinitial=='S',
%     monkeyname='Stewie'; sheetname='RSVP Cells_S';
%     % Grid location groups for comparison
%     grp(1).grids={'A7L2','A7L1','A7R1'}; % n=87
%     grp(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % n=100
%     grp(3).grids={'A4L2','A4L1','A4R1'}; % n=87
%     grp(4).grids={'A2L5','A0L6','A0L2','A0R0','P1L1','P2L3','P3L5','P3L4'}; % n=128
%     grp(5).grids={'P5L3','P6L3','P6L2','P6L1','P7L2'}; % n=74
% elseif monkinitial=='W',
%     monkeyname='Wiggum'; sheetname='RSVP Cells_W';
%     % Grid location groups for comparison
%     grp(1).grids={'A6R2','A5R0','A4R3'}; % n=48
%     grp(2).grids={'A3R0','A2R1','A2R3','A2R5'}; % n=112
%     grp(3).grids={'P1R0','P1R3'}; % n=88
%     grp(4).grids={'P3R0','P3R2','P5R0'}; % n=70
%     grp(5).grids={'P3R0','P3R2','P5R0'}; % n=70
% end
%%%% Grids defined according to fMRI category-selective regions
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP_LFP_S';
    % Grid location groups for comparison
    grp(1).grids={'A7L2','A7L1','A7R1'}; % BodyPart Selective
    grp(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Face Selective
    grp(3).grids={'A4L2','A4L1','A4R1'}; % Place Selective
    grp(4).grids={'A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Object Selective
    grp(5).grids={'P6L2','P6L1','P7L2'}; % Face Selective
    if preexist==1,
        load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_',monkeyname,'.mat'],'sitedata');
        load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_',monkeyname,'.mat'],'griddata');
    else
        [sitedata,griddata]=plx500_prepproject1data_LFP('S');
        save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_',monkeyname,'.mat'],'sitedata');
        save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_',monkeyname,'.mat'],'griddata');
    end
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP_LFP_W';
    % Grid location groups for comparison
    grp(1).grids={'A6R2','A5R0','A4R3'}; % Bodypart Selective
    grp(2).grids={'A3R0','A2R1','A2R3','A2R5'}; % Face Selective
    grp(3).grids={'P1R0','P1R3'}; % Bodypart Selective
    grp(4).grids={'P3R0','P3R2','P5R0'}; % Place Selective
    grp(5).grids={'P3R0','P3R2','P5R0'}; % Place Selective
    if preexist==1,
        load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_',monkeyname,'.mat'],'sitedata');
        load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_',monkeyname,'.mat'],'griddata');
    else
        [sitedata,griddata]=plx500_prepproject1data_LFP('W');
        save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_',monkeyname,'.mat'],'sitedata');
        save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_',monkeyname,'.mat'],'griddata','sitedata');
    end
end

% A/P borders for Anterior/Middle/Posterior
sicutoff=0.20;

fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colourmaps

disp('***********************************************************************')
disp('* plx500_project1_LFP.m - Generates figures listed under Project 1 in *')
disp('*     RSVP500_Outline.docx (for local field potential data ONLY).     *')
disp('***********************************************************************')
%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
%%%%%%%%%%%%%%%%%%%%%% SUMMARY STATISTICS %%%%%%%%%%%%%%%%%%%%%% 

% Figure 1  (Site Distribution Figure)
disp('Figure 1  (Site Distribution Figure)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.4 0.8]); set(gca,'FontName','Arial','FontSize',8);
subplot(4,1,1); bardata=[]; % Proportion of Category-Selective Sites
bardataC(1,1)=length(find(sitedata.cat_anova<0.05));
bardataC(1,2)=length(find(sitedata.cat_anova>=0.05));
bardataC(1,3)=bardataC(1,1)/sum(bardataC(1,1:2))*100; bardataC(1,4)=100-bardataC(1,3);
bardataC(2,1)=length(find(sitedata.cat_anova_rect<0.05));
bardataC(2,2)=length(find(sitedata.cat_anova_rect>=0.05));
bardataC(2,3)=bardataC(2,1)/sum(bardataC(2,1:2))*100; bardataC(2,4)=100-bardataC(2,3);
for freq=1:6,
    bardataC(freq+2,1)=length(find(sitedata.freq_across_anova(:,freq)<0.05));
    bardataC(freq+2,2)=length(find(sitedata.freq_across_anova(:,freq)>=0.05));
    bardataC(freq+2,3)=bardataC(freq+2,1)/sum(bardataC(freq+2,1:2))*100; bardataC(freq+2,4)=100-bardataC(freq+2,3);
end
bar(1:8,bardataC(1:8,[3 4]),'stack');
ylabel({'Proportion of LFP sites exhibiting','Category Selectivity (ANOVA)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('Category-Selectivity','FontSize',fontsize_lrg)
subplot(4,1,2); bardata=[]; % preferred category (All Sites)
bardata(1,1)=length(find(strcmp(sitedata.bestlabel,'Faces')==1));
bardata(1,2)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1));
bardata(1,3)=length(find(strcmp(sitedata.bestlabel,'Objects')==1));
bardata(1,4)=length(find(strcmp(sitedata.bestlabel,'Places')==1));
bardata(2,1)=length(find(strcmp(sitedata.bestlabel_rect,'Faces')==1));
bardata(2,2)=length(find(strcmp(sitedata.bestlabel_rect,'Bodyparts')==1));
bardata(2,3)=length(find(strcmp(sitedata.bestlabel_rect,'Objects')==1));
bardata(2,4)=length(find(strcmp(sitedata.bestlabel_rect,'Places')==1));
for freq=1:6,
    bardata(freq+2,1)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Faces')==1));
    bardata(freq+2,2)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Bodyparts')==1));
    bardata(freq+2,3)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Objects')==1));
    bardata(freq+2,4)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Places')==1));
end
bar(1:8,bardata(1:8,[1 2 3 4]),'stack'); legend('Faces','BParts','Objects','Places')
ylabel({'Category Preferences','(All Sites)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('Preferred Category across all sites','FontSize',fontsize_lrg)
subplot(4,1,3); bardata=[]; % preferred category (Only Category Selective Sites)
bardata(1,1)=length(find(strcmp(sitedata.bestlabel,'Faces')==1 & sitedata.cat_anova<0.05));
bardata(1,2)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1 & sitedata.cat_anova<0.05));
bardata(1,3)=length(find(strcmp(sitedata.bestlabel,'Objects')==1 & sitedata.cat_anova<0.05));
bardata(1,4)=length(find(strcmp(sitedata.bestlabel,'Places')==1 & sitedata.cat_anova<0.05));
bardata(2,1)=length(find(strcmp(sitedata.bestlabel_rect,'Faces')==1 & sitedata.cat_anova_rect<0.05));
bardata(2,2)=length(find(strcmp(sitedata.bestlabel_rect,'Bodyparts')==1 & sitedata.cat_anova_rect<0.05));
bardata(2,3)=length(find(strcmp(sitedata.bestlabel_rect,'Objects')==1 & sitedata.cat_anova_rect<0.05));
bardata(2,4)=length(find(strcmp(sitedata.bestlabel_rect,'Places')==1 & sitedata.cat_anova_rect<0.05));
for freq=1:6,
    bardata(freq+2,1)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Faces')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+2,2)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Bodyparts')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+2,3)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Objects')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+2,4)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Places')==1 & sitedata.freq_across_anova(:,freq)<0.05));
end
bar(1:8,bardata(1:8,[1 2 3 4]),'stack');
for col=1:8, text(col,200,[num2str(bardataC(col,3),'%1.2g'),'%'],'FontSize',fontsize_sml); end
ylabel({'Category Preferences','(Category-Selective Sites)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('Preferred Category across Category-Selective Sites','FontSize',fontsize_lrg)
subplot(4,1,4); bardata=[]; % preferred category (Only Category Selective Sites)
pointer=find(sitedata.cat_anova<0.05);
[bardata(1,1),bardata(1,2)]=mean_sem(sitedata.evoked_rawsi(pointer));
[bardata(2,1),bardata(2,2)]=mean_sem(sitedata.rect_rawsi(pointer));
for freq=1:6,
    [bardata(freq+2,1),bardata(freq+2,2)]=mean_sem(sitedata.freq_rawsi(pointer,freq));
end
hold on
bar(1:8,bardata(1:8,1)); errorbar(1:8,bardata(1:8,1),bardata(1:8,2))
ylabel({'Category Selectivity','(Category-Selective Sites)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('CategorySelectivity Index (for preferred category) Category across Category-Selective Sites','FontSize',fontsize_lrg)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%%%%%%%%%%%%%%%%%%%%% GRID STATISTICS %%%%%%%%%%%%%%%%%%%%%% 
numgrids=size(griddata,2);
% Figure 2  (Analysis of Distribution of Category-Preferring Sites) %
disp('Figure 2  (Analysis of Distribution of Category-Preferring Sites)')
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.05 0.6 0.8])
set(gca,'FontName','Arial','FontSize',8)
labels={'Faces','Bodyparts','Objects','Places'};

% Proportion (Evoked Potentials)
for pn=1:4,
    subplot(2,2,pn) % surface plot - face proportion
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        catselectnum=length(find(griddata(g).cat_anova_rect<0.05));
        if catselectnum>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=griddata(gridloc).grid_coords;
        tempnum_all_select=length(find(griddata(gridloc).cat_anova_rect<0.05));
        tempnum_cat_select=length(find(griddata(gridloc).cat_anova_rect<0.05 & strcmp(griddata(gridloc).bestlabel,char(labels(pn)))==1));
        surfdata(g,3)=tempnum_cat_select/tempnum_all_select;
        
        if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
        if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
    end
    %%% Need to convert surfdata to a 10*10 matrix
    gridmap=plx500_surfdata2gridmap(surfdata);
    %exp=prep_chidata(surfdata(:,3),surfdata(:,5));
    %[p,h]=chi2_test(surfdata(:,4),exp);
    pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
    axis square; set(gca,'CLim',[0 1])
    mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
    %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
    ylabel('Distance from interaural axis (mm)','fontsize',6);
    xlabel('Distance from midline (mm)','fontsize',6);
    title({[char(labels(pn)),' Proportion'],'(% of All Cat-Selective Sites)'},'FontSize',fontsize_med,'FontWeight','Bold')
    %axis off
    %colorbar('WestOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_CatPrefDist_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_CatPrefDist_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 3 - Category Proportion for each Patch
disp('Figure 3 - Category Proportion for each Patch')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
%%% Proportions (Evoked Potentials)
for pat=1:5, % one loop per patch
    subplot(5,5,pat)
    [ns,nc,prop]=extractPropGrid(griddata,grp(pat).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 100]); axis square
    title(['Patch ',num2str(pat),', CatPrefs (Evoked)'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
%%% Proportions (Rectified Potentials)
for pat=1:5, % one loop per patch
    subplot(5,5,pat+5)
    [ns,nc,prop]=extractPropGrid_rect(griddata,grp(pat).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 100]); axis square
    title(['Patch ',num2str(pat),', CatPrefs (Rect Evoked)'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
%%% Proportions (Frequency (0-120Hz)
for pat=1:5, % one loop per patch
    subplot(5,5,pat+10)
    [ns,nc,prop]=extractPropGrid_freq(griddata,grp(pat).grids,1); 
        bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 100]); axis square
    title(['Patch ',num2str(pat),', CatPrefs (0-120Hz)'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
%%% Proportions (Frequency (0-20Hz)
for pat=1:5, % one loop per patch
    subplot(5,5,pat+15)
    [ns,nc,prop]=extractPropGrid_freq(griddata,grp(pat).grids,2); 
        bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 100]); axis square
    title(['Patch ',num2str(pat),', CatPrefs (0-20Hz)'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
%%% Proportions (Frequency (95-120Hz)
for pat=1:5, % one loop per patch
    subplot(5,5,pat+20)
    [ns,nc,prop]=extractPropGrid_freq(griddata,grp(pat).grids,6); 
        bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 100]); axis square
    title(['Patch ',num2str(pat),', CatPrefs (95-120Hz)'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_grpCatPrefperpatch_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_grpCatPrefperpatch_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_grpCatPrefperpatch_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 4 - Category vs. Power in different Frequency Bands
disp('Figure 4 - Category vs. Power in different Frequency Bands')
figure; clf; cla; bardata=[];
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
%subplot(1,1,1)
trial_id=[ones(size(sitedata.cat_avg_epoch,1),1)*1; ones(size(sitedata.cat_avg_epoch,1),1)*2; ones(size(sitedata.cat_avg_epoch,1),1)*3; ones(size(sitedata.cat_avg_epoch,1),1)*4]; 
bardata(1,1:4)=mean(sitedata.cat_avg_epoch);
bar_anova(1)=anova1(log(reshape(sitedata.cat_avg_epoch,size(sitedata.cat_avg_epoch,1)*4,1)),trial_id,'off');
bar_anova_log(1)=anova1(reshape(sitedata.cat_avg_epoch,size(sitedata.cat_avg_epoch,1)*4,1),trial_id,'off');
bardata(2,1:4)=mean(sitedata.cat_avg_rect_epoch);
bar_anova(2)=anova1(reshape(sitedata.cat_avg_rect_epoch,size(sitedata.cat_avg_rect_epoch,1)*4,1),trial_id,'off');
bar_anova_log(2)=anova1(log(reshape(sitedata.cat_avg_rect_epoch,size(sitedata.cat_avg_rect_epoch,1)*4,1)),trial_id,'off');
for cc=1:6, 
    bardata(cc+2,1:4)=mean(sitedata.freq_epoch_cat(:,:,cc)); 
    bar_anova(cc+2)=anova1(reshape(sitedata.freq_epoch_cat(:,:,cc),size(sitedata.cat_avg_epoch,1)*4,1),trial_id,'off');
    bar_anova_log(cc+2)=anova1(log(reshape(sitedata.freq_epoch_cat(:,:,cc),size(sitedata.cat_avg_epoch,1)*4,1)),trial_id,'off');
end
bar(log(bardata),'group')
for cc=1:8,
    text(cc,1.8,['p=',num2str(bar_anova(cc),'%1.2g')],'FontSize',fontsize_med)
    text(cc,1.6,['p(log)=',num2str(bar_anova_log(cc),'%1.2g')],'FontSize',fontsize_med)
end
ylabel('log Power','FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('Frequency vs. Category','FontSize',fontsize_lrg)
legend('Faces','Bodyparts','Objects','Places')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_CatFreqBand_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_CatFreqBand_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_CatFreqBand_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 5  (Category and Raw Selectivity Figure)
disp('Figure 5  (Category and Raw Selectivity Figure)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
subplot(3,2,1); bardata=[]; % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova<0.05),:);
hist(max(tempdata,[],2),0:0.05:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw SI','CatSelectiveSites'},'FontSize',8); ylabel('# Sites','FontSize',8);
text(0.2,120,['n=',num2str(length(max(tempdata,[],2)))],'FontSize',7)
text(0.2,140,['Avg: ',num2str(mean(max(tempdata,[],2))),' (',num2str(sem(max(tempdata,[],2)),'%1.2g'),')'],'FontSize',7)
ylim([0 200]); xlim([-0.2 0.6]); 
title('Average Raw SI (for Selective Sites)','FontWeight','Bold','FontSize',fontsize_med);
subplot(3,2,2); % within category selectivity
bardata=[];
bardata(1,1)=length(find(strcmp(sitedata.bestlabel,'Faces')==1 & sitedata.cat_anova_rect<0.05));
bardata(2,1)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1 & sitedata.cat_anova_rect<0.05));
bardata(3,1)=length(find(strcmp(sitedata.bestlabel,'Objects')==1 & sitedata.cat_anova_rect<0.05));
bardata(4,1)=length(find(strcmp(sitedata.bestlabel,'Places')==1 & sitedata.cat_anova_rect<0.05));
bardata(1,2)=length(find(strcmp(sitedata.bestlabel,'Faces')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,1)'<0.05));
bardata(2,2)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,2)'<0.05));
bardata(3,2)=length(find(strcmp(sitedata.bestlabel,'Objects')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,3)'<0.05));
bardata(4,2)=length(find(strcmp(sitedata.bestlabel,'Places')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,4)'<0.05));
bardata(1,3)=bardata(1,2)/bardata(1,1)*100;
bardata(2,3)=bardata(2,2)/bardata(2,1)*100;
bardata(3,3)=bardata(3,2)/bardata(3,1)*100;
bardata(4,3)=bardata(4,2)/bardata(4,1)*100;
bar(bardata(:,3)); set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTicklabel',{'F','Bp','Ob','Pl'})
ylim([0 50]); ylabel({'Proportion of Sites with','Stim Selectivity'},'FontSize',fontsize_med)
subplot(3,2,3); % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova_rect<0.05 & strcmp(sitedata.bestlabel,'Faces')==1),:);
hist(max(tempdata,[],2),0:0.05:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Face SI','CatSelectiveSites'},'FontSize',8); ylabel('# Sites','FontSize',8);
text(0.2,30,['n=',num2str(length(max(tempdata,[],2)))],'FontSize',7)
text(0.2,40,['Avg: ',num2str(mean(max(tempdata,[],2))),' (',num2str(sem(max(tempdata,[],2)),'%1.2g'),')'],'FontSize',7)
xlim([-0.2 0.6]); 
title('Average Face SI (for Face Preferring Sites)','FontWeight','Bold','FontSize',fontsize_med);
subplot(3,2,4); % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova_rect<0.05 & strcmp(sitedata.bestlabel,'Bodyparts')==1),:);
hist(max(tempdata,[],2),0:0.05:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Bodypart SI','CatSelectiveSites'},'FontSize',8); ylabel('# Sites','FontSize',8);
text(0.2,20,['n=',num2str(length(max(tempdata,[],2)))],'FontSize',7)
text(0.2,10,['Avg: ',num2str(mean(max(tempdata,[],2))),' (',num2str(sem(max(tempdata,[],2)),'%1.2g'),')'],'FontSize',7)
xlim([-0.2 0.6]); 
title('Average Bodypart SI (for Bodypart Preferring Sites)','FontWeight','Bold','FontSize',fontsize_med);
subplot(3,2,5); % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova_rect<0.05 & strcmp(sitedata.bestlabel,'Objects')==1),:);
hist(max(tempdata,[],2),0:0.05:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Object SI','CatSelectiveSites'},'FontSize',8); ylabel('# Sites','FontSize',8);
text(0.2,20,['n=',num2str(length(max(tempdata,[],2)))],'FontSize',7)
text(0.2,10,['Avg: ',num2str(mean(max(tempdata,[],2))),' (',num2str(sem(max(tempdata,[],2)),'%1.2g'),')'],'FontSize',7)
xlim([-0.2 0.6]); 
title('Average Object SI (for Object Preferring Sites)','FontWeight','Bold','FontSize',fontsize_med);
subplot(3,2,6); % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova_rect<0.05 & strcmp(sitedata.bestlabel,'Places')==1),:);
hist(max(tempdata,[],2),0:0.05:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Place SI','CatSelectiveSites'},'FontSize',8); ylabel('# Sites','FontSize',8);
text(0.2,1,['n=',num2str(length(max(tempdata,[],2)))],'FontSize',7)
text(0.2,2,['Avg: ',num2str(mean(max(tempdata,[],2))),' (',num2str(sem(max(tempdata,[],2)),'%1.2g'),')'],'FontSize',7)
xlim([-0.2 0.6]); 
title('Average Place SI (for Place Preferring Sites)','FontWeight','Bold','FontSize',fontsize_med);
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_si_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_si_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_si_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%%% FACE PROCESSING ANALYSIS
% What is the difference between face neurons IN the patch vs. OUT of the patch?
% Figure 6 (Category Selectivity)
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
%%% Excitatory Responses
subplot(4,1,1) % CatSI Analysis
% Compare ability of patches to discriminate faces vs. other categories
[rawSI1,avgSI(1,:),semSI(1,:)]=extractCatSI_Grid_prefCat(sitedata,[1],grp(1).grids,'Faces');
[rawSI2,avgSI(2,:),semSI(2,:)]=extractCatSI_Grid_prefCat(sitedata,[1],grp(2).grids,'Faces');
[rawSI3,avgSI(3,:),semSI(3,:)]=extractCatSI_Grid_prefCat(sitedata,[1],grp(3).grids,'Faces');
[rawSI4,avgSI(4,:),semSI(4,:)]=extractCatSI_Grid_prefCat(sitedata,[1],grp(4).grids,'Faces');
[rawSI5,avgSI(5,:),semSI(5,:)]=extractCatSI_Grid_prefCat(sitedata,[1],grp(5).grids,'Faces');
hold on
bar(avgSI,'group')
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average CatSI','FontSize',8); ylim([0 .50]);
legend('Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz')
title({'CatSI Analysis (FaceNeuronsOnly) Excite',monkeyname},'FontWeight','Bold','FontSize',7);

% ROC Analysis
% Compare ability of patches to discriminate faces vs. other categories
[rawROC1,avgROC(:,:,1),semROC(:,:,1)]=extractROC_Grid_prefCat(sitedata,[1 2 3 4],grp(1).grids,'Faces');
[rawROC2,avgROC(:,:,2),semROC(:,:,2)]=extractROC_Grid_prefCat(sitedata,[1 2 3 4],grp(2).grids,'Faces');
[rawROC3,avgROC(:,:,3),semROC(:,:,3)]=extractROC_Grid_prefCat(sitedata,[1 2 3 4],grp(3).grids,'Faces');
[rawROC4,avgROC(:,:,4),semROC(:,:,4)]=extractROC_Grid_prefCat(sitedata,[1 2 3 4],grp(4).grids,'Faces');
[rawROC5,avgROC(:,:,5),semROC(:,:,5)]=extractROC_Grid_prefCat(sitedata,[1 2 3 4],grp(5).grids,'Faces');
labels={'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'};
for pp=1:8
    subplot(4,4,4+pp)
    graphdata=squeeze(avgROC(pp,:,:))';
    [avggraph(pp,:),semgraph(pp,:)]=mean_sem(graphdata,2);
    bar(graphdata,'group')
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average ROC','FontSize',8); ylim([0.45 0.75]);
    title({'ROC Analysis (FaceNeuronsOnly)',labels{pp}},'FontWeight','Bold','FontSize',7);
end
% Average ROC
subplot(4,1,4)
bar(avggraph,'group')
set(gca,'FontName','Arial','FontSize',8,'XTick',1:8,'XTickLabel',{'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
ylabel('Average ROC','FontSize',8); ylim([0.45 0.75]); legend('Grp1','Grp2','Grp3','Grp4','Grp5')
title({'ROC Analysis (FaceNeuronsOnly)','Average'},'FontWeight','Bold','FontSize',7);
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F6_FacePatchAnalysis_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F6_FacePatchAnalysis_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F6_FacePatchAnalysis_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%% Stimulus Selectivity
disp('Figure 7 (Stimulus Selectivity)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
SI1=extractStimSelect_Grid(sitedata,grp(1).grids);
SI2=extractStimSelect_Grid(sitedata,grp(2).grids);
SI3=extractStimSelect_Grid(sitedata,grp(3).grids);
SI4=extractStimSelect_Grid(sitedata,grp(4).grids);
SI5=extractStimSelect_Grid(sitedata,grp(5).grids);
labels={'Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'};
for pp=1:8,
    subplot(2,4,pp)
    bar([SI1(pp,:);SI2(pp,:);SI3(pp,:);SI4(pp,:);SI5(pp,:)],'group')
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('% Within Category Selectivity','FontSize',8); ylim([0 60]);
    title({'Stimulus Selectivity per Patch',[monkeyname,' ',labels{pp}]},'FontWeight','Bold','FontSize',7);
    legend('Faces','BodyParts','Objects','Places')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F7_StimSelectperGrid_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F7_StimSelectperGrid_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F7_StimSelectperGrid_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% AVERAGE ANOVA SPECTROGRAM %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 8 (Average ANOVA spectrogram for category-selective units)
disp('Figure 8 (Average ANOVA spectrogram for category-selective units)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
disp('Loading ANOVA spectrograms for each category-selective site...')
subplot(1,3,1) % Average ANOVA based on Evoked Cat-Select Units
catselect_pointer=find(sitedata.cat_anova<0.05);
average_anova=zeros(length(catselect_pointer),846,31); % based on size of lfpstructsingle_trim.mtspect_anova
for un=1:length(catselect_pointer),
    load([hmiconfig.rsvp500lfps,sitedata.filenames{catselect_pointer(un)},'-500-',sitedata.channames{catselect_pointer(un)},'.mat']);
    average_anova(un,:,:)=lfpstructsingle_trim.mtspect_anova;
    xrange=lfpstructsingle_trim.cat_specgramMT_T;    
    yrange=lfpstructsingle_trim.cat_specgramMT_F;
    clear lfpstructsingle_trim
end
average_anova_fig=squeeze(mean(average_anova,1));
pcolor((xrange(1,:)-0.4)*1000,yrange(1,:),average_anova_fig'); shading flat; hold on
plot([0 0],[0 120],'k:'); axis square
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 120]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title({'Average ANOVA',['(All Category Selective Units(Evoked), n=',num2str(length(catselect_pointer)),')']},'FontSize',fontsize_med); colormap(flipud(hot)); caxis([0 0.1]); colorbar('SouthOutside')

subplot(1,3,2) % Average ANOVA based on Evoked Cat-Select Units
catselect_pointer=find(sitedata.cat_anova_rect<0.05);
average_anova=zeros(length(catselect_pointer),846,31); % based on size of lfpstructsingle_trim.mtspect_anova
for un=1:length(catselect_pointer),
    load([hmiconfig.rsvp500lfps,sitedata.filenames{catselect_pointer(un)},'-500-',sitedata.channames{catselect_pointer(un)},'.mat']);
    average_anova(un,:,:)=lfpstructsingle_trim.mtspect_anova;
    xrange=lfpstructsingle_trim.cat_specgramMT_T;    
    yrange=lfpstructsingle_trim.cat_specgramMT_F;
    clear lfpstructsingle_trim
end
average_anova_fig=squeeze(mean(average_anova,1));
pcolor((xrange(1,:)-0.4)*1000,yrange(1,:),average_anova_fig'); shading flat; hold on
plot([0 0],[0 120],'k:'); axis square
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 120]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title({'Average ANOVA',['(All Category Selective Units(Rect), n=',num2str(length(catselect_pointer)),')']},'FontSize',fontsize_med); colormap(flipud(hot)); caxis([0 0.1]); colorbar('SouthOutside')

subplot(1,3,3) % Average ANOVA based on Evoked Cat-Select Units
catselect_pointer=find(sitedata.freq_across_anova(:,2)<0.05);
average_anova=zeros(length(catselect_pointer),846,31); % based on size of lfpstructsingle_trim.mtspect_anova
for un=1:length(catselect_pointer),
    load([hmiconfig.rsvp500lfps,sitedata.filenames{catselect_pointer(un)},'-500-',sitedata.channames{catselect_pointer(un)},'.mat']);
    average_anova(un,:,:)=lfpstructsingle_trim.mtspect_anova;
    xrange=lfpstructsingle_trim.cat_specgramMT_T;    
    yrange=lfpstructsingle_trim.cat_specgramMT_F;
    clear lfpstructsingle_trim
end
average_anova_fig=squeeze(mean(average_anova,1));
pcolor((xrange(1,:)-0.4)*1000,yrange(1,:),average_anova_fig'); shading flat; hold on
plot([0 0],[0 120],'k:'); axis square
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 120]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title({'Average ANOVA',['(All Category Selective Units(0-20Hz), n=',num2str(length(catselect_pointer)),')']},'FontSize',fontsize_med); colormap(flipud(hot)); caxis([0 0.1]); colorbar('SouthOutside')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F8_anova_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F8_anova_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F8_anova_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)









return



%%% NESTED FUNCTIONS %%%
%%% Figure 4 Subroutines
function [numsensory,numcat,output]=extractPropGrid(data,gridlocs); % output will be multiple values (1/gridloc)
catnames={'Faces','Bodyparts','Objects','Places'};
numgrids=size(data,2); numsensory=0; numcat=[0 0 0 0];
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        tempnum_all_select=0; tempnum_cat_select=[0 0 0 0];
        tempnum_all_select=length(find(data(gg).cat_anova<0.05));
        tempnum_cat_select(1)=length(find(data(gg).cat_anova<0.05 & strcmp(data(gg).bestlabel,'Faces')==1));   
        tempnum_cat_select(2)=length(find(data(gg).cat_anova<0.05 & strcmp(data(gg).bestlabel,'Bodyparts')==1));
        tempnum_cat_select(3)=length(find(data(gg).cat_anova<0.05 & strcmp(data(gg).bestlabel,'Objects')==1));
        tempnum_cat_select(4)=length(find(data(gg).cat_anova<0.05 & strcmp(data(gg).bestlabel,'Places')==1));
        numsensory=numsensory+tempnum_all_select;
        numcat=numcat+tempnum_cat_select;
    end
end
output=numcat/numsensory*100;
return

function [numsensory,numcat,output]=extractPropGrid_rect(data,gridlocs); % output will be multiple values (1/gridloc)
catnames={'Faces','Bodyparts','Objects','Places'};
numgrids=size(data,2); numsensory=0; numcat=[0 0 0 0];
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        tempnum_all_select=0; tempnum_cat_select=[0 0 0 0];
        tempnum_all_select=length(find(data(gg).cat_anova_rect<0.05));
        tempnum_cat_select(1)=length(find(data(gg).cat_anova_rect<0.05 & strcmp(data(gg).bestlabel_rect,'Faces')==1));   
        tempnum_cat_select(2)=length(find(data(gg).cat_anova_rect<0.05 & strcmp(data(gg).bestlabel_rect,'Bodyparts')==1));
        tempnum_cat_select(3)=length(find(data(gg).cat_anova_rect<0.05 & strcmp(data(gg).bestlabel_rect,'Objects')==1));
        tempnum_cat_select(4)=length(find(data(gg).cat_anova_rect<0.05 & strcmp(data(gg).bestlabel_rect,'Places')==1));
        numsensory=numsensory+tempnum_all_select;
        numcat=numcat+tempnum_cat_select;
    end
end
output=numcat/numsensory*100;
return

function [numsensory,numcat,output]=extractPropGrid_freq(data,gridlocs,freqbin); % output will be multiple values (1/gridloc)
catnames={'Faces','Bodyparts','Objects','Places'};
numgrids=size(data,2); numsensory=0; numcat=[0 0 0 0];
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        tempnum_all_select=0; tempnum_cat_select=[0 0 0 0];
        tempnum_all_select=length(find(data(gg).freq_across_anova(:,freqbin)<0.05));
        tempnum_cat_select(1)=length(find(data(gg).freq_across_anova(:,freqbin)<0.05 & strcmp(data(gg).freq_bestlabel(:,freqbin),'Faces')==1));   
        tempnum_cat_select(2)=length(find(data(gg).freq_across_anova(:,freqbin)<0.05 & strcmp(data(gg).freq_bestlabel(:,freqbin),'Bodyparts')==1));
        tempnum_cat_select(3)=length(find(data(gg).freq_across_anova(:,freqbin)<0.05 & strcmp(data(gg).freq_bestlabel(:,freqbin),'Objects')==1));
        tempnum_cat_select(4)=length(find(data(gg).freq_across_anova(:,freqbin)<0.05 & strcmp(data(gg).freq_bestlabel(:,freqbin),'Places')==1));
        numsensory=numsensory+tempnum_all_select;
        numcat=numcat+tempnum_cat_select;
    end
end
output=numcat/numsensory*100;
return

function cmap_anova
cmap_anova = [...
    1.0000    1.0000    1.0000;    1.0000    1.0000    0.9375;    1.0000    1.0000    0.8750;    1.0000    1.0000    0.8125;...
    1.0000    1.0000    0.7500;    1.0000    1.0000    0.6875;    1.0000    1.0000    0.6250;    1.0000    1.0000    0.5625;...
    1.0000    1.0000    0.5000;    1.0000    1.0000    0.4375;    1.0000    1.0000    0.3750;    1.0000    1.0000    0.3125;...
    1.0000    1.0000    0.2500;    1.0000    1.0000    0.1875;    1.0000    1.0000    0.1250;    1.0000    1.0000    0.0625;...
    1.0000    1.0000         0;    1.0000    0.9583         0;    1.0000    0.9167         0;    1.0000    0.8750         0;...
    1.0000    0.8333         0;    1.0000    0.7917         0;    1.0000    0.7500         0;    1.0000    0.7083         0;...
    1.0000    0.6667         0;    1.0000    0.6250         0;    1.0000    0.5833         0;    1.0000    0.5417         0;...
    1.0000    0.5000         0;    1.0000    0.4583         0;    1.0000    0.4167         0;    1.0000    0.3750         0;...
    1.0000    0.3333         0;    1.0000    0.2917         0;    1.0000    0.2500         0;    1.0000    0.2083         0;...
    1.0000    0.1667         0;    1.0000    0.1250         0;    1.0000    0.0833         0;    1.0000    0.0417         0;...
    1.0000         0         0;    0.9583         0         0;    0.9167         0         0;    0.8750         0         0;...
    0.8333         0         0;    0.7917         0         0;    0.7500         0         0;    0.7083         0         0;...
    0.6667         0         0;    0.6250         0         0;    0.5833         0         0;    0.5417         0         0;...
    0.5000         0         0;    0.4583         0         0;    0.4167         0         0;    0.3750         0         0;...
    0.3333         0         0;    0.2917         0         0;    0.2500         0         0;    0.2083         0         0;...
    0.1667         0         0;    0.1250         0         0;    0.0833         0         0;    0.0417         0         0];
colormap(cmap_anova);
return

%% Figure 6 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output,avgoutput,semoutput]=extractCatSI_Grid_prefCat(sdata,catcol,gridlocs,prefcat)
gridpointer=find(ismember(sdata.gridloc,gridlocs)==1);
% Evoked
pointerB=find(strcmp(sdata.bestlabel,prefcat)==1 & sdata.cat_anova<0.05);
pointer=intersect(gridpointer,pointerB);
output.evoked=sdata.evoked_cat_si(pointer,catcol);
% Rect
pointerB=find(strcmp(sdata.bestlabel_rect,prefcat)==1 & sdata.cat_anova_rect<0.05);
pointer=intersect(gridpointer,pointerB);
output.rect=sdata.rect_cat_si(pointer,catcol);
% freq
pointerB=find(strcmp(sdata.freq_bestlabel(:,1),prefcat)==1 & sdata.freq_across_anova(:,1)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq1=sdata.freq_cat_si(pointer,catcol,1);
pointerB=find(strcmp(sdata.freq_bestlabel(:,2),prefcat)==1 & sdata.freq_across_anova(:,2)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq2=sdata.freq_cat_si(pointer,catcol,2);
pointerB=find(strcmp(sdata.freq_bestlabel(:,3),prefcat)==1 & sdata.freq_across_anova(:,3)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq3=sdata.freq_cat_si(pointer,catcol,3);
pointerB=find(strcmp(sdata.freq_bestlabel(:,4),prefcat)==1 & sdata.freq_across_anova(:,4)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq4=sdata.freq_cat_si(pointer,catcol,4);
pointerB=find(strcmp(sdata.freq_bestlabel(:,5),prefcat)==1 & sdata.freq_across_anova(:,5)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq5=sdata.freq_cat_si(pointer,catcol,5);
pointerB=find(strcmp(sdata.freq_bestlabel(:,6),prefcat)==1 & sdata.freq_across_anova(:,6)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq6=sdata.freq_cat_si(pointer,catcol,6);

[avgoutput(1),semoutput(1)]=mean_sem(output.evoked);
[avgoutput(2),semoutput(2)]=mean_sem(output.rect);
[avgoutput(3),semoutput(3)]=mean_sem(output.freq1);
[avgoutput(4),semoutput(4)]=mean_sem(output.freq2);
[avgoutput(5),semoutput(5)]=mean_sem(output.freq3);
[avgoutput(6),semoutput(6)]=mean_sem(output.freq4);
[avgoutput(7),semoutput(7)]=mean_sem(output.freq5);
[avgoutput(8),semoutput(8)]=mean_sem(output.freq6);
return

%% Figure 6 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output,avgoutput,semoutput]=extractROC_Grid_prefCat(sdata,catcols,gridlocs,prefcat)
gridpointer=find(ismember(sdata.gridloc,gridlocs)==1);
% Evoked
pointerB=find(strcmp(sdata.bestlabel,prefcat)==1 & sdata.cat_anova<0.05);
pointer=intersect(gridpointer,pointerB);
output.evoked=sdata.roc_evoked(pointer,catcols);
% Rect
pointerB=find(strcmp(sdata.bestlabel_rect,prefcat)==1 & sdata.cat_anova_rect<0.05);
pointer=intersect(gridpointer,pointerB);
output.rect=sdata.roc_rect(pointer,catcols);
% freq
pointerB=find(strcmp(sdata.freq_bestlabel(:,1),prefcat)==1 & sdata.freq_across_anova(:,1)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq1=sdata.roc_freq1(pointer,catcols);
pointerB=find(strcmp(sdata.freq_bestlabel(:,2),prefcat)==1 & sdata.freq_across_anova(:,2)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq2=sdata.roc_freq2(pointer,catcols);
pointerB=find(strcmp(sdata.freq_bestlabel(:,3),prefcat)==1 & sdata.freq_across_anova(:,3)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq3=sdata.roc_freq3(pointer,catcols);
pointerB=find(strcmp(sdata.freq_bestlabel(:,4),prefcat)==1 & sdata.freq_across_anova(:,4)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq4=sdata.roc_freq4(pointer,catcols);
pointerB=find(strcmp(sdata.freq_bestlabel(:,5),prefcat)==1 & sdata.freq_across_anova(:,5)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq5=sdata.roc_freq5(pointer,catcols);
pointerB=find(strcmp(sdata.freq_bestlabel(:,6),prefcat)==1 & sdata.freq_across_anova(:,6)<0.05); pointer=intersect(gridpointer,pointerB);
output.freq6=sdata.roc_freq6(pointer,catcols);

[avgoutput(1,:),semoutput(1,:)]=mean_sem(output.evoked,1);
[avgoutput(2,:),semoutput(2,:)]=mean_sem(output.rect,1);
[avgoutput(3,:),semoutput(3,:)]=mean_sem(output.freq1,1);
[avgoutput(4,:),semoutput(4,:)]=mean_sem(output.freq2,1);
[avgoutput(5,:),semoutput(5,:)]=mean_sem(output.freq3,1);
[avgoutput(6,:),semoutput(6,:)]=mean_sem(output.freq4,1);
[avgoutput(7,:),semoutput(7,:)]=mean_sem(output.freq5,1);
[avgoutput(8,:),semoutput(8,:)]=mean_sem(output.freq6,1);
return

%% Figure 7 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bardata=extractStimSelect_Grid(sdata,gridlocs);
bardata=zeros(8,4); cats={'Faces','Bodyparts','Objects','Places'};
for cc=1:4,
    % Evoked
    pointerF=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.bestlabel',cats(cc))==1));
    pointerS=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.bestlabel',cats(cc))==1 & sdata.anova_stim(:,cc)<0.05));
    bardata(1,cc)=(pointerS/pointerF)*100;
    % Rect
    pointerF=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.bestlabel_rect',cats(cc))==1));
    pointerS=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.bestlabel_rect',cats(cc))==1 & sdata.anova_stim(:,cc)<0.05));
    bardata(1,cc)=(pointerS/pointerF)*100;
    % Frequency
    for ff=1:6,
        pointerF=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.freq_bestlabel(:,ff),cats(cc))==1));
        tmp=squeeze(sdata.freq_within_anova(:,cc,ff));
        pointerS=length(find(ismember(sdata.gridloc,gridlocs)==1 & strcmp(sdata.freq_bestlabel(:,ff),cats(cc))==1 & tmp<0.05));
        bardata(ff+2,cc)=(pointerS/pointerF)*100;
    end
end
return