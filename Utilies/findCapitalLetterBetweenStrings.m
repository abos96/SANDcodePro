function capitalLetter = findCapitalLetterBetweenStrings(inputString)
    % Define the regular expression pattern
    pattern = '_([A-Z])_mfr\.mat';

    % Use the 'regexp' function to find matches
    match = regexp(inputString, pattern, 'tokens');

    % Check if a match is found
    if isempty(match)
        capitalLetter = [];
    else
        capitalLetter = match{1}{1};
    end
end