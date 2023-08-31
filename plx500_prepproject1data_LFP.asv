function [sitedata,griddata]=plx500_prepproject1data_LFP(monkinitial);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_prepproject1data_LFP %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, May2009,
% based on plx500_project1 - adapted to analyze LFP responses (population).
% Does not compare LFPs to anything else... yet
% MONKINITIAL (required) = 'W' or 'S'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify a monkey (''S''/''W'')'); end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP_LFP_S';
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP_LFP_W';
end

disp('*********************************************************************')
disp('* plx500_prepproject1data_LFP.m - Prepares matrices for local field *')
disp('*     potential data.                                               *')
disp('*********************************************************************')
disp('Loading list of LFP sites from EXCEL...')
sitedata=struct('filenames',[],'channames',[],'gridloc',[]);
[crap,filenames]=xlsread(hmiconfig.excelfile,sheetname,'B4:B1000'); % filename, string
[crap,channames]=xlsread(hmiconfig.excelfile,sheetname,'C4:C1000'); % channel name, string
include=xlsread(hmiconfig.excelfile,sheetname,'I4:I1000'); % include, numeric
[crap,gridloc]=xlsread(hmiconfig.excelfile,sheetname,'E4:E1000'); % grid location
pointer_include=find(include>0);
sitedata.filenames=filenames(pointer_include);
sitedata.channames=channames(pointer_include);
sitedata.gridloc=gridloc(pointer_include);
numsites=length(pointer_include);
disp(['Found ',num2str(length(include)),' sites...'])
disp(['Keeping ',num2str(numsites),' sites.'])
clear include crap gridloc filenames channames pointer_include

%%% LOAD UNITNAME INFORMATION (for adding neuron data)
unitnames=[];
unitdir=dir(hmiconfig.rsvp500spks);
for un=3:size(unitdir,1),
    unitnames{un-2}=unitdir(un).name;
end; unitnames=unitnames';
resp_names=[]; resp_fullnames=[];
for ff=1:size(unitnames),
    tempname=char(unitnames(ff));
    if length(tempname)>27,
        if tempname(25:28)=='resp',
            resp_names=[resp_names;{tempname(1:19)}];
            resp_fullnames=[resp_fullnames;{tempname}];
        end
    end
end

%%% COMPILE INDIVIDUAL FILE INFO %%%
disp('Compiling individual site info...')
for ss=1:numsites,
    lfp_name=[sitedata.filenames{ss},'-',sitedata.channames{ss}];
    disp(['..Loading data from ',char(lfp_name)]);
    sitedata.complete_filename{ss}=lfp_name;
    load([hmiconfig.rsvp500lfps,sitedata.filenames{ss},'-500-',sitedata.channames{ss},'.mat']);
    %%% Append fields...
    % data epochs
    sitedata.cat_avg_epoch(ss,1:4)=lfpstructsingle_trim.cat_avg_epoch;
    sitedata.lfp_average_epoch_rect(ss,1:100)=lfpstructsingle_trim.lfp_average_epoch_rect;
    sitedata.cat_avg_rect_epoch(ss,1:4)=lfpstructsingle_trim.cat_avg_rect_epoch;
    sitedata.cat_avg_rect_epoch_tr(ss,1:4)=lfpstructsingle_trim.cat_avg_rect_epoch_tr;
    sitedata.evoked_cat_si(ss,1:4)=lfpstructsingle_trim.evoked_cat_si;
    sitedata.rect_cat_si(ss,1:4)=lfpstructsingle_trim.rect_cat_si;
    sitedata.cond_min_max(ss,1:100,1:2)=lfpstructsingle_trim.cond_min_max;
    sitedata.cat_min_max(ss,1:4,1:2)=lfpstructsingle_trim.cat_min_max;
    sitedata.freq_epoch_cat(ss,1:4,1:6)=lfpstructsingle_trim.freq_epoch_cat;
    sitedata.freq_cat_si(ss,1:4,1:6)=lfpstructsingle_trim.freq_cat_si;
    sitedata.evoked_rawsi(ss)=lfpstructsingle_trim.evoked_rawsi;
    sitedata.rect_rawsi(ss)=lfpstructsingle_trim.rect_rawsi;
    sitedata.freq_rawsi(ss,1:6)=lfpstructsingle_trim.freq_rawsi;
    % statistics
    sitedata.anova_stim(ss,1:4)=lfpstructsingle_trim.anova_stim;
    sitedata.cat_anova(ss)=lfpstructsingle_trim.cat_anova;
    sitedata.cat_anova_rect(ss)=lfpstructsingle_trim.cat_anova_rect;
    sitedata.freq_across_anova(ss,1:6)=lfpstructsingle_trim.freq_across_anova;
    sitedata.freq_within_anova(ss,1:4,1:6)=lfpstructsingle_trim.freq_within_anova;
    
