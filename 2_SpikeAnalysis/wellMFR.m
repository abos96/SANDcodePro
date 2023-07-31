function mfr_table = wellMFR(well_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dur = size(well_data.spikeTrain,1)./well_data.parameters.fs;
mfr = sum(well_data.spikeTrain,1)./dur;
% Create a table
mfr_table = table(well_data.channels', mfr', 'VariableNames', {'Channels', 'MFR'});
end