function plx500_stimselect(files);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_stimselect(files); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by AHB, Sept 2008
% Analysis of stimulus selectivity for individual neurons listed in "FILES"
% Produces graphs showing individual responses to each stimulus.  Shows
% both individual spike density functions and histograms of each response.
% files = string matrix containing full unit names of files to analyze

%%% SETUP DEFAULTS
warning off;
hmiconfig=generate_hmi_configplex; % generates and loads config file
xrange=-200:400;
xscale=-200:400; % default time window
normwin=-100:0;
fontsize_sml=7; fontsize_med=8; fontsize_lrg=9;
if nargin==0,
    files={'Stew051408a1-sig003a' ...
        'Stew052208c1-sig003a' ...   
        'Stew052208d1-sig003a' ...   
        'Stew052308c1-sig003a' ...
        'Stew051408b1-sig003a' ...
        'Stew051408e1-sig001a' ...
        'Stew101007a1-sig003a' ...
        'Stew102507b1-sig001a' ...
        'Stew012408b1-sig004b' ...
        'Stew020108e1-sig001b' ...
        'Stew020108e1-sig004a' ...
        'Stew022208b1-sig003a' ...
        'Stew022508b2-sig003a' ...
        'Stew022808b1-sig004a' ...
        'Stew042808e1-sig003a' ...
        'Stew052008g1-sig003a' ...
        'Stew052308d1-sig003a' ...
        'Stew052708f1-sig003a' ...
        'Stew052908c1-sig002a' ...
        'Stew060408c1-sig004a' ...
        'Stew060408e1-sig004a' ...
        'Stew061108g1-sig001b' ...
        'Stew091508c1-sig004a' ...
        'Stew091508d1-sig004a' ...
        'Stew011209b1-sig003a'
        };
end
%'Stew022208b2-sig003a' ...
%'Stew051408a1-sig001b' ...
%'Stew051408a1-sig001c' ...
%'Stew022208b1-sig003b' ...
disp('******************************************************************')
disp('* plx500_stimselect.m - Analyzes individual neurons for stimulus *')
disp('*  selectivity.  Generates figures showing both individual spike *')
disp('*  density functions and histograms.                             *')
disp('******************************************************************')
disp(' ')

numunits=length(files);

