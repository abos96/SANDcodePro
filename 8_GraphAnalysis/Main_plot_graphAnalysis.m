%% Plot Graph statistic across DIVs

%% MAGANE FOLDER find Peak detection folder
[start_folder]= selectfolder('Select the RawMatFiles folder of your experiment');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
elseif strfind(start_folder,'Split')
    check = 1;
end

% Display the yes-no dialog box
savesvg = questdlg('Do you want save svg pictures?', ...
    'Confirmation', ...
    'Yes', 'No', 'Yes');

% Get a list of all files in the folder
files = dir(fullfile(start_folder, '*.mat'));
items = cell(length(files),1);
for i = 1:numel(files)
    items{i} = files(i).name;
end

selectedItems = selectItemsFromListbox(items);

%% Plot individual net graphs for each file
connFolder = replaceWord(start_folder,'RawMatFiles','ConnectivityAnalysis');
ADfolder = replaceWord(start_folder,'RawMatFiles','ADmatrices');
saveDir = connFolder;

%% Identify groups based on the file in the folder

% Find the number of DIV and well names
[divNumbers, wellNames] = identifyDIVandWell(start_folder);

% List all files in the folder
files = dir(fullfile(start_folder, '*.mat'));

% Extract the filenames of .csv files from the structure array
FileNames = {files.name};
%% generate color

% Number of different colors (n)
n = length(wellNames);
% Create a matrix to store the RGB values
colormapValues = linspace(0, 1, n)';
colorsRGB = parula(n);

%% Load all the data

% Create cell arrays to store different measures for each well and DIV
SWI = cell(length(wellNames), length(divNumbers));
PC = cell(length(wellNames), length(divNumbers));
BC = cell(length(wellNames), length(divNumbers));
LE = cell(length(wellNames), length(divNumbers));
ND = cell(length(wellNames), length(divNumbers));
Nhubs = cell(length(wellNames), length(divNumbers));

% Change current directory to 'connFolder' where data is stored
cd(connFolder)

% Loop over each DIV and each Well to load the corresponding data files
for i = 1 : length(divNumbers) % Cycle over DIV 
    searchString = strcat('DIV', divNumbers{i});
    divFiles = findMATFilesWithSpecificString(start_folder, searchString);

    for j = 1 : length(divFiles) % Cycle over Well
        name = cell2mat(divFiles(j));

        % Load files for each measure
        well = findLetterAfterLastUnderscore(name);
        wellIndex = find(strcmp(wellNames, well));
        ND{wellIndex, i} = load(replaceWord(name, '.mat', '_NodeDegree.mat'));
        PC{wellIndex, i} = load(replaceWord(name, '.mat', '_PartecipationCoefficient.mat'));
        BC{wellIndex, i} = load(replaceWord(name, '.mat', '_BetweenessCentrality.mat'));
        LE{wellIndex, i} = load(replaceWord(name, '.mat', '_LocalEfficency.mat'));
        Nhubs{wellIndex, i} = load(replaceWord(name, '.mat', '_Hubs.mat'));
        SWI{wellIndex, i} = load(replaceWord(name, '.mat', '_SmallWorldIndex.mat'));
    end
end
% save experimental name
expName = split(name,'_');
expName = join(expName(1:2),'_');
%% Plot Node Degree over DIV

% Create a figure to plot the Node Degree over DIV
F1 = figure();
for i = 1 : length(divNumbers) % Cycle over DIV
    for j = 1 : length(wellNames) % Cycle over Well

        % Create subplot for each DIV
        subplot(1, length(divNumbers), i)

        % Plot the HalfViolinPlot for Node Degree if data is not empty
        if ~isempty(ND{j, i})
            HalfViolinPlot(ND{j, i}.ND, j, colorsRGB(j, :), 0.1, 0)
        end
    end

    % Set x-ticks and labels for each subplot
    xticks(1 : length(wellNames))
    xticklabels(wellNames)
    xlabel('Wells')
    ylabel('Node Degree')
    title(divNumbers{i})
    aesthetics
    set(gca, 'TickDir', 'out');
    ylim([0 inf])
end
sgtitle('Node Degree')

% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_NodeDegre.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_NodeDegre.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%%
% Similar code blocks follow to plot other measures.
% They plot Partecipation Coefficient, Normalized Partecipation Coefficient,
% Betweeness Centrality, Local Efficieniency, Number of Hubs, and Small World Index.

%% Plot Node strengh over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(ND{j,i})
        HalfViolinPlot(ND{j,i}.NS, j, colorsRGB(j,:), 0.1, 0)
        end
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('Node Stregth')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Node Strength')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_NodeStrengh.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_NodeStrengh.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot Partecipation Coefficient over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(PC{j,i})
        HalfViolinPlot(PC{j,i}.PC, j, colorsRGB(j,:), 0.1, 0)
        end
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('Partecipation Coefficient')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Partecipation Coefficient')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_PartecipationCoefficient.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_PartecipationCoefficient.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot Normalized Partecipation Coefficient over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(PC{j,i})
        HalfViolinPlot(PC{j,i}.PCnorm, j, colorsRGB(j,:), 0.1, 0)
        end
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('Normalized Partecipation Coefficient')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Normalized Partecipation Coefficient')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_NormalizedPartecipationCoefficient.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_NormalizedPartecipationCoefficient.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot Betweeness Centrality over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(BC{j,i})
        HalfViolinPlot(BC{j,i}.BC, j, colorsRGB(j,:), 0.1, 0)
        end
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('Betweeness Centrality')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Betweeness Centrality')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_BetweenessCentrality.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_Betweeness Centrality.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot Local Efficieniency over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(LE{j,i})
        HalfViolinPlot(LE{j,i}.Eloc, j, colorsRGB(j,:), 0.1, 0)
        end
    end
        xticks(1 : length(wellNames))
        xticklabels(wellNames)
        xlabel('Wells')
        ylabel('Local Efficieniency')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Local Efficieniency')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_LocalEfficieniency.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_LocalEfficieniency.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot Number of Hubs over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(Nhubs{j,i})
        idx2plot(j) = length(Nhubs{j,i}.hubND);
        end
    end
        HalfViolinPlot(idx2plot, i, colorsRGB(i,:), 0.1, 0)
        xticks(1 : length(divNumbers))
        xticklabels(divNumbers)
        xlabel('DIV')
        ylabel('Number of Hubs')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Number of Hubs')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_NumberOfHubs.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_NumberOfHubs.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)
%% Plot SWI over DIV

F1 = figure();
for i = 1 : length(divNumbers) %cycle over DIV

    for j = 1 : length(wellNames) %cycle over Well
        
        subplot(1,length(divNumbers),i)
        if ~isempty(LE{j,i})
        idx2plot(j) = SWI{j,i}.SW;
        end
    end
        HalfViolinPlot(idx2plot, i, colorsRGB(i,:), 0.1, 0)
        xticks(1 : length(divNumbers))
        xticklabels(divNumbers)
        xlabel('DIV')
        ylabel('Small World Index')
        title(divNumbers{i})
        aesthetics
        set(gca,'TickDir','out');
        ylim([0 inf])

end
sgtitle('Small World Index')
% save picture
% Save the figure as PNG
pngFileName = strcat(expName,'_SmallWorldIndex.png');
saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'png');
disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
if strcmp(savesvg,'yes')
    % Save the figure as SVG
    pngFileName = strcat(expName,'_SmallWorldIndex.svg');
    saveas(F1, fullfile(saveDir, cell2mat(pngFileName)), 'svg');
    disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
end
close(F1)


%% ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');