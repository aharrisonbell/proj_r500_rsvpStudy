function AFNIcoords=plx500_apml2xyz(monkinitial,APcoords);
% [x,y,z]=plx500_apml2xyz(ap,ml)
% by AHB, Mar2009
% Converts grid coords (AP,ML) to hard-coded X,Y,Z slice coords for
% comparing neuronal data to EPI timeseries data.
% Note: this program uses hard-coded values that were determined by
% comparing electrode scans and EPI/anatomicals
% monkinitial = 'S' or 'W'
% ap = anterior/posterior grid location (5-19mm)
% ml = medial/lateral grid location (13-27mm)

ap=APcoords(1); ml=APcoords(2);
if monkinitial=='S' % Stewie
    APrange=5:19;
    MLrange=13:27;
    cor_range=[19 19 18 18 17 17 16 16 15 15 14 14 13 13 12]; % x (must match to AFNI output)
    sag_range=[0 0 0 17 17 16 15 14 13 13 12 11 10 9 0]; % y
    axi_range=[29 29 28 28 26 26 26 25 25 25 24 24 23 23 23]; % z
    AFNIcoords(3)=cor_range(APrange==ap); % coronal
    AFNIcoords(1)=sag_range(MLrange==ml); % sagital
    AFNIcoords(2)=axi_range(APrange==ap); % axial
    %% Note: Stewie's data were clipped Ant/Post - 5 from Ant, 10, from
    %% post.  Therefore:
    AFNIcoords(3)=AFNIcoords(3)-5;
elseif monkinitial=='W', % wiggum
    APrange=5:19;
    MLrange=14:29;
    cor_range=[15 15 14 13 13 12 12 11 11 10 10 9 9 8 7]; % x (must match to AFNI output)
    sag_range=[46 47 48 49 49 50 51 52 53 54 54 55 56 57 58]; % y
    axi_range=[37 36 35 34 33 33 32 31 30 29 28 28 27 26 25]; % z
    AFNIcoords(3)=cor_range(APrange==ap); % coronal
    AFNIcoords(1)=sag_range(MLrange==ml); % sagital
    AFNIcoords(2)=axi_range(APrange==ap); % axial
    %% Note: Wiggum's data were clipped Ant/Post - 5 from Ant, 10, from
    %% post.  Therefore:
    AFNIcoords(3)=AFNIcoords(3)-5;
end
return
     