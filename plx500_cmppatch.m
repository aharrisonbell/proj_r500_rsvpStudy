function plx500_cmppatch(sheetname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_cmppatch(sheetname); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept 2008
% Summarizes data from a set of grid locations and compares the summarized
% data across groups of grid locations (hardcoded).
% Sheetname = name of excel sheet (used to load appropriate XL structures)

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file

if nargin==0, sheetname='RSVP Cells_S'; end

%%% LOAD XLS STRUCTURES
outputfname = [hmiconfig.rsvpanal,sheetname,'_XLS_Neurons.mat'];
load(outputfname) 

%%% INITIALIZE GRID-DATA MATRIX
griddata=struct('label',[]','gridlocs',[],'all_unitnames',[],'filter_unitnames',[],'neuron_id',[],'cat_rsp',[],'cat_si',[]);

%%% IDENTIFY GRID LOCATIONS (HARD-CODING)
griddata(1).title='Anterior Posterior Analysis';
griddata(1).linestyles={'r-','b-','g-','c-','k-'};
griddata(1).markerstyles={'rs','bs','gs','cs','ks'};

% Face Patch Analysis
%griddata(1).title='Face Patch Analysis'
%griddata(1).label='Inside Patch';
%griddata(2).label='Near Patch';
%griddata(3).label='Outside Patch';
%griddata(1).gridlocs={'A7R1','A7L1','A7L2','A6L1','A6L0','A6R1'} 
%griddata(2).gridlocs={'A4R1','A4L1','A4L2'}
%griddata(3).gridlocs={'A0L0','A0L2','P1L1','P2L3'}

% Anterior/Posterior Analysis
griddata(1).label='Anterior';
griddata(2).label='Posterior';
griddata(1).gridlocs={'A7R1','A7L1','A7L2','A6L1','A6L0','A6R1','A6L0','A6L1','A6L2',...
    'A5L0','A5L1','A5L2'};
griddata(2).gridlocs={'P7L2','P6L3','P6L2','P5L3','P4L4','P3L4','P3L5'};

disp('***************************************************************')
disp('* plx500_cmppatch.m - Analysis program for neuronal data from *')
disp('*  RSVP500 datafiles.  This program generates a single set of *')
disp('*  spike density functions for a given grid location.         *')
disp('***************************************************************')
disp(' ')
numpatch=size(griddata,2);

for pt=1:numpatch,
    % Get all filenames
    unitind=find(ismember(unitsx.GridLoc,griddata(pt).gridlocs)==1);
    griddata(pt).all_unitnames=unitsx.FullUnitName(unitind);
    
    % Get filtered (sensory) units
    unitind=find(ismember(unitsx.GridLoc,griddata(pt).gridlocs)==1 & strcmp(unitsx.SensoryConf,'Sensory')==1);
    griddata(pt).filter_unitnames=unitsx.FullUnitName(unitind);
    
    % begin neuron loop
    for un=1:size(griddata(pt).filter_unitnames,2),
        % load datafiles
        load([hmiconfig.rsvp500spks,char(griddata(pt).filter_unitnames(un)),'-500responsedata.mat']); % load unit data
        % paste data into GRID-DATA structure
        griddata(pt).neuron_id(un,:)=neuron_id(respstructsingle);
        griddata(pt).cat_rsp(un,:)=respstructsingle.cat_avg(:,2);
        griddata(pt).cat_rsp_nobase(un,:)=respstructsingle.cat_avg_nobase(:,2);
        griddata(pt).cat_si(un,:)=respstructsingle.cat_si(1:6,2); % category selectivity (baseline included)
        griddata(pt).cat_si_nobase(un,:)=respstructsingle.cat_si_nobase(1:6,2); % category selectivity (no baseline)
        temp=respstructsingle.anova_within_group(:,:,2);
        griddata(pt).anovas_group(un,:)=temp; % within group anovas (for testing stimulus selectivity)
        griddata(pt).face_trad(un)=respstructsingle.face_trad; % "traditional" face selectivity (1=yes/0=no)
    end
end

%%% GENERATE COMPARISON STRUCTURE

for pt=1:numpatch,
    grid_sum.labels(pt)={griddata(pt).label};
    % panel A (neuronal proportions)
    numunits=size(griddata(pt).filter_unitnames,2);
    grid_sum.panelA(pt,1)=length(find(griddata(pt).neuron_id(:,2)==1))/numunits*100;
    grid_sum.panelA(pt,2)=length(find(griddata(pt).neuron_id(:,3)==1))/numunits*100;
    grid_sum.panelA(pt,3)=length(find(griddata(pt).neuron_id(:,3)==0))/numunits*100;
    grid_sum.panelA(pt,4)=length(find(griddata(pt).neuron_id(:,3)==-1))/numunits*100;
    grid_sum.panelA(pt,5)=length(find(griddata(pt).neuron_id(:,4)==1))/numunits*100;
    grid_sum.panelA(pt,6)=length(find(griddata(pt).neuron_id(:,4)==2))/numunits*100;
    grid_sum.panelA(pt,7)=length(find(griddata(pt).neuron_id(:,4)==3))/numunits*100;
    grid_sum.panelA(pt,8)=length(find(griddata(pt).neuron_id(:,4)==4))/numunits*100;
    grid_sum.panelA(pt,9)=length(find(griddata(pt).neuron_id(:,4)==5))/numunits*100;
    grid_sum.panelA(pt,10)=sum(griddata(pt).face_trad)/numunits*100;
    grid_sum.panelA(pt,11)=numunits;
    grid_sum.panelA(pt,12)=length(griddata(pt).gridlocs);

    % panel B (selectivity)
    [grid_sum.panelB(pt,1:6),grid_sum.panelB(pt,7:12)]=mean_sem(griddata(pt).cat_si);
    [grid_sum.panelBnb(pt,1:6),grid_sum.panelBnb(pt,7:12)]=mean_sem(griddata(pt).cat_si_nobase);

    % panel C (response magnitude)
    [grid_sum.panelC(pt,1:5),grid_sum.panelC(pt,6:10)]=mean_sem(griddata(pt).cat_rsp);
    [grid_sum.panelCnb(pt,1:5),grid_sum.panelCnb(pt,6:10)]=mean_sem(griddata(pt).cat_rsp_nobase);
end

% Statistics for two-way comparison
for x=1:6, grid_sum.panelB_rs(x)=ranksum(griddata(1).cat_si(:,x),griddata(2).cat_si(:,x)); end
for x=1:5, grid_sum.panelC_rs(x)=ranksum(griddata(1).cat_rsp(:,x),griddata(2).cat_rsp(:,x)); end

% anova - panelB
tempdata=[]; tempindex1=[]; tempindex2=[];
for pt=1:numpatch
    numunits=grid_sum.panelA(pt,11);
    tempdata=[tempdata;reshape(griddata(pt).cat_si(:,1:5),numunits*5,1)];
    tempindex1=[tempindex1;ones(numunits,1);ones(numunits,1)*2;ones(numunits,1)*3;ones(numunits,1)*4;ones(numunits,1)*5];  
    tempindex2=[tempindex2;ones(numunits*5,1)*pt];
end
grid_sum.panelB_anova=anovan(tempdata,{tempindex1 tempindex2},'interaction');

% anova - panelC
tempdata=[]; tempindex1=[]; tempindex2=[];
for pt=1:numpatch
    numunits=grid_sum.panelA(pt,11);
    tempdata=[tempdata;reshape(griddata(pt).cat_rsp,numunits*5,1)];
    tempindex1=[tempindex1;ones(numunits,1);ones(numunits,1)*2;ones(numunits,1)*3;ones(numunits,1)*4;ones(numunits,1)*5];  
    tempindex2=[tempindex2;ones(numunits*5,1)*pt];
end
grid_sum.panelC_anova=anovan(tempdata,{tempindex1 tempindex2},'interaction');


%%% GENERATE FIGURE
figure; clf; cla; % 
set(gcf,'Units','Normalized','Position',[0.25 0.1 0.4 0.8])
set(gca,'FontName','Arial','FontSize',8)
subplot(3,1,1) % proportions
bar(1:numpatch,grid_sum.panelA(:,1:10),'group')
title(griddata(1).title,'FontSize',12,'FontWeight','Bold')
ylabel('% of Sensory Neurons','FontSize',8); ylim([0 100]);
set(gca,'XTickLabel',grid_sum.labels,'FontSize',7)
legend('Sel','Ex','Bo','In','Fa','Ft','Pl','Bp','Ob','Face','Location','BestOutside')
for pt=1:numpatch, 
    text(pt,92,['(patch)n=',num2str(grid_sum.panelA(pt,12))],'FontSize',7);
    text(pt,85,['n=',num2str(grid_sum.panelA(pt,11))],'FontSize',7);
end

subplot(3,1,2) % Category Selectivity
hold on
for pt=1:numpatch, 
    errorbar(1:6,grid_sum.panelB(pt,1:6),grid_sum.panelB(pt,7:12),char(griddata(1).linestyles(pt)),'LineWidth',1)
    plot(0.7,mean(grid_sum.panelB(pt,1:5)),char(griddata(1).markerstyles(pt)),'MarkerSize',5)
    plot([0.7 0.7],[mean(grid_sum.panelB(pt,1:5))-sem(grid_sum.panelB(pt,1:5)) mean(grid_sum.panelB(pt,1:5))+sem(grid_sum.panelB(pt,1:5))],...
        char(griddata(1).linestyles(pt)),'LineWidth',1)
end
for x=1:6, text(x,0.05,['p=',num2str(grid_sum.panelB_rs(x),'%1.2g')],'FontSize',6); end
plot([1 6],[0 0],'k:','LineWidth',0.5)
ylabel('Selectivity Index','FontSize',8)
set(gca,'XTick',1:6,'XTickLabel',{'Faces','Fruit','Places','BodyP','Objcts','FcNoFt'},'FontSize',7)
% anova
text(0.5,0.080,['Main Effect (Cat): ',num2str(grid_sum.panelB_anova(1),'%1.2g')],'FontSize',6)
text(0.5,0.065,['Main Effect (Patch): ',num2str(grid_sum.panelB_anova(2),'%1.2g')],'FontSize',6)
text(0.5,0.050,['Interaction: ',num2str(grid_sum.panelB_anova(3),'%1.2g')],'FontSize',6)


subplot(3,1,3) % Category Selectivity
hold on
for pt=1:numpatch, 
    errorbar(1:5,grid_sum.panelC(pt,1:5),grid_sum.panelC(pt,6:10),char(griddata(1).linestyles(pt)),'LineWidth',1); 
    plot(0.7,mean(grid_sum.panelC(pt,1:5)),char(griddata(1).markerstyles(pt)),'MarkerSize',5)
    plot([0.7 0.7],[mean(grid_sum.panelC(pt,1:5))-sem(grid_sum.panelC(pt,1:5)) mean(grid_sum.panelC(pt,1:5))+sem(grid_sum.panelC(pt,1:5))],...
        char(griddata(1).linestyles(pt)),'LineWidth',1)
end
for x=1:5, text(x,21,['p=',num2str(grid_sum.panelC_rs(x),'%1.2g')],'FontSize',6); end
ylabel('Average Response (sp/s)','FontSize',8)
set(gca,'XTick',1:5,'XTickLabel',{'Faces','Fruit','Places','BodyP','Objcts'},'FontSize',7)
text(0.5,24.0,['Main Effect (Cat): ',num2str(grid_sum.panelC_anova(1),'%1.2g')],'FontSize',6)
text(0.5,22.5,['Main Effect (Patch): ',num2str(grid_sum.panelC_anova(2),'%1.2g')],'FontSize',6)
text(0.5,21.0,['Interaction: ',num2str(grid_sum.panelC_anova(3),'%1.2g')],'FontSize',6)

jpgfigname=[hmiconfig.rsvpanal,'RSVP_',char(griddata(1).title),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_',char(griddata(1).title),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)






return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%      NESTED FUNCTIONS      %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output=neuron_id(unitinfo)
output=zeros(1,4);
if strcmp(unitinfo.conf_neurtype,'Sensory')==1, output(1)=1; end
if strcmp(unitinfo.conf_selective,'Selective')==1, output(2)=1; end
if strcmp(unitinfo.conf_excite,'Excite')==1, output(3)=1; end
if strcmp(unitinfo.conf_excite,'Both')==1, output(3)=0; end
if strcmp(unitinfo.conf_excite,'Inhibit')==1, output(3)=-1; end
if strcmp(unitinfo.conf_preferred_cat,'Faces')==1, output(4)=1; end
if strcmp(unitinfo.conf_preferred_cat,'Fruit')==1, output(4)=2; end
if strcmp(unitinfo.conf_preferred_cat,'Places')==1, output(4)=3; end
if strcmp(unitinfo.conf_preferred_cat,'BodyParts')==1, output(4)=4; end
if strcmp(unitinfo.conf_preferred_cat,'Objects')==1, output(4)=5; end
return

