
function matchingFiles = findMATFilesWithSpecificString(folderPath, searchString)
    % Get a list of all files in the folder
    files = dir(fullfile(folderPath, '*.mat'));
    
    % Initialize a cell array to store matching filenames
    matchingFiles = {};
    
    % Loop through the files and check for the specific string in the file names
    for i = 1:length(files)
        [~, fileName, ~] = fileparts(files(i).name);

        if contains(fileName, searchString, 'IgnoreCase', true)
            matchingFiles{end+1} = files(i).name;
        end
    end
end
