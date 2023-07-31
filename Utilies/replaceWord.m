function newString = replaceWord(inputString)
    % Check if the input string contains 'conn'
    if contains(inputString, 'conn')
        % Replace 'conn' with 'spike'
        newString = strrep(inputString, 'conn', 'spike');
    else
        % If 'conn' is not found, keep the input string unchanged
        newString = inputString;
    end
end