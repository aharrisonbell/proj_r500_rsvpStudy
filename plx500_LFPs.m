function rejects=plx500_LFPs(filez)
%%%%%%%%%%%%%%%%%%%%%%%
% plx500_LFPs(files); %
%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, June2008, based on plx500
% Analyzes data for RSVP500 (rsvp500f.tim, rsvp500s.tim) task
% Incoming files must be run first through plx_processnexfile and then plx_processLFPs
% before analysis is possible
% files = optional argument, list files as strings.  Otherwise, program
% will load files listed in default analyze500.txt

%%% SETUP DEFAULTS
warning off;
%close all
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=500; % list of paradigm numbers
xscale=[-400 700]; % default time window for LFPs, +/-400ms from stim onset/offset
channels={'LFP1','LFP2','LFP3','LFP4'};
%%% CURRENT METRICS (used to define "response")
rect_epoch=[50 300]; % same as spikes

%%%  LOAD FILE LIST
if strcmp(filez,'S')==1
    disp('Analyzing all RSVP500 LFP files for Stewie...')
    % Pulls files from HMI_PhysiologyNotes
    include=xlsread(hmiconfig.excelfile,'RSVP500','D9:D1000'); % alphanumeric, Gridlocation
    [crap,filest]=xlsread(hmiconfig.excelfile,'RSVP500','E9:E1000');
    filesx=filest(find(include==1)); clear include; clear filez
    for ff=1:size(filesx,1),
        temp=char(filesx(ff)); filez(ff)=cellstr(temp(1:12));
    end
elseif strcmp(filez,'W')==1
    disp('Analyzing all RSVP500 LFP files for Wiggum...')
    % Pulls files from HMI_PhysiologyNotes
    include=xlsread(hmiconfig.excelfile,'RSVP500','J9:J1000'); % alphanumeric, Gridlocation
    [crap,filest]=xlsread(hmiconfig.excelfile,'RSVP500','K9:K1000');
    filesx=filest(find(include==1)); clear include; clear filez
    for ff=1:size(filesx,1),
        temp=char(filesx(ff)); filez(ff)=cellstr(temp(1:12));
    end
end

