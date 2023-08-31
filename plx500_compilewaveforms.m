function [units,unitsx]=plx500_compilewaveforms(monkeyinitial,exceloption,proofing);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_compilewaveforms(monkeyinitial); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by AHB, Dec2008, updated Jan2009, based on plx_compilewaveforms;
% Collects raw waveforms for listed units and compiles the individual
% parameters into histograms.  Used for determining the identity of neurons
% based on the waveform shape (Mitchell et al., 2006 Neuron)
% MONKEYINITIAL="S" for Stewie, "W" for Wiggum (required)
% EXCELOPTION(optional)=1 for Sync, 0 for no sync

% This program analyzes four different parameters:
% 1) Depolarization Magnitude
% 2) Depolarization Latency
% 3) Repolarization Magnitude
% 4) Repolarization Latency
%
% This program eliminates any waveforms where the latency of the
% repolarization is LESS than the depolarization (indicates a neuron that
% was thresholded from above)

warning off;
%%% SETUP DEFAULTS
hmiconfig = generate_hmi_configplex; % generates and loads config file
samprate=40000; 
cutoff=250; % approximated from Johnston et al. 2009
xticktime=(1/samprate)*1000000; % us per tick
if nargin==0, error('You must specify either ''S'' or ''W''.'); 
elseif nargin==1, exceloption=0; proofing=0;
elseif nargin==2, proofing=0; end
if monkeyinitial=='S', sheetname='RSVP Cells_S'; monkeyname='Stewie'; 
elseif monkeyinitial=='W', sheetname='RSVP Cells_W'; monkeyname='Wiggum';
else monkeyinitial=='B', sheetname='RSVP Cells_B'; monkeyname='Both Monkeys';
end


disp('******************************************************************')
disp('* plx500_compilewaveforms.m - Classifies neurons listed in EXCEL *')
disp('*     spreadsheet based on waveform parameters.                  *')
disp('******************************************************************')
%%% LOAD FILE INFO
disp('Loading EXCEL spreadsheet data...'); tic
[allunits,unit_index]=plx_loadfileinfo(hmiconfig,sheetname); toc
disp('Done.'); disp(' ');

%%% CREATE EMPTY MATRICES
wf_data_all=struct('avg_wf',[],'align_avg_wf',[],'parameters',[],'include',unit_index.wf_include,'norm_avg',[]);

