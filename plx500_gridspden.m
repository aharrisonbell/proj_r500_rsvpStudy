function plx500_gridspden(grid,monkey,type);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_gridspden(grid,monkey); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept 2008
% Generates a single set of spike density functions for a given grid
% location.  

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
xrange=-200:400;
normwin=-100:0;
if nargin==0,
    disp('*** plx500_gridspden.m ***')
    disp('NOTE: You must specify which grids to analyze:')
    disp('FORMAT: plx500_gridspden({''AxRx''});')
    disp('        plx500_gridspden({''AxRx'',''AxRx''});')
    disp('        plx500_gridspden({''ALL''});')
    return
elseif monkey=='Stewie',
    monkey='Stewie'; sheetname='RSVP Cells_S';  
elseif monkey=='Wiggum',
    sheetname='RSVP Cells_W';
end

disp('****************************************************************')
disp('* plx500_gridspden.m - Analysis program for neuronal data from *')
disp('*   RSVP500 datafiles.  This program generates a single set of *')
disp('*   spike density functions for a given grid location.         *')
disp('****************************************************************')

%%% DETERMINE GRID LOCATIONS TO ANALYZE
[units,unitsx]=plx_loadfileinfo(hmiconfig,sheetname);
%load([hmiconfig.rsvpanal,sheetname,'_data.mat'])
if strcmp(grid,'ALL')==1, % not analyzing all
    grids=unique(unitsx.GridLoc);
else
    grids=grid;
end

