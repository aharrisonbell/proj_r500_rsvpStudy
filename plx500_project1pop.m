function plx500_project1pop(neurtype);
%%%%%%%%%%%%%%%%%%%%%%
% plx500_project1pop %
%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Jan2009, updated Mar2009 - to remove FRUIT from all
% analyses.
% based on plx500_sortgrid - adapted to follow RSVP500_Outline, and to be
% compatible with both Monkeys
% MONKINITIAL (required) = 'W' or 'S'
% NEURTYPE (optional) = 'ns','bs', or 'both' (default)

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, neurtype='both'; end
% Grid location groups for comparison
grpS(1).grids={'A7L2','A7L1','A7R1'}; % n=87
grpS(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % n=100
grpS(3).grids={'A4L2','A4L1','A4R1'}; % n=87
grpS(4).grids={'A2L5','A0L6','A0L2','A0R0','P1L1','P2L3','P3L5','P3L4'}; % n=128
grpS(5).grids={'P5L3','P6L3','P6L2','P6L1','P7L2'}; % n=74
% Grid location groups for comparison
grpW(1).grids={'A6R2','A5R0','A4R3'}; % n=48
grpW(2).grids={'A3R0','A2R1','A2R3','A2R5'}; % n=112
grpW(3).grids={'P1R0','P1R3'}; % n=88
grpW(4).grids={'P3R0','P3R2','P5R0'}; % n=70
grpW(5).grids={'P3R0','P3R2','P5R0'}; % n=70
% A/P borders for Anterior/Middle/Posterior
ant=[19 18 17 16 15];
mid=[14 13 12 11 10];
post=[9 8 7 6 5];
sicutoff=0.2;

fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colourmaps
%hmiconfig.printer=1;
disp('**********************************************************************')
disp('* plx500_project1pop.m - Generates figures listed under Project 1 in *')
disp('*     RSVP500_Outline.docx.                                          *')
disp('**********************************************************************')
if strcmp(neurtype,'ns')==1,
    disp('Loading data for all narrow-spiking neurons...')
    neurlabel='NarrowSpiking';
    [dataS,numgridsS,counts_matrixS,allunitsS,unit_indexS,unitdataS]=plx500_prepproject1data_nt(hmiconfig,'RSVP Cells_S','ns');
    [dataW,numgridsW,counts_matrixW,allunitsW,unit_indexW,unitdataW]=plx500_prepproject1data_nt(hmiconfig,'RSVP Cells_W','ns');
elseif strcmp(neurtype,'bs')==1,
    disp('Loading data for all broad-spiking neurons...')
    neurlabel='BroadSpiking';
    [dataS,numgridsS,counts_matrixS,allunitsS,unit_indexS,unitdataS]=plx500_prepproject1data_nt(hmiconfig,'RSVP Cells_S','bs');
    [dataW,numgridsW,counts_matrixW,allunitsW,unit_indexW,unitdataW]=plx500_prepproject1data_nt(hmiconfig,'RSVP Cells_W','bs');
else
    disp('Loading data for all neurons...')
    neurlabel='Both';
    [dataS,numgridsS,counts_matrixS,allunitsS,unit_indexS,unitdataS]=plx500_prepproject1data(hmiconfig,'RSVP Cells_S');
    [dataW,numgridsW,counts_matrixW,allunitsW,unit_indexW,unitdataW]=plx500_prepproject1data(hmiconfig,'RSVP Cells_W');
end

% Need to subtract 100 from all of Wiggum's FMRI data
unitdataW.fmri_rsp=unitdataW.fmri_rsp-100;
for dg=1:size(dataW,2), dataW(dg).fmri_rsp=dataW(dg).fmri_rsp-100; end

% COMPILE DATASETS
data=[dataS dataW]; allunits=[allunitsS allunitsW]; numgrids=numgridsS+numgridsW;
counts_matrix=[counts_matrixS(1:end-1) counts_matrixW(1:end-1)];
counts_matrix(end+1).data=counts_matrixS(end).data + counts_matrixW(end).data;

unitdata.raw_si=[unitdataS.raw_si unitdataW.raw_si];
unitdata.cat_si=[unitdataS.cat_si;unitdataW.cat_si];
unitdata.excite_rawsi=[unitdataS.excite_rawsi unitdataW.excite_rawsi];
unitdata.inhibit_rawsi=[unitdataS.inhibit_rawsi unitdataW.inhibit_rawsi];
unitdata.pref_excite=[unitdataS.pref_excite unitdataW.pref_excite];
unitdata.pref_inhibit=[unitdataS.pref_inhibit unitdataW.pref_inhibit];
unitdata.stimresponse=[unitdataS.stimresponse;unitdataW.stimresponse];
unitdata.cat_avg=[unitdataS.cat_avg;unitdataW.cat_avg];
unitdata.roc_analysis=[unitdataS.roc_analysis;unitdataW.roc_analysis];
unitdata.wf_type=[unitdataS.wf_type unitdataW.wf_type];
unitdata.wf_include=[unitdataS.wf_include unitdataW.wf_include];
unitdata.wf_params=[unitdataS.wf_params;unitdataW.wf_params ];
unitdata.excite_rawsi_nofruit=[unitdataS.excite_rawsi_nofruit unitdataW.excite_rawsi_nofruit]; % [1x609 double]
unitdata.inhibit_rawsi_nofruit=[unitdataS.inhibit_rawsi_nofruit unitdataW.inhibit_rawsi_nofruit]; % [1x609 double]
unitdata.cat_si_nofruit=[unitdataS.cat_si_nofruit;unitdataW.cat_si_nofruit]; %  [609x4 double]
unitdata.APcoords=[unitdataS.APcoords;unitdataW.APcoords]; %      [609x2 double]
unitdata.AFNIcoords=[unitdataS.AFNIcoords;unitdataW.AFNIcoords]; % [609x3 double]
unitdata.FMRIdat_coords=[unitdataS.FMRIdat_coords;unitdataW.FMRIdat_coords]; % [609x3 double]
%unitdata.AFNItimeseries=[unitdataS.AFNItimeseries;unitdataW.AFNItimeseries]; % : [609x176 double]
unitdata.fmri_rsp=[unitdataS.fmri_rsp;unitdataW.fmri_rsp]; % : [609x4 double]
unitdata.fmri_catsi=[unitdataS.fmri_catsi;unitdataW.fmri_catsi]; % : [609x4 double]
unitdata.fmri_excite_rawsi=[unitdataS.fmri_excite_rawsi unitdataW.fmri_excite_rawsi]; % : [1x609 double]
unitdata.fmri_inhibit_rawsi=[unitdataS.fmri_inhibit_rawsi unitdataW.fmri_inhibit_rawsi]; % : [1x609 double]
unitdata.excitetype_nofruit=[unitdataS.excitetype_nofruit unitdataW.excitetype_nofruit]; % : {1x609 cell}
unitdata.prefcat_excite_nofruit=[unitdataS.prefcat_excite_nofruit unitdataW.prefcat_excite_nofruit]; % : {1x609 cell}
unitdata.prefcat_inhibit_nofruit=[unitdataS.prefcat_inhibit_nofruit unitdataW.prefcat_inhibit_nofruit]; % : {1x609 cell}
unitdata.face_trad_nofruit=[unitdataS.face_trad_nofruit unitdataW.face_trad_nofruit]; % : [1x609 double]
unitdata.selective_nofruit=[unitdataS.selective_nofruit unitdataW.selective_nofruit]; % : {1x609 cell}
unitdata.stats_rsp_matrix_avg=[unitdataS.stats_rsp_matrix_avg;unitdataW.stats_rsp_matrix_avg];
unitdata.stats_rsp_matrix_trial=[unitdataS.stats_rsp_matrix_trial;unitdataW.stats_rsp_matrix_trial];
unitdata.stats_prefexcite_v_others_nofruit=[unitdataS.stats_prefexcite_v_others_nofruit unitdataW.stats_prefexcite_v_others_nofruit];
unitdata.stats_prefinhibit_v_others_nofruit=[unitdataS.stats_prefinhibit_v_others_nofruit unitdataW.stats_prefinhibit_v_others_nofruit];
unitdata.LFP_lfp_average_epoch_rect=[unitdataS.LFP_lfp_average_epoch_rect;unitdataW.LFP_lfp_average_epoch_rect];
unitdata.LFP_cat_avg_rect_epoch=[unitdataS.LFP_cat_avg_rect_epoch;unitdataW.LFP_cat_avg_rect_epoch];
unitdata.LFP_bestlabel=[unitdataS.LFP_bestlabel';unitdataW.LFP_bestlabel'];
unitdata.LFP_cat_anova_rect=[unitdataS.LFP_cat_anova_rect;unitdataW.LFP_cat_anova_rect];
unitdata.LFP_evoked_cat_si=[unitdataS.LFP_evoked_cat_si;unitdataW.LFP_evoked_cat_si];
unitdata.LFP_freq_epoch_cat=[unitdataS.LFP_freq_epoch_cat;unitdataW.LFP_freq_epoch_cat];
unitdata.LFP_freq_bestlabel=[unitdataS.LFP_freq_bestlabel;unitdataW.LFP_freq_bestlabel];
unitdata.LFP_freq_across_anova=[unitdataS.LFP_freq_across_anova;unitdataW.LFP_freq_across_anova];
unitdata.LFP_freq_cat_si=[unitdataS.LFP_freq_cat_si;unitdataW.LFP_freq_cat_si];
unitdata.LFP_stats_pref_v_others_evoked=[unitdataS.LFP_stats_pref_v_others_evoked';unitdataW.LFP_stats_pref_v_others_evoked'];
unitdata.LFP_stats_pref_v_others_0_120Hz=[unitdataS.LFP_stats_pref_v_others_0_120Hz';unitdataW.LFP_stats_pref_v_others_0_120Hz'];
unitdata.LFP_stats_pref_v_others_0_20Hz=[ unitdataS.LFP_stats_pref_v_others_0_20Hz';unitdataW.LFP_stats_pref_v_others_0_20Hz'];

unit_index.PlxFile=[unit_indexS.PlxFile;unit_indexW.PlxFile];
unit_index.UnitName=[unit_indexS.UnitName;unit_indexW.UnitName];
unit_index.GridLoc=[unit_indexS.GridLoc;unit_indexW.GridLoc];
unit_index.Depth=[unit_indexS.Depth;unit_indexW.Depth];
unit_index.APIndex=[unit_indexS.APIndex;unit_indexW.APIndex];
unit_index.EstimatedLocation=[unit_indexS.EstimatedLocation;unit_indexW.EstimatedLocation];
unit_index.SensoryAuto=[unit_indexS.SensoryAuto;unit_indexW.SensoryAuto];
unit_index.SensoryConf=[unit_indexS.SensoryConf;unit_indexW.SensoryConf];
unit_index.CategoryAuto=[unit_indexS.CategoryAuto;unit_indexW.CategoryAuto];
unit_index.CategoryConf=[unit_indexS.CategoryConf;unit_indexW.CategoryConf];
unit_index.SelectiveAuto=[unit_indexS.SelectiveAuto;unit_indexW.SelectiveAuto];
unit_index.SelectiveConf=[unit_indexS.SelectiveConf;unit_indexW.SelectiveConf];
unit_index.ExciteAuto=[unit_indexS.ExciteAuto;unit_indexW.ExciteAuto];
unit_index.ExciteConf=[unit_indexS.ExciteConf;unit_indexW.ExciteConf];
unit_index.Quality=[unit_indexS.Quality;unit_indexW.Quality];
unit_index.wf_include=[unit_indexS.wf_include;unit_indexW.wf_include];
unit_index.wf_type=[unit_indexS.wf_type;unit_indexW.wf_type];
unit_index.pref_excite=[unit_indexS.pref_excite;unit_indexW.pref_excite];
unit_index.pref_inhibit=[unit_indexS.pref_inhibit;unit_indexW.pref_inhibit];
unit_index.APcoords=[unit_indexS.APcoords;unit_indexW.APcoords];
unit_index.prefcat_excite_nofruit=[unit_indexS.prefcat_excite_nofruit;unit_indexW.prefcat_excite_nofruit];
unit_index.prefcat_inhibit_nofruit=[unit_indexS.prefcat_inhibit_nofruit;unit_indexW.prefcat_inhibit_nofruit];
unit_index.stats_prefexcite_v_others_nofruit=[unit_indexS.stats_prefexcite_v_others_nofruit unit_indexW.stats_prefexcite_v_others_nofruit];
unit_index.stats_prefinhibit_v_others_nofruit=[unit_indexS.stats_prefinhibit_v_others_nofruit unit_indexW.stats_prefinhibit_v_others_nofruit];
unit_index.excitetype_nofruit=[unit_indexS.excitetype_nofruit;unit_indexW.excitetype_nofruit];
unit_index.selective_nofruit=[unit_indexS.selective_nofruit;unit_indexW.selective_nofruit];
save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_BothMonks_',neurtype,'.mat'],'data','unit_index','unitdata');

%%% GENERATE FIGURES (see RSVP500_Outline.docx for details)
% Figure 1  (Neuron Distribution Figure)
disp('Figure 1  (Neuron Distribution Figure)')
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6]); set(gca,'FontName','Arial','FontSize',8);
subplot(3,3,1); piedata=[]; % Assumes removing fruit has no impact on responsiveness
piedata(1)=length(find(strcmp(unit_index.excitetype_nofruit,'Non-Responsive')~=1));
piedata(2)=length(find(strcmp(unit_index.excitetype_nofruit,'Non-Responsive')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str((piedata(1)/sum(piedata))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str((piedata(2)/sum(piedata))*100,'%1.2g'),'%)']})
title(['(A) Sensory/Non-Responsive (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('S','NS','Location','Best'); set(gca,'FontSize',7)
subplot(3,3,2); piedata=[]; % Updated NO FRUIT
piedata(1)=length(find(strcmp(unit_index.excitetype_nofruit,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(2)=length(find(strcmp(unit_index.excitetype_nofruit,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(3)=length(find(strcmp(unit_index.excitetype_nofruit,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
piedata(4)=length(find(strcmp(unit_index.excitetype_nofruit,'Non-Responsive')==1));
pie(piedata,...
    {['n=',num2str(piedata(1)),'(',num2str(piedata(1)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(2)),'(',num2str(piedata(2)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(3)),'(',num2str(piedata(3)/sum(piedata)*100,'%1.2g'),'%)'] ...
    ['n=',num2str(piedata(4)),'(',num2str(piedata(4)/sum(piedata)*100,'%1.2g'),'%)']})
title(['(B) Excite/Inhibit/Both (n=',num2str(sum(piedata)),')'],'FontSize',fontsize_med,'FontWeight','Bold')
legend('E','I','B','NR','Location','Best'); set(gca,'FontSize',7)


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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_PieCharts_BothMonks_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_PieCharts_BothMonks_BothMonkeys_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F1_PieCharts_BothMonks_BothMonkeys_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 2 - Raw SI histogram of all category selective neurons
disp('Figure 2 - Raw SI histogram of all category selective neurons')
figure; clf; cla; % selectivity index histograms
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,4,1)
dd=extractRawSI(unit_index,unitdata,5:19); hist(dd,0:0.1:1);
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw EXCITATORY SI','CatSelectiveNeurons - nofruit'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(dd))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd)),' (',num2str(sem(dd),'%1.2g'),')'],'FontSize',7)
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Excitatory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,2)
dd2=abs(extractRawSI_inhibit(unit_index,unitdata,5:19)); hist(dd2,0:0.1:1)
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw SUPPRESSED SI','CatSelectiveNeurons - nofruit'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n=',num2str(length(dd2))],'FontSize',7)
text(0.6,100,['Avg: ',num2str(mean(dd2)),' (',num2str(sem(dd2),'%1.2g'),')'],'FontSize',7)
[p,h]=ranksum(dd,dd2); text(0.6,140,['P=',num2str(p,'%1.2g')],'FontSize',7);
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Inhibitory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,3) % significant RawSI (those that show a significant 
pointers=find(unit_index.stats_prefexcite_v_others_nofruit<0.05);
pointerns=find(unit_index.stats_prefexcite_v_others_nofruit>=0.05);
pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1 & ismember(unit_index.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unit_index.selective_nofruit,'Selective')==1);
pointer2=find(ismember(unit_index.APcoords(:,1),5:19)==1);
pointerT1=intersect(pointer1,pointer2); 
pointerFS=intersect(pointerT1,pointers); pointerFNS=intersect(pointerT1,pointerns);
hold on
dds=unitdata.excite_rawsi_nofruit(pointerFS);
ddns=unitdata.excite_rawsi_nofruit(pointerFNS);
s=hist(dds,0:0.1:1); ns=hist(ddns,0:0.1:1);
bar(0:0.1:1,[s;ns]','stack')
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw EXCITATORY SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n(ns)=',num2str(length(ddns))],'FontSize',7)
text(0.6,100,['n(s)=',num2str(length(dds))],'FontSize',7)
text(0.6,90,['Avg(s): ',num2str(mean(dds)),' (',num2str(sem(dds),'%1.2g'),')'],'FontSize',7)
text(0.6,70,['Avg(ns): ',num2str(mean(ddns)),' (',num2str(sem(ddns),'%1.2g'),')'],'FontSize',7)
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Excitatory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,4) % significant RawSI (those that show a significant 
pointers=find(unit_index.stats_prefinhibit_v_others_nofruit<0.05);
pointerns=find(unit_index.stats_prefinhibit_v_others_nofruit>=0.05);
pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1 & ismember(unit_index.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unit_index.selective_nofruit,'Selective')==1);
pointer2=find(ismember(unit_index.APcoords(:,1),5:19)==1);
pointerT1=intersect(pointer1,pointer2); 
pointerFS=intersect(pointerT1,pointers); pointerFNS=intersect(pointerT1,pointerns);
hold on
dds=abs(unitdata.inhibit_rawsi_nofruit(pointerFS));
ddns=abs(unitdata.inhibit_rawsi_nofruit(pointerFNS));
s=hist(dds,0:0.1:1); ns=hist(ddns,0:0.1:1);
bar(0:0.1:1,[s;ns]','stack')
set(gca,'FontName','Arial','FontSize',8)
xlabel({'Raw SUPPRESSED SI','CatSelectiveNeurons'},'FontSize',8); ylabel('# Neurons','FontSize',8);
text(0.6,80,['n(ns)=',num2str(length(ddns))],'FontSize',7)
text(0.6,100,['n(s)=',num2str(length(dds))],'FontSize',7)
text(0.6,90,['Avg(s): ',num2str(mean(dds)),' (',num2str(sem(dds),'%1.2g'),')'],'FontSize',7)
text(0.6,70,['Avg(ns): ',num2str(mean(ddns)),' (',num2str(sem(ddns),'%1.2g'),')'],'FontSize',7)
ylim([0 200]); xlim([-0.2 1.2]); axis square
title({'Average Raw SI (for Selective Neurons)','Inhibitory Responses Only'},'FontWeight','Bold','FontSize',fontsize_med);
subplot(2,4,5)
faceSI=extractCatSI(unit_index,unitdata,'Faces',1);
placeSI=extractCatSI(unit_index,unitdata,'Places',2);
bpartSI=extractCatSI(unit_index,unitdata,'BodyParts',3);
objectSI=extractCatSI(unit_index,unitdata,'Objects',4);
hold on
bar([mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)])
errorbar(1:4,[mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(objectSI) sem(placeSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'Face','BPart','Object','Place'})
ylabel('Average Category SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(faceSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(bpartSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(objectSI))],'FontSize',7)
text(4,.48,['n=',num2str(length(placeSI))],'FontSize',7)
[p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(bpartSI,objectSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(objectSI,placeSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(faceSI,placeSI); text(2.5,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
title({'Category Selectivity of CatSelective Neurons)','Excitatory Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,6)
faceSI=extractCatSI_inhibit(unit_index,unitdata,'Faces',1);
placeSI=extractCatSI_inhibit(unit_index,unitdata,'Places',2);
bpartSI=extractCatSI_inhibit(unit_index,unitdata,'BodyParts',3);
objectSI=extractCatSI_inhibit(unit_index,unitdata,'Objects',4);
hold on
bar([mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)])
errorbar(1:4,[mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(objectSI) sem(placeSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'Face','BPart','Object','Place'})
ylabel('Average Category SI','FontSize',8); ylim([-0.5 0]); axis square
text(1,-.48,['n=',num2str(length(faceSI))],'FontSize',7)
text(2,-.48,['n=',num2str(length(bpartSI))],'FontSize',7)
text(3,-.48,['n=',num2str(length(objectSI))],'FontSize',7)
text(4,-.48,['n=',num2str(length(placeSI))],'FontSize',7)
try [p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(bpartSI,objectSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(objectSI,placeSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
try [p,h]=ranksum(faceSI,placeSI); text(2.5,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center'); end
title({'Category Selectivity of CatSelective Neurons)','Inhibited Responses'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
subplot(2,4,7)
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
subplot(2,4,8)
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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_BothMonks_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_BothMonks_BothMonkeys_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F2_rawSI_BothMonks_BothMonkeys_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 3  (Stimulus Selectivity Figure)
disp('Figure 3  (Stimulus Selectivity Figure)')
%%% stimulus electivity according to category (preferred)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.9 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(1,3,1) % Within category selectivity
bardata=zeros(5,2);
for g=1:numgrids,
    for c=1:4,
        bardata(c,1)=bardata(c,1)+data(g).counts_nofruit(c);
        bardata(c,2)=bardata(c,2)+data(g).within_counts_nofruit(c);
    end
end
bardata(:,3)=bardata(:,1)-bardata(:,2);
bar(bardata([1 3 4 2],2:3),'stack')
tmp=sum(bardata); tmpprc=tmp(2)/tmp(1); bardata(:,4)=bardata(:,1)*tmpprc;
[p,h]=chi2_test(bardata(:,2),bardata(:,4));
text(1,bardata(1,1)+5,[num2str(bardata(1,2)/bardata(1,1)*100,'%1.2g'),'%'],'FontSize',7); 
text(2,bardata(3,1)+5,[num2str(bardata(3,2)/bardata(3,1)*100,'%1.2g'),'%'],'FontSize',7); 
text(3,bardata(4,1)+5,[num2str(bardata(4,2)/bardata(4,1)*100,'%1.2g'),'%'],'FontSize',7); 
text(4,bardata(2,1)+5,[num2str(bardata(2,2)/bardata(2,1)*100,'%1.2g'),'%'],'FontSize',7); 
set(gca,'XTick',1:4,'XTickLabel',{'F','Bp','O','P',}); axis square
legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
title({'Within Category Selectivity (per category)',['(ChiSquare: p=',num2str(p,'%1.2g'),')']},'FontWeight','Bold')
%%% stimulus selectivity according to grid location
subplot(1,3,2) % uninterpolated stimulus selectivity
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
subplot(1,3,3)
faceSI=extractCatSI(unit_index,unitdata,'Faces',1);
placeSI=extractCatSI(unit_index,unitdata,'Places',2);
bpartSI=extractCatSI(unit_index,unitdata,'BodyParts',3);
objectSI=extractCatSI(unit_index,unitdata,'Objects',4);
hold on
bar([mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)])
errorbar(1:4,[mean(faceSI) mean(bpartSI) mean(objectSI) mean(placeSI)],[sem(faceSI) sem(bpartSI) sem(objectSI) sem(placeSI)])
set(gca,'FontName','Arial','FontSize',8,'XTick',1:4,'XTickLabel',{'Face','BPart','Object','Place'})
ylabel('Average Category SI','FontSize',8); ylim([0 0.5]); axis square
text(1,.48,['n=',num2str(length(faceSI))],'FontSize',7)
text(2,.48,['n=',num2str(length(bpartSI))],'FontSize',7)
text(3,.48,['n=',num2str(length(objectSI))],'FontSize',7)
text(4,.48,['n=',num2str(length(placeSI))],'FontSize',7)
[p,h]=ranksum(faceSI,bpartSI); text(1.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(bpartSI,objectSI); text(2.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(objectSI,placeSI); text(3.5,0.32,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
[p,h]=ranksum(faceSI,placeSI); text(2.5,0.35,['p=',num2str(p,'%1.2g')],'FontSize',7,'HorizontalAlignment','Center')
title({'Category Selectivity of Excite/Both Preferring Neurons_BothMonks'},'FontWeight','Bold','FontSize',fontsize_med); axis square;
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_BothMonkeys_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_BothMonkeys_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F3_withinCat_BothMonkeys_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%% FMRI DATA ANALYSIS
% Figure 5  (Percent Signal Change vs. Firing Rate for each Category, SI vs. SI --- PER GRID)
disp('Figure 5  (Percent Signal Change vs. Firing Rate for each Category)')
% Load data for both monkeys
compdata=struct('fmri_rsp_avg',[],'fmri_si_avg',[],'uniq_fmri_rsp_avg',[],'uniq_fmri_si_avg',[],...
    'E_neurprop',[],'E_neurpropSI',[],'E_neurpropSig',[],'E_ALLcat_avg',[],'E_ALLnorm_cat_avg',[],...
    'E_SIcat_avg',[],'E_SInorm_cat_avg',[],'E_SIGcat_avg',[],'E_SIGnorm_cat_avg',[],'I_neurprop',[],...
    'I_neurpropSI',[],'I_neurpropSig',[],'I_ALLcat_avg',[],'I_ALLnorm_cat_avg',[],'I_SIcat_avg',[],...
    'I_SInorm_cat_avg',[],'I_SIGcat_avg',[],'I_SIGnorm_cat_avg',[],'B_neurprop',[],'B_neurpropSI',[],...
    'B_neurpropSig',[],'B_ALLcat_avg',[],'B_ALLnorm_cat_avg',[],'B_SIcat_avg',[],'B_SInorm_cat_avg',[],...
    'B_SIGcat_avg',[],'B_SIGnorm_cat_avg',[],'ALLcatsi_avg',[],'SIcatsi_avg',[],'SIGcatsi_avg',[]);
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_fMRICompData_Stewie_',neurtype,'.mat']); otS=ot;
for s=1:size(otS,2),
    compdata.fmri_rsp_avg=[compdata.fmri_rsp_avg;otS(s).fmri_rsp_avg([1 4 3 2])'];
    compdata.fmri_si_avg=[compdata.fmri_si_avg;otS(s).fmri_si_avg([1 4 3 2])'];
    compdata.uniq_fmri_rsp_avg=[compdata.uniq_fmri_rsp_avg;otS(s).uniq_fmri_rsp_avg([1 4 3 2])'];
    compdata.uniq_fmri_si_avg=[compdata.uniq_fmri_si_avg;otS(s).uniq_fmri_si_avg([1 4 3 2])'];
    compdata.E_neurprop=[compdata.E_neurprop;(otS(s).E_neurprop/sum(otS(s).E_neurprop))'];
    compdata.E_neurpropSI=[compdata.E_neurpropSI;(otS(s).E_neurpropSI/sum(otS(s).E_neurpropSI))'];
    compdata.E_neurpropSig=[compdata.E_neurpropSig;(otS(s).E_neurpropSig/sum(otS(s).E_neurpropSig))'];
    compdata.E_ALLcat_avg=[compdata.E_ALLcat_avg;otS(s).E_ALLcat_avg([1 4 5 3])'];
    compdata.E_ALLnorm_cat_avg=[compdata.E_ALLnorm_cat_avg;otS(s).E_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.E_SIcat_avg=[compdata.E_SIcat_avg;otS(s).E_SIcat_avg([1 4 5 3])'];
    compdata.E_SInorm_cat_avg=[compdata.E_SInorm_cat_avg;otS(s).E_SInorm_cat_avg([1 4 5 3])'];
    compdata.E_SIGcat_avg=[compdata.E_SIGcat_avg;otS(s).E_SIGcat_avg([1 4 5 3])'];
    compdata.E_SIGnorm_cat_avg=[compdata.E_SIGnorm_cat_avg;otS(s).E_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.I_neurprop=[compdata.I_neurprop;(otS(s).I_neurprop/sum(otS(s).I_neurprop))'];
    compdata.I_neurpropSI=[compdata.I_neurpropSI;(otS(s).I_neurpropSI/sum(otS(s).I_neurpropSI))'];
    compdata.I_neurpropSig=[compdata.I_neurpropSig;(otS(s).I_neurpropSig/sum(otS(s).I_neurpropSig))'];
    compdata.I_ALLcat_avg=[compdata.I_ALLcat_avg;otS(s).I_ALLcat_avg([1 4 5 3])'];
    compdata.I_ALLnorm_cat_avg=[compdata.I_ALLnorm_cat_avg;otS(s).I_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.I_SIcat_avg=[compdata.I_SIcat_avg;otS(s).I_SIcat_avg([1 4 5 3])'];
    compdata.I_SInorm_cat_avg=[compdata.I_SInorm_cat_avg;otS(s).I_SInorm_cat_avg([1 4 5 3])'];
    compdata.I_SIGcat_avg=[compdata.I_SIGcat_avg;otS(s).I_SIGcat_avg([1 4 5 3])'];
    compdata.I_SIGnorm_cat_avg=[compdata.I_SIGnorm_cat_avg;otS(s).I_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.B_neurprop=[compdata.B_neurprop;(otS(s).B_neurprop/sum(otS(s).B_neurprop))'];
    compdata.B_neurpropSI=[compdata.B_neurpropSI;(otS(s).B_neurpropSI/sum(otS(s).B_neurpropSI))'];
    compdata.B_neurpropSig=[compdata.B_neurpropSig;(otS(s).B_neurpropSig/sum(otS(s).B_neurpropSig))'];
    compdata.B_ALLcat_avg=[compdata.B_ALLcat_avg;otS(s).B_ALLcat_avg([1 4 5 3])'];
    compdata.B_ALLnorm_cat_avg=[compdata.B_ALLnorm_cat_avg;otS(s).B_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.B_SIcat_avg=[compdata.B_SIcat_avg;otS(s).B_SIcat_avg([1 4 5 3])'];
    compdata.B_SInorm_cat_avg=[compdata.B_SInorm_cat_avg;otS(s).B_SInorm_cat_avg([1 4 5 3])'];
    compdata.B_SIGcat_avg=[compdata.B_SIGcat_avg;otS(s).B_SIGcat_avg([1 4 5 3])'];
    compdata.B_SIGnorm_cat_avg=[compdata.B_SIGnorm_cat_avg;otS(s).B_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.ALLcatsi_avg=[compdata.ALLcatsi_avg;otS(s).ALLcatsi_avg([1 3 4 2])'];    
    compdata.SIcatsi_avg=[compdata.SIcatsi_avg;otS(s).SIcatsi_avg([1 3 4 2])'];    
    compdata.SIGcatsi_avg=[compdata.SIGcatsi_avg;otS(s).SIGcatsi_avg([1 3 4 2])'];    
end
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_fMRICompData_Wiggum_',neurtype,'.mat']); otW=ot; otW(5)=[];
for s=1:size(otW,2),
    compdata.fmri_rsp_avg=[compdata.fmri_rsp_avg;(otW(s).fmri_rsp_avg([1 4 3 2]))'];
    compdata.fmri_si_avg=[compdata.fmri_si_avg;otW(s).fmri_si_avg([1 4 3 2])'];
    compdata.uniq_fmri_rsp_avg=[compdata.uniq_fmri_rsp_avg;(otW(s).uniq_fmri_rsp_avg([1 4 3 2]))'];
    compdata.uniq_fmri_si_avg=[compdata.uniq_fmri_si_avg;otW(s).uniq_fmri_si_avg([1 4 3 2])'];
    compdata.E_neurprop=[compdata.E_neurprop;(otW(s).E_neurprop/sum(otW(s).E_neurprop))'];
    compdata.E_neurpropSI=[compdata.E_neurpropSI;(otW(s).E_neurpropSI/sum(otW(s).E_neurpropSI))'];
    compdata.E_neurpropSig=[compdata.E_neurpropSig;(otW(s).E_neurpropSig/sum(otW(s).E_neurpropSig))'];
    compdata.E_ALLcat_avg=[compdata.E_ALLcat_avg;otW(s).E_ALLcat_avg([1 4 5 3])'];
    compdata.E_ALLnorm_cat_avg=[compdata.E_ALLnorm_cat_avg;otW(s).E_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.E_SIcat_avg=[compdata.E_SIcat_avg;otW(s).E_SIcat_avg([1 4 5 3])'];
    compdata.E_SInorm_cat_avg=[compdata.E_SInorm_cat_avg;otW(s).E_SInorm_cat_avg([1 4 5 3])'];
    compdata.E_SIGcat_avg=[compdata.E_SIGcat_avg;otW(s).E_SIGcat_avg([1 4 5 3])'];
    compdata.E_SIGnorm_cat_avg=[compdata.E_SIGnorm_cat_avg;otW(s).E_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.I_neurprop=[compdata.I_neurprop;(otW(s).I_neurprop/sum(otW(s).I_neurprop))'];
    compdata.I_neurpropSI=[compdata.I_neurpropSI;(otW(s).I_neurpropSI/sum(otW(s).I_neurpropSI))'];
    compdata.I_neurpropSig=[compdata.I_neurpropSig;(otW(s).I_neurpropSig/sum(otW(s).I_neurpropSig))'];
    compdata.I_ALLcat_avg=[compdata.I_ALLcat_avg;otW(s).I_ALLcat_avg([1 4 5 3])'];
    compdata.I_ALLnorm_cat_avg=[compdata.I_ALLnorm_cat_avg;otW(s).I_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.I_SIcat_avg=[compdata.I_SIcat_avg;otW(s).I_SIcat_avg([1 4 5 3])'];
    compdata.I_SInorm_cat_avg=[compdata.I_SInorm_cat_avg;otW(s).I_SInorm_cat_avg([1 4 5 3])'];
    compdata.I_SIGcat_avg=[compdata.I_SIGcat_avg;otW(s).I_SIGcat_avg([1 4 5 3])'];
    compdata.I_SIGnorm_cat_avg=[compdata.I_SIGnorm_cat_avg;otW(s).I_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.B_neurprop=[compdata.B_neurprop;(otW(s).B_neurprop/sum(otW(s).B_neurprop))'];
    compdata.B_neurpropSI=[compdata.B_neurpropSI;(otW(s).B_neurpropSI/sum(otW(s).B_neurpropSI))'];
    compdata.B_neurpropSig=[compdata.B_neurpropSig;(otW(s).B_neurpropSig/sum(otW(s).B_neurpropSig))'];
    compdata.B_ALLcat_avg=[compdata.B_ALLcat_avg;otW(s).B_ALLcat_avg([1 4 5 3])'];
    compdata.B_ALLnorm_cat_avg=[compdata.B_ALLnorm_cat_avg;otW(s).B_ALLnorm_cat_avg([1 4 5 3])'];
    compdata.B_SIcat_avg=[compdata.B_SIcat_avg;otW(s).B_SIcat_avg([1 4 5 3])'];
    compdata.B_SInorm_cat_avg=[compdata.B_SInorm_cat_avg;otW(s).B_SInorm_cat_avg([1 4 5 3])'];
    compdata.B_SIGcat_avg=[compdata.B_SIGcat_avg;otW(s).B_SIGcat_avg([1 4 5 3])'];
    compdata.B_SIGnorm_cat_avg=[compdata.B_SIGnorm_cat_avg;otW(s).B_SIGnorm_cat_avg([1 4 5 3])'];
    compdata.ALLcatsi_avg=[compdata.ALLcatsi_avg;otW(s).ALLcatsi_avg([1 3 4 2])'];    
    compdata.SIcatsi_avg=[compdata.SIcatsi_avg;otW(s).SIcatsi_avg([1 3 4 2])'];    
    compdata.SIGcatsi_avg=[compdata.SIGcatsi_avg;otW(s).SIGcatsi_avg([1 3 4 2])'];
end
%%% NEWER WAY OF COLLECTING FMRI DATA (Unique)
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
subplot(4,3,1); hold on % Signal Change vs. Proportion
plot(compdata.uniq_fmri_rsp_avg,compdata.E_neurprop*100,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_neurprop*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_neurprop*100,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_neurprop*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_neurprop*100,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_neurprop*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('% Proportion Cells'); ylim([0 100]); axis square;
%legend('Excite','Suppressed')
[r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_neurprop*100);
text(3,90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8)
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_neurprop*100); end
text(3,60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8)
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_neurprop*100); end
text(3,30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI Activation vs. Neuron Distribution','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(4,3,2); hold on % Signal Change vs. Proportion
plot(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSI*100,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSI*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSI*100,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSI*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSI*100,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSI*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('% Proportion Cells'); ylim([0 100]); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSI*100);
text(3,90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSI*100);
text(3,60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSI*100);
text(3,30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Activation vs. Neuron Distribution','(SI Cutoff)'},'FontWeight','Bold')
subplot(4,3,3); hold on % Signal Change vs. Proportion
plot(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSig*100,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSig*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSig*100,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSig*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSig*100,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSig*100,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('% Proportion Cells'); ylim([0 100]); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_neurpropSig*100);
text(3,90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_neurpropSig*100);
text(3,60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_neurpropSig*100);
text(3,30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Activation vs. Neuron Distribution','(Significance Cutoff)'},'FontWeight','Bold')

subplot(4,3,4); hold on % Signal Change vs. Firing Rate
plot(compdata.uniq_fmri_rsp_avg,compdata.E_ALLnorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_ALLnorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_ALLnorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_ALLnorm_cat_avg);
text(3,.8,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_ALLnorm_cat_avg);
text(3,.6,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_ALLnorm_cat_avg);
text(3,.4,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Activation vs. Normalized Neural Activity','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(4,3,5); hold on % Signal Change vs. Firing Rate
plot(compdata.uniq_fmri_rsp_avg,compdata.E_SInorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_SInorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_SInorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_SInorm_cat_avg);
text(3,.8,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_SInorm_cat_avg);
text(3,.6,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_SInorm_cat_avg);
text(3,.4,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Activation vs. Normalized Neural Activity','(SI Cutoff)'},'FontWeight','Bold')
subplot(4,3,6); hold on % Signal Change vs. Firing Rate
plot(compdata.uniq_fmri_rsp_avg,compdata.E_SIGnorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.E_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.I_SIGnorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.I_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_rsp_avg,compdata.B_SIGnorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_rsp_avg,compdata.B_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)]);
plot([min(compdata.uniq_fmri_rsp_avg) max(compdata.uniq_fmri_rsp_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI % Signal Change'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.E_SIGnorm_cat_avg);
text(3,.8,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.I_SIGnorm_cat_avg);
text(3,.6,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_rsp_avg,compdata.B_SIGnorm_cat_avg);
text(3,.4,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Activation vs. Normalized Neural Activity','(Significance Cutoff)'},'FontWeight','Bold')

subplot(4,3,7); hold on % Signal Change vs. Normalized Firing Rate
plot(compdata.uniq_fmri_si_avg,compdata.E_ALLnorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.E_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.I_ALLnorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.I_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.B_ALLnorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.B_ALLnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.E_ALLnorm_cat_avg);
text(.2,.90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.I_ALLnorm_cat_avg);
text(.2,.60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.B_ALLnorm_cat_avg);
text(.2,.30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(4,3,8); hold on % Signal Change vs. Normalized Firing Rate
plot(compdata.uniq_fmri_si_avg,compdata.E_SInorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.E_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.I_SInorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.I_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.B_SInorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.B_SInorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.E_SInorm_cat_avg);
text(.2,.90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.I_SInorm_cat_avg);
text(.2,.60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.B_SInorm_cat_avg);
text(.2,.30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(SI Cutoff)'},'FontWeight','Bold')
subplot(4,3,9); hold on % Signal Change vs. Normalized Firing Rate
plot(compdata.uniq_fmri_si_avg,compdata.E_SIGnorm_cat_avg,'gs','MarkerSize',3,'MarkerFaceColor','g');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.E_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'g-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.I_SIGnorm_cat_avg,'rs','MarkerSize',3,'MarkerFaceColor','r');
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.I_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'r-','LineWidth',2);
plot(compdata.uniq_fmri_si_avg,compdata.B_SIGnorm_cat_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.B_SIGnorm_cat_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Normalized Firing Rate'); axis square;
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.E_SIGnorm_cat_avg);
text(.2,.90,{['r(E)=',num2str(r,'%1.2g')],['p(E)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.I_SIGnorm_cat_avg);
text(.2,.60,{['r(I)=',num2str(r,'%1.2g')],['p(I)=',num2str(p,'%1.2g')]},'FontSize',8); end
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.B_SIGnorm_cat_avg);
text(.2,.30,{['r(B)=',num2str(r,'%1.2g')],['p(B)=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(Significance Cutoff)'},'FontWeight','Bold')

subplot(4,3,10); hold on % Selectivity vs. Selectivity Index
plot(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Selectivity'); ylim([-0.25 0.25]); xlim([-1 1]);
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(4,3,11); hold on % Signal Change vs. Selectivity Index
plot(compdata.uniq_fmri_si_avg,compdata.SIcatsi_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.SIcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Selectivity'); ylim([-0.25 0.25]); xlim([-1 1]);
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.SIcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(SI Cutoff)'},'FontWeight','Bold')
subplot(4,3,12); hold on % Signal Change vs. Selectivity Index
plot(compdata.uniq_fmri_si_avg,compdata.SIGcatsi_avg,'bs','MarkerSize',3,'MarkerFaceColor','b'); 
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.SIGcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'b-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Selectivity'); ylim([-0.25 0.25]); xlim([-1 1]);
%legend('Excite','Suppressed')
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.SIGcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(Significance Cutoff)'},'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F5_fMRISummary_perGrid_BothMonkeysUNIQ_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F5_fMRISummary_perGrid_BothMonkeysUNIQ_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F5_fMRIcatrsp_siperGrid_BothMonkeysUNIQ_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% new figure comparing selectivities 
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,3,1); hold on
for mm=1:5
    plot(otS(mm).uniq_fmri_si_avg(1),otS(mm).ALLcatsi_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otS(mm).uniq_fmri_si_avg(4),otS(mm).ALLcatsi_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otS(mm).uniq_fmri_si_avg(3),otS(mm).ALLcatsi_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otS(mm).uniq_fmri_si_avg(2),otS(mm).ALLcatsi_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
for mm=1:4,
    plot(otW(mm).uniq_fmri_si_avg(1),otW(mm).ALLcatsi_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otW(mm).uniq_fmri_si_avg(4),otW(mm).ALLcatsi_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otW(mm).uniq_fmri_si_avg(3),otW(mm).ALLcatsi_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otW(mm).uniq_fmri_si_avg(2),otW(mm).ALLcatsi_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(2,3,2); hold on
for mm=1:5
    plot(otS(mm).uniq_fmri_si_avg(1),otS(mm).ALLcatsi_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otS(mm).uniq_fmri_si_avg(4),otS(mm).ALLcatsi_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otS(mm).uniq_fmri_si_avg(3),otS(mm).ALLcatsi_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otS(mm).uniq_fmri_si_avg(2),otS(mm).ALLcatsi_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons - Stewie)'},'FontWeight','Bold')
subplot(2,3,3); hold on
for mm=1:4,
    plot(otW(mm).uniq_fmri_si_avg(1),otW(mm).ALLcatsi_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otW(mm).uniq_fmri_si_avg(4),otW(mm).ALLcatsi_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otW(mm).uniq_fmri_si_avg(3),otW(mm).ALLcatsi_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otW(mm).uniq_fmri_si_avg(2),otW(mm).ALLcatsi_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons - Wiggum)'},'FontWeight','Bold')
subplot(2,3,4); hold on
for mm=1:5
    plot(otS(mm).uniq_fmri_rsp_avg(1),otS(mm).E_ALLnorm_cat_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otS(mm).uniq_fmri_rsp_avg(4),otS(mm).E_ALLnorm_cat_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otS(mm).uniq_fmri_rsp_avg(3),otS(mm).E_ALLnorm_cat_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otS(mm).uniq_fmri_rsp_avg(2),otS(mm).E_ALLnorm_cat_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
for mm=1:4,
    plot(otW(mm).uniq_fmri_rsp_avg(1),otW(mm).E_ALLnorm_cat_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otW(mm).uniq_fmri_rsp_avg(4),otW(mm).E_ALLnorm_cat_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otW(mm).uniq_fmri_rsp_avg(3),otW(mm).E_ALLnorm_cat_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otW(mm).uniq_fmri_rsp_avg(2),otW(mm).E_ALLnorm_cat_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons)'},'FontWeight','Bold')
subplot(2,3,5); hold on
for mm=1:5
    plot(otS(mm).uniq_fmri_rsp_avg(1),otS(mm).E_ALLnorm_cat_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otS(mm).uniq_fmri_rsp_avg(4),otS(mm).E_ALLnorm_cat_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otS(mm).uniq_fmri_rsp_avg(3),otS(mm).E_ALLnorm_cat_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otS(mm).uniq_fmri_rsp_avg(2),otS(mm).E_ALLnorm_cat_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons - Stewie)'},'FontWeight','Bold')
subplot(2,3,6); hold on
for mm=1:4,
    plot(otW(mm).uniq_fmri_rsp_avg(1),otW(mm).E_ALLnorm_cat_avg(1),'rs','MarkerSize',5,'MarkerFaceColor','r');
    plot(otW(mm).uniq_fmri_rsp_avg(4),otW(mm).E_ALLnorm_cat_avg(3),'ys','MarkerSize',5,'MarkerFaceColor','y');
    plot(otW(mm).uniq_fmri_rsp_avg(3),otW(mm).E_ALLnorm_cat_avg(4),'gs','MarkerSize',5,'MarkerFaceColor','g');
    plot(otW(mm).uniq_fmri_rsp_avg(2),otW(mm).E_ALLnorm_cat_avg(2),'bs','MarkerSize',5,'MarkerFaceColor','b');
end
pf=polyfit(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg,1); ys=polyval(pf,[min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)]);
plot([min(compdata.uniq_fmri_si_avg) max(compdata.uniq_fmri_si_avg)],ys,'k-','LineWidth',2);
axis square; set(gca,'FontSize',7); xlabel('fMRI Selectivity'); ylabel('Neuronal Selectivity');
try [r,p,z]=pearson2(compdata.uniq_fmri_si_avg,compdata.ALLcatsi_avg);
text(.2,.3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8); end
title({'fMRI Selectivity vs. Normalized Neural Activity','(All Sensory Neurons - Wiggum)'},'FontWeight','Bold')

jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F6_talk_',neurtype,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F6_talk_',neurtype,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F6_talk_',neurtype,'.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
return

%%% NESTED FUNCTIONS %%%
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

function output=extractCatSIall_Grid_Both(uindex,udata,catname,catcol,gridlocs,cutoff)
pointer1=find(strcmp(uindex.SensoryConf,'Sensory')==1);
pointer2=find(ismember(uindex.GridLoc,gridlocs)==1);
pointer=intersect(pointer1,pointer2);
output=udata.cat_si(pointer,catcol);
return