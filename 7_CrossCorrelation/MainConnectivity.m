%% Main script to compute adjacency matrix over the dataset

%% MAGANE FOLDER find Peak detection folder
[start_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
elseif strfind(start_folder,'Split')
    check = 1;
end

% Get a list of all files in the folder
files = dir(fullfile(start_folder, '*.mat'));

% Create Saving folder
cd(start_folder)
cd .. 
expfolder = pwd;
connFolder = strcat(expfolder,'\ADmatrices');

if ~exist(strcat(connFolder,'\ADmatrices'), 'dir')
    % If the folder doesn't exist, create it
    mkdir(connFolder);
    disp(['Folder "', connFolder, '" created successfully.']);
else
    disp(['Folder "', connFolder, '" already exists.']);
end

%% -----------> INPUT FROM THE USER
    [lag_ms, tail, rep_num]= uigetConnectinfo; % Get parameters from user
%% Load spike train and convert to Spike times
for i = 1 : length(files)
    cd(start_folder)
    well = load(files(i).name);
    channels = well.channels;
    spikeTimes = findIndicesOfOnes(well.spikeTrain, well.parameters.fs); % second
    
    %% Set up Parameter for Adj
    tic
    fprintf('\n Extracting Adjacency Matrix from %s ...',files(i).name);
    method = [];
    duration_s = length(well.spikeTrain)./well.parameters.fs;
    % Compute AdjM
    [adjM, adjMci] = adjM_thr_parallel(spikeTimes, method, lag_ms, tail, well.parameters.fs,...
        duration_s, rep_num);
    toc
    %% save files and Info
    cd(connFolder);
    newfilename = strrep(files(i).name, 'spike', 'conn');
    save(newfilename, 'spikeTimes', 'adjM', 'adjMci','channels')
end

% ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');