function rasterPlot(File,spikeMatrix,figFolder,fs)
% creata a raster plot of the recording
% Parameters 
% -----------
% File : char 
% spikeMatrix : matrix 
% Params : structure 
% spikeFreqMax : float 
% figFolder : path to directory 
%     absolute path to folder to save the raster plot

%% Downsample spike matrix

% duration of the recording
duration_s = length(spikeMatrix)/fs; % in seconds

spikeMatrix = full(spikeMatrix);

% downsample matrix to 1 frame per second
dur = floor(duration_s);
downSpikeMatrix = downSampleSum(spikeMatrix(1:(dur.*fs),:), dur);

%% plot the raster

% p = [100 100 1500 800];
% set(0, 'DefaultFigurePosition', p)
 
F1= figure;
 
h = imagesc(downSpikeMatrix');
        
xticks((duration_s)/(duration_s/60):(duration_s)/(duration_s/60):duration_s)
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'})

c = parula;
c = c(1:round(length(c)*.85),:);
colormap(c);

aesthetics
ylabel('Electrode')
xlabel('Time (min)')
cb = colorbar;
ylabel(cb, 'Firing Rate (Hz)')
cb.TickDirection = 'out';
set(gca,'TickDir','out');
cb.Location = 'Eastoutside';
cb.Box = 'off';
set(gca, 'FontSize', 14)
ylimit_cbar = prctile(downSpikeMatrix(:),99,'all');
% ylimit_cbar = (max(downSpikeMatrix(:)));
ylimit_cbar = max([ylimit_cbar, 1]);  % ensures it is minimum of 1

caxis([0,ylimit_cbar])
yticks([1, 10:10:60])
title({strcat(replaceWord(strrep(File, '_', ' '),'spike.mat',' '),' raster scaled to recording')});
ax = gca;
ax.TitleFontSizeMultiplier = 1;


%% save the figure
figName = replaceWord(File,'spike.mat','raster.png');
figPath = fullfile(figFolder, figName);
saveas(gcf, figPath, 'png');


close(F1);

  
end
