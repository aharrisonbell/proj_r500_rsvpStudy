function output=plx500_fmridata(monkinitial)
% function output=plx500_fmridata(monkinitial)
% by AHB, Mar2009
% Function to load fMRI data and generate 'fmristruct'

hmiconfig=generate_hmi_configplex;


disp('**********************************************************')
disp('* plx500_fmridata.m - Converts fMRIdata to Matlab Matrix *')
disp('**********************************************************')
if monkinitial=='S',
    fmridata=BrikLoad([hmiconfig.rsvpfmri,'Stewie_Norm_AllCondsMION+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rsvpfmri,'Stewie_fMRIstruct_SC.mat'],'fmridata');
elseif monkinitial=='W'
    fmridata=BrikLoad([hmiconfig.rsvpfmri,'Wiggum_Norm_AllConds+orig']);
    disp('Saving *.mat file...')
    save([hmiconfig.rsvpfmri,'Wiggum_fMRIstruct_SC.mat'],'fmridata');
end
return
