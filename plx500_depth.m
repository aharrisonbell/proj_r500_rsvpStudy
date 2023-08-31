function plx500_depth(monkeyinitial,reload);
%%%%%%%%%%%%%%%%%%%%%%%%
% plx500_depth(filez); %
%%%%%%%%%%%%%%%%%%%%%%%%
% by AHB, Dec2008
% Charts neuronal preferences and other variables according to depth and
% grid location.

warning off;
%%% SETUP DEFAULTS
hmiconfig = generate_hmi_configplex; % generates and loads config file
if nargin==0, monkeyinitial='S'; reload=0; else nargin==1, reload=0; end
if monkeyinitial=='S', sheetname='RSVP Cells_S'; else monkeyinitial=='W', sheetname='RSVP Cells_W'; end

%%% LOAD FILE INFO
disp('********************'); disp('*** plx500_depth ***'); disp('********************');
if reload==1, disp('Refreshing RSVP neurons XLS matrix...'); [units,unitsx]=plx500_refreshXL(sheetname); 
else disp('Loading RSVP neurons XLS matrix...'); load([hmiconfig.rsvpanal,sheetname,'_XLS_Neurons.mat']);
end


%%% LOAD DATA
grids=unique(unitsx.GridLoc); numgrids=length(grids);
griddata=struct('gridloc',grids,'unitname',[],'depth',[],'neurtype',[],'pref_cat',[],'cat_sel',[],'resptype',[]);
griddataall=[];
for gd=1:numgrids,
    disp(['Analyzing grid location ',griddata(gd).gridloc,'...'])
    pointer=find(strcmp(unitsx.GridLoc,griddata(gd).gridloc)==1);   
    griddata(gd).unitname=unitsx.FullUnitName(pointer);
    griddata(gd).depth=unitsx.Depth(pointer);
    griddata(gd).neurtype=unitsx.SensoryConf(pointer);
    griddata(gd).pref_cat=unitsx.CategoryConf(pointer);
    griddata(gd).resptype=unitsx.ExciteConf(pointer);
    griddata(gd).gridAP_ML(1:2)=plx_convertgrid2ap(griddata(gd).gridloc);
    % paste locus info    
    griddata(gd).unit_id(1:length(pointer),1)=griddata(gd).gridAP_ML(1);
    griddata(gd).unit_id(1:length(pointer),2)=griddata(gd).gridAP_ML(2);
    griddata(gd).unit_id(1:length(pointer),3)=griddata(gd).depth;
    % translate neuron info
    for un=1:length(griddata(gd).depth),
        pointer0=find(strcmp(griddata(gd).neurtype,'Sensory')==0);
        pointer1=find(strcmp(griddata(gd).neurtype,'Sensory')==1);
        griddata(gd).unit_id(pointer0,4)=0;
        griddata(gd).unit_id(pointer1,4)=1;

        pointer0=find(strcmp(griddata(gd).pref_cat,'Faces')==1);
        pointer1=find(strcmp(griddata(gd).pref_cat,'Fruit')==1);
        pointer2=find(strcmp(griddata(gd).pref_cat,'Places')==1);
        pointer3=find(strcmp(griddata(gd).pref_cat,'Bodyparts')==1);
        pointer4=find(strcmp(griddata(gd).pref_cat,'Objects')==1);
        griddata(gd).unit_id(pointer0,5)=1;
        griddata(gd).unit_id(pointer1,5)=2;
        griddata(gd).unit_id(pointer2,5)=3;
        griddata(gd).unit_id(pointer3,5)=4;
        griddata(gd).unit_id(pointer4,5)=5;

        pointer0=find(strcmp(griddata(gd).resptype,'Excite')==1);
        pointer1=find(strcmp(griddata(gd).resptype,'Inhibit')==1);
        pointer2=find(strcmp(griddata(gd).resptype,'Both')==1);
        griddata(gd).unit_id(pointer0,6)=1;
        griddata(gd).unit_id(pointer1,6)=-1;
        griddata(gd).unit_id(pointer2,6)=2;
    end
    griddataall=[griddataall;griddata(gd).unit_id];
