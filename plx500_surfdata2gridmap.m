function gridmap=plx500_surfdata2gridmap(surfdata,option)
% Function to take surfdata (created by plx500_sortgrid_*) and convert it
% into a format suitable for pcolor
if nargin==1, option=0; end
if option==0,
    % create blank gridmap
    gridmap=zeros(16,16)-1;
    % convert surfdata X and Y to 1-15
    gridtemp=surfdata;
    gridtemp(:,1)=gridtemp(:,1)-4;
    gridtemp(:,2)=gridtemp(:,2)-11;
    for rr=1:size(gridtemp,1),
        gridmap(gridtemp(rr,1),gridtemp(rr,2))=gridtemp(rr,3);
    end
end
if option==1,
    % create blank gridmap
    gridmap=zeros(16,16);
    % convert surfdata X and Y to 1-15
    gridtemp=surfdata;
    gridtemp(:,1)=gridtemp(:,1)-4;
    gridtemp(:,2)=gridtemp(:,2)-12;
    for rr=1:size(gridtemp,1),
        gridmap(gridtemp(rr,1),gridtemp(rr,2))=gridtemp(rr,3);
    end
end
return