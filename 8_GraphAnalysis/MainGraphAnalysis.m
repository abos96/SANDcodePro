% Mainscript to extract basic connectivity features from the adjMatrices
% Namely, Node Degree, SWI, Number of Hub,PC,BC,LE

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
%%
for i = 1: length(files)
    %% Loading AdjMatricx
    cd(start_folder)
    AD_file = load(files(i).name);
    % ADj do not contain negative or nan val
    adjM = AD_file.adjMci;
    adjM(adjM<0) = 0;
    adjM(isnan(adjM)) = 0;
    
    %% Loading and plot Raster
    cd ..\SpikeDetection\
    newfilename = replaceWord(files(i).name,'conn','spike');
    spike_file = load(newfilename);
    rasterPlot(newfilename,spike_file.spikeTrain, connFolder,spike_file.parameters.fs);

    %% Compute Node Degree
    cd(connFolder)
    % edge threshold for adjM
    edge_thresh = 0.0001;
    exclude_zeros = 0;
    [ND,MEW] = findNodeDegEdgeWeight(adjM, edge_thresh, exclude_zeros);
    % Node strength
    NS = strengths_und(adjM)';  
    coords = getCoord('MSC60');

    %saving
    channels = spike_file.channels;
    savename = replaceWord(files(i).name,'conn','NodeDegree');
    save(savename,'ND','MEW','NS','channels','coords');
    
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

    %saving
    savename = replaceWord(files(i).name,'conn','SmallWorldIndex');
    save(savename,'SW','SWw','CC','PL');

    %% Local Efficency
    
    %   For ease of interpretation of the local efficiency it may be
    %   advantageous to rescale all weights to lie between 0 and 1.
    
    isbinary = all(ismember(adjM(:), [0, 1]));
    
    if isbinary 
        adjM_nrm = weight_conversion(adjM, 'normalize');
        Eloc = efficiency_bin(adjM_nrm,2);
    else 
        adjM_nrm = weight_conversion(adjM, 'normalize');
        Eloc = efficiency_wei(adjM_nrm,2);
    end
    
    % mean local efficiency across nodes
    ElocMean = mean(Eloc);

    %saving
    savename = replaceWord(files(i).name,'conn','LocalEfficency');
    save(savename,'adjM_nrm','Eloc','ElocMean','channels','coords');

    %% Betweeness Centrality
    
    %   Note: Betweenness centrality may be normalised to the range [0,1] as
    %   BC/[(N-1)(N-2)], where N is the number of nodes in the network.
    if isbinary
        BC = betweenness_bin(adjM);
    else 
        smallFactor = 0.01; % prevent division by zero
        pathLengthNetwork = 1 ./ (adjM + smallFactor);   
        BC = betweenness_wei(pathLengthNetwork);
    
    end
    BC = BC/((length(adjM)-1)*(length(adjM)-2));
    
    BC95thpercentile = prctile(BC, 95);
    BCmeantop5 = mean(BC(BC >= BC95thpercentile));

    %saving
    savename = replaceWord(files(i).name,'conn','BetweenessCentrality');
    save(savename,'BC','BC95thpercentile','BCmeantop5','channels','coords');

    %% Partecipation Coefficient

    % density
    [Dens, ~, ~] = density_und(adjM);

    % Modularity
    try
        [Ci,Q,~] = mod_consensus_cluster_iterate(adjM,0.4,50);
    catch
        Ci = 0;
        Q = 0;
    end
    nMod = max(Ci);

    PC = participation_coef(adjM,Ci,0);
    [PCnorm,~,~,~] = participation_coef_norm(adjM,Ci);

    % within module degree z-score
    Z = module_degree_zscore(adjM,Ci,0);
    
    % percentage of within-module z-score greater and less than zero
    percentZscoreGreaterThanZero = sum(Z > 0) / length(Z) * 100;
    percentZscoreLessThanZero = sum(Z < 0) / length(Z) * 100;
    
    % mean participation coefficient 
    PCmean = mean(PCnorm);
    PC90thpercentile = prctile(PCnorm, 90);
    PC10thpercentile = prctile(PCnorm, 10);
    PCmeanTop10 = mean(PCnorm(PCnorm >= PC90thpercentile));
    PCmeanBottom10 = mean(PCnorm(PCnorm <= PC10thpercentile));

    %saving
    savename = replaceWord(files(i).name,'conn','PartecipationCoefficient');
    save(savename,'PC','PCnorm','PCmean','PC90thpercentile', 'PC10thpercentile', ...
        'PCmeanTop10','PCmeanBottom10','channels','coords','Ci','Q');

    %% Compute Number of Hubs
    % active nodes
    aNtemp = sum(adjM,1);
    iN = find(aNtemp==0);
    aNtemp(aNtemp==0) = [];  % ??? why remove the zeros?
    aN = length(aNtemp);

    sortND = sort(ND,'descend');
    sortND = sortND(1:round(aN/10));
    hubNDfind = ismember(ND, sortND);
    [hubND, ~] = find(hubNDfind==1);

    %saving
    savename = replaceWord(files(i).name,'conn','Hubs');
    save(savename,'hubND','channels','coords');
end

% ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');