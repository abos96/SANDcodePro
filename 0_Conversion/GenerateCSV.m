%% Generate csv spreedshit based on data in the RawFolder and experiment lookuptable 
% Get folder path using uigetdir
folderPath = uigetdir('Select a root folder of your experiment');

if folderPath == 0
    % User clicked cancel or closed the dialog
    disp('No folder selected.');
else
    % Define the file name
    fileName = 'Genotype_lookUpTable.csv';
    
    % Construct the full file path
    filePath = fullfile(folderPath, fileName);
    
    % Load the CSV file using readtable
    try
        lookupTable = readtable(filePath);
        
        % Display a message indicating successful loading
        disp(['CSV file "', fileName, '" loaded successfully.']);
        
        % Now you can work with the loaded lookupTable
        % For example, you can display its content using disp(lookupTable)
    catch
        % Display an error message if the file couldn't be loaded
        disp(['Error loading CSV file "', fileName, '".']);
    end
end
lookupTable = table2array(lookupTable);

%% Generate spreedshit file
% Define the path to the folder containing raw .mat files
RawMatFolder = fullfile(folderPath,'RawMatFiles');

% Call the function to generate the spreadsheet file
% The function arguments are:
% - 'y': Indicates that you want to create a spreadsheet
% - 'y': Indicates that you want to include a header row
% - lookupTable: The table containing your data
csv2save = fillBatchFile(RawMatFolder, 'y', 'y', lookupTable);

% Define the path and filename for the CSV file
csvFileName = 'spreedSheetExp.csv';  % Specify your desired filename

% Save the table as a CSV file
writetable(csv2save, csvFileName);
disp(['Table saved as ' csvFileName]);
