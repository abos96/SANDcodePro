% compCCorrParam.m
% Function that makes different analysis on the correlogram and produces
% the histograms for C(0), Peak position, Coincidence Index (CI)
% by Michela Chiappalone (9 Maggio 2005)
% modified by V. Pasquale (April 2007)
% modified by Luca Leonardo Bologna (10 June 2007)
%   - in order to handle the 64 channels of the MED64 Panasonic system

% function compCCorrParam(binpeak, binzero, binsample, fs, start_folder, end_folder)
% INPUT --> winmsec [msec]
%           binmsec [msec]
%           binpeak = number of bins on one side of maximum peak detected - total winpeak length is (2*binpeak+1)*bin
%           binzero = number of bins on one side of 0 - total winpeak length is (2*binzero+1)*bin
%           start_folder = folder containing the computed cross-correlograms

% % -----------> VARIABLE DEFINITION
% mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];

function []= compCCorrParam_checkArea(ChosenParameters,start_folder,end_folder,folder)
if strcmp(folder,start_folder)
start_folder = ChosenParameters{1,1};
else
end

fs = ChosenParameters{3,1};
binpeak_ms = ChosenParameters{16,1};
binzero_ms = ChosenParameters{17,1};
AreaPeak = ChosenParameters{18,1}./100;
 if ChosenParameters{11,1} 
      binsample_ms = ChosenParameters{7,1};
 else name_split = split(start_folder,'\');
      name_split = split(name_split{end},'_');
      name_split = split(name_split{end},'-');
      binsample_ms=str2double(name_split{1});
 end
binpeak  = round(binpeak_ms/binsample_ms);    % [number of samples]
binzero = round(binzero_ms/binsample_ms);    % [number of samples]
binsample = round(binsample_ms*fs/1000); % [number of samples]
first=3;

% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end
%% create new saving_folder ( non indispensabile )
 save_dir=strcat( start_folder,'_Analysis'); % Name of the resulting directory
 cd(end_folder)
 d=dir;
        if isempty(strmatch(save_dir, d(:),'exact')) % Check if the corrdir already exists
            mkdir (save_dir) % Make a new directory only if corrdir doesn't exist
        end

%% check type file: mea 60,120,240,4q
cd(start_folder)
corrfolders=dir;
numcorrfolders=length(dir);
exphase= numcorrfolders-first+1;
    currentcorrfolder=corrfolders(3).name;
    cd(currentcorrfolder)
    currentcorrfolder=pwd;
    corrfiles=dir;
    numcorrfiles=length(dir)-2;

if numcorrfiles == 120
    mcmea_electrodes = MEA120_lookuptable;
      % useful to allocate memory
    numElectrodes = 120;
elseif numcorrfiles == 64 & isempty(chars)
    mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];
    numElectrodes = 64;
    
elseif numcorrfiles == 60 & ~isempty(chars)
    mcmea_electrodes = MEA4Q_lookuptable;
    % numElectrodes=?
else
     mcmea_electrodes = MEA256_lookuptable;
     %numElectrodes=?
end

%%

c0 = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
CI0 = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
cPeak = zeros(numElectrodes,numElectrodes,numcorrfolders-2); 
CIpeak = zeros(numElectrodes,numElectrodes,numcorrfolders-2); 
peakLatency = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
Area_arond_peak = zeros(numElectrodes,numElectrodes,numcorrfolders-2);
 
exp_phase = 0;

% -----------> COMPUTATION
if ~rem(binsample,2)
    binsample=binsample+1;
