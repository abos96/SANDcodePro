%% Main plot for individual graph plotting
%This script plot single file graph contained in the RawfileMat folders


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
% ---------------------------- PROCESSING----------------------------------
for i = 1 : length(selectedItems)
    %% plot Node Degree
    file2load = replaceWord(selectedItems(i),'.mat','_NodeDegree.mat');
    pathfile2load = fullfile(connFolder,cell2mat(file2load));
    var2plot = load(pathfile2load);
    Ad2load = replaceWord(selectedItems(i),'.mat','_conn.mat');
    pathAd2load = fullfile(ADfolder,cell2mat(Ad2load));
    Ad2plot = load(pathAd2load);

    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(Ad2plot.adjMci,var2plot.coords,...
        0.01, var2plot.ND, 'Node Degree', var2plot.ND, 'Node Degree', 'MEA', connFolder,0.01);
    tit = strcat(cell2mat(selectedItems(i)),' Node Degree');
    tit = strrep(tit, '_', ' ');
    title(tit)

    % save picture
    % Save the figure as PNG
    pngFileName = replaceWord(file2load,'.mat','.png');
    saveas(figureHandle, fullfile(saveDir, cell2mat(pngFileName)), 'png');
    disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
    if strcmp(savesvg,'yes')
        % Save the figure as SVG
        svgFileName = replaceWord(file2load,'.mat','.svg');
        saveas(figureHandle, fullfile(saveDir, cell2mat(svgFileName)), 'svg');
        disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
    end
    close(figureHandle)
    %% Save Adj Matrix and coordinates
    AdjM = Ad2plot.adjMci;
    coords = var2plot.coords;
    %% plot Node Stregth
    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(Ad2plot.adjMci,var2plot.coords,...
        0.01, var2plot.NS, 'Node Strength', var2plot.NS, 'Node Strength', 'MEA', connFolder,0.01);
    tit = strcat(cell2mat(selectedItems(i)),' Node Strength');
    tit = strrep(tit, '_', ' ');
    title(tit)

    % save picture
    % Save the figure as PNG
    pngFileName = replaceWord(file2load,'NodeDegree.mat','NodeStrength.png');
    saveas(figureHandle, fullfile(saveDir, cell2mat(pngFileName)), 'png');
    disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
    if strcmp(savesvg,'yes')
        % Save the figure as SVG
        svgFileName = replaceWord(file2load,'NodeDegree.mat','NodeStrength.svg');
        saveas(figureHandle, fullfile(saveDir, cell2mat(svgFileName)), 'svg');
        disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
    end
    close(figureHandle)
    %% Local efficiency
    file2load = replaceWord(selectedItems(i),'.mat','_LocalEfficency.mat');
    pathfile2load = fullfile(connFolder,cell2mat(file2load));
    var2plot = load(pathfile2load);

    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(AdjM,coords,...
        0.01, var2plot.Eloc, 'LocalEfficiency', var2plot.Eloc, 'LocalEfficiency', 'MEA', connFolder,0.01);
    tit = strcat(cell2mat(selectedItems(i)),' Local Efficency');
    tit = strrep(tit, '_', ' ');
    title(tit)

    % save picture
    % Save the figure as PNG
    pngFileName = replaceWord(file2load,'.mat','.png');
    saveas(figureHandle, fullfile(saveDir, cell2mat(pngFileName)), 'png');
    disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
    if strcmp(savesvg,'yes')
        % Save the figure as SVG
        svgFileName = replaceWord(file2load,'.mat','.svg');
        saveas(figureHandle, fullfile(saveDir, cell2mat(svgFileName)), 'svg');
        disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
    end
    close(figureHandle)
    %% Partecipation Coefficient
    file2load = replaceWord(selectedItems(i),'.mat','_PartecipationCoefficient.mat');
    pathfile2load = fullfile(connFolder,cell2mat(file2load));
    var2plot = load(pathfile2load);

    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(AdjM,coords,...
        0.01, var2plot.PC, 'PartecipationCoefficient', var2plot.PC, 'PartecipationCoefficient', 'MEA', connFolder,0.01);
    tit = strcat(cell2mat(selectedItems(i)),' Partecipation Coefficient');
    tit = strrep(tit, '_', ' ');
    title(tit)

    % save picture
    % Save the figure as PNG
    pngFileName = replaceWord(file2load,'.mat','.png');
    saveas(figureHandle, fullfile(saveDir, cell2mat(pngFileName)), 'png');
    disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
    if strcmp(savesvg,'yes')
        % Save the figure as SVG
        svgFileName = replaceWord(file2load,'.mat','.svg');
        saveas(figureHandle, fullfile(saveDir, cell2mat(svgFileName)), 'svg');
        disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
    end
    close(figureHandle)
    %% Betwines Centrality
    file2load = replaceWord(selectedItems(i),'.mat','_BetweenessCentrality.mat');
    pathfile2load = fullfile(connFolder,cell2mat(file2load));
    var2plot = load(pathfile2load);

    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(AdjM,coords,...
        0.01, var2plot.BC, 'BetweenessCentrality', var2plot.BC, 'BetweenessCentrality', 'MEA', connFolder,0.01);
    tit = strcat(cell2mat(selectedItems(i)),' Betweeness Centrality');
    tit = strrep(tit, '_', ' ');
    title(tit)

    % save picture
    % Save the figure as PNG
    pngFileName = replaceWord(file2load,'.mat','.png');
    saveas(figureHandle, fullfile(saveDir, cell2mat(pngFileName)), 'png');
    disp(['Figure saved as ' fullfile(saveDir, pngFileName)]);
    if strcmp(savesvg,'yes')
        % Save the figure as SVG
        svgFileName = replaceWord(file2load,'.mat','.svg');
        saveas(figureHandle, fullfile(saveDir, cell2mat(svgFileName)), 'svg');
        disp(['Figure saved as ' fullfile(saveDir, svgFileName)]);
    end
    close(figureHandle)
end

% ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');