%%% LOAD WAVEFORM DATA INTO WF_DATA_ALL MATRIX
for un=1:length(allunits), % perform following operations on each nex file listed
    % Load waveform data
    disp(['.Loading waveforms for ',char(allunits(un).FullUnitName),'...']);
    raw_wf=load([hmiconfig.wave_raw,char(allunits(un).FullUnitName),'_raw.mat']); raw_wf=raw_wf.waverawdata;
    % Calculate average waveform
    wf_data_all.avg_wf(un,:)=mean(raw_wf');
    % Solve waveform parameters
    [wf_data_all.parameters(un,1) wf_data_all.parameters(un,2)]=min(wf_data_all.avg_wf(un,:)); % waveform minimum (#samples)
    [wf_data_all.parameters(un,3) wf_data_all.parameters(un,4)]=max(wf_data_all.avg_wf(un,:)); % waveform maximum (#samples)
    wf_data_all.parameters(un,5)=wf_data_all.parameters(un,4)-wf_data_all.parameters(un,2); % waveform duration (#samples)
    % Calculate aligned waveform
    try % attempt to align waveform on waveform minimum -100us, +375us
        wf_data_all.align_avg_wf(un,:)=wf_data_all.avg_wf(un,wf_data_all.parameters(un,2)-4:wf_data_all.parameters(un,2)+15);
        wf_data_all.parameters(un,6)=wf_data_all.parameters(un,5)*xticktime; % waveform duration (us)
        % Normalize aligned waveform
        temp=wf_data_all.align_avg_wf(un,:)+abs(min(wf_data_all.align_avg_wf(un,:))); % bring level to zero
        normalizer=max(temp);
        wf_data_all.norm_avg(un,:)=temp/normalizer;
    catch
        disp('.Unable to align waveforms.  Excluding this neuron.')
        wf_data_all.include(un)=0;
    end
    % Load responsestruct data
    load([hmiconfig.rsvp500spks,allunits(un).FullUnitName,'-500responsedata.mat']);
    wf_data_all.avg_firing_rate(un)=mean(respstructsingle.m_epoch1);
    wf_data_all.max_firing_rate(un)=max(respstructsingle.m_epoch1);
end

%%% FILTER UNITS
disp('Filtering units...')
for un=1:length(allunits),
    if wf_data_all.include==1, % only worry about included units
        if wf_data_all.parameters(un,2)>wf_data_all.parameters(un,4),
            disp('.Repolarization precedes depolarization.  Excluding this neuron.')
            wf_data_all.include(un)=0;
        end
    end
end

%%% CLASSIFY NEURONS ACCORDING TO CUTOFF (see above)
disp('Classifying units...')
neurontype={};
for un=1:length(allunits),
    if wf_data_all.include(un)==1 & wf_data_all.parameters(un,6)<=cutoff,
        neurontype(un)={'ns'};
    elseif wf_data_all.include(un)==1 & wf_data_all.parameters(un,6)>cutoff,
        neurontype(un)={'bs'};
    else
        neurontype(un)={'unk'};
    end
end

%%% EXPORT RESULTS TO EXCEL
if exceloption==1,
    disp('Syncing with EXCEL...')
    rownums=5:5+length(allunits)-1;
    xlswrite(hmiconfig.excelfile,neurontype',sheetname,['AB',num2str(rownums(1)),':AB',num2str(rownums(end))])
    xlswrite(hmiconfig.excelfile,wf_data_all.include,sheetname,['AC',num2str(rownums(1)),':AC',num2str(rownums(end))])
end

%%% GENERATE FIGURES
disp('Generate figures...')
pointerNS=find(wf_data_all.include==1 & wf_data_all.parameters(:,6)<=cutoff);
pointerBS=find(wf_data_all.include==1 & wf_data_all.parameters(:,6)>cutoff);
pointer=[pointerNS;pointerBS];
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,5,1)
hold on
plot(-100:25:375,wf_data_all.norm_avg(pointerNS,:),'r','LineWidth',0.25)
plot(-100:25:375,wf_data_all.norm_avg(pointerBS,:),'b','LineWidth',0.25)
xlim([-100 375]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
set(gca,'FontSize',7); axis square
title('Normalized Waveforms','FontWeight','Bold','FontSize',8)
subplot(2,5,2); hold on
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerNS,:)),'r','LineWidth',2.25)
plot(-100:25:375,(mean(wf_data_all.norm_avg(pointerNS,:))+std(wf_data_all.norm_avg(pointerNS,:))),'r','LineWidth',0.55)
plot(-100:25:375,(mean(wf_data_all.norm_avg(pointerNS,:))-std(wf_data_all.norm_avg(pointerNS,:))),'r','LineWidth',0.55)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerBS,:)),'b','LineWidth',2.25)
plot(-100:25:375,(mean(wf_data_all.norm_avg(pointerBS,:))+std(wf_data_all.norm_avg(pointerBS,:))),'b','LineWidth',0.55)
plot(-100:25:375,(mean(wf_data_all.norm_avg(pointerBS,:))-std(wf_data_all.norm_avg(pointerBS,:))),'b','LineWidth',0.55)
xlim([-100 375]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
set(gca,'FontSize',7); axis square
title('Normalized Waveforms','FontWeight','Bold','FontSize',8)
subplot(2,5,3)
ns=histc(wf_data_all.parameters(pointerNS,6),100:25:500);
bs=histc(wf_data_all.parameters(pointerBS,6),100:25:500);
hold on
bar(100:25:500,ns,'r'); 
bar(100:25:500,bs,'b'); 
xlim([100 500]); axis square
xlabel('Wave Duration (us)'); ylabel('Number of Units'); set(gca,'FontSize',7);
text(110,40,['HDT=',num2str(HartigansDipTest(wf_data_all.parameters(pointer,6)),'%1.3g')],'FontSize',7)
pointer=[pointerNS;pointerBS];
subplot(2,5,4)
ns=histc(wf_data_all.avg_firing_rate(pointerNS),0:4:100);
bs=histc(wf_data_all.avg_firing_rate(pointerBS),0:4:100);
hold on
%bar(0:4:100,ns,'r'); 
%bar(0:4:100,bs,'b'); 
bar(0:4:100,[ns' bs'],'stack')
xlim([-10 100]); axis square
xlabel('Average Firing Rate'); ylabel('Number of Units'); set(gca,'FontSize',7);
[h,p]=ttest2(wf_data_all.avg_firing_rate(pointerNS),wf_data_all.avg_firing_rate(pointerBS));
text(50,50,['p=',num2str(p,'%1.2g')])
subplot(2,5,5)
ns=histc(wf_data_all.max_firing_rate(pointerNS),0:4:100);
bs=histc(wf_data_all.max_firing_rate(pointerBS),0:4:100);
hold on
%bar(0:4:100,ns,'r'); 
%bar(0:4:100,bs,'b'); 
bar(0:4:100,[ns' bs'],'stack')
xlim([-10 100]); axis square
xlabel('Max Firing Rate'); ylabel('Number of Units'); set(gca,'FontSize',7);
[h,p]=ttest2(wf_data_all.max_firing_rate(pointerNS),wf_data_all.max_firing_rate(pointerBS));
text(50,50,['p=',num2str(p,'%1.2g')])

pointerNS=find(wf_data_all.include==1 & wf_data_all.parameters(:,6)<=cutoff & strcmp(unit_index.SensoryConf,'Sensory')==1);
pointerBS=find(wf_data_all.include==1 & wf_data_all.parameters(:,6)>cutoff & strcmp(unit_index.SensoryConf,'Sensory')==1);
pointer=[pointerNS;pointerBS];
subplot(2,5,6)
hold on
plot(-100:25:375,wf_data_all.norm_avg(pointerNS,:),'r','LineWidth',0.25)
plot(-100:25:375,wf_data_all.norm_avg(pointerBS,:),'b','LineWidth',0.25)
xlim([-100 375]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
set(gca,'FontSize',7); axis square
title('Normalized Waveforms - Sensory Neurons Only','FontWeight','Bold','FontSize',8)
subplot(2,5,7); hold on
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerNS,:)),'r','LineWidth',2.25)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerNS,:))+std(wf_data_all.norm_avg(pointerNS,:)),'r','LineWidth',0.55)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerNS,:))-std(wf_data_all.norm_avg(pointerNS,:)),'r','LineWidth',0.55)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerBS,:)),'b','LineWidth',2.25)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerBS,:))+std(wf_data_all.norm_avg(pointerBS,:)),'b','LineWidth',0.55)
plot(-100:25:375,mean(wf_data_all.norm_avg(pointerBS,:))-std(wf_data_all.norm_avg(pointerBS,:)),'b','LineWidth',0.55)
xlim([-100 375]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
set(gca,'FontSize',7); axis square
title('Normalized Waveforms','FontWeight','Bold','FontSize',8)
subplot(2,5,8)
ns=histc(wf_data_all.parameters(pointerNS,6),100:25:500);
bs=histc(wf_data_all.parameters(pointerBS,6),100:25:500);
hold on
bar(100:25:500,ns,'r'); 
bar(100:25:500,bs,'b'); 
%plot(100:25:500,ns,'rs')
%plot(100:25:500,bs,'bs')
xlim([100 500]); axis square
xlabel('Wave Duration (us)'); ylabel('Number of Units'); set(gca,'FontSize',7);
text(110,40,['HDT=',num2str(HartigansDipTest(wf_data_all.parameters(pointer,6)),'%1.3g')],'FontSize',7)
subplot(2,5,9)
ns=histc(wf_data_all.avg_firing_rate(pointerNS),0:4:100);
bs=histc(wf_data_all.avg_firing_rate(pointerBS),0:4:100);
hold on
%bar(0:4:100,ns,'r'); 
%bar(0:4:100,bs,'b'); 
bar(0:4:100,[ns' bs'],'stack')
xlim([-10 100]); axis square
xlabel('Average Firing Rate'); ylabel('Number of Units'); set(gca,'FontSize',7);
[h,p]=ttest2(wf_data_all.avg_firing_rate(pointerNS),wf_data_all.avg_firing_rate(pointerBS));
text(50,50,['p=',num2str(p,'%1.2g')])
subplot(2,5,10)
ns=histc(wf_data_all.max_firing_rate(pointerNS),0:4:100);
bs=histc(wf_data_all.max_firing_rate(pointerBS),0:4:100);
hold on
%bar(0:4:100,ns,'r'); 
%bar(0:4:100,bs,'b'); 
bar(0:4:100,[ns' bs'],'stack')
xlim([-10 100]); axis square
xlabel('Max Firing Rate'); ylabel('Number of Units'); set(gca,'FontSize',7);
[h,p]=ttest2(wf_data_all.max_firing_rate(pointerNS),wf_data_all.max_firing_rate(pointerBS));
text(50,50,['p=',num2str(p,'%1.2g')])
jpgfigname=[hmiconfig.rsvpanal,'RSVP_Project1_Fig9_',monkeyname,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_Project1_Fig9_',monkeyname,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%% Proofing Waveforms - generate one figure for every 10 waveforms
if proofing==1,
    %% Narrow-Spiking Neurons
    rns=1:10:length(pointerNS);
    linstyl={'+','*','x','s','d','^','v','>','<','p','h'};
    for fg=1:length(rns),
        figure; clf; cla; %
        set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
        set(gca,'FontName','Arial','FontSize',8)
        if fg~=length(rns), unitr=pointerNS(rns(fg):rns(fg+1)-1);
        else unitr=pointerNS(rns(fg):end);
        end
        for w=1:length(unitr),
            hold on
            plot(-100:25:375,wf_data_all.norm_avg(unitr(w),:),[char(linstyl(w)),'-'],'LineWidth',0.25)
            plot(400,w/10,char(linstyl(w)),'MarkerSize',8)
            text(405,w/10,allunits(unitr(w)).FullUnitName,'FontSize',7)
        end
        plot([250 250],[0 1],'r:','LineWidth',0.25); plot([0 0],[0 1],'r:','LineWidth',0.25);
        xlim([-100 400]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
        set(gca,'FontSize',7); axis square
        title('Normalized Waveforms - Narrow-Spiking','FontWeight','Bold','FontSize',8)
    end
end
if proofing==2,
    %%% Proofing Waveforms - generate one figure for every 10 waveforms
    %% Broad-Spiking Neurons
    rbs=1:10:length(pointerBS);
    linstyl={'+','*','x','s','d','^','v','>','<','p','h'};
    for fg=1:length(rbs),
        figure; clf; cla; %
        set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.6])
        set(gca,'FontName','Arial','FontSize',8)
        if fg~=length(rbs), unitr=pointerBS(rbs(fg):rbs(fg+1)-1);
        else unitr=pointerBS(rbs(fg):end);
        end
        for w=1:length(unitr),
            hold on
            plot(-100:25:375,wf_data_all.norm_avg(unitr(w),:),[char(linstyl(w)),'-'],'LineWidth',0.25)
            plot(400,w/10,char(linstyl(w)),'MarkerSize',8)
            text(405,w/10,allunits(unitr(w)).FullUnitName,'FontSize',7)
        end
        plot([250 250],[0 1],'r:','LineWidth',0.25); plot([0 0],[0 1],'r:','LineWidth',0.25);
        xlim([-100 400]); ylim([0 1]); xlabel('Time (us)'); ylabel('Normalized Amplitude','FontSize',7)
        set(gca,'FontSize',7); axis square
        title('Normalized Waveforms - Broad-Spiking','FontWeight','Bold','FontSize',8)
    end
end
return