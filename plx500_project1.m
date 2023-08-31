function plx500_project1(monkinitial,neurtype);
%%%%%%%%%%%%%%%%%%%
% plx500_project1 %
%%%%%%%%%%%%%%%%%%%
% written by AHB, Jan2009,
% based on plx500_sortgrid - adapted to follow RSVP500_Outline, and to be
% compatible with both Monkeys
% MONKINITIAL (required) = 'W' or 'S'
% NEURTYPE (optional) = 'ns','bs', or 'both' (default)

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify a monkey (''S''/''W'')'); elseif nargin==1, neurtype='both'; end
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
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
    % Grid location groups for comparison
    grp(1).grids={'A7L2','A7L1','A7R1'}; % BodyPart Selective
    grp(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Face Selective
    grp(3).grids={'A4L2','A4L1','A4R1'}; % Place Selective
    grp(4).grids={'A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Object Selective
    grp(5).grids={'P6L2','P6L1','P7L2'}; % Face Selective
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
    % Grid location groups for comparison
    grp(1).grids={'A6R2','A5R0','A4R3'}; % Bodypart Selective
    grp(2).grids={'R0','A2R1','A2R3','A2R5'}; % Face Selective
    grp(3).grids={'P1R0','P1R3'}; % Bodypart Selective
    grp(4).grids={'P3R0','P3R2','P5R0'}; % Place Selective
    grp(5).grids={'P3R0','P3R2','P5R0'}; % Place Selective
end

%%% Grids defined as ANTERIOR/POSTERIOR/OUTSIDE
% if monkinitial=='S',
%     monkeyname='Stewie_InOut'; sheetname='RSVP Cells_S';
%     % Grid location groups for comparison
%     grp(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
%     grp(2).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
%     grp(3).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Outside Face Selective
%     grp(4).grids={'A6L2','A6L0','A5L2','A5L1','A5L0','P6L2','P6L1','P7L2'}; % Inside
%     grp(5).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Outside Face Selective
% elseif monkinitial=='W',
%     monkeyname='Wiggum_InOut'; sheetname='RSVP Cells_W';
%     % Grid location groups for comparison
%     grp(1).grids={'A6R2','A5R0','A4R3','A3R0','A2R1','A2R3','A2R5'}; % Inside Face Selective
%     grp(2).grids={'P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective
%     grp(3).grids={'P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective
%     grp(4).grids={'A3R0','A2R1','A2R3','A2R5'}; % Inside Face Selective
%     grp(5).grids={'A6R2','A5R0','A4R3','P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective
% end
% 
% %%% Grids defined as ANTERIOR/POSTERIOR/OUTSIDE
% if monkinitial=='S',
%     monkeyname='Stewie_InOut_postNeuron'; sheetname='RSVP Cells_S';
%     % Grid location groups for comparison
%     grp(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
%     grp(2).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5'}; % Outside Face Selective (Anterior)
%     grp(3).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
%     grp(4).grids={'P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Outside Face Selective (Posterior)
%     grp(5).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Outside Face Selective (All)
% 
%     grp(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
%     grp(2).grids={'A2L5','A0L6','A0L2','A0L0','A0R0'}; % Outside Face Selective (Anterior)
%     grp(3).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
%     grp(4).grids={'P1L1','P2L3','P3L5','P3L4'}; % Outside Face Selective (Posterior)
%     grp(5).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Outside Face Selective (All)
% 
% 
% 
% 
% 
% elseif monkinitial=='W',
%     monkeyname='Wiggum_InOut_postNeuron'; sheetname='RSVP Cells_W';
%     % Grid location groups for comparison
%     grp(1).grids={'A3R0','A2R1','A2R3','A2R5'}; % Inside Face Selective
%     grp(2).grids={'A6R2','A5R0','A4R3'}; % Outside Face Selective (Anterior)
%     grp(3).grids={'P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective (Posterior)
%     grp(4).grids={'A6R2','A5R0','A4R3','P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective    
%     grp(5).grids={'A6R2','A5R0','A4R3','P1R0','P1R3','P3R0','P3R2','P5R0'}; % Outside Face Selective
% end

% A/P borders for Anterior/Middle/Posterior
ant=[19 18 17 16 15];
mid=[14 13 12 11 10];
post=[9 8 7 6 5];
sicutoff=0.20;
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
disp('*******************************************************************')
disp('* plx500_project1.m - Generates figures listed under Project 1 in *')
disp('*     RSVP500_Outline.docx.                                       *')
disp('*******************************************************************')
if strcmp(neurtype,'ns')==1,
    disp('Loading data for all narrow-spiking neurons...')
    neurlabel='NarrowSpiking';
    [data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject1data_nt(hmiconfig,sheetname,'ns');
    save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_',monkeyname,'_',neurtype,'.mat'],'data','unit_index','unitdata');
elseif strcmp(neurtype,'bs')==1,
    disp('Loading data for all broad-spiking neurons...')
    neurlabel='BroadSpiking';
    [data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject1data_nt(hmiconfig,sheetname,'bs');
    save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_',monkeyname,'_',neurtype,'.mat'],'data','unit_index','unitdata');
else
    disp('Loading data for all neurons...')
    neurlabel='Both';
    [data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject1data(hmiconfig,sheetname);
    save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_',monkeyname,'_',neurtype,'.mat'],'data','unit_index','unitdata');
end

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Neuron Distribution Figure)
disp('Figure 1  (Neuron Distribution Figure)')
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6]); set(gca,'FontName','Arial','FontSize',8);
subplot(3,3,1); piedata=[]; % Assumes removing fruit has no impact on responsiveness
piedata(1)=length(find(strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(2)=length(find(strcmp(unit_index.SensoryConf,'Non-Responsive')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str((piedata(1)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(2)/sum(piedata))*100,'%1.2g'),'%)']})
title(['(A) Sensory/Non-Responsive (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(3,3,2); piedata=[]; % Updated NO FRUIT
piedata(1)=length(find(strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(2)=length(find(strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(3)=length(find(strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str(piedata(1)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str(piedata(2)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(3)),'(',num2str(piedata(3)/sum(piedata)*100,'%1.2g'),'%)']})
title(['(B) Excite/Inhibit/Both (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','Location','Best'); set(gca,'FontSize',7)
subplot(3,3,3); bardataS=[]; bardataW=[]; bardata=[]; % breakdown of category selectivity according to response type
bardata(1,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1));
bardata(1,2)=length(find(strcmp(unit_index.selective_nofruit,'Not Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1));
bardata(2,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1));
bardata(2,2)=length(find(strcmp(unit_index.selective_nofruit,'Not Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1));
bardata(3,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1));
bardata(3,2)=length(find(strcmp(unit_index.selective_nofruit,'Not Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1));
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

subplot(3,3,4); bardata=[]; % preferred excitatory categories
bardata(1,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Faces')==1));
bardata(1,2)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.prefcat_excite_nofruit,'BodyParts')==1));
bardata(1,3)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Objects')==1));
bardata(1,4)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Places')==1));
bardata(2,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Faces')==1));
bardata(2,2)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_excite_nofruit,'BodyParts')==1));
bardata(2,3)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Objects')==1));
bardata(2,4)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_excite_nofruit,'Places')==1));
bardata(1,5) =bardata(1,1)/sum(bardata(1,1:4)); bardata(2,5) =bardata(2,1)/sum(bardata(2,1:4));
bardata(1,6) =bardata(1,2)/sum(bardata(1,1:4)); bardata(2,6) =bardata(2,2)/sum(bardata(2,1:4));
bardata(1,7) =bardata(1,3)/sum(bardata(1,1:4)); bardata(2,7) =bardata(2,3)/sum(bardata(2,1:4));
bardata(1,8) =bardata(1,4)/sum(bardata(1,1:4)); bardata(2,8) =bardata(2,4)/sum(bardata(2,1:4));
bar(1:2,bardata(1:2,5:8),'stack')
text(1,.15,['n=',num2str(bardata(1,1))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.35,['n=',num2str(bardata(1,2))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.55,['n=',num2str(bardata(1,3))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.75,['n=',num2str(bardata(1,4))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.15,['n=',num2str(bardata(2,1))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.35,['n=',num2str(bardata(2,2))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.55,['n=',num2str(bardata(2,3))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.75,['n=',num2str(bardata(2,4))],'FontSize',6,'HorizontalAlignment','Center')
title(['(D) Excitatory Responses (n=',num2str(sum(sum(bardata(:,1:4)))),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Bp','Ob','Pl','Location','Best'); set(gca,'FontSize',7)
set(gca,'XTick',1:2,'XTickLabel',{'E','B'}); ylabel('% of Neurons');
axis square

subplot(3,3,5); bardata=[]; % preferred inhibited categories
bardata(1,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Faces')==1));
bardata(1,2)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'BodyParts')==1));
bardata(1,3)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Objects')==1));
bardata(1,4)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Places')==1));
bardata(2,1)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Faces')==1));
bardata(2,2)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'BodyParts')==1));
bardata(2,3)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Objects')==1));
bardata(2,4)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.prefcat_inhibit_nofruit,'Places')==1));
bardata(1,5) =bardata(1,1)/sum(bardata(1,1:4)); bardata(2,5) =bardata(2,1)/sum(bardata(2,1:4));
bardata(1,6) =bardata(1,2)/sum(bardata(1,1:4)); bardata(2,6) =bardata(2,2)/sum(bardata(2,1:4));
bardata(1,7) =bardata(1,3)/sum(bardata(1,1:4)); bardata(2,7) =bardata(2,3)/sum(bardata(2,1:4));
bardata(1,8) =bardata(1,4)/sum(bardata(1,1:4)); bardata(2,8) =bardata(2,4)/sum(bardata(2,1:4));
bar(1:2,bardata(1:2,5:8),'stack')
text(1,.15,['n=',num2str(bardata(1,1))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.35,['n=',num2str(bardata(1,2))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.55,['n=',num2str(bardata(1,3))],'FontSize',6,'HorizontalAlignment','Center')
text(1,.75,['n=',num2str(bardata(1,4))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.15,['n=',num2str(bardata(2,1))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.35,['n=',num2str(bardata(2,2))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.55,['n=',num2str(bardata(2,3))],'FontSize',6,'HorizontalAlignment','Center')
text(2,.75,['n=',num2str(bardata(2,4))],'FontSize',6,'HorizontalAlignment','Center')
title(['(E) Inhibited Responses (n=',num2str(sum(sum(bardata(:,1:4)))),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('F','Bp','Ob','Pl','Location','Best'); set(gca,'FontSize',7); ylabel('% of Neurons');
set(gca,'XTick',1:2,'XTickLabel',{'B','I'})
axis square
subplot(3,3,[6 9]); pmap=zeros(5,5); % both neurons
catnames={'Faces','BodyParts','Objects','Places'};
for y=1:4, % each column (inhibit responses)
    for x=1:4, % each row (excite responses)
        pmap(y,x)=length(find(strcmp(unit_index.selective_nofruit,'Selective')==1 & strcmp(unit_index.excitetype_nofruit,'Both')==1 & ...
            strcmp(unit_index.prefcat_excite_nofruit,catnames(x))==1 & strcmp(unit_index.prefcat_inhibit_nofruit,catnames(y))==1));
    end
end
pmap=[pmap;[0 0 0 0 0]]; pmap=[pmap,[0 0 0 0 0 0]'];
tt=sum(sum(pmap)); pmap2=pmap/tt;
pcolor(pmap2); shading flat; set(gca,'YDir','reverse');
axis square; set(gca,'CLim',[0 .20]); 
mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
set(gca,'XTick',1.5:4.5,'XTickLabel',catnames,'YTick',1.5:4.5,'YTickLabel',catnames,'FontSize',7)
ylabel('Preferred Inhibited Category','fontsize',7);
xlabel('Preferred Excited Category','fontsize',7);
colorbar('SouthOutside','FontSize',6)
title(['(F) Breakdown of Excite/Inhibited Responses of BOTH Neurons (n=',num2str(tt),')'],'FontSize',fontsize_med,'FontWeight','Bold')
subplot(3,3,7) % pie chart, excitatory preferences, only those that are significant for their excite category
pointer=find(unitdata.stats_prefexcite_v_others_nofruit<0.05);
tempdata=unitdata.prefcat_excite_nofruit(pointer);
piedata(1)=length(find(strcmp(tempdata,'Faces')==1));
piedata(2)=length(find(strcmp(tempdata,'BodyParts')==1));
piedata(3)=length(find(strcmp(tempdata,'Objects')==1));
piedata(4)=length(find(strcmp(tempdata,'Places')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str((piedata(1)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(2)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(3)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(4)/sum(piedata))*100,'%1.2g'),'%)']})
title(['(G) Neurons with Sig Excitatory Selectivity (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('Fa','Bp','Ob','Pl','Location','Best'); set(gca,'FontSize',7)
subplot(3,3,8) % pie chart, excitatory preferences, only those that are significant for their excite category
pointer=find(unitdata.stats_prefinhibit_v_others_nofruit<0.05);
tempdata=unitdata.prefcat_excite_nofruit(pointer);
piedata(1)=length(find(strcmp(tempdata,'Faces')==1));
piedata(2)=length(find(strcmp(tempdata,'BodyParts')==1));
piedata(3)=length(find(strcmp(tempdata,'Objects')==1));
piedata(4)=length(find(strcmp(tempdata,'Places')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str((piedata(1)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(2)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(3)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(4)/sum(piedata))*100,'%1.2g'),'%)']})
title(['(G) Neurons with Sig Suppressed Selectivity (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('Fa','Bp','Ob','Pl','Location','Best'); set(gca,'FontSize',7)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_PieCharts_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_PieCharts_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% % Figure 2 - Raw SI histogram of all category selective neurons
% disp('Figure 2 - Raw SI histogram of all category selective neurons')
% figure; clf; cla; % selectivity index histograms
% set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% subplot(2,3,1)
% dd=extractRawSI(unit_index,unitdata,5:19); hist(dd,0:0.1:1);
% set(gca,'FontName','Arial','FontSize',8)
% xlabel({'Raw EXCITATORY SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
% text(0.6,80,['n=',num2str(length(dd))],'FontSize',7)
% text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
% ylim([0 200]); xlim([-0.2 1.2]); axis square
% title({'Average Raw SI (for Selective Neurons)','Excitatory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
% subplot(2,3,2)
% dd2=abs(extractRawSI_inhibit(unit_index,unitdata,5:19)); hist(dd2,0:0.1:1)
% set(gca,'FontName','Arial','FontSize',8)
% xlabel({'Raw INHIBITED SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
% text(0.6,80,['n=',num2str(length(dd2))],'FontSize',7)
% text(0.6,100,['Avg: ',num2str(mean(dd2)),' (',num2str(sem(dd2),'%1.2g'),')'],'FontSize',7)
% [p,h]=ranksum(dd,dd2); text(0.6,140,['P=',num2str(p,'%1.2g')],'FontSize',7);
% ylim([0 200]); xlim([-0.2 1.2]); axis square
% title({'Average Raw SI (for Selective Neurons)','Inhibitory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
% subplot(2,3,3)
% faceSI=extractCatSI(unit_index,unitdata,'Faces',1);
% placeSI=extractCatSI(unit_index,unitdata,'Places',2);
% bpartSI=extractCatSI(unit_index,unitdata,'BodyParts',3);
% objectSI=extractCatSI(unit_index,unitdata,'Objects',4);
% hold on
% bar([mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)])
% errorbar(1:4,[mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(objectSI) sem(placeSI)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'Face','BPart','Object','Place'})
% ylabel('Average Category SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(faceSI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(bpartSI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(objectSI))],'FontSize',7)
% text(4,.48,['n=',num2str(length(placeSI))],'FontSize',7)
% [p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(bpartSI,objectSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(objectSI,placeSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% [p,h]=ranksum(faceSI,placeSI); text(2,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
% title({'Category Selectivity of CatSelective Neurons)','Excitatory Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% subplot(2,3,4)
% faceSI=extractCatSI_inhibit(unit_index,unitdata,'Faces',1);
% placeSI=extractCatSI_inhibit(unit_index,unitdata,'Places',2);
% bpartSI=extractCatSI_inhibit(unit_index,unitdata,'BodyParts',3);
% objectSI=extractCatSI_inhibit(unit_index,unitdata,'Objects',4);
% hold on
% bar([mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)])
% errorbar(1:4,[mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(objectSI) sem(placeSI)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'Face','BPart','Object','Place'})
% ylabel('Average Category SI','FontSize',8); ylim([-0.5 0]); axis square
% text(1,-.48,['n=',num2str(length(faceSI))],'FontSize',7)
% text(2,-.48,['n=',num2str(length(bpartSI))],'FontSize',7)
% text(3,-.48,['n=',num2str(length(objectSI))],'FontSize',7)
% text(4,-.48,['n=',num2str(length(placeSI))],'FontSize',7)
% try [p,h]=ranksum(faceSI,bpartSI); text(1.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(bpartSI,objectSI); text(2.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(objectSI,placeSI); text(3.5,-0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(faceSI,placeSI); text(2,-0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% title({'Category Selectivity of CatSelective Neurons)','Inhibited Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% subplot(2,3,5)
% antSI=extractRawSI(unit_index,unitdata,ant); 
% midSI=extractRawSI(unit_index,unitdata,mid); 
% postSI=extractRawSI(unit_index,unitdata,post); 
% hold on
% bar([mean(antSI) mean(midSI) mean(postSI)])
% errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
% ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
% [p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% title({'Raw SI vs AP Location','Excitatory Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% subplot(2,3,6)
% antSI=abs(extractRawSI_inhibit(unit_index,unitdata,ant)); 
% midSI=abs(extractRawSI_inhibit(unit_index,unitdata,mid)); 
% postSI=abs(extractRawSI_inhibit(unit_index,unitdata,post)); 
% hold on
% bar([mean(antSI) mean(midSI) mean(postSI)])
% errorbar(1:3,[mean(antSI) mean(midSI) mean(postSI)],[sem(antSI) sem(midSI) sem(postSI)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:3,'XTickLabel',{'A19-A15','A14-A10','A9-A5'})
% ylabel('Average Raw SI','FontSize',8); ylim([0 0.5]); axis square
% text(1,.48,['n=',num2str(length(antSI))],'FontSize',7)
% text(2,.48,['n=',num2str(length(midSI))],'FontSize',7)
% text(3,.48,['n=',num2str(length(postSI))],'FontSize',7)
% [p,h]=ranksum(antSI,midSI); text(1.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% [p,h]=ranksum(midSI,postSI); text(2.5,0.45,['p=',num2str(p,'%1.2g')],'FontSize',7)
% title({'Raw SI vs AP Location','Inhibited Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% Figure 3  (Stimulus Selectivity Figure) %%% Updated: No fruit
disp('Figure 3  (Stimulus Selectivity Figure)')
%%% stimulus electivity according to category (preferred)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,2,1) % Within category selectivity
bardata=zeros(4,2);
for g=1:numgrids,
    for c=1:4,
        bardata(c,1)=bardata(c,1)+data(g).counts_nofruit(c);
        bardata(c,2)=bardata(c,2)+data(g).within_counts_nofruit(c);
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bar(bardata(:,2:3),'stack')
tmp=sum(bardata); tmpprc=tmp(2)/tmp(1); bardata(:,4)=bardata(:,1)*tmpprc;
[p,h]=chi2_test(bardata(:,2),bardata(:,4));
for c=1:4, text(c,bardata(c,1)+4,[num2str(bardata(c,2)/bardata(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
set(gca,'XTick',1:5,'XTickLabel',{'F','P','Bp','O'}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(1,2,2) % uninterpolated stimulus selectivity
surfdata=[]; validgrids=[];
for g=1:numgrids,
    surfdata(g,1:2)=data(g).grid_coords;
    surfdata(g,3)=sum(data(g).within_counts_nofruit)/sum(data(g).counts_nofruit);
    surfdata(g,4)=sum(data(g).within_counts_nofruit);
    surfdata(g,5)=sum(data(g).counts_nofruit);
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
colorbar('SouthOutside','FontSize',6)
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% % Figure 4  (Analysis of Distribution of Category-Preferring Neurons) %
% % FRUIT REMOVED
% % Proportion
% disp('Figure 4  (Analysis of Distribution of Category-Preferring Neurons)')
% figure; clf; cla; %
% set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
% set(gca,'FontName','Arial','FontSize',8)
% labels={'Face','Place','Bodypart','Object'};
% for pn=1:4,
%     subplot(3,4,pn) % surface plot - face proportion
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts_nofruit)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     %validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)=data(gridloc).propE_nofruit(pn);
%         if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
%         if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%         tmp=sum(data(gridloc).countsmat_nofruit);
%         surfdata(g,4)=tmp(pn);
%         surfdata(g,5)=sum(data(gridloc).counts_nofruit);
%     end
%     %%% Need to convert surfdata to a 10*10 matrix
%     gridmap=plx500_surfdata2gridmap(surfdata);
%     exp=prep_chidata(surfdata(:,3),surfdata(:,5));
%     [p,h]=chi2_test(surfdata(:,4),exp);
%     pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
%     axis square; set(gca,'CLim',[0 .5])
%     mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%     %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%     ylabel('Distance from interaural axis (mm)','fontsize',6);
%     xlabel('Distance from midline (mm)','fontsize',6);
%     title({[char(labels(pn)),' Proportion'],['Excite (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
%     %axis off
%     colorbar('SouthOutside','FontSize',6)
% end
% for pn=1:4,
%     subplot(3,4,pn+4) % surface plot - face proportion
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts_nofruit)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     %validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)=data(gridloc).propI_nofruit(pn);
%         if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
%         if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%         tmp=sum(data(gridloc).countsmat_nofruit);
%         surfdata(g,4)=tmp(pn);
%         surfdata(g,5)=sum(data(gridloc).counts_nofruit);
%     end
%     %%% Need to convert surfdata to a 10*10 matrix
%     gridmap=plx500_surfdata2gridmap(surfdata);
%     exp=prep_chidata(surfdata(:,3),surfdata(:,5));
%     [p,h]=chi2_test(surfdata(:,4),exp);
%     pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
%     axis square; set(gca,'CLim',[0 .5])
%     mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%     %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%     ylabel('Distance from interaural axis (mm)','fontsize',6);
%     xlabel('Distance from midline (mm)','fontsize',6);
%     title({[char(labels(pn)),' Proportion'],['Inhibit (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
%     %axis off
%     colorbar('SouthOutside','FontSize',6)
% end
% for pn=1:4,
%     subplot(3,4,pn+8) % surface plot - face proportion
%     surfdata=[]; validgrids=[];
%     % Filter out any sites that don't have at least 5 neurons
%     for g=1:numgrids,
%         if sum(data(g).counts_nofruit)>=minunitnum, validgrids=[validgrids; g]; end
%     end
%     %validgrids=1:numgrids; % do not eliminate grids
%     for g=1:length(validgrids),
%         gridloc=validgrids(g);
%         surfdata(g,1:2)=data(gridloc).grid_coords;
%         surfdata(g,3)=data(gridloc).propB_nofruit(pn);
%         if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
%         if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
%         tmp=sum(data(gridloc).countsmat_nofruit);
%         surfdata(g,4)=tmp(pn);
%         surfdata(g,5)=sum(data(gridloc).counts_nofruit);
%     end
%     %%% Need to convert surfdata to a 10*10 matrix
%     gridmap=plx500_surfdata2gridmap(surfdata);
%     exp=prep_chidata(surfdata(:,3),surfdata(:,5));
%     [p,h]=chi2_test(surfdata(:,4),exp);
%     pcolor(gridmap); shading flat; set(gca,'XDir','reverse');
%     axis square; set(gca,'CLim',[0 .5])
%     mp=colormap; mp(1,:)=[0.7529 0.7529 0.7529]; colormap(mp)
%     %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
%     ylabel('Distance from interaural axis (mm)','fontsize',6);
%     xlabel('Distance from midline (mm)','fontsize',6);
%     title({[char(labels(pn)),' Proportion'],['Both (ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontSize',fontsize_med,'FontWeight','Bold')
%     %axis off
%     colorbar('SouthOutside','FontSize',6)
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F4_CatPrefDist_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F4_CatPrefDist_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F4_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 5 - Category Proportion for each Patch
disp('Figure 5 - Category Proportion for each Patch')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
for pp=1:5, % Excitatory Preferences
    % one loop per patch
    subplot(3,5,pp)
    [ns,nc,prop]=extractPropGrid_Excite(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Grid ',num2str(pp),', Excite/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
for pp=1:5, % Inhibited Preferences
     % one loop per patch
    subplot(3,5,pp+5)
    [ns,nc,prop]=extractPropGrid_Inhibit(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Patch ',num2str(pp),', Inhibit/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
for pp=1:5, % Both
    % one loop per patch
    subplot(3,5,pp+10)
    [ns,nc,prop]=extractPropGrid_Both(data,grp(pp).grids); 
    bar(prop);
    x2=chi2_test(prop,[20 20 20 20]);
    set(gca,'FontName','Arial','FontSize',7,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
    ylabel('Average % CatPref Neurons','FontSize',8); ylim([0 50]); axis square
    title(['Patch ',num2str(pp),', Both/CatPrefs'],'FontSize',7,'FontWeight','Bold')
    text(3,45,['p(X2)=',num2str(x2,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
    text(1,40,['n=',num2str(nc(1))],'FontSize',7,'HorizontalAlignment','Center')
    text(2,40,['n=',num2str(nc(2))],'FontSize',7,'HorizontalAlignment','Center')
    text(3,40,['n=',num2str(nc(3))],'FontSize',7,'HorizontalAlignment','Center')
    text(4,40,['n=',num2str(nc(4))],'FontSize',7,'HorizontalAlignment','Center')
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F5_grpCatPrefperpatch_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F5_grpCatPrefperpatch_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Proj1Pop_Fig5_grpCatPrefperpatch_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% % Figure 6 - Category Selectivity for each Patch
% disp('Figure 6 - Category Selectivity for each Patch')
% figure; clf; cla; 
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% catnames={'Faces','Places','BodyParts','Objects'};
% for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
%     subplot(2,5,pp)
%     for cc=1:4
%         SI(cc).tmp=extractCatSI_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
%     end    
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([0 .50]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Excite/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
%     subplot(2,5,pp+5)
%     for cc=1:4
%         SI(cc).tmp=extractCatSI_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
%     end    
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([-.50 0]); axis square
%     text(1,-.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,-.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,-.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,-.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Inhibit/CatPrefNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F6_grpCatSIperpatchCatprefNeurons_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F6_grpCatSIperpatchCatprefNeurons_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Proj1Pop_Fig6_grpCatSIperpatchCatprefNeurons_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% 
% % Figure 7 - Category Selectivity for each Patch, collapsed across Response Type
% disp('Figure 7 - Category Selectivity for each Patch, collapsed across Response Type')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% catnames={'Faces','Places','BodyParts','Objects'};
% for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
%     subplot(2,5,pp)
%     for cc=1:4
%         SI(cc).tmp=(extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([-.50 0.5]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' CatPrefNeurons - Both Responses'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% for pp=1:5, % category selectivity of catpref sensory neurons (absolute value)
%     subplot(2,5,pp+5)
%     for cc=1:4
%         SI(cc).tmp=abs(extractCatSI_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([0 .5]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' CatPrefNeurons - Both Responses (abs)'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F7_grpCatSIperpatchCatprefNeuronsBothResp_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F7_grpCatSIperpatchCatprefNeuronsBothResp_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_Fig7_grpCatSIperpatchCatprefNeuronsBothResp_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% % Figure 8 - CatSelectivity for each Patch
% disp('Figure 8 - CatSelectivity for each Patch')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% catnames={'Faces','Places','BodyParts','Objects'};
% for pp=1:5, % category selectivity of ALL sensory neurons (absolute value)
%     subplot(2,5,pp)
%     for cc=1:4
%         SI(cc).tmp=extractCatSIall_Grid_Excite(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([-.50 0.5]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Excite/AllNeurons (abs)'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% for pp=1:5, % category selectivity of ALL sensory neurons (absolute value)
%     subplot(2,5,pp+5)
%     for cc=1:4
%         SI(cc).tmp=extractCatSIall_Grid_Inhibit(unit_index,unitdata,catnames(cc),cc,grp(pp).grids);
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([-.5 0.25]); axis square
%     text(1,-.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,-.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,-.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,-.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Inhibit/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,-0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F8_grpCatSIperPatchAllneurons_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F8_grpCatSIperPatchAllneurons_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Proj1Pop_Fig8_grpCatSIperPatchAllneurons_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% % Figure 9 - Absolute Value of CatSelectivity for each Patch
% disp('Figure 9 - Absolute Value of CatSelectivity for each Patch')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% catnames={'Faces','Fruit','Places','BodyParts','Objects'};
% for pp=1:5, % category selectivity of all sensory neurons (absolute value)
%     subplot(2,5,pp)
%     for cc=1:4
%         SI(cc).tmp=abs(extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([0 0.5]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Both/AllNeurons'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% for pp=1:5, % category selectivity of all sensory neurons (absolute value)
%     subplot(2,5,pp+5)
%     for cc=1:4
%         SI(cc).tmp=abs(extractCatSIall_Grid_Both(unit_index,unitdata,catnames(cc),cc,grp(pp).grids));
%     end
%     hold on
%     bar([mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)])
%     errorbar(1:4,[mean(SI(1).tmp) mean(SI(3).tmp) mean(SI(4).tmp) mean(SI(2).tmp)],[sem(SI(1).tmp) sem(SI(3).tmp) sem(SI(4).tmp) sem(SI(2).tmp)])
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Average CatSI','FontSize',8); ylim([0 0.5]); axis square
%     text(1,.35,['n=',num2str(length(SI(1).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(2,.35,['n=',num2str(length(SI(3).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(3,.35,['n=',num2str(length(SI(4).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     text(4,.35,['n=',num2str(length(SI(2).tmp))],'FontSize',7,'HorizontalAlignment','Center')
%     title({['Patch ',num2str(pp),' Both/AllNeurons (abs)'],[monkeyname]},'FontWeight','Bold','FontSize',7);
%     try [p,h]=ranksum(SI(1).tmp,SI(3).tmp); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(3).tmp,SI(4).tmp); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
%     try [p,h]=ranksum(SI(4).tmp,SI(2).tmp); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F9_grpRawSIperPatchAllNeurons_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F9_grpRawSIperPatchAllNeurons_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F9_grpRawSIperPatchAllNeurons_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 10 - CatSelectivity across Patch, for each category
disp('Figure 10 - CatSelectivity across Patch, for each category')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Places','BodyParts','Objects'};
for cc=1:4, % category selectivity of CategoryPreferringNeurons
    subplot(3,4,cc)
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
for cc=1:4, % category selectivity of ALL neurons
    subplot(3,4,cc+4)
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
for cc=1:4, % category selectivity of ALL neurons
    subplot(3,4,cc+8)
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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F10_grpCatSIperCatCatPrefNeurons_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F10_grpCatSIperCatCatPrefNeurons_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F10_grpCatSIperCatCatPrefNeurons_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 11 - CatSelectivity across Patch, for each category, all neurons
disp('Figure 11 - CatSelectivity across Patch, for each category, All neurons')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
catnames={'Faces','Places','BodyParts','Objects'};
for cc=1:4, % category selectivity of CategoryPreferringNeurons
    subplot(3,4,cc)
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
for cc=1:4, % category selectivity of ALL neurons
    subplot(3,4,cc+4)
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
for cc=1:4, % category selectivity of ALL neurons
    subplot(3,4,cc+8)
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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F11_grpCatSIperCatAllNeurons_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F11_grpCatSIperCatAllNeurons_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F11_grpCatSIperCatAllNeurons_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% %%% FMRI DATA ANALYSIS
% % Figure 12  (PerZone - BarGraphs for fMRI and Spikes, TimeSeries PER GRID)
% %% New - One FIGURE per GRID
% disp('Figure 12  (PerZone - BarGraphs for fMRI and Spikes, TimeSeries PER GRID)')
% for x=1:5, % One Loop Per Patch
%     figure; clf; cla; 
%     set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
%     set(gca,'FontName','Arial','FontSize',8)
%     ot(x)=extractfMRIgriddata(unit_index,unitdata,grp(x).grids,sicutoff);
%     subplot(3,4,1) % Neuron Proportions (All Neurons)
%     bar(1:4,[ot(x).E_neurprop;ot(x).I_neurprop;ot(x).B_neurprop]','group')
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('#Neurons','FontSize',7); 
%     title({['Patch ',num2str(x)],' - Prop AllSensoryCells'},'FontSize',8)
%     subplot(3,4,2) % Neuron Proportions (Neurons with SI > sicutoff)
%     bar([ot(x).E_neurpropSI;ot(x).I_neurpropSI;ot(x).B_neurpropSI]','group')
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('#Neurons','FontSize',7); 
%     title(['SI>Cutoff'],'FontSize',8)
%     subplot(3,4,3) % Neuron Proportions (Neurons with Significant Selectivity)
%     bar([ot(x).E_neurpropSig;ot(x).I_neurpropSig;ot(x).B_neurpropSig]','group')
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('#Neurons','FontSize',7); 
%     title(['SigDiff from Other Rsps'],'FontSize',8)
%     subplot(3,4,4); hold on % Neuron Proportions vs. fMRI Responses
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_neurprop/sum(ot(x).E_neurprop)*100,'gs','MarkerFaceColor','g'); % note the need to reorder fMRI responses!
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).I_neurprop/sum(ot(x).I_neurprop)*100,'rs','MarkerFaceColor','r'); % note the need to reorder fMRI responses!
%     %plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).B_neurprop/sum(ot(x).B_neurprop)*100,'bs','MarkerFaceColor','b'); % note the need to reorder fMRI responses!
%     axis square; set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('% Proportion Cells');
%     %legend('Excite','Suppressed')
%     [r,p,z]=pearson2(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_neurprop/sum(ot(x).E_neurprop)*100);
%     text(.2,60,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8)
%     try [r,p,z]=pearson(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).I_neurprop/sum(ot(x).I_neurprop)*100); end
%     text(.2,50,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8)
%     %[r,p,z]=pearson(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).B_neurprop/sum(ot(x).B_neurprop)*100);
%     %text(.2,40,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8)
%     title({'fMRI Activation vs. Neuron Distribution','1 pt/category'},'FontWeight','Bold')
%     subplot(3,5,6); hold on  % Average Neuronal Responses of all Neurons
%     bar([ot(x).E_ALLcat_avg([1 4 5 3]);ot(x).I_ALLcat_avg([1 4 5 3]);ot(x).B_ALLcat_avg([1 4 5 3])]','group')
%     try errorbar(0.8:3.8,ot(x).E_ALLcat_avg([1 4 5 3]),ot(x).E_ALLcat_sem([1 4 5 3])); end
%     try errorbar(1:4,ot(x).I_ALLcat_avg([1 4 5 3]),ot(x).I_ALLcat_sem([1 4 5 3])); end
%     try errorbar(1.2:4.2,ot(x).B_ALLcat_avg([1 4 5 3]),ot(x).B_ALLcat_sem([1 4 5 3])); end
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Avg Firing Rate (sp/s)','FontSize',7); ylim([0 25]);
%     title({'Neuron Responses','All Sensory Neurons'},'FontSize',8)
%     subplot(3,5,7); hold on % Average Normalized Responses
%     bar([ot(x).E_ALLnorm_cat_avg([1 4 5 3]);ot(x).I_ALLnorm_cat_avg([1 4 5 3]);;ot(x).B_ALLnorm_cat_avg([1 4 5 3])]','group')
%     try errorbar(0.8:3.8,ot(x).E_ALLnorm_cat_avg([1 4 5 3]),ot(x).E_ALLnorm_cat_sem([1 4 5 3])); end
%     try errorbar(1:4,ot(x).I_ALLnorm_cat_avg([1 4 5 3]),ot(x).I_ALLnorm_cat_sem([1 4 5 3])); end
%     try errorbar(1.2:4.2,ot(x).B_ALLnorm_cat_avg([1 4 5 3]),ot(x).B_ALLnorm_cat_sem([1 4 5 3])); end
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Norm Firing Rate','FontSize',7); ylim([0 1]);
%     title({'Normalized Neuron Responses','All Sensory Neurons'},'FontSize',8)
%     subplot(3,5,8); hold on % Neuronal Selectivity
%     bar(ot(x).ALLcatsi_avg([1 3 4 2]))
%     errorbar(1:4,ot(x).ALLcatsi_avg([1 3 4 2]),ot(x).ALLcatsi_sem([1 3 4 2]))
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('avg SI','FontSize',7);
%     title('Neuron Selectivity','FontSize',8)
%     %subplot(3,5,9); hold on % Neuron Responses vs. fMRI Responses (Raw)
%     %plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_cat_avg([1 4 5 3]),'gs','MarkerFaceColor','g'); % note the need to reorder fMRI responses!
%     %plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).I_cat_avg([1 4 5 3]),'rs','MarkerFaceColor','r'); % note the need to reorder fMRI responses!
%     %axis square; set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Firing Rate (sp/s)');
%     %legend('Excite','Suppressed')
%     %[r,p,z]=pearson(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_cat_avg([1 4 5 3]));
%     %text(.2,16,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
%     %title({'fMRI Activation vs. Neuronal Activity','1 pt/category'},'FontWeight','Bold')
%     
%     subplot(3,5,9); hold on % Neuron Responses vs. fMRI Responses (Normalized)
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_ALLnorm_cat_avg([1 4 5 3]),'go','MarkerFaceColor','g'); % note the need to reorder fMRI responses!
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).I_ALLnorm_cat_avg([1 4 5 3]),'ro','MarkerFaceColor','r'); % note the need to reorder fMRI responses!
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).B_ALLnorm_cat_avg([1 4 5 3]),'bo','MarkerFaceColor','b'); % note the need to reorder fMRI responses!
%     axis square; set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Normalized Firing Rate');
%     %legend('Excite','Suppressed')
%     [r,p,z]=pearson2(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).E_ALLnorm_cat_avg([1 4 5 3]));
%     text(.2,.8,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8)
%     try [r,p,z]=pearson(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).I_ALLnorm_cat_avg([1 4 5 3])); end
%     text(.2,.7,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8)
%     [r,p,z]=pearson2(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).B_ALLnorm_cat_avg([1 4 5 3]));
%     text(.2,.6,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8)
%     title({'fMRI Activation vs. Neuronal Activity','1 pt/category'},'FontWeight','Bold')
%     subplot(3,5,10); hold on % Neuron Selectivity vs. fMRI Responses (Normalized)
%     plot(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).ALLcatsi_avg([1 3 4 2]),'bo','MarkerFaceColor','b'); % note the need to reorder fMRI responses!
%     axis square; set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Selectivity');
%     [r,p,z]=pearson2(ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).ALLcatsi_avg([1 3 4 2]));
%     text(.2,.05,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
%     title({'fMRI Activation vs. Neuronal Selectivity','1 pt/category'},'FontWeight','Bold')
%     subplot(3,4,[9 10]); hold on % TimeSeries
%     plot(ot(x).timeseries,'k-','LineWidth',1.5)
%     xlabel('Time (s)','FontSize',7); ylabel('% Signal Change','FontSize',7); xlim([0 176]);
%     set(gca,'FontSize',8,'FontName','Arial')
%     if monkinitial=='S',
%         text(24,1,'Faces','HorizontalAlignment','Center','FontSize',6)
%         text(56,1,'Places','HorizontalAlignment','Center','FontSize',6)
%         text(88,1,'Objects','HorizontalAlignment','Center','FontSize',6)
%         text(120,1,'Bparts','HorizontalAlignment','Center','FontSize',6)
%         text(152,1,'Scram','HorizontalAlignment','Center','FontSize',6)
%         xlim([0 176])
%         plot([16 16],[-2 2],'k:','LineWidth',0.5)
%         plot([32 32],[-2 2],'k:','LineWidth',0.5)
%         plot([48 48],[-2 2],'k:','LineWidth',0.5)
%         plot([64 64],[-2 2],'k:','LineWidth',0.5)
%         plot([80 80],[-2 2],'k:','LineWidth',0.5)
%         plot([96 96],[-2 2],'k:','LineWidth',0.5)
%         plot([112 112],[-2 2],'k:','LineWidth',0.5)
%         plot([128 128],[-2 2],'k:','LineWidth',0.5)
%         plot([144 144],[-2 2],'k:','LineWidth',0.5)
%         plot([160 160],[-2 2],'k:','LineWidth',0.5)
%         plot([176 176 ],[-2 2],'k:','LineWidth',0.5)
%     elseif monkinitial=='W'
%         text(18,1,'Faces','HorizontalAlignment','Center','FontSize',6)
%         text(42,1,'Places','HorizontalAlignment','Center','FontSize',6)
%         text(66,1,'Objects','HorizontalAlignment','Center','FontSize',6)
%         text(90,1,'Bparts','HorizontalAlignment','Center','FontSize',6)
%         text(114,1,'Scram','HorizontalAlignment','Center','FontSize',6)
%         xlim([0 132])
%     end
%     subplot(3,4,11); hold on % Average fMRI Responses
%     bar(ot(x).uniq_fmri_rsp_avg([1 4 3 2]))
%     try errorbar(1:4,ot(x).uniq_fmri_rsp_avg([1 4 3 2]),ot(x).uniq_fmri_rsp_sem([1 4 3 2])); end
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Avg % Change','FontSize',7);
%     title(['fMRI Responses'],'FontSize',8)
%     subplot(3,4,12); hold on % fMRI Selectivity
%     bar(ot(x).uniq_fmri_si_avg([1 4 3 2]))
%     try errorbar(1:4,ot(x).uniq_fmri_si_avg([1 4 3 2]),ot(x).uniq_fmri_si_sem([1 4 3 2])); end
%     set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'F','Bp','Ob','Pl'})
%     ylabel('Avg % Change','FontSize',7);
%     title(['fMRI Selectivity'],'FontSize',8)
%     jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F12_fMRIsummaryperGrid',num2str(x),'_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%     illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F12_fMRIsummaryperGrid',num2str(x),'_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%     hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F12_fMRIsummaryperGrid',num2str(x),'_',monkeyname,'_',neurtype,'.fig'])
%     if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% end
% save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_fMRICompData_',monkeyname,'_',neurtype,'.mat'],'ot');

%%% NEW ANALYSIS - Compare Inside vs. Outside Patches for Faces
% Figure 13 (Comparison of Face Patches)
disp('Figure 13 (Selectivity Index)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
%%% Excitatory Responses
subplot(3,2,1) % ROC Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractROC_Grid_Excite(unit_index,unitdata,[3 4 5],grp(1).grids);
SI2=extractROC_Grid_Excite(unit_index,unitdata,[3 4 5],grp(2).grids);
SI3=extractROC_Grid_Excite(unit_index,unitdata,[3 4 5],grp(3).grids);
SI4=extractROC_Grid_Excite(unit_index,unitdata,[3 4 5],grp(4).grids);
SI5=extractROC_Grid_Excite(unit_index,unitdata,[3 4 5],grp(5).grids);
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Excite',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(3,2,2)
SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
hold on
bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Excite',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(3,2,3) % ROC Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractROC_Grid_Inhibit(unit_index,unitdata,[3 4 5],grp(1).grids);
SI2=extractROC_Grid_Inhibit(unit_index,unitdata,[3 4 5],grp(2).grids);
SI3=extractROC_Grid_Inhibit(unit_index,unitdata,[3 4 5],grp(3).grids);
SI4=extractROC_Grid_Inhibit(unit_index,unitdata,[3 4 5],grp(4).grids);
SI5=extractROC_Grid_Inhibit(unit_index,unitdata,[3 4 5],grp(5).grids);
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
subplot(3,2,4)
SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
hold on
bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(3,2,5) % ROC Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractROC_Grid_Both(unit_index,unitdata,[3 4 5],grp(1).grids);
SI2=extractROC_Grid_Both(unit_index,unitdata,[3 4 5],grp(2).grids);
SI3=extractROC_Grid_Both(unit_index,unitdata,[3 4 5],grp(3).grids);
SI4=extractROC_Grid_Both(unit_index,unitdata,[3 4 5],grp(4).grids);
SI5=extractROC_Grid_Both(unit_index,unitdata,[3 4 5],grp(5).grids);
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Both',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(3,2,6)
SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
hold on
bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'ROC Analysis (CatPref) Both',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F13_ROCanalysisperGrid_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F13_ROCanalysisperGrid_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F13_ROCanalysisperGrid_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% Figure 14 (Comparison of Face Patches - Stimulus Selectivity)
disp('Figure 14 (Stimulus Selectivity)')
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
subplot(3,1,1)
SI1=extractStimSelect_Grid(unit_index,unitdata,grp(1).grids);
SI2=extractStimSelect_Grid(unit_index,unitdata,grp(2).grids);
SI3=extractStimSelect_Grid(unit_index,unitdata,grp(3).grids);
SI4=extractStimSelect_Grid(unit_index,unitdata,grp(4).grids);
SI5=extractStimSelect_Grid(unit_index,unitdata,grp(5).grids);
bar([SI1;SI2;SI3;SI4;SI5],'group')
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('% Within Category Selectivity','FontSize',8); ylim([0 60]);
title({'Stimulus Selectivity per Patch',monkeyname},'FontWeight','Bold','FontSize',7);
legend('Faces','BodyParts','Objects','Places')

SI1=extractStimSelect_Gridall(unit_index,unitdata,grp(1).grids);
SI2=extractStimSelect_Gridall(unit_index,unitdata,grp(2).grids);
SI3=extractStimSelect_Gridall(unit_index,unitdata,grp(3).grids);
SI4=extractStimSelect_Gridall(unit_index,unitdata,grp(4).grids);
SI5=extractStimSelect_Gridall(unit_index,unitdata,grp(5).grids);
catlabels={'Faces','BodyParts','Objects','Places'};
for pp=1:4,
    subplot(3,2,2+pp)
    bardata=[SI1(pp,[4 5 6]);SI2(pp,[4 5 6]);SI3(pp,[4 5 6]);SI4(pp,[4 5 6]);SI5(pp,[4 5 6])];
    bar(bardata(:,1:2),'stack')
    set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
    ylabel({'% Within Category Selectivity','(of Total Sensory Neurons)'},'FontSize',8); ylim([0 75]);
    title({'Stimulus Selectivity per Patch',[char(catlabels(pp)),' - ',monkeyname]},'FontWeight','Bold','FontSize',7);
    for tl=1:5,
       text(tl,sum(bardata(tl,1:2)),[num2str(bardata(tl,3),'%1.2g'),'%'])
    end
    %%% Chi Square
    % 1vs2
    % Calculate average percentage of stim select units across both patches
    avgperc=mean([SI1(pp,6) SI2(pp,6)])/100
    expected=[SI1(pp,2)*avgperc SI2(pp,2)*avgperc]
    [p1v2,h1v2]=chi2_test([SI1(pp,1) SI2(pp,1)],expected);
    text(4,60,['p(1v2)=',num2str(p1v2,'%1.2g')])
    
    % 1vs2vs3
    % Calculate average percentage of stim select units across both patches
    avgperc=mean([SI1(pp,6) SI2(pp,6) SI3(pp,6)])/100;
    expected=[SI1(pp,2)*avgperc SI2(pp,2)*avgperc SI3(pp,2)*avgperc];
    [p1v3,h1v3]=chi2_test([SI1(pp,1) SI2(pp,1) SI3(pp,1)],expected);
    text(4,55,['p(1v2v3)=',num2str(p1v3,'%1.2g')])
    
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F14_StimSelectperGrid_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F14_StimSelectperGrid_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F14_StimSelectperGrid_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%%% FACE PROCESSING ANALYSIS
% What is the difference between face neurons IN the patch vs. OUT of the
% patch?

% Figure 15 (Category Selectivity)
figure; clf; cla;
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
%%% Excitatory Responses
subplot(1,3,1) % CatSI Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractCatSI_Grid_Excite_prefCat(unit_index,unitdata,[1],grp(1).grids,'Faces');
SI2=extractCatSI_Grid_Excite_prefCat(unit_index,unitdata,[1],grp(2).grids,'Faces');
SI3=extractCatSI_Grid_Excite_prefCat(unit_index,unitdata,[1],grp(3).grids,'Faces');
SI4=extractCatSI_Grid_Excite_prefCat(unit_index,unitdata,[1],grp(4).grids,'Faces');
SI5=extractCatSI_Grid_Excite_prefCat(unit_index,unitdata,[1],grp(5).grids,'Faces');
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average CatSI','FontSize',8); ylim([-.50 .50]);
text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'CatSI Analysis (FaceNeuronsOnly) Excite',monkeyname},'FontWeight','Bold','FontSize',7);

try [p,h]=ttest(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ttest(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ttest2(SI1,SI3); text(2,0.48,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ttest2(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ttest2(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(1,3,2) % CatSI Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractCatSI_Grid_Inhibit_prefCat(unit_index,unitdata,[1],grp(1).grids,'Faces');
SI2=extractCatSI_Grid_Inhibit_prefCat(unit_index,unitdata,[1],grp(2).grids,'Faces');
SI3=extractCatSI_Grid_Inhibit_prefCat(unit_index,unitdata,[1],grp(3).grids,'Faces');
SI4=extractCatSI_Grid_Inhibit_prefCat(unit_index,unitdata,[1],grp(4).grids,'Faces');
SI5=extractCatSI_Grid_Inhibit_prefCat(unit_index,unitdata,[1],grp(5).grids,'Faces');
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average CatSI','FontSize',8); ylim([-.50 .50]);
text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'CatSI Analysis (FaceNeuronsOnly) Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI1,SI3); text(2,0.48,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end

subplot(1,3,3) % CatSI Analysis
% Compare ability of patches to discriminate faces vs. other categories
SI1=extractCatSI_Grid_Both_prefCat(unit_index,unitdata,[1],grp(1).grids,'Faces');
SI2=extractCatSI_Grid_Both_prefCat(unit_index,unitdata,[1],grp(2).grids,'Faces');
SI3=extractCatSI_Grid_Both_prefCat(unit_index,unitdata,[1],grp(3).grids,'Faces');
SI4=extractCatSI_Grid_Both_prefCat(unit_index,unitdata,[1],grp(4).grids,'Faces');
SI5=extractCatSI_Grid_Both_prefCat(unit_index,unitdata,[1],grp(5).grids,'Faces');
hold on
bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
errorbar(1:5,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
ylabel('Average CatSI','FontSize',8); ylim([-.50 .50]);
text(1,.38,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
text(2,.38,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
text(3,.38,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
text(4,.38,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
text(5,.38,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
title({'CatSI Analysis (FaceNeuronsOnly) Both',monkeyname},'FontWeight','Bold','FontSize',7);
try [p,h]=ranksum(SI1,SI2); text(1.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI2,SI3); text(2.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI3,SI4); text(3.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(SI4,SI5); text(4.5,0.44,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F15_CatSelectperGrid_catpref_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F15_CatSelectperGrid_catpref_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F15_CatSelectperGrid_catpref_',monkeyname,'_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% 
% 
% % Figure 16 (Comparison of Face Patches, look at Face neurons only)
% disp('Figure 16 (Comparison of Face Patches, look at face neurons only)')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% %%% Excitatory Responses
% subplot(3,2,1) % ROC Analysis
% % Compare ability of patches to discriminate faces vs. other categories
% SI1=extractROC_Grid_Excite_prefCat(unit_index,unitdata,[3 4 5],grp(1).grids,'Faces');
% SI2=extractROC_Grid_Excite_prefCat(unit_index,unitdata,[3 4 5],grp(2).grids,'Faces');
% SI3=extractROC_Grid_Excite_prefCat(unit_index,unitdata,[3 4 5],grp(3).grids,'Faces');
% SI4=extractROC_Grid_Excite_prefCat(unit_index,unitdata,[3 4 5],grp(4).grids,'Faces');
% SI5=extractROC_Grid_Excite_prefCat(unit_index,unitdata,[3 4 5],grp(5).grids,'Faces');
% hold on
% bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
% errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Excite',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% 
% subplot(3,2,2)
% SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
% SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
% SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
% SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
% SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
% hold on
% bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
% errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Excite',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% 
% subplot(3,2,3) % ROC Analysis
% % Compare ability of patches to discriminate faces vs. other categories
% SI1=extractROC_Grid_Inhibit_prefCat(unit_index,unitdata,[3 4 5],grp(1).grids,'Faces');
% SI2=extractROC_Grid_Inhibit_prefCat(unit_index,unitdata,[3 4 5],grp(2).grids,'Faces');
% SI3=extractROC_Grid_Inhibit_prefCat(unit_index,unitdata,[3 4 5],grp(3).grids,'Faces');
% SI4=extractROC_Grid_Inhibit_prefCat(unit_index,unitdata,[3 4 5],grp(4).grids,'Faces');
% SI5=extractROC_Grid_Inhibit_prefCat(unit_index,unitdata,[3 4 5],grp(5).grids,'Faces');
% hold on
% bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
% errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% subplot(3,2,4)
% SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
% SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
% SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
% SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
% SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
% hold on
% bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
% errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% 
% subplot(3,2,5) % ROC Analysis
% % Compare ability of patches to discriminate faces vs. other categories
% SI1=extractROC_Grid_Both_prefCat(unit_index,unitdata,[3 4 5],grp(1).grids,'Faces');
% SI2=extractROC_Grid_Both_prefCat(unit_index,unitdata,[3 4 5],grp(2).grids,'Faces');
% SI3=extractROC_Grid_Both_prefCat(unit_index,unitdata,[3 4 5],grp(3).grids,'Faces');
% SI4=extractROC_Grid_Both_prefCat(unit_index,unitdata,[3 4 5],grp(4).grids,'Faces');
% SI5=extractROC_Grid_Both_prefCat(unit_index,unitdata,[3 4 5],grp(5).grids,'Faces');
% hold on
% bar([mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)])
% errorbar(1:15,[mean(SI1) mean(SI2) mean(SI3) mean(SI4) mean(SI5)],[sem(SI1) sem(SI2) sem(SI3) sem(SI4) sem(SI5)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:15,'XTickLabel',{'Grp1','','','Grp2','','','Grp3','','','Grp4','','','Grp5','',''})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(7,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(10,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(13,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Both',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1,SI2); text(2.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2,SI3); text(5.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3,SI4); text(8.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4,SI5); text(11.5,0.74,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% 
% subplot(3,2,6)
% SI1a=reshape(SI1,1,size(SI1,1)*size(SI1,2));
% SI2a=reshape(SI2,1,size(SI2,1)*size(SI2,2));
% SI3a=reshape(SI3,1,size(SI3,1)*size(SI3,2));
% SI4a=reshape(SI4,1,size(SI4,1)*size(SI4,2));
% SI5a=reshape(SI5,1,size(SI5,1)*size(SI5,2));
% hold on
% bar([mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)])
% errorbar(1:5,[mean(SI1a) mean(SI2a) mean(SI3a) mean(SI4a) mean(SI5a)],[sem(SI1a) sem(SI2a) sem(SI3a) sem(SI4a) sem(SI5a)])
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('Average Area under ROC','FontSize',8); ylim([0.5 .75]);
% text(1,.68,['n=',num2str(length(SI1))],'FontSize',7,'HorizontalAlignment','Center')
% text(2,.68,['n=',num2str(length(SI2))],'FontSize',7,'HorizontalAlignment','Center')
% text(3,.68,['n=',num2str(length(SI3))],'FontSize',7,'HorizontalAlignment','Center')
% text(4,.68,['n=',num2str(length(SI4))],'FontSize',7,'HorizontalAlignment','Center')
% text(5,.68,['n=',num2str(length(SI5))],'FontSize',7,'HorizontalAlignment','Center')
% title({'ROC Analysis (CatPref) Both',monkeyname},'FontWeight','Bold','FontSize',7);
% try [p,h]=ranksum(SI1a,SI2a); text(1.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI2a,SI3a); text(2.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI3a,SI4a); text(3.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% try [p,h]=ranksum(SI4a,SI5a); text(4.5,0.70,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F16_ROCanalysisperGrid_catpref_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F16_ROCanalysisperGrid_catpref_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F16_ROCanalysisperGrid_catpref_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
% 
% % Figure 17 (Density of Face Neurons)
% disp('Figure 17 (Face Neuron Density)')
% figure; clf; cla;
% set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
% set(gca,'FontName','Arial','FontSize',8)
% numgrids=size(data,2);
% prop=struct('propE_nofruit',[],'propI_nofruit',[],'propB_nofruit',[]);
% for pp=1:5, % one loop per patch
%     prop(pp).propE_nofruit=[];
%     prop(pp).propI_nofruit=[];
%     prop(pp).propB_nofruit=[];
%     sqmm(pp)=length(grp(pp).grids); % count number of grid holes
%     for gg=1:sqmm(pp), for nn=1:numgrids,
%             if strcmp(grp(pp).grids(gg),data(nn).gridloc)==1, % if grid is in patch
%                 if isnan(data(nn).propE_nofruit(1))==0,
%                     prop(pp).propE_nofruit=[prop(pp).propE_nofruit;data(nn).propE_nofruit];
%                 end
%                 if isnan(data(nn).propI_nofruit(1))==0,
%                     prop(pp).propI_nofruit=[prop(pp).propI_nofruit;data(nn).propI_nofruit];
% 
%                 end
%                 if isnan(data(nn).propB_nofruit(1))==0,
%                     prop(pp).propB_nofruit=[prop(pp).propB_nofruit;data(nn).propB_nofruit];
%                 end
%             end
%         end 
%     end
%     densityE(pp,1:4)=mean(prop(pp).propE_nofruit);
%     semDensE(pp,1:4)=sem(prop(pp).propE_nofruit);
%     densityI(pp,1:4)=mean(prop(pp).propI_nofruit);
%     semDensI(pp,1:4)=sem(prop(pp).propI_nofruit);
%     densityB(pp,1:4)=mean(prop(pp).propB_nofruit);
%     semDensB(pp,1:4)=sem(prop(pp).propB_nofruit);
% end
% subplot(1,3,1); hold on
% bar(densityE(:,1))
% errorbar(1:5,densityE(:,1),semDensE(:,1))
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('%FaceNeurons/mm2','FontSize',8); ylim([0 1.00]);
% title({'Face Neuron Density Excite',monkeyname},'FontWeight','Bold','FontSize',7);
% for eb=1:4,
%     p=ranksum(prop(eb).propE_nofruit(:,1),prop(eb+1).propE_nofruit(:,1));
%     text(eb+0.5,.65,['p=',num2str(p,'%1.2g')])
% end
% subplot(1,3,2); hold on
% bar(densityI(:,1)); errorbar(1:5,densityI(:,1),semDensI(:,1))
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('%FaceNeurons/mm2','FontSize',8); ylim([0 1.00]);
% title({'Face Neuron Density Inhibit',monkeyname},'FontWeight','Bold','FontSize',7);
% for eb=1:4,
%     p=ranksum(prop(eb).propI_nofruit(:,1),prop(eb+1).propI_nofruit(:,1));
%     text(eb+0.5,.65,['p=',num2str(p,'%1.2g')])
% end
% subplot(1,3,3); hold on
% bar(densityB(:,1)); errorbar(1:5,densityB(:,1),semDensB(:,1))
% set(gca,'FontName','Arial','FontSize',8,'XTick',1:5,'XTickLabel',{'Grp1','Grp2','Grp3','Grp4','Grp5'})
% ylabel('%FaceNeurons/mm2','FontSize',8); ylim([0 1.00]);
% title({'Face Neuron Density Both',monkeyname},'FontWeight','Bold','FontSize',7);
% for eb=1:4,
%     p=ranksum(prop(eb).propB_nofruit(:,1),prop(eb+1).propB_nofruit(:,1));
%     text(eb+0.5,.65,['p=',num2str(p,'%1.2g')])
% end
% jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F17_FaceNeuronDensity_',monkeyname,'_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
% illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F17_FaceNeuronDensity_',monkeyname,'_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
% hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F17_FaceNeuronDensity_',monkeyname,'_',neurtype,'.fig'])
% if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
return

%%% NESTED FUNCTIONS %%%
%% Figure 2 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractRawSI(uindex,udata,APrange); % Updated: NO FRUIT
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointer4=find(strcmp(uindex.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.excite_rawsi_nofruit(pointer);
return
function output=extractRawSI_inhibit(uindex,udata,APrange); % Updated: NO FRUIT
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointer4=find(strcmp(uindex.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.inhibit_rawsi_nofruit(pointer);
return
function output=extractCatSI(uindex,udata,catname,catcol); % Updated: NO FRUIT
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_excite_nofruit,catname)==1);
pointer4=find(strcmp(uindex.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSI_inhibit(uindex,udata,catname,catcol); % Updated: NO FRUIT
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_inhibit_nofruit,catname)==1);
pointer4=find(strcmp(uindex.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return

%% Figure 5 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [numsensory,numcat,output]=extractPropGrid_Excite(data,gridlocs); % output will be multiple values (1/gridloc)
% Updated : No Fruit
catnames={'Face','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).counts_nofruit); numcat=numcat+data(gg).counts_nofruit;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(3) numcat(4) numcat(2)]; output=[output(1) output(3) output(4) output(2)];
return
function [numsensory,numcat,output]=extractPropGrid_Inhibit(data,gridlocs); % output will be multiple values (1/gridloc)
% Updated : No Fruit
catnames={'Face','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).countsI_nofruit); numcat=numcat+data(gg).countsI_nofruit;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(3) numcat(4) numcat(2)]; output=[output(1) output(3) output(4) output(2)];
return
function [numsensory,numcat,output]=extractPropGrid_Both(data,gridlocs); % output will be multiple values (1/gridloc)
% Updated : No Fruit
catnames={'Face','Place','Bodypart','Object'};
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).gridloc(1,1),gridlocs)==1,
        numsensory=numsensory+sum(data(gg).countsB_nofruit); numcat=numcat+data(gg).countsB_nofruit;
    end
end
output=numcat/numsensory*100;
% resort
numcat=[numcat(1) numcat(3) numcat(4) numcat(2)]; output=[output(1) output(3) output(4) output(2)];
return

%% Figure 6 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractCatSI_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_excite_nofruit,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSI_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_inhibit_nofruit,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSI_Grid_Both(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.prefcat_excite_nofruit,catname)==1 | ismember(uindex.prefcat_inhibit_nofruit,catname)==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return

%% Figure 7 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractCatSIall_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSIall_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSIall_Grid_Both(uindex,udata,catname,catcol,gridlocs,cutoff)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.cat_si_nofruit(pointer,catcol);
return

%% Figure 12 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputstruct=extractfMRIgriddata(uindex,udata,gridlocs,cutoff)
% FMRI Responses/SI
% orig way
pointerFMRI=find(ismember(uindex.GridLoc,gridlocs)==1);
outputstruct.fmri_rsp_avg=mean(udata.fmri_rsp(pointerFMRI,:),1);
outputstruct.fmri_rsp_sem=sem(udata.fmri_rsp(pointerFMRI,:));
outputstruct.fmri_si_avg=mean(udata.fmri_catsi(pointerFMRI,:),1);
outputstruct.fmri_si_sem=sem(udata.fmri_catsi(pointerFMRI,:));
outputstruct.timeseries=mean(udata.AFNItimeseries(pointerFMRI,:),1);
% newer way
outputstruct.uniq_fmri_rsp_avg=mean(unique(udata.fmri_rsp(pointerFMRI,:),'rows'),1);
outputstruct.uniq_fmri_rsp_sem=sem(unique(udata.fmri_rsp(pointerFMRI,:),'rows'));
outputstruct.uniq_fmri_si_avg=mean(unique(udata.fmri_catsi(pointerFMRI,:),'rows'),1);
outputstruct.uniq_fmri_si_sem=sem(unique(udata.fmri_catsi(pointerFMRI,:),'rows'));
outputstruct.uniq_timeseries=mean(unique(udata.AFNItimeseries(pointerFMRI,:),'rows'),1);

catlabs={'Faces';'BodyParts';'Objects';'Places'};
patchneurons=find(ismember(uindex.GridLoc,gridlocs)==1); % select only neurons in grid
%%% Excitatory Responses
% NeuronProportion (no Fruit), no SI criteria
tmpdata1a=udata.excitetype_nofruit(patchneurons); % subselect indices corresponding to units in grid
tmpP1a=find(ismember(tmpdata1a,{'Excite','Both'})==1);
tmpdata1b=udata.prefcat_excite_nofruit(patchneurons);
tmpdata1c=tmpdata1b(tmpP1a); % subselects only excitatory and both neurons
for cc=1:4, outputstruct.E_neurprop(cc)=length(find(ismember(tmpdata1c,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), SI criteria (cutoff)
tmpdata2a=udata.excite_rawsi_nofruit(patchneurons);
tmpP2a=find(tmpdata2a>=cutoff);
tmpP2b=intersect(tmpP1a,tmpP2a);
tmpdata2b=tmpdata1b(tmpP2b);
for cc=1:4, outputstruct.E_neurpropSI(cc)=length(find(ismember(tmpdata2b,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), Sig criteria (cutoff)
tmpdata3a=udata.stats_prefexcite_v_others_nofruit(patchneurons);
tmpP3a=find(tmpdata3a<0.05);
tmpP3b=intersect(tmpP1a,tmpP3a);
tmpdata3b=tmpdata1b(tmpP3b);
for cc=1:4, outputstruct.E_neurpropSig(cc)=length(find(ismember(tmpdata3b,catlabs(cc))==1)); end
% NeuronResponses for ALL SENSORY neurons in patch
tmpdata4a=udata.cat_avg(patchneurons,:);
tmpdata4b=tmpdata4a(tmpP1a,:);
outputstruct.E_ALLcat_avg=mean(tmpdata4b,1);
outputstruct.E_ALLcat_sem=sem(tmpdata4b);
tmpdata4c=udata.norm_cat_avg(patchneurons,:);
tmpdata4d=tmpdata4c(tmpP1a,:);
outputstruct.E_ALLnorm_cat_avg=mean(tmpdata4d,1);
outputstruct.E_ALLnorm_cat_sem=sem(tmpdata4d);
% NeuronResponses for all SENSORY neurons with SI > cutoff
tmpdata5a=udata.cat_avg(patchneurons,:);
tmpdata5b=tmpdata5a(tmpP2b,:);
outputstruct.E_SIcat_avg=mean(tmpdata5b,1);
outputstruct.E_SIcat_sem=sem(tmpdata5b);
tmpdata5c=udata.norm_cat_avg(patchneurons,:);
tmpdata5d=tmpdata5c(tmpP2b,:);
outputstruct.E_SInorm_cat_avg=mean(tmpdata5d,1);
outputstruct.E_SInorm_cat_sem=sem(tmpdata5d);
% NeuronResponses for all SENSORY neurons with Significant Difference for Preferred Response
tmpdata6a=udata.cat_avg(patchneurons,:);
tmpdata6b=tmpdata6a(tmpP3b,:);
outputstruct.E_SIGcat_avg=mean(tmpdata6b,1);
outputstruct.E_SIGcat_sem=sem(tmpdata6b);
tmpdata6c=udata.norm_cat_avg(patchneurons,:);
tmpdata6d=tmpdata6c(tmpP3b,:);
outputstruct.E_SIGnorm_cat_avg=mean(tmpdata6d,1);
outputstruct.E_SIGnorm_cat_sem=sem(tmpdata6d);

%%% Suppressed Responses
% NeuronProportion (no Fruit), no SI criteria
tmpdata1a=udata.excitetype_nofruit(patchneurons); % subselect indices corresponding to units in grid
tmpP1a=find(ismember(tmpdata1a,{'Inhibit','Both'})==1);
tmpdata1b=udata.prefcat_inhibit_nofruit(patchneurons);
tmpdata1c=tmpdata1b(tmpP1a); % subselects only excitatory and both neurons
for cc=1:4, outputstruct.I_neurprop(cc)=length(find(ismember(tmpdata1c,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), SI criteria (cutoff)
tmpdata2a=abs(udata.inhibit_rawsi_nofruit(patchneurons));
tmpP2a=find(tmpdata2a>=cutoff);
tmpP2b=intersect(tmpP1a,tmpP2a);
tmpdata2b=tmpdata1b(tmpP2b);
for cc=1:4, outputstruct.I_neurpropSI(cc)=length(find(ismember(tmpdata2b,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), Sig criteria (cutoff)
tmpdata3a=udata.stats_prefinhibit_v_others_nofruit(patchneurons);
tmpP3a=find(tmpdata3a<0.05);
tmpP3b=intersect(tmpP1a,tmpP3a);
tmpdata3b=tmpdata1b(tmpP3b);
for cc=1:4, outputstruct.I_neurpropSig(cc)=length(find(ismember(tmpdata3b,catlabs(cc))==1)); end
% NeuronResponses for ALL SENSORY neurons in patch
tmpdata4a=udata.cat_avg(patchneurons,:);
tmpdata4b=tmpdata4a(tmpP1a,:);
outputstruct.I_ALLcat_avg=mean(tmpdata4b,1);
outputstruct.I_ALLcat_sem=sem(tmpdata4b);
tmpdata4c=udata.norm_cat_avg(patchneurons,:);
tmpdata4d=tmpdata4c(tmpP1a,:);
outputstruct.I_ALLnorm_cat_avg=mean(tmpdata4d,1);
outputstruct.I_ALLnorm_cat_sem=sem(tmpdata4d);
% NeuronResponses for all SENSORY neurons with SI > cutoff
tmpdata5a=udata.cat_avg(patchneurons,:);
tmpdata5b=tmpdata5a(tmpP2b,:);
outputstruct.I_SIcat_avg=mean(tmpdata5b,1);
outputstruct.I_SIcat_sem=sem(tmpdata5b);
tmpdata5c=udata.norm_cat_avg(patchneurons,:);
tmpdata5d=tmpdata5c(tmpP2b,:);
outputstruct.I_SInorm_cat_avg=mean(tmpdata5d,1);
outputstruct.I_SInorm_cat_sem=sem(tmpdata5d);
% NeuronResponses for all SENSORY neurons with Significant Difference for Preferred Response
tmpdata6a=udata.cat_avg(patchneurons,:);
tmpdata6b=tmpdata6a(tmpP3b,:);
outputstruct.I_SIGcat_avg=mean(tmpdata6b,1);
outputstruct.I_SIGcat_sem=sem(tmpdata6b);
tmpdata6c=udata.norm_cat_avg(patchneurons,:);
tmpdata6d=tmpdata6c(tmpP3b,:);
outputstruct.I_SIGnorm_cat_avg=mean(tmpdata6d,1);
outputstruct.I_SIGnorm_cat_sem=sem(tmpdata6d);

%%% BOTH Response types   %%% THIS IS FLAWED - DON'T USE
% NeuronProportion (no Fruit), no SI criteria
tmpdata1a=udata.excitetype_nofruit(patchneurons); % subselect indices corresponding to units in grid
tmpP1a=find(ismember(tmpdata1a,{'Excite','Inhibit','Both'})==1);
tmpdata1b=udata.prefcat_excite_nofruit(patchneurons);
tmpdata1c=tmpdata1b(tmpP1a); % subselects only excitatory and both neurons
for cc=1:4, outputstruct.B_neurprop(cc)=length(find(ismember(tmpdata1c,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), SI criteria (cutoff)
tmpdata2a=udata.excite_rawsi_nofruit(patchneurons);
tmpP2a=find(tmpdata2a>=cutoff);
tmpP2b=intersect(tmpP1a,tmpP2a);
tmpdata2b=tmpdata1b(tmpP2b);
for cc=1:4, outputstruct.B_neurpropSI(cc)=length(find(ismember(tmpdata2b,catlabs(cc))==1)); end
% NeuronProportion (no Fruit), Sig criteria (cutoff)
tmpdata3a=udata.stats_prefexcite_v_others_nofruit(patchneurons);
tmpP3a=find(tmpdata3a<0.05);
tmpP3b=intersect(tmpP1a,tmpP3a);
tmpdata3b=tmpdata1b(tmpP3b);
for cc=1:4, outputstruct.B_neurpropSig(cc)=length(find(ismember(tmpdata3b,catlabs(cc))==1)); end
% NeuronResponses for ALL SENSORY neurons in patch
tmpdata4a=udata.cat_avg(patchneurons,:);
tmpdata4b=tmpdata4a(tmpP1a,:);
outputstruct.B_ALLcat_avg=mean(tmpdata4b,1);
outputstruct.B_ALLcat_sem=sem(tmpdata4b);
tmpdata4c=udata.norm_cat_avg(patchneurons,:);
tmpdata4d=tmpdata4c(tmpP1a,:);
outputstruct.B_ALLnorm_cat_avg=mean(tmpdata4d,1);
outputstruct.B_ALLnorm_cat_sem=sem(tmpdata4d);
% NeuronResponses for all SENSORY neurons with SI > cutoff
tmpdata5a=udata.cat_avg(patchneurons,:);
tmpdata5b=tmpdata5a(tmpP2b,:);
outputstruct.B_SIcat_avg=mean(tmpdata5b,1);
outputstruct.B_SIcat_sem=sem(tmpdata5b);
tmpdata5c=udata.norm_cat_avg(patchneurons,:);
tmpdata5d=tmpdata5c(tmpP2b,:);
outputstruct.B_SInorm_cat_avg=mean(tmpdata5d,1);
outputstruct.B_SInorm_cat_sem=sem(tmpdata5d);
% NeuronResponses for all SENSORY neurons with Significant Difference for Preferred Response
tmpdata6a=udata.cat_avg(patchneurons,:);
tmpdata6b=tmpdata6a(tmpP3b,:);
outputstruct.B_SIGcat_avg=mean(tmpdata6b,1);
outputstruct.B_SIGcat_sem=sem(tmpdata6b);
tmpdata6c=udata.norm_cat_avg(patchneurons,:);
tmpdata6d=tmpdata6c(tmpP3b,:);
outputstruct.B_SIGnorm_cat_avg=mean(tmpdata6d,1);
outputstruct.B_SIGnorm_cat_sem=sem(tmpdata6d);

% NeuronSI - All Sensory Neurons
tmpdata7a=udata.cat_si_nofruit(patchneurons,:);
tmpdata7b=tmpdata7a(tmpP1a,:);
outputstruct.ALLcatsi_avg=mean(tmpdata7b,1);
outputstruct.ALLcatsi_sem=sem(tmpdata7b);
% NeuronSI - SI Cutoff
tmpdata8a=tmpdata7a(tmpP2b,:);
outputstruct.SIcatsi_avg=mean(tmpdata8a,1);
outputstruct.SIcatsi_sem=sem(tmpdata8a);
% NeuronSI - Significance Cutoff
tmpdata9a=tmpdata7a(tmpP3b,:);
outputstruct.SIGcatsi_avg=mean(tmpdata9a,1);
outputstruct.SIGcatsi_sem=sem(tmpdata9a);
% NeuronSI - All Excitatory Neurons
% NeuronSI - All Suppressed Neurons
return

%% Figure 13 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractROC_Grid_Excite(uindex,udata,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.roc_analysis(pointer,catcol);
return
function output=extractROC_Grid_Inhibit(uindex,udata,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.roc_analysis(pointer,catcol);
return
function output=extractROC_Grid_Both(uindex,udata,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.roc_analysis(pointer,catcol);
return

%% Figure 14 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bardata=extractStimSelect_Grid(uindex,udata,gridlocs);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT=intersect(pointer1,pointer2);
catnames={'Faces','BodyParts','Objects','Places'};
catcols=[1 4 5 3];
for cat=1:4,
    pointer3=find(strcmp(catnames(cat),udata.prefcat_excite_nofruit)==1|strcmp(catnames(cat),udata.prefcat_inhibit_nofruit)==1);
    pointer4=find(udata.anova_within_group(:,catcols(cat))<0.05);
    totalpointer=intersect(pointerT,pointer3);
    totalnum=length(totalpointer);
    stimnum=length(intersect(totalpointer,pointer4));
    bardata(cat)=(stimnum/totalnum)*100;
end
return

function bardata=extractStimSelect_Gridall(uindex,udata,gridlocs);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT=intersect(pointer1,pointer2);
catnames={'Faces','BodyParts','Objects','Places'};
catcols=[1 4 5 3];
for ct=1:4,
    pointer3=find(strcmp(catnames(ct),udata.prefcat_excite_nofruit)==1|strcmp(catnames(ct),udata.prefcat_inhibit_nofruit)==1)'; % catselectneurons
    pointer4=find(udata.anova_within_group(:,catcols(ct))<0.05); % stim select
    bardata(ct,1)=length(intersect(pointerT,intersect(pointer4,pointer3))); % stim select
    bardata(ct,2)=length(intersect(pointerT,pointer3)); % total sensory select for cat
    bardata(ct,3)=length(pointerT); % total sensory
    bardata(ct,4)=(bardata(ct,1)/bardata(ct,3))*100;
    bardata(ct,5)=((bardata(ct,2)/bardata(ct,3))*100)-bardata(ct,4);
    bardata(ct,6)=bardata(ct,1)/bardata(ct,2)*100;
end
return

%% Figure 15 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractCatSI_Grid_Excite_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer4=find(strcmp(udata.prefcat_excite_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSI_Grid_Inhibit_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer4=find(strcmp(udata.prefcat_inhibit_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return
function output=extractCatSI_Grid_Both_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer3=find(strcmp(udata.prefcat_excite_nofruit,prefcat)==1|strcmp(udata.prefcat_inhibit_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointer3,pointerT1);
output=udata.cat_si_nofruit(pointer,catcol);
return

%% Figure 16 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output=extractROC_Grid_Excite_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer4=find(strcmp(udata.prefcat_excite_nofruit,prefcat)==1|strcmp(udata.prefcat_inhibit_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.roc_analysis(pointer,catcol);
return
function output=extractROC_Grid_Inhibit_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer4=find(strcmp(udata.prefcat_excite_nofruit,prefcat)==1|strcmp(udata.prefcat_inhibit_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.roc_analysis(pointer,catcol);
return
function output=extractROC_Grid_Both_prefCat(uindex,udata,catcol,gridlocs,prefcat)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer3=find(strcmp(udata.prefcat_excite_nofruit,prefcat)==1|strcmp(udata.prefcat_inhibit_nofruit,prefcat)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointer3,pointerT1);
output=udata.roc_analysis(pointer,catcol);
return

%% Figure 14 Subroutines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function bardata=extractStimSelect(data,APrange);
bardata=zeros(5,2); numgrids=size(data,2);
for g=1:numgrids,
    if ismember(data(g).grid_coords(1,1),APrange)==1,
        for c=1:5,
            bardata(c,1)=bardata(c,1)+data(g).counts(c);
            bardata(c,2)=bardata(c,2)+data(g).within_counts(c);
        end; end; end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bardata(:,4)=bardata(:,2) ./ bardata(:,1) * 100;
return

function [numsensory,numcat,output]=extractCatPropExcite(data,APrange,catcol); % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).counts_nofruit(catcol);
    end
end
output=numcat/numsensory;
return

function [numsensory,numcat,output]=extractCatPropInhibit(data,APrange,catcol); % Updated: NO FRUIT % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).countsI_nofruit(catcol);
    end
end
output=numcat/numsensory;
return

function [numsensory,numcat,output]=extractCatPropBoth(data,APrange,catcol); % Updated: NO FRUIT % output will be multiple values (1/gridloc)
numgrids=size(data,2); numsensory=0; numcat=0;
for gg=1:numgrids,
    if ismember(data(gg).grid_coords(1,1),APrange)==1,
        numsensory=numsensory+data(gg).numsensory;
        numcat=numcat+data(gg).countsB_nofruit(catcol);
    end
end
output=numcat/numsensory;
return

function output=extractCatSI_AP(uindex,udata,catname,catcol,APrange) % Updated: NO FRUIT
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_excite_nofruit,catname)==1);
pointer4=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return

function output=extractCatSI_APall(uindex,udata,catname,catcol,APrange)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.APcoords(:,1),APrange)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return

function output=extractRawSI_Grid(uindex,udata,gridlocs);
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT=intersect(pointer1,pointer2);
pointer=intersect(pointerT,pointer3);
output=udata.raw_si_nofruit(pointer);
return




function output=extractCatSI_Grid(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.prefcat_excite_nofruit,catname)==1);
pointer4=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointerT2=intersect(pointer3,pointer4);
pointer=intersect(pointerT1,pointerT2);
output=udata.cat_si_nofruit(pointer,catcol);
return

function output=extractCatSI_APall_Grid_Both(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.cat_si_nofruit(pointer,catcol);
return

function output=extractCatSI_APall_Grid_Excite(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return

function output=extractCatSI_APall_Grid_Inhibit(uindex,udata,catname,catcol,gridlocs)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(ismember(uindex.GridLoc,gridlocs)==1);
pointerT1=intersect(pointer1,pointer2);
pointer=intersect(pointerT1,pointer3);
output=udata.cat_si_nofruit(pointer,catcol);
return



