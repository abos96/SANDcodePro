function cellArray = findIndicesOfOnes(logicalMatrix,fs)
    % Find the linear indices of ones in the matrix
    linearIndices = find(logicalMatrix);
    
    % Convert linear indices to row and column subscripts
    [rowSub, colSub] = ind2sub(size(logicalMatrix), linearIndices);
    
    % Create a cell array to store the indices of ones for each row
    cellArray = cell(size(logicalMatrix, 2), 1);
    
    % Populate the cell array with indices of ones for each row
    for i = 1:numel(cellArray)
       cellArray{i} = rowSub(colSub==i)./fs;
    end
end