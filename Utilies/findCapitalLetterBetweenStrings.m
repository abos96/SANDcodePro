function capitalLetter = findCapitalLetterBetweenStrings(inputString,tag)
    % Define the regular expression pattern
    pattern = strcat('_([A-Z])',tag,'.mat');

    % Use the 'regexp' function to find matches
    match = regexp(inputString, pattern, 'tokens');

    % Check if a match is found
    if isempty(match)
        capitalLetter = [];
    else
        capitalLetter = match{1}{1};
    end
end