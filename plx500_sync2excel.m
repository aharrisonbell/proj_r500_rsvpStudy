function plx500_syncexcel(rownums,sheetinitial,option);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_syncexcel(files,sheetinitial,option) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, June2008
% FILES: Can be range of numbers referring to the EXCEL row numbers
% SHEETINITIAL: First letter of the monkey whose data you wish to sync
% OPTION: Specifics direction of sync ('TO' Excel/'FROM' Excel Only)

% Syncs data between the RESPSTRUCT structure created by plx500
% and the Excel spreadsheet storing all the data.  Currently, the program
% performs the following operations:
% TO EXCEL
% - automated neuron type (sensory, inhibited, non-responsive)
% - automated preferred category (faces, fruit, places, objects, body-parts)
% - automated selective type (selective, non-selective)
% - automated response type (excite, inhibit, both)
% TO RESPSTRUCT (output to *-responsedata2.mat)
% - Grid location (respstruct.gridlocation)
% - Depth (respstruct.depth)
% - A/P Index (respstruct.APIndex)
% - CONFIRMED COLUMNS: (based on visual confirmation of automated process)
%   J5:J700 - Confirmed Sensory (Sensory vs. Non-Responsive)
%   L5:J700 - Confirmed Preferred Category (based on visual inspection)
%   N5:J700 - Confirmed Category-Selective (based on visual inspection)
%   P5:J700 - Confirmed Excite/Inhibit/Both
%   Q5:Q700 - Quality
% sheetname (optional) = name of the sheet within the default excel file
% that contains the list of neurons to be analyzed.  note that it MUST have
% the same structure (i.e., column headers) as the default sheet (DMS
% Cells)

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin==0, error('You must specify at least ROWNUMS (min:5) and MONKEY_INITIAL'); end
if nargin==2, option='BOTH'; end
if sheetinitial=='S', sheetname='RSVP Cells_S'; elseif sheetinitial=='W', sheetname='RSVP Cells_W'; end
if rownums(1)<5, error('You have entered a row number below 5.  The first row number must be greater than 4.'); end
    
disp('Loading data from Excel spreadsheet...')
tic
[crap,xldata.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,['B',num2str(rownums(1)),':B',num2str(rownums(end))]); % alpha, PlexonFilename
[crap,xldata.UnitName]=xlsread(hmiconfig.excelfile,sheetname,['C',num2str(rownums(1)),':C',num2str(rownums(end))]); % alpha, Unitname
[crap,xldata.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,['E',num2str(rownums(1)),':E',num2str(rownums(end))]); % alphanumeric, Gridlocation
xldata.Depth=xlsread(hmiconfig.excelfile,sheetname,['F',num2str(rownums(1)),':F',num2str(rownums(end))]); % numeric, Depth
[crap,xldata.APIndex]=xlsread(hmiconfig.excelfile,sheetname,['G',num2str(rownums(1)),':G',num2str(rownums(end))]); % alphanumeric, APindex
[crap,xldata.NeurType]=xlsread(hmiconfig.excelfile,sheetname,['J',num2str(rownums(1)),':J',num2str(rownums(end))]); % alphanumeric, neuron type
[crap,xldata.ConfPref]=xlsread(hmiconfig.excelfile,sheetname,['L',num2str(rownums(1)),':L',num2str(rownums(end))]); % alphanumeric, pref category
[crap,xldata.ConfSele]=xlsread(hmiconfig.excelfile,sheetname,['N',num2str(rownums(1)),':N',num2str(rownums(end))]); % alphanumeric, conf selective
[crap,xldata.ConfExci]=xlsread(hmiconfig.excelfile,sheetname,['P',num2str(rownums(1)),':P',num2str(rownums(end))]); % alphanumeric, conf excite
xldata.ConfQuality=xlsread(hmiconfig.excelfile,sheetname,['Q',num2str(rownums(1)),':Q',num2str(rownums(end))]); % alphanumeric, quality
xldata.wf_include=xlsread(hmiconfig.excelfile,sheetname,['AA',num2str(rownums(1)),':AA',num2str(rownums(end))]); % numeric
[crap,xldata.wf_type]=xlsread(hmiconfig.excelfile,sheetname,['AB',num2str(rownums(1)),':AB',num2str(rownums(end))]); % alphanumeric, conf excite
xldata.wf_autoinclude=xlsread(hmiconfig.excelfile,sheetname,['AC',num2str(rownums(1)),':AC',num2str(rownums(end))]); % numeric
toc