for un=1:numunits,
    %%% generate spike density portion of figure
    disp(['Loading graph data for ',char(files(un)),'... '])
    load([hmiconfig.rsvp500spks,char(files(un)),'-500graphdata.mat']); % load unit graph data
    load([hmiconfig.rsvp500spks,char(files(un)),'-500responsedata.mat']); % load unit response data    
    figure
    clf; cla; set(gcf,'Units','Normalized'); set(gcf,'Position',[0.1 0.1 0.8 0.8]); set(gca,'FontName','Arial')
    xrange=(1000+xscale(1)):(1000+xscale(end));
    subplot(5,3,[1 4 7 10 13]) % colour plot
    pcolor(xscale,1:100,graphstructsingle.allconds_avg(:,xrange))
    shading flat
    %caxis([10 90])
    hold on
    plot([xscale(1) xscale(end)],[21 21],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[41 41],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[61 61],'w-','LineWidth',1)
    plot([xscale(1) xscale(end)],[81 81],'w-','LineWidth',1)
    plot([0 0],[0 100],'w:','LineWidth',1)
    colorbar('SouthOutside')
    text(401,graphstructsingle.bestconds(1)+0.5,['\leftarrow',num2str(graphstructsingle.bestconds(1))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstructsingle.bestconds(2)+20.5,['\leftarrow',num2str(graphstructsingle.bestconds(2))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstructsingle.bestconds(3)+40.5,['\leftarrow',num2str(graphstructsingle.bestconds(3))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstructsingle.bestconds(4)+60.5,['\leftarrow',num2str(graphstructsingle.bestconds(4))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(401,graphstructsingle.bestconds(5)+80.5,['\leftarrow',num2str(graphstructsingle.bestconds(5))],'FontSize',fontsize_lrg,'FontWeight','Bold')
    text(0,101.5,'0','FontSize',fontsize_sml,'HorizontalAlignment','Center')
    text(xscale(1),101.5,num2str(xscale(1)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
    text(xscale(end),101.5,num2str(xscale(end)),'FontSize',fontsize_sml,'HorizontalAlignment','Center')
    text(xscale(1)-(abs(xscale(1))*.5),10,['Faces (n=',num2str(length(find(respstructsingle.trial_id(:,2)==1))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    text(xscale(1)-(abs(xscale(1))*.5),30,['Fruit (n=',num2str(length(find(respstructsingle.trial_id(:,2)==2))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    text(xscale(1)-(abs(xscale(1))*.5),50,['Places (n=',num2str(length(find(respstructsingle.trial_id(:,2)==3))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    text(xscale(1)-(abs(xscale(1))*.5),70,['Bodyparts (n=',num2str(length(find(respstructsingle.trial_id(:,2)==4))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    text(xscale(1)-(abs(xscale(1))*.5),90,['Objects (n=',num2str(length(find(respstructsingle.trial_id(:,2)==5))),')'],'FontSize',fontsize_med,'HorizontalAlignment','Center','Rotation',90)
    set(gca,'FontSize',7); xlim([xscale(1) xscale(end)]); box off; axis off; axis ij; ylim([0 100]);
    signame=char(graphstructsingle.label);

%     figure; clf; cla; % 
%     set(gcf,'Units','Normalized','Position',[0.05 0.2 0.9 0.6]); set(gca,'FontName','Arial','FontSize',8)
%     subplot(3,5,1)
%     plotcndresp(graphstructsingle.allconds_avg,graphstructsingle.faces_avg,hmiconfig.faces500,xscale,'r-')
%     title('Faces','FontSize',10,'FontWeight','Bold')
%     plx_figuretitle(get(gca),files(un));
%     subplot(3,5,2)
%     plotcndresp(graphstructsingle.allconds_avg,graphstructsingle.fruit_avg,hmiconfig.fruit500,xscale,'m-')
%     title('Fruit','FontSize',10,'FontWeight','Bold')
%     subplot(3,5,3)
%     plotcndresp(graphstructsingle.allconds_avg,graphstructsingle.places_avg,hmiconfig.places500,xscale,'b-')
%     title('Places','FontSize',10,'FontWeight','Bold')
%     subplot(3,5,4)
%     plotcndresp(graphstructsingle.allconds_avg,graphstructsingle.bodyp_avg,hmiconfig.bodyp500,xscale,'y-')
%     title('Bodyparts','FontSize',10,'FontWeight','Bold')
%     subplot(3,5,5)
%     plotcndresp(graphstructsingle.allconds_avg,graphstructsingle.objct_avg,hmiconfig.objct500,xscale,'g-')
%     title('Objects','FontSize',10,'FontWeight','Bold')
    
    clear graphstructsingle
    
       
    
    %%% prepare histogram data
    histodata=struct('faces',zeros(20,3),'fruit',zeros(20,3),'places',zeros(20,3),'bodyparts',zeros(20,3),'objects',zeros(20,3));
    histodata.faces(:,1)=hmiconfig.faces500;
    histodata.fruit(:,1)=hmiconfig.fruit500;
    histodata.places(:,1)=hmiconfig.places500;
    histodata.bodyparts(:,1)=hmiconfig.bodyp500;
    histodata.objects(:,1)=hmiconfig.objct500;
    histodata.faces(:,2)=respstructsingle.m_epoch1(hmiconfig.faces500);
    histodata.fruit(:,2)=respstructsingle.m_epoch1(hmiconfig.fruit500);
    histodata.places(:,2)=respstructsingle.m_epoch1(hmiconfig.places500);
    histodata.bodyparts(:,2)=respstructsingle.m_epoch1(hmiconfig.bodyp500);
    histodata.objects(:,2)=respstructsingle.m_epoch1(hmiconfig.objct500);
    [histodata.faces(:,3) histodata.faces(:,4)]=sortrows(histodata.faces(:,2));
    [histodata.fruit(:,3) histodata.fruit(:,4)]=sortrows(histodata.fruit(:,2));
    [histodata.places(:,3) histodata.places(:,4)]=sortrows(histodata.places(:,2));
    [histodata.bodyparts(:,3) histodata.bodyparts(:,4)]=sortrows(histodata.bodyparts(:,2));
    [histodata.objects(:,3) histodata.objects(:,4)]=sortrows(histodata.objects(:,2));
    %%% plot data
    ind1=1;
    plotresphisto2(histodata.faces,ind1,[2 3])
    plotresphisto2(histodata.fruit,ind1,[5 6])
    plotresphisto2(histodata.places,ind1,[8 9])
    plotresphisto2(histodata.bodyparts,ind1,[11 12])
    plotresphisto2(histodata.objects,ind1,[14 15])
    
%     plotresphisto(histodata.faces,6,11)
%     plotresphisto(histodata.fruit,7,12)
%     plotresphisto(histodata.places,8,13)
%     plotresphisto(histodata.bodyparts,9,14)
%     plotresphisto(histodata.objects,10,15)
    % save figure
    jpgfigname=[hmiconfig.rsvpanal,'RSVP_stimselect_',char(files(un)),'.jpg']; print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
    illfigname=[hmiconfig.rsvpanal,'RSVP_stimselect_',char(files(un)),'.ai']; print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
    if hmiconfig.printer==1, print; end % prints the figure to the default printer (if printer==1)
end


return

%%%%%%%%%%%%%%%%%%%%%%%%
%%% NESTED FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function plotcndresp(datacnd,dataavg,cndnums,xrange,linestyle)
xwindow=1000+xrange(1):1000+xrange(end);
hold on
for cnd=cndnums(1):cndnums(end),
    plot(xrange,datacnd(cnd,xwindow),'k-','LineWidth',0.5)
end
plot(xrange,dataavg(xwindow),linestyle,'LineWidth',1.5)
xlabel('Time from stimulus onset (ms)','FontSize',8); xlim([xrange(1) xrange(end)]);
ylabel('Firing rate (sp/s)','FontSize',8); set(gca,'FontSize',7);
return

function plotresphisto(data,ind1,ind2)
subplot(3,5,ind1)
bar(1:20,data(:,2))
for x=1:20, text(x,-10,num2str(data(x,1)),'HorizontalAlignment','Center','FontSize',6); end
ylabel('Average response (sp/s)','FontSize',7); xlim([0.5 20.5]);
subplot(3,5,ind2)
bar(1:20,data(:,3))
for x=1:20, text(x,-10,num2str(data(x,4)),'HorizontalAlignment','Center','FontSize',6); end
ylabel('Average response (sp/s)','FontSize',7); xlim([0.5 20.5]);
return

function plotresphisto2(data,ind1,ind2)
% subplot(3,5,ind1)
% bar(1:20,data(:,2))
% for x=1:20, text(x,-10,num2str(data(x,1)),'HorizontalAlignment','Center','FontSize',6); end
% ylabel('Average response (sp/s)','FontSize',7); xlim([0.5 20.5]);
subplot(5,3,ind2)
bar(1:20,data(:,3))
for x=1:20, text(x,-10,num2str(data(x,4)),'HorizontalAlignment','Center','FontSize',6); end
ylabel('Average response (sp/s)','FontSize',7); xlim([0.5 22.5]);
text(21,30,['min: ',num2str(min(data(:,2)))],'FontSize',7)
text(21,20,['max: ',num2str(max(data(:,2)))],'FontSize',7)
text(21,10,['std: ',num2str(std(data(:,2)))],'FontSize',7)
return
