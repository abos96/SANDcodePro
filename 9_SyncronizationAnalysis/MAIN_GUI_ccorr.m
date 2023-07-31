%   MAIN_GUI_ccorr.m
%   Script for the evaluation of the initial status of the CCorr_GUI
%   Detailed explanation goes here
%
%   Created by Michela Chiappalone (12 Febbraio 2007, 13 Febbraio 2007, 27 Febbraio 2007)
%   modified by Luca Leonardo Bologna (10 June 2007)
%       - in order to handle the 64 channels of the MED64 Panasonic system
%   modified by Martina Brofiga (23 Genuary 2020)

% --------------> MAIN VARIABLES DEFINITION
clear all 
clc

% --------------> RECALL THE CCORR GUI
[outputGuiCcorr, answerGuiCcorrHandle, chosenParameters]= GUI_ccorr();
delete (outputGuiCcorr); % Cancel the GUI
clear outputGuiCcorr

% --------------> START COMPUTATION
if strcmpi(answerGuiCcorrHandle, 'Cancel')
    clr
    return
else
    % Extract parameters from the chosenParameters cell array
    start_folder = chosenParameters{1,1}; % Input folder  
    fs           = chosenParameters{3,1}; % Sampling frequency [samples/sec]
    artwin       = chosenParameters{4,1}; % Artifact cancelaltion window [msec]
    inputdata    = chosenParameters{5,1}; % 1 = Spike Train; 2 = Burst Event
    layout       = chosenParameters{14,1}; % layout chosen
    
    
    cd(start_folder)
    cd ..
    end_folder=pwd;    
    
    if chosenParameters{11,1} % If the cross-correlation panel has been checked
        normID  = chosenParameters{13,1}; % Normalization method
        win     = chosenParameters{6,1};  % Correlation window [msec]
        bin     = chosenParameters{7,1};  % Binsize [msec]
        window  = win*fs/1000;    % [number of samples]
        binsize = bin*fs/1000;    % [number of samples]
        cancwin = artwin*fs/1000; % [number of samples]
        if inputdata==1  % Spike Train
            [exp_num]=find_expnum(start_folder, '_PeakDetectionMAT'); % To be revised
            [r_tabledir]= uigetfoldername(exp_num, bin, win, end_folder, 'msec');
            buildcorrelogram (start_folder, r_tabledir, window, binsize, cancwin, fs, normID, layout{:}) % for spike train
        else         % Burst Event
            [exp_num]=find_expnum(start_folder, '_BurstEventFiles');
            [r_tabledir]= uigetfoldernameBE(exp_num, bin, win, end_folder, 'msec');
            buildcorrelogrambe (start_folder, r_tabledir, window, binsize, cancwin, fs, normID, layout{:}) % for burst event
        end
        start_folder=r_tabledir;
    end
    
    if chosenParameters{12,1}
        compCCorrParam_checkArea(chosenParameters,start_folder,end_folder,chosenParameters{1,1});
    end
    
        


end
EndOfProcessing (start_folder, 'Successfully accomplished');