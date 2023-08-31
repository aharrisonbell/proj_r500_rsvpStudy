function plx500_sortgrid(option);
%%%%%%%%%%%%%%%%%%%
% plx500_sortgrid %
%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept2008,
% Program to sort information according to grids.
% 1) Copies figures into individual subdirectories for each grid location.
% 2) Generate individual figure(s) for each grid location with summary
% information including pie charts, etc.

%%% SETUP DEFAULTS
warning off; close all;
hmiconfig=generate_hmi_configplex; % generates and loads config file
monkeyname = 'Stewie'; sheetname='RSVP Cells_S';
if nargin==0, option=[1]; end
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
minunitnum=5; % minimum number of units for site to be included in colormaps

disp('********************************************************************')
disp('* plx500_sortgrid.m - Sorts figures into individual subdirectories *')
disp('*   for each grid location.                                        *')
disp('********************************************************************')

%%% LOAD FILES AND PREPARE "FILES" MATRIX
junk=find(hmiconfig.excelfile==filesep);
excelname=hmiconfig.excelfile(junk(end)+1:end);
disp(['Scanning ',excelname,'(',sheetname,')'])
[allunits,unit_index]=loadfileinfo(hmiconfig,sheetname);
numunits=size(allunits,2);
disp(['..found ',num2str(numunits),' units'])
disp('..creating new unit names...')
for un=1:numunits,
    junk=char(allunits(un).PlxFile);
    allunits(un).NewUnitName=[junk(1:end-4),'-',char(allunits(un).UnitName)];
end
disp('Done.')
disp(' ')

%%% COUNT GRID LOCATIONS/NEURONS
numunits=size(allunits,2); grids=unique(unit_index.GridLoc); numgrids=length(grids);
counts_matrix=prep_countsmatrix(unit_index);

%%% SUMMARY FIGURE (collapsed across grids)
figure; clf; cla; %
set(gcf,'Units','Normalized','Position',[0.05 0.15 0.7 0.5])
set(gca,'FontName','Arial','FontSize',8)
subplot(2,3,1); pie(counts_matrix(numgrids+1).data(1:2,1),...
    {['n=',num2str(counts_matrix(numgrids+1).data(1,1)),'(',num2str(counts_matrix(numgrids+1).data(1,1)/sum(counts_matrix(numgrids+1).data(1:2,1))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(2,1)),'(',num2str(counts_matrix(numgrids+1).data(2,1)/sum(counts_matrix(numgrids+1).data(1:2,1))*100,'%1.2g'),'%)']})
