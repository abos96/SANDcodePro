%% Script to plot the MFR saved in the mat files
% Created plot MFR

%% select RawMat folder
[start_folder]= selectfolder('Select the Spike Analysis folder');
if start_folder == 0
    % User canceled the folder selection
    disp('Folder selection canceled.');
else
    % Extract the folder name from the selected path
    [~, folderName, ~] = fileparts(start_folder);

    % Check if the last part of the folder name is "SpikeAnalysis"
    targetName = 'SpikeAnalysis';
    if strcmpi(folderName(end-numel(targetName)+1:end), targetName)
        disp(['The last part of the folder name is "', targetName, '".']);
    else
        disp(['The last part of the folder name is not "', targetName, '".']);
    end
end
%% Parameter for MFR plotting -- Threshold for active electrodes
% To improve... create UI for parameters
prompt = {'threshold active electrode (Spike/s)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0.1'};
answer = (inputdlg(prompt,dlgtitle,dims,definput));
thr = str2double(answer{1});

%% Identify groups based on the file in the folder

% Find the number of DIV and well names
[divNumbers, wellNames] = identifyDIVandWell(start_folder);

% Extract the filenames of .csv files from the structure array
% List all files in the folder
cd(start_folder)
cd ..
rootfolder = pwd;
spikeAnalysis_folder = fullfile(rootfolder,"SpikeAnalysis");
cd(spikeAnalysis_folder);
files = dir(fullfile(spikeAnalysis_folder, '*.mat'));
FileNames = {files.name};

%% generate color

% Number of different colors (n)
n = length(wellNames);
% Create a matrix to store the RGB values
colormapValues = linspace(0, 1, n)';
colorsRGB = parula(n);

%% load all the data
mfr = cell(length(wellNames),length(divNumbers));
activeChannels = cell(length(wellNames),length(divNumbers));
[mfr{:}] = deal([0]);
[activeChannels{:}] = deal([0]);

cd(spikeAnalysis_folder)

for i = 1 : length(divNumbers) %cycle over DIV 
    searchString = strcat('DIV',divNumbers{i});
    divFiles = findMATFilesWithSpecificString(start_folder, searchString);

    for j = 1 : length(divFiles) %cycle over Well
        name = cell2mat(divFiles(j));
        dataMatrix = load(name);
        well = findCapitalLetterBetweenStrings(name);
        wellIndex = find(strcmp(wellNames, well));
        % Each row is a well, each column is a DIV
        allmfr = table2array(dataMatrix.mfr_table(:,2));
        % Impose a threshold for active electrode to plot
        thrmfr = allmfr(allmfr>thr);
        mfr{wellIndex,i} = thrmfr; 
        activeChannels{wellIndex,i} = length(thrmfr);
     end
end

%% Plot MFR
figure
thickness = 1./length(wellNames);
for i = 1 : length(divNumbers) %cycle over DIV
    for j = 1 : length(wellNames) %cycle over Well
        subplot(1,length(divNumbers),i)
        HalfViolinPlot(mfr{j,i}, j, colorsRGB(j,:), thickness, 0)
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('MFR (Spike/sec)')
        title(strcat('DIV',divNumbers{i}))
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])
end
sgtitle(strcat('Mean Firing Rate (thr: ',string(thr),'spike/s)'))
%% plot channels table
figure
thickness = 0.2; %1./length(divNumbers);
% Resize the cell array to 1x2
activeChannels2plot = {vertcat(activeChannels{:, 1}), vertcat(activeChannels{:, 2})};

for i = 1 : length(divNumbers) %cycle over DIV
        subplot(1,length(divNumbers),i)

        HalfViolinPlot(activeChannels2plot{i}, i, colorsRGB(i,:), thickness, 0)

        xticks(1 : length(wellNames))
        xticklabels(divNumbers)
        xlabel('DIV')
        ylabel('Active Channels')
        title(strcat('DIV',divNumbers{i}))
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 60])
end
sgtitle(strcat('Active Channels (thr: ',string(thr),'spike/s)'))


