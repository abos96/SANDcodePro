% Get user inputs
% input folder
PDfolder = uigetdir(pwd,'Select the folder that contains the PeakDetectionMAT files:');
if strcmp(num2str(PDfolder),'0')          % halting case
    warndlg('Select a folder!','!!Warning!!')
    return
end
% output folder
[expFolderPath,PDFolderName] = fileparts(PDfolder);
% ISI thresholds file
ISIThFolder = uigetdir(expFolderPath,'Select the folder that contains the ISI thresholds:');
if strcmp(num2str(ISIThFolder),'0')          % halting case
    warndlg('Select a folder!','!!Warning!!')
    return
end
[saveFolderName, overwriteFlag] = createResultFolder(expFolderPath, 'BurstDetectionMAT');
if(isempty(saveFolderName))
    errordlg('Error creating output folder!','!!Error!!')
    return
end
% parameters
[parameters, flag] = burstDetection_getParam();
if(flag)        % arguments are correctly saved
    % Launch algorithm to detect bursts
    [newBurstDetection_cell, burstEvent_cell, outburstSpikes_cell,color] = burstDetection_trialCycle(PDfolder, ISIThFolder, parameters);
    % saves results
    flag2 = burstDetection_save(PDfolder, saveFolderName, parameters, newBurstDetection_cell(1:length(color),:), burstEvent_cell(1:length(color),:), outburstSpikes_cell(1:length(color),:));
    if(flag2)
        msgbox('Burst Detection', 'End Of Session', 'warn')
    else
        errordlg('Saving failed: end of session','Error')
    end
else
    errordlg('Selection failed: end of session','Error')
end