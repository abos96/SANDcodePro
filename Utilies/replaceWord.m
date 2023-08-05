function newString = replaceWord(inputString,oldstring,newstrinng)
    % Check if the input string contains 'conn'
    if contains(inputString, oldstring)
        % Replace 'conn' with 'spike'
        newString = strrep(inputString, oldstring, newstrinng);
    else
        % If 'conn' is not found, keep the input string unchanged
        newString = inputString;
    end
end