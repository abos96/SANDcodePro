%% Script to plot the Bursting features saved in the cvs files
% Created plot MBR, %rnadSpikeburs, BD
% create plot for each well over the DIVs

%% select MeanStatreportBURST folder
[start_folder]= selectfolder('Select the MeanStatreportBURST folder');
if start_folder == 0
    % User canceled the folder selection
    disp('Folder selection canceled.');
else
    % Extract the folder name from the selected path
    [~, folderName, ~] = fileparts(start_folder);

    % Check if the last part of the folder name is "MeanStatReportBURST"
    targetName = 'MeanStatReportBURST';
    if strcmpi(folderName(end-numel(targetName)+1:end), targetName)
        disp(['The last part of the folder name is "', targetName, '".']);
    else
        disp(['The last part of the folder name is not "', targetName, '".']);
    end
end

%% select BurstDetectionFiles folderr
[BDfolder]= selectfolder('Select the BurstDetectionFiles folder');
if BDfolder == 0
    % User canceled the folder selection
    disp('Folder selection canceled.');
else
    % Extract the folder name from the selected path
    [~, folderName, ~] = fileparts(BDfolder);

    % Check if the last part of the folder name is "MeanStatReportBURST"
    targetName = 'BurstDetectionFiles';
    if strcmpi(folderName(end-numel(targetName)+1:end), targetName)
        disp(['The last part of the folder name is "', targetName, '".']);
    else
        disp(['The last part of the folder name is not "', targetName, '".']);
    end
end
%% Identify groups based on the file in the folder

% Find the number of DIV and well names
[divNumbers, wellNames] = identifyDIVandWell(BDfolder);

% List all files in the folder
files = dir(fullfile(start_folder, '*.csv'));

% Extract the filenames of .csv files from the structure array
csvFileNames = {files.name};

%% generate color

% Number of different colors (n)
n = length(wellNames);
% Create a matrix to store the RGB values
colormapValues = linspace(0, 1, n)';
colorsRGB = turbo(n);

%% load all the data
mbr = cell(length(wellNames),length(divNumbers));
RNDSPKxBurst = cell(length(wellNames),length(divNumbers));
BD = cell(length(wellNames),length(divNumbers));
[mbr{:}] = deal([0]);
[RNDSPKxBurst{:}] = deal([0]);
[BD{:}] = deal([0]);
maxthr_mbr = 0;
maxthr_rnd = 0;
maxthr_bd = 0;

cd(start_folder)
for i = 1 : length(divNumbers) %cycle over DIV 
    searchString = strcat('DIV',divNumbers{i});
    divFiles = findCSVFilesWithSpecificString(start_folder, searchString);

    for j = 1 : length(divFiles) %cycle over Well
        name = cell2mat(divFiles(j));
        dataMatrix = readtable(name);
        well = findLetterAfterLastUnderscore(name);
        wellIndex = find(strcmp(wellNames, well));
        % find maxes
        mbrtemp = table2array(dataMatrix(:,4));
        new_max_mbr = max(mbrtemp);
        if new_max_mbr > maxthr_mbr
            maxthr_mbr = new_max_mbr;
        end

        % find maxes
        rndtemp = table2array(dataMatrix(:,2));
        new_max_rndtemp  = max(rndtemp);
        if new_max_rndtemp > maxthr_rnd
            maxthr_rnd = new_max_rndtemp;
        end

         % find maxes
        bdtemp = table2array(dataMatrix(:,8));
        new_max_bd= max(bdtemp);
        if new_max_bd > maxthr_bd
            maxthr_bd = new_max_bd;
        end

        % Each row is a well, each column is a DIV
        mbr{wellIndex,i} = mbrtemp;  
        RNDSPKxBurst{wellIndex,i} =  rndtemp;
        BD{wellIndex,i} = bdtemp;
     end
end

%% MBR
figure
for i = 1 : length(divNumbers) %cycle over DIV
    for j = 1 : length(wellNames) %cycle over Well
        subplot(1,length(divNumbers),i)
        HalfViolinPlot(mbr{j,i}, j, colorsRGB(j,:), 0.1, 0)
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        if i == 1
           ylabel('MBR (burst/min)')
        end
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 maxthr_mbr])
end
sgtitle('MBR')

%% Random Spikes
figure
for i = 1 : length(divNumbers) %cycle over DIV
    for j = 1 : length(wellNames) %cycle over Well
        subplot(1,length(divNumbers),i)
        HalfViolinPlot(RNDSPKxBurst{j,i}, j, colorsRGB(j,:), 0.1, 0)
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
         if i == 1
           ylabel('RND SPK xBurst (%)')
         end
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 100])
end
sgtitle('% Random Spikes')
%% BD
figure
for i = 1 : length(divNumbers) %cycle over DIV
    for j = 1 : length(wellNames) %cycle over Well
        subplot(1,length(divNumbers),i)
        HalfViolinPlot(BD{j,i}, j, colorsRGB(j,:), 0.1, 0)
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
         if i == 1
        ylabel('Burst Duration (ms)')
         end
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 2000])
end
sgtitle('Burst Duration')

