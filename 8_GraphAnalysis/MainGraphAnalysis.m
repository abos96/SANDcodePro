% Mainscript to extract basic connectivity features from the adjMatrices
% Namely, Node Degree, SWI, Number of Hub

%% settings 
netMetToCal = {'ND', 'EW', 'NS', 'aN', 'Dens', 'Ci', 'Q', 'nMod', 'Eglob', ...,
        'CC', 'PL' 'SW','SWw' 'Eloc', 'BC', 'PC' , 'PC_raw', 'Cmcblty', 'Z', ...
        'NE', 'effRank', 'num_nnmf_components', 'nComponentsRelNS', ...
        'aveControl', 'modalControl'};


%% MAGANE FOLDER find Peak detection folder
[start_folder]= selectfolder('Select the \ADmatrices folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
elseif strfind(start_folder,'Split')
    check = 1;
end

% Get a list of all files in the folder
files = dir(fullfile(start_folder, '*.mat'));

% Create Saving folder
cd(start_folder)
cd .. 
expfolder = pwd;
connFolder = strcat(expfolder,'\ConnectivityAnalysis');

if ~exist(strcat(connFolder,'\ConnectivityAnalysis'), 'dir')
    % If the folder doesn't exist, create it
    mkdir(connFolder);
    disp(['Folder "', connFolder, '" created successfully.']);
else
    disp(['Folder "', connFolder, '" already exists.']);
end


for i = 1: length(files)
    %% Loading AdjMatricx
    cd(start_folder)
    AD_file = load(files(i).name);
    % ADj do not contain negative or nan val
    adjM = AD_file.adjMci;
    adjM(adjM<0) = 0;
    adjM(isnan(adjM)) = 0;
    
    %% Loading Raster
    cd ..\SpikeDetection\
    newfilename = replaceWord(files(i).name);
    spike_file = load(newfilename);

    %% Compute Node Degree
    % edge threshold for adjM
    edge_thresh = 0.0001;
    exclude_zeros = 0;
    [ND,MEW] = findNodeDegEdgeWeight(adjM, edge_thresh, exclude_zeros);
    % Node strength
    NS = strengths_und(adjM)';  

    %% Compute SWI
    minNumberOfNodesToCalNetMet = 10;
    if length(adjM)> minNumberOfNodesToCalNetMet

        ITER = 1000;
        Z = pdist(adjM);
        D = squareform(Z);
        % TODO: rename L to Lattice to avoid confusion with path length
        [LatticeNetwork,Rrp,ind_rp,eff,met] = latmio_und_v2(adjM,ITER,D,'SW');
    
        % Random rewiring model (d)
        ITER = 1000;
        [R, ~,met2] = randmio_und_v2(adjM, ITER,'SW');             
        [SW, SWw, CC, PL] = small_worldness_RL_wu(adjM,R,LatticeNetwork);
    end
    %% Compute Number of Hubs

end

%%
[NetMet] = ExtractNetMet(adjM, 25, spike_file.spikeTrain,netMetToCal,connFolder);