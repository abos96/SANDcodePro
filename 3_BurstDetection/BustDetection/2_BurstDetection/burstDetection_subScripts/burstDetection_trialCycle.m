% burstDetection_trialCycle.m
% Detects bursts from the collection of peak
% trains (trial by trial)
function [newBurstDetection_cell, burstEvent_cell, outburstSpikes_cell,color] = ...
    burstDetection_trialCycle(startPath, ISIThFolder, userParam)
% count number of different trials
trialFolders = dirr(startPath);
numTrials = length(trialFolders); 
% initialize variables
maxNumElec = 256;
newBurstDetection_cell = cell(maxNumElec,numTrials);
burstEvent_cell = cell(maxNumElec,numTrials);
outburstSpikes_cell = cell(maxNumElec,numTrials);
% ------ COMPUTATION ------
cancWinSample = userParam.cancWin*1e-3*userParam.sf;    % [sample]
hWB = waitbar(0,'Burst Detection...Please wait...','Position',[50 50 275 50]);
u = 0;



 [FileName,PathName] = uigetfile('*.mat','Select a ColorElectrode file');
    if strcmp(num2str(FileName),'0')
        errordlg('Selection Failed - End of Session', 'Error');
        return
    end
    load(fullfile(PathName,FileName));
    
    if length(color) == 252
        mcs = MEA256_lookuptable;
    elseif length(color) == 120
        mcs = MEA120_lookuptable;
    end
    
    


for j = 1:numTrials
    u = u + 1/(numTrials);
    waitbar(u,hWB)
    trialFolder = fullfile(startPath,trialFolders(j).name);
    numberOfSamples = getSamplesNumber(trialFolder);
    numberOfElectrodes = getElectrodesNumber(trialFolder);
    files = dirr(trialFolder);
    idxSlash = strfind(trialFolder,filesep);
    trialFolderName = trialFolder(idxSlash(end)+1:end);
%     [trialFolderPath, trialFolderName] = fileparts(trialFolder);
    % Load ISITh
    ISITh = importfileMB(fullfile(ISIThFolder,['ISIHistLOG_ISImaxTh_',trialFolderName,'.txt']));
    tic
    
    if ~isempty(strfind(trialFolderName,'Cyan'))
        [Result,Position] = ismember(color,[0 1 1],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Red'))
        [Result,Position] = ismember(color,[1 0 0],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Green'))
        [Result,Position] =ismember(color,[0 1 0],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Gray'))
        [Result,Position] = ismember(color,[0.8 0.8 0.8],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Blue'))
        [Result,Position] = ismember(color,[0 0 1],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Yellow'))
        [Result,Position] = ismember(color,[1 1 0],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    elseif ~isempty(strfind(trialFolderName,'Violet'))
        [Result,Position] = ismember(color,[1 0 1],'rows');
        mcmea_electrodes = string(find(Position));
        mea = mcs(ismember(str2double(mcs(:,2)),str2double(mcmea_electrodes)),:);
    else  
        if length(color) == 120
            mea = mcs;
        else
             mea = mcs;
        end
    end
    
        
    for k = 1:numberOfElectrodes
        filename = fullfile(trialFolder,files(k).name);
        elecNumber = filename(end-6:end-4);
        elec = str2double(mea(strcmp(mea(:,1),elecNumber),2));
        load(filename);
        if sum(peak_train) > 0        % if there is at least one spike
            %%%%%%%%% TO REVISE AS SOON AS THE NEW ARTEFACT DETECTION WILL
            %%%%%%%%% BE AVAILABLE
            if exist('artifact','var') && ~isempty(artifact) && ~isscalar(artifact)
                peak_train = delartcontr(peak_train,artifact,cancWinSample);    % delete artifact contribution
            end
            %%%%%%%%%
%             peakTrain = sparse(numberOfSamples,1);
%             peak_train = peak_train(1:numberOfSamples);
%             clear peak_train artifact
            if logical(str2double(ISITh(k,3)))
                ISIThThis = ISITh(strcmp(ISITh(:,1),elecNumber),:);
                [newBurstDetection_cell{elec,j}, ...
                    burstEvent_cell{elec,j}, ...
                    outburstSpikes_cell{elec,j}] = ...
                    burstDetection_oneChannelComput(peak_train, ISIThThis, userParam);
            else
                continue
            end  
        else
            continue
        end
    end
    toc
end
close(hWB)