end

figure
clf; cla; set(gcf,'Units','Normalized'); set(gcf,'Position',[0.1 0.1 0.8 0.8]); set(gca,'FontName','Arial','FontSize',7)
subplot(3,3,1) % neurontype
hold on
pointer=find(griddataall(:,4)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1),pdata(:,3),'r.')
pointer=find(griddataall(:,4)==0); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)+0.3,pdata(:,3),'k.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([0 25]); ylim([2000 16000]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Depth (um)')
title('Sensory vs. Non-Responsive','FontSize',11,'FontWeight','Bold')
subplot(3,3,4) % bar graph
histdata=[];
pointer0=find(griddataall(:,4)==1); pdata0=griddataall(pointer0,[1 4]);
pointer1=find(griddataall(:,4)==0); pdata1=griddataall(pointer1,[1 4]);
histdata(1,:)=hist(pdata0(:,1),1:1:25);
histdata(2,:)=hist(pdata1(:,1),1:1:25);
bar(histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units');
subplot(3,3,7) % line graph
linedata=[];
for r=1:size(histdata,1), 
    linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; 
end
hold on
plot(1:1:25,linedata(1,:),'r-','LineWidth',2)
plot(1:1:25,linedata(2,:),'k-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units')
legend('S','nR','Location','SouthOutside','Orientation','Horizontal')

subplot(3,3,2) % preferred category
hold on
pointer=find(griddataall(:,5)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)-0.2,pdata(:,3),'r.')
pointer=find(griddataall(:,5)==2); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)-0.1,pdata(:,3),'m.')
pointer=find(griddataall(:,5)==3); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1),pdata(:,3),'b.')
pointer=find(griddataall(:,5)==4); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)+0.1,pdata(:,3),'y.')
pointer=find(griddataall(:,5)==5); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)+0.2,pdata(:,3),'g.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([0 25]); ylim([2000 16000]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Depth (um)')
title('Preferred Category','FontSize',11,'FontWeight','Bold')
subplot(3,3,5) % bar graph
histdata=[];
pointer0=find(griddataall(:,5)==1); pdata0=griddataall(pointer0,[1 4]);
pointer1=find(griddataall(:,5)==2); pdata1=griddataall(pointer1,[1 4]);
pointer2=find(griddataall(:,5)==3); pdata2=griddataall(pointer2,[1 4]);
pointer3=find(griddataall(:,5)==4); pdata3=griddataall(pointer3,[1 4]);
pointer4=find(griddataall(:,5)==5); pdata4=griddataall(pointer4,[1 4]);
histdata(1,:)=hist(pdata0(:,1),1:1:25);
histdata(2,:)=hist(pdata1(:,1),1:1:25);
histdata(3,:)=hist(pdata2(:,1),1:1:25);
histdata(4,:)=hist(pdata3(:,1),1:1:25);
histdata(5,:)=hist(pdata4(:,1),1:1:25);
bar(histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units')
subplot(3,3,8) % line graph
linedata=[];
for r=1:size(histdata,1), 
    linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; 
end
hold on
plot(1:1:25,linedata(1,:),'r-','LineWidth',2)
plot(1:1:25,linedata(2,:),'m-','LineWidth',2)
plot(1:1:25,linedata(3,:),'b-','LineWidth',2)
plot(1:1:25,linedata(4,:),'y-','LineWidth',2)
plot(1:1:25,linedata(5,:),'g-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units')
legend('F','Ft','P','Bp','O','Location','SouthOutside','Orientation','Horizontal')

subplot(3,3,3) % preferred category
hold on
pointer=find(griddataall(:,6)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)-0.1,pdata(:,3),'g.')
pointer=find(griddataall(:,6)==-1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1),pdata(:,3),'r.')
pointer=find(griddataall(:,6)==2); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,1)+0.1,pdata(:,3),'m.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([0 25]); ylim([2000 16000]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Depth (um)')
title('Excite/Inhibit/Both','FontSize',11,'FontWeight','Bold')

