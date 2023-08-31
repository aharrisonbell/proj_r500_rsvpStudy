function plx500_project1pop_LFPs(reload);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_project1pop_LFPs %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, May2009
% based on plx500_project1_LFPs - adapted to analyze LFP responses (population).
% Does not compare LFPs to anything else... yet

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file

if nargin==0, reload=0; end

% Grid location groups for comparison
grpS(1).grids={'A7L2','A7L1','A7R1'}; % BodyPart Selective
grpS(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Face Selective
grpS(3).grids={'A4L2','A4L1','A4R1'}; % Place Selective
grpS(4).grids={'A2L5','A0L6','A0L2','A0L0','A0R0','P1L1','P2L3','P3L5','P3L4','P5L2','P5L3','P6L3'}; % Object Selective
grpS(5).grids={'P6L2','P6L1','P7L2'}; % Face Selective


grpW(1).grids={'A6R2','A5R0','A4R3'}; % Bodypart Selective
grpW(2).grids={'A3R0','A2R1','A2R3','A2R5'}; % Face Selective
grpW(3).grids={'P1R0','P1R3'}; % Bodypart Selective
grpW(4).grids={'P3R0','P3R2','P5R0'}; % Place Selective



%%% sitedata
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_Stewie.mat'],'sitedata');
sitedataS=rmfield(sitedata,'FMRI_AFNItimeseries');
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_Wiggum.mat'],'sitedata');
sitedataW=rmfield(sitedata,'FMRI_AFNItimeseries');

clear sitedata
sitedata.filenames=[sitedataS.filenames;sitedataW.filenames];
sitedata.channames=[sitedataS.channames;sitedataW.channames];
sitedata.gridloc=[sitedataS.gridloc;sitedataW.gridloc];
sitedata.complete_filename=[sitedataS.complete_filename';sitedataW.complete_filename'];
sitedata.lfp_average_epoch_rect=[sitedataS.lfp_average_epoch_rect;sitedataW.lfp_average_epoch_rect];
sitedata.cat_avg_rect_epoch=[sitedataS.cat_avg_rect_epoch;sitedataW.cat_avg_rect_epoch];
sitedata.cat_avg_rect_epoch_tr=[sitedataS.cat_avg_rect_epoch_tr;sitedataW.cat_avg_rect_epoch_tr];
sitedata.evoked_cat_si=[sitedataS.evoked_cat_si;sitedataW.evoked_cat_si];
sitedata.evoked_rawsi=[sitedataS.evoked_rawsi';sitedataW.evoked_rawsi'];
sitedata.rect_rawsi=[sitedataS.rect_rawsi';sitedataW.rect_rawsi'];
sitedata.freq_rawsi=[sitedataS.freq_rawsi;sitedataW.freq_rawsi];
%sitedata.cond_min_max=[sitedataS.cond_min_max sitedataW.cond_min_max];
%sitedata.cat_min_max=[sitedataS.cat_min_max sitedataW.cat_min_max];
%sitedata.freq_epoch_cat=[sitedataS.freq_epoch_cat sitedataW.freq_epoch_cat];
sitedata.freq_cat_si=[sitedataS.freq_cat_si;sitedataW.freq_cat_si];
sitedata.anova_stim=[sitedataS.anova_stim;sitedataW.anova_stim];
sitedata.cat_anova=[sitedataS.cat_anova';sitedataW.cat_anova'];
sitedata.cat_anova_rect=[sitedataS.cat_anova_rect';sitedataW.cat_anova_rect'];
sitedata.freq_across_anova=[sitedataS.freq_across_anova;sitedataW.freq_across_anova];
%sitedata.freq_within_anova=[sitedataS.freq_within_anova sitedataW.freq_within_anova];
sitedata.bestlabel=[sitedataS.bestlabel';sitedataW.bestlabel'];
sitedata.bestlabel_rect=[sitedataS.bestlabel_rect';sitedataW.bestlabel_rect'];
sitedata.freq_bestlabel=[sitedataS.freq_bestlabel;sitedataW.freq_bestlabel];
sitedata.specgramMT_time_axis=[sitedataS.specgramMT_time_axis;sitedataW.specgramMT_time_axis];
sitedata.specgramMT_freq_axis=[sitedataS.specgramMT_freq_axis;sitedataW.specgramMT_freq_axis];
sitedata.AFNIcoords=[sitedataS.AFNIcoords;sitedataW.AFNIcoords];
sitedata.FMRIdat_coords=[sitedataS.FMRIdat_coords;sitedataW.FMRIdat_coords];
sitedata.FMRI_fmri_rsp=[sitedataS.FMRI_fmri_rsp;sitedataW.FMRI_fmri_rsp];
sitedata.FMRI_fmri_catsi=[sitedataS.FMRI_fmri_catsi;sitedataW.FMRI_fmri_catsi];
sitedata.FMRI_fmri_excite_rawsi=[sitedataS.FMRI_fmri_excite_rawsi';sitedataW.FMRI_fmri_excite_rawsi'];
sitedata.FMRI_fmri_inhibit_rawsi=[sitedataS.FMRI_fmri_inhibit_rawsi';sitedataW.FMRI_fmri_inhibit_rawsi'];

%%% griddata
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_Stewie.mat'],'griddata');
griddataS=rmfield(griddata,'FMRI_AFNItimeseries');
load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_Wiggum.mat'],'griddata');
griddataW=rmfield(griddata,'FMRI_AFNItimeseries');
griddata=[griddataS griddataW];
save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_BothMonks.mat'],'sitedata','griddata');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% LOAD RESPSTRUCTSINGLE DATA %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if reload==0,
    [dataS,numgridsS,counts_matrixS,allunitsS,unit_indexS,unitdataS]=plx500_prepproject1data(hmiconfig,'RSVP Cells_S');
    [dataW,numgridsW,counts_matrixW,allunitsW,unit_indexW,unitdataW]=plx500_prepproject1data(hmiconfig,'RSVP Cells_W');
    % Need to subtract 100 from all of Wiggum's FMRI data
    %unitdataW.fmri_rsp=unitdataW.fmri_rsp-100;
    %for dg=1:size(dataW,2), dataW(dg).fmri_rsp=dataW(dg).fmri_rsp-100; end

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
    unitdata.LFP_cat_avg_epoch_tr=[unitdataS.LFP_cat_avg_epoch_tr;unitdataW.LFP_cat_avg_epoch_tr];
    unitdata.LFP_cat_avg_rect_epoch=[unitdataS.LFP_cat_avg_rect_epoch;unitdataW.LFP_cat_avg_rect_epoch];
    unitdata.LFP_bestlabel=[unitdataS.LFP_bestlabel';unitdataW.LFP_bestlabel'];
    unitdata.LFP_cat_anova_rect=[unitdataS.LFP_cat_anova_rect;unitdataW.LFP_cat_anova_rect];
    unitdata.LFP_evoked_cat_si=[unitdataS.LFP_evoked_cat_si;unitdataW.LFP_evoked_cat_si];
    unitdata.LFP_evokedpure_cat_si=[unitdataS.LFP_evoked_cat_si;unitdataW.LFP_evoked_cat_si];
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
    save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_BothMonks_Both.mat'],'data','unit_index','unitdata','unitdataS','unitdataW','unit_indexS','unit_indexW');
else
    load([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataNT_BothMonks_Both.mat']);
end


fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colourmaps
%hmiconfig.printer=1;
disp('**************************************************************************')
disp('* plx500_project1pop_LFP.m - Generates figures listed under Project 1 in *')
disp('*     RSVP500_Outline.docx (for local field potential data ONLY).        *')
disp('**************************************************************************')
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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_Both.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_Both.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F1_dist_Both.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% Figure NEW 4 - For Paper
disp('Figure 2  (Category and Raw Selectivity Figure)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
subplot(2,1,1) % proportions
bardata(1,1)=length(find(ismember(unitdata.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_excite_nofruit,'Faces')==1)); % SUA (Faces) Excitatory
bardata(1,2)=length(find(ismember(unitdata.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_excite_nofruit,'BodyParts')==1)); % SUA (Bodyparts) Excitatory
bardata(1,3)=length(find(ismember(unitdata.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_excite_nofruit,'Objects')==1)); % SUA (Objects) Excitatory
bardata(1,4)=length(find(ismember(unitdata.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_excite_nofruit,'Places')==1)); % SUA (Places) Excitatory
bardata(1,5)=length(find(ismember(unitdata.excitetype_nofruit,{'Excite' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Not Selective')==1)); % SUA (Not Selective) Excitatory

bardata(2,1)=length(find(ismember(unitdata.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_inhibit_nofruit,'Faces')==1)); % SUA (Faces) Suppressed
bardata(2,2)=length(find(ismember(unitdata.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_inhibit_nofruit,'BodyParts')==1)); % SUA (Bodyparts) Suppressed
bardata(2,3)=length(find(ismember(unitdata.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_inhibit_nofruit,'Objects')==1)); % SUA (Objects) Suppressed
bardata(2,4)=length(find(ismember(unitdata.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Selective')==1 & strcmp(unitdata.prefcat_inhibit_nofruit,'Places')==1)); % SUA (Places) Suppressed
bardata(2,5)=length(find(ismember(unitdata.excitetype_nofruit,{'Inhibit' 'Both'})==1 & strcmp(unitdata.selective_nofruit,'Not Selective')==1)); % SUA (Not Selective) Suppressed

bardata(3,1)=length(find(strcmp(sitedata.bestlabel,'Faces')==1 & sitedata.cat_anova<0.05));
bardata(3,2)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1 & sitedata.cat_anova<0.05));
bardata(3,3)=length(find(strcmp(sitedata.bestlabel,'Objects')==1 & sitedata.cat_anova<0.05));
bardata(3,4)=length(find(strcmp(sitedata.bestlabel,'Places')==1 & sitedata.cat_anova<0.05));
bardata(3,5)=length(find(sitedata.cat_anova>=0.05));

bardata(4,1)=length(find(strcmp(sitedata.bestlabel_rect,'Faces')==1 & sitedata.cat_anova_rect<0.05));
bardata(4,2)=length(find(strcmp(sitedata.bestlabel_rect,'Bodyparts')==1 & sitedata.cat_anova_rect<0.05));
bardata(4,3)=length(find(strcmp(sitedata.bestlabel_rect,'Objects')==1 & sitedata.cat_anova_rect<0.05));
bardata(4,4)=length(find(strcmp(sitedata.bestlabel_rect,'Places')==1 & sitedata.cat_anova_rect<0.05));
bardata(4,5)=length(find(sitedata.cat_anova_rect>0.05));

for freq=1:6,
    bardata(freq+4,1)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Faces')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+4,2)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Bodyparts')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+4,3)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Objects')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+4,4)=length(find(strcmp(sitedata.freq_bestlabel(:,freq),'Places')==1 & sitedata.freq_across_anova(:,freq)<0.05));
    bardata(freq+4,5)=length(find(sitedata.freq_across_anova(:,freq)>=0.05));
end

for bb=1:10,
    bardata(bb,6)=bardata(bb,1)/sum(bardata(bb,1:5));
    bardata(bb,7)=bardata(bb,2)/sum(bardata(bb,1:5));
    bardata(bb,8)=bardata(bb,3)/sum(bardata(bb,1:5));
    bardata(bb,9)=bardata(bb,4)/sum(bardata(bb,1:5));
    bardata(bb,10)=bardata(bb,5)/sum(bardata(bb,1:5));
end


bar(1:10,bardata(1:10,[6 7 8 9 10]),'stack');
for col=1:8, text(col,200,[num2str(bardataC(col,3),'%1.2g'),'%'],'FontSize',fontsize_sml); end
ylabel({'Category Preferences','(Category-Selective Sites)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:10,'XTickLabel',{'SUA(E)','SUA(S)','Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz'})
title('Preferred Category across Category-Selective Sites','FontSize',fontsize_lrg)

subplot(2,1,2); bardata=[]; % SI
pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
pointer2=find(ismember(unit_index.excitetype_nofruit,{'Excite' 'Both'})==1);
pointer3=find(strcmp(unit_index.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointer=intersect(pointerT1,pointer3);
output=unitdata.excite_rawsi_nofruit(pointer);
[bardata(1,1),bardata(1,2)]=mean_sem(output);
pointer1=find(strcmp(unit_index.SensoryConf,'Sensory')==1);
pointer2=find(ismember(unit_index.excitetype_nofruit,{'Inhibit' 'Both'})==1);
pointer3=find(strcmp(unit_index.selective_nofruit,'Selective')==1);
pointerT1=intersect(pointer1,pointer2); pointerT2=intersect(pointerT1,pointer3);
output=unitdata.inhibit_rawsi_nofruit(pointer);
[bardata(2,1),bardata(2,2)]=mean_sem(output);
pointer=find(sitedata.cat_anova<0.05);
[bardata(3,1),bardata(3,2)]=mean_sem(sitedata.evoked_rawsi(pointer));
[bardata(4,1),bardata(4,2)]=mean_sem(sitedata.rect_rawsi(pointer));
for freq=1:6,
    [bardata(freq+4,1),bardata(freq+2,2)]=mean_sem(sitedata.freq_rawsi(pointer,freq));
end
[bardata(11,1),bardata(11,2)]=mean_sem(unique(unitdata.fmri_excite_rawsi));
[bardata(12,1),bardata(12,2)]=mean_sem(unique(unitdata.fmri_inhibit_rawsi));

hold on
bar(1:12,bardata(1:12,1)); errorbar(1:12,bardata(1:12,1),bardata(1:12,2))
ylabel({'Category Selectivity','(Category-Selective Sites)'},'FontSize',fontsize_med)
set(gca,'FontSize',fontsize_med,'XTick',1:12,'XTickLabel',{'SUA(E)','SUA(S)','Evoked','Rect','0-120Hz','0-20Hz','20-45Hz','45-70Hz','70-95Hz','95-120Hz','fMRI(E)','fMRI(S)'})
title('CategorySelectivity Index (for preferred category) Category across Category-Selective Sites','FontSize',fontsize_lrg)


jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F4_SumBoth.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1_F4_SumBoth.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)









% Figure 2  (Category and Raw Selectivity Figure)
disp('Figure 2  (Category and Raw Selectivity Figure)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
subplot(3,2,1); bardata=[]; % Maximum Category Selectivity (of all sites)
tempdata=sitedata.evoked_cat_si(find(sitedata.cat_anova_rect<0.05),:);
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
bardata(1,2)=length(find(strcmp(sitedata.bestlabel,'Faces')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,1)<0.05));
bardata(2,2)=length(find(strcmp(sitedata.bestlabel,'Bodyparts')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,2)<0.05));
bardata(3,2)=length(find(strcmp(sitedata.bestlabel,'Objects')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,3)<0.05));
bardata(4,2)=length(find(strcmp(sitedata.bestlabel,'Places')==1 & sitedata.cat_anova_rect<0.05 & sitedata.anova_stim(:,4)<0.05));
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
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_si_Both.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_si_Both.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F2_si_Both.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)








% Figure 3  (Correlation between SUA, LFP, and FMRI - PREFERRED RESPONSES ONLY)
patchdataS=prep_patchdata(unitdataS,unit_indexS,grpS);
patchdataW=prep_patchdata(unitdataW,unit_indexW,grpW);
patchdata=[];
patchdata.sua_rsp_avg=[patchdataS.sua_rsp_avg;patchdataW.sua_rsp_avg];
patchdata.sua_rsp_avg_norm=[patchdataS.sua_rsp_avg_norm;patchdataW.sua_rsp_avg_norm];
patchdata.sua_catsi_avg=[patchdataS.sua_catsi_avg;patchdataW.sua_catsi_avg];
% evoked
patchdata.lfp_evoked_rsp_avg=[patchdataS.LFP_evoked_avg;patchdataW.LFP_evoked_avg];
patchdata.lfp_evoked_catsi_avg=[patchdataS.LFP_evoked_catsi_avg;patchdataW.LFP_evoked_catsi_avg];
% rectified
lfp_metric=1;
patchdata.lfpRect_rsp_avg=[squeeze(patchdataS.lfp_rsp_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg(:,:,lfp_metric))];
patchdata.lfpRect_rsp_avg_norm=[squeeze(patchdataS.lfp_rsp_avg_norm(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg_norm(:,:,lfp_metric))];
patchdata.lfpRect_catsi_avg=[squeeze(patchdataS.lfp_catsi_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_catsi_avg(:,:,lfp_metric))];
% freq 0-120hz
lfp_metric=2;
patchdata.lfp120Hz_rsp_avg=[squeeze(patchdataS.lfp_rsp_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg(:,:,lfp_metric))];
patchdata.lfp120Hz_rsp_avg_norm=[squeeze(patchdataS.lfp_rsp_avg_norm(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg_norm(:,:,lfp_metric))];
patchdata.lfp120Hz_catsi_avg=[squeeze(patchdataS.lfp_catsi_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_catsi_avg(:,:,lfp_metric))];
% freq 0-20hz
lfp_metric=3;
patchdata.lfp20Hz_rsp_avg=[squeeze(patchdataS.lfp_rsp_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg(:,:,lfp_metric))];
patchdata.lfp20Hz_rsp_avg_norm=[squeeze(patchdataS.lfp_rsp_avg_norm(:,:,lfp_metric));squeeze(patchdataW.lfp_rsp_avg_norm(:,:,lfp_metric))];
patchdata.lfp20Hz_catsi_avg=[squeeze(patchdataS.lfp_catsi_avg(:,:,lfp_metric));squeeze(patchdataW.lfp_catsi_avg(:,:,lfp_metric))];
patchdata.fmri_rsp_avg=[patchdataS.fmri_rsp_avg;patchdataW.fmri_rsp_avg];
patchdata.fmri_rsp_avg_norm=[patchdataS.fmri_rsp_avg_norm;patchdataW.fmri_rsp_avg_norm];
patchdata.fmri_catsi_avg=[patchdataS.fmri_catsi_avg;patchdataW.fmri_catsi_avg];

disp('Figure 3  (Correlation between SUA, LFP, and FMRI)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
%%% SUA INDEX
subplot(6,6,7); hold on % SUA vs LFPevoked
[crap,maxindex]=max(patchdata.sua_rsp_avg');
xdata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'SUA rsp vs. LFP (Evoked) rsp','(SUA index)'},'FontWeight','Bold')
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
subplot(6,6,13); hold on % SUA vs LFPrect
ydata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'SUA rsp vs. LFP (Rect) rsp','(SUA index)'},'FontWeight','Bold')
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
subplot(6,6,19); hold on % SUA vs LFP120hz
ydata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'SUA rsp vs. LFP (120Hz) rsp','(SUA index)'},'FontWeight','Bold')
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
subplot(6,6,25); hold on % SUA vs LFP20hz
ydata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(15,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'SUA rsp vs. LFP (20Hz) rsp','(SUA index)'},'FontWeight','Bold')
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
subplot(6,6,31); hold on % SUA vs FMRI
ydata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(15,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'SUA rsp vs. FMRI rsp','(SUA index)'},'FontWeight','Bold')
xlabel('Firing Rate (sp/s)'); ylabel('% Signal Change');

%%% LFP EVOKED INDEX
subplot(6,6,2); hold on % LFPevoked vs SUA
[crap,maxindex]=max(patchdata.lfp_evoked_rsp_avg');
xdata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,15,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Evoked) rsp vs. SUA rsp','(LFP (Evoked) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Firing Rate (sp/s)');
subplot(6,6,14); hold on % LFPevoked vs LFPrect
ydata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Evoked) rsp vs. LFP (Rect) rsp','(LFP (Evoked) index)'},'FontWeight','Bold')
xlabel('Voltage (V)');  ylabel('Rectified Voltage (V)');
subplot(6,6,20); hold on % LFPevoked vs LFP120hz
ydata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Evoked) rsp vs. LFP (120Hz) rsp','(LFP (Evoked) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Power');
subplot(6,6,26); hold on % LFPevoked vs LFP20hz
ydata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Evoked) rsp vs. LFP (20Hz) rsp','(LFP (Evoked) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Power');
subplot(6,6,32); hold on % LFPevoked vs FMRI
ydata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Evoked) rsp vs. fMRI rsp','(LFP (Evoked) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('% Signal Change');

%%% LFP RECT INDEX
subplot(6,6,3); hold on % LFPrect vs SUA
[crap,maxindex]=max(patchdata.lfpRect_rsp_avg');
xdata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,15,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Rect) rsp vs. SUA rsp','(LFP (Rect) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Firing Rate (sp/s)');
subplot(6,6,9); hold on % LFPrect vs LFPevoked
ydata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Rect) rsp vs. LFP (Evoked) rsp','(LFP (Rect) index)'},'FontWeight','Bold')
xlabel('Rectified Voltage (V)');  ylabel('Voltage (V)');
subplot(6,6,21); hold on % LFPrect vs LFP120hz
ydata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Rect) rsp vs. LFP (120Hz) rsp','(LFP (Rect) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Power');
subplot(6,6,27); hold on % LFPrect vs LFP20hz
ydata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Rect) rsp vs. LFP (20Hz) rsp','(LFP (Rect) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('Power');
subplot(6,6,33); hold on % LFPrect vs FMRI
ydata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (Rect) rsp vs. fMRI rsp','(LFP (Rect) index)'},'FontWeight','Bold')
xlabel('Voltage (V)'); ylabel('% Signal Change');

%%% LFP 120Hz INDEX
subplot(6,6,4); hold on % LFP120hz vs SUA
[crap,maxindex]=max(patchdata.lfp120Hz_rsp_avg');
xdata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,15,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (120Hz) rsp vs. SUA rsp','(LFP (120Hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Firing Rate (sp/s)');
subplot(6,6,10); hold on % LFP120hz vs LFPevoked
ydata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (120Hz) rsp vs. LFP (Evoked) rsp','(LFP (120Hz) index)'},'FontWeight','Bold')
xlabel('Power');  ylabel('Voltage (V)');
subplot(6,6,16); hold on % LFP120hz vs LFPrect
ydata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (120Hz) rsp vs. LFP (Rect) rsp','(LFP (120Hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Rectified Voltage (V)');
subplot(6,6,28); hold on % LFP120hz vs LFP20hz
ydata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (120Hz) rsp vs. LFP (20Hz) rsp','(LFP (120Hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Power');
subplot(6,6,34); hold on % LFP120hz vs FMRI
ydata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (120Hz) rsp vs. fMRI rsp','(LFP (120Hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('% Signal Change');

%%% LFP 20Hz INDEX
subplot(6,6,5); hold on % LFP20hz vs SUA
[crap,maxindex]=max(patchdata.lfp20Hz_rsp_avg');
xdata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,15,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (20hz) rsp vs. SUA rsp','(LFP (20hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Firing Rate (sp/s)');
subplot(6,6,11); hold on % LFP20hz vs LFPevoked
ydata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (20hz) rsp vs. LFP (Evoked) rsp','(LFP (20hz) index)'},'FontWeight','Bold')
xlabel('Power');  ylabel('Voltage (V)');
subplot(6,6,17); hold on % LFP20hz vs LFPrect
ydata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (20hz) rsp vs. LFP (Rect) rsp','(LFP (20hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Rectified Voltage (V)');
subplot(6,6,23); hold on % LFP20hz vs LFP120hz
ydata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (20hz) rsp vs. LFP 120Hz) rsp','(LFP (20hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('Power');
subplot(6,6,35); hold on % LFP20hz vs FMRI
ydata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'LFP (20hz) rsp vs. FMRI rsp','(LFP (20hz) index)'},'FontWeight','Bold')
xlabel('Power'); ylabel('% Signal Change');

%%% FMRI INDEX
subplot(6,6,6); hold on % FMRI vs SUA
[crap,maxindex]=max(patchdata.fmri_rsp_avg');
xdata=extract_rsp(patchdata.fmri_rsp_avg,maxindex);
ydata=extract_rsp(patchdata.sua_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,15,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI rsp vs. SUA rsp','(fMRI index)'},'FontWeight','Bold')
xlabel('% Signal Change'); ylabel('Firing Rate (sp/s)');
subplot(6,6,12); hold on % FMRI vs LFPevoked
ydata=extract_rsp(patchdata.lfp_evoked_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI rsp vs. LFP (Evoked) rsp','(fMRI index)'},'FontWeight','Bold')
xlabel('% Signal Change');  ylabel('Voltage (V)');
subplot(6,6,18); hold on % FMRI vs LFPrect
ydata=extract_rsp(patchdata.lfpRect_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI rsp vs. LFP (Rect) rsp','(fMRI index)'},'FontWeight','Bold')
xlabel('% Signal Change'); ylabel('Voltage (V)');
subplot(6,6,24); hold on % FMRI vs LFP120HZ
ydata=extract_rsp(patchdata.lfp120Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI rsp vs. LFP (120Hz) rsp','(fMRI index)'},'FontWeight','Bold')
xlabel('% Signal Change'); ylabel('Power');
subplot(6,6,30); hold on % FMRI vs LFP20Hz
ydata=extract_rsp(patchdata.lfp20Hz_rsp_avg,maxindex);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k'); pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]); plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
[r,p]=corr(xdata',ydata'); axis square; set(gca,'FontSize',7)
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
title({'fMRI rsp vs. LFP (20Hz) rsp','(fMRI index)'},'FontWeight','Bold')
xlabel('% Signal Change'); ylabel('Power');
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_compare_Both.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_compare_Both.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F3_compare_Both.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

% Figure 4  (Correlation between SUA, LFP, and FMRI - ALL RESPONSES)
disp('Figure 4  (Correlation between SUA, LFP, and FMRI)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
subplot(5,5,1); hold on % SUA vs LFPevoked
xdata=reshape(patchdata.sua_rsp_avg,1,36);
ydata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
title({'SUA rsp vs. LFP (Evoked) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,6); hold on % SUA vs LFPrect
xdata=reshape(patchdata.sua_rsp_avg,1,36);
ydata=reshape(patchdata.lfpRect_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Firing Rate (sp/s)'); ylabel('Rectified Voltage (V)');
title({'SUA rsp vs. LFP (Rect) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,11); hold on % SUA vs LFP120hz
xdata=reshape(patchdata.sua_rsp_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Firing Rate (sp/s)'); ylabel('Power');
title({'SUA rsp vs. LFP (120Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,16); hold on % SUA vs LFP20hz
xdata=reshape(patchdata.sua_rsp_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(15,4,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Firing Rate (sp/s)'); ylabel('Power');
title({'SUA rsp vs. LFP (20Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,21); hold on % SUA vs FMRI
xdata=reshape(patchdata.sua_rsp_avg,1,36);
ydata=reshape(patchdata.fmri_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(15,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Firing Rate (sp/s)'); ylabel('% Signal Change');
title({'SUA rsp vs. FMRI rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,7); hold on % LFPevoked vs LFPrect
xdata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
ydata=reshape(patchdata.lfpRect_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Voltage (V)'); ylabel('Rectified Voltage (V)');
title({'LFP (Evoked) rsp vs. LFP (Rect) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,12); hold on % LFPevoked vs LFP120hz
xdata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Voltage (V)'); ylabel('Power');
title({'LFP (Evoked) rsp vs. LFP (120Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,17); hold on % LFPevoked vs LFP20hz
xdata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Voltage (V)'); ylabel('Power');
title({'LFP (Evoked) rsp vs. LFP (20Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,22); hold on % LFPevoked vs FMRI
xdata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
ydata=reshape(patchdata.fmri_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Voltage (V)'); ylabel('% Signal Change');
title({'LFP (Evoked) rsp vs. FMRI rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,13); hold on % LFPrect vs LFP120hz
xdata=reshape(patchdata.lfp_evoked_rsp_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Rectified Voltage (V)'); ylabel('Power');
title({'LFP (Rect) rsp vs. LFP (120Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,18); hold on % LFPrect vs LFP20hz
xdata=reshape(patchdata.lfpRect_rsp_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Rectified Voltage (V)'); ylabel('Power');
title({'LFP (Rect) rsp vs. LFP (20Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,23); hold on % LFPrect vs FMRI
xdata=reshape(patchdata.lfpRect_rsp_avg,1,36);
ydata=reshape(patchdata.fmri_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Rectified Voltage (V)'); ylabel('% Signal Change');
title({'LFP (Rect) rsp vs. FMRI rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,19); hold on % LFP120hz vs LFP20hz
xdata=reshape(patchdata.lfp120Hz_rsp_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,3,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Power'); ylabel('Power');
title({'LFP (120Hz) rsp vs. LFP (20Hz) rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,24); hold on % LFP120hz vs FMRI
xdata=reshape(patchdata.lfp120Hz_rsp_avg,1,36);
ydata=reshape(patchdata.fmri_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Power'); ylabel('% Signal Change');
title({'LFP (120Hz) rsp vs. FMRI rsp','(All Responses)'},'FontWeight','Bold')
subplot(5,5,25); hold on % LFP0hz vs FMRI
xdata=reshape(patchdata.lfp20Hz_rsp_avg,1,36);
ydata=reshape(patchdata.fmri_rsp_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(3,0.96,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('Power'); ylabel('% Signal Change');
title({'LFP (20Hz) rsp vs. FMRI rsp','(All Responses)'},'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_compare_Both.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_compare_Both.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F4_compare_Both.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% Figure 5  (Correlation between SUA, LFP, and FMRI SI - ALL RESPONSES)
disp('Figure 5  (Correlation between SUA, LFP, and FMRI)')
figure; clf; cla; 
set(gcf,'Units','Normalized','Position',[0.05 0.25 0.5 0.7]); set(gca,'FontName','Arial','FontSize',8);
subplot(5,5,1); hold on % SUA vs LFPevoked
xdata=reshape(patchdata.sua_catsi_avg,1,36);
ydata=reshape(patchdata.lfp_evoked_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'SUA catsi vs. LFP (Evoked) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,6); hold on % SUA vs LFPrect
xdata=reshape(patchdata.sua_catsi_avg,1,36);
ydata=reshape(patchdata.lfpRect_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'SUA catsi vs. LFP (Rect) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,11); hold on % SUA vs LFP120hz
xdata=reshape(patchdata.sua_catsi_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'SUA catsi vs. LFP (120Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,16); hold on % SUA vs LFP20hz
xdata=reshape(patchdata.sua_catsi_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'SUA catsi vs. LFP (20Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,21); hold on % SUA vs FMRI
xdata=reshape(patchdata.sua_catsi_avg,1,36);
ydata=reshape(patchdata.fmri_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'SUA catsi vs. FMRI catsi','(All Responses)'},'FontWeight','Bold')

subplot(5,5,7); hold on % LFPevoked vs LFPrect
xdata=reshape(patchdata.lfp_evoked_catsi_avg,1,36);
ydata=reshape(patchdata.lfpRect_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Evoked) catsi vs. LFP (Rect) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,12); hold on % LFPevoked vs LFP120hz
xdata=reshape(patchdata.lfp_evoked_catsi_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Evoked) catsi vs. LFP (120Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,17); hold on % LFPevoked vs LFP20hz
xdata=reshape(patchdata.lfp_evoked_catsi_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Evoked) catsi vs. LFP (20Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,22); hold on % LFPevoked vs FMRI
xdata=reshape(patchdata.lfp_evoked_catsi_avg,1,36);
ydata=reshape(patchdata.fmri_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Evoked) catsi vs. FMRI catsi','(All Responses)'},'FontWeight','Bold')

subplot(5,5,13); hold on % LFPrect vs LFP120hz
xdata=reshape(patchdata.lfpRect_catsi_avg,1,36);
ydata=reshape(patchdata.lfp120Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Rect) catsi vs. LFP (120Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,18); hold on % LFPrect vs LFP20hz
xdata=reshape(patchdata.lfpRect_catsi_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Rect) catsi vs. LFP (20Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,23); hold on % LFPrect vs FMRI
xdata=reshape(patchdata.lfpRect_catsi_avg,1,36);
ydata=reshape(patchdata.fmri_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (Rect) catsi vs. FMRI catsi','(All Responses)'},'FontWeight','Bold')

subplot(5,5,19); hold on % LFP120hz vs LFP20hz
xdata=reshape(patchdata.lfp120Hz_catsi_avg,1,36);
ydata=reshape(patchdata.lfp20Hz_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (120Hz) catsi vs. LFP (20Hz) catsi','(All Responses)'},'FontWeight','Bold')
subplot(5,5,24); hold on % LFP120hz vs FMRI
xdata=reshape(patchdata.lfp120Hz_catsi_avg,1,36);
ydata=reshape(patchdata.fmri_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (120Hz) catsi vs. FMRI catsi','(All Responses)'},'FontWeight','Bold')

subplot(5,5,25); hold on % LFP0hz vs FMRI
xdata=reshape(patchdata.lfp20Hz_catsi_avg,1,36);
ydata=reshape(patchdata.fmri_catsi_avg,1,36);
plot(xdata,ydata,'ks','MarkerSize',3,'MarkerFaceColor','k');
pf=polyfit(xdata,ydata,1); ys=polyval(pf,[min(xdata) max(xdata)]);
plot([min(xdata) max(xdata)],ys,'k-','LineWidth',2);
set(gca,'FontSize',7); axis square; [r,p]=corr(xdata',ydata');
text(0.2,0.2,{['r=',num2str(r,'%1.2g')],['p=',num2str(p,'%1.2g')]},'FontSize',8)
xlabel('SI'); ylabel('SI'); xlim([-0.2 0.2]); ylim([-0.2 0.2]);
title({'LFP (20Hz) catsi vs. FMRI catsi','(All Responses)'},'FontWeight','Bold')
jpgfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_compareSI_Both.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_compareSI_Both.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
hgsave([hmiconfig.rootdir,'rsvp500_project1',filesep,'Pr1lfp_F5_compareSI_Both.fig'])
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
return



%%% NESTED FUNCTIONS
function output=prep_patchdata(ud,ui,grps);
numpatches=size(grps,2);
output=struct('sua_rsp_avg',zeros(numpatches,4),'sua_rsp_sem',zeros(numpatches,4),'sua_rsp_avg_norm',zeros(numpatches,4),...
    'sua_catsi_avg',zeros(numpatches,4),'sua_catsi_sem',zeros(numpatches,4),...
    'lfp_rsp_avg',zeros(numpatches,4,7),'lfp_rsp_sem',zeros(numpatches,4,7),'lfp_rsp_avg_norm',zeros(numpatches,4,7),...
    'lfp_catsi_avg',zeros(numpatches,4,7),'lfp_catsi_sem',zeros(numpatches,4,7),...
    'lfp_evoked_avg',zeros(numpatches,4),'lfp_evoked_sem',[],...
    'fmri_rsp_avg',zeros(numpatches,4),'fmri_rsp_sem',zeros(numpatches,4),'fmri_rsp_avg_norm',zeros(numpatches,4),...
    'fmri_catsi_avg',zeros(numpatches,4),'fmri_catsi_sem',zeros(numpatches,4));
for pt=1:numpatches,
    all_pointer=find(ismember(ui.GridLoc,grps(pt).grids)==1);
    %%% Unit Activity - All Category-Selective Sensory Neurons
    unit_pointer=find(strcmp(ui.SensoryConf,'Sensory')==1 & strcmp(ui.SelectiveConf,'Selective')==1);
    pointer=intersect(all_pointer,unit_pointer);
    [output.sua_rsp_avg(pt,:) output.sua_rsp_sem(pt,:)]=mean_sem(ud.cat_avg(pointer,[1 4 5 3]));
    output.sua_rsp_avg_norm(pt,:)=output.sua_rsp_avg(pt,:)/max(output.sua_rsp_avg(pt,:));
    [output.sua_catsi_avg(pt,:) output.sua_catsi_sem(pt,:)]=mean_sem(ud.cat_si(pointer,[1 4 5 3]));

    %%% LFP responses - evoked
    [output.LFP_evoked_avg(pt,:) output.LFP_evoked_sem(pt,:)]=mean_sem(ud.LFP_cat_avg_epoch_tr(pointer,[1 2 3 4]));    
    [output.LFP_evoked_catsi_avg(pt,:) output.LFP_evoked_catsi_sem(pt,:)]=mean_sem(ud.LFP_evoked_cat_si(pointer,[1 2 3 4]));    
    
    %%% LFP responses - rectified (all unique selective sites)
    [output.lfp_rsp_avg(pt,:,1) output.lfp_rsp_sem(pt,:,1)]=mean_sem(unique(ud.LFP_cat_avg_rect_epoch(pointer,:),'rows'));
    output.lfp_rsp_avg_norm(pt,:,1)=output.lfp_rsp_avg(pt,:,1)/max(output.lfp_rsp_avg(pt,:,1));
    [output.lfp_catsi_avg(pt,:,1) output.lfp_catsi_sem(pt,:,1)]=mean_sem(unique(ud.LFP_evoked_cat_si(pointer,:),'rows'));
    % frequency based
    for fq=1:6,
        [output.lfp_rsp_avg(pt,:,fq+1) output.lfp_rsp_sem(pt,:,fq+1)]=mean_sem(unique(ud.LFP_freq_epoch_cat(pointer,1+(fq-1)*4:4+(fq-1)*4),'rows'));
        [output.lfp_catsi_avg(pt,:,fq+1) output.lfp_catsi_sem(pt,:,fq+1)]=mean_sem(unique(ud.LFP_freq_cat_si(pointer,1+(fq-1)*4:4+(fq-1)*4),'rows'));
    end % need to confirm that the fields are mapped correctly

    %%% FMRI responses - all sites (all unique units)
    [output.fmri_rsp_avg(pt,:) output.fmri_rsp_sem(pt,:)]=mean_sem(unique(ud.fmri_rsp(all_pointer,[1 4 3 2]),'rows'));
    output.fmri_rsp_avg_norm(pt,:)=output.fmri_rsp_avg(pt,:)/max(output.fmri_rsp_avg(pt,:));
    [output.fmri_catsi_avg(pt,:) output.fmri_catsi_sem(pt,:)]=mean_sem(unique(ud.fmri_catsi(all_pointer,[1 4 3 2]),'rows')); 
end
return

function output=extract_rsp(data,index)
output=zeros(1,size(data,1));
for rw=1:size(data,1)
    output(rw)=data(rw,index(rw));
end
return