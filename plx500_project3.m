function plx500_project3(monkinitial);
%%%%%%%%%%%%%%%%%%%
% plx500_project3 %
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
disp('* plx500_project3.m - Generates figures listed under Project 2 in *')
disp('*     RSVP500_Outline.docx.                                       *')
disp('*******************************************************************')
[data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepprojectdata(hmiconfig,sheetname);

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Quantification of visual similarity)
disp('Figure 1 (Quantification of image similarity)')
%[cmpmatrix_pixel cmpmatrix_spect]=plx500_project2_imgint;

% Figure 2 (FeatureBased Encoding)
disp('Figure 2 (FeatureBased Encoding')




% Figure 3 (CategoryBased Encoding)
disp('Figure 3 (CategoryBased Encoding')

figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
catname={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5
    subplot(2,5,cc)
    pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_index.CategoryConf,catname(cc))==1);
    pointer=intersect(pointer1,pointer2);
    [bm,bs]=mean_sem(unitdata.cat_avg(pointer,:));
    hold on; bar(1:5,bm); errorbar(1:5,bm,bs); axis square
    set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','Pl','Bp','Ob'},'FontSize',7)
    ylabel('Average Response (sp/s)','FontSize',8); ylim([0 30])
    if signrank(unitdata.cat_avg(pointer,1),unitdata.cat_avg(pointer,2))<0.055,
        text(1.5,26,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.cat_avg(pointer,2),unitdata.cat_avg(pointer,3))<0.055,
        text(2.5,26,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.cat_avg(pointer,3),unitdata.cat_avg(pointer,4))<0.055,
        text(3.5,26,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.cat_avg(pointer,4),unitdata.cat_avg(pointer,5))<0.055,
        text(4.5,26,'*','FontSize',14,'FontWeight','Bold')
    end
    title({[char(catname(cc)),'-preferring neurons'],['(n=',num2str(length(pointer)),')']},'FontSize',9,'FontWeight','Bold')

    subplot(2,5,cc+5)
    rg=1+((cc-1)*5):5+((cc-1)*5);
    [bm,bs]=mean_sem(unitdata.roc_analysis(pointer,rg));
    hold on; bar(1:5,bm); errorbar(1:5,bm,bs); axis square
    if signrank(unitdata.roc_analysis(pointer,1),unitdata.roc_analysis(pointer,2))<0.055,
        text(1.5,.72,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.roc_analysis(pointer,2),unitdata.roc_analysis(pointer,3))<0.055,
        text(2.5,.72,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.roc_analysis(pointer,3),unitdata.roc_analysis(pointer,4))<0.055,
        text(3.5,.72,'*','FontSize',14,'FontWeight','Bold')
    end
    if signrank(unitdata.roc_analysis(pointer,4),unitdata.roc_analysis(pointer,5))<0.055,
        text(4.5,.72,'*','FontSize',14,'FontWeight','Bold')
    end
    set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','Pl','Bp','Ob'},'FontSize',7)
    ylabel('Avg area under ROC','FontSize',8); ylim([.5 .75])
end
jpgfigname=[hmiconfig.rsvpanal,'RSVP_Project2_Fig3a_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_Project2_Fig3a_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.5 0.9])
set(gca,'FontName','Arial','FontSize',8)
catname={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5
    subplot(5,1,cc)
    pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
    pointer2=find(ismember(unit_index.CategoryConf,catname(cc))==1);
    pointer=intersect(pointer1,pointer2);
    [bm,bs]=mean_sem(unitdata.stimresponse(pointer,:));
    hold on; bar(1:100,bm); errorbar(1:100,bm,bs);
    ylabel('Average Response (sp/s)','FontSize',8); ylim([10 30]); xlim([0 101]);
    set(gca,'FontSize',7); axis off
    text(10,-5,'Face Stimuli','HorizontalAlignment','Center','FontSize',8)
    text(30,-5,'Fruit Stimuli','HorizontalAlignment','Center','FontSize',8)
    text(50,-5,'Place Stimuli','HorizontalAlignment','Center','FontSize',8)
    text(70,-5,'BodyPart Stimuli','HorizontalAlignment','Center','FontSize',8)
    text(90,-5,'Object Stimuli','HorizontalAlignment','Center','FontSize',8)
    title([char(catname(cc)),'-preferring neurons (n=',num2str(length(pointer)),')'],'FontSize',9,'FontWeight','Bold')
end
jpgfigname=[hmiconfig.rsvpanal,'RSVP_Project2_Fig3b_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_Project2_Fig3b_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)









return











return

%%% NESTED FUNCTIONS %%%
