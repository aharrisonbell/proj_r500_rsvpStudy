function plx500_project1nt(monkinitial,neurontype);
%%%%%%%%%%%%%%%%%%%
% plx500_project1 %
%%%%%%%%%%%%%%%%%%%
% written by AHB, Jan2009,
% based on plx500_sortgrid - adapted to follow RSVP500_Outline, and to be
% compatible with both Monkeys
% MONKINITIAL (required) = 'W' or 'S'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin<2, error('You must specify a monkey (''S''/''W'') and neuron type (''ns''/''bs'''); elseif nargin==1, option=[1]; end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
    % Grid location groups for comparison
    grp(1).grids={'A7L2','A7L1','A7R1'}; % n=87
    grp(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % n=100
    grp(3).grids={'A4L2','A4L1','A4R1'}; % n=87
    grp(4).grids={'A2L5','A0L6','A0L2','A0R0','P1L1','P2L3','P3L5','P3L4'}; % n=128
    grp(5).grids={'P5L3','P6L3','P6L2','P6L1','P7L2'}; % n=74
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
    % Grid location groups for comparison
    grp(1).grids={'A6R2','A5R0','A4R3'}; % n=48
    grp(2).grids={'A3R0','A2R1','A2R3','A2R5'}; % n=112
    grp(3).grids={'P1R0','P1R3'}; % n=88
    grp(4).grids={'P3R0','P3R2','P5R0'}; % n=70
    grp(5).grids={'P3R0','P3R2','P5R0'}; % n=70
end
if neurontype=='ns'
    neurlabel='NarrowSpiking'
else
    neurontype='BroadSpiking'
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
disp('******************************************************************************')
disp('* plx500_project1_neurontype.m - Generates figures listed under Project 1 in *')
disp('*     RSVP500_Outline.docx.  This version breaks down the data according to  *')
disp('*     neuron type.                                                           *')
disp('******************************************************************************')
[data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepprojectdata(hmiconfig,sheetname);

[data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject2data(hmiconfig,sheetname,'ns');
[dataBS,numgridsBS,countsBS,allunitsBS,unit_indexBS,unitdataBS]=plx500_prepproject2data(hmiconfig,sheetname,'bs');

save([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'Project1DataNT_',monkeyname,'_',neurontype,'.mat'],'data','unit_index','unitdata');

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Methods) - create manually
disp('Figure 1 (Methods) - create manually)')
% Figure 2  (Neuron Distribution Figure)
disp('Figure 2  (Neuron Distribution Figure)')
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6]); set(gca,'FontName','Arial','FontSize',8);
subplot(2,3,1); 
piedata(1)=length(find(strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(2)=length(find(strcmp(unit_index.SensoryConf,'Non-Responsive')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str((piedata(1)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(2)/sum(piedata))*100,'%1.2g'),'%)']})
title(['(A) Sensory/Non-Responsive (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(2,3,2); piedata=[];
piedata(1)=length(find(strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(2)=length(find(strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(3)=length(find(strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str(piedata(1)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str(piedata(2)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(3)),'(',num2str(piedata(3)/sum(piedata)*100,'%1.2g'),'%)']})
title(['(B) Excite/Inhibit/Both (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','Location','Best'); set(gca,'FontSize',7)
subplot(2,3,3); bardataS=[]; bardataW=[]; bardata=[]; % breakdown of category selectivity according to response type
bardata(1,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1));
bardata(1,2)=length(find(strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1));
bardata(2,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1));
bardata(2,2)=length(find(strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1));
bardata(3,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1));
bardata(3,2)=length(find(strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1));
bardata(1,3)=bardata(1,1)/sum(bardata(1,1:2)); bardata(1,4)=bardata(1,2)/sum(bardata(1,1:2));
bardata(2,3)=bardata(2,1)/sum(bardata(2,1:2)); bardata(2,4)=bardata(2,2)/sum(bardata(2,1:2));
bardata(3,3)=bardata(3,1)/sum(bardata(3,1:2)); bardata(3,4)=bardata(3,2)/sum(bardata(3,1:2));
bar(1:3,bardata(:,3:4),'stack')
text(1,.25,['n=',num2str(bardata(1,1))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.75,['n=',num2str(bardata(1,2))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.25,['n=',num2str(bardata(2,1))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.75,['n=',num2str(bardata(2,2))],'FontSize',6,'HorizontalAlignment','Center')
text(3,.25,['n=',num2str(bardata(3,1))],'FontSize',6,'HorizontalAlignment','Center')
text(3,.75,['n=',num2str(bardata(3,2))],'FontSize',6,'HorizontalAlignment','Center')
title(['(C) Selective/Non-Selective (n=',num2str(sum(sum(bardata(:,1:2)))),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
set(gca,'XTick',1:3,'XTickLabel',{'E','B','I'}); ylabel('% of Neurons');
axis square
subplot(2,3,4); bardata=[]; % preferred excitatory categories
bardata(1,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.pref_excite,'Faces')==1));
bardata(1,2)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.pref_excite,'BodyParts')==1));
bardata(1,3)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.pref_excite,'Fruit')==1));
bardata(1,4)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.pref_excite,'Objects')==1));
bardata(1,5)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.pref_excite,'Places')==1));
bardata(2,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_excite,'Faces')==1));
bardata(2,2)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_excite,'BodyParts')==1));
bardata(2,3)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_excite,'Fruit')==1));
bardata(2,4)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_excite,'Objects')==1));
bardata(2,5)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_excite,'Places')==1));
bardata(1,6) =bardata(1,1)/sum(bardata(1,1:5)); bardata(2,6) =bardata(2,1)/sum(bardata(2,1:5));
bardata(1,7) =bardata(1,2)/sum(bardata(1,1:5)); bardata(2,7) =bardata(2,2)/sum(bardata(2,1:5));
bardata(1,8) =bardata(1,3)/sum(bardata(1,1:5)); bardata(2,8) =bardata(2,3)/sum(bardata(2,1:5));
bardata(1,9) =bardata(1,4)/sum(bardata(1,1:5)); bardata(2,9) =bardata(2,4)/sum(bardata(2,1:5));
bardata(1,10)=bardata(1,5)/sum(bardata(1,1:5)); bardata(2,10)=bardata(2,5)/sum(bardata(2,1:5));
bar(1:2,bardata(1:2,6:10),'stack')
text(1,.15,['n=',num2str(bardata(1,1))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.35,['n=',num2str(bardata(1,2))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.55,['n=',num2str(bardata(1,3))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.75,['n=',num2str(bardata(1,4))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.95,['n=',num2str(bardata(1,5))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.15,['n=',num2str(bardata(2,1))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.35,['n=',num2str(bardata(2,2))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.55,['n=',num2str(bardata(2,3))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.75,['n=',num2str(bardata(2,4))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.95,['n=',num2str(bardata(2,5))],'FontSize',6,'HorizontalAlignment','Center')
title(['(D) Excitatory Responses (n=',num2str(sum(sum(bardata(:,1:5)))),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Bp','Ft','Ob','Pl','Location','Best'); set(gca,'FontSize',7)
set(gca,'XTick',1:2,'XTickLabel',{'E','B'}); ylabel('% of Neurons');
axis square
subplot(2,3,5); bardata=[]; % preferred inhibited categories
bardata(1,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_inhibit,'Faces')==1));
bardata(1,2)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_inhibit,'BodyParts')==1));
bardata(1,3)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_inhibit,'Fruit')==1));
bardata(1,4)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_inhibit,'Objects')==1));
bardata(1,5)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.pref_inhibit,'Places')==1));
bardata(2,1)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.pref_inhibit,'Faces')==1));
bardata(2,2)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.pref_inhibit,'BodyParts')==1));
bardata(2,3)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.pref_inhibit,'Fruit')==1));
bardata(2,4)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.pref_inhibit,'Objects')==1));
bardata(2,5)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.pref_inhibit,'Places')==1));
bardata(1,6) =bardata(1,1)/sum(bardata(1,1:5)); bardata(2,6) =bardata(2,1)/sum(bardata(2,1:5));
bardata(1,7) =bardata(1,2)/sum(bardata(1,1:5)); bardata(2,7) =bardata(2,2)/sum(bardata(2,1:5));
bardata(1,8) =bardata(1,3)/sum(bardata(1,1:5)); bardata(2,8) =bardata(2,3)/sum(bardata(2,1:5));
bardata(1,9) =bardata(1,4)/sum(bardata(1,1:5)); bardata(2,9) =bardata(2,4)/sum(bardata(2,1:5));
bardata(1,10)=bardata(1,5)/sum(bardata(1,1:5)); bardata(2,10)=bardata(2,5)/sum(bardata(2,1:5));
bar(1:2,bardata(1:2,6:10),'stack')
text(1,.15,['n=',num2str(bardata(1,1))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.35,['n=',num2str(bardata(1,2))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.55,['n=',num2str(bardata(1,3))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.75,['n=',num2str(bardata(1,4))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.95,['n=',num2str(bardata(1,5))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.15,['n=',num2str(bardata(2,1))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.35,['n=',num2str(bardata(2,2))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.55,['n=',num2str(bardata(2,3))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.75,['n=',num2str(bardata(2,4))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.95,['n=',num2str(bardata(2,5))],'FontSize',6,'HorizontalAlignment','Center')
title(['(E) Inhibited Responses (n=',num2str(sum(sum(bardata(:,1:5)))),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Bp','Ft','Ob','Pl','Location','Best'); set(gca,'FontSize',7); ylabel('% of Neurons');
set(gca,'XTick',1:2,'XTickLabel',{'B','I'})
axis square
subplot(2,3,6); pmap=zeros(5,5); % both neurons
catnames={'Faces','BodyParts','Fruit','Objects','Places'};
for y=1:5, % each column (inhibit responses)
    for x=1:5, % each row (excite responses)
        pmap(y,x)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & ...
            strcmp(unit_index.pref_excite,catnames(x))==1 & strcmp(unit_index.pref_inhibit,catnames(y))==1));
    end
end
pmap=[pmap;[0 0 0 0 0]]; pmap=[pmap,[0 0 0 0 0 0]'];
tt=sum(sum(pmap)); pmap2=pmap/tt;
pcolor(pmap2); shading flat; set(gca,'YDir','reverse');
axis square; set(gca,'CLim',[0 .20]); 
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
set(gca,'XTick',1.5:5.5,'XTickLabel',catnames,'YTick',1.5:5.5,'YTickLabel',catnames,'FontSize',7)
ylabel('Preferred Inhibited Category','fontsize',7);
xlabel('Preferred Excited Category','fontsize',7);
colorbar('SouthOutside','FontSize',6)
title(['(F) Breakdown of Excite/Inhibited Responses of BOTH Neurons (n=',num2str(tt),')'],'FontSize',fontsize_med,'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig1_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig1_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig1_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 2 - Raw SI histogram of all category selective neurons
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,4,1)
dd=extractRawSI(unit_index,unitdata,5:19); hist(dd,0:0.1:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw EXCITATORY SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(dd))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Excitatory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,2)
dd2=abs(extractRawSI_inhibit(unit_index,unitdata,5:19)); hist(dd2,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw INHIBITED SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(dd2))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd2)),' (',num2str(sem(dd2),'%1.2g'),')'],'FontSize',7)
[p,h]=ranksum(dd,dd2); text(0.6,140,['P=',num2str(p,'%1.2g')],'FontSize',7);
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Inhibitory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,3)
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
title({'Category Selectivity of CatSelective Neurons)','Excitatory Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,4)
faceSI=extractCatSI_inhibit(unit_index,unitdata,'Faces',1);
fruitSI=extractCatSI_inhibit(unit_index,unitdata,'Fruit',2);
placeSI=extractCatSI_inhibit(unit_index,unitdata,'Places',3);
bpartSI=extractCatSI_inhibit(unit_index,unitdata,'BodyParts',4);
objectSI=extractCatSI_inhibit(unit_index,unitdata,'Objects',5);
hold on
bar([mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)])
errorbar(1:5,[mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(fruitSI) sem(objectSI) sem(placeSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Face','BPart','Fruit','Object','Place'})
ylabel('Average Category SI','FontSize',8); ylim([-0.5 0]); axis square
text(1,-.48,['n=',num2str(length(faceSI))],'FontSize',7)
text(2,-.48,['n=',num2str(length(bpartSI))],'FontSize',7)
text(3,-.48,['n=',num2str(length(fruitSI))],'FontSize',7)
text(4,-.48,['n=',num2str(length(objectSI))],'FontSize',7)
text(5,-.48,['n=',num2str(length(placeSI))],'FontSize',7)
[p,h]=ranksum(faceSI,bpartSI); text(1.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(bpartSI,fruitSI); text(2.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(fruitSI,objectSI); text(3.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(objectSI,placeSI); text(4.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(faceSI,placeSI); text(3,-0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
title({'Category Selectivity of CatSelective Neurons)','Inhibited Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,5)
antSI=extractRawSI(unit_index,unitdata,ant); 
midSI=extractRawSI(unit_index,unitdata,mid); 
postSI=extractRawSI(unit_index,unitdata,post); 
hold on
bar([mean(antSI) mean(midSI) mean(postSI)])
errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
[p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
title({'Raw SI vs AP Location','Excitatory Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,6)
antSI=abs(extractRawSI_inhibit(unit_index,unitdata,ant)); 
midSI=abs(extractRawSI_inhibit(unit_index,unitdata,mid)); 
postSI=abs(extractRawSI_inhibit(unit_index,unitdata,post)); 
hold on
bar([mean(antSI) mean(midSI) mean(postSI)])
errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
[p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
[p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
title({'Raw SI vs AP Location','Inhibited Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,7) % uninterpolated raw selectivity of all excitatory/both neurons
surfdata=[]; validgrids=[];
for g=1:numgrids,
    surfdata(g,1:2)=data(g).grid_coords;
    if isempty(data(g).exciteraw_si_all_corr_mean)==1,
        surfdata(g,3)=0; else
        surfdata(g,3)=data(g).exciteraw_si_all_corr_mean;
    end
    surfdata(g,4)=sum(data(g).counts);
end
% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata);
pcolor(gridmap); shading flat
axis square; set(gca,'CLim',[0 0.30]); 
set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
[p,h]=chi2_test(obs,exp);
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
title({'Raw SI across IT for all Excite/Both neurons',['(ChiSquare(flawed): p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
subplot(2,4,8) % uninterpolated raw selectivity of all inhibit/both neurons
surfdata=[]; validgrids=[];
for g=1:numgrids,
    surfdata(g,1:2)=data(g).grid_coords;
    if isempty(data(g).inhibitraw_si_all_corr_mean)==1,
        surfdata(g,3)=0; else
        surfdata(g,3)=data(g).inhibitraw_si_all_corr_mean;
    end
    surfdata(g,4)=sum(data(g).counts);
end
% Need to convert surfdata to a 10*10 matrix
gridmap=plx500_surfdata2gridmap(surfdata);
pcolor(gridmap); shading flat
axis square; set(gca,'CLim',[-0.30 0]); 
set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
ylabel('Distance from interaural axis (mm)','fontsize',7);
xlabel('Distance from meridian (mm)','fontsize',7);
obs=abs(surfdata(:,3))*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
[p,h]=chi2_test(obs,exp);
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
title({'Raw SI across IT for all Inhibit/Both neurons',['(ChiSquare(flawed): p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig2_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig2_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig2_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)



% figure; clf; cla; % selectivity index histograms for SELECTIVE NEURONS
% set(gcf,'Units','Normalized','Position',[0.05 0.05 0.9 0.9])
% set(gca,'FontName','Arial','FontSize',8)
% catname={'Faces','Fruit','Places','BodyParts','Objects'};
% for cc=1:5,
%     subplot(2,5,cc)
%     set(gca,'FontName','Arial','FontSize',8)
%     % selectivity only for excitatory/both + sensory neurons
%     pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
%     pointer2=find(ismember(unit_index.ExciteConf,{'Excite' 'Both'})==1);
%     pointer=intersect(pointer1,pointer2);
%     dd=unitdata.cat_si(pointer,cc);
%     hist(dd,-1:0.05:1)
%     set(gca,'FontName','Arial','FontSize',8)
%     xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8); xlim([-1 1]);
%     text(0.6,30,['n=',num2str(length(pointer))],'FontSize',7)
%     text(0.6,35,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
%     axis square
%     title({['(F) Average ',char(catname(cc)),' Selectivity'],'(All Excite/Both Neurons)'},'FontWeight','Bold')
% end
% for cc=1:5,
%     subplot(2,5,cc+5)
%     set(gca,'FontName','Arial','FontSize',8)
%     % selectivity only for excitatory/both + sensory neurons
%     pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
%     pointer2=find(ismember(unit_index.ExciteConf,{'Excite' 'Both'})==1);
%     pointert=intersect(pointer1,pointer2);
%     pointer3=find(ismember(unit_index.CategoryConf,catname(cc))==1);
%     pointer=intersect(pointert,pointer3);
%     dd=unitdata.cat_si(pointer,cc);
%     hist(dd,-1:0.05:1)
%     set(gca,'FontName','Arial','FontSize',8)
%     xlabel([char(catname(cc)),' Selectivity Index'],'FontSize',8); ylabel('# Neurons','FontSize',8); xlim([-0.25 1]);
%     text(0.5,5,['n=',num2str(length(pointer))],'FontSize',7)
%     text(0.5,10,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
%     axis square
%     title({['(F) Average ',char(catname(cc)),' Selectivity'],'(All Excite/Both / Preferring Neurons)'},'FontWeight','Bold')
% end
%jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig3_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig3_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig3_',monkeyname,'.fig'])
%if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 3  (Examples) - create manually from output of plx500;
disp('Figure 3  (Examples) - create manually from output of plx500')

% Figure 4  (Stimulus Selectivity Figure)
disp('Figure 4  (Stimulus Selectivity Figure)')
%%% stimulus electivity according to category (preferred)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,2,1) % Within category selectivity
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
title({'Within Category Selectivity (per category)',['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(1,2,2) % uninterpolated stimulus selectivity
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
title({'Proportion of Stim-Selective Neurons',['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',9,'FontWeight','Bold')
colorbar('SouthOutside','FontSize',6)
% subplot(1,3,3) % surface plot - stimulus selectivity
% surfdata=[];
% for g=1:numgrids,
%     surfdata(g,1:2)=data(g).grid_coords;
%     surfdata(g,3)=sum(data(g).within_counts)/sum(data(g).counts);
%     if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
% end
% %%% clip NaNs
% ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
% vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
% [uu,vv]=meshgrid(ulin,vlin);
% pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
% h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
% hold on
% plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
% axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
% axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .75]); colormap(mp);
% xlabel('Distance from interaural axis (mm)','fontsize',7);
% ylabel('Distance from midline (mm)','fontsize',7);
% title('Proportion of Stimulus Selective Neurons','FontSize',9,'FontWeight','Bold')
%axis off
colorbar('SouthOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig4_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig4_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig4_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 4a (Stimulus Selectivity Figure - Individual Example)
%plx500_stimselect(stimselectfiles);

% Figure 5  (Analysis of Distribution of Category-Preferring Neurons) -
% Proportion
disp('Figure 5  (Analysis of Distribution of Category-Preferring Neurons)')
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(3,5,pn) % surface plot - face proportion
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)=data(gridloc).propE(pn);
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
    title({[char(labels(pn)),' Proportion'],['Excite (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
    %axis off
    colorbar('SouthOutside','FontSize',6)
end
for pn=1:5,
    subplot(3,5,pn+5) % surface plot - face proportion
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)=data(gridloc).propI(pn);
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
    title({[char(labels(pn)),' Proportion'],['Inhibit (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
    %axis off
    colorbar('SouthOutside','FontSize',6)
end
for pn=1:5,
    subplot(3,5,pn+10) % surface plot - face proportion
    surfdata=[]; validgrids=[];
    % Filter out any sites that don't have at least 5 neurons
    for g=1:numgrids,
        if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
    end
    %validgrids=1:numgrids; % do not eliminate grids
    for g=1:length(validgrids),
        gridloc=validgrids(g);
        surfdata(g,1:2)=data(gridloc).grid_coords;
        surfdata(g,3)=data(gridloc).propB(pn);
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
    title({[char(labels(pn)),' Proportion'],['Both (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
    %axis off
    colorbar('SouthOutside','FontSize',6)
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig5_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig5_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig5_',monkeyname,'.fig'])
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
    subplot(1,5,pn) % surface plot - face selectivity
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
    title({[char(labels(pn)),' Selectivity (CatPrefNeurons)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
    colorbar('SouthOutside','FontSize',6)
end
% for pn=1:5,
%     subplot(2,5,pn+5) % surface plot - face selectivity
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     %validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)  =data(gridloc).cat_si_corr_mean(pn);
%         if isnan(surfdata(g,3))==1,  surfdata(g,3)=0; end
%     end
%     %%% clip NaNs
%     ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
%     vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
%     [uu,vv]=meshgrid(ulin,vlin);
%     pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
%     h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
%     hold on
%     plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
%     axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
%     axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
%     xlabel('Distance from interaural axis (mm)','fontsize',6);
%     ylabel('Distance from midline (mm)','fontsize',6);
%     title({[char(labels(pn)),' Selectivity'],'(CatPrefNeurons)'},'FontSize',fontsize_med,'FontWeight','Bold')
%     axis off
%     colorbar('SouthOutside','FontSize',6)    
% end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig6_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig6_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig6_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 7' (Analysis of Selectivity-Indices of ALL SENSORY Neurons)
disp('Figure 7'' (Analysis of Selectivity-Indices of ALL SENSORY Neurons)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
labels={'Face','Fruit','Place','Bodypart','Object'};
for pn=1:5,
    subplot(1,5,pn) % surface plot - face selectivity
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
    title({[char(labels(pn)),' Selectivity (All Neurons)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
    colorbar('SouthOutside','FontSize',6)
end
% for pn=1:5,
%     subplot(2,5,pn+5) % surface plot - face selectivity
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     %validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)  =data(gridloc).cat_si_all_corr_mean(pn);
%         if isnan(surfdata(g,3))==1,  surfdata(g,3)=0; end
%     end
%     %%% clip NaNs
%     ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
%     vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
%     [uu,vv]=meshgrid(ulin,vlin);
%     pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
%     h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
%     hold on
%     plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
%     axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
%     axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[-.15 .15]); colormap(mp);
%     xlabel('Distance from interaural axis (mm)','fontsize',6);
%     ylabel('Distance from midline (mm)','fontsize',6);
%     title({[char(labels(pn)),' Selectivity'],'(All Neurons)'},'FontSize',7,'FontWeight','Bold')
%     axis off
%     colorbar('SouthOutside','FontSize',6)    
% end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig7_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig7_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig7_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% % Figure 8 (Analysis of Pure Selectivity-Indices for Category-Preferring Neurons)
% disp('Figure 8 (Analysis of Pure Selectivity-Indices for Category-Preferring Neurons')
% %%%% 5x5 matrix -- contrast each class of cat-pref neuron with each other
% for cc=1:5, % one figure per preferred category
%     figure; clf; cla;
%     set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
%     set(gca,'FontName','Arial','FontSize',8)
%     labels={'Face','Fruit','Place','Bodypart','Object'};
%     for pn=1:5, % once per contrast category
%         subplot(1,5,pn) % surface plot
%         surfdata=[]; validgrids=[];
%         % Filter out any sites that don't have at least 5 neurons
%         for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
%         validgrids=1:numgrids; % do not eliminate grids
%         for g=1:length(validgrids),
%             gridloc=validgrids(g);
%             surfdata(g,1:2)=data(gridloc).grid_coords;
%             surfdata(g,3)  =data(gridloc).pure_si_corr_mean(cc,pn);
%             if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%         end
%         obs=surfdata(:,3)*100; avgtmp=mean(obs); exp=ones(length(obs),1)*avgtmp;
%         [p,h]=chi2_test(obs,exp);
%         %%% Need to convert surfdata to a 10*10 matrix
%         gridmap=plx500_surfdata2gridmap(surfdata,1);
%         pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
%         axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%         %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%         ylabel('Distance from interaural axis (mm)','fontsize',6);
%         xlabel('Distance from midline (mm)','fontsize',6);
%         title({[char(labels(pn)),' Selectivity (CatPref Neurons)'],['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
% %         subplot(2,5,pn+5) % surface plot - face selectivity
% %         ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
% %         vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
% %         [uu,vv]=meshgrid(ulin,vlin);
% %         pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
% %         h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
% %         hold on
% %         plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
% %         axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
% %         axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
% %         xlabel('Distance from interaural axis (mm)','fontsize',7);
% %         ylabel('Distance from midline (mm)','fontsize',7);
% %         title({[char(labels(pn)),' Selectivity'],'(CatPref Neurons)'},'FontSize',7,'FontWeight','Bold')
% %         axis off
%         colorbar('SouthOutside','FontSize',6)
%     end
%     jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig8_',monkeyname,'_',char(labels(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%     illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig8_',monkeyname,'_',char(labels(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%     hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig8_',monkeyname,'.fig'])    
%     if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% end


% Figure 9 (Other Possibilities breakdown of neuron type/response type);
% disp('Figure 9 (Other Possibilities breakdown of neuron type/response type)')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% labels={'Face','Fruit','Place','Bodypart','Object'};
% %%% neuron type (sensory/non-responsive)
% subplot(2,5,1) % surface plot
% surfdata=[]; validgrids=[];
% % Filter out any sites that don't have at least 5 neurons
% for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
% validgrids=1:numgrids; % do not eliminate grids
% for g=1:length(validgrids),
%     gridloc=validgrids(g);
%     surfdata(g,1:2)=data(gridloc).grid_coords;
%     surfdata(g,3)  =data(gridloc).numsensory/data(gridloc).numunits;
%     if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%     surfdata(g,4)=data(gridloc).numsensory;
%     surfdata(g,5)=data(gridloc).numunits;
% end
% %%% Need to convert surfdata to a 10*10 matrix
% exp=prep_chidata(surfdata(:,3),surfdata(:,5));
% [p,h]=chi2_test(surfdata(:,4),exp);
% gridmap=plx500_surfdata2gridmap(surfdata,1);
% pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
% axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
% %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
% ylabel('Distance from interaural axis (mm)','fontsize',6);
% xlabel('Distance from midline (mm)','fontsize',6);
% title({'Distribution of neurons','Sensory vs. Non-Responsive',['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',7,'FontWeight','Bold')
% subplot(2,5,6) % surface plot - face selectivity
% ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
% vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
% [uu,vv]=meshgrid(ulin,vlin);
% pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
% h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
% hold on
% plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
% axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
% axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 1]); colormap(mp);
% xlabel('Distance from interaural axis (mm)','fontsize',6);
% ylabel('Distance from midline (mm)','fontsize',6);
% title({'Distribution of neurons','Sensory vs. Non-Responsive'},'FontSize',7,'FontWeight','Bold')
% axis off
% colorbar('SouthOutside','FontSize',6)
% subplot(2,5,2) % category-selective vs. not-category selective
% surfdata=[]; validgrids=[];
% % Filter out any sites that don't have at least 5 neurons
% for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
% validgrids=1:numgrids; % do not eliminate grids
% for g=1:length(validgrids),
%     gridloc=validgrids(g);
%     surfdata(g,1:2)=data(gridloc).grid_coords;
%     surfdata(g,3)  =data(gridloc).count_selective(1)/data(g).numunits;
%     if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
% end
% %%% Need to convert surfdata to a 10*10 matrix
% gridmap=plx500_surfdata2gridmap(surfdata,1);
% pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
% axis square; set(gca,'CLim',[0 1]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
% %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
% ylabel('Distance from interaural axis (mm)','fontsize',6);
% xlabel('Distance from midline (mm)','fontsize',6);
% title({'Distribution','Category Selective vs. Non-Selective'},'FontSize',7,'FontWeight','Bold')
% subplot(2,5,7)
% ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
% vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
% [uu,vv]=meshgrid(ulin,vlin);
% pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
% h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
% hold on
% plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
% axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
% axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 1]); colormap(mp);
% xlabel('Distance from interaural axis (mm)','fontsize',6);
% ylabel('Distance from midline (mm)','fontsize',6);
% title({'Distribution','Category Selective vs. Non-Selective'},'FontSize',7,'FontWeight','Bold')
% axis off
% colorbar('SouthOutside','FontSize',6)        
% label={'Pure Excitatory' 'Both Excitatory/Inhibitory' 'Pure Inhibited'};
% for pn=1:3
%     subplot(2,5,2+pn) % category-selective vs. not-category selective
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids, if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end; end
%     validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)  =data(gridloc).count_resptype(pn)/data(g).numunits;
%         if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%     end
%     %%% Need to convert surfdata to a 10*10 matrix
%     gridmap=plx500_surfdata2gridmap(surfdata,1);
%     pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
%     axis square; set(gca,'CLim',[0 .5]); mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%     %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%     ylabel('Distance from interaural axis (mm)','fontsize',6);
%     xlabel('Distance from midline (mm)','fontsize',6);
%     title({'Response Type',['(',char(label(pn)),')']},'FontSize',7,'FontWeight','Bold')
%     subplot(2,5,7+pn)
%     ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
%     vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
%     [uu,vv]=meshgrid(ulin,vlin);
%     pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
%     h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
%     hold on
%     plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
%     axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
%     axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5]); colormap(mp);
%     xlabel('Distance from interaural axis (mm)','fontsize',6);
%     ylabel('Distance from midline (mm)','fontsize',6);
%     title({'Response Type',['(',char(label(pn)),')']},'FontSize',7,'FontWeight','Bold')
%     colorbar('SouthOutside','FontSize',6)
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig9_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig9_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig9_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%% New Figures (from population)
% Figure 10 - Raw SI histogram
% figure; clf; cla; % selectivity index histograms
% set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% subplot(1,2,1)
% dd=extractRawSI(unit_index,unitdata,5:19);
% hist(dd,0:0.1:1)
% set(gca,'FontName','Arial','FontSize',8)
% xlabel('Raw Selectivity Index','FontSize',8); ylabel('# Neurons','FontSize',8);
% text(0.6,80,['n=',num2str(length(dd))],'FontSize',7)
% text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
% title({'Average Raw SI (for Sensory+Excite/Both Neurons)',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% subplot(1,2,2)
% antSI=extractRawSI(unit_index,unitdata,ant);
% midSI=extractRawSI(unit_index,unitdata,mid);
% postSI=extractRawSI(unit_index,unitdata,post);
% hold on
% bar([mean(antSI) mean(midSI) mean(postSI)]);
% errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)]);
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
% ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
% [p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% title({'Raw SI vs AP Location (for Sensory+Excite/Both Neurons)',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig10_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig10_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig10_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 11 - Category SI histogram (for CatPreferring Neurons)
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% faceSI=extractCatSI(unit_index,unitdata,'Faces',1);
% fruitSI=extractCatSI(unit_index,unitdata,'Fruit',2);
% placeSI=extractCatSI(unit_index,unitdata,'Places',3);
% bpartSI=extractCatSI(unit_index,unitdata,'BodyParts',4);
% objectSI=extractCatSI(unit_index,unitdata,'Objects',5);
% hold on
% bar([mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)])
% errorbar(1:5,[mean(faceSI) mean(bpartSI) mean(fruitSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(fruitSI) sem(objectSI) sem(placeSI)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Face','BPart','Fruit','Object','Place'})
% ylabel('Average Category SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(faceSI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(bpartSI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(fruitSI))],'FontSize',7)
% text(4,.48,['n=',num2str(length(objectSI))],'FontSize',7)
% text(5,.48,['n=',num2str(length(placeSI))],'FontSize',7)
% [p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(bpartSI,fruitSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(fruitSI,objectSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(objectSI,placeSI); text(4.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(faceSI,placeSI); text(3,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% title({'Category Selectivity of Excite/Both Preferring Neurons',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig11_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig11_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig11_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 12 - Stimulus Selectivity Figure
% figure; clf; cla; 
% set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% subplot(1,2,1)
% stimB=extractStimSelect(data,5:19);
% bar(stimB(:,2:3),'stack')
% tmp=sum(stimB); tmpprc=tmp(2)/tmp(1); stimB(:,4)=stimB(:,1)*tmpprc;
% [p,h]=chi2_test(stimB(:,2),stimB(:,4));
% for c=1:5, text(c,stimB(c,1)+5,[num2str(stimB(c,2)/stimB(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
% set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
% legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
% title({'Within Category Selectivity (per category)',[monkeyname,': (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
% subplot(1,2,2)
% antStim=extractStimSelect(data,ant);
% midStim=extractStimSelect(data,mid); 
% postStim=extractStimSelect(data,post);
% hold on
% bar([mean(antStim(:,4)) mean(midStim(:,4)) mean(postStim(:,4))])
% errorbar(1:3,[mean(antStim(:,4)) mean(midStim(:,4)) mean(postStim(:,4))],[sem(antStim(:,4)) sem(midStim(:,4)) sem(postStim(:,4))])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
% ylabel('Average % StimSelective Neurons','FontSize',8); ylim([0 75]); axis square
% text(1,58,['n=',num2str(sum(antStim(:,1)))],'FontSize',7)
% text(2,58,['n=',num2str(sum(midStim(:,1)))],'FontSize',7)
% text(3,58,['n=',num2str(sum(postStim(:,1)))],'FontSize',7)
% title({'Proportion of StimSelective Neurons (for given category)',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig12_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig12_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig12_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% % Figure 13 - Category Proportion and Selectivity for Both Monkeys for each Category
% figure; clf; cla; 
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% catnames={'Face','Fruit','Place','Bodypart','Object'};
% for cc=1:5, % once per category
%     subplot(3,5,cc)
%     [ans,anc,aprop]=extractCatProp_(data,ant,cc);
%     [mns,mnc,mprop]=extractCatProp(data,mid,cc);
%     [pns,pnc,pprop]=extractCatProp(data,post,cc);
%     antprop=(anc/ans)*100;
%     midprop=(mnc/mns)*100;
%     postprop=(pnc/pns)*100;
%     bar([antprop midprop postprop]);
%     x2=chi2_test([antprop midprop postprop],[33.3 33.3 33.3]);
%     set(gca,'FontName','Arial','FontSize',7,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
%     ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
%     title([char(catnames(cc)),'-selective Neurons'],'FontSize',7,'FontWeight','Bold')
%     text(2,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
%     text(1,40,['n=',num2str([ans])],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,40,['n=',num2str([mns])],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,40,['n=',num2str([pns])],'FontSize',7,'HorizontalAlignment','Center')
% end
% catnames={'Faces','Fruit','Places','BodyParts','Objects'};
% for cc=1:5, % category selectivity of CategoryPreferringNeurons
%     subplot(3,5,cc+5)
%     SIant=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,ant);
%     SImid=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,mid);
%     SIpost=extractCatSI_AP(unit_index,unitdata,catnames(cc),cc,post);
%     hold on
%     bar([mean(SIant) mean(SImid) mean(SIpost)])
%     errorbar(1:3,[mean(SIant) mean(SImid) mean(SIpost)],[sem(SIant) sem(SImid) sem(SIpost)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
%     ylabel('Average CatSI','FontSize',8); ylim([0 .5]); axis square
%     text(1,.38,['n=',num2str(length(SIant))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.38,['n=',num2str(length(SImid))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.38,['n=',num2str(length(SIpost))],'FontSize',7,'HorizontalAlignment','Center')
%     title({[char(catnames(cc)),'-Selectivity (CatPref Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);    
%     try [p,h]=ranksum(SIant,SImid); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SImid,SIpost); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SIant,SIpost); text(2,0.48,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% for cc=1:5, % category selectivity of ALL neurons
%     subplot(3,5,cc+10)
%     SIant=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,ant);
%     SImid=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,mid);
%     SIpost=extractCatSI_APall(unit_index,unitdata,catnames(cc),cc,post);
%     hold on
%     bar([mean(SIant) mean(SImid) mean(SIpost)])
%     errorbar(1:3,[mean(SIant) mean(SImid) mean(SIpost)],[sem(SIant) sem(SImid) sem(SIpost)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
%     ylabel('Average CatSI','FontSize',8); ylim([-0.15 .15]); axis square
%     text(1,-.14,['n=',num2str(length(SIant))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,-.14,['n=',num2str(length(SImid))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,-.14,['n=',num2str(length(SIpost))],'FontSize',7,'HorizontalAlignment','Center')
%     title({[char(catnames(cc)),'-Selectivity (All Neurons)'],monkeyname},'FontWeight','Bold','FontSize',7);    
%     [p,h]=ranksum(SIant,SImid); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
%     [p,h]=ranksum(SImid,SIpost); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
%     [p,h]=ranksum(SIant,SIpost); text(2,0.12,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig13_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig13_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig13_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


%%% New Figures - Based on Groups
% Figure 14 - Raw SI histogram
% figure; clf; cla; % selectivity index histograms
% set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% subplot(1,2,1)
% grp1SI=extractRawSI_Grid(unit_index,unitdata,grp1);
% grp2SI=extractRawSI_Grid(unit_index,unitdata,grp2);
% grp3SI=extractRawSI_Grid(unit_index,unitdata,grp3);
% grp4SI=extractRawSI_Grid(unit_index,unitdata,grp4);
% grp5SI=extractRawSI_Grid(unit_index,unitdata,grp5);
% hold on
% bar([mean(grp1SI) mean(grp2SI) mean(grp3SI) mean(grp4SI) mean(grp5SI)]);
% errorbar(1:5,[mean(grp1SI) mean(grp2SI) mean(grp3SI) mean(grp4SI) mean(grp5SI)],...
%     [sem(grp1SI) sem(grp2SI) sem(grp3SI) sem(grp4SI) sem(grp5SI)]);
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(grp1SI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(grp2SI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(grp3SI))],'FontSize',7)
% text(4,.48,['n=',num2str(length(grp4SI))],'FontSize',7)
% text(5,.48,['n=',num2str(length(grp5SI))],'FontSize',7)
% [p,h]=ranksum(grp1SI,grp2SI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(grp2SI,grp3SI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(grp3SI,grp4SI); text(3.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(grp4SI,grp5SI); text(4.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% title({'Raw SI vs GrpLoc (for Sensory+Excite/Both Neurons)',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% 
% subplot(1,2,2)
% grp1Stim=extractStimSelect_Grid(data,grp1);
% grp2Stim=extractStimSelect_Grid(data,grp2);
% grp3Stim=extractStimSelect_Grid(data,grp3);
% grp4Stim=extractStimSelect_Grid(data,grp4);
% grp5Stim=extractStimSelect_Grid(data,grp5);
% hold on
% bar([mean(grp1Stim(:,4)) mean(grp2Stim(:,4)) mean(grp3Stim(:,4)) mean(grp4Stim(:,4)) mean(grp5Stim(:,4))])
% errorbar(1:5,[mean(grp1Stim(:,4)) mean(grp2Stim(:,4)) mean(grp3Stim(:,4)) mean(grp4Stim(:,4)) mean(grp5Stim(:,4))],...
%     [sem(grp1Stim(:,4)) sem(grp2Stim(:,4)) sem(grp3Stim(:,4)) sem(grp4Stim(:,4)) sem(grp5Stim(:,4))])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('Average % StimSelective Neurons','FontSize',8); ylim([0 75]); axis square
% text(1,58,['n=',num2str(sum(grp1Stim(:,1)))],'FontSize',7)
% text(2,58,['n=',num2str(sum(grp2Stim(:,1)))],'FontSize',7)
% text(3,58,['n=',num2str(sum(grp3Stim(:,1)))],'FontSize',7)
% text(4,58,['n=',num2str(sum(grp4Stim(:,1)))],'FontSize',7)
% text(5,58,['n=',num2str(sum(grp5Stim(:,1)))],'FontSize',7)
% title({'Proportion of StimSelective Neurons (for given category)',monkeyname},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig14_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig14_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig14_',monkeyname,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 15 - Category Proportion and Selectivity for Both Monkeys for each Category
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
for pp=1:5, % Excitatory Preferences
    % one loop per patch
    subplot(3,5,pp)
    [ns,nc,prop]=extractPropGrid_Excite(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Grid ',num2str(pp),', Excite/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,40,['n=',num2str(nc(5))],'FontSize',7,'HorizontalAlignment','Center')
end
for pp=1:5, % Inhibited Preferences
     % one loop per patch
    subplot(3,5,pp+5)
    [ns,nc,prop]=extractPropGrid_Inhibit(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Grid ',num2str(pp),', Inhibit/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,40,['n=',num2str(nc(5))],'FontSize',7,'HorizontalAlignment','Center')
end
for pp=1:5, % Both
    % one loop per patch
    subplot(3,5,pp+10)
    [ns,nc,prop]=extractPropGrid_Both(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Grid ',num2str(pp),', Both/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,40,['n=',num2str(nc(5))],'FontSize',7,'HorizontalAlignment','Center')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig15_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig15_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig15_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp)
    for cc=1:5
        SI(cc).tmp=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
    text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' Excite/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp+5)
    for cc=1:5
        SI(cc).tmp=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([-.50 0]); axis square
    text(1,-.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' Inhibit/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig16_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig16_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig16_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp)
    for cc=1:5
        SI(cc).tmp=(extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([-.30 .30]); axis square
    text(1,.25,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.25,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.25,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.25,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.25,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' RAW Both/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp+5)
    for cc=1:5
        SI(cc).tmp=abs(extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
    text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' ABS Both/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig17_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig17_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig17_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for pp=1:5, % category selectivity of ALL sensory neurons (absolute value)
    subplot(2,5,pp)
    for cc=1:5
        SI(cc).tmp=abs(extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
    text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' Excite/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for pp=1:5, % category selectivity of ALL sensory neurons (absolute value)
    subplot(2,5,pp+5)
    for cc=1:5
        SI(cc).tmp=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([-.50 .50]); axis square
    text(1,-.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' Inhibit/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig18_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig18_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig18_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp)
    for cc=1:5
        SI(cc).tmp=(extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([-.30 .30]); axis square
    text(1,.25,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.25,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.25,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.25,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.25,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' RAW Both/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.20,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
    subplot(2,5,pp+5)
    for cc=1:5
        SI(cc).tmp=abs(extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
    end    
    hold on
    bar([mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)])
    errorbar(1:5,[mean(SI(1).tmp) mean(SI(4).tmp) mean(SI(2).tmp) mean(SI(5).tmp) mean(SI(3).tmp)],[sem(SI(1).tmp) sem(SI(4).tmp) sem(SI(2).tmp) sem(SI(5).tmp) sem(SI(3).tmp)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'F','Bp','Ft','Ob','Pl'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
    text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.35,['n=',num2str(length(SI(5).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
    title({['Patch ',num2str(pp),' ABS Both/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI(1).tmp,SI(4).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(2).tmp,SI(5).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI(5).tmp,SI(3).tmp); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig19_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig19_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig19_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5, % category selectivity of CategoryPreferringNeurons
    subplot(3,5,cc)
    SI1=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(5).grids);
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
    text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (CatPref) Excite'],monkeyname},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+5)
    SI1=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(5).grids);    
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.5 0]); axis square
    text(1,-.14,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.14,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.14,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (CatPref) Inhibit'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+10)
    SI1=extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(5).grids);    
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.2 .2]); axis square
    text(1,-.14,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.14,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.14,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (CatPref) Both'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig20_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig20_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig20_',monkeyname,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
for cc=1:5, % category selectivity of CategoryPreferringNeurons
    subplot(3,5,cc)
    SI1=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(5).grids);
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-.20 .20]); axis square
    text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (AllNeurons) Excite'],monkeyname},'FontWeight','Bold','FontSize',7);
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+5)
    SI1=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(5).grids);    
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.2 .2]); axis square
    text(1,-.14,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.14,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.14,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (All Neurons) Inhibit'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
for cc=1:5, % category selectivity of ALL neurons
    subplot(3,5,cc+10)
    SI1=extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(1).grids);
    SI2=extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(2).grids);
    SI3=extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(3).grids);
    SI4=extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(4).grids);
    SI5=extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(5).grids);    
    hold on
    bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
    errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel('Average CatSI','FontSize',8); ylim([-0.2 .2]); axis square
    text(1,-.14,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,-.14,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,-.14,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,-.14,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
    text(5,-.14,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
    title({[char(catnames(cc)),'-Selectivity (All Neurons) Both'],monkeyname},'FontWeight','Bold','FontSize',7);    
    try [p,h]=ranksum(SI1,SI2); text(1.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI2,SI3); text(2.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI3,SI4); text(3.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
    try [p,h]=ranksum(SI4,SI5); text(4.5,0.1,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig21_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1nt_Fig21_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1nt',filesep,'RSVP_project1ntPop_Fig21_',monkeyname,'.fig'])
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

function output=extractRawSI_inhibit(uindex,udata,APrange);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointer4=find(strcmp(uindex.SelectiveConf,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.inhibit_rawsi(pointer);
return

function output=extractCatSI_inhibit(uindex,udata,catname,catcol);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.pref_inhibit,catname)==1);
pointer4=find(strcmp(uindex.SelectiveConf,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
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

function [numsensory,numcat,output]=extractCatPropExcite(data,APrange,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).counts(catcol);
    end
end
output=numcat/numsensory;
return

function [numsensory,numcat,output]=extractCatPropInhibit(data,APrange,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).countsI(catcol);
    end
end
output=numcat/numsensory;
return

function [numsensory,numcat,output]=extractCatPropBoth(data,APrange,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).countsB(catcol);
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

function output=extractCatSI_APall_Grid_Both(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_APall_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_APall_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function [numsensory,numcat,output]=extractPropGrid_Excite(data,gridlocs); % output will be multiple values (1/gridloc)
catnames={'Face','Fruit','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).counts);
        numcat=numcat+data(gg).counts;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(4) numcat(2) numcat(5) numcat(3)];
output=[output(1) output(4) output(2) output(5) output(3)];
return

function [numsensory,numcat,output]=extractPropGrid_Inhibit(data,gridlocs); % output will be multiple values (1/gridloc)
catnames={'Face','Fruit','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).countsI);
        numcat=numcat+data(gg).countsI;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(4) numcat(2) numcat(5) numcat(3)];
output=[output(1) output(4) output(2) output(5) output(3)];
return

function [numsensory,numcat,output]=extractPropGrid_Both(data,gridlocs); % output will be multiple values (1/gridloc)
catnames={'Face','Fruit','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).countsB);
        numcat=numcat+data(gg).countsB;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(4) numcat(2) numcat(5) numcat(3)];
output=[output(1) output(4) output(2) output(5) output(3)];
return

function output=extractCatSI_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.pref_excite,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.pref_inhibit,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSI_Grid_Both(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.pref_excite,catname)==1 | ismember(uindex.pref_inhibit,catname)==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSIall_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSIall_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.ExciteConf,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si(pointer,catcol);
return

function output=extractCatSIall_Grid_Both(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.cat_si(pointer,catcol);
return