title(['Sensory/Non-Responsive (n=',num2str(sum(counts_matrix(numgrids+1).data(1:2,1))),')'],'FontSize',fontsize_lrg,'FontWeight','Bold')
legend('S','NS','Location','Best')
subplot(2,3,2); pie(counts_matrix(numgrids+1).data(1:6,2),...
    {['n=',num2str(counts_matrix(numgrids+1).data(1,2)),'(',num2str(counts_matrix(numgrids+1).data(1,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(2,2)),'(',num2str(counts_matrix(numgrids+1).data(2,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(3,2)),'(',num2str(counts_matrix(numgrids+1).data(3,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(4,2)),'(',num2str(counts_matrix(numgrids+1).data(4,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(5,2)),'(',num2str(counts_matrix(numgrids+1).data(5,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,2)),'(',num2str(counts_matrix(numgrids+1).data(6,2)/sum(counts_matrix(numgrids+1).data(1:6,2))*100,'%1.2g'),'%)']})
title(['Preferred Categories (n=',num2str(sum(counts_matrix(numgrids+1).data(1:6,2))),')'],'FontSize',fontsize_lrg,'FontWeight','Bold')
legend('F','Ft','P','Bp','O','n/a','Location','Best')
subplot(2,3,4); pie(counts_matrix(numgrids+1).data(6,3:4),...
    {['n=',num2str(counts_matrix(numgrids+1).data(6,3)),'(',num2str(counts_matrix(numgrids+1).data(6,3)/sum(counts_matrix(numgrids+1).data(6,3:4))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,4)),'(',num2str(counts_matrix(numgrids+1).data(6,4)/sum(counts_matrix(numgrids+1).data(6,3:4))*100,'%1.2g'),'%)']})
title(['Selective/Non-Selective (n=',num2str(sum(counts_matrix(numgrids+1).data(6,3:4))),')'],'FontSize',fontsize_lrg,'FontWeight','Bold')
legend('S','NS','Location','Best')
subplot(2,3,5); pie(counts_matrix(numgrids+1).data(6,5:7),...
    {['n=',num2str(counts_matrix(numgrids+1).data(6,5)),'(',num2str(counts_matrix(numgrids+1).data(6,5)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,6)),'(',num2str(counts_matrix(numgrids+1).data(6,6)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)'] ...
    ['n=',num2str(counts_matrix(numgrids+1).data(6,7)),'(',num2str(counts_matrix(numgrids+1).data(6,7)/sum(counts_matrix(numgrids+1).data(6,5:7))*100,'%1.2g'),'%)']})
title(['Excite/Inhibit/Both (n=',num2str(sum(counts_matrix(numgrids+1).data(6,5:7))),')'],'FontSize',fontsize_lrg,'FontWeight','Bold')
legend('E','I','B','Location','Best')
subplot(2,3,3); bar(counts_matrix(numgrids+1).data(1:5,3:4),'stack')
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'})
legend('S','NS','Location','SouthEast'); ylabel('Number of Neurons')
title('Category Breakdown (Selective/Non-Selective)','FontWeight','Bold')
subplot(2,3,6); bar(counts_matrix(numgrids+1).data(1:5,5:7),'stack')
set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'})
legend('E','I','B','Location','SouthEast'); ylabel('Number of Neurons')
title('Category Breakdown (Excite/Inhibit/Both)','FontWeight','Bold')
jpgfigname=[hmiconfig.rsvpanal,'RSVP_SummaryFigure.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
illfigname=[hmiconfig.rsvpanal,'RSVP_SummaryFigure.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

%%% PART 1 - LOAD INDIVIDUAL FILES AND COMPILE QUANTITATIVE INFORMATION
if ismember(1,option)==1,
    data=[];
    data.cat_si=[]; data.cat_si_nobase=[]; data.face_trad=[]; data.anovas_group=[];
    for g=1:numgrids,
        data(g).grid_coords=plx_convertgrid2ap(grids(g)); % convert grid location to A/P coordindates
        gridind=find(strcmp(unit_index.GridLoc,grids(g))==1); % find all neurons for particular grid location
        numunits_grid=length(gridind);
        data(g).cat_si=[]; data(g).cat_si_nobase=[]; data(g).face_trad=0.01; data(g).anovas_group=[]; % initialize matrices
        data(g).numsensory=0; data(g).counts=zeros(1,5)*.01; data(g).countsmat=zeros(numunits_grid,5); data(g).within_counts=zeros(1,5); % initialize matrices
        for un=1:numunits_grid,
            load([hmiconfig.rsvp500spks,allunits(gridind(un)).NewUnitName,'-500responsedata.mat']); % load unit data
            data(g).cat_si=[data(g).cat_si;respstructsingle.cat_si(1:6,2)']; % concatenate selectivity indices
            data(g).cat_si_nobase=[data(g).cat_si_nobase;respstructsingle.cat_si_nobase(1:6,2)']; % concatenate selectivity indices (no baseline)
            data(g).face_trad=data(g).face_trad+respstructsingle.face_trad; % count "traditional" face selective neurons
            temp=respstructsingle.anova_within_group(:,:,2);
            data(g).anovas_group=[data(g).anovas_group;temp']; % concatenate within group anovas (for testing stimulus selectivity)
            if strcmp(respstructsingle.conf_neurtype,'Sensory')==1, % count number of sensory neurons
                data(g).numsensory=data(g).numsensory+1;
            end
            if strcmp(respstructsingle.conf_preferred_cat,'Faces')==1,
                data(g).counts(1)=data(g).counts(1)+1; data(g).countsmat(un,1)=data(g).countsmat(un,1)+1;
                if temp(1)<0.06, data(g).within_counts(1)=data(g).within_counts(1)+1; end % if anova for within cat is <0.06, increment 1
            end
            if strcmp(respstructsingle.conf_preferred_cat,'Fruit')==1,
                data(g).counts(2)=data(g).counts(2)+1; data(g).countsmat(un,2)=data(g).countsmat(un,2)+1;
                if temp(2)<0.06, data(g).within_counts(2)=data(g).within_counts(2)+1; end % if anova for within cat is <0.06, increment 1
            end
            if strcmp(respstructsingle.conf_preferred_cat,'Places')==1,
                data(g).counts(3)=data(g).counts(3)+1; data(g).countsmat(un,3)=data(g).countsmat(un,3)+1;
                if temp(3)<0.06, data(g).within_counts(3)=data(g).within_counts(3)+1; end % if anova for within cat is <0.06, increment 1
            end
            if strcmp(respstructsingle.conf_preferred_cat,'BodyParts')==1,
                data(g).counts(4)=data(g).counts(4)+1; data(g).countsmat(un,4)=data(g).countsmat(un,4)+1;
                if temp(4)<0.06, data(g).within_counts(4)=data(g).within_counts(4)+1; end % if anova for within cat is <0.06, increment 1
            end
            if strcmp(respstructsingle.conf_preferred_cat,'Objects')==1,
                data(g).counts(5)=data(g).counts(5)+1; data(g).countsmat(un,5)=data(g).countsmat(un,5)+1;
                if temp(5)<0.06, data(g).within_counts(5)=data(g).within_counts(5)+1; end % if anova for within cat is <0.06, increment 1
            end
        end
        % per grid measures
        data(g).numunits=numunits_grid;
        [data(g).cat_si_corr_mean data(g).cat_si_corr_sem   ]=mean_noncol(data(g).cat_si(:,1:5) .* data(g).countsmat);
        for cat=1:5, data(g).prop(cat)=data(g).counts(cat)/data(g).numsensory; end
    end

    %%% FIGURES
    figure; clf; cla; % traditional face selectivity
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(6,5,g)
        pie([data(g).face_trad data(g).numunits-data(g).face_trad])
        title([char(grids(g)),' (n=',num2str(data(g).numunits),')'],'FontSize',fontsize_lrg)
        if g==1, plx_figuretitle(get(gca),'Traditional Face Selectivity',12); end
    end
    legend('Face','Non-face','FontSize',5)

    figure; clf; cla; % liberal face selectivity (preferred category)
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.8 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(6,5,g)
        pie([data(g).face_trad data(g).counts(1)])
        title([char(grids(g)),' (n=',num2str(data(g).face_trad+data(g).counts(1)),')'],'FontSize',fontsize_lrg)
        if g==1, plx_figuretitle(get(gca),'Proportion of face-preferring neurons that are face selective (trad)',12); end
    end
    legend('FaceSel','FacePref','FontSize',5)

    % Individual jpegs for each category
    newmap=struct('cmap',zeros(64,3));
    for x=1:64,
        newmap(1).cmap(x,1)=x/64; % red
        newmap(1).cmap(x,2)=0.001; % red
        newmap(1).cmap(x,3)=0.001; % red
        newmap(2).cmap(x,1)=x/64; % purple
        newmap(2).cmap(x,2)=0.001; % purple
        newmap(2).cmap(x,3)=x/64; % purple
        newmap(3).cmap(x,1)=0.001; % blue
        newmap(3).cmap(x,2)=0.001; % blue
        newmap(3).cmap(x,3)=x/64; % blue
        newmap(4).cmap(x,1)=x/64; % yellow
        newmap(4).cmap(x,2)=x/64; % yellow
        newmap(4).cmap(x,3)=0.001; % yellow
        newmap(5).cmap(x,1)=0.001; % green
        newmap(5).cmap(x,2)=x/64; % green
        newmap(5).cmap(x,3)=0.001; % green
    end

    for pn=1:5,
        figure; clf; cla; % colour map showing category selectivity/proportion
        set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
        set(gca,'FontName','Arial','FontSize',8)
        labels={'Face','Fruit','Place','Bodypart','Object'};
        surfdata=[];
        validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids,
            if sum(data(g).counts)>=minunitnum, validgrids=[validgrids; g]; end
        end
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).prop(pn);
            if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        %%% clip NaNs
        ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
        vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
        [uu,vv]=meshgrid(ulin,vlin);
        pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
        h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
        hold on
        plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k'); % plot sample points
        axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
        axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5])
        cmap=newmap(pn).cmap;
        colormap(cmap);
        cmap=flipud(contrast(64)); colormap(cmap);
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from meridian (mm)','fontsize',7);
        title([char(labels(pn)),' Proportion'],'FontSize',9,'FontWeight','Bold')
        axis off
        colorbar('SouthOutside','FontSize',6);
        jpgfigname=[hmiconfig.rsvpanal,'RSVP_colormapsBW_',num2str(pn),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
        illfigname=[hmiconfig.rsvpanal,'RSVP_colormapsBW_',num2str(pn),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
        %if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
    end



    figure; clf; cla; % colour map showing category selectivity/proportion
    set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
    set(gca,'FontName','Arial','FontSize',8)
    labels={'Face','Fruit','Place','Bodypart','Object'};
    for pn=1:5,
        subplot(2,5,pn) % surface plot - face selectivity
        surfdata=[];
        validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids,
            if sum(data(g).counts)>=minunitnum,
                validgrids=[validgrids; g];
            end
        end
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).cat_si_corr_mean(pn);
            if isnan(surfdata(g,3))==1,
                surfdata(g,3)=0;
            end
        end
        %%% clip NaNs
        ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
        vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
        [uu,vv]=meshgrid(ulin,vlin);
        pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
        h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
        hold on
        plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
        axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
        axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5])
        cmap=newmap(pn).cmap;
        colormap(cmap);
        cmap=flipud(contrast(64)); colormap(cmap);
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from meridian (mm)','fontsize',7);
        title([char(labels(pn)),' Selectivity'],'FontSize',9,'FontWeight','Bold')
        axis off
    end
    colorbar('East','FontSize',6);

    for pn=1:5,
        subplot(2,5,pn+5) % surface plot - face selectivity
        surfdata=[];
        validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids,
            if sum(data(g).counts)>=minunitnum,
                validgrids=[validgrids; g];
            end
        end
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).prop(pn);
            if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        %%% clip NaNs
        ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
        vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
        [uu,vv]=meshgrid(ulin,vlin);
        pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
        h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
        hold on
        plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
        axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
        axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 .5])
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from meridian (mm)','fontsize',7);
        title([char(labels(pn)),' Proportion'],'FontSize',9,'FontWeight','Bold')
        axis off
    end
    colorbar('East','FontSize',6)
    jpgfigname=[hmiconfig.rsvpanal,'RSVP_colormaps.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVP_colormaps.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    
    %%% New Analysis - no interpolation
    figure; clf; cla; % colour map showing category selectivity/proportion
    set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6])
    set(gca,'FontName','Arial','FontSize',8)
    labels={'Face','Fruit','Place','Bodypart','Object'};
    for pn=1:5,
        subplot(2,5,pn) % surface plot - face selectivity
        surfdata=[];
        validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids,
            if sum(data(g).counts)>=minunitnum,
                validgrids=[validgrids; g];
            end
        end

        validgrids=1:numgrids; % do not eliminate grids
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).cat_si_corr_mean(pn);
            if isnan(surfdata(g,3))==1,
                surfdata(g,3)=0;
            end
        end
        %%% Need to convert surfdata to a 10*10 matrix
        gridmap=plx500_surfdata2gridmap(surfdata);
        pcolor(gridmap); shading flat
        axis square; 
        set(gca,'CLim',[0 .5])
        %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from meridian (mm)','fontsize',7);
        title([char(labels(pn)),' Proportion'],'FontSize',9,'FontWeight','Bold')
    end
   % colorbar('EastOutside','FontSize',6);

    for pn=1:5,
        subplot(2,5,pn+5) % surface plot - face selectivity
        surfdata=[];
        validgrids=[];
        % Filter out any sites that don't have at least 5 neurons
        for g=1:numgrids,
            if sum(data(g).counts)>=minunitnum,
                validgrids=[validgrids; g];
            end
        end
        for g=1:length(validgrids),
            gridloc=validgrids(g);
            surfdata(g,1:2)=data(gridloc).grid_coords;
            surfdata(g,3)  =data(gridloc).prop(pn);
            if isinf(surfdata(g,3))==1, surfdata(g,3)=1; end
            if isnan(surfdata(g,3))==1, surfdata(g,3)=0; end
        end
        %%% Need to convert surfdata to a 10*10 matrix
        gridmap=plx500_surfdata2gridmap(surfdata);
        pcolor(gridmap); shading flat
        axis square; 
        set(gca,'CLim',[0 .5])
        %set(gca,'YTick',1:15,'YTickLabel',5:19,'XTick',15:29,'XTickLabel',15:29)
        xlabel('Distance from interaural axis (mm)','fontsize',7);
        ylabel('Distance from meridian (mm)','fontsize',7);
        title([char(labels(pn)),' Selectivity'],'FontSize',9,'FontWeight','Bold')
        axis off
    end
    colorbar('EastOutside','FontSize',6)
    jpgfigname=[hmiconfig.rsvpanal,'RSVP_colormaps_nointerp.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVP_colormaps_nointerp.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    
    
    
    
    
    %%% stimulus electivity according to category (preferred)
    figure; clf; cla; %
    set(gcf,'Units','Normalized','Position',[0.05 0.25 0.9 0.6])
    set(gca,'FontName','Arial','FontSize',8)
    subplot(1,2,1)
    bardata=zeros(5,2);
    for g=1:numgrids,
        for c=1:5,
            bardata(c,1)=bardata(c,1)+data(g).counts(c);
            bardata(c,2)=bardata(c,2)+data(g).within_counts(c);
        end
    end
    bardata(:,3)=bardata(:,1)-bardata(:,2);
    bar(bardata(:,2:3),'stack')
    for c=1:5, text(c,bardata(c,1)+5,[num2str(bardata(c,2)/bardata(c,1)*100,'%1.2g'),'%'],'FontSize',7); end
    set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'}); axis square
    legend('StimS','StimNS','Location','SouthEast'); ylabel('Number of Neurons')
    title('Within Category Selectivity (per category)','FontWeight','Bold')
    %%% stimulus selectivity according to grid location
    subplot(1,2,2) % surface plot - face selectivity
    surfdata=[];
    for g=1:numgrids,
        surfdata(g,1:2)=data(g).grid_coords;
        surfdata(g,3)=sum(data(g).within_counts)/sum(data(g).counts);
    end
    %%% clip NaNs
    ulin=linspace(min(surfdata(:,1)),max(surfdata(:,1)),30);
    vlin=linspace(min(surfdata(:,2)),max(surfdata(:,2)),30);
    [uu,vv]=meshgrid(ulin,vlin);
    pp=griddata(surfdata(:,1),surfdata(:,2),surfdata(:,3),uu,vv,'cubic');
    h=surface(uu,vv,pp,'linestyle','none','facecolor','interp');
    hold on
    plot3(surfdata(:,1),surfdata(:,2),surfdata(:,3),'k.','MarkerSize',10,'markerfacecolor','k');
    axis([min(surfdata(:,1)) max(surfdata(:,1)) min(surfdata(:,2)) max(surfdata(:,2))]);
    axis square; set(gca,'XDir','reverse','YDir','reverse','CLim',[0 1])
    xlabel('Distance from interaural axis (mm)','fontsize',7);
    ylabel('Distance from meridian (mm)','fontsize',7);
    title('Proportion of Stimulus Selective Neurons','FontSize',9,'FontWeight','Bold')
    %axis off
    colorbar('EastOutSide','FontSize',6)
    jpgfigname=[hmiconfig.rsvpanal,'RSVP_stimulusselectivity.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVP_stimulusselectivity.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end

%%% PART 2 - COMPILE NEURON COUNTS PER GRID
if ismember(2,option)==1,
    %%%%%%%% FIGURES %%%%%%%%
    figure; clf; cla; % sensory/non-responsive
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        pie(counts_matrix(g).data(1:2,1))
        title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
        legend('S','NS','FontSize',5)
        if g==1, figure_title(get(gca),'All Neurons: Sensory vs. Non-Responsive',12); end
    end
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_sensory_all.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_sensory_all.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    figure; clf; cla; % sensory neurons: preferred category
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        if sum(counts_matrix(g).data(1:5,2))>0,
            pie(counts_matrix(g).data(1:5,2))
            title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
            legend('F','Ft','P','Bp','O','FontSize',5)
        end
        if g==1, figure_title(get(gca),'Sensory Neurons: Preferred Category',12); end
    end
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_prefcat.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_prefcat.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    figure; clf; cla; % sensory neurons: category-selective
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        if sum(counts_matrix(g).data(6,3:4))>0
            pie(counts_matrix(g).data(6,3:4))
            title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
            legend('S','NS','FontSize',5)
        end
        if g==1, figure_title(get(gca),'Sensory Neurons: Category-Selective/Non-Selective',12); end
    end
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_selective_all.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_selective_all.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    figure; clf; cla; % preferred categories/selective/non-selective breakdown per category
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        bar(counts_matrix(g).data(1:5,3:4),'stack')
        set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'},'FontSize',fontsize_sml); xlim([0.5 5.5])
        title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
        if g==1, figure_title(get(gca),'Sensory Neurons: Category-Selective/Non-Selective',12); end
    end
    legend('S','NS','FontSize',5);
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_selective_break.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_selective_break.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    figure; clf; cla; % excite/inhibit/both
    set(gcf,'Units','Normalized','Position',[0.05 0.05 0.9 0.9])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        if sum(counts_matrix(g).data(6,5:7))>0
            pie(counts_matrix(g).data(6,5:7))
            title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
            legend('E','I','B','FontSize',5)
        end
        if g==1, figure_title(get(gca),'Sensory Neurons: Excite/Both/Inhibited',12); end
    end
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_excite_all.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_excite_all.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)

    figure; clf; cla; % preferred categories/excite/inhibit/both breakdown per category
    set(gcf,'Units','Normalized','Position',[0.05 0.15 0.9 0.7])
    set(gca,'FontName','Arial','FontSize',8)
    for g=1:numgrids
        subplot(5,5,g)
        bar(counts_matrix(g).data(1:5,5:7),'stack')
        set(gca,'XTick',1:5,'XTickLabel',{'F','Ft','P','Bp','O'},'FontSize',fontsize_sml); xlim([0.5 5.5])
        title([char(grids(g)),' (n=',num2str(sum(counts_matrix(g).data(1:2,1))),')'],'FontSize',fontsize_lrg)
        if g==1, figure_title(get(gca),'Sensory Neurons: Excite/Both/Inhibited',12); end
    end
    legend('E','I','B','FontSize',5)
    jpgfigname=[hmiconfig.rsvpanal,'RSVPgrid_excite_break.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVPgrid_excite_break.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end


%%% PART 3 - PASTE FIGURES FOR EACH GRID INTO SEPARATE SUBDIRECTORIES
if ismember(3,option)==1,
    for g=1:numgrids,
        disp(['Grid: ',char(grids(g))])
        mkdir([hmiconfig.rsvpanal,'GridBreakDown',filesep,char(grids(g))]);
        gridind=find(strcmp(unit_index.GridLoc,grids(g))==1);
        %%% copy figure to directory
        for un=1:length(gridind),
            try 
                copyfile(...
                    [hmiconfig.figure_dir,'rsvp500',filesep,char(allunits(gridind(un)).NewUnitName),'_rsvp500_Mean Spden.jpg'],...
                    [hmiconfig.rsvpanal,'GridBreakDown',filesep,char(grids(g)),filesep,char(allunits(gridind(un)).NewUnitName),'_rsvp500_Mean Spden.jpg']);
                disp(['..Copied figure for ',char(allunits(gridind(un)).NewUnitName)])
            catch
                disp(['..Unable to copy figure for ',char(allunits(gridind(un)).NewUnitName)])
            end
        end
    end
end
return

%%% NESTED FUNCTIONS %%%
function [units,unitsx]=loadfileinfo(hmiconfig,sheetname)
%%% LOAD DATA
[crap,unitsx.PlxFile]=xlsread(hmiconfig.excelfile,sheetname,'B5:B800'); % alpha, PlexonFilename
[crap,unitsx.UnitName]=xlsread(hmiconfig.excelfile,sheetname,'C5:C800'); % alpha, Unitname
%[crap,unitsx.UnitMatch]=xlsread(hmiconfig.excelfile,sheetname,'D5:D800'); % alpha, Unitmatch
[crap,unitsx.GridLoc]=xlsread(hmiconfig.excelfile,sheetname,'E5:E800'); % alphanumeric, GridLocation
unitsx.Depth=xlsread(hmiconfig.excelfile,sheetname,'F5:F800'); % numeric, Depth
[crap,unitsx.APIndex]=xlsread(hmiconfig.excelfile,sheetname,'G5:G800'); % alphanumeric, APIndex
[crap,unitsx.EstimatedLocation]=xlsread(hmiconfig.excelfile,sheetname,'H5:H800'); % alphanumeric, Estimated Location
[crap,unitsx.SensoryAuto]=xlsread(hmiconfig.excelfile,sheetname,'I5:I800'); % alpha, Sensory, automated
[crap,unitsx.SensoryConf]=xlsread(hmiconfig.excelfile,sheetname,'J5:J800'); % alpha, Sensory, confirmed
[crap,unitsx.CategoryAuto]=xlsread(hmiconfig.excelfile,sheetname,'K5:K800'); % alpha, Sensory, automated
[crap,unitsx.CategoryConf]=xlsread(hmiconfig.excelfile,sheetname,'L5:L800'); % alpha, Sensory, confirmed
[crap,unitsx.SelectiveAuto]=xlsread(hmiconfig.excelfile,sheetname,'M5:M800'); % alpha, Selective, automated
[crap,unitsx.SelectiveConf]=xlsread(hmiconfig.excelfile,sheetname,'N5:N800'); % alpha, Selective, confirmed
[crap,unitsx.ExciteAuto]=xlsread(hmiconfig.excelfile,sheetname,'O5:O800'); % alpha, Excite/Inhibit, automated
[crap,unitsx.ExciteConf]=xlsread(hmiconfig.excelfile,sheetname,'P5:P800'); % alpha, Excite/Inhibit, confirmed
unitsx.Quality=xlsread(hmiconfig.excelfile,sheetname,'Q5:Q800'); % numeric

%%% RESHUFFLE STRUCTURE AND SAVE INDIVIDUAL LOCATION FILES
for un=1:length(unitsx.PlxFile),
    units(un).PlxFile=unitsx.PlxFile(un);
    units(un).UnitName=unitsx.UnitName(un);
    units(un).GridLoc=unitsx.GridLoc(un);
    units(un).Depth=unitsx.Depth(un);
    units(un).APIndex=unitsx.APIndex(un);
    units(un).EstimatedLocation=unitsx.EstimatedLocation(un);
    units(un).SensoryAuto=unitsx.SensoryAuto(un);
    units(un).SensoryConf=unitsx.SensoryConf(un);
    units(un).CategoryAuto=unitsx.CategoryAuto(un);
    units(un).CategoryConf=unitsx.CategoryConf(un);
    units(un).SelectiveAuto=unitsx.SelectiveAuto(un);
    units(un).SelectiveConf=unitsx.SelectiveConf(un);
    units(un).ExciteAuto=unitsx.ExciteAuto(un);
    units(un).ExciteConf=unitsx.ExciteConf(un);
    units(un).Quality=unitsx.Quality(un);
end
return

function counts_matrix=prep_countsmatrix(unit_index)
grids=unique(unit_index.GridLoc);
numgrids=length(grids);
counts_matrix=[];
for g=1:numgrids,
    gridind=find(strcmp(unit_index.GridLoc,grids(g))==1);
    % sensory or non-responsive
    counts_matrix(g).data(1,1)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,1)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.SensoryConf,'Non-Responsive')==1));
    counts_matrix(g).data(3,1)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.SensoryConf,'Sensory')~=1 & strcmp(unit_index.SensoryConf,'Non-Responsive')~=1));
    % preferred category
    counts_matrix(g).data(1,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(6,2)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'n/a')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    % category-selective(col3)/category-non-selective(col4)
    counts_matrix(g).data(1,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));

    counts_matrix(g).data(1,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));

    counts_matrix(g).data(6,3)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(6,4)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.SelectiveConf,'Selective')~=1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    % excite(col5)/inhibit(col6)/both(col7)
    counts_matrix(g).data(1,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(6,5)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(1,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(6,6)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(1,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(2,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(3,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(4,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(5,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
    counts_matrix(g).data(6,7)=length(find(strcmp(unit_index.GridLoc,grids(g))==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
end

% sensory or non-responsive
counts_matrix(numgrids+1).data(1,1)=length(find(strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,1)=length(find(strcmp(unit_index.SensoryConf,'Non-Responsive')==1));
counts_matrix(numgrids+1).data(3,1)=length(find(strcmp(unit_index.SensoryConf,'Sensory')~=1 & strcmp(unit_index.SensoryConf,'Non-Responsive')~=1));
% preferred category
counts_matrix(numgrids+1).data(1,2)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,2)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,2)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,2)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,2)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(6,2)=length(find(strcmp(unit_index.CategoryConf,'n/a')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
% category-selective(col3)/category-non-selective(col4)
counts_matrix(numgrids+1).data(1,3)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,3)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,3)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,3)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,3)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(1,4)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,4)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,4)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,4)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,4)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.SelectiveConf,'Not Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));

