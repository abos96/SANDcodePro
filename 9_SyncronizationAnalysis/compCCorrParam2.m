% compCCorrParam.m
% Function that makes different analysis on the correlogram and produces
% the histograms for C(0), Peak position, Coincidence Index (CI)
% by Michela Chiappalone (9 Maggio 2005)
% modified by V. Pasquale (April 2007)
% modified by Luca Leonardo Bologna (10 June 2007)
%   - in order to handle the 64 channels of the MED64 Panasonic system
%modified by Martina Brofiga (04 Febraury 2020)

% function compCCorrParam(binpeak, binzero, binsample, fs, start_folder, end_folder)
% INPUT --> winmsec [msec]
%           binmsec [msec]
%           binpeak = number of bins on one side of maximum peak detected - total winpeak length is (2*binpeak+1)*bin
%           binzero = number of bins on one side of 0 - total winpeak length is (2*binzero+1)*bin
%           start_folder = folder containing the computed cross-correlograms



function []= compCCorrParam2(ChosenParameters)
start_folder = ChosenParameters{1,1};
end_folder = ChosenParameters{2,1};
fs = ChosenParameters{3,1};
binpeak = ChosenParameters{16,1};
binzero = ChosenParameters{17,1};
binsample = ChosenParameters{15,1};
first = 3;


% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end

% --------> INPUT FOLDERS & ARRAY DEFINITION
cd(start_folder)
corrfolders=dir;
numcorrfolders=length(dir);

numElectrodes = regexp(ChosenParameters{14,1},'\d*','Match');
numElectrodes = str2num(cell2mat(numElectrodes{:}));

if numElectrodes == 120
    mcmea_electrodes = MEA120_lookuptable;
elseif numElectrodes == 60
    numElectrodes = 88;
    mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];  
elseif numElectrodes == 4
    numElectrodes = 88;
    mcmea_electrodes = MEA4Q_lookuptable;
else
     mcmea_electrodes = MEA256_lookuptable;
end

c0 = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
CI0 = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
cPeak = zeros(numElectrodes,numElectrodes,numcorrfolders-2); 
CIpeak = zeros(numElectrodes,numElectrodes,numcorrfolders-2); 
peakLatency = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
exp_phase = 0;

% -----------> COMPUTATION
if ~rem(binsample,2)
    binsample=binsample+1;
end
binmsecNew = binsample*1000/fs;

