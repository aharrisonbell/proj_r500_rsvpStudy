function plx500_LFPs_append(monkinitial,replot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_LFPs_append(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, May 2009


replot = 1;
%%% SETUP DEFAULTS
warning off;
%close all
hmiconfig=generate_hmi_configplex; % generates and loads config file
parnumlist=500; % list of paradigm numbers
xscale=[-400 700]; % default time window for LFPs, +/-400ms from stim onset/offset
rect_epoch=[50 300]; % same as spikes
channels={'LFP1','LFP2','LFP3','LFP4'}; catnames={'Faces','Bodyparts','Objects','Places'};
if nargin==0, error('You must specify a monkey (''S''/''W'')'); elseif nargin==1, replot=0; option=[1]; end
if monkinitial=='S',
    monkeyname='Stewie'; sheetname='RSVP_LFP_S';
elseif monkinitial=='W',
    monkeyname='Wiggum'; sheetname='RSVP_LFP_W';
end

disp('*************************************************************************')
disp('* plx500_LFPs_append.m - Adds additional fields to LFPSTRUCTSINGLE_TRIM *')
disp('*************************************************************************')
disp('Loading XL information...')
%%%  LOAD FILE LIST
if strcmp(monkinitial,'S')==1
    disp('Analyzing all RSVP500 LFP files for Stewie...')
    % Pulls files from HMI_PhysiologyNotes
    include=xlsread(hmiconfig.excelfile,'RSVP500','D9:D1000'); % alphanumeric, Gridlocation
    [crap,filest]=xlsread(hmiconfig.excelfile,'RSVP500','E9:E1000');
    filesx=filest(find(include==1)); clear include; clear filez
    for ff=1:size(filesx,1),
        temp=char(filesx(ff)); files(ff)=cellstr(temp(1:12));
    end
elseif strcmp(monkinitial,'W')==1
    disp('Analyzing all RSVP500 LFP files for Wiggum...')
    % Pulls files from HMI_PhysiologyNotes
    include=xlsread(hmiconfig.excelfile,'RSVP500','J9:J1000'); % alphanumeric, Gridlocation
    [crap,filest]=xlsread(hmiconfig.excelfile,'RSVP500','K9:K1000');
    filesx=filest(find(include==1)); clear include; clear filez
    for ff=1:size(filesx,1),
        temp=char(filesx(ff)); files(ff)=cellstr(temp(1:12));
    end
end
numsites=length(files);

%%% ANALYZE INDIVIDUAL FILES
for ss=1:numsites, % perform following operations on each nex file listed
    disp(['Appending new fields to LFP structures from ',char(files(ss))])

    for ch=1:4,
        disp(['...Trying channel ',channels{ch}])
        try
            load([hmiconfig.rsvp500lfps,files{ss},'-500-',channels{ch},'.mat']);


            %%%% APPEND FIELDS HERE %%%%
            disp('.....appending additional fields...')

            %% Correct label name
            lfpstructsingle_trim.label=channels{ch};
            
            %%%%%%%%% May 21, 2009 %%%%%%%%%
            %%% Category-selectivity (Evoked Responses)
            lfpstructsingle_trim.cat_anova=anova1(lfpstructsingle_trim.trial_epoch,lfpstructsingle_trim.trial_type,'off');

            %%% Raw Category Selectivity
            % Raw Category SI (SI for preferred category)
            catlabels={'Faces','Bodyparts','Objects','Places'};
            % Evoked
            catind=find(strcmp(lfpstructsingle_trim.bestlabel,catlabels)==1);
            lfpstructsingle_trim.evoked_rawsi=lfpstructsingle_trim.evoked_cat_si(catind);
            % Rect
            catind=find(strcmp(lfpstructsingle_trim.bestlabel_rect,catlabels)==1);
            lfpstructsingle_trim.rect_rawsi=lfpstructsingle_trim.rect_cat_si(catind);
            % Frequency
            for fr=1:6,
                catind=find(strcmp(lfpstructsingle_trim.freq_bestlabel(fr),catlabels)==1);
                lfpstructsingle_trim.freq_rawsi(fr)=lfpstructsingle_trim.freq_cat_si(catind,fr);
            end

            %%% ROC Analysis
            %%% Conduct ROC analyses (as per Bell et al 2009)
            disp('...performing ROC analysis...')
            % Evoked
            %     pointer1=find(lfpstructsingle_trim.trial_type==1);
            %     pointer2=find(lfpstructsingle_trim.trial_type==2);
            %     pointer3=find(lfpstructsingle_trim.trial_type==3);
            %     pointer4=find(lfpstructsingle_trim.trial_type==4);
            %     lfpstructsingle_trim.roc_evoked=zeros(4,4);
            %     lfpstructsingle_trim.roc_rect=zeros(4,4);
            %     lfpstructsingle_trim.roc_freq=zeros(6,4,4);
            %     for rr=1:4, % once per condition
            %         pointerR=find(lfpstructsingle_trim.trial_type==rr);
            %         lfpstructsingle_trim.roc_evoked(rr,1)=plx500_calcROC(lfpstructsingle_trim.trial_epoch(pointerR),lfpstructsingle_trim.trial_epoch(pointer1));
            %         lfpstructsingle_trim.roc_evoked(rr,2)=plx500_calcROC(lfpstructsingle_trim.trial_epoch(pointerR),lfpstructsingle_trim.trial_epoch(pointer2));
            %         lfpstructsingle_trim.roc_evoked(rr,3)=plx500_calcROC(lfpstructsingle_trim.trial_epoch(pointerR),lfpstructsingle_trim.trial_epoch(pointer3));
            %         lfpstructsingle_trim.roc_evoked(rr,4)=plx500_calcROC(lfpstructsingle_trim.trial_epoch(pointerR),lfpstructsingle_trim.trial_epoch(pointer4));
            %         lfpstructsingle_trim.roc_rect(rr,1)=plx500_calcROC(lfpstructsingle_trim.trial_epoch_rect(pointerR),lfpstructsingle_trim.trial_epoch_rect(pointer1));
            %         lfpstructsingle_trim.roc_rect(rr,2)=plx500_calcROC(lfpstructsingle_trim.trial_epoch_rect(pointerR),lfpstructsingle_trim.trial_epoch_rect(pointer2));
            %         lfpstructsingle_trim.roc_rect(rr,3)=plx500_calcROC(lfpstructsingle_trim.trial_epoch_rect(pointerR),lfpstructsingle_trim.trial_epoch_rect(pointer3));
            %         lfpstructsingle_trim.roc_rect(rr,4)=plx500_calcROC(lfpstructsingle_trim.trial_epoch_rect(pointerR),lfpstructsingle_trim.trial_epoch_rect(pointer4));
            %         for fb=1:6,
            %             lfpstructsingle_trim.roc_freq(fb,rr,1)=plx500_calcROC(lfpstructsingle_trim.freq_epoch_trial(pointerR,fb),lfpstructsingle_trim.freq_epoch_trial(pointer1,fb));
            %             lfpstructsingle_trim.roc_freq(fb,rr,2)=plx500_calcROC(lfpstructsingle_trim.freq_epoch_trial(pointerR,fb),lfpstructsingle_trim.freq_epoch_trial(pointer2,fb));
            %             lfpstructsingle_trim.roc_freq(fb,rr,3)=plx500_calcROC(lfpstructsingle_trim.freq_epoch_trial(pointerR,fb),lfpstructsingle_trim.freq_epoch_trial(pointer3,fb));
            %             lfpstructsingle_trim.roc_freq(fb,rr,4)=plx500_calcROC(lfpstructsingle_trim.freq_epoch_trial(pointerR,fb),lfpstructsingle_trim.freq_epoch_trial(pointer4,fb));
            %         end
            %     end
            %
            %%% SAVE APPENDED STRUCTURE
            lfpstructsingle_trim.date_modified=date;
            outputfname_sml=[hmiconfig.rsvp500lfps,files{ss},'-500-',channels{ch},'.mat'];
            save(outputfname_sml,'lfpstructsingle_trim');

            %%% REGENERATE FIGURE (IF REPLOT==1)
            %if replot==1,
                plot_singleLFP(hmiconfig,xscale,lfpstructsingle_trim,[files{ss}])
            %end
            clear lfpstructsingle_trim
            close all
        catch
            disp('...no data found for this channel')
        end
    end
end
return

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