%%% ANALYZE EACH GRID LOCATION
for gd=1:length(grids), % scroll through each
    disp(' ')
    disp(['Analyzing ',char(grids(gd)),'...'])
    gridind=find(strcmp(unitsx.GridLoc,grids(gd))==1);
    allfiles=units(gridind);
    %%% LOAD FILES
    disp('Loading unit names...')
    numunits_all=size(allfiles,2);
    disp(['..found ',num2str(numunits_all),' units'])

    %%% FILTER UNITS
    disp('Filtering units (removing non-responsive units)...')
    filterlist=zeros(numunits_all,1); % a "mask" used to filter units
    for un=1:numunits_all,
        load([hmiconfig.rsvp500spks,allfiles(un).FullUnitName,'-500responsedata.mat']); % load unit data
        % filter one - only sensory neurons
        if strcmp(type,'Both')==1 & strcmp(respstructsingle.conf_neurtype,'Sensory')==1
            filterlist(un)=1;
        elseif strcmp(type,'Excite')==1 & strcmp(respstructsingle.conf_excite,'Inhibit')~=1 & strcmp(respstructsingle.conf_neurtype,'Sensory')==1,
            filterlist(un)=1;
        elseif strcmp(type,'Inhibit')==1 & strcmp(respstructsingle.conf_excite,'Excite')~=1 & strcmp(respstructsingle.conf_neurtype,'Sensory')==1,
            filterlist(un)=1;
        end
        clear respstructsingle
    end
    tempunits=find(filterlist==1);
    files=allfiles(tempunits);
    numunits=size(files,2);
    disp(['..',num2str(numunits),' remain'])
    if numunits<3,
        disp('..Less than 3 units remain, skipping this location')
        continue
    end
    
    %%% LOAD GRAPH DATA AND PASTE INTO MASTER MATRIX
    graphs = struct('faces_raw',[],'fruit_raw',[],'places_raw',[],'bodyparts_raw',[],'objects_raw',[],...
        'faces_norm',[],'fruit_norm',[],'places_norm',[],'bodyparts_norm',[],'objects_norm',[],...
        'responses',[]);
    for un=1:numunits,
        load([hmiconfig.rsvp500spks,files(un).FullUnitName,'-500graphdata.mat']); % load unit data
        xwindow=1000+xrange(1):1000+xrange(end);
        xnormwin=1000+normwin(1):1000+normwin(end);
        graphs.faces_raw(un,1:length(xrange))=graphstructsingle.faces_avg(xwindow);
        graphs.fruit_raw(un,1:length(xrange))=graphstructsingle.fruit_avg(xwindow);
        graphs.places_raw(un,1:length(xrange))=graphstructsingle.places_avg(xwindow);
        graphs.bodyparts_raw(un,1:length(xrange))=graphstructsingle.bodyp_avg(xwindow);
        graphs.objects_raw(un,1:length(xrange))=graphstructsingle.objct_avg(xwindow);

        % normalize to max of each response
        graphs.faces_norm(un,1:length(xrange))=graphstructsingle.faces_avg(xwindow)/max(graphstructsingle.faces_avg(xnormwin));
        graphs.fruit_norm(un,1:length(xrange))=graphstructsingle.fruit_avg(xwindow)/max(graphstructsingle.fruit_avg(xnormwin));
        graphs.places_norm(un,1:length(xrange))=graphstructsingle.places_avg(xwindow)/max(graphstructsingle.places_avg(xnormwin));
        graphs.bodyparts_norm(un,1:length(xrange))=graphstructsingle.bodyp_avg(xwindow)/max(graphstructsingle.bodyp_avg(xnormwin));
        graphs.objects_norm(un,1:length(xrange))=graphstructsingle.objct_avg(xwindow)/max(graphstructsingle.objct_avg(xnormwin));

        % population responses
        load([hmiconfig.rsvp500spks,files(un).FullUnitName,'-500responsedata.mat']);
        graphs.responses(un,1:100)=respstructsingle.m_epoch1;
        
        % LFP responses
        graphs.lfp_faces(un,:)=respstructsingle.LFP_cat_avg(1,:);
        graphs.lfp_bparts(un,:)=respstructsingle.LFP_cat_avg(2,:);
        graphs.lfp_objects(un,:)=respstructsingle.LFP_cat_avg(3,:);
        graphs.lfp_places(un,:)=respstructsingle.LFP_cat_avg(4,:);
        
        graphs.lfp_faces_rect(un,:)=respstructsingle.LFP_cat_avg_rect(1,:);
        graphs.lfp_bparts_rect(un,:)=respstructsingle.LFP_cat_avg_rect(2,:);
        graphs.lfp_objects_rect(un,:)=respstructsingle.LFP_cat_avg_rect(3,:);
        graphs.lfp_places_rect(un,:)=respstructsingle.LFP_cat_avg_rect(4,:);
        
        % LFP frequency responses
        templfpname=char(respstructsingle.label);
        lfpname=[templfpname(1:13),'500-LFP',templfpname(19),'.mat'];
        load([hmiconfig.rsvp500lfps,lfpname]);
        if isfield(lfpstructsingle_trim,'cat_specgramMT_S_noB')==1,
            graphs.lfp_face_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(1,:,:);
            graphs.lfp_bparts_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(2,:,:);
            graphs.lfp_objects_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(3,:,:);
            graphs.lfp_places_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(4,:,:);
        else
            plx500_LFPs({lfpname(1:12)});
            load([hmiconfig.rsvp500lfps,lfpname]);
            graphs.lfp_face_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(1,:,:);
            graphs.lfp_bparts_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(2,:,:);
            graphs.lfp_objects_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(3,:,:);
            graphs.lfp_places_freq(un,:,:)=lfpstructsingle_trim.cat_specgramMT_S_noB(4,:,:);
        end
        graphs.cat_specgramMT_T=lfpstructsingle_trim.cat_specgramMT_T;
        graphs.cat_specgramMT_F=lfpstructsingle_trim.cat_specgramMT_F;
        clear respstructsingle graphstructsingle lfpstructsingle_trim
    end

    %%% GENERATE THE FIGURE
    figure; clf; cla; % colour map showing category selectivity/proportion
    set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
    set(gca,'FontName','Arial','FontSize',8)
    subplot(3,3,1) % raw
    hold on
    plot(xrange,mean(graphs.faces_raw),'r-','LineWidth',1.5)
    plot(xrange,mean(graphs.fruit_raw),'m-','LineWidth',1.5)
    plot(xrange,mean(graphs.places_raw),'b-','LineWidth',1.5)
    plot(xrange,mean(graphs.bodyparts_raw),'y-','LineWidth',1.5)
    plot(xrange,mean(graphs.objects_raw),'g-','LineWidth',1.5)
    % error bars
    %plot(xrange,mean(graphs.faces_raw)+sem(graphs.faces_raw),'r-','LineWidth',0.5)
    %plot(xrange,mean(graphs.fruit_raw)+sem(graphs.fruit_raw),'m-','LineWidth',0.5)
    %plot(xrange,mean(graphs.places_raw)+sem(graphs.places_raw),'b-','LineWidth',0.5)
    %plot(xrange,mean(graphs.bodyparts_raw)+sem(graphs.bodyparts_raw),'y-','LineWidth',0.5)
    %plot(xrange,mean(graphs.objects_raw)+sem(graphs.objects_raw),'g-','LineWidth',0.5)
    %plot(xrange,mean(graphs.faces_raw)-sem(graphs.faces_raw),'r-','LineWidth',0.5)
    %plot(xrange,mean(graphs.fruit_raw)-sem(graphs.fruit_raw),'m-','LineWidth',0.5)
    %plot(xrange,mean(graphs.places_raw)-sem(graphs.places_raw),'b-','LineWidth',0.5)
    %plot(xrange,mean(graphs.bodyparts_raw)-sem(graphs.bodyparts_raw),'y-','LineWidth',0.5)
    %plot(xrange,mean(graphs.objects_raw)-sem(graphs.objects_raw),'g-','LineWidth',0.5)
    xlabel('Time from stimulus onset (ms)','FontSize',8); xlim([xrange(1) xrange(end)]);
    ylabel('Firing rate (sp/s)','FontSize',8); set(gca,'FontSize',7); ylim([0 30])
    title({[char(grids(gd)),' - Firing Rate (n=',num2str(numunits),')'],[monkey,' - ',type,' responses']},'FontSize',9,'FontWeight','Bold')
    plx_figuretitle(get(gca),grids(gd),9)

    subplot(3,3,2) % norm
    hold on
    plot(xrange,mean(graphs.faces_norm),'r-','LineWidth',1.5)
    plot(xrange,mean(graphs.fruit_norm),'m-','LineWidth',1.5)
    plot(xrange,mean(graphs.places_norm),'b-','LineWidth',1.5)
    plot(xrange,mean(graphs.bodyparts_norm),'y-','LineWidth',1.5)
    plot(xrange,mean(graphs.objects_norm),'g-','LineWidth',1.5)
    % error bars
    %plot(xrange,mean(graphs.faces_norm)+sem(graphs.faces_norm),'r-','LineWidth',0.5)
    %plot(xrange,mean(graphs.fruit_norm)+sem(graphs.fruit_norm),'m-','LineWidth',0.5)
    %plot(xrange,mean(graphs.places_norm)+sem(graphs.places_norm),'b-','LineWidth',0.5)
    %plot(xrange,mean(graphs.bodyparts_norm)+sem(graphs.bodyparts_norm),'y-','LineWidth',0.5)
    %plot(xrange,mean(graphs.objects_norm)+sem(graphs.objects_norm),'g-','LineWidth',0.5)
    %plot(xrange,mean(graphs.faces_norm)-sem(graphs.faces_norm),'r-','LineWidth',0.5)
    %plot(xrange,mean(graphs.fruit_norm)-sem(graphs.fruit_norm),'m-','LineWidth',0.5)
    %plot(xrange,mean(graphs.places_norm)-sem(graphs.places_norm),'b-','LineWidth',0.5)
    %plot(xrange,mean(graphs.bodyparts_norm)-sem(graphs.bodyparts_norm),'y-','LineWidth',0.5)
    %plot(xrange,mean(graphs.objects_norm)-sem(graphs.objects_norm),'g-','LineWidth',0.5)
    xlabel('Time from stimulus onset (ms)','FontSize',8); xlim([xrange(1) xrange(end)]);
    ylabel('Normalized firing rate (sp/s)','FontSize',8); set(gca,'FontSize',7);
    title('Normalized Firing Rate','FontSize',9,'FontWeight','Bold')

    subplot(3,3,3) % responses
    hold on
    pcolor(1:100,1:size(graphs.responses,1),graphs.responses)
    shading flat; % colorbar('SouthOutside');
    plot([20 20],[0 size(graphs.responses,1)],'k-','LineWidth',1)
    plot([40 40],[0 size(graphs.responses,1)],'k-','LineWidth',1)
    plot([60 60],[0 size(graphs.responses,1)],'k-','LineWidth',1)
    plot([80 80],[0 size(graphs.responses,1)],'k-','LineWidth',1)
    set(gca,'FontSize',7); box off; axis ij; ylim([0 size(graphs.responses,1)]);
    xlim([1 100]); set(gca,'XTick',[10 30 50 70 90],'XTickLabel',{'Faces','Fruit','Places','Bodyparts','Objects'})
    set(gca,'YTick',[1 size(graphs.responses,1)])
    ylabel('Neuron Number','FontSize',7)
    xlabel('Stimulus Identity','FontSize',1)
    
    subplot(3,3,4)
    hold on
    plot(-400:700,mean(graphs.lfp_faces),'r-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_bparts),'y-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_objects),'g-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_places),'b-','LineWidth',1)
    set(gca,'YDir','reverse'); xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
    xlabel('Time from stimulus onset (ms)','FontSize',7);
    ylabel('Voltage (mV)','FontSize',7); set(gca,'FontSize',7);

    subplot(3,3,5)
    hold on
    plot(-400:700,mean(graphs.lfp_faces_rect),'r-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_bparts_rect),'y-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_objects_rect),'g-','LineWidth',1)
    plot(-400:700,mean(graphs.lfp_places_rect),'b-','LineWidth',1)
    xlim([-200 400]); h=axis; plot([0 0],[h(3) h(4)],'k:');
    xlabel('Time from stimulus onset (ms)','FontSize',7);
    ylabel('Voltage (mV)','FontSize',7); set(gca,'FontSize',7);

    
