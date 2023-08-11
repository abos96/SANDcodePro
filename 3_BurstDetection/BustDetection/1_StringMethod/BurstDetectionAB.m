function BurstDetectionAB (peakfolder, end_folder1, end_folder2, end_folder3, nspikes, ISImax, min_mbr, cwin, fs, check)
% Function for producing the Burst Detection files
% INPUT
%
% OUTPUT
%
% by Michela Chiappalone (17 Marzo 2006, 12 Gennaio 2007)
% modified by Luca Leonardo Bologna (10 June 2007) in order to handle med
% meas with 64 channels


% DEFINE LOCAL VARIABLES
first=3;
ISImaxsample=ISImax/1000*fs; % ISImax [sample]
cancwinsample= cwin/1000*fs; % cwin [sample]

% START PROCESSING
cd(peakfolder)                       % start_folder in the MAIN program
peakfolderdir=dir;                   % struct containing the peak-det folders   
NumPeakFiles=length(peakfolderdir); % number of experimental well
peakfile = dir;

mcs = [12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87];
n = 60;

cd(peakfolder) 

    
 progressbar('Burst Detection')
 for i = first:NumPeakFiles % FOR cycle on the single directory files
        progressbar(i/NumPeakFiles)
        burst_detection_cell = cell(n,1);  % cell array containing the burst features for each channel
        burst_event_cell     = cell (n,1); % cell array containing the burst_event train for each channel
        outburst_spikes_cell = cell(n,1);  % cell array containing the random spikes features for each channel


        filename = peakfile(i).name;    % current PKD file
        load(filename);
        fprintf('\n Detecting Burst in %s ...', filename);
        for kk = 1 : length(channels) % FOR cycle on the single channels
        peak_train = spikeTrain(:,kk);

        if sum(peak_train)>0
            timestamp=find(peak_train); % Vector with dimension [nx1]
            allisi  =[-sign(diff(timestamp)-ISImaxsample)];
            allisi(find(allisi==0))=1;  % If the difference is exactly ISImax, I have to accept the two spikes as part of the burst
            edgeup  =find(diff(allisi)>1)+1;  % Beginning of burst
            edgedown=find(diff(allisi)<-1)+1; % End of burst
            
            if ((length(edgedown)>=2) & (length(edgeup)>=2))
                barray_init=[];
                barray_end=[];
                
                if (edgedown(1)<edgeup(1))                    
                    barray_init=[timestamp(1), timestamp(edgedown(1)), edgedown(1), ...
                        (timestamp(edgedown(1))-timestamp(1))/fs];
                    edgedown=edgedown(2:end);
                end
                
                if(edgeup(end)>edgedown(end))
                    barray_end= [timestamp(edgeup(end)), timestamp(end), length(timestamp)-edgeup(end)+1, ...
                         (timestamp(end)-timestamp(edgeup(end)))/fs];
                    edgeup=edgeup(1:end-1);
                end
                
                barray= [timestamp(edgeup), timestamp(edgedown), (edgedown-edgeup+1), ...
                    (timestamp(edgedown)-timestamp(edgeup))/fs];      % [init end nspikes duration-sec]
                barray= [barray_init;barray;barray_end];
                burst_detection=barray(find(barray(:,3)>=nspikes),:); % Real burst statistics

                [r,c]=size(burst_detection);
                acq_time=fix(length(peak_train)/fs); % Acquisition time  [sec]
                mbr=r/(acq_time/60);                 % Mean Bursting Rate [bpm]
                clear  edgeup edgedown
                
                % THRESHOLD EVALUATION
                if (mbr>=min_mbr) % Save only if the criterion is met

                    % OUTSIDE BURST Parameters
                    %%%%%%%%%%%%%%%%%%%%%% !!!!!WARNING!!!!! %%%%%%%%%%%%%%%%%%%%%%
                    tempburst= [(burst_detection(:,1)-1), (burst_detection(:,2)+1)];
                    % There is no check here: the +1 and -1 could be
                    % dangerous when indexing the peak_train vector
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    out_burst=reshape(tempburst',[],1);
                    out_burst=[1;out_burst; length(peak_train)];
                    out_burst= reshape(out_burst, 2, [])';
                    [rlines, clines]=size(out_burst);                    
                    outburst_cell= cell(rlines,7);
                    
                    for k=1:rlines
                        outb_period=(out_burst(k,2)-out_burst(k,1))/fs; % duration [sec] of the non-burst period
                        outbspikes= find(peak_train(out_burst(k,1):out_burst(k,2)));                        
                        
                        n_outbspikes=length(outbspikes);
                        mfob=n_outbspikes/outb_period;       % Mean frequency in the non-burst period
                        isi_outbspikes= diff(outbspikes)/fs; % ISI [sec] - for the spikes outside the bursts
                        f_outbspikes =1./isi_outbspikes;     % frequency between two consecutive spikes outside the bursts
                        
                        outburst_cell{k,1}= out_burst(k,1);  % Init of the non-burst period
                        outburst_cell{k,2}= out_burst(k,2);  % End of the non-burst period
                        outburst_cell{k,3}= n_outbspikes;    % Number of spikes in the non-burst period
                        outburst_cell{k,4}= mfob;            % Mean Frequency in the non-burst period
                        outburst_cell{k,5}= outbspikes;      % Position of the spikes in the non-burst period
                        outburst_cell{k,6}= isi_outbspikes;  % ISI of spikes in the non-burst period
                        outburst_cell{k,7}= f_outbspikes;    % Frequency of the spikes in the non-burst period
                    end                                        
                    ave_mfob= mean(cell2mat(outburst_cell(:,4))); % Avearge frequency outside the burst - v1: all elements
                    % ave_mfob= mean(nonzeros(cell2mat(outburst_cell(:,4)))); % Average frequency outside the burst - v2: only non zeros elements
                    
                    % INSIDE BURST Parameters
                    binit= burst_detection(:,1); % Burst init [samples]
                    burst_event =sparse(binit, ones(length(binit),1), peak_train(binit)); % Burst event
                    bp= [diff(binit)/fs; 0];     % Burst Period [sec] - start-to-start
                    ibi= [((burst_detection(2:end,1)- burst_detection(1:end-1,2))/fs); 0]; % Inter Burst Interval, IBI [sec] - end-to-start                    
                    lastrow=[acq_time, length(find(peak_train)), r, sum(burst_detection(:,3)), mbr, ave_mfob];
                    
                    burst_detection=[burst_detection, ibi, bp; lastrow];
                    % burst_detection=[init, end, nspikes, duration, ibi, bp;
                    %  acquisition time, total spikes, total bursts, total burst spikes, mbr, average mfob]
                    
                    %deal with nan in electrode 15
                    if isnan(channels(kk))
                        el = 15;
                    else
                        el = channels(kk); 
                    end
                    
                    burst_detection_cell{el,1}= burst_detection; % Update the cell array
                    burst_event_cell{el,1}= burst_event;         % Update the cell array
                    outburst_spikes_cell{el,1}= outburst_cell;   % Update the cell array
                    
                    
                    clear rlines clines out_burst tempburst
                end
                end
            end
            
            clear peak_train artifact allisi acq_time mbr barray timestamp
            clear r c ibi binit burst_detection burst_event edgedown edgeup lastrow

    end
    
    % SAVE ALL FILES

    expname_split = split(filename,'_');
    tojoin = expname_split(1:4);
    expname = strjoin(tojoin,'_');

    cd(end_folder1) % Burst array
    nome=strcat('burst_detection_', expname);
    save(nome, 'burst_detection_cell');
    
    cd(end_folder2) % Burst event
    nome=strcat('burst_event_', expname);
    save(nome, 'burst_event_cell');
    
    cd(end_folder3) % Outside Burst Spikes
    nome=strcat('outburst_spikes', expname);
    save(nome, 'outburst_spikes_cell');
    
    cd(peakfolder)
end
