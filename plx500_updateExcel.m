function plx500_updateExcel(startdate,startrow,monkinitial);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_updateExcel(files,sheetinitial,option) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, February 2010, Based on plx500_syncexcel
% ROWNUM: Starting point to paste new units
% DATE: Starting date to paste new units
% SHEETINITIAL: First letter of the monkey whose data you wish to sync

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
if nargin<3, error('You must specify DATE (in char format), STARTROW, and MONKEY_INITIAL'); end
if monkinitial=='S', sheetname='RSVP Cells_S'; monkeyname='Stewie'; elseif monkinitial=='W', sheetname='RSVP Cells_W'; monkeyname='Wiggum'; end

%%% Load Recording Notes
plx_importrecordingnotes(monkinitial);
temp=load([hmiconfig.rootdir,filesep,monkeyname,'_RecordingNotes.mat']);
recordnotes=temp.xldata; clear temp

%%% Generate list of existing unit names currently in Excel spreadsheet
[crap,xldata.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,['B4:B1000']); % alpha, PlexonFilename
[crap,xldata.UnitName]=xlsread(hmiconfig.excelfile,sheetname,['C4:C1000']); % alpha, Unitname

%%% Find list of units that are after StartDate
disp('...Scanning RSVP500 directory...')
dd=dir(hmiconfig.rsvp500spks);
numfiles=size(dd,1); fnames=[];
for nf=3:numfiles,
    if length(dd(nf).name)>26, % if filename is not proper length, skip it
        if strcmp(dd(nf).name(1),monkinitial)==1 && strcmp(dd(nf).name(25),'r')==1,
            % Correct date:
            if str2num(dd(nf).name(5:6))==str2num(startdate(1:2)),
                if str2num(dd(nf).name(7:8))==str2num(startdate(3:4)),
                    if str2num(dd(nf).name(9:10))>str2num(startdate(5:6)),
                        fnames=[fnames;dd(nf).name];
                    end; end; end; end; end
end
numfiles=size(fnames,1); % Number of MONKEY specific files

%%% Paste unitnames and data into Excel
disp('Transferring data:  Matlab --> Excel')
disp('...Loading data from individual files...')
xldata=[]; 
for nf=1:numfiles,
    xldata.plx_fname(nf)={fnames(nf,1:12)};
    xldata.unit_id(nf)={fnames(nf,14:20)};
    % Load Data File
    
    %%%%% MAY NEED TO CHANGE AFTER APPEND
    load([hmiconfig.rsvp500spks,fnames(nf,:)]);
    xldata.neurontype(nf)={respstructsingle.excitetype_nofruit};
    xldata.prefcat(nf)={respstructsingle.prefcat_excite_nofruit};
    xldata.autoresptype(nf)={respstructsingle.excitetype_nofruit};
    xldata.autocatselect(nf)={respstructsingle.selective_nofruit};
    xldata.prefcat_excite_nofruit(nf)={respstructsingle.prefcat_excite_nofruit};
    xldata.prefcat_inhibit_nofruit(nf)={respstructsingle.prefcat_inhibit_nofruit};
    
    %%% Determine grid and depth
    newname=char(xldata.plx_fname(nf)); newunit=char(xldata.unit_id(nf));
    % Find matching entry
    file_num=find(strcmp(recordnotes.PlxFile,[newname,'.plx']));
    unit_id=char(newunit(6));
    % Find Gridloc & depth
    gridloc=eval(['recordnotes.Grid',num2str(unit_id),'(',num2str(file_num(1)),')']);
    %depth=eval(['recordnotes.Depth',num2str(unit_id),'(',num2str(file_num(1)),')']);
    % Paste GridLoc & depth
    respstructsingle.gridloc=gridloc;
    respstructsingle.datemodified=date;
    xldata.gridloc(nf)=gridloc;
    save([hmiconfig.rsvp500spks,filesep,fnames(nf,:)],'respstructsingle');


    
    clear respstructsingle
end





disp('...Pasting data into EXCEL spreadsheet...');
xlswrite(hmiconfig.excelfile,xldata.plx_fname',sheetname,['B',num2str(startrow),':B',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.unit_id',sheetname,['C',num2str(startrow),':C',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.gridloc',sheetname,['E',num2str(startrow),':E',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.neurontype',sheetname,['I',num2str(startrow),':I',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.prefcat',sheetname,['K',num2str(startrow),':K',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.autoresptype',sheetname,['O',num2str(startrow),':O',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.autocatselect',sheetname,['M',num2str(startrow),':M',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.prefcat_excite_nofruit',sheetname,['AD',num2str(startrow),':AD',num2str(startrow+numfiles-1)])
xlswrite(hmiconfig.excelfile,xldata.prefcat_inhibit_nofruit',sheetname,['AE',num2str(startrow),':AE',num2str(startrow+numfiles-1)])
disp('Task complete.');

	
