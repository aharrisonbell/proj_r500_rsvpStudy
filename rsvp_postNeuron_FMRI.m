function output=rsvp_postNeuron_FMRI(monkinitial)
% function output=rsvp_postNeuron_FMRI(monkinitial)
% by AHB, June 2010
% Function to load fMRI data and generate 'fmristruct'

warning off; close all;
hmiconfig=generate_hmi_configplex;
fmridata_dir='Z:\Desktop\RSVP_JN_Revision\fMRI_Data\';

disp('**************************************************************')
disp('* rsvp_postNeuron_FMRI.m - Imports fMRI data into Matlab and *')
disp('*   compares to spiking activity/LFP data.                   *')
disp('*   Will likely be called from within rsvp_postNeuron.m      *')
disp('*   SPECIFIC FOR AFTER NEURON SUBMISSION.                    *')
disp('**************************************************************')

% Data structure = average time series for each voxel
%   1-16 scrambled
%  17-32 faces
%  33-48 scrambled 
%  49-64 bodyparts
%  65-80 scrambled
%  81-96 objects
% 97-112 scrambled
%113-128 places
%129-144 scrambled

if monkinitial=='S',
    fmridata=BrikLoad([fmridata_dir,'Stewie_Group',filesep,'Stewie_Norm_AllConds2MION+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'Stewie_fMRIstruct.mat'],'fmridata');
    
    monkeyname='Stewie'; sheetname='RSVP Cells_S';
    stewsampledlocations={'A7R1','A7L1','A7L2','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4R1','A4L1','A4L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'};

    % Grid location groups for comparison
    grp(1).grids={'A7L2','A7L1','A6L3'}; % BodyPart Selective
    grp(2).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Face Selective
    grp(3).grids={'A4L2','A4L1','A4R1'}; % No Category Selectivity
    grp(4).grids={'A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4', 'P4L2','P4L4','P5L3','P6L3'}; % Object Selective
    grp(5).grids={'P6L2','P6L1','P7L2'}; % Face Selective
    
    % Grid location groups for comparison
    grpf(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
    grpf(2).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
    grpf(3).grids={'A6L2','A6L0','A5L2','A5L1','A5L0','P6L2','P6L1','P7L2'}; % Inside All
    grpf(4).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1','A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P5L3','P6L3'}; % Outside All Face Selective
    grpbp(1).grids={'A7L2','A7L1'}; % Inside Bodypart Selective
    grpbp(2).grids={'A7R1','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4R1','A4L1','A4L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Outside All Bodypart Selective
    grpob(1).grids={'A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L2'}; % Inside Object Selective
    grpob(2).grids={'A7R1','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4R1','A4L1','A4L2','A4L3','P5L0','P6L1','P6L3','P7L2'}; % Outside All Object Selective
    grppl(1).grids={'A4L2','A4L1','A4R1','A7R1'}; % Non Category Selective
    grppl(2).grids={'A7L2','A7L1','A6L2','A6L0','A5L2','A5L1','A5L0','A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L3','P6L2','P6L1','P7L2'}; % Category Selective
 
    grpfnf(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
    grpfnf(2).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1'}; % Near Face Selective (Anterior)
    grpfnf(3).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
    grpfnf(4).grids={'P4L2','P4L4','P5L2','P5L3','P6L3','P5L0'}; % Near Face Selective (Posterior)
    grpfnf(5).grids={'A7R1','A7L1','A7L2','A6L3','A4R1','A4L1','A4L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Outside Face Selective (All)
    grpbpnf(1).grids={'A7L2','A7L1','A6L3'}; % Inside Bodypart Selective
    grpbpnf(2).grids={'A7R1','A6L2','A6L0','A5L2','A5L1','A5L0','A4L2','A4L1','A4R1',}; % Near Bodypart Selective
    grpbpnf(3).grids={'A7R1','A6L0','A6L2','A5L0','A5L1','A5L2','A4R1','A4L1','A4L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Outside BodySelective
    grpobnf(1).grids={'A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L2'}; % Inside Object Selective
    grpobnf(2).grids={'A4L3','A4L2','A4L1','A4R1','P6L3','P6L1','P7L2'}; % Near Object Selective
    grpobnf(3).grids={'A7R1','A7L1','A7L2','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4R1','A4L1','A4L2','A4L3','P5L0','P6L1','P6L3','P7L2'}; % Outside All Object Selective
    grpplnf(1).grids={'A4L2','A4L1','A4R1','A7R1'}; % Non Category Selective
    grpplnf(2).grids={'A7L2','A7L1','A6L2','A6L0','A5L2','A5L1','A5L0','A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L3','P6L2','P6L1','P7L2'}; % Category Selective
    grpplnf(3).grids={'A7L1','A7L2','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Category Selective
 
    % In Near Far
    grpfnf(1).grids={'A6L2','A6L0','A5L2','A5L1','A5L0'}; % Anterior Face Selective
    grpfnf(2).grids={'A7L2','A7L1','A7R1','A4L2','A4L1','A4R1'}; % Near Face Selective (Anterior)
    grpfnf(3).grids={'P6L2','P6L1','P7L2'}; % Posterior Face Selective
    grpfnf(4).grids={'P4L2','P4L4','P5L2','P5L3','P6L3','P5L0'}; % Near Face Selective (Posterior)
    grpfnf(5).grids={'A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5'}; % Outside Face Selective (All)    
    grpbpnf(1).grids={'A7L2','A7L1','A6L3'}; % Inside Bodypart Selective
    grpbpnf(2).grids={'A7R1','A6L2','A6L0','A5L2','A5L1','A5L0','A4L2','A4L1','A4R1',}; % Near Bodypart Selective
    grpbpnf(3).grids={'A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Outside BodySelective
    grpobnf(1).grids={'A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L2'}; % Inside Object Selective
    grpobnf(2).grids={'A4L3','A4L2','A4L1','A4R1','P6L3','P6L1','P7L2'}; % Near Object Selective
    grpobnf(3).grids={'A7R1','A7L1','A7L2','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','P5L0'}; % Outside All Object Selective
    grpplnf(1).grids={'A4L2','A4L1','A4R1','A7R1'}; % Non Category Selective
    grpplnf(2).grids={'A7L2','A7L1','A6L2','A6L0','A5L2','A5L1','A5L0','A2L5','A0L6','A0L2','A0L0','P1L1','P2L3','P3L5','P3L4','P4L2','P4L4','P5L3','P6L3','P6L2','P6L1','P7L2'}; % Category Selective
    grpplnf(3).grids={'A7L1','A7L2','A6L0','A6L2','A6L3','A5L0','A5L1','A5L2','A4L3','A2L5','A0L0','A0L2','A0L6','P1L1','P2L3','P3L4','P3L5','P4L2','P4L4','P5L0','P5L3','P6L1','P6L2','P6L3','P7L2'}; % Category Selective
elseif monkinitial=='W'
    fmridata=BrikLoad([fmridata_dir,'Wiggum_Group',filesep,'Wiggum_Norm_AllCondsMION+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'Wiggum_fMRIstruct.mat'],'fmridata');
    
    monkeyname='Wiggum'; sheetname='RSVP Cells_W';
    wiggsampledlocations={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'};
   
    grp(1).grids={'A7R0','A7L1','A6L1'}; %  Places
    grp(2).grids={'A0R0','A0R1','A1R0','A2R1','A3R0'}; % Faces
    grp(3).grids={'P1R0','P1R3'}; % Bodyparts
    grp(4).grids={'P3R0','P3R2'}; % Objects
    grp(5).grids={'P7R0','P7R2'}; %  Face Selective
    % Grid location groups for comparison
    grpf(1).grids={'A0R0','A0R1','A1R0','A2R1','A3R0'}; % Anterior Face Selective
    grpf(2).grids={'P7R0','P7R2'}; % Posterior Face Selective
    grpf(3).grids={'A0R0','A0R1','A1R0','A2R1','A3R0','P7R0','P7R2'}; % Inside All
    grpf(4).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R2','A2R3','A2R5','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0'}; % Outside Face Selective
    grpbp(1).grids={'P1R0','P1R3'}; % Inside Bodypart Selective
    grpbp(2).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Bodypart Selective
    grpob(1).grids={'P3R0','P3R2'}; % Inside Object Selective
    grpob(2).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Object Selective
    grppl(1).grids={'A7R0','A7L1','A6L1'}; % Inside Place Category Selective
    grppl(2).grids={'A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Place Selective
    grpfnf(1).grids={'A0R0','A0R1','A1R0','A2R1','A3R0'}; % Anterior Face Selective
    grpfnf(2).grids={'A5R0','A4R3','A3R2','A2R3','A2R5','P1R0','P1R3'}; % Near Face Selective (Anterior)
    grpfnf(3).grids={'P7R0','P7R2'}; % Posterior Face Selective
    grpfnf(4).grids={'P4R1','P5R0','P6R0','P7R0','P7R2'}; % Near Face Selective (Posterior)
    grpfnf(5).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R2','A2R3','A2R5','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0'}; % Outside all Face Selective
    grpbpnf(1).grids={'P1R0','P1R3'}; % Inside Bodypart Selective
    grpbpnf(2).grids={'A2R1','A1R0','A0R0','A0R1','P3R0','P3R2'}; % Near Bodypart Selective
    grpbpnf(3).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Bodypart Selective 
    grpobnf(1).grids={'P3R0','P3R2'}; % Inside Object Selective
    grpobnf(2).grids={'A0R0','A0R1','P1R0','P1R3','P4R1','P5R0'}; % Near Object Selective
    grpobnf(3).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside Object Selective
    grpplnf(1).grids={'A7R0','A7L1','A6L1'}; % Inside Place Category Selective
    grpplnf(2).grids={'A6R2','A5R0','A4R3'}; % Near Place Category Selective
    grpplnf(3).grids={'A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Category Selective
    % In Near Far
    grpfnf(1).grids={'A0R0','A0R1','A1R0','A2R1','A3R0'}; % Anterior Face Selective
    grpfnf(2).grids={'A5R0','A4R3','A3R2','A2R3','A2R5','P1R0','P1R3'}; % Near Face Selective (Anterior)
    grpfnf(3).grids={'P7R0','P7R2'}; % Posterior Face Selective
    grpfnf(4).grids={'P4R1','P5R0','P6R0','P7R0','P7R2'}; % Near Face Selective (Posterior)
    grpfnf(5).grids={'A7L1','A7R0','A6L1','A6R2','P3R0','P3R2'}; % Outside all Face Selective
    grpbpnf(1).grids={'P1R0','P1R3'}; % Inside Bodypart Selective
    grpbpnf(2).grids={'A2R1','A1R0','A0R0','A0R1','P3R0','P3R2'}; % Near Bodypart Selective
    grpbpnf(3).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R3','A2R5','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Bodypart Selective 
    grpobnf(1).grids={'P3R0','P3R2'}; % Inside Object Selective
    grpobnf(2).grids={'A0R0','A0R1','P1R0','P1R3','P4R1','P5R0'}; % Near Object Selective
    grpobnf(3).grids={'A7L1','A7R0','A6L1','A6R2','A5R0','A4R3','A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','P6R0','P7R0','P7R2'}; % Outside Object Selective
    grpplnf(1).grids={'A7R0','A7L1','A6L1'}; % Inside Place Category Selective
    grpplnf(2).grids={'A6R2','A5R0','A4R3'}; % Near Place Category Selective
    grpplnf(3).grids={'A3R0','A3R2','A2R1','A2R3','A2R5','A1R0','A0R0','A0R1','P1R0','P1R3','P3R0','P3R2','P4R1','P5R0','P6R0','P7R0','P7R2'}; % Outside All Category Selective
end

%%% Load Spike Data
disp('Loading data for all neurons...')
[data,numgrids,counts_matrix,allunits,unit_index,unitdata]=plx500_prepproject1data(hmiconfig,sheetname);
save([hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'Project1Data_',monkeyname,'.mat'],'data','unit_index','unitdata');



%%% FIGURES
% Figure(s) 1 - Average Time Series for Each ROI
disp('Figure(s) 1 Average Time Series for Each ROI')
maxroi=10; bufferlead=2;
categories={'Faces','BodyParts','Objects','Places'}; 
fmri_rsp=struct('responses',zeros(1,4));
path = ['\\.psf\Home\Desktop\RSVP_JN_Revision\fMRI_Data\',monkeyname,'_Group\MatLab_Data\'];
cd(path)
for cc=1:4,
    figure; clf; cla; set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8]); set(gca,'FontName','Arial','FontSize',8)
    for rr=1:maxroi,
        data=load([path,monkeyname,'_',char(categories(cc)),'Map_ROI',num2str(rr),'_norm.1D']);
        if isempty(data)~=1,
            subplot(5,2,rr); hold on
            plot(data,'b-','LineWidth',2)
            blocklength=length(data)/9;
            set(gca,'XTick',0:blocklength:length(data))
            for bl=0:blocklength:length(data), plot([bl bl],[-2 5],'k:','LineWidth',0.5); end
            xlabel('TRs')
            ylabel('MION Response (% Change)')
            if monkinitial=='S',
                text(1,2.6,'Scrambled','FontSize',8,'FontName','Helvetica')
                text(17,2.6,'Faces','FontSize',8,'FontName','Helvetica')
                text(33,2.6,'Scrambled','FontSize',8,'FontName','Helvetica')
                text(49,2.6,'BodyParts','FontSize',8,'FontName','Helvetica')
                text(65,2.6,'Scrambled','FontSize',8,'FontName','Helvetica')
                text(81,2.6,'Objects','FontSize',8,'FontName','Helvetica')
                text(97,2.6,'Scrambled','FontSize',8,'FontName','Helvetica')
                text(113,2.6,'Places','FontSize',8,'FontName','Helvetica')
                text(129,2.6,'Scrambled','FontSize',8,'FontName','Helvetica')
            end

            xlim([0 length(data)]);
            %ylim([-2.2 3.1]);
            title([monkeyname,' ',char(categories(cc)),' - ROI #',num2str(rr)],'FontSize',10,'FontWeight','Bold','Interpreter','None')
            if monkinitial=='S',

                %%% Pull Response Data for next figure
                fmri_rsp(cc).responses(rr,1)=max(data(17+bufferlead:17+blocklength)); % face response
                fmri_rsp(cc).responses(rr,2)=max(data(49+bufferlead:49+blocklength)); % bodypart response
                fmri_rsp(cc).responses(rr,3)=max(data(81+bufferlead:81+blocklength)); % object response
                fmri_rsp(cc).responses(rr,4)=max(data(113+bufferlead:113+blocklength)); % place response
            end
        end
    end
    jpgfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig1_ROITimeSeries_',monkeyname,'_',char(categories(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig1_ROITimeSeries_',monkeyname,'_',char(categories(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end


% Figure 2 - Category Selectivity for Each ROI
disp('Figure 2 Category Selectivity for Each ROI')
figure; clf; cla; set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8]); set(gca,'FontName','Arial','FontSize',8)
%%% MAY EVENTUALLY CHANGE THIS ANALYSIS TO MEASURE RESPONSE FROM EACH
%%% BLOCK, NOT FROM THE AVERAGE TIME SERIES
pref=[1 2 3 4]; categories={'Faces','BodyParts','Objects','Places'}; 
for cc=1:4,
    subplot(2,2,cc)
    numrois=size(fmri_rsp(cc).responses,1); bardata=zeros(numrois,1);
    for rr=1:numrois,
        Rp=fmri_rsp(cc).responses(rr,cc);
        Rnp=sum(fmri_rsp(cc).responses(rr,pref~=cc))/3;
        bardata(rr)=(Rp-Rnp)/(Rp+Rnp);
    end

    bar([bardata ; mean(bardata)]);
    xlabel('ROI #'); ylabel(['Average ',char(categories(cc)),' SI'])
    title([char(categories(cc)),' ROIs']); ylim([0 0.75]);
    text(length(bardata)+1,0.7,'AVERAGE','HorizontalAlignment','Center');
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig2_ROITimeSeries_',monkeyname,'_',char(categories(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig2_ROITimeSeries_',monkeyname,'_',char(categories(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)


% Figure 3 - Average Time Series for Each Patch within recording grid
disp('Figure 3 Average Time Series for Each Patch within recording grid')
figure; clf; cla; set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8]); set(gca,'FontName','Arial','FontSize',8)
fmri_faces=struct('responses',[],'average',[]);
fmri_bodyparts=struct('responses',[],'average',[]);
fmri_objects=struct('responses',[],'average',[]);
fmri_places=struct('responses',[],'average',[]);

for pp=1:5,
    subplot(4,5,pp); hold on; % Faces IN NEAR OUT
    temp_pointer=find(ismember(unit_index.GridLoc,grpfnf(pp).grids)==1 & strcmp(unit_index.SensoryConf,'Sensory')==1);
    temp_coords=unique(unit_index.APcoords(temp_pointer,:),'Rows');
    temp_data=[];
    for tc=1:size(temp_coords,1),
        temp_afni_coords(tc,1:3)=rsvp_apml2xyz(monkinitial,temp_coords(tc,:));
    end
    temp_fmri_locs=unique(temp_afni_coords,'Rows');
    for tf=1:size(temp_fmri_locs,1),
        newdata=squeeze(fmridata(temp_fmri_locs(tf,1),temp_fmri_locs(tf,2),temp_fmri_locs(tf,3),:))';
        temp_data=[temp_data;newdata];
        fmri_faces(pp).responses(tf,1)=max(newdata(17+bufferlead:17+blocklength)); % face response
        fmri_faces(pp).responses(tf,2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
        fmri_faces(pp).responses(tf,3)=max(newdata(81+bufferlead:81+blocklength)); % object response
        fmri_faces(pp).responses(tf,4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    end
    newdata=mean(temp_data,1);
    plot(newdata);
    fmri_faces(pp).average(1)=max(newdata(17+bufferlead:17+blocklength)); % face response
    fmri_faces(pp).average(2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
    fmri_faces(pp).average(3)=max(newdata(81+bufferlead:81+blocklength)); % object response
    fmri_faces(pp).average(4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    plot([16 16],[-2 3],'k:','LineWidth',0.5); plot([32 32],[-2 3],'k:','LineWidth',0.5);
    plot([48 48],[-2 3],'k:','LineWidth',0.5); plot([64 64],[-2 3],'k:','LineWidth',0.5);
    plot([80 80],[-2 3],'k:','LineWidth',0.5); plot([96 96],[-2 3],'k:','LineWidth',0.5);
    plot([112 112],[-2 3],'k:','LineWidth',0.5); plot([128 128],[-2 3],'k:','LineWidth',0.5);
    xlim([0 145]); ylim([-2 3]); ylabel('% Signal Change'); xlabel('#TRs');
    title(['Faces - Patch #',num2str(pp),'(',num2str(size(temp_data,1)),')'],'FontSize',8,'FontWeight','Bold')
    clear temp_fmri_locs temp_afni_coords temp_pointer temp_coords newdata
end

for pp=1:3,
    subplot(4,3,pp+3); hold on; % Bodyparts IN NEAR OUT
    temp_pointer=find(ismember(unit_index.GridLoc,grpbpnf(pp).grids)==1 & strcmp(unit_index.SensoryConf,'Sensory')==1);
    temp_coords=unique(unit_index.APcoords(temp_pointer,:),'Rows');
    temp_data=[];
    for tc=1:size(temp_coords,1),
        temp_afni_coords(tc,1:3)=rsvp_apml2xyz(monkinitial,temp_coords(tc,:));
    end
    temp_fmri_locs=unique(temp_afni_coords,'Rows');
    for tf=1:size(temp_fmri_locs,1),
        newdata=squeeze(fmridata(temp_fmri_locs(tf,1),temp_fmri_locs(tf,2),temp_fmri_locs(tf,3),:))';
        temp_data=[temp_data;newdata];
        fmri_bodyparts(pp).responses(tf,1)=max(newdata(17+bufferlead:17+blocklength)); % face response
        fmri_bodyparts(pp).responses(tf,2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
        fmri_bodyparts(pp).responses(tf,3)=max(newdata(81+bufferlead:81+blocklength)); % object response
        fmri_bodyparts(pp).responses(tf,4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    end
    newdata=mean(temp_data,1);
    plot(newdata);
    fmri_bodyparts(pp).average(1)=max(newdata(17+bufferlead:17+blocklength)); % face response
    fmri_bodyparts(pp).average(2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
    fmri_bodyparts(pp).average(3)=max(newdata(81+bufferlead:81+blocklength)); % object response
    fmri_bodyparts(pp).average(4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    plot([16 16],[-2 3],'k:','LineWidth',0.5); plot([32 32],[-2 3],'k:','LineWidth',0.5);
    plot([48 48],[-2 3],'k:','LineWidth',0.5); plot([64 64],[-2 3],'k:','LineWidth',0.5);
    plot([80 80],[-2 3],'k:','LineWidth',0.5); plot([96 96],[-2 3],'k:','LineWidth',0.5);
    plot([112 112],[-2 3],'k:','LineWidth',0.5); plot([128 128],[-2 3],'k:','LineWidth',0.5);
    xlim([0 145]); ylim([-2 3]); ylabel('% Signal Change'); xlabel('#TRs');
    title(['BodyParts - Patch #',num2str(pp),'(',num2str(size(temp_data,1)),')'],'FontSize',8,'FontWeight','Bold')
    clear temp_fmri_locs temp_afni_coords temp_pointer temp_coords newdata
end

for pp=1:3,
    subplot(4,3,pp+6); hold on; % Objects IN NEAR OUT
    temp_pointer=find(ismember(unit_index.GridLoc,grpobnf(pp).grids)==1 & strcmp(unit_index.SensoryConf,'Sensory')==1);
    temp_coords=unique(unit_index.APcoords(temp_pointer,:),'Rows');
    temp_data=[];
    for tc=1:size(temp_coords,1),
        temp_afni_coords(tc,1:3)=rsvp_apml2xyz(monkinitial,temp_coords(tc,:));
    end
    temp_fmri_locs=unique(temp_afni_coords,'Rows');
    for tf=1:size(temp_fmri_locs,1),
        newdata=squeeze(fmridata(temp_fmri_locs(tf,1),temp_fmri_locs(tf,2),temp_fmri_locs(tf,3),:))';
        temp_data=[temp_data;newdata];
        fmri_objects(pp).responses(tf,1)=max(newdata(17+bufferlead:17+blocklength)); % face response
        fmri_objects(pp).responses(tf,2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
        fmri_objects(pp).responses(tf,3)=max(newdata(81+bufferlead:81+blocklength)); % object response
        fmri_objects(pp).responses(tf,4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    end
    newdata=mean(temp_data,1);
    plot(newdata);
    fmri_objects(pp).average(1)=max(newdata(17+bufferlead:17+blocklength)); % face response
    fmri_objects(pp).average(2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
    fmri_objects(pp).average(3)=max(newdata(81+bufferlead:81+blocklength)); % object response
    fmri_objects(pp).average(4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    plot([16 16],[-2 3],'k:','LineWidth',0.5); plot([32 32],[-2 3],'k:','LineWidth',0.5);
    plot([48 48],[-2 3],'k:','LineWidth',0.5); plot([64 64],[-2 3],'k:','LineWidth',0.5);
    plot([80 80],[-2 3],'k:','LineWidth',0.5); plot([96 96],[-2 3],'k:','LineWidth',0.5);
    plot([112 112],[-2 3],'k:','LineWidth',0.5); plot([128 128],[-2 3],'k:','LineWidth',0.5);
    xlim([0 145]); ylim([-2 3]); ylabel('% Signal Change'); xlabel('#TRs');
    title(['Objects - Patch #',num2str(pp),'(',num2str(size(temp_data,1)),')'],'FontSize',8,'FontWeight','Bold')
    clear temp_fmri_locs temp_afni_coords temp_pointer temp_coords newdata
end

for pp=1:3,
    subplot(4,3,pp+9); hold on; % Places IN NEAR OUT
    temp_pointer=find(ismember(unit_index.GridLoc,grpplnf(pp).grids)==1 & strcmp(unit_index.SensoryConf,'Sensory')==1);
    temp_coords=unique(unit_index.APcoords(temp_pointer,:),'Rows');
    temp_data=[];
    for tc=1:size(temp_coords,1),
        temp_afni_coords(tc,1:3)=rsvp_apml2xyz(monkinitial,temp_coords(tc,:));
    end
    temp_fmri_locs=unique(temp_afni_coords,'Rows');
    for tf=1:size(temp_fmri_locs,1),
        newdata=squeeze(fmridata(temp_fmri_locs(tf,1),temp_fmri_locs(tf,2),temp_fmri_locs(tf,3),:))';
        temp_data=[temp_data;newdata];
        fmri_places(pp).responses(tf,1)=max(newdata(17+bufferlead:17+blocklength)); % face response
        fmri_places(pp).responses(tf,2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
        fmri_places(pp).responses(tf,3)=max(newdata(81+bufferlead:81+blocklength)); % object response
        fmri_places(pp).responses(tf,4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    end
    newdata=mean(temp_data,1);
    plot(newdata);
    fmri_places(pp).average(1)=max(newdata(17+bufferlead:17+blocklength)); % face response
    fmri_places(pp).average(2)=max(newdata(49+bufferlead:49+blocklength)); % bodypart response
    fmri_places(pp).average(3)=max(newdata(81+bufferlead:81+blocklength)); % object response
    fmri_places(pp).average(4)=max(newdata(113+bufferlead:113+blocklength)); % place response
    plot([16 16],[-2 3],'k:','LineWidth',0.5); plot([32 32],[-2 3],'k:','LineWidth',0.5);
    plot([48 48],[-2 3],'k:','LineWidth',0.5); plot([64 64],[-2 3],'k:','LineWidth',0.5);
    plot([80 80],[-2 3],'k:','LineWidth',0.5); plot([96 96],[-2 3],'k:','LineWidth',0.5);
    plot([112 112],[-2 3],'k:','LineWidth',0.5); plot([128 128],[-2 3],'k:','LineWidth',0.5);
    xlim([0 145]); ylim([-2 3]); ylabel('% Signal Change'); xlabel('#TRs');
    title(['Places - Patch #',num2str(pp),'(',num2str(size(temp_data,1)),')'],'FontSize',8,'FontWeight','Bold')
    clear temp_fmri_locs temp_afni_coords temp_pointer temp_coords newdata
end
jpgfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig3_PatchTimeSeries_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig3_PatchTimeSeries_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)



% Figure 4 - Category Selectivity for Each Patch within Grid (and Correlation)
disp('Figure 4 Category Selectivity for Each ROI')
figure; clf; cla; set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.8]); set(gca,'FontName','Arial','FontSize',8)
%%% MAY EVENTUALLY CHANGE THIS ANALYSIS TO MEASURE RESPONSE FROM EACH
%%% BLOCK, NOT FROM THE AVERAGE TIME SERIES
pref=[1 2 3 4]; categories={'Faces','BodyParts','Objects','Places'};
clear bardata
subplot(2,2,1); % faces
for rr=1:5,
    Rp=fmri_faces(rr).average(1);
    Rnp=sum(fmri_faces(rr).average(pref~=1))/3;
    bardata(rr)=(Rp-Rnp)/(Rp+Rnp);
end
bar(bardata);
xlabel('Location'); ylabel('Average Faces SI')
title(['Face Patches']); ylim([-0.5 0.5]); set(gca,'XTickLabel',{'AntIn','AntNear','PostIn','PostNear','Far'})
clear bardata

subplot(2,2,2); % bodyparts
for rr=1:3,
    Rp=fmri_bodyparts(rr).average(2);
    Rnp=sum(fmri_bodyparts(rr).average(pref~=2))/3;
    bardata(rr)=(Rp-Rnp)/(Rp+Rnp);
end
bar(bardata);
xlabel('Location'); ylabel('Average BP SI')
title(['BodyPart Patches']); ylim([-0.5 0.5]); set(gca,'XTickLabel',{'In','Near','Far'})
clear bardata

subplot(2,2,3); % objects
for rr=1:3,
    Rp=fmri_objects(rr).average(3);
    Rnp=sum(fmri_objects(rr).average(pref~=3))/3;
    bardata(rr)=(Rp-Rnp)/(Rp+Rnp);
end
bar(bardata);
xlabel('Location'); ylabel('Average Objects SI')
title(['Object Patches']); ylim([-0.5 0.5]); set(gca,'XTickLabel',{'In','Near','Far'})
clear bardata

subplot(2,2,4); % places
for rr=1:3,
    Rp=fmri_places(rr).average(4);
    Rnp=sum(fmri_places(rr).average(pref~=4))/3;
    bardata(rr)=(Rp-Rnp)/(Rp+Rnp);
end
bar(bardata);
xlabel('Location'); ylabel('Average Places SI')
title(['Place Patches']); ylim([-.5 0.5]); set(gca,'XTickLabel',{'In','Near','Far'})
clear bardata
jpgfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig4_GridSI_',monkeyname,'_',char(categories(cc)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rootdir,'rsvp500_postNeuron',filesep,'RSVPfMRI_Fig4_GridSI_',monkeyname,'_',char(categories(cc)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)





return

%%%% NESTED FUNCTIONS %%%%


function AFNIcoords=rsvp_apml2xyz(monkinitial,APcoords);
% Converts grid coords (AP,ML) to hard-coded X,Y,Z slice coords for
% comparing neuronal data to EPI timeseries data.
% Note: this program uses hard-coded values that were determined by
% comparing electrode scans and EPI/anatomicals
% monkinitial = 'S' or 'W'
% ap = anterior/posterior grid location (5-19mm)
% ml = medial/lateral grid location (13-27mm)

ap=APcoords(1); ml=APcoords(2);
if monkinitial=='S' % Stewie % Updated June 15, 2010
    APrange=5:19;
    MLrange=13:27;
    sag_range=[0 0 0 17 17 16 15 14 13 13 12 11 10 9 0]; % y slice# (Medial to Lateral)
    axi_range=[29 29 28 28 26 26 26 25 25 25 24 24 23 23 23]; % z slice# (Posterior to Anterior)
    cor_range=[19 19 18 18 17 17 16 16 15 15 14 14 13 13 12]; % x slice# (Posterior to Anterior)
    AFNIcoords(1)=sag_range(find(MLrange==ml)); % sagital
    AFNIcoords(2)=axi_range(find(APrange==ap)); % axial
    AFNIcoords(3)=cor_range(find(APrange==ap)); % coronal
    
    %% Correct for Matrix Orientation
    AFNIcoords(1)=64-AFNIcoords(1);
    AFNIcoords(2)=64-AFNIcoords(2);
    AFNIcoords(3)=(20+5)-AFNIcoords(3);
elseif monkinitial=='W', % wiggum
    APrange=5:19;
    MLrange=14:29;
    cor_range=[20 19 18 17 16 15 14 13 12 11 10 9 8 7 7]; % x (must match to AFNI output)
    sag_range=[38 39 40 41 42 43 44 45 46 47 48 49 50 51 52]; % y
    axi_range=[28 28 28 28 28 26 26 21 23 22 23 23 22 22 20]; % z
    
    man_range=[22 20 20 24 0 0 0;22 23 21 22 0 0 0;23 23 22 22 22 0 0;23 23 23 23 23 0 0;23 23 23 23 23 23 0;23 22 22 22 22 24 0;23 21 21 21 23 23 23;24 21 21 21 21 21 21;25 26 26 26 26 26 26;...
        25 26 26 26 26 26 26;26 28 28 28 28 29 29;27 28 28 28 28 28 28;28 28 28 28 28 28 28;28 28 28 28 28 28 28;29 28 28 28 28 28 28];
    xrange=[7 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
    yrange=[43 44 45 46 47 48 49];
    
    AFNIcoords(3)=cor_range(APrange==ap); % coronal
    AFNIcoords(1)=sag_range(MLrange==ml); % sagital
    AFNIcoords(2)=axi_range(APrange==ap); % axial
    
    
    
    %% Note: Wiggum's data were clipped Ant/Post - 5 from Ant, 10, from
    %% post.  Therefore:
    AFNIcoords(3)=AFNIcoords(3)-5;
end
return
     