end
cd(start_folder)
binmsecNew = binsample*1000/fs; % convert bin in [ms]
for i = first:numcorrfolders  % Cycle over the 'Cross correlation' folders
    exp_phase = exp_phase+1;
    currentcorrfolder = corrfolders(i).name;
    cd(currentcorrfolder)
    currentcorrfolder = pwd;
    corrfiles = dir;
    numcorrfiles = length(dir);
    for j = first:numcorrfiles                     % Cycle over the 'Cross correlation' files
        filename = corrfiles(j).name;
        el = filename(end-6:end-4);                % Electrode name
        electrode=double(mcmea_electrodes(strcmp(mcmea_electrodes(:,1),el),2)); % Electrode name for spike train
        % electrode = str2double(el);                % Electrode name in DOUBLE
        load(filename)                             % Variable r_table is loaded --> one for each electrode
        if length(r_table)==87
            r_table(end+1)=[];
        end
        % -------------> PROCESSING
        r_table{electrode,1} = zeros(size(r_table{electrode,1},1),1);                   % autocorrelation is excluded
        x = length(r_table{electrode,1});            % Length of the correlogram [bins]
       if numElectrodes==64 
           r_mcmea = r_table(mcmea_electrodes,1);   % select only the rows of mcmea electrodes (11,13,...88) in case of 64   
       elseif numElectrodes==120
           r_mcmea=r_table;
       end
        missingElec = find(cellfun('isempty',r_mcmea));
        for k = 1:length(missingElec)
            r_mcmea{missingElec(k)} = zeros(x,1);
            c0{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            CI0{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            cPeak{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            CIpeak{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            peakLatency{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            Area_arond_peak{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
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
             Area_arond_peak_temp=zeros(numElectrodes, 1);
            for k = 1:numElectrodes  % Cycle on all the electrodes
                    maxes = find(cc(k,:) == maxv(k));
                  if(isscalar(maxes)) % if there is only one maximum value
                        if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                        cPeak_temp(k,1) = trapz(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                        %Area_arond_peak_temp(k,1) = trapz(cc(k,maxi(k)-binpeak:maxi(k)+binpeak)-mean(cc(k,:)))./trapz(cc(k,:)-mean(cc(k,:)));% compute %area under peak
                        Area_arond_peak_temp(k,1) = trapz(cc(k,maxi(k)-binpeak:maxi(k)+binpeak))./trapz(cc(k,:));% compute %area under peak

                        end  
                  else if  maxv(k)~=0 
                        d = maxes - center;
                        absd = abs(d);
                        [minv, mini] = min(absd);
                         maxi(k) = center + d(mini);   
                            if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                               cPeak_temp(k,1) = sum(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                               %Area_arond_peak_temp(k,1) = trapz(cc(k,maxi(k)-binpeak:maxi(k)+binpeak)-mean(cc(k,:)))./trapz(cc(k,:)-mean(cc(k,:)));% compute %area under peak
                                Area_arond_peak_temp(k,1) = trapz(cc(k,maxi(k)-binpeak:maxi(k)+binpeak))./trapz(cc(k,:));% compute %area under peak
                   
                            end
                       else
                       cPeak_temp(k,1) = 0;
                       Area_arond_peak_temp(k,1) = 0;
                      end
                  end      
           end
            cPeak(:,electrode, exp_phase) = cPeak_temp;
            Area_arond_peak(:,electrode, exp_phase)= Area_arond_peak_temp;
            
            % Coincidence Index around peak (CIpeak)
            warning off MATLAB:divideByZero
            CIpeak_temp = cPeak_temp./ccarea;
            CIpeak_temp(isnan(CIpeak_temp)) = 0;             % Put equal to zero the NaN elements --> the area is zero!
            CIpeak(:,electrode, exp_phase) = CIpeak_temp;      

            % Peak latency
            peakLatency_temp = (maxi-center)*binmsecNew;
            if sum(isnan(peakLatency_temp)) > 0
                display('test');
            else
            peakLatency(:,electrode, exp_phase) = peakLatency_temp;  % Peak latency from zero [msec]
            end
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
 % of FOR on i
end

%% compute mean,std,media,stderror

for i=1:exphase
    
     % firing up zeros elements
     c0tmp = c0(:,:,i);
     temp_c0=c0tmp(find(Area_arond_peak(:,:,i)>AreaPeak & c0tmp~=0));
    [Mean_c0(i) Std_c0(i) Median_c0(i) StdError_c0(i)]=compMSMS(temp_c0);
     % firing up zeros elements
    CI0tmp = CI0(:,:,i);
    temp_CI0=CI0tmp(find(Area_arond_peak(:,:,i)>AreaPeak & CI0tmp~=0));
    [Mean_CI0(i) Std_CI0(i) Median_CI0(i) StdError_CI0(i)]=compMSMS(temp_CI0);
     % firing up zeros elements
    cPeaktmp = cPeak(:,:,i);
    temp_cPeak=cPeaktmp(find(Area_arond_peak(:,:,i)>AreaPeak & cPeaktmp~=0));
    [Mean_cPeak(i) Std_cPeak(i) Median_cPeak(i) StdError_cPeak(i)]=compMSMS(temp_cPeak);
     % firing up zeros elements
    CIpeaktmp = CIpeak(:,:,i);
    temp_CIpeak=CIpeaktmp(find(Area_arond_peak(:,:,i)>AreaPeak & CIpeaktmp~=0));
    [Mean_CIpeak(i) Std_CIpeak(i) Median_CIpeak(i) StdError_CIpeak(i)]=compMSMS(temp_CIpeak);
    % firing up zeros elements
    peakLatencytmp = peakLatency(:,:,i);
    temp_peakLatency=peakLatencytmp(find(Area_arond_peak(:,:,i)>AreaPeak & ~isnan(peakLatencytmp)));
    [Mean_peakLatency(i) Std_peakLatency(i) Median_peakLatency(i) StdError_peakLatency(i)]=compMSMS(temp_peakLatency);
       
    Mean_full=[Mean_c0(:)  Mean_CI0(:)  Mean_cPeak(:) Mean_CIpeak(:)  Mean_peakLatency(:)]';
    Std_full=[Std_c0(:)  Std_CI0(:)  Std_cPeak(:) Std_CIpeak(:)  Std_peakLatency(:)]';
    Median_full=[Median_c0(:)  Median_CI0(:)  Median_cPeak(:) Median_CIpeak(:)  Median_peakLatency(:)]';
    StdError_full=[StdError_c0(:)  StdError_CI0(:)  StdError_cPeak(:) StdError_CIpeak(:)  StdError_peakLatency(:)]';
    
end

%% compute parameters into sub-coltures
cd(end_folder)
IND = strfind(start_folder,'\');
start_dir= start_folder(IND(end)+1:end);
ind=strfind(start_dir,'_');
find_color_folder=strcat(strcat(start_dir(1:ind(1)-1)),'_ColorElectrode');

if strmatch(string(find_color_folder),string(struct2cell(dir)),'exact')% Check if the corrdir already exists
       cd(find_color_folder)
       load('ColorElectrode.mat');
       
        %% check color
    cellar= cell(1,exphase);   
    color_str=convertColor2(color, mcmea_electrodes);
 
  color_used=[];
   standard_color=[ "Red" "Cyan" "Gray" "Yellow" "Blue" "Green" "Violet" ];
   for i=1:7
       if sum(color_str(:,1)==standard_color(i))>0;
           color_used = [color_used  standard_color(i)];
       end
   end
  num_color = length(color_used);
  %%
       
       Mean_c0=zeros(exphase,num_color);
       Std_c0=zeros(exphase,num_color);
       Median_c0=zeros(exphase,num_color);
       StdError_c0=zeros(exphase,num_color);
       
        Mean_CI0=zeros(exphase,num_color);
       Std_CI0=zeros(exphase,num_color);
       Median_CI0=zeros(exphase,num_color);
       StdError_CI0=zeros(exphase,num_color);
       
        Mean_cPeak=zeros(exphase,num_color);
       Std_cPeak=zeros(exphase,num_color);
       Median_cPeak=zeros(exphase,num_color);
       StdError_cPeak=zeros(exphase,num_color);
       
        Mean_CIpeak=zeros(exphase,num_color);
       Std_CIpeak=zeros(exphase,num_color);
       Median_CIpeak=zeros(exphase,num_color);
       StdError_CIpeak=zeros(exphase,num_color);
       
        Mean_peakLatency=zeros(exphase,num_color);
       Std_peakLatency=zeros(exphase,num_color);
       Median_peakLatency=zeros(exphase,num_color);
       StdError_peakLatency=zeros(exphase,num_color);
       
   
 
    
    %% compute MSMS
    boxCI=[];
for i=1:exphase
 
       for j=1:num_color %cycle over colors RGB
           
       idx_color = color_str(:,1)==color_used(j) ;   
       idx = double(mcmea_electrodes(idx_color==1,2));    
       
       mat_c0=c0(idx,idx,i);
       mat_area=Area_arond_peak(idx,idx,i);
       temp_c0 = mat_c0(mat_c0>0 & mat_area>AreaPeak);
       [Mean_c0(i,j) Std_c0(i,j) Median_c0(i,j) StdError_c0(i,j)]=compMSMS(temp_c0);
    
       mat_CI0=CI0(idx,idx,i);
       temp_CI0 = mat_CI0(mat_CI0>0 & mat_area>AreaPeak);
       [Mean_CI0(i,j) Std_CI0(i,j) Median_CI0(i,j) StdError_CI0(i,j)]=compMSMS(temp_CI0);
      
       mat_cPeak=cPeak(idx,idx,i);
       temp_cPeak = mat_cPeak(mat_cPeak>0 & mat_area>AreaPeak);
       [Mean_cPeak(i,j) Std_cPeak(i,j) Median_cPeak(i,j) StdError_cPeak(i,j)]=compMSMS(temp_cPeak);
     
       mat_CIpeak=CIpeak(idx,idx,i);
       temp_CIpeak = mat_CIpeak(mat_CIpeak>0 & mat_area>AreaPeak);
      [Mean_CIpeak(i,j) Std_CIpeak(i,j) Median_CIpeak(i,j) StdError_CIpeak(i,j)]=compMSMS(temp_CIpeak);
      
       
       mat_peakLatency=peakLatency(idx,idx,i);
       temp_peakLatency = mat_peakLatency(~isnan(mat_peakLatency) & mat_area>AreaPeak);
       [Mean_peakLatency(i,j) Std_peakLatency(i,j) Median_peakLatency(i,j) StdError_peakLatency(i,j)]=compMSMS(temp_peakLatency);
       
       end
   
    tab_c0=table (Mean_c0(i,:)',Std_c0(i,:)',Median_c0(i,:)',StdError_c0(i,:)','VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',color_used);
    tab_c0_cell=mat2cell(tab_c0,num_color,4);
    
    tab_CI0=table (Mean_CI0(i,:)',Std_CI0(i,:)',Median_CI0(i,:)',StdError_CI0(i,:)','VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',color_used);
    tab_CI0_cell=mat2cell(tab_CI0,num_color,4);
    
    tab_cPeak=table (Mean_cPeak(i,:)',Std_cPeak(i,:)',Median_cPeak(i,:)',StdError_cPeak(i,:)','VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',color_used);
    tab_cPeak_cell=mat2cell(tab_cPeak,num_color,4);
    
    tab_CIpeak=table (Mean_CIpeak(i,:)',Std_CIpeak(i,:)',Median_CIpeak(i,:)',StdError_CIpeak(i,:)','VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',color_used);
    tab_CIpeak_cell=mat2cell(tab_CIpeak,num_color,4);
    
    figure
    plot(Mean_CIpeak(i,:)','*r')
    hold on 
    plot(Mean_CIpeak(i,:)'+Std_CIpeak(i,:)','*b')
    hold on
    plot(Mean_CIpeak(i,:)'-Std_CIpeak(i,:)','*b')
    
    tab_peakLatency=table (Mean_peakLatency(i,:)',Std_peakLatency(i,:)',Median_peakLatency(i,:)',StdError_peakLatency(i,:)','VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',color_used);
    tab_peakLatency_cell=mat2cell(tab_peakLatency,num_color,4);
   
    
 tab_finale=table(tab_c0_cell, tab_CI0_cell, tab_cPeak_cell,tab_CIpeak_cell,tab_peakLatency_cell,...
     'VariableNames',{'c0' 'CI0' 'cPeak' 'CIpeak' 'peakLatency'});
   
 cellar(i)=mat2cell(tab_finale,1,5);
 
 clear tab_finale  tab_peakLatency_cell  tab_peakLatency tab_CIpeak_cell tab_CIpeak
 clear  tab_cPeak_cell tab_cPeak  tab_CI0_cell  tab_CI0  tab_c0_cell  tab_c0
end
end
 
%%
saveCCorrParam(c0, CI0, cPeak, CIpeak, peakLatency,...
    Mean_full,Std_full,Median_full,StdError_full,binmsecNew,cellar, start_folder, end_folder)

end