counts_matrix(numgrids+1).data(6,3)=length(find(strcmp(unit_index.SelectiveConf,'Selective')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(6,4)=length(find(strcmp(unit_index.SelectiveConf,'Selective')~=1 & strcmp(unit_index.SensoryConf,'Sensory')==1));

% excite(col5)/inhibit(col6)/both(col7)
counts_matrix(numgrids+1).data(1,5)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,5)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,5)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,5)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,5)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(6,5)=length(find(strcmp(unit_index.ExciteConf,'Excite')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(1,6)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,6)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,6)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,6)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,6)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(6,6)=length(find(strcmp(unit_index.ExciteConf,'Inhibit')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(1,7)=length(find(strcmp(unit_index.CategoryConf,'Faces')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(2,7)=length(find(strcmp(unit_index.CategoryConf,'Fruit')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(3,7)=length(find(strcmp(unit_index.CategoryConf,'Places')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(4,7)=length(find(strcmp(unit_index.CategoryConf,'BodyParts')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(5,7)=length(find(strcmp(unit_index.CategoryConf,'Objects')==1 & strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
counts_matrix(numgrids+1).data(6,7)=length(find(strcmp(unit_index.ExciteConf,'Both')==1 & strcmp(unit_index.SensoryConf,'Sensory')==1));
return

function [redmap,yellowmap,bluemap,greenmap]=cat_colormaps
redmap=zeros(64,3); yellowmap=zeros(64,3); bluemap=zeros(64,3); greenmap=zeros(64,3);
for x=1:64,
    redmap(x,1)=x/64;
    greenmap(x,2)=x/64;
    bluemap(x,3)=x/64;
    yellowmap(x,1)=x/64;
    yellowmap(x,2)=x/64;
end
return;