subplot(3,3,6) % bar graph
histdata=[];
pointer0=find(griddataall(:,6)==1); pdata0=griddataall(pointer0,[1 4]);
pointer1=find(griddataall(:,6)==-1); pdata1=griddataall(pointer1,[1 4]);
pointer2=find(griddataall(:,6)==2); pdata1=griddataall(pointer2,[1 4]);
histdata(1,:)=hist(pdata0(:,1),1:1:25);
histdata(2,:)=hist(pdata1(:,1),1:1:25);
histdata(3,:)=hist(pdata2(:,1),1:1:25);
bar(histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units')
subplot(3,3,9) % line graph
linedata=[];
for r=1:size(histdata,1), 
    linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; 
end
hold on
plot(1:1:25,linedata(1,:),'g-','LineWidth',2)
plot(1:1:25,linedata(2,:),'r-','LineWidth',2)
plot(1:1:25,linedata(3,:),'m-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from Interaural Axis (mm)'); ylabel('Number of units')
legend('E','I','B','Location','SouthOutside','Orientation','Horizontal')

%matfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_AP.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_AP.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_AP.ai'];
%hgsave(matfigname);
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end



figure
clf; cla; set(gcf,'Units','Normalized'); set(gcf,'Position',[0.1 0.1 0.8 0.8]); set(gca,'FontName','Arial','FontSize',7)
subplot(3,3,1) % neurontype
hold on
pointer=find(griddataall(:,4)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2),pdata(:,3),'r.')
pointer=find(griddataall(:,4)==0); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)+0.3,pdata(:,3),'k.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([17 27]); ylim([2000 16000]);
xlabel('Distance from midline (mm)'); ylabel('Depth (um)')
title('Sensory vs. Non-Responsive','FontSize',11,'FontWeight','Bold')
subplot(3,3,4) % bar graph
histdata=[];
pointer0=find(griddataall(:,4)==1); pdata0=griddataall(pointer0,[2 4]);
pointer1=find(griddataall(:,4)==0); pdata1=griddataall(pointer1,[2 4]);
histdata(1,:)=hist(pdata0(:,1),17:1:27);
histdata(2,:)=hist(pdata1(:,1),17:1:27);
bar(17:27,histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([17 27]);
xlabel('Distance from midline (mm)'); ylabel('Number of units');
subplot(3,3,7) % line graph
linedata=[];
for r=1:size(histdata,1), linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; end
hold on
plot(17:1:27,linedata(1,:),'r-','LineWidth',2)
plot(17:1:27,linedata(2,:),'k-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([17 27]);
xlabel('Distance from midline (mm)'); ylabel('Number of units')
legend('S','nR','Location','SouthOutside','Orientation','Horizontal')

subplot(3,3,2) % preferred category
hold on
pointer=find(griddataall(:,5)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)-0.2,pdata(:,3),'r.')
pointer=find(griddataall(:,5)==2); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)-0.1,pdata(:,3),'m.')
pointer=find(griddataall(:,5)==3); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2),pdata(:,3),'b.')
pointer=find(griddataall(:,5)==4); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)+0.1,pdata(:,3),'y.')
pointer=find(griddataall(:,5)==5); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)+0.2,pdata(:,3),'g.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([17 27]); ylim([2000 16000]);
xlabel('Distance from midline (mm)'); ylabel('Depth (um)')
title('Preferred Category','FontSize',11,'FontWeight','Bold')
subplot(3,3,5) % bar graph
histdata=[];
pointer0=find(griddataall(:,5)==1); pdata0=griddataall(pointer0,[2 4]);
pointer1=find(griddataall(:,5)==2); pdata1=griddataall(pointer1,[2 4]);
pointer2=find(griddataall(:,5)==3); pdata2=griddataall(pointer2,[2 4]);
pointer3=find(griddataall(:,5)==4); pdata3=griddataall(pointer3,[2 4]);
pointer4=find(griddataall(:,5)==5); pdata4=griddataall(pointer4,[2 4]);
histdata(1,:)=hist(pdata0(:,1),17:1:27);
histdata(2,:)=hist(pdata1(:,1),17:1:27);
histdata(3,:)=hist(pdata2(:,1),17:1:27);
histdata(4,:)=hist(pdata3(:,1),17:1:27);
histdata(5,:)=hist(pdata4(:,1),17:1:27);
bar(17:27,histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([17 27]);
xlabel('Distance from midline (mm)'); ylabel('Number of units')
subplot(3,3,8) % line graph
linedata=[];
for r=1:size(histdata,1), linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; end
hold on
plot(17:1:27,linedata(1,:),'r-','LineWidth',2)
plot(17:1:27,linedata(2,:),'m-','LineWidth',2)
plot(17:1:27,linedata(3,:),'b-','LineWidth',2)
plot(17:1:27,linedata(4,:),'y-','LineWidth',2)
plot(17:1:27,linedata(5,:),'g-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([0 25]);
xlabel('Distance from midline (mm)'); ylabel('Number of units')
legend('F','Ft','P','Bp','O','Location','SouthOutside','Orientation','Horizontal')

subplot(3,3,3) % preferred category
hold on
pointer=find(griddataall(:,6)==1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)-0.1,pdata(:,3),'g.')
pointer=find(griddataall(:,6)==-1); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2),pdata(:,3),'r.')
pointer=find(griddataall(:,6)==2); pdata=griddataall(pointer,[1 2 3]); plot(pdata(:,2)+0.1,pdata(:,3),'m.')
grid on; set(gca,'XDir','reverse','YDir','reverse','FontSize',7); xlim([17 27]); ylim([2000 16000]);
xlabel('Distance from midline (mm)'); ylabel('Depth (um)')
title('Excite/Inhibit/Both','FontSize',11,'FontWeight','Bold')

