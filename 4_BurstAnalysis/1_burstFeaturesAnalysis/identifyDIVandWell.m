function [divNumbers, wellNames] = identifyDIVandWell(folderPath)
    % Get a list of file names in the folder
    files = dir(fullfile(folderPath, '*.mat'));  % Change the file extension accordingly
    
    % Initialize arrays to store DIV numbers and well names
    divNumbers = cell(numel(files), 1);
    wellNames = cell(numel(files), 1);
    
    % Regular expression patterns to identify DIV and well
    divPattern = '(?<=DIV)\d+';
    wellPattern = '(?<=DIV**_)\w';
    
    % Iterate over each file name
    for i = 1:numel(files)
        fileName = files(i).name;
        
        % Extract DIV number
        divMatch = regexp(fileName, divPattern, 'match');
        if ~isempty(divMatch)
            divNumbers{i} = divMatch{1};
        else
            divNumbers{i} = '';
        end
        
        % Extract well name
        wellNames{i} = findCapitalLetterBetweenStrings(fileName);
        %wellNames{i} = findLastLetterAfterUnderscore(fileName);

    end
    wellNames = unique(wellNames);
    divNumbers = unique(divNumbers);
end

