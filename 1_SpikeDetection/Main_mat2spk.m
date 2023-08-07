% Script for managing MAT files (previously converted from DAT) and
% converting them into PEAK DETECTION files. The novelty of the sw is that the PD is made by a user-set inspection
% window and the absolute position of the peak is saved, instead of having the peak always in the same
% position of the window. In this way, the timing of each spike is maintained.
% by Alessio Boschi 2023

% -----------> INPUT FROM THE USER
filterFlag = 0;
absoluteThreshold = '';
threshold_calculation_window = [0, 1];

[start_folder]= uigetdir('C:\','Select the .mat files folder');
if isempty (start_folder)
    error('The folder is empty')
elseif ~strcmp(split(start_folder,'\'),'RawMatFiles') %check  if the name is correct
    error('The folder is not correct')
end

%% Get a list of all files in the folder
files = dir(fullfile(start_folder, '*.mat'));
items = cell(length(files),1);
for i = 1:numel(files)
    items{i} = files(i).name;
end

selectedItems = selectItemsFromListbox(items);
selectedItems = cell2struct(selectedItems','name',1);
%% Manage Spike Detection folder
% Move to the start folder containing raw .mat
cd(start_folder)
tmp = dir;
name_wells = selectedItems;         % name of the wells
num_wells = length(name_wells);  % number of files contained in the start folder

% create the spike detected file folder
cd(start_folder)
cd ..
% check if folder exist
if exist('SpikeDetection','dir')
    % do something
else   
    mkdir('SpikeDetection')
    cd('SpikeDetection')
    SpikeDetection_folder = pwd;
end



%% Parameter for Spike Detection
% To improve... create UI for parameters
prompt = {'Multiplier (int)','Fs  (Hz)','Refractary Period (ms)','Filter'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'4.5','10000','3','yes'};
answer = (inputdlg(prompt,dlgtitle,dims,definput));
n = str2double(answer{1});
fs = str2double(answer{2});
RefPeriod = str2double(answer{3});
filterFlag = answer{4};
valid_wname = "threshold";

%% Filtering TO DO...
if strcmp(filterFlag,'yes')
%     lowpass = 600;
%     highpass = 8000;
%     wn = [lowpass highpass] / (fs / 2);
%     filterOrder = 3;
%     [b, a] = butter(filterOrder, wn);
%     trace = filtfilt(b, a, double(trace));
end
%% Run Spike Detection

for count = 1 : num_wells
    
    cd(start_folder)
    tic
    fprintf('\n Loading %s ...', name_wells(count).name);
    well = load(name_wells(count).name);
    toc
    filename = split(name_wells(count).name,'.');
    filename = filename(1);
    num_channels = length(well.channels);
    fs = well.fs;
    channels = well.channels;
    fprintf('\n Detecting Spike in %s ...', cell2mat(filename));


    tic
    [spikeTrain, threshold] = detectSpikesThreshold(...
                                         well.dat,...
                                         n,...
                                         RefPeriod,...
                                         fs,...
                                         absoluteThreshold, ...
                                         threshold_calculation_window);
    toc                           
    clear well
    % Save the variables to a file
    parentDir = fileparts(start_folder); % Move to the upper folder
    cd(strcat(parentDir,'\SpikeDetection'));
    parameters.threshold=threshold;
    parameters.fs = fs;
    parameters.RefPeriod = RefPeriod;
    parameters.thr = n;
    save(cell2mat(strcat(filename,'_spike')), 'spikeTrain','-v7.3', 'channels','parameters');
    clear spikeTrain
end

% ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');