for i = first:numcorrfolders  % Cycle over the 'Cross correlation' folders
    exp_phase = exp_phase+1;
    currentcorrfolder = corrfolders(i).name;
    cd(currentcorrfolder)
    currentcorrfolder = pwd;
    corrfiles = dir;
    numcorrfiles = length(dir);
    for j = first:numcorrfiles                     % Cycle over the 'Cross correlation' files
        filename = corrfiles(j).name;
        el = split(filename, '.');
        el = split(el{1},'_');
        el = el{end};            % Electrode name
        
        if numElectrodes == 60
            electrode = str2double(el);
        else
            electrode=double(mcmea_electrodes(strcmp(mcmea_electrodes(:,1),el),2)); % Electrode name for spike train
        end
        
        load(filename)                             % Variable r_table is loaded --> one for each electrode
        if length(r_table)==87
            r_table(end+1)=[];
        end
        
        
        % -------------> PROCESSING
        r_table{electrode,1} = zeros(size(r_table{electrode,1},1),1);                   % autocorrelation is excluded
        x = length(r_table{electrode,1});            % Length of the correlogram [bins]
        
       if numElectrodes==60 || numElectrodes == 4 
           r_mcmea = r_table(mcmea_electrodes,1);   % select only the rows of mcmea electrodes in case of 64   
       else
           r_mcmea=r_table;
       end
       
        missingElec = find(cellfun('isempty',r_mcmea));
                
        for k = 1:length(missingElec)
            r_mcmea{missingElec(k)} = zeros(x,1);
        end
        
        cc = reshape(cell2mat(r_mcmea), x, numElectrodes)';     % Reshape the cell array (cc is 60*[bins])
        center = median(1:x);                        % Center of the correlogram (index of the bin centered in 0)
        ccarea = sum(cc,2);                          % Area of the correlogram (sum over columns --> ccarea is 60*1)
        clear filename k
        
        if(~isempty(find(cc)))
            % Cpeak
            [maxv, maxi] = max(cc,[],2);                 % Peak amplitude [uVolt] and position [samples]
            %[r, c] = size(maxi);
            cPeak_temp = zeros(numElectrodes, 1);
            for k = 1:numElectrodes  % Cycle on all the electrodes
                maxes = find(cc(k,:) == maxv(k));
                if(isscalar(maxes))         % if there is only one maximum value
                    if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                        cPeak_temp(k,1) = sum(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                    end
                else                        % if there are more than one max values, it considers the one which is closest to zero
                    d = maxes - center;
                    absd = abs(d);
                    [minv, mini] = min(absd);
                    maxi(k) = center + d(mini);   
                    if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                        cPeak_temp(k,1) = sum(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                    end              
                end
            end
            cPeak(:,electrode, exp_phase) = cPeak_temp;

            % Coincidence Index around peak (CIpeak)
            warning off MATLAB:divideByZero
            CIpeak_temp = cPeak_temp./ccarea;
            CIpeak_temp(isnan(CIpeak_temp)) = 0;             % Put equal to zero the NaN elements --> the area is zero!
            CIpeak(:,electrode, exp_phase) = CIpeak_temp;      

            % Peak latency
            peakLatency_temp = (maxi-center)*binmsecNew;
            peakLatency(:,electrode, exp_phase) = peakLatency_temp;  % Peak latency from zero [msec]

            % C(0)
            c0_temp = zeros(numElectrodes, 1);
            cc_temp = cc(:,(center-binzero):(center+binzero));      % cross correlogram close to 0
            c0_temp = sum(cc_temp,2);
            c0(:,electrode,exp_phase)= c0_temp;        
            
            % Coincidence Index around zero (CIzero)
            warning off MATLAB:divideByZero
            CI0_temp = c0_temp./ccarea;
            CI0_temp(isnan(CI0_temp)) = 0;              % Put equal to zero the NaN elements --> the area is zero!
            CI0(:,electrode, exp_phase)= CI0_temp;        
            
            cd(currentcorrfolder)
            clear cc
        else                        % if cc has no elements ~= 0 --> the electrode is off...
            cPeak(:,electrode, exp_phase) = zeros(numElectrodes, 1);
            CIpeak(:,electrode, exp_phase) = zeros(numElectrodes, 1);
            peakLatency(:,electrode, exp_phase) = NaN*ones(numElectrodes, 1);    % put the peak latencies equal to NaN 
            c0(:,electrode, exp_phase) = zeros(numElectrodes, 1);
            CI0(:,electrode, exp_phase) = zeros(numElectrodes, 1);
        end
     end % of FOR on j 
      
     cd(start_folder)    
end


cd(end_folder{:});

[r,c,z] = size(CI0);
for i = 1:z
    mkdir(corrfolders(i+2).name);
    cd(corrfolders(i+2).name)
    CI0tmp = CI0(:,:,i);
    CIpeaktmp = CIpeak(:,:,i);
    C0tmp = c0(:,:,i);
    Cpeaktmp = cPeak(:,:,i);
    save('CI0','CI0tmp');
    save('CIpeak','CIpeaktmp');
    save('C0','C0tmp');
    save('Cpeak','Cpeaktmp');
    
    % Statistics
    CI0tmp = reshape(CI0tmp,r*r,1);
    statistics = [mean(CI0tmp(CI0tmp~=0)), std(CI0tmp(CI0tmp~=0)), median(CI0tmp(CI0tmp~=0)), stderror(mean(CI0tmp(CI0tmp~=0)),CI0tmp(CI0tmp~=0))];
    save('Statistics','statistics');         %std(CI0tmp~=0)
    cd ..
end