%%% from EXCEL to MATLAB
if strcmp(option,'BOTH')==1|strcmp(option,'FROM')==1,
    disp('Transferring data:  Excel --> Matlab')
    for un=1:size(xldata.PlxFile,1),
        % Load individual file
        newname=char(xldata.PlxFile(un)); newunit=char(xldata.UnitName(un));
        disp(['...',newname(1:12),'-',newunit,'...'])
        load([hmiconfig.rsvp500spks,filesep,newname(1:12),'-',newunit,'-500responsedata.mat']);
        % Paste Excel data into Matlab File
        respstructsingle.gridlocation=xldata.GridLoc(un);
        respstructsingle.depth=xldata.Depth(un);
        respstructsingle.APIndex=xldata.APIndex(un);
        respstructsingle.conf_neurtype=xldata.NeurType(un);
        respstructsingle.conf_preferred_cat=xldata.ConfPref(un);
        respstructsingle.conf_selective=xldata.ConfSele(un);
        respstructsingle.conf_excite=xldata.ConfExci(un);
        respstructsingle.quality=xldata.ConfQuality(un);
        respstructsingle.wf_include=xldata.wf_include(un);
        respstructsingle.wf_type=xldata.wf_type(un);
        respstructsingle.wf_autoinclude=xldata.wf_autoinclude(un);
        respstructsingle.datemodified=date;
        save([hmiconfig.rsvp500spks,filesep,newname(1:12),'-',newunit,'-500responsedata.mat'],'respstructsingle');
    end
end

%%% to EXCEL from MATLAB
if strcmp(option,'BOTH')==1|strcmp(option,'TO')==1,
    disp('Transferring data:  Excel <-- Matlab')
    for un=1:size(xldata.PlxFile,1),
        % Load individual file
        newname=char(xldata.PlxFile(un)); newunit=char(xldata.UnitName(un));
        disp(['...',newname(1:12),'-',newunit,'...'])
        load([hmiconfig.rsvp500spks,filesep,newname(1:12),'-',newunit,'-500responsedata.mat']);
        % Define automatic classifications
        if isempty(find(respstructsingle.cat_sensory(:,2)<=0.05))~=1, % determine if there was a significant response in any category
            if max(respstructsingle.cat_avg_nobase(:,2))<=0, neurontype='Sensory'; % neurontype='Inhibited';
            elseif max(respstructsingle.cat_avg_nobase(:,2))>0, neurontype='Sensory';
            else neurontype='Non-Responsive';
            end
        else neurontype='Non-Responsive';
        end
        excite=respstructsingle.excitetype;
        prefcat=respstructsingle.preferred_category;
        prefexcite=respstructsingle.pref_excite;
        prefinhibit=respstructsingle.pref_inhibit;
        if respstructsingle.anova_epoch(1,2)<=0.05, % determine if ANOVA for category responses is significant
            selective='Selective';
        else selective='Not Selective';
        end
        disp(['......neuron type: ',neurontype])
        disp(['......preferred category: ',prefcat])
        disp(['......selective?: ',selective])
        disp(['......excite/inhibit?: ',excite])
        xldata.auto_neurontype(un)={neurontype};
        xldata.auto_prefcat(un)={prefcat};
        xldata.auto_selective(un)={selective};
        xldata.auto_excite(un)={excite};
        xldata.pref_excite(un)={prefexcite};
        xldata.pref_inhibit(un)={prefinhibit};
    end
    xlswrite(hmiconfig.excelfile,xldata.auto_neurontype',sheetname,['I',num2str(rownums(1)),':I',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,xldata.auto_prefcat',sheetname,['K',num2str(rownums(1)),':K',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,xldata.auto_selective',sheetname,['M',num2str(rownums(1)),':M',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,xldata.auto_excite',sheetname,['O',num2str(rownums(1)),':O',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,xldata.pref_excite',sheetname,['AD',num2str(rownums(1)),':AD',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,xldata.pref_inhibit',sheetname,['AE',num2str(rownums(1)),':AE',num2str(rownums(end))])
end
return