% spectrograms - multitaper
subplot(3,3,6)
tmp=log(abs(squeeze(mean(graphs.lfp_face_freq))));
pcolor((graphs.cat_specgramMT_T(1,:)-0.4)*1000,graphs.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',7); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',7); set(gca,'FontSize',7); axis square; caxis([-20 -5])
title('Faces (multitaper)','FontSize',7); colormap(jet);
subplot(3,3,7)
tmp=log(abs(squeeze(mean(graphs.lfp_bparts_freq))));
pcolor((graphs.cat_specgramMT_T(1,:)-0.4)*1000,graphs.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',7); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',7); set(gca,'FontSize',7); axis square; caxis([-20 -5])
title('Bodyparts (multitaper)','FontSize',7);
subplot(3,3,8)
tmp=log(abs(squeeze(mean(graphs.lfp_objects_freq))));
pcolor((graphs.cat_specgramMT_T(1,:)-0.4)*1000,graphs.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',7); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',7); set(gca,'FontSize',7); axis square; caxis([-20 -5])
title('Objects (multitaper)','FontSize',7);
subplot(3,3,9)
tmp=log(abs(squeeze(mean(graphs.lfp_places_freq))));
pcolor((graphs.cat_specgramMT_T(1,:)-0.4)*1000,graphs.cat_specgramMT_F(1,:),tmp'); shading flat;
xlabel('Time from stimulus onset (ms)','FontSize',7); xlim([-200 400]); ylim([0 125]);
ylabel('Frequency (Hz)','FontSize',7); set(gca,'FontSize',7); axis square; caxis([-20 -5])
title('Places (multitaper)','FontSize',7);

    
    
    
    
    
    
    
    
    
    jpgfigname=[hmiconfig.rsvpanal,'RSVP_multispden_',char(grids(gd)),'_',type,'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVP_multispden_',char(grids(gd)),'_',type,'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end