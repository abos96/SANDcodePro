%% Remove Noise from all the channels
function normalizedSignals = cleanData(signals,numChannel2mean)

    % Generate sample data (replace this with your actual data)
    % Step 1: Calculate standard deviation and peak-to-peak amplitude for each signal
    stdValues = std(signals);
    peakToPeakValues = max(signals) - min(signals);
    
    % Step 2: Compute the difference between std and peak-to-peak values
    differenceValues = abs(stdValues - peakToPeakValues);
    
    % Step 3: Find the indices of the first three signals with the smallest differences
    [~, sortedIndices] = sort(differenceValues);
    selectedSignalIndices = sortedIndices(2:2+numChannel2mean);
    
    % Step 4: Subtract the selected signals from all other signals
    referenceSignals = signals(:, selectedSignalIndices);
    normalizedSignals = bsxfun(@minus, signals, mean(referenceSignals, 2));

end