%     tmproc=reshape(lfpstructsingle_trim.roc_evoked',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_evoked(ss,:)=tmproc;
%     tmproc=reshape(lfpstructsingle_trim.roc_rect',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_rect(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(1,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq1(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(2,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq2(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(3,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq3(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(4,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq4(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(5,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq5(ss,:)=tmproc;
%     tmproc=reshape(squeeze(lfpstructsingle_trim.roc_freq(6,:,:))',1,16);
%     for tr=1:16, if tmproc(tr)<0.50, tmproc(tr)=1-tmproc(tr); end; end
%     sitedata.roc_freq6(ss,:)=tmproc;
    
    % descriptors
    sitedata.bestlabel(ss)=lfpstructsingle_trim.bestlabel;
    sitedata.bestlabel_rect(ss)=lfpstructsingle_trim.bestlabel_rect;
    sitedata.freq_bestlabel(ss,1:6)=lfpstructsingle_trim.freq_bestlabel;
    sitedata.specgramMT_time_axis(ss,1:846)=lfpstructsingle_trim.trial_specgramMT_T(1,846);
    sitedata.specgramMT_freq_axis(ss,1:31)=lfpstructsingle_trim.trial_specgramMT_F(1,31);
    
    %%% Add FMRI data (if possible)
    % Load Corresponding FMRI Data (if possible)
    try
        lfp_tempname=char(sitedata.complete_filename(ss)); chan_num=lfp_tempname(end);
        fakeUNITname=[lfp_tempname(1:12),'-sig00',chan_num];
        unit_found=find(strcmp(resp_names,fakeUNITname)==1);
        if isempty(unit_found)~=1,
            load([hmiconfig.rsvp500spks,char(resp_fullnames(unit_found(1)))]);
            sitedata.AFNIcoords(ss,1:3)=respstructsingle.AFNIcoords;
            sitedata.FMRIdat_coords(ss,1:3)=respstructsingle.FMRIdat_coords;
            if monkinitial=='W'
                sitedata.FMRI_AFNItimeseries(ss,1:132)=respstructsingle.AFNItimeseries';
            else
                sitedata.FMRI_AFNItimeseries(ss,1:176)=respstructsingle.AFNItimeseries';
            end
            sitedata.FMRI_fmri_rsp(ss,1:4)=respstructsingle.fmri_rsp;
            sitedata.FMRI_fmri_catsi(ss,1:4)=respstructsingle.fmri_catsi;
            sitedata.FMRI_fmri_excite_rawsi(ss)=respstructsingle.fmri_excite_rawsi;
            sitedata.FMRI_fmri_inhibit_rawsi(ss)=respstructsingle.fmri_inhibit_rawsi;
        end
    catch
        disp('Problem Found!')
        sitedata.AFNIcoords(ss,1:3)=respstructsingle.AFNIcoords;
        sitedata.FMRIdat_coords(ss,1:3)=respstructsingle.FMRIdat_coords;
        if monkinitial=='W'
            sitedata.FMRI_AFNItimeseries(ss,1:132)=zeros(1,132);
        else
            sitedata.FMRI_AFNItimeseries(ss,1:176)=zeros(1,176);
        end
        sitedata.FMRI_fmri_rsp(ss,1:4)=[0 0 0 0];
        sitedata.FMRI_fmri_catsi(ss,1:4)=[0 0 0 0];
        sitedata.FMRI_fmri_excite_rawsi(ss)=0;
        sitedata.FMRI_fmri_inhibit_rawsi(ss)=0;
    end
end
disp('Saving per site data...')
save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_sitedata_',monkeyname,'.mat'],'sitedata');
disp('Done.'); disp(' ');
clear lfpstructsingle_trim ss numsites crap filenames channames include gridloc
    

%%% COMPILE GRID INFO %%%
disp('Compiling individual grid location info...')
grids=unique(sitedata.gridloc);
numgrids=length(grids);
griddata=[];
for gg=1:numgrids,
    disp(['Compiling files from ',char(grids(gg)),'...']);
    griddata(gg).grid_coords=plx_convertgrid2ap(grids(gg)); % convert grid location to A/P coordindates
    griddata(gg).gridloc=grids(gg);
    % Identify sites from current grid location
    gridind=find(strcmp(sitedata.gridloc,grids(gg))==1); % find all neurons for particular grid location
    numunits_grid=length(gridind);
    % Per site measures
    for un=1:numunits_grid,
        %%% Load and append LFP site data
        lfp_name=[sitedata.filenames{gridind(un)},'-',sitedata.channames{gridind(un)}];
        disp(['..Loading data from ',char(lfp_name)]);
        load([hmiconfig.rsvp500lfps,sitedata.filenames{gridind(un)},'-500-',sitedata.channames{gridind(un)},'.mat']);
        % data epochs
        griddata(gg).lfp_average_epoch_rect(un,1:100)=lfpstructsingle_trim.lfp_average_epoch_rect;
        griddata(gg).cat_avg_rect_epoch(un,1:4)=lfpstructsingle_trim.cat_avg_rect_epoch;
        griddata(gg).cat_avg_rect_epoch_tr(un,1:4)=lfpstructsingle_trim.cat_avg_rect_epoch_tr;
        griddata(gg).evoked_cat_si(un,1:4)=lfpstructsingle_trim.evoked_cat_si;
        griddata(gg).cond_min_max(un,1:100,1:2)=lfpstructsingle_trim.cond_min_max;
        griddata(gg).cat_min_max(un,1:4,1:2)=lfpstructsingle_trim.cat_min_max;
        griddata(gg).freq_epoch_cat(un,1:4,1:6)=lfpstructsingle_trim.freq_epoch_cat;
        griddata(gg).freq_cat_si(un,1:4,1:6)=lfpstructsingle_trim.freq_cat_si;
        % statistics
        griddata(gg).anova_stim(un,1:4)=lfpstructsingle_trim.anova_stim;
        griddata(gg).cat_anova(un)=lfpstructsingle_trim.cat_anova;
        griddata(gg).cat_anova_rect(un)=lfpstructsingle_trim.cat_anova_rect;
        griddata(gg).freq_across_anova(un,1:6)=lfpstructsingle_trim.freq_across_anova;
        griddata(gg).freq_within_anova(un,1:4,1:6)=lfpstructsingle_trim.freq_within_anova;
        % descriptors
        griddata(gg).bestlabel(un)=lfpstructsingle_trim.bestlabel;
        griddata(gg).bestlabel_rect(un)=lfpstructsingle_trim.bestlabel_rect;
        griddata(gg).freq_bestlabel(un,1:6)=lfpstructsingle_trim.freq_bestlabel;
        griddata(gg).specgramMT_time_axis(un,1:846)=lfpstructsingle_trim.trial_specgramMT_T(1,846);
        griddata(gg).specgramMT_freq_axis(un,1:31)=lfpstructsingle_trim.trial_specgramMT_F(1,31);
        %%% Load and append FMRI data
        try
            lfp_tempname=char(sitedata.complete_filename(un)); chan_num=lfp_tempname(end);
            fakeUNITname=[lfp_tempname(1:12),'-sig00',chan_num];
            unit_found=find(strcmp(resp_names,fakeUNITname)==1);
            if isempty(unit_found)~=1,
                load([hmiconfig.rsvp500spks,char(resp_fullnames(unit_found(1)))]);
                griddata(gg).AFNIcoords(un,1:3)=respstructsingle.AFNIcoords;
                griddata(gg).FMRIdat_coords(un,1:3)=respstructsingle.FMRIdat_coords;
                if monkinitial=='W'
                    griddata(gg).FMRI_AFNItimeseries(un,1:132)=respstructsingle.AFNItimeseries';
                else
                    griddata(gg).FMRI_AFNItimeseries(un,1:176)=respstructsingle.AFNItimeseries';
                end
                griddata(gg).FMRI_fmri_rsp(un,1:4)=respstructsingle.fmri_rsp;
                griddata(gg).FMRI_fmri_catsi(un,1:4)=respstructsingle.fmri_catsi;
                griddata(gg).FMRI_fmri_excite_rawsi(un)=respstructsingle.fmri_excite_rawsi;
                griddata(gg).FMRI_fmri_inhibit_rawsi(un)=respstructsingle.fmri_inhibit_rawsi;
            end
        catch
            disp('Problem found!')
        end
    end
end
disp('Saving per grid data...')
save([hmiconfig.rootdir,'rsvp500_project1',filesep,'Project1DataLFP_griddata_',monkeyname,'.mat'],'griddata');
disp('Done.'); disp(' ');
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



