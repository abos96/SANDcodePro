function coords = getCoord(system)
switch system
    case 'MSC60'
        channels = [11, 12, 13, 14, 15, 16, 17, 18, ... 
                21, 22, 23, 24, 25, 26, 27, 28, ...
                31, 32, 33, 34, 35, 36, 37, 38, ...
                41, 42, 43, 44, 45, 46, 47, 48, ...
                51, 52, 53, 54, 55, 56, 57, 58, ...
                61, 62, 63, 64, 65, 66, 67, 68, ...,
                71, 72, 73, 74, 75, 76, 77, 78, ...,
                81, 82, 83, 84, 85, 86, 87, 88];
        
        channelsOrdering = ...
        [47, 48, 46, 45, 38, 37, 28, 36, 27, 17, 26, 16, 35, 25, ...
        15, 14, 24, 34, 13, 23, 12, 22, 33, 21, 32, 31, 44, 43, 41, 42, ...
        52, 51, 53, 54, 61, 62, 71, 63, 72, 82, 73, 83, 64, 74, 84, 85, 75, ...
        65, 86, 76, 87, 77, 66, 78, 67, 68, 55, 56, 58, 57];
        
        coords = zeros(length(channels), 2);
        coords(:, 2) = repmat(linspace(1, 0, 8), 1, 8);
        coords(:, 1) = repelem(linspace(0, 1, 8), 1, 8);
        
        subset_idx = find(~ismember(channels, [11, 81, 18, 88]));
        channels = channels(subset_idx);
        
        reorderingIdx = zeros(length(channels), 1);
        for n = 1:length(channels)
            reorderingIdx(n) = find(channelsOrdering(n) == channels);
        end 
        
        coords = coords(subset_idx, :);
end