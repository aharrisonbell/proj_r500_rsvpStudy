function plx500_append(monkinitial);
%%%%%%%%%%%%%%%%%
% plx500_append %
%%%%%%%%%%%%%%%%%
% written by AHB, Feb2009,
% Program to reclassify preferred categories for inhibited and "both"
% neurons.  Creates two new fields in respstructsingle: .pref_excite and
% .pref_inhibit.  For neurons that don't have both, the default answer is
% "none".
% This program loads the unitnames from the excel spreadsheet.
% MONKINITIAL (required) = 'W' or 'S'

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify a monkey (''S''/''W'')'); elseif nargin==1, option=[1]; end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
    disp('Loading fMRI data...')
    fmridata=BrikLoad([hmiconfig.rsvpfmri,'Stewie_Norm_AllCondsMION+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rsvpfmri,'Stewie_fMRIstruct_SC.mat'],'fmridata');
    blocksnum=11;
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
    disp('Loading fMRI data...')
    fmridata=BrikLoad([hmiconfig.rsvpfmri,'Wiggum_Norm_AllConds+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rsvpfmri,'Wiggum_fMRIstruct_SC.mat'],'fmridata');    
    blocksnum=11;
end

disp('****************************************************************')
disp('* plx500_append.m - Adds additional fields to RESPSTRUCTSINGLE *')
disp('****************************************************************')
disp('Loading XL information...')
[crap,xldata.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B5:B800'); % alpha, PlexonFilename
[crap,xldata.UnitName]=xlsread(hmiconfig.excelfile,sheetname,'C5:C800'); % alpha, Unitname
catnames={'Faces','Fruit','Places','BodyParts','Objects'};
disp('Starting appending files...')
for un=1:size(xldata.PlxFile,1),
    % Load individual file
    newname=char(xldata.PlxFile(un)); newunit=char(xldata.UnitName(un));
    disp(['...',newname(1:12),'-',newunit,'...'])
    load([hmiconfig.rsvp500spks,filesep,newname(1:12),'-',newunit,'-500responsedata.mat']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                  APPEND ADDITIONAL CATEGORIES                   %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Preferred categories for both excitatory and inhibited responses
    if strcmp(respstructsingle.conf_excite,'Excite')==1
        [m1,m2]=max(respstructsingle.cat_avg(:,2));
        respstructsingle.pref_excite=char(catnames(m2));
        respstructsingle.pref_inhibit='None';
        if strcmp(respstructsingle.pref_excite,respstructsingle.conf_preferred_cat)~=1,
            disp('.....Preferred excitatory responses don''t match for this unit!')
        end
    elseif strcmp(respstructsingle.conf_excite,'Inhibit')==1,
        [m1,m2]=min(respstructsingle.cat_avg(:,2));
        respstructsingle.pref_excite='None';
        respstructsingle.pref_inhibit=char(catnames(m2));
    elseif strcmp(respstructsingle.conf_excite,'Both')==1,
        [m1,m2]=max(respstructsingle.cat_avg(:,2));
        respstructsingle.pref_excite=char(catnames(m2));
        [m1,m2]=min(respstructsingle.cat_avg(:,2));
        respstructsingle.pref_inhibit=char(catnames(m2));
    elseif strcmp(respstructsingle.conf_excite,'Non-Responsive')==1,
        respstructsingle.pref_excite='None';
        respstructsingle.pref_inhibit='None';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Raw SI for both excitatory and inhibited responses
    rsp=respstructsingle.cat_avg(:,2)';
    cols=1:5;
    % excite_rawsi
    [val ind]=max(rsp);
    othercols=find(cols~=ind);
    non_ind=mean(rsp(othercols));
    maincol=rsp(ind);
    respstructsingle.excite_rawsi=(maincol-non_ind)/(maincol+non_ind);
    % inhibit_rawsi
    [val ind]=min(rsp);
    othercols=find(cols~=ind); 
    non_ind=mean(rsp(othercols));
    maincol=rsp(ind);
    respstructsingle.inhibit_rawsi=(maincol-non_ind)/(maincol+non_ind);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% without Fruit Measures (March 12, 2009)
    %%% Excite/Inhibit/Both - No Fruit
    respstructsingle.excitetype_nofruit='Non-Responsive'; % default
    tmpexciteinhibit=respstructsingle.excite_inhibit([1 3 4 5]);
    excitemarkers=find(tmpexciteinhibit==1);
    inhibitmarkers=find(tmpexciteinhibit==-1);
    if strcmp(respstructsingle.conf_neurtype,'Sensory')==1,
    if isempty(excitemarkers)~=1 & isempty(inhibitmarkers)~=1, respstructsingle.excitetype_nofruit='Both';
    elseif isempty(excitemarkers)~=1 & isempty(inhibitmarkers)==1, respstructsingle.excitetype_nofruit='Excite';
    elseif isempty(excitemarkers)==1 & isempty(inhibitmarkers)~=1, respstructsingle.excitetype_nofruit='Inhibit';
    elseif isempty(excitemarkers)==1 & isempty(inhibitmarkers)==1, respstructsingle.excitetype_nofruit='Non-Responsive';
    end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% CategorySelectivity (ANOVA)
    respstructsingle.selective_nofruit='Non-Responsive'; % default
    category_id=[ones(1,20) ones(1,20)*2 ones(1,20)*3 ones(1,20)*4 ones(1,20)*5]'; pointer=find(category_id~=2); % eliminate fruit
    respstructsingle.catanova_nofruit=anova1(respstructsingle.m_epoch1(pointer),category_id(pointer),'off');
    if respstructsingle.catanova_nofruit<0.05 & strcmp(respstructsingle.excitetype_nofruit,'Non-Responsive')~=1
        respstructsingle.selective_nofruit='Selective';
    elseif respstructsingle.catanova_nofruit>=0.05 & strcmp(respstructsingle.excitetype_nofruit,'Non-Responsive')~=1
        respstructsingle.selective_nofruit='Not Selective';
    else
        respstructsingle.selective_nofruit='Non-Responsive';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%% Preferred Categories
    respstructsingle.prefcat_excite_nofruit='None'; % default
    respstructsingle.prefcat_inhibit_nofruit='None'; % default
    if strcmp(respstructsingle.excitetype_nofruit,'Non-Responsive')~=1,
        %%% Preferred Excitatory
        if ismember(respstructsingle.excitetype_nofruit,{'Excite','Both'})==1
            [junk,ind]=max(respstructsingle.cat_avg([1 3 4 5],2));
            switch ind
                case 1, respstructsingle.prefcat_excite_nofruit='Faces';
                case 2, respstructsingle.prefcat_excite_nofruit='Places';
                case 3, respstructsingle.prefcat_excite_nofruit='BodyParts';
                case 4, respstructsingle.prefcat_excite_nofruit='Objects';
            end
        end
        %%% Preferred Suppressed
        if ismember(respstructsingle.excitetype_nofruit,{'Inhibit','Both'})==1
            [junk,ind]=min(respstructsingle.cat_avg([1 3 4 5],2));
            switch ind
                case 1, respstructsingle.prefcat_inhibit_nofruit='Faces';
                case 2, respstructsingle.prefcat_inhibit_nofruit='Places';
                case 3, respstructsingle.prefcat_inhibit_nofruit='BodyParts';
                case 4, respstructsingle.prefcat_inhibit_nofruit='Objects';
            end
        end
    else
        respstructsingle.prefcat_excite_nofruit='None';
        respstructsingle.prefcat_inhibit_nofruit='None';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%% Raw Selectivity Indices (March 12, 2009)
    %%% Excite/Inhibit/Both - No Fruit
    rsp=respstructsingle.cat_avg([1 3 4 5],2)'; cols=1:4;
    % excite_rawsi
    [val ind]=max(rsp);
    othercols=find(cols~=ind);
    non_ind=mean(rsp(othercols));
    maincol=rsp(ind);
    respstructsingle.excite_rawsi_nofruit=(maincol-non_ind)/(maincol+non_ind);
    % inhibit_rawsi
    [val ind]=min(rsp);
    othercols=find(cols~=ind); 
    non_ind=mean(rsp(othercols));
    maincol=rsp(ind);
    respstructsingle.inhibit_rawsi_nofruit=(maincol-non_ind)/(maincol+non_ind);
    % CatSpecificSI
    for c=1:4,
        othercols=find(cols~=c); 
        non_ind=mean(rsp(othercols));
        maincol=rsp(c);
        respstructsingle.cat_si_nofruit(c)=(maincol-non_ind)/(maincol+non_ind);
    end
    %%% Solve for traditional face-selectivity
    nonface=mean(respstructsingle.cat_avg([3 4 5],2));
    if respstructsingle.cat_avg(1,2)>(2*nonface), respstructsingle.face_trad_nofruit=1;
    else respstructsingle.face_trad_nofruit=0; end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%% Append fMRI data (March 12,2009)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    respstructsingle.APcoords=plx_convertgrid2ap(respstructsingle.gridlocation);
    respstructsingle.AFNIcoords=plx500_apml2xyz(monkinitial,respstructsingle.APcoords);
    %%% Need to convert AFNIcoords to FMRIDATA coords (BrikLoad flips the volume)
    respstructsingle.FMRIdat_coords(1)=size(fmridata,1)-respstructsingle.AFNIcoords(1);
    respstructsingle.FMRIdat_coords(2)=size(fmridata,2)-respstructsingle.AFNIcoords(2);
    respstructsingle.FMRIdat_coords(3)=size(fmridata,3)-respstructsingle.AFNIcoords(3);
    ac=respstructsingle.FMRIdat_coords;
    respstructsingle.AFNItimeseries=squeeze(fmridata(ac(1),ac(2),ac(3),:));
    %%% fMRI Measures - Collapse 8 TRs into 1 value (peak response, ignore first 2 TRs)
    blocklength=length(respstructsingle.AFNItimeseries)/blocksnum; % both monkeys have 11 conds/block but different blocklength
    blocks=1:blocklength:length(respstructsingle.AFNItimeseries);
    for b=1:blocksnum,
        blockrsp(b)=max(respstructsingle.AFNItimeseries(blocks(b)+2:blocks(b)+(blocklength-3)));
    end
    respstructsingle.fmri_rsp=blockrsp([2 4 6 8]); % face,place,object,bodyparts,neutral,baseline
    %%% Correct Wiggum's FMRI data
    if monkinitial=='W',
        respstructsingle.fmri_rsp=respstructsingle.fmri_rsp-100;
    end
    %%% Normalize Responses:
    respstructsingle.fmri_norm_rsp=respstructsingle.fmri_rsp+abs(min(respstructsingle.fmri_rsp));
    %%% Category-Specific SI
    cols=1:4;
    for c=1:4,
        othercols=find(cols~=c); 
        non_ind=mean(respstructsingle.fmri_norm_rsp(othercols));
        maincol=respstructsingle.fmri_norm_rsp(c);
        respstructsingle.fmri_catsi(c)=(maincol-non_ind)/(maincol+non_ind);
    end
    %%% Excitatory Raw SI
    [val ind]=max(respstructsingle.fmri_norm_rsp);
    othercols=find(cols~=ind);
    non_ind=mean(respstructsingle.fmri_norm_rsp(othercols));
    maincol=respstructsingle.fmri_norm_rsp(ind);
    respstructsingle.fmri_excite_rawsi=(maincol-non_ind)/(maincol+non_ind);
    %%% Inhibited Raw SI
    [val ind]=min(respstructsingle.fmri_norm_rsp);
    othercols=find(cols~=ind); 
    non_ind=mean(respstructsingle.fmri_norm_rsp(othercols));
    maincol=respstructsingle.fmri_norm_rsp(ind);
    respstructsingle.fmri_inhibit_rawsi=(maincol-non_ind)/(maincol+non_ind);
    %%% NEED TO AVOID GRILL-SPECTOR MISTAKE WITH FMRI

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%% Statistical comparison of preferred categories (excited/suppressed)
    %%% to average response to remaining categories (March 19, 2009)
    respstructsingle.cat_id=[ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5];
    % comparison matrix
    for c1=1:5,
        for c2=1:5,
            % use mean cat responses
            pointer1=find(respstructsingle.cat_id==c1);
            pointer2=find(respstructsingle.cat_id==c2);
            respstructsingle.stats_rsp_matrix_avg(c1,c2)=ranksum(respstructsingle.m_epoch1(pointer1),respstructsingle.m_epoch1(pointer2));
            % use trial responses
            pointer1=find(respstructsingle.trial_id(:,2)==c1);
            pointer2=find(respstructsingle.trial_id(:,2)==c2);
            respstructsingle.stats_rsp_matrix_trial(c1,c2)=ranksum(respstructsingle.trial_m_epoch1(pointer1),respstructsingle.trial_m_epoch1(pointer2));
        end
    end
    %%% Compare preferred excitatory category to remaining categories
    cats={'Faces','Fruit','Places','BodyParts','Objects'}; catcols=[1 3 4 5]; % eliminate fruits
    catid=find(strcmp(cats,respstructsingle.prefcat_excite_nofruit)==1); % identify category col number
    if isempty(catid)==0,
        otherid=catcols(find(catcols~=catid));
        pointer1=find(respstructsingle.cat_id==catid);
        pointer2=find(ismember(respstructsingle.cat_id,otherid)==1);
        respstructsingle.stats_prefexcite_v_others_nofruit=...
            ranksum(respstructsingle.m_epoch1(pointer1),respstructsingle.m_epoch1(pointer2));
    else
        respstructsingle.stats_prefexcite_v_others_nofruit=NaN;
    end
    %%% Compare preferred suppressed category to remaining categories
    catid=find(strcmp(cats,respstructsingle.prefcat_inhibit_nofruit)==1);
    if isempty(catid)==0,
        otherid=catcols(find(catcols~=catid));
        pointer1=find(respstructsingle.cat_id==catid);
        pointer2=find(ismember(respstructsingle.cat_id,otherid)==1);
        respstructsingle.stats_prefinhibit_v_others_nofruit=...
            ranksum(respstructsingle.m_epoch1(pointer1),respstructsingle.m_epoch1(pointer2));
    else
        respstructsingle.stats_prefinhibit_v_others_nofruit=NaN;
    end
    %%% Normalized category response (March 23, 2009)
    respstructsingle.norm_cat_avg=respstructsingle.cat_avg(:,2)/max(respstructsingle.cat_avg(:,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%% Append LFP data (May 7, 2009)
     try
        disp('......trying to append LFP data...')
        %%% Find matching LFP channel by creating 'matching name'
        chan_name={'LFP1','LFP2','LFP3','LFP4'};
        temp=char(newunit); nameindex=str2num(temp(6));
        fakeLFPname=[hmiconfig.rsvp500lfps,newname(1:12),'-500-',char(chan_name(nameindex)),'.mat'];
        load(fakeLFPname);
        %%% Copy LFP data fields
        respstructsingle.LFP_trial_type=lfpstructsingle_trim.trial_type;
        respstructsingle.LFP_trial_epoch=lfpstructsingle_trim.trial_epoch;
        respstructsingle.LFP_trial_epoch_rect=lfpstructsingle_trim.trial_epoch_rect;
        respstructsingle.LFP_lfp_average_epoch_rect=lfpstructsingle_trim.lfp_average_epoch_rect;
        respstructsingle.LFP_cat_avg_epoch_tr=lfpstructsingle_trim.cat_avg_epoch_tr;
        respstructsingle.LFP_cat_avg_rect_epoch=lfpstructsingle_trim.cat_avg_rect_epoch;
        respstructsingle.LFP_cat_avg_rect_epoch_tr=lfpstructsingle_trim.cat_avg_rect_epoch_tr;
        respstructsingle.LFP_anova_stim=lfpstructsingle_trim.anova_stim;
        respstructsingle.LFP_bestlabel=lfpstructsingle_trim.bestlabel;
        respstructsingle.LFP_cat_anova_rect=lfpstructsingle_trim.cat_anova_rect;
        respstructsingle.LFP_evoked_cat_si=lfpstructsingle_trim.evoked_cat_si;
        respstructsingle.LFP_evokedpure_cat_si=lfpstructsingle_trim.evoked_cat_si;
        respstructsingle.LFP_freq_epoch_cat=lfpstructsingle_trim.freq_epoch_cat;
        respstructsingle.LFP_freq_within_anova=lfpstructsingle_trim.freq_within_anova;
        respstructsingle.LFP_freq_bestlabel=lfpstructsingle_trim.freq_bestlabel;
        respstructsingle.LFP_freq_across_anova=lfpstructsingle_trim.freq_across_anova;
        respstructsingle.LFP_freq_cat_si=lfpstructsingle_trim.freq_cat_si;
        respstructsingle.LFP_tr_min_max=lfpstructsingle_trim.tr_min_max;
        respstructsingle.LFP_cond_min_max=lfpstructsingle_trim.cond_min_max;
        respstructsingle.LFP_cat_min_max=lfpstructsingle_trim.cat_min_max;
        respstructsingle.LFP_stats_pref_v_others_evoked=lfpstructsingle_trim.stats_pref_v_others_evoked;
        respstructsingle.LFP_stats_pref_v_others_0_120Hz=lfpstructsingle_trim.stats_pref_v_others_0_120Hz;
        respstructsingle.LFP_stats_pref_v_others_0_20Hz=lfpstructsingle_trim.stats_pref_v_others_0_20Hz;
        disp('......Successful!')
     catch
        disp('......Unsuccessful!  Pasting blank values...')
        numtrials=size(respstructsingle.trial_id,1);
        respstructsingle.LFP_trial_type=zeros(1,numtrials);
        respstructsingle.LFP_trial_epoch=zeros(1,numtrials);
        respstructsingle.LFP_trial_epoch_rect=zeros(1,numtrials);
        respstructsingle.LFP_lfp_average_epoch_rect=zeros(1,100);
        respstructsingle.LFP_cat_avg_epoch_tr=[0 0 0 0];
        respstructsingle.LFP_cat_avg_rect_epoch=[0 0 0 0];
        respstructsingle.LFP_cat_avg_rect_epoch_tr=[0 0 0 0];
        respstructsingle.LFP_anova_stim=[0 0 0 0];
        respstructsingle.LFP_bestlabel={'None'};
        respstructsingle.LFP_cat_anova_rect=1;
        respstructsingle.LFP_evoked_cat_si=[0 0 0 0];
        respstructsingle.LFP_evokedpure_cat_si=[0 0 0 0];
        respstructsingle.LFP_freq_epoch_cat=zeros(4,6);
        respstructsingle.LFP_freq_within_anova=zeros(4,6);
        respstructsingle.LFP_freq_bestlabel={'None','None','None','None','None','None'};
        respstructsingle.LFP_freq_across_anova=[0 0 0 0 0 0];
        respstructsingle.LFP_freq_cat_si=zeros(4,6);
        respstructsingle.LFP_tr_min_max=zeros(numtrials,2);
        respstructsingle.LFP_cond_min_max=zeros(100,2);
        respstructsingle.LFP_cat_min_max=zeros(4,2);
        respstructsingle.LFP_stats_pref_v_others_evoked=1;
        respstructsingle.LFP_stats_pref_v_others_0_120Hz=1;
        respstructsingle.LFP_stats_pref_v_others_0_20Hz=1;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
    %%% RESAVE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    respstructsingle.datemodified=date;
    save([hmiconfig.rsvp500spks,filesep,newname(1:12),'-',newunit,'-500responsedata.mat'],'respstructsingle');
    clear respstructsingle
end
return