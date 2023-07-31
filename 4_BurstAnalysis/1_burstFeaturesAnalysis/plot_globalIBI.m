% plot_globalIBI.m
% by M. Chiappalone (26 Maggio 2006)
% modified by Luca Leonardo Bologna 04 June 2007
%   - modified in order to handle 64 channels
clr
[FileName,PathName] = uigetfile('*.mat','Select a Burst Detection file');
cd (PathName)
cd ..
cd ..
start_folder = pwd;
d = dir;
control = 0;
for k = 3:length(d)
    if ~isempty(strfind(d(k).name,'ColorElectrode'))
        cd(d(k).name);
        electrodes = dir;
        
        if length(electrodes)~=3
            errordlg('Generate the ColorElectrodes file - End of Session', 'Error');
        return
        else
        load(electrodes(3).name);
        end
        control = 1;
    elseif ~isempty(strfind(d(k).name,'PeakDetection'))& isempty(strfind(d(k).name,'Split'))& isempty(strfind(d(k).name,'Joint'))
        cd(start_folder);
        cd(d(k).name);
        check = dir;
        cd(check(3).name);
        cc = dir;
        cc = cc(3).name;
        cc = split(cc,'.');
        cc = split(cc(1),'_');
        cc = cc(end);
        chars =  regexp(cc,'([A-Z]+)','match');
    end
end
if control == 0
    errordlg('Generate the ColorElectrodes file - End of Session', 'Error');
    return
end

cd (PathName)
               
if ~isempty(strfind(FileName,'Cyan'))
    [Result,Position] = ismember(color,[0 1 1],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Red'))
    [Result,Position] = ismember(color,[1 0 0],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Green'))
    [Result,Position] =ismember(color,[0 1 0],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Gray'))
    [Result,Position] = ismember(color,[0.8 0.8 0.8],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Blue'))
    [Result,Position] = ismember(color,[0 0 1],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Yellow'))
    [Result,Position] = ismember(color,[1 1 0],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
elseif ~isempty(strfind(FileName,'Violet'))
    [Result,Position] = ismember(color,[1 0 1],'rows');
    mcmea_electrodes = find(Position);
    mcs = mcmea_electrodes;
else  
  if length(color) == 120
        mcmea_electrodes = MEA120_lookuptable;
        mcs = mcmea_electrodes(:,1);
    elseif length(color) == 87 & isempty(chars)
        mcs = string([12:17,21:28,31:38, 41:48,51:58,61:68,71:78,82:87]);
        mcmea_electrodes = mcs;
    elseif length(color) == 87
        mcmea_electrodes = MEA4Q_lookuptable;
        mcs = mcmea_electrodes(:,1);
    else
         mcmea_electrodes = MEA256_lookuptable;
         mcs = mcmea_electrodes(:,1);
    end
end
           

s=strfind(PathName,'\');
BDFolder=PathName(1:s(end-1)-1);
cd ..
cd ..
expFolderPath=pwd;
NetworkIBI = createResultFolderNoOverwrite(expFolderPath, BDFolder, 'NetworkIBI');
if FileName == 0
    errordlg('Selection Failed - End of Session', 'Error');
    return
end      
if exist(fullfile(PathName, FileName))
    % --------------- USER information
    single=0;
    [el, binsec, max_x, ylim, fs, cancelFlag]= uigetIBIinfo(single,mcs);

    if cancelFlag
        errordlg('Selection Failed - End of Session', 'Error');
        return
    end
    % --------------- PLOT phase
    load (fullfile(PathName, FileName)) % a cell array with the burst detection is loaded
% % % %     if length(burst_detection_cell)==87 %added for compatibility with previous versions
% % % %         burst_detection_cell(end+1)=[];
% % % %     end

    IBIarray=[];
    for i=1:length(mcmea_electrodes)
        if isnumeric(mcmea_electrodes)
            el = mcmea_electrodes(i);
        else
            if isempty(chars)
                el = str2num(str2mat(mcs(i)));
            else
                el = str2num(str2mat(mcmea_electrodes(i)));
            end
        end
        
        if (el<=length(burst_detection_cell) && ~isempty( burst_detection_cell{el,1}))

            temp=burst_detection_cell{el,1};

            [r,c]=size(temp);
            if r>=3
                IBIarray=[IBIarray; burst_detection_cell{el,1}(1:end-2,5)];
            end
        end
    end

    figure();
    [bins,n_norm,max_y] = f_single_IBIh(IBIarray, fs, max_x, binsec);
    % y=plot(bins, n_norm , 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);
    
    y=bar(bins, n_norm, 1, 'r' );

    axis ([0 max_x 0 ylim])
    title ('Inter Burst Interval - IBI Histogram');
    xlabel('Inter Burst Interval [sec]');
    ylabel('Probability per bin');
    cd (NetworkIBI)
    nome=strcat('NetworkIBI_',FileName(1:end-4));
    grid on 
    box
    saveas(y,nome,'jpg')
    saveas(y,nome,'fig')
    close;
    EndOfProcessing (PathName, 'Successfully accomplished');
end

