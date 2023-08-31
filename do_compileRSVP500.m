%% do_compileRSVP500
% Started March 13, 2019
% Compiles RSVP500 data into "massiveMatrix
clc; clear; close all;
dbstop if error;

addpath(userpath);
addpath(genpath('~/Documents/MATLAB/Common_Functions'));
warning('off','MATLAB:MKDIR:DirectoryExists');


%% RSVP500
cd /Volumes/untitled/CompleteArchive_March3_2019/__^^LONG-TERM-STORAGE^^/_@_PLEXONDATA_NIH/rsvp500spks
rsvp500_massiveMatrix=struct('name',[],'data',[],'excelData',[],'avgSpden',[]);
% Import details from Excel Spreadsheet
[~,~,rsvp500_massiveMatrix.excelData]=xlsread('/Volumes/untitled/CompleteArchive_March3_2019/__^^LONG-TERM-STORAGE^^/_@_PLEXONDATA_NIH/HMI_PhysiologyNotes.xlsx','RSVP_Cells_Both','A5:AE1300');
unitNum=cell2mat(rsvp500_massiveMatrix.excelData(:,1));
unitNum=unitNum(~isnan(unitNum));

% rsvp500_massiveMatrix.data structure
% 01) Neuron Number
% 02) trial_ID (1) - Condition Number
% 03) trial_ID (2) - Category
% 04) trial_m_baseline
% 05) trial_m_epoch1
% 06) spden_trial
% 07-20) empty
% 21) spden_trial (5000+-500:750)
rsvp500_massiveMatrix.data=[];
for nn=1:length(unitNum)
    clear tempName tempName1 tempData respstructsingle graphstructsingle spikestruct
    %
    tempName1=char(rsvp500_massiveMatrix.excelData(nn,2));
    tempName=[tempName1(1:12),'-',rsvp500_massiveMatrix.excelData{nn,3},'-500_NeuronData.mat'];
    %
    fprintf(['Loading data from ',tempName,' (',num2str(nn),'/',num2str(length(unitNum)),')...'])
    try 
        load(tempName);
    catch
        load([tempName1(1:12),'-',rsvp500_massiveMatrix.excelData{nn,3},'-500responsedata.mat'])
        load([tempName1(1:12),'-',rsvp500_massiveMatrix.excelData{nn,3},'-500graphdata.mat'])
        save(tempName,'respstructsingle','graphstructsingle')
    end
    rsvp500_massiveMatrix.name{nn}=tempName;
    %    
    tempData=[ones(1,length(respstructsingle.trial_m_epoch1))'*nn respstructsingle.trial_id respstructsingle.trial_m_baseline' respstructsingle.trial_m_epoch1'...
        nan(length(respstructsingle.trial_m_epoch1),15)];
    tempData=[tempData graphstructsingle.spden_trial(:,500:1750)]; %#ok<*AGROW>
    rsvp500_massiveMatrix.data=[rsvp500_massiveMatrix.data; tempData];
    rsvp500_massiveMatrix.avgSpden=[rsvp500_massiveMatrix.avgSpden graphstructsingle.allconds_avg];
    fprintf('done.\n')
end
imagesc(rsvp500_massiveMatrix.data(:,21:end));
save('~/Desktop/rsvp500_massiveMatrix.mat','rsvp500_massiveMatrix','-v7.3')

%% FACES570
clear
cd /Volumes/untitled/CompleteArchive_March3_2019/__^^LONG-TERM-STORAGE^^/_@_PLEXONDATA_NIH/faces570spks
faces570_massiveMatrix=struct('name',[],'data',[],'excelData',[],'avgSpden',[]);
% Import details from Excel Spreadsheet
[~,~,faces570_massiveMatrix.excelData]=xlsread('/Volumes/untitled/CompleteArchive_March3_2019/__^^LONG-TERM-STORAGE^^/_@_PLEXONDATA_NIH/HMI_PhysiologyNotes.xlsx','F570_Neural_Both','A4:AG700');
unitNum=cell2mat(faces570_massiveMatrix.excelData(:,1));
unitNum=unitNum(~isnan(unitNum));


%% faces570_massiveMatrix.data structure
% 01) Neuron Number
% 02) trial_ID (1) - Stimulus Number (Condition Number)
% 03) trial_ID (2) - Expression (1=neutral,2=threat,3=fear,0=object/bodypart)
% 04) trial_ID (3) - Identity (1-8 identity 1-8, 0=object/bodypart)
% 05) trial_ID (4) - Gaze Direction (1=directed,2=averted,0=object/bodypart)
% 06) trial_ID (5) - Category (1=face,2=object,3=bodypart)
% 07) trial_ID (6) - Stimulus repetition
% 08) trial_ID (7) - Category repetition (faces, objects, body-parts)
% 09) trial_ID (8) - Identity repetition (face 1-8)
% 10) trial_ID (9) - Expression repetition (1-3)
% 11) trial_ID (10) - Gaze Direction repetition (1 or 2)
% 12) trial_ID (11) - Stimulus repetition (Correct Only)
% 13) trial_ID (12) - Category repetition (faces, objects, body-parts)
% 14) trial_ID (13) - Identity repetition (face 1-8)
% 15) trial_ID (14) - Expression repetition (1-3)
% 16) trial_ID (15) - Gaze Direction repetition (1 or 2)
% 17) trial_ID (16) - ISI
% 18) trial_m_baseline
% 19) trial_m_epoch1
% 20) spden_trial (5000+-500:750)

for nn=1:length(unitNum)
    clear tempName tempName1 tempData respstructsingle graphstructsingle spikestruct
    %
    tempName1=char(faces570_massiveMatrix.excelData(nn,2));
    tempName=[tempName1(1:12),'-',faces570_massiveMatrix.excelData{nn,3},'-570'];
    %
    fprintf(['Loading data from ',tempName,' (',num2str(nn),'/',num2str(length(unitNum)),')...'])
    load([tempName,'responsedata.mat'])
    load([tempName,'graphdata.mat'])
    faces570_massiveMatrix.name{nn}=tempName;
    %    
    tempData=[ones(1,length(respstructsingle.trial_m_epoch1))'*nn respstructsingle.trial_id respstructsingle.trial_m_baseline' respstructsingle.trial_m_epoch1'];
    tempData=[tempData graphstructsingle.spden_trial(:,500:1750)]; %#ok<*AGROW>
    faces570_massiveMatrix.data=[faces570_massiveMatrix.data; tempData];
    faces570_massiveMatrix.avgSpden=[faces570_massiveMatrix.avgSpden graphstructsingle.allconds_avg];
    fprintf('done.\n')
end
imagesc(faces570_massiveMatrix.avgSpden(:,21:end)');
save('~/Desktop/faces570_massiveMatrix.mat','faces570_massiveMatrix','-v7.3')
