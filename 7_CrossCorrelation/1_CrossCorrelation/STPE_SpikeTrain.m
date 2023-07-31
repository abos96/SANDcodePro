%% Genete the correct spike train
%clear all
%STPE_SpikeTrain
clear all
clc
format long g

peak_dir = uigetdir(pwd,'Select the Spike Detection Folder');
if strcmp(num2str(peak_dir),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

cd(peak_dir);
d = dir;
nEl = length(d)-2;

% START PROCESSING
cd(peakfolder)                       % start_folder in the MAIN program
peakfolderdir=dir;                   % struct containing the peak-det folders   
NumPeakFiles=length(peakfolderdir); % number of experimental well
peakfile = dir;

mcs = [12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87];
n = 60;


% if nEl == 120
%     mcmea_electrodes = MEA120_lookuptable;
% elseif nEl == 60 & isempty(chars)
%     mcmea_electrodes = string([12:18,21:28,31:38, 41:48,51:58,61:68,71:78,82:87]);
% elseif nEl == 60 & ~isempty(chars)
%     mcmea_electrodes = MEA4Q_lookuptable;
% elseif  nEl == 256
%      mcmea_electrodes = MEA256_lookuptable;
% end

 
%% Create the peak train with only the time [ms] when the spike occurs
peak_train_new=cell(120,1);
for j = 1:length(pk)
    tmp = pk{j};
    index = find(tmp~=0);
    time = index/SaRa*1000;
    peak_train_new{j,1} = time;
end


peak_train_new{j+1,1} = 1;
peak_train_new{j+2,1} = [nEl rectime_ms];
 

data.asdf = peak_train_new;
clear peak_train_new pk
filter=0;
%[ConnectivityMatrix, Delaymatrix_ms, CrossCorrelogram]=TSPE(data.asdf);
  kh=SaRa/1000;
     [ConnectivityMatrix, Delaymatrix_ms, CrossCorrelogram]=TSPE(data.asdf,25,[3, 4, 5, 6, 7, 8]*kh,0,[2, 3, 4, 5, 6]*kh,0);
cd ..
cd ..
path = dir;
% neglect self-connections
name_split = split(path(3).name,'_');
name = name_split{1};
mkdir(strcat(char(name),'_CrossCorrelation'));
cd(strcat(char(name),'_CrossCorrelation'));

ConnectivityMatrix(1==(diag(ones(1,data.NumEL_rec))))=0;

save('ConnectivityMatrix', 'ConnectivityMatrix');
save('DelayMatrix_ms', 'Delaymatrix_ms');
save('CrossCorrelogram', 'CrossCorrelogram');

if nEl == 60 & isempty(chars)
    type = 1;
else
    type = 0;
end
%FilteredConnectivityMatrix = SpatialFilter(nEl, ConnectivityMatrix, Delaymatrix_ms, type);
  kh=SaRa/1000;
     [ConnectivityMatrix, Delaymatrix_ms, CrossCorrelogram]=TSPE(data.asdf,25,[3, 4, 5, 6, 7, 8]*kh,0,[2, 3, 4, 5, 6]*kh,0);

h  = figure;
subplot(1,2,1)
imagesc(ConnectivityMatrix);
xlabel('Electrodes')
ylabel('Electrodes')
title('Estimated connectivity')
k = colorbar;
k.Position = [0.48,0.105,0.024,0.816];
subplot(1,2,2) 
imagesc(FilteredConnectivityMatrix)
xlabel('Electrodes')
ylabel('Electrodes')
title('Filtered Connectivity'); 
set(gcf, 'Position', [50 50 1200 500])
c = colorbar;
c.Position =  [0.92,0.105,0.024,0.816];
savefig(h,'SpatialConnectivity');    

save('FilteredConnectivityMatrix', 'FilteredConnectivityMatrix');
EndOfProcessing (peak_dir, 'Successfully accomplished');


        