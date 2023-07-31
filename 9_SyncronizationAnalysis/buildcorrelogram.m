function []= buildcorrelogram (start_folder, corr_folder, window, binsize, cancwin, fs, normid, layout)
% by Michela Chiappalone
% modified by Luca Leonardo Bologna 21 November 2006
% buildcorrelogram.m
% Function for building the cross-correlation functions from burst_event
% INPUT:
%          start_folder= folder containing the Peak Detection files
%          corr_folder= folder containing the cross-correlation files
%          window= window of the correlation
%          binsize= bin dimension within the correlation window
%          cancwin= window for deleting the artifact
%          fs = sampling frequency
%          normid = normalization procedure
% by Michela Chiappalone (6 Maggio 2005, 16 Febbraio 2007)
% modified by Luca Leonardo Bologna (21 November 2006)
% modified by Luca Leonardo Bologna (10 June 2007) 
%   - in order to handle the 64 channels of MED64 Panasonic system

%modified by Martina Brofiga (17 December 2019)

cd (start_folder)
sourcedir= dir;      % Names of the elements in the start_folder directory - struct array
numdir= length(dir); % Number of elements in the start_folder directory
first= 3;            % First two elements '.' and '..' are not considered
for i = first:numdir                 % Cycle over the directories
    current_dir = sourcedir(i).name;  % Directory containing the PKD files - visualization
    foldername=current_dir;
    finalfolder = split(foldername,'.');
    finalfolder = split(finalfolder{1},'_');
    if strfind(start_folder,'Split')
        if strfind(start_folder,'Joint')
            finalfolder = finalfolder{end};
        else
            finalfolder = strcat(finalfolder{end-1},'_',finalfolder{end});
        end
    else
        finalfolder = finalfolder{end};
    end
    cd (current_dir);  
    current_dir=pwd;
    % --------------> COMPUTATION PHASE: CROSS_CORRELATION
    filecontent=dir;
    numfiles= length(filecontent);
    for k=first:numfiles
        if strcmp(layout(find(~isspace(layout))), 'MCSMEA120')
            r_table = cell(120,1);
            mcs = MEA120_lookuptable;
        elseif strcmp(layout(find(~isspace(layout))), 'MCSMEA60')
            r_table = cell(88,1);
            mcs = [12:17 21:28 31:38 41:48 51:58 61:68 71:78 82:87]';
        elseif strcmp(layout(find(~isspace(layout))), 'MCSMEA4Q')
            r_table = cell(88,1);
            mcs = MEA4Q_lookuptable;
        else
            r_table = cell(252,1)
            mcs = MEA256_lookuptable;
        end
        
        filenamex= filecontent(k).name;     % LOAD THE X-SPIKE TRAIN
        elx = split(filenamex,'.');
        elx = split(elx{1},'_');
        elx_str = elx{end};
        if strcmp(layout(find(~isspace(layout))), 'MCSMEA60')
            elx = double(elx_str);
        else
            elx = double(mcs(strcmp(mcs(:,1),elx_str),2));% Electrode name for x-spike train
        end
        
        load (filenamex);                   % The vector'peak_train' is loaded
        if  (~exist('artifact','var') | isempty(artifact) | artifact==0) % CHECK FOR ARTIFACT
            % DO NOTHING
        else% If I have a file of electrical stim
            for p=1:length(artifact) % Cancel the artifacts
                peak_train(artifact(p):(artifact(p)+cancwin-1))= zeros(cancwin,1);
            end
        end
        input_train=peak_train;
        clear p peak_train filenamex foldername  % Free the memory
        %%
        for j=first:numfiles
            filenamey = filecontent(j).name;    % LOAD THE Y-SPIKE TRAIN
            ely = split(filenamey,'.');
            ely = split(ely{1},'_');
            ely_str = ely{end};
            
            if strcmp(layout(find(~isspace(layout))), 'MCSMEA60')
                ely = double(ely_str);
            else
                ely = double(mcs(strcmp(mcs(:,1),ely_str),2));% Electrode name for y-spike train
            end

            load (filenamey);                   % The vector'peak_train' is loaded
            if  (~exist('artifact','var') | isempty(artifact) | artifact==0) % CHECK FOR ARTIFACT
                % DO NOTHING
            else% If I have a file of electrical stim
                for p=1:length(artifact) % Cancel the artifacts
                    peak_train(artifact(p):(artifact(p)+cancwin-1))= zeros(cancwin,1);
                end
            end
            output_train=peak_train;
            clear p peak_train filenamey  % Free the memory
            [r]= cc3 (input_train, output_train, window, binsize, fs, normid);
            r_table{ely,1} = r;
        end
        %%
        % --------------> SAVING PHASE
        cd (corr_folder)
        enddir=dir;
        numenddir=length(enddir);
        nEl = regexp(layout,'\d*','Match');
        corrdir=strcat('Correlogram_MCS',nEl{:},'_', finalfolder); % Name of the resulting directory
        if isempty(strmatch(corrdir, strvcat(enddir(1:numenddir).name),'exact')) % Check if the corrdir already exists
            mkdir (corrdir) % Make a new directory only if corrdir doesn't exist
        end
        cd (corrdir) % Go into the just created directory
        nome= strcat('r', finalfolder, '_', string(elx_str));
        save (nome, 'r_table')
        cd (current_dir);
        clear nome
    end
    cd(start_folder);
end