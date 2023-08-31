function rejects=plx500_LFPs_trim(filez)
%%%%%%%%%%%%%%%%%%%%%%%
% plx500_LFPs(files); %
%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, May, 2009
% Removes excess spectrograms from LFP files

%%% SETUP DEFAULTS
warning off;
%close all
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=500; % list of paradigm numbers
xscale=[-400 700]; % default time window for LFPs, +/-400ms from stim onset/offset
channels={'LFP1','LFP2','LFP3','LFP4'};
%%% CURRENT METRICS (used to define "response")
rect_epoch=[50 300]; % same as spikes

disp('******************************************************************************')
disp('plx500_LFPs_trim.m - Removes trial spectrograms (to save spacetime) (May 2009)')
disp('******************************************************************************')
%%%  LOAD FILE LIST
disp('Loading filenames...')
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
for f=1:length(filez), % perform following operations on each nex file listed
    close all
    filename=char(filez(f));
    disp(['Trimming LFP structures from ',filename])
    chan_anal=[];
    for ch=1:length(channels),
        % See if channel exists in CORRECTED directory
        corrname=strcat(hmiconfig.LFPdir_corr,filez(f),'-',channels(ch),'c.mat');
        if exist(char(corrname))==2, chan_anal=[chan_anal ch]; end
    end
    disp(['.found ',num2str(length(chan_anal)),' LFP channels...'])
    %%% Begin channel analysis
    for ch=1:length(chan_anal), % scroll through each channel
        chan=channels(chan_anal(ch)); % channel name
        %%% load previously generated LFPSTRUCTSINGLE
        outputfname = [hmiconfig.rsvp500lfps_lrg,filename,'-500-',char(chan),'.mat'];
        disp(['..loading local field potential data for ',char(chan),'...'])
        load(outputfname);
        %%%% TRIM FIELDS %%%%
        lfpstructsingle_trim=rmfield(lfpstructsingle,{...
            'trial_specgramMT_S_noB','cat_specgramMT_S_noB'});

        %%% save data into single files per channel
        outputfname_sml = [hmiconfig.rsvp500lfps,filename,'-500-',char(chan),'.mat'];
        disp(['....saving local field potential data for ',char(chan),'...'])
        save(outputfname_sml,'lfpstructsingle_trim');
        clear lfpstructsingle
    end
end % filez loop
return

%%%%%%%%%% NESTED FUNCTIONS %%%%%%%%%%

