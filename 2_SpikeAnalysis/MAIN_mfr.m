% MAIN_mfr.m
% Table saved in MAT format only - 1 table for each phase
% mfr_table [elNumx3] (electrode name, MFR, acquisition time)


[start_folder]= selectfolder('Select the source folder that contains the PeakDetectionMAT files');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
cd(start_folder)

% ------------------------------------------------ VARIABLES

[mfr_thresh, cancwin, fs, cancelFlag]= uigetMFRinfo;
% mfr_thresh [spikes/sec]
% cancwin [msec]

% -------------------------------------------------
% MANAGING FOLDERS

if cancelFlag
    return
else
    cancwinsample= cancwin/1000*fs;
    first=3;
    artifact=[];
    peak_train=[];
    firingch=[];
    totaltime=[];

    [exp_num]=find_expnum(start_folder, '_PeakDetection');
    [SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num);
   
%-------------------------------------------------------------------------
% PROCESING compute and save mfr for each well
cd(start_folder)
nwells = length(dir)-2;
well = dir;
for i = 3 : nwells+2  %cycle over wells
    cd(start_folder)
    well_data = load(well(i).name);
    mfr_table = wellMFR(well_data);
    cd(SpikeAnalysis)
    % Save the table to a .mat file with a specified filename
    filename = well(i).name;  % Change this to your desired filename and extension
    filename_splitted = split(filename,'_');
    filename_splitted{end} = 'mfr.mat';
    filename = strjoin(filename_splitted, '_');
    save(filename, 'mfr_table');
end

    % ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');
    keep allmfr totaltime
end