%%% ANALYZE INDIVIDUAL FILES
disp('*************************************************************************')
disp('plx500_LFPs.m - Analysis program for RSVP500-series datafiles (June 2008)')
disp('*************************************************************************')
for f=1:length(filez), % perform following operations on each nex file listed
    %try
    close all
    filename=char(filez(f));
    %%% setup structures
    disp(['Analyzing LFPs activity from ',filename])
    tempstruct=load([hmiconfig.spikedir,filename,'_spkmat.mat']);
    tempbehav=tempstruct.behav_matrix(:,[1 3 4 30 40 44]); % load behavioural data
    clear tempstruct
    tempbehav(:,7)=tempbehav(:,6)-tempbehav(:,5); % solve for cue onset time (aligned to the beginning of each trial, in ms?)
    tempbehav(:,8)=ceil(tempbehav(:,6)*1000); % converts raw cue onset times to rounded ms
    pointer=find(ismember(tempbehav(:,2),parnumlist));
    numtrials=length(pointer);
    if numtrials<1,
        disp('.No RSVP500 trials found!!  Skipping this file.')
    else
        disp(['.found ',num2str(numtrials),' 500-series trials...'])
        pointer=find(ismember(tempbehav(:,2),parnumlist)&tempbehav(:,4)==6); % select only correct trials
        disp(['.found ',num2str(length(pointer)),' correct trials...'])
        numtrials=length(pointer);
        %goodtrials=tempbehav(pointer,:);

        %%% REMOVE FRUIT
        pointer=find(ismember(tempbehav(:,2),parnumlist)==1 & ismember(tempbehav(:,3),21:40)~=1 &tempbehav(:,4)==6);
        goodtrials=tempbehav(pointer,:);
        disp(['.found ',num2str(length(pointer)),' (no fruit) correct trials...'])
        numtrials=length(pointer);

        %%% Find available channels
        chan_anal=[];
        for ch=1:length(channels),
            % See if channel exists in CORRECTED directory
            corrname=strcat(hmiconfig.LFPdir_corr,filez(f),'-',channels(ch),'c.mat');
            if exist(char(corrname))==2,
                chan_anal=[chan_anal ch];
            end
        end
        disp(['.found ',num2str(length(chan_anal)),' LFP channels...'])

        %%% Begin channel analysis
        for ch=1:length(chan_anal), % scroll through each channel
            lfpstructsingle=struct('label',[]);
            chan=channels(chan_anal(ch)); % channel name
            disp(['..analyzing ',char(chan),'...'])
            lfpstructsingle.label=channels(chan_anal(ch)); % paste channel label into lfpstruct
            corrname=strcat(hmiconfig.LFPdir_corr,filez(f),'-',chan,'c.mat');
            lfpdata=load(char(corrname));
            disp('...Evoked Potential Analysis...')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% EVOKED POTENTIAL ANALYSIS %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% cut out individual trial LFPs
            for t=1:numtrials, % loop through each trial and paste lfp into trial matrix
                lfpstructsingle.lfp_trial(t,1:(length(xscale(1):xscale(2))))=lfpdata.LFPsignal(goodtrials(t,8)+xscale(1):goodtrials(t,8)+xscale(2));
                lfpstructsingle.lfp_trial_rect(t,:)=lfpstructsingle.lfp_trial(t,:).^2; % rectify each trial
                %%% also paste category number into goodtrials matrix
                if ch==1, % only need to do this once
                    switch goodtrials(t,3) %% assign category number
                        case {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}, goodtrials(t,9)=1; % faces
                        case {41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60}, goodtrials(t,9)=4; % places
                        case {61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80}, goodtrials(t,9)=2; % body parts
                        case {81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100}, goodtrials(t,9)=3; % objects
                    end
                end
                lfpstructsingle.trial_type(t)=goodtrials(t,9); % assign category number

                %%% Calculate evoked potential epoch (max between 50-300
                %%% following stim onset)
                lfpstructsingle.trial_epoch(t)=max(lfpstructsingle.lfp_trial(t,400+rect_epoch(1):400+rect_epoch(2)));
                lfpstructsingle.trial_epoch_rect(t)=max(lfpstructsingle.lfp_trial_rect(t,400+rect_epoch(1):400+rect_epoch(2)));
            end
            %%% generate average condition LFPs
            for cnd=1:100, % scroll through each condition
                pointer=find(goodtrials(:,3)==cnd);
                [lfpstructsingle.lfp_average(cnd,:) lfpstructsingle.lfp_sem(cnd,:)]=mean_sem(lfpstructsingle.lfp_trial(pointer,:));
                [lfpstructsingle.lfp_average_rect(cnd,:) lfpstructsingle.lfp_sem_rect(cnd,:)]=mean_sem(lfpstructsingle.lfp_trial_rect(pointer,:));
                lfpstructsingle.lfp_average_epoch(cnd)=max(lfpstructsingle.lfp_average(cnd,400+rect_epoch(1):400+rect_epoch(2)));
                lfpstructsingle.lfp_average_epoch_rect(cnd)=max(lfpstructsingle.lfp_average_rect(cnd,400+rect_epoch(1):400+rect_epoch(2)));
            end
            %%% calculate average category responses (evoked)
            lfpstructsingle.cat_avg_epoch(1)=mean(lfpstructsingle.lfp_average_epoch(1:20));
            lfpstructsingle.cat_avg_epoch(2)=mean(lfpstructsingle.lfp_average_epoch(61:80));
            lfpstructsingle.cat_avg_epoch(3)=mean(lfpstructsingle.lfp_average_epoch(81:100));
            lfpstructsingle.cat_avg_epoch(4)=mean(lfpstructsingle.lfp_average_epoch(41:60));
            lfpstructsingle.cat_sem_epoch(1)=sem(lfpstructsingle.lfp_average_epoch(1:20));
            lfpstructsingle.cat_sem_epoch(2)=sem(lfpstructsingle.lfp_average_epoch(61:80));
            lfpstructsingle.cat_sem_epoch(3)=sem(lfpstructsingle.lfp_average_epoch(81:100));
            lfpstructsingle.cat_sem_epoch(4)=sem(lfpstructsingle.lfp_average_epoch(41:60));
            %%% calculate average category responses (rect)
            lfpstructsingle.cat_avg_rect_epoch(1)=mean(lfpstructsingle.lfp_average_epoch_rect(1:20));
            lfpstructsingle.cat_avg_rect_epoch(2)=mean(lfpstructsingle.lfp_average_epoch_rect(61:80));
            lfpstructsingle.cat_avg_rect_epoch(3)=mean(lfpstructsingle.lfp_average_epoch_rect(81:100));
            lfpstructsingle.cat_avg_rect_epoch(4)=mean(lfpstructsingle.lfp_average_epoch_rect(41:60));
            lfpstructsingle.cat_sem_rect_epoch(1)=sem(lfpstructsingle.lfp_average_epoch_rect(1:20));
            lfpstructsingle.cat_sem_rect_epoch(2)=sem(lfpstructsingle.lfp_average_epoch_rect(61:80));
            lfpstructsingle.cat_sem_rect_epoch(3)=sem(lfpstructsingle.lfp_average_epoch_rect(81:100));
            lfpstructsingle.cat_sem_rect_epoch(4)=sem(lfpstructsingle.lfp_average_epoch_rect(41:60));

            %%% generate average LFP functions for each category (listed in CAT_avg/CAT_sem)
            [lfpstructsingle.cat_avg(1,:),lfpstructsingle.cat_sem(1,:)]=mean_sem(lfpstructsingle.lfp_average(hmiconfig.faces500,:));
            [lfpstructsingle.cat_avg(2,:),lfpstructsingle.cat_sem(2,:)]=mean_sem(lfpstructsingle.lfp_average(hmiconfig.bodyp500,:));
            [lfpstructsingle.cat_avg(3,:),lfpstructsingle.cat_sem(3,:)]=mean_sem(lfpstructsingle.lfp_average(hmiconfig.objct500,:));
            [lfpstructsingle.cat_avg(4,:),lfpstructsingle.cat_sem(4,:)]=mean_sem(lfpstructsingle.lfp_average(hmiconfig.places500,:));
            [lfpstructsingle.cat_avg_rect(1,:),lfpstructsingle.cat_sem_rect(1,:)]=mean_sem(lfpstructsingle.lfp_average_rect(hmiconfig.faces500,:));
            [lfpstructsingle.cat_avg_rect(2,:),lfpstructsingle.cat_sem_rect(2,:)]=mean_sem(lfpstructsingle.lfp_average_rect(hmiconfig.bodyp500,:));
            [lfpstructsingle.cat_avg_rect(3,:),lfpstructsingle.cat_sem_rect(3,:)]=mean_sem(lfpstructsingle.lfp_average_rect(hmiconfig.objct500,:));
            [lfpstructsingle.cat_avg_rect(4,:),lfpstructsingle.cat_sem_rect(4,:)]=mean_sem(lfpstructsingle.lfp_average_rect(hmiconfig.places500,:));
            %%% calculate category response and test for within category selectivity
            for cat=1:4,
                pointer=find(goodtrials(:,9)==cat);
                lfpstructsingle.cat_avg_epoch_tr(cat)=mean(lfpstructsingle.trial_epoch(pointer));
                lfpstructsingle.cat_sem_epoch_tr(cat)=sem(lfpstructsingle.trial_epoch(pointer));
                lfpstructsingle.cat_avg_rect_epoch_tr(cat)=mean(lfpstructsingle.trial_epoch_rect(pointer));
                lfpstructsingle.cat_sem_rect_epoch_tr(cat)=sem(lfpstructsingle.trial_epoch_rect(pointer));
                lfpstructsingle.anova_stim(cat)=anova1(lfpstructsingle.trial_epoch(pointer),goodtrials(pointer,3),'off');
                lfpstructsingle.anova_stim_rect(cat)=anova1(lfpstructsingle.trial_epoch_rect(pointer),goodtrials(pointer,3),'off');
            end
            %%% solve for best category
            catlabels={'Faces','Bodyparts','Objects','Places'};
             [junk,ind]=max(lfpstructsingle.cat_avg_epoch);
            lfpstructsingle.bestlabel=catlabels(ind);
            [junk,ind]=max(lfpstructsingle.cat_avg_rect_epoch);
            lfpstructsingle.bestlabel_rect=catlabels(ind);
            %%% test for category selectivity (no fruit)
            lfpstructsingle.cat_anova_rect=anova1(lfpstructsingle.trial_epoch_rect,goodtrials(:,9),'off');
            
            %%% Calculate Selectivity Index (no fruit)
            catinds=[1 2 3 4];
            for cat=1:4, % evoked potential
                R1=catinds(cat); R2=find(catinds~=catinds(cat));
                r1=lfpstructsingle.cat_avg_epoch(R1);
                r2=mean(lfpstructsingle.cat_avg_epoch(catinds(R2)));
                lfpstructsingle.evoked_cat_si(cat)=(r1-r2)/(r1+r2);
                clear R1 R2 r1 r2
            end
            for cat=1:4, % rectified potential
                R1=catinds(cat); R2=find(catinds~=catinds(cat));
                r1=lfpstructsingle.cat_avg_rect_epoch(R1);
                r2=mean(lfpstructsingle.cat_avg_rect_epoch(catinds(R2)));
                lfpstructsingle.rect_cat_si(cat)=(r1-r2)/(r1+r2);
                clear R1 R2 r1 r2
            end
            % Min and Max for each trial, condition, and category (May 7, 2009)
            for tr=1:length(lfpstructsingle.trial_type),
                lfpstructsingle.tr_min_max(tr,1)=min(lfpstructsingle.lfp_trial(tr,400+rect_epoch(1):400+rect_epoch(2)));
                lfpstructsingle.tr_min_max(tr,2)=max(lfpstructsingle.lfp_trial(tr,400+rect_epoch(1):400+rect_epoch(2)));
            end
            for cc=1:100,
                lfpstructsingle.cond_min_max(cc,1)=min(lfpstructsingle.lfp_average(cc,400+rect_epoch(1):400+rect_epoch(2)));
                lfpstructsingle.cond_min_max(cc,2)=max(lfpstructsingle.lfp_average(cc,400+rect_epoch(1):400+rect_epoch(2)));
            end
            for cat=1:4,
                lfpstructsingle.cat_min_max(cat,1)=min(lfpstructsingle.cat_avg(cat,400+rect_epoch(1):400+rect_epoch(2)));
                lfpstructsingle.cat_min_max(cat,2)=max(lfpstructsingle.cat_avg(cat,400+rect_epoch(1):400+rect_epoch(2)));
            end
            clear catinds pointer cat junk ind

            disp('...Frequency Domain Analysis...')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% FREQUENCY DOMAIN ANALYSIS %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% NOTE THE REORDERING AND REMOVAL OF FRUIT
            %%% Create spectrograms (multitaper function; Partha Mitra Chronux.org)
            disp('....constructing spectrograms for each trial (excluding fruit)...')
            params=hmiconfig.chronux_params;
            trial_specgramMT_S=zeros(numtrials,846,31);
            for tt=1:numtrials,
                [trial_specgramMT_S(tt,:,:),lfpstructsingle.trial_specgramMT_T(tt,:),lfpstructsingle.trial_specgramMT_F(tt,:)]=...
                    mtspecgramc(lfpstructsingle.lfp_trial(tt,:)',[0.256 0.001],params);
            end
            disp('....constructing average spectrograms for each category (excluding fruit)...')
            [cat_specgramMT_S(1,:,:),lfpstructsingle.cat_specgramMT_T(1,:),lfpstructsingle.cat_specgramMT_F(1,:)]=...
                mtspecgramc(lfpstructsingle.lfp_average(hmiconfig.faces500,:)',[0.256 0.001],params);
            [cat_specgramMT_S(2,:,:),lfpstructsingle.cat_specgramMT_T(2,:),lfpstructsingle.cat_specgramMT_F(2,:)]=...
                mtspecgramc(lfpstructsingle.lfp_average(hmiconfig.bodyp500,:)',[0.256 0.001],params);
            [cat_specgramMT_S(3,:,:),lfpstructsingle.cat_specgramMT_T(3,:),lfpstructsingle.cat_specgramMT_F(3,:)]=...
                mtspecgramc(lfpstructsingle.lfp_average(hmiconfig.objct500,:)',[0.256 0.001],params);
            [cat_specgramMT_S(4,:,:),lfpstructsingle.cat_specgramMT_T(4,:),lfpstructsingle.cat_specgramMT_F(4,:)]=...
                mtspecgramc(lfpstructsingle.lfp_average(hmiconfig.places500,:)',[0.256 0.001],params);
            %%% baseline subtraction - take average spectrum across ALL conditions (-100-0ms) and reduce to single function.
            %%% Calculate baseline spectrum
            for cc=1:4,
                clear indexmark
                indexmark=abs((lfpstructsingle.cat_specgramMT_T(cc,1)*1000)-300);
                tempbase=squeeze(cat_specgramMT_S(cc,indexmark:indexmark+100,:));
                tempavg(cc,:)=mean(tempbase,1);
            end
            baseline=mean(tempavg); % average baseline across all categories
            %%% Subtract baseline from trial spectrograms
            for tr=1:numtrials,
                tempS=squeeze(trial_specgramMT_S(tr,:,:));
                for tt=1:size(tempS,1),
                    tempS(tt,:)=tempS(tt,:)-baseline;
                end
                lfpstructsingle.trial_specgramMT_S_noB(tr,:,:)=tempS;
            end
            clear tr tt tempS tempavg tempbase trial_specgramMT_S
            %%% Subtract baseline from average category spectrograms
            for cc=1:4,
                tempS=squeeze(cat_specgramMT_S(cc,:,:));
                for tt=1:size(tempS,1),
                    tempS(tt,:)=tempS(tt,:)-baseline;
                end
                lfpstructsingle.cat_specgramMT_S_noB(cc,:,:)=tempS;

            end
            clear cc tt tempS tempavg tempbase cat_specgramMT_S
            %%% Calculate responses for different frequency bands
            disp('....conducting frequency band analysis...')
            % 0-120Hz
            % ~0-20Hz
            % ~20-45Hz
            % ~45-70Hz
            % ~70-95Hz
            % ~95-120Hz
            freqband=[0 120;0 20;20 45;45 70;70 95;95 120];
            for tr=1:numtrials,
                for fb=1:size(freqband,1), % cycle through each frequency window
                    fbpointer=find(lfpstructsingle.trial_specgramMT_F(tr,:)>=freqband(fb,1) & lfpstructsingle.trial_specgramMT_F(tr,:) < freqband(fb,2));
                    lfpstructsingle.freq_epoch_trial(tr,fb)=sum(sum(squeeze(lfpstructsingle.trial_specgramMT_S_noB(tr,400+rect_epoch(1):400+rect_epoch(2),fbpointer))));
                end
            end
            clear tr fb
            %%% calculate category response and test for within category selectivity
            stimid=goodtrials(:,3);
            catid=goodtrials(:,9);
            catcol=[1 2 3 4];
            for cat=1:4,
                pointer=find(catid==catcol(cat));
                for fb=1:6, % one loop per measure
                    lfpstructsingle.freq_epoch_cat(cat,fb)=mean(lfpstructsingle.freq_epoch_trial(pointer,fb));
                    lfpstructsingle.freq_epoch_cat(cat,fb)= sem(lfpstructsingle.freq_epoch_trial(pointer,fb));
                    lfpstructsingle.freq_within_anova(cat,fb)=anova1(lfpstructsingle.freq_epoch_trial(pointer,fb),stimid(pointer),'off');
                end
            end
            %%% solve for best category
            catlabels={'Faces','Bodyparts','Objects','Places'};
            for fb=1:6,
                %%% identify and label best category for each band
                [junk,ind]=max(lfpstructsingle.freq_epoch_cat(:,fb));
                lfpstructsingle.freq_bestlabel(fb)=catlabels(ind);
                %%% test for category selectivity (across cat)
                lfpstructsingle.freq_across_anova(fb)=anova1(lfpstructsingle.freq_epoch_trial(:,fb),catid,'off');
                %%% Calculate Selectivity Index (no fruit)
                catind=1:4;
                for cat=1:4,
                    R1=cat; R2=find(catind~=cat);
                    r1=lfpstructsingle.freq_epoch_cat(R1,fb);
                    r2=mean(lfpstructsingle.freq_epoch_cat(R2,fb));
                    lfpstructsingle.freq_cat_si(cat,fb)=(r1-r2)/(r1+r2);
                    clear R1 R2 r1 r2
                end
            end
            clear cat fb junk ind


            %%% MATRIX ANOVA - performs an anova on all trials - for category
            disp('....calculating time/freq anova...')
            lfpstructsingle.mtspect_anova=zeros(846,31);
            for tim=1:size(lfpstructsingle.trial_specgramMT_S_noB,2),
                for freq=1:size(lfpstructsingle.trial_specgramMT_S_noB,3),
                    lfpstructsingle.mtspect_anova(tim,freq)=anova1(log(abs(lfpstructsingle.trial_specgramMT_S_noB(:,tim,freq))),catid,'off');
                end
            end
            clear tim freq
            
            %%% MATRIX T-TEST - performs pairwise T-tests
            disp('....calculating time/freq ttest...')
            pairs=[1 2;1 3;1 4;2 3;2 4;3 4];
            for pp=1:size(pairs,1),
                for tim=1:size(lfpstructsingle.trial_specgramMT_S_noB,2),
                    for freq=1:size(lfpstructsingle.trial_specgramMT_S_noB,3),
                        pointer1=find(lfpstructsingle.trial_type==pairs(pp,1));
                        pointer2=find(lfpstructsingle.trial_type==pairs(pp,2));
                        data1=log(abs(lfpstructsingle.trial_specgramMT_S_noB(pointer1,tim,freq)));
                        data2=log(abs(lfpstructsingle.trial_specgramMT_S_noB(pointer2,tim,freq)));
                        [junk,lfpstructsingle.mtspect_ttest(pp,tim,freq)]=ttest2(data1,data2);
                    end
                end
            end
            
            %%%% APPENDED FIELDS HERE %%%%

            % Statistical test of responses vs. all others
            % Compare preferred excitatory category to remaining categories
            % (evoked)
            cats={'Faces','Bodyparts','Objects','Places'}; catcols=[1 2 3 4]; % eliminate fruits
            catid=find(strcmp(cats,lfpstructsingle.bestlabel)==1); % identify category col number
            if isempty(catid)==0,
                otherid=catcols(find(catcols~=catid));
                pointer1=find(lfpstructsingle.trial_type==catid);
                pointer2=find(ismember(lfpstructsingle.trial_type,otherid)==1);
                lfpstructsingle.stats_pref_v_others_evoked=...
                    ranksum(lfpstructsingle.trial_epoch(pointer1),lfpstructsingle.trial_epoch(pointer2));
            else
                lfpstructsingle.stats_pref_v_others_evoked=1;
            end
            
             % Statistical test of responses vs. all others
            % Compare preferred excitatory category to remaining categories
            % (rectified)
            cats={'Faces','Bodyparts','Objects','Places'}; catcols=[1 2 3 4]; % eliminate fruits
            catid=find(strcmp(cats,lfpstructsingle.bestlabel_rect)==1); % identify category col number
            if isempty(catid)==0,
                otherid=catcols(find(catcols~=catid));
                pointer1=find(lfpstructsingle.trial_type==catid);
                pointer2=find(ismember(lfpstructsingle.trial_type,otherid)==1);
                lfpstructsingle.stats_pref_v_others_rect=...
                    ranksum(lfpstructsingle.trial_epoch_rect(pointer1),lfpstructsingle.trial_epoch_rect(pointer2));
            else
                lfpstructsingle.stats_pref_v_others_rect=1;
            end
            
            % Compare preferred excitatory category to remaining categories
            % (0-120Hz)
            cats={'Faces','Bodyparts','Objects','Places'}; catcols=[1 2 3 4]; % eliminate fruits
            catid=find(strcmp(cats,lfpstructsingle.freq_bestlabel(1))==1); % identify category col number
            if isempty(catid)==0,
                otherid=catcols(find(catcols~=catid));
                pointer1=find(lfpstructsingle.trial_type==catid);
                pointer2=find(ismember(lfpstructsingle.trial_type,otherid)==1);
                lfpstructsingle.stats_pref_v_others_0_120Hz=...
                    ranksum(lfpstructsingle.freq_epoch_trial(pointer1,1),lfpstructsingle.freq_epoch_trial(pointer2,1));
            else
                lfpstructsingle.stats_pref_v_others_0_120Hz=1;
            end

            % Compare preferred excitatory category to remaining categories
            % (0-20Hz)
            cats={'Faces','Bodyparts','Objects','Places'}; catcols=[1 2 3 4]; % eliminate fruits
            catid=find(strcmp(cats,lfpstructsingle.freq_bestlabel(2))==1); % identify category col number
            if isempty(catid)==0,
                otherid=catcols(find(catcols~=catid));
                pointer1=find(lfpstructsingle.trial_type==catid);
                pointer2=find(ismember(lfpstructsingle.trial_type,otherid)==1);
                lfpstructsingle.stats_pref_v_others_0_20Hz=...
                    ranksum(lfpstructsingle.freq_epoch_trial(pointer1,2),lfpstructsingle.freq_epoch_trial(pointer2,2));
            else
                lfpstructsingle.stats_pref_v_others_0_20Hz=1;
            end


            
            %%% save data into single files per channel
            %lfpstructsingle.xscale=xscale;
            %outputfname = [hmiconfig.rsvp500lfps_lrg,filename,'-500-',char(chan),'.mat'];
            %disp(['....saving local field potential data for ',char(chan),'...'])
            %save(outputfname,'lfpstructsingle');
            
             %%%% TRIM FIELDS %%%%
            lfpstructsingle_trim=rmfield(lfpstructsingle,{...
            'trial_specgramMT_S_noB'}); %,'cat_specgramMT_S_noB'});

            %%% save data into single files per channel
            outputfname_sml = [hmiconfig.rsvp500lfps,filename,'-500-',char(chan),'.mat'];
            disp(['....saving local field potential data for ',char(chan),'...'])
            save(outputfname_sml,'lfpstructsingle_trim');

            plot_singleLFP(hmiconfig,xscale,lfpstructsingle,char(filez(f)))
            
            %plot_singleLFP_figureJET(hmiconfig,xscale,lfpstructsingle,char(filez(f)))
            %plot_singleLFP_figureHOT(hmiconfig,xscale,lfpstructsingle,char(filez(f)))
            close all
            clear lfpstructsingle
            
            
        end
    end % end of found RSVP trials loop
    %catch
    %disp('Error in file')
    % rejects=[rejects;filez(f)];
    %end % end try loop
end % filez loop
return

%%%%%%%%%% NESTED FUNCTIONS %%%%%%%%%%
function plot_singleLFP(hmiconfig,xscale,lfpstruct,fname)
disp('....graphing LFP data...')
fontsize_sml=7;
fontsize_med=8;
figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.05 0.4 0.8])
set(gca,'FontName','Arial')
subplot(5,4,[1 2])
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(4,:),'b-','LineWidth',1)
set(gca,'YDir','reverse'); xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title({[fname,'-',char(lfpstruct.label)],'All Categories'},'FontSize',fontsize_med)
subplot(5,4,[5 6])
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(4,:),'b-','LineWidth',1)
xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Rectified - All Categories','FontSize',fontsize_med)
subplot(5,4,[9 13 17])
pcolor(xscale(1):xscale(2),1:80,lfpstruct.lfp_average([1:20 41:100],:)*-1)
shading flat
hold on
plot([xscale(1) xscale(end)],[21 21],'k-','LineWidth',1)
plot([xscale(1) xscale(end)],[41 41],'k-','LineWidth',1)
plot([xscale(1) xscale(end)],[61 61],'k-','LineWidth',1)
plot([0 0],[0 100],'k-','LineWidth',1)
colorbar('SouthOutside'); colormap(jet);
text(-250,10,'Faces','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,30,'Places','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,50,'Bodyparts','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,70,'Objects','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(0,81.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
set(gca,'FontSize',7); box off; axis off; axis ij; ylim([0 80]); set(gca,'ZDir','reverse');
xlim([-200 400]);

subplot(4,4,3) % faces
hold on
pointer=find(lfpstruct.trial_type==1);
for tr=1:length(pointer),
    plot(xscale(1):xscale(2),lfpstruct.lfp_trial(pointer(tr),:),'-','Color',[0.5 0.5 0.5],'LineWidth',0.1)
end
plot(xscale(1):xscale(2),lfpstruct.cat_avg(1,:),'r-','LineWidth',2)
set(gca,'YDir','reverse'); h=axis; xlim([-200 400]); plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title(['Faces (pref.cat evoked): ',char(lfpstruct.bestlabel)],'FontSize',fontsize_med)
%text(-190,-3.8,['SI(min1): ',num2str(lfpstruct.cat_si(1,1),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(1,1),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-3.3,['SI(min2): ',num2str(lfpstruct.cat_si(1,2),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(1,2),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-2.8,['SI(max1): ',num2str(lfpstruct.cat_si(1,3),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(1,3),'%1.2g')],'FontSize',fontsize_sml)
subplot(4,4,7) % bodyparts
hold on
pointer=find(lfpstruct.trial_type==2);
for tr=1:length(pointer),
    plot(xscale(1):xscale(2),lfpstruct.lfp_trial(pointer(tr),:),'-','Color',[0.5 0.5 0.5],'LineWidth',0.1)
end
plot(xscale(1):xscale(2),lfpstruct.cat_avg(2,:),'y-','LineWidth',2)
set(gca,'YDir','reverse'); h=axis; xlim([-200 400]); plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Bodyparts','FontSize',fontsize_med)
%text(-190,-3.8,['SI(min1): ',num2str(lfpstruct.cat_si(4,1),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(4,1),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-3.3,['SI(min2): ',num2str(lfpstruct.cat_si(4,2),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(4,2),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-2.8,['SI(max1): ',num2str(lfpstruct.cat_si(4,3),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(4,3),'%1.2g')],'FontSize',fontsize_sml)
subplot(4,4,11) % objects
hold on
pointer=find(lfpstruct.trial_type==3);
for tr=1:length(pointer),
    plot(xscale(1):xscale(2),lfpstruct.lfp_trial(pointer(tr),:),'-','Color',[0.5 0.5 0.5],'LineWidth',0.1)
end
plot(xscale(1):xscale(2),lfpstruct.cat_avg(3,:),'g-','LineWidth',2)
set(gca,'YDir','reverse'); h=axis; xlim([-200 400]); plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Objects','FontSize',fontsize_med)
% text(-190,-3.8,['SI(min1): ',num2str(lfpstruct.cat_si(5,1),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(5,1),'%1.2g')],'FontSize',fontsize_sml)
% text(-190,-3.3,['SI(min2): ',num2str(lfpstruct.cat_si(5,2),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(5,2),'%1.2g')],'FontSize',fontsize_sml)
% text(-190,-2.8,['SI(max1): ',num2str(lfpstruct.cat_si(5,3),'%1.2g'),',
% anovaInCat: ',num2str(lfpstruct.anova_stim(5,3),'%1.2g')],'FontSize',fontsize_sml)
subplot(4,4,15) % places
hold on
pointer=find(lfpstruct.trial_type==4);
for tr=1:length(pointer),
    plot(xscale(1):xscale(2),lfpstruct.lfp_trial(pointer(tr),:),'-','Color',[0.5 0.5 0.5],'LineWidth',0.1)
end
plot(xscale(1):xscale(2),lfpstruct.cat_avg(4,:),'b-','LineWidth',2)
set(gca,'YDir','reverse'); h=axis; xlim([-200 400]); plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Places','FontSize',fontsize_med)
%text(-190,-3.8,['SI(min1): ',num2str(lfpstruct.cat_si(3,1),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(3,1),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-3.3,['SI(min2): ',num2str(lfpstruct.cat_si(3,2),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(3,2),'%1.2g')],'FontSize',fontsize_sml)
%text(-190,-2.8,['SI(max1): ',num2str(lfpstruct.cat_si(3,3),'%1.2g'),', anovaInCat: ',num2str(lfpstruct.anova_stim(3,3),'%1.2g')],'FontSize',fontsize_sml)

% anova spect
subplot(4,4,10)
hold on
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),lfpstruct.mtspect_anova'); shading flat;
plot([0 0],[0 120],'k:')
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Anova on Category (no Fruit)','FontSize',fontsize_med); cmap_anova; caxis([0 0.05]); colorbar('SouthOutside')

% ttest spect sample
subplot(4,4,14)
hold on
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),squeeze(lfpstruct.mtspect_ttest(3,:,:))'); shading flat;
plot([0 0],[0 120],'k:')
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Sample TTest (Faces vs. Places))','FontSize',fontsize_med); cmap_anova; caxis([0 0.05]); colorbar('SouthOutside')


% spectrograms - multitaper
subplot(4,4,4)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(1,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Faces (multitaper)','FontSize',fontsize_med); colormap(jet);
subplot(4,4,8)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(2,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Bodyparts (multitaper)','FontSize',fontsize_med);
subplot(4,4,12)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(3,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Objects (multitaper)','FontSize',fontsize_med);
subplot(4,4,16)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(4,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Places (multitaper)','FontSize',fontsize_med);

% epochs
% subplot(5,4,14) %evoked
% hold on
% bar(lfpstruct.cat_avg_rect_epoch)
% errorbar(1:4,lfpstruct.cat_avg_rect_epoch,lfpstruct.cat_sem_rect_epoch)
% set(gca,'FontSize',fontsize_med,'XTick',1:5,'XTickLabel',{'F','Bp','Ob','Pl'})
% ylabel('Voltage')
% title(['Anova (nofruit): ',num2str(lfpstruct.cat_anova_rect,'%1.2g')],'FontSize',10)
% subplot(5,4,18) % frequency
% bar(1:4,lfpstruct.freq_epoch_cat,'Group')
% set(gca,'XTick',1:4,'FontSize',fontsize_med,'XTickLabel',{'F','Bp','Ob','Pl'})
% %legend('0-120','0-20','20-45','45-70','70-95','95-120')
% title(['Anova(0-20Hz): ',num2str(lfpstruct.freq_across_anova(2),'%1.2g')],'FontSize',10)
%matfigname=[hmiconfig.figure_dir,'rsvp500lfps',filesep,fname,'_rsvp500_',char(lfpstruct.label),'.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500lfps',filesep,fname,'_rsvp500_',char(lfpstruct.label),'.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500lfps',filesep,fname,'_rsvp500_',char(lfpstruct.label),'.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
%hgsave(matfigname);
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return

function plot_singleLFP_figureJET(hmiconfig,xscale,lfpstruct,fname)
disp('....graphing LFP data in a format suitable for publication...')
fontsize_sml=7;
fontsize_med=8;
figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.05 0.4 0.8])
set(gca,'FontName','Arial')
% Evoked and Rectified
subplot(5,5,1)
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(4,:),'b-','LineWidth',1)
set(gca,'YDir','reverse'); xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title({[fname,'-',char(lfpstruct.label)],'All Categories'},'FontSize',fontsize_med)
subplot(5,5,6)
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(4,:),'b-','LineWidth',1)
xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Rectified - All Categories','FontSize',fontsize_med)
% Color Plot
subplot(5,5,[11 16 21])
pcolor(xscale(1):xscale(2),1:80,lfpstruct.lfp_average([1:20 61:80 81:100 41:60],:)*-1)
shading flat
hold on
%plot([xscale(1) xscale(end)],[21 21],'k-','LineWidth',1)
%plot([xscale(1) xscale(end)],[41 41],'k-','LineWidth',1)
%plot([xscale(1) xscale(end)],[61 61],'k-','LineWidth',1)
%plot([0 0],[0 100],'k-','LineWidth',1)
colorbar('SouthOutside'); colormap(jet);
text(-250,10,'Faces','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,30,'Body Parts','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,50,'Objects','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,70,'Places','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(0,81.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
set(gca,'FontSize',7); box off; axis off; axis ij; ylim([0 80]); set(gca,'ZDir','reverse');
xlim([-200 400]);

% spectrograms - multitaper
subplot(4,5,2)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(1,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Faces (multitaper)','FontSize',fontsize_med); colormap(jet); axis square; caxis([-20 -5])
subplot(4,5,3)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(2,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Bodyparts (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])
subplot(4,5,7)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(3,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Objects (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])
subplot(4,5,8)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(4,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Places (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])

% Anova Individual Unit
subplot(4,5,[12 13 17 18])
hold on
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),lfpstruct.mtspect_anova'); shading flat;
plot([0 0],[0 120],'k:')
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); axis square
title('Anova on Category (no Fruit)','FontSize',fontsize_med); caxis([0 0.1]); colorbar('SouthOutside'); colormap(jet)

jpgfigname=[hmiconfig.rootdir,filesep,fname,'_rsvp500_JET',char(lfpstruct.label),'.jpg'];
%illfigname=[hmiconfig.rootdir,filesep,fname,'_rsvp500_JET',char(lfpstruct.label),'.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
return

function plot_singleLFP_figureHOT(hmiconfig,xscale,lfpstruct,fname)
disp('....graphing LFP data in a format suitable for publication...')
fontsize_sml=7;
fontsize_med=8;
figure
clf; cla;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.05 0.4 0.8])
set(gca,'FontName','Arial')
% Evoked and Rectified
subplot(5,5,1)
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg(4,:),'b-','LineWidth',1)
set(gca,'YDir','reverse'); xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title({[fname,'-',char(lfpstruct.label)],'All Categories'},'FontSize',fontsize_med)
subplot(5,5,6)
hold on
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(1,:),'r-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(2,:),'y-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(3,:),'g-','LineWidth',1)
plot(xscale(1):xscale(2),lfpstruct.cat_avg_rect(4,:),'b-','LineWidth',1)
xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med);
ylabel('Voltage (mV)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); box off;
title('Rectified - All Categories','FontSize',fontsize_med)
% Color Plot
subplot(5,5,[11 16 21])
pcolor(xscale(1):xscale(2),1:80,lfpstruct.lfp_average([1:20 61:80 81:100 41:60],:)*-1)
shading flat
hold on
plot([xscale(1) xscale(end)],[21 21],'k-','LineWidth',1)
plot([xscale(1) xscale(end)],[41 41],'k-','LineWidth',1)
plot([xscale(1) xscale(end)],[61 61],'k-','LineWidth',1)
plot([0 0],[0 100],'k-','LineWidth',1)
colorbar('SouthOutside'); colormap(jet);
text(-250,10,'Faces','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,30,'Body Parts','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,50,'Objects','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(-250,70,'Places','FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
text(0,81.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
set(gca,'FontSize',7); box off; axis off; axis ij; ylim([0 80]); set(gca,'ZDir','reverse');
xlim([-200 400]);

% spectrograms - multitaper
subplot(4,5,2)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(1,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Faces (multitaper)','FontSize',fontsize_med); colormap(jet); axis square; caxis([-20 -5])
subplot(4,5,3)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(2,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Bodyparts (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])
subplot(4,5,7)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(3,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Objects (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])
subplot(4,5,8)
tmp=log(abs(squeeze(lfpstruct.cat_specgramMT_S_noB(4,:,:))));
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med);
title('Places (multitaper)','FontSize',fontsize_med); axis square; caxis([-20 -5])

% Anova Individual Unit
subplot(4,5,[12 13 17 18])
hold on
pcolor((lfpstruct.cat_specgramMT_T(1,:)-0.4)*1000,lfpstruct.cat_specgramMT_F(1,:),lfpstruct.mtspect_anova'); shading flat;
plot([0 0],[0 120],'k:')
xlabel('Time from stimulus onset (ms)','FontSize',fontsize_med); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',fontsize_med); set(gca,'FontSize',fontsize_med); axis square
title('Anova on Category (no Fruit)','FontSize',fontsize_med); colormap(flipud(hot)); caxis([0 0.1]); colorbar('SouthOutside')

jpgfigname=[hmiconfig.rootdir,filesep,fname,'_rsvp500_HOT',char(lfpstruct.label),'.jpg'];
%illfigname=[hmiconfig.rootdir,filesep,fname,'_rsvp500_HOT',char(lfpstruct.label),'.ai'];
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end
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
