function nextLetter = findLetterAfterLastUnderscore(inputString)
    % Find the index of the last underscore in the input string
    lastUnderscoreIndex = find(inputString == '_', 1, 'last');
    
    % Check if an underscore was found
    if isempty(lastUnderscoreIndex)
        % If no underscore is found, return an empty character
        nextLetter = '';
    else
        % Extract the substring after the last underscore
        substringAfterUnderscore = inputString(lastUnderscoreIndex + 1:end);
        
        % Find the first letter after the last underscore
        firstLetterIndex = find(isletter(substringAfterUnderscore), 1);
        
        % Check if a letter is found
        if isempty(firstLetterIndex)
            % If no letter is found, return an empty character
            nextLetter = '';
        else
            % Extract the first letter after the last underscore
            nextLetter = substringAfterUnderscore(firstLetterIndex);
        end
    end
end