%% Main tocheck Spike detection Result
% plot and save aligned spike traces 
% clustering spike sorting
%% MAGANE FOLDER find Peak detection folder
[start_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
elseif strfind(start_folder,'Split')
    check = 1;
end

%% Create Saving folder
cd(start_folder)
cd .. 
expfolder = pwd;
SpikeSorting_folder = strcat(expfolder,'\SpikeSorting');

if ~exist(strcat(SpikeSorting_folder,'\SpikeWaveforms'), 'dir')
    % If the folder doesn't exist, create it
    mkdir(SpikeSorting_folder);
    disp(['Folder "', SpikeSorting_folder, '" created successfully.']);
else
    disp(['Folder "', SpikeSorting_folder, '" already exists.']);
end

%% Load spike train and convert to Spike times

% Get a list of all spike files in the folder
Spike_files = dir(fullfile(start_folder, '*.mat'));
cd(start_folder)
well = load(Spike_files(3).name);
channels = well.channels;
fs = well.parameters.fs;
well_spikeTrain = well.spikeTrain;
well_spikeTimes = findIndicesOfOnes(well_spikeTrain, well.parameters.fs); % second
clear well
% Get a list of all trace files in the folder
cd ..
cd('RawMatFiles\')
Rawmat_folder = pwd;
% Get a list of all files in the folder
RawFiles = dir(fullfile(Rawmat_folder, '*.mat'));
raw_well = load(RawFiles(3).name);
%% filt raw traces
    lowpass = 100;
    highpass = 2000;
    wn = [lowpass highpass] / (fs / 2);
    filterOrder = 3;
    [b, a] = butter(filterOrder, wn);

   
%% start computational phase 
for electrodeIndex = 1 : length(channels) 

    % Define Spike times - SPike Train - trace
    SpikeTimes = well_spikeTimes{electrodeIndex};
    SpikeTrain = well_spikeTrain(:,electrodeIndex);
    trace = raw_well.dat(:,electrodeIndex);
    filtered_trace = filtfilt(b, a, trace);
    channels =  raw_well.channels;
    el = channels(electrodeIndex);
    mfr = sum(SpikeTrain)./(length(SpikeTrain)./fs);
    if mfr > 1
            %% Get aligned spike times and waveforms
            multiple_templates = 0;
            spike_window = 50;  %10 frames = 1 ms %ms
            remove_artifact=0;
            waveform_width = 50; %ms
            multi_template_method = 'amplitudeAndWidth';
            [Times, spikeWaveforms] = alignPeaks(SpikeTimes,filtered_trace, spike_window, remove_artifact,waveform_width);
%             for i = 1:length(Times)
%                 plot(spikeWaveforms(i,:))
%                 hold on
%             end
            %% Dimension Check    
            if isempty(SpikeTimes)
                fprintf('No spikes found for this electrode, getTemplate will fail');
            end 
                
            %  If fewer spikes than specified - use the maximum number possible
            nSpikes = sum(SpikeTrain);
            if  numel(SpikeTimes) < nSpikes
                nSpikes = sum(SpikeTrain);
                disp(['Not enough spikes detected with specified threshold, using ', num2str(nSpikes),'instead']);
            end
            
                    
           %% Extract features for clustering
                
                if strcmp(multi_template_method, 'PCA')
                    % extract mulitple templates by first performing PCA, then 
                    % doing clustering and finding the optimal number of clusters
            
                    % do PCA all detected spikes 
                    [coeff, score, latent, tsquared, explained, mu] = pca(spikeWaveforms');
                    num_PC = 2;
                    reduced_X = coeff(:, 1:num_PC);
            
                elseif strcmp(multi_template_method, 'amplitudeAndWidth')
                    
                    % spike_amplitude = min(spikeWaveforms, [], 2);
                    num_spikes = size(spikeWaveforms, 1);
                    peak_x = 25; % hard-coded for now, due to alignPeaks
                    spike_amplitude = spikeWaveforms(:, peak_x);
                    spike_widths = zeros(num_spikes, 1);
                    
                    for spike_idx = 1:size(spikeWaveforms)
                        spike_wave = spikeWaveforms(spike_idx, :);
                        
                        half_peak_y = spike_amplitude(spike_idx) / 2;
                        cross_half_peak_x = find(spike_wave > half_peak_y);
                        
                        % Find latest time of crossing half_peak_y before peak 
                        % And find earliest time of crossing half_peak_y after peak
                        if cross_half_peak_x(cross_half_peak_x < peak_x)
                            half_peak_x1 = max(cross_half_peak_x(cross_half_peak_x < peak_x));
                        else
                            half_peak_x1=0;
                        end
                        half_peak_x2 = min(cross_half_peak_x(cross_half_peak_x > peak_x));
                        spike_widths(spike_idx) = (half_peak_x2 - half_peak_x1) ./ fs;
                    end 
                    
                    reduced_X = [spike_amplitude spike_widths];
                
                elseif strcmp(multi_template_method, 'amplitudeAndWidthAndSymmetry')
                    
                    % spike_amplitude = min(spikeWaveforms, [], 2);
                    num_spikes = size(spikeWaveforms, 1);
                    peak_x = 25; % hard-coded for now, due to alignPeaks
                    spike_amplitude = spikeWaveforms(:, peak_x);
                    spike_widths = zeros(num_spikes, 1);
                    spike_symmetry = zeros(num_spikes, 1);
                    
                    for spike_idx = 1:size(spikeWaveforms)
                        spike_wave = spikeWaveforms(spike_idx, :);
                        
                        half_peak_y = spike_amplitude(spike_idx) / 2;
                        cross_half_peak_x = find(spike_wave > half_peak_y);
                        
                        % Find latest time of crossing half_peak_y before peak 
                        % And find earliest time of crossing half_peak_y after peak
                        half_peak_x1 = max(cross_half_peak_x(cross_half_peak_x < peak_x));
                        half_peak_x2 = min(cross_half_peak_x(cross_half_peak_x > peak_x));
                        spike_widths(spike_idx) = (half_peak_x2 - half_peak_x1) / fs;
                        
                        spike_first_half = spike_wave(1:peak_x-1);
                        spike_second_half_flipped = fliplr(spike_wave(peak_x+1:end-2));
                        % higher value means less symmetric, 0 means perfectly
                        % symmetric (no difference between first half and second half
                        % reversed
                        spike_symmetry(spike_idx) = sum(abs(spike_first_half - spike_second_half_flipped));
                        
                    end 
                    
                    reduced_X = [spike_amplitude spike_widths spike_symmetry];
                    
                    
                else
                    
                    fprintf('Warning: invalid multi_template method specified! \n');
                    
                end 
                
                %% Do clustering   
%                 minClustNum = 1;
%                 clusterer = HDBSCAN(reduced_X); 
%                 clusterer.minClustNum = minClustNum;
%                 clusterer.minclustsize = length(reduced_X)/10;
%                 clusterer.fit_model(); 			% trains a cluster hierarchy
%                 clusterer.get_best_clusters(); 	% finds the optimal "flat" clustering scheme
%                 clusterer.get_membership();		% assigns cluster labels to the points in X
%                 
%                 
%                 clustering_labels = clusterer.labels;
%                 unique_clusters = unique(clustering_labels);
%                 num_cluster = length(unique_clusters);
%             
%                 fprintf('Doing clustering of spikes in reduced space \n')
%                 fprintf( 'Number of points: %i \n',clusterer.nPoints );
%                 fprintf( 'Number of dimensions: %i \n',clusterer.nDims );

                [clustering_labels, C] = kmeans(reduced_X,2);
                unique_clusters = unique(clustering_labels);
                num_cluster = length(unique_clusters);
                num_spike_time_frames = size(spikeWaveforms, 2);
                aveWaveform = zeros(num_spike_time_frames, num_cluster);
            
                % Make average waveform for each cluster 
                for cluster_label_idx = 1:num_cluster
                    cluster_label = unique_clusters(cluster_label_idx);
                    label_idx = find(clustering_labels == cluster_label);
                    cluster_ave_waveform = median(spikeWaveforms(label_idx, :));
                    aveWaveform(:, cluster_label_idx) = cluster_ave_waveform;
                end 
                
                
                %% Plot to look at spike features / PCA components
                % generate color
                % Number of different colors (n)
                n = num_cluster;
                % Create a matrix to store the RGB values
                colormapValues = linspace(0, 0.5, n)';
                colorsRGB = winter(n);

                if num_cluster < 5
                    figure;
                    for cluster_label_idx = 1:num_cluster
                        cluster_label = unique_clusters(cluster_label_idx);
                        label_idx = find(clustering_labels == cluster_label);
                        subplot(1, 2, 1)
                        scatter(reduced_X(label_idx, 1), reduced_X(label_idx, 2),50,colorsRGB(cluster_label_idx,:),'filled');
                        hold on
                        scatter(C(:, 1), C(:, 2), 100, 'k', 'Marker', 'x');
                        xlabel('Feature 1')
                        ylabel('Feature 2')
                       
                    end 
                    title_txt = sprintf('Clusters: %.f', num_cluster); 
                    title(title_txt);
            
                    subplot(1, 2, 2)
                    for cluster_label_idx = 1:num_cluster
                        color = colorsRGB(cluster_label_idx,:);
                        plot(aveWaveform(:, cluster_label_idx), 'linewidth', 1,'Color', color)
                        hold on
                    end 
                    xlabel('Time bins')
                    ylabel('Voltage')
                    set(gcf, 'color', 'w')
                    set(gcf, 'PaperPosition', [0 0 20 10]);
                    %legend('Data Series 1', 'Data Series 2', 'Data Series 3');
                    %[~, recording_name, ~] = fileparts(channelInfo.fileName);
                    fig_name = strcat([RawFiles(3).name, '_channel_' num2str(el)]);
                    print(fullfile(SpikeSorting_folder, fig_name), '-dpng', '-r300');
                    close(gcf)
                end 
                
    end
end
%% Extract averaged waveforms 
            
                
                aveWaveform = median(spikeWaveforms,1);
                figure;
               
                hold on
                for i = 1:size(spikeWaveforms, 1)
                    plot(spikeWaveforms(i,:), 'Color', [0.7, 0.7, 0.7]); % RGBA: [R, G, B, Alpha]
                end
                
                % Calculate and plot the mean of the traces
                plot(aveWaveform, 'k', 'LineWidth', 2);
                
                % Add labels and title
                xlabel('X');
                ylabel('Y');
                title('Traces with Mean Overlay');
                
                % Show the plot
                grid on;
                hold off;
                