subplot(3,3,6) % bar graph
histdata=[];
pointer0=find(griddataall(:,6)==1); pdata0=griddataall(pointer0,[2 4]);
pointer1=find(griddataall(:,6)==-1); pdata1=griddataall(pointer1,[2 4]);
pointer2=find(griddataall(:,6)==2); pdata1=griddataall(pointer2,[2 4]);
histdata(1,:)=hist(pdata0(:,1),17:1:27);
histdata(2,:)=hist(pdata1(:,1),17:1:27);
histdata(3,:)=hist(pdata2(:,1),17:1:27);
bar(17:27,histdata','stack'); set(gca,'XDir','reverse','FontSize',7); xlim([17 27]);
xlabel('Distance from midline (mm)'); ylabel('Number of units')
subplot(3,3,9) % line graph
linedata=[];
for r=1:size(histdata,1), linedata(r,:)=((histdata(r,:)./(sum(histdata)))*100)'; end
hold on
plot(17:1:27,linedata(1,:),'g-','LineWidth',2)
plot(17:1:27,linedata(2,:),'r-','LineWidth',2)
plot(17:1:27,linedata(3,:),'m-','LineWidth',2)
set(gca,'XDir','reverse','FontSize',7); xlim([17 27]);
xlabel('Distance from midline (mm)'); ylabel('Number of units')
legend('E','I','B','Location','SouthOutside','Orientation','Horizontal')

%matfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_ML.fig'];
jpgfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_ML.jpg'];
%illfigname=[hmiconfig.figure_dir,'rsvp500_analysis',filesep,'RSVP500_DepthAnalysis_ML.ai'];
%hgsave(matfigname);
print(gcf,jpgfigname,'-djpeg') % generates an JPEG file of the figure
%print(gcf,illfigname,'-dill') % generates an Adobe Illustrator file of the figure
if hmiconfig.printer==1, % prints the figure to the default printer (if printer==1)
    